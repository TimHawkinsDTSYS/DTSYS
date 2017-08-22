      /TITLE Utility, Internet Weather (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves the current weather for a postal code.
      *
      *  Notes   :  Uses Scott Klement's HTTP and Expat Parser routines;
      *              at www.scottklement.com/oss.html
      *             Originally this code was found on Scott's website at:
      *                 www.scottklement.com/archives/+
      *                 ftpapi/200807/msg00032.html
      *              and modified to fetch weather information.
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  04/23/09  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /copy qcpysrc,HspecSrv
     H bnddir('LIBHTTP/HTTPAPI')
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8205S
      /include libhttp/qrpglesrc,httpapi_h
      *
      *  Prototype to parse the XML data.
      *
     D RtvCurWthIncomming...
     D                 PR
     D   UserData                      *   value
     D   Depth                       10i 0 value
     D   namespace                 1024a   varying const
     D   Name                      1024a   varying Const
     D   Path                     24576a   varying Const
     D   Value                    65535a   varying Const
     D   Attrs                         *   dim(32767)
     D                                     const options(*VarSize)
      *
      *  Data structure to return information.
      *
     D W               ds                  likeds(t_RtvCurWth) inz
      * **********************************************************
      * RtvCurWth() -- Retrieve current weather.
      * **********************************************************
     P RtvCurWth       B                   export
      *
     D RtvCurWth       PI                  like(t_RtvCurWth)
     D  i_pscd                        5    const
      *
     D RetCode         s                   like(StdInt)
     D Url             s            256    varying
     D UrlRedirect     s            256    varying
     D FileName        s             45    varying
      * ---------------------------------------------------------
      /Free

       // debug (ifs subdir tmp/httpapi_debug.txt if on)
       Http_Debug(*off);

       // URL to get weather from www.Weather.com
       // -- replace &par=partner ID, &key=license key
       //    with the value received when registering
       URL = 'http://xoap.weather.com/weather/local/' +
              %trim(i_pscd) +
             '?cc=*' +
             '&dayf=0' +
             '&link=xoap' +
             '&prod=xoap' +
             '&par=1112448002' +
             '&key=d5c396dd1eeaeddc';

       // create a tempory file in subdirectory tmp in the ifs
       FileName = Http_TempFile() + '.xml';

       // get the weather
       RetCode = Http_Url_Get(Url : FileName );

       // If errors, crash the program
       // -- crash disabled; we don't want to kill jobs for this.
       If RetCode <> 1;
       // Http_Crash();
          w.XMLerr = *on;
          w.XMLpth = 'HTTP crashed';
          return w;
       EndIf;

       // Parse the XML from the temp file
       http_xmlns(*on);

       RetCode = Http_Parse_XML_Stmf( FileName
                                      : HTTP_XML_CALC
                                      : *null
                                      : %paddr(RtvCurWthIncomming)
                                      : *null );
       if RetCode < *zero;
          w.XMLerr = *on;
          w.XMLpth = 'Parse failed';
          return w;
       EndIf;

       // delete the work file
       UnLink(FileName);

       Return w;

      /end-Free
      *
     P RtvCurWth       E
      * ---------------------------------------------------------
      * Parse XML feed.
      * ---------------------------------------------------------
     P RtvCurWthIncomming...
     P                 B

     D RtvCurWthIncomming...
     D                 PI
     D   UserData                      *   value
     D   Depth                       10i 0 value
     D   NameSpace                 1024a   varying const
     D   Name                      1024a   varying const
     D   Path                     24576a   varying const
     D   Value                    65535a   varying const
     D   Attrs                         *   dim(32767)
     D                                     const options(*VarSize)

     D wk005a          s              5    varying
     D wk010a          s             10    varying

     D lenTemperature  c                   %size(w.Temperature)
     D decTemperature  c                   %decpos(w.Temperature)
     D lenFeelsLike    c                   %size(w.FeelsLike)
     D decFeelsLike    c                   %decpos(w.FeelsLike)
     D lenHumidity     c                   %size(w.Humidity)
     D decHumidity     c                   %decpos(w.Humidity)
     D lenVisability   c                   %size(w.Visability)
     D decVisability   c                   %decpos(w.Visability)
     D lenDewpoint     c                   %size(w.Dewpoint)
     D decDewpoint     c                   %decpos(w.Dewpoint)
     D lenPressureBar  c                   %size(w.PressureBar)
     D decPressureBar  c                   %decpos(w.PressureBar)
     D lenWindSpeed    c                   %size(w.WindSpeed)
     D decWindSpeed    c                   %decpos(w.WindSpeed)
     D lenWindGust     c                   %size(w.WindGust)
     D decWindGust     c                   %decpos(w.WindGust)
     D lenWindDir      c                   %size(w.WindDir)
     D decWindDir      c                   %decpos(w.WindDir)
     D lenUVnumber     c                   %size(w.UVnumber)
     D decUVnumber     c                   %decpos(w.UVnumber)

      /free

       // Extract value once identified.

       select;
       when path = '/weather/cc';
          select;
          when name     = 'lsup';

            wk010a = %subst(value:1:%scan(' ':value)-1);
            if %len(%trim(wk010a)) = 7;
               wk010a = '0' + wk010a;
            endif;
            monitor;
              w.LstUpdDte = %dec(%date(wk010a:*MDY));
            on-error;
              w.XMLerr    = *on;
            endmon;

            wk005a = %subst(value:%scan(' ':value)+1);
            if %len(%trim(wk005a)) = 4;
               wk005a = '0' + wk005a;
            endif;
            wk010a = wk005a + ':00';
            monitor;
              w.LstUpdTim = %dec(%time(wk010a:*HMS));
            on-error;
              w.XMLerr    = *on;
            endmon;

            if %scan('PM':value) > *zero;
               w.LstUpdTim += 120000;
            endif;

            if %scan('M':value) > *zero;
               w.LstUpdZon = %subst(value:%scan('M':value)+2);
            endif;

          when name      = 'obst';
            if %scan(',':value) > *zero;
               w.ObsCity = %subst(value:1:%scan(',':value)-1);
               w.ObsStcd = %trim(%subst(value:%scan(',':value)+1));
            else;
               w.ObsCity = value;
               w.ObsStcd = *blanks;
            endif;

          when name       = 'tmp';
            w.Temperature = %dec(value:lenTemperature:decTemperature);

          when name       = 'flik';
            w.FeelsLike   = %dec(value:lenFeelsLike:decFeelsLike);

          when name       = 't';
            w.Conditions  = value;

          when name       = 'hmid'  and
               value     <> 'N/A';
            monitor;
              w.Humidity  = %dec(value:lenHumidity:decHumidity);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name       = 'vis'         and
              (value      = 'unlimited'   or
               value      = 'Unlimited');
             w.Visability = 10.00;

          when name       = 'vis'   and
               value     <> 'N/A';
            monitor;
              w.Visability = %dec(value:lenVisability:decVisability);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name       = 'dewp'  and
               value     <> 'N/A';
            monitor;
              w.Dewpoint  = %dec(value:lenDewpoint:decDewpoint);
            on-error;
              w.XMLerr    = *on;
            endmon;
          endsl;


       when path = '/weather/cc/bar';
          select;
          when name       = 'r'    and
               value     <> 'N/A';
            monitor;
              w.PressureBar = %dec(value:lenPressureBar:decPressureBar);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name        = 'd';
            w.PressureDesc = value;
          endsl;


       when path = '/weather/cc/wind';
          select;
          when name       = 's'    and
               value     <> 'N/A'  and
               value     <> 'calm';
            monitor;
              w.WindSpeed = %dec(value:lenWindSpeed:decWindSpeed);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name       = 'gust'  and
               value     <> 'N/A';
            monitor;
              w.WindGust  = %dec(value:lenWindGust:decWindGust);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name       = 'd'     and
               value     <> 'N/A';
            monitor;
              w.WindDir   = %dec(value:lenWindDir:decWindDir);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name       = 't';
            w.WindCompass = value;
          endsl;


       when path = '/weather/cc/uv';
          select;
          when name       = 'i'     and
               value     <> 'N/A';
            monitor;
              w.UVnumber  = %dec(value:lenUVnumber:decUVnumber);
            on-error;
              w.XMLerr    = *on;
            endmon;

          when name       = 't';
            w.UVdesc      = value;
          endsl;


       when path = '/weather/cc/moon';
          select;
          when name       = 't';
            w.MoonDesc    = value;
          endsl;
       endsl;

       // Extract error source and pass it back.

       if w.XMLerr;
          w.XMLpth = path;
          w.XMLnam = name;
          w.XMLval = value;
       endif;

      /end-free

     P RtvCurWthIncomming...
     P                 E
