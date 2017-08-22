      /TITLE Utility, HTML/XML (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8081S
      * *********************************************************
      * rmvWhiteSpace() -- Remove white space.
      * -- Returns a string that removes strings of whitespace
      *    to a single blank.
      * *********************************************************
     P rmvWhiteSpace   b                   export

     D rmvWhiteSpace   pi         65535a   varying
     D   input                    65535a   varying const

     D output          s                   like(input) inz('')

     D whitespaceChr   C                   x'40'
     D*whitespaceChr   C                   x'15050D2540'
      * x'15'=newline  x'05'=tab     x'0D'=carriage-return
      * x'25'=linefeed x'40'=blank

     D c               s                   like(StdChr)
     D i               s                   like(StdInt)
     D inWhitespace    s                   like(StdInd)

      /free

       // --------------------------------------------
       // Escape if nothing passed.

       if %len(%trim(input)) = *zero;
          return *blanks;
       endif;

       // copy all non-whitespace characters to the return value
       for i = 1 to %len(%trim(input));
          c = %subst(input : i : 1);

          if %scan(c : whitespaceChr) > *zero;

             // If this is a new set of whitespace, add one blank
             if inWhitespace = *off;
                inWhitespace = *on;
                output += ' ';
             endif;
          else;
             // Not handling whitespace now.  Add character to output
             inWhitespace = *off;
             output += c;
          endif;
       endfor;

       return output;

      /end-free

     P rmvWhiteSpace   e
      * *********************************************************
      * rmvNonTypeable() -- Remove non-typeable characters.
      * -- Protects routines from invalid cut/past characters.
      * *********************************************************
     P rmvNonTypeable  b                   export

     D rmvNonTypeable  pi         65535a   varying
     D   input                    65535a   varying const

     D output          s          65535a   varying
     D WKhex           s                   like(StdNam)
     D PVhex           s                   like(StdNam)
     D strpos          s                   like(StdInt)
     D endpos          s                   like(StdInt)
     D poslen          s                   like(StdInt)
     D len             s                   like(StdInt)
     D x               s                   like(StdInt)
      *
     D XLATEfr         c                   'âäàáãåéêëèíîïìôöòóõûüùúýÿ+
     D                                      ÂÄÀÁÃÅÉÊËÈÍÎÏÌÔÖÒÓÕÛÜÙÚÝµ'
      *
     D XLATEto         c                   'aaaaaaeeeeiiiiooooouuuuyy+
     D                                      AAAAAAEEEEIIIIOOOOOUUUUYu'

      /free

       // --------------------------------------------
       // Escape if nothing passed.

       if %len(%trim(input)) = *zero;
          return *blanks;
       endif;

       // --------------------------------------------
       // Move constant input to the output area.

       output = input;

       // --------------------------------------------
       // Replace hexidecimal references like "&#xE9;"

       strpos = 1;

       dow strpos > *zero;
         strpos = %scan('&#x':%subst(output: 1:%len(output)):strpos);

         if strpos > *zero;
           endpos = %scan(';':%subst(output: 1:%len(output)):strpos);
           poslen = endpos - strpos + 1;
         endif;

         if  strpos <= *zero     or
             endpos <= *zero     or
             endpos <= strpos    or
             endpos >  %len(output);
             leave;
         endif;

         if  poslen <> 5        and
             poslen <> 6;
             leave;
         endif;

         if  strpos > *zero;
           WKhex = %subst(output:strpos:poslen);

           select;
             when WKhex = '&#x9;' or
                  WKhex = '&#xA;' or
                  WKhex = '&#xB;' or
                  WKhex = '&#xC;' or
                  WKhex = '&#xD;';
               output = RplStg(output: WKhex: ' ');

             when WKhex = '&#xa0;';
               output = RplStg(output: WKhex: ' ');
             when WKhex = '&#xa9;';
               output = RplStg(output: WKhex: '©');
             when WKhex = '&#xab;';
               output = RplStg(output: WKhex: '«');
             when WKhex = '&#xae;';
               output = RplStg(output: WKhex: 'î');

             when WKhex = '&#xb0;';
               output = RplStg(output: WKhex: '°');
             when WKhex = '&#xb2;';
               output = RplStg(output: WKhex: '²');
             when WKhex = '&#xb4;';
               output = RplStg(output: WKhex: '´');
             when WKhex = '&#xb7;';
               output = RplStg(output: WKhex: '·');
             when WKhex = '&#xba;';
               output = RplStg(output: WKhex: 'º');
             when WKhex = '&#xbb;';
               output = RplStg(output: WKhex: '»');
             when WKhex = '&#xbc;';
               output = RplStg(output: WKhex: '¼');
             when WKhex = '&#xbd;';
               output = RplStg(output: WKhex: '½');

             when WKhex = '&#xc1;';
               output = RplStg(output: WKhex: 'Á');
             when WKhex = '&#xc2;';
               output = RplStg(output: WKhex: 'Â');
             when WKhex = '&#xc3;';
               output = RplStg(output: WKhex: 'Ã');
             when WKhex = '&#xc0;';
               output = RplStg(output: WKhex: 'À');
             when WKhex = '&#xc9;';
               output = RplStg(output: WKhex: 'É');

             when WKhex = '&#xd1;';
               output = RplStg(output: WKhex: 'Ñ');
             when WKhex = '&#xda;';
               output = RplStg(output: WKhex: 'Ú');

             when WKhex = '&#xe0;';
               output = RplStg(output: WKhex: 'à');
             when WKhex = '&#xe1;';
               output = RplStg(output: WKhex: 'á');
             when WKhex = '&#xe7;';
               output = RplStg(output: WKhex: 'ç');
             when WKhex = '&#xe8;';
               output = RplStg(output: WKhex: 'è');
             when WKhex = '&#xe9;';
               output = RplStg(output: WKhex: 'é');
             when WKhex = '&#xeb;';
               output = RplStg(output: WKhex: 'ë');
             when WKhex = '&#xed;';
               output = RplStg(output: WKhex: 'í');
             when WKhex = '&#xef;';
               output = RplStg(output: WKhex: 'ï');

             when WKhex = '&#xf1;';
               output = RplStg(output: WKhex: 'ñ');
             when WKhex = '&#xf3;';
               output = RplStg(output: WKhex: 'ó');
             when WKhex = '&#xf4;';
               output = RplStg(output: WKhex: 'ô');
             when WKhex = '&#xfa;';
               output = RplStg(output: WKhex: 'ú');
             when WKhex = '&#xfc;';
               output = RplStg(output: WKhex: 'ü');
             other;

             if WKhex <> PVhex;
                PVhex  = WKhex;
               dsply ('Hex reference: ' + WKhex);
             endif;
           endsl;
         endif;

         if strpos > *zero;
            strpos = endpos;
         endif;
       enddo;

       // ----------------------------
       // Replace accented characters.

       output = %xlate(XLATEfr: XLATEto: output);

       // -------------------------------
       // Remove non-typeable characters.

       for x = 1 to %len(output);
         if  %subst(output: x: 1)  = ' '    or
            (%subst(output: x: 1) >= 'a'    and
             %subst(output: x: 1) <= 'z')   or
            (%subst(output: x: 1) >= 'A'    and
             %subst(output: x: 1) <= 'Z')   or
            (%subst(output: x: 1) >= '0'    and
             %subst(output: x: 1) <= '9')   or
             %subst(output: x: 1)  = x'25'  or
             %subst(output: x: 1)  = '~'    or
             %subst(output: x: 1)  = '`'    or
             %subst(output: x: 1)  = '!'    or
             %subst(output: x: 1)  = '@'    or
             %subst(output: x: 1)  = '#'    or
             %subst(output: x: 1)  = '$'    or
             %subst(output: x: 1)  = '%'    or
             %subst(output: x: 1)  = '¢'    or
             %subst(output: x: 1)  = '&'    or
             %subst(output: x: 1)  = '*'    or
             %subst(output: x: 1)  = '('    or
             %subst(output: x: 1)  = ')'    or
             %subst(output: x: 1)  = '-'    or
             %subst(output: x: 1)  = '_'    or
             %subst(output: x: 1)  = '+'    or
             %subst(output: x: 1)  = '='    or
             %subst(output: x: 1)  = '['    or
             %subst(output: x: 1)  = ']'    or
             %subst(output: x: 1)  = '¦'    or
             %subst(output: x: 1)  = '|'    or
             %subst(output: x: 1)  = '{'    or
             %subst(output: x: 1)  = '}'    or
             %subst(output: x: 1)  = '\'    or
             %subst(output: x: 1)  = '\'    or
             %subst(output: x: 1)  = ':'    or
             %subst(output: x: 1)  = ';'    or
             %subst(output: x: 1)  = ''''   or
             %subst(output: x: 1)  = '"'    or
             %subst(output: x: 1)  = '<'    or
             %subst(output: x: 1)  = '>'    or
             %subst(output: x: 1)  = '?'    or
             %subst(output: x: 1)  = ','    or
             %subst(output: x: 1)  = '.'    or
             %subst(output: x: 1)  = '/'    or
             %subst(output: x: 1)  = '<';
         else;
           %subst(output: x: 1) = *blanks;
         endif;
       endfor;

       return output;

      /end-free

     P rmvNonTypeable  e
      ***********************************************************
      * RplXMLsplact() -- Replace XML special to actual.
      ***********************************************************
     P RplXMLsplact    B                   Export
      *
     D RplXMLsplact    PI         65535a   varying
     D  InString                  65535a   varying value
     D  InPrefix                           like(StdChr)
     D                                     const options(*omit:*nopass)
      *
     D strpos          s                   like(StdInt) inz
     D P_Prefix        s                   like(StdChr) inz
      /free

       // --------------------------------------------
       // Escape if nothing passed.

       if %len(%trim(InString)) = *zero;
          return *blanks;
       endif;

       // -------------------------------------------------------
       // Test for 2 parms.

š1b€   if %parms  >= 2;
         P_Prefix = InPrefix;
š1e€   else;
         P_Prefix = '&';
š1e€   endif;

       // -------------------------------------------------------
       // ampersand.

       InString = RplStg(InString:P_Prefix + 'amp;':'&');

       // apostrophy.

       InString = RplStg(InString:P_Prefix + 'apos;':'''');

       // quote.

       InString = RplStg(InString:P_Prefix + 'quot;':'"');

       // less than.

       InString = RplStg(InString:P_Prefix + 'lt;':'<');

       // greater than.

       InString = RplStg(InString:P_Prefix + 'gt;':'>');

š1b€   return InString;

      /end-free

     P RplXMLsplact    E
      ***********************************************************
      * RplXMLactspl() -- Replace XML actual to special.
      ***********************************************************
     P RplXMLactspl    B                   Export
      *
     D RplXMLactspl    PI         65535a   varying
     D  InString                  65535a   varying value
     D  InPrefix                           like(StdChr)
     D                                     const options(*omit:*nopass)
      *
     D strpos          s                   like(StdInt) inz
     D P_Prefix        s                   like(StdChr) inz
      /free

       // --------------------------------------------
       // Escape if nothing passed.

       if %len(%trim(InString)) = *zero;
          return *blanks;
       endif;

       // -------------------------------------------------------
       // Test for 2 parms.

š1b€   if %parms  >= 2;
         P_Prefix = InPrefix;
š1e€   else;
         P_Prefix = '&';
š1e€   endif;

       // -------------------------------------------------------
       // ampersand.

       InString = RplStg(InString:'&':P_Prefix + 'amp;');

       // apostrophy.

       InString = RplStg(InString:'''':P_Prefix + 'apos;');

       // quote.

       InString = RplStg(InString:'"':P_Prefix + 'quot;');

       // less than.

       InString = RplStg(InString:'<':P_Prefix + 'lt;');

       // greater than.

       InString = RplStg(InString:'>':P_Prefix + 'gt;');

š1b€   return InString;

      /end-free
      *
     P RplXMLactspl    E
      ***********************************************************
      * RplXMLsplpfx() -- Replace XML special character prefix.
      ***********************************************************
     P RplXMLsplpfx    B                   Export
      *
     D RplXMLsplpfx    PI         65535a   varying
     D  InString                  65535a   varying value
     D  InFmPrefix                         like(StdChr) const
     D  InToPrefix                         like(StdChr) const
      *
     D strpos          s                   like(StdInt) inz
     D P_Prefix        s                   like(StdChr) inz
      /free

       // --------------------------------------------
       // Escape if nothing passed.

       if %len(%trim(InString)) = *zero;
          return *blanks;
       endif;

       // -------------------------------------------------------
       // ampersand.

       InString = RplStg(InString:InFmPrefix+'amp;':InToPrefix+'amp;');

       // apostrophy.

       InString = RplStg(InString:InFmPrefix+'apos;':InToPrefix+'apos;');

       // quote.

       InString = RplStg(InString:InFmPrefix+'quot;':InToPrefix+'quot;');

       // less than.

       InString = RplStg(InString:InFmPrefix+'lt;':InToPrefix+'lt;');

       // greater than.

       InString = RplStg(InString:InFmPrefix+'gt;':InToPrefix+'gt;');

š1b€   return InString;

      /end-free
      *
     P RplXMLsplpfx    E
