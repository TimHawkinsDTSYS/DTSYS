      /TITLE Utility, Date/Time job values (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      * **********************************************************
      * TodaysDate()-- Return todays date in ISO format.
      * **********************************************************
     P TodaysDate      B                   Export
      *
      *  Input values
      *
     D TodaysDate      PI                  like(NumISO)
     D  DateType_p                         like(StdNam) const
     D                                     options(*nopass)
      *
     D DateType        s                   like(StdNam)
     D WrkDteISO       s                   like(DteISO) inz
     D RtnISO          s                   like(NumISO) inz
      * ---------------------------------------------------------
      *
      *    Check for omitted parameters.
      *
     C                   if        %parms  >= 1
     C                   eval      DateType = DateType_p
     C                   endif
      * ---------------------------------------------------------
      *
      *   Set date using job date.
      *
     C                   select
     C                   when      DateType = *blanks or
     C                             DateType = '*JOB'
     C     *usa          move      *date         WrkDteISO
     C                   movel     WrkDteISO     RtnISO
      *
      *   Set date using system date.
      *
     C                   when      DateType = '*SYS'     or
     C                             DateType = '*SYSTEM'
      /free
        eval WrkDteISO = %date;
      /end-free
      *
     C     *iso          movel     WrkDteISO     RtnISO
     C                   endsl
      *
     C                   return    RtnISO
      *
     P TodaysDate      E
      ***********************************************************
      * CurrentTime() - Return current time in HMS format.
      ***********************************************************
     P CurrentTime     B                   Export
      *
      * Input values
      *
     D CurrentTime     PI                  like(NumHMS )
      *
     D                 ds
     D TimeDate                      14  0
     D  Time60                        6  0 overlay(TimeDate:1)
     D  Date80                        8  0 overlay(TimeDate:7)
      *
      *   Set time using TIME operation.
      *
     C                   time                    TimeDate
     C                   return    Time60
      *
     P CurrentTime     E
      ***********************************************************
      * TimeStamp() -- Return timestamp in ISO format.
      ***********************************************************
     P TimeStamp       B                   Export
      *
     D TimeStamp       PI                  like(TimStp)
     D  DateType_p                         like(StdNam) const
     D                                     options(*nopass:*omit)
     D  Options_p                          like(StdStr) const
     D                                     options(*nopass:*omit)
      *
      * Standalone fields
      *
     D DateType        s                   like(DateType_p)
     D Options         s                   like(Options_p)
     D RtnTimStp       s                   like(TimStp) Inz
      * ---------------------------------------------------------
      /free

       // -------------------------------------------------------
       //    Check for omitted parameters.

       if %parms >= 1;
          callp CEETSTA(ParmPassed:1:*omit);
          if ParmPassed = 1;
             DateType = DateType_p;
          endif;
       endif;

       if %parms >= 2;
          callp CEETSTA(ParmPassed:2:*omit);
          if ParmPassed = 1;
             Options = Options_p;
          endif;
       endif;

       // -------------------------------------------------------
       //   Set timestamp using job date or system date.

       select;
         when DateType  = '*JOB';
              NumISO    = CvtUSAtoISO(*date);
              RtnTimStp = %timestamp;
              AlpTimStp = %editw(NumISO:'    -  -  ') +
                          %subst(%char(RtnTimStp):11);
              RtnTimStp = %timestamp(AlptimStp);

         when DateType  = *blanks or
              DateType  = '*SYS'  or
              DateType  = '*SYSTEM';
              RtnTimStp = %timestamp;
       endsl;

       // -------------------------------------------------------
       //   No microseconds option.

       if %scan('*NOMSECONDS':Options) > *zero;
       // RtnTimStp -= %subdt(RtnTimStp:*mseconds);
       endif;

       return RtnTimStp;

      /end-free
      *
     P TimeStamp       E
      ***********************************************************
      * TimeStampAlpha() -- Return timestamp in alpha format.
      ***********************************************************
     P TimeStampAlpha  B                   Export
      *
     D TimeStampAlpha  PI                  like(AlpTimStp )
     D  DateType_p                         like(StdNam) const
     D                                     options(*nopass)
      *
      * Standalone fields
      *
     D DateType        s                   like(StdNam)
     D RtnTimStp       S                   like(TimStp) Inz
      * ---------------------------------------------------------
      /free

       //    Check for omitted parameters.

       if %parms >= 1;
         eval DateType = DateType_p;
       endif;
       // -------------------------------------------------------

       //   Set timestamp using job date or system date.

       select;
         when DateType    = '*JOB';
           eval NumISO    = CvtUSAtoISO(*date);
           eval RtnTimStp = %timestamp;
           eval AlpTimStp = %editw(NumISO:'    -  -  ') +
                            %subst(%char(RtnTimStp):11);

         when DateType    = *blanks or
              DateType    = '*SYS'  or
              DateType    = '*SYSTEM';
           eval AlpTimStp = %char(%timestamp);
       endsl;

       return AlpTimStp;

      /end-free
      *
     P TimeStampAlpha  E
      ***********************************************************
      * PmtCal() -- Prompt for calendar.
      ***********************************************************
      *
     P PmtCal          B                   Export

     D PmtCal          PI                  like(NumISO)
     D  InpISO                             like(NumISO) value

     D UT0307R         PR                  extpgm('UT0307R')
     D  InpISO                             like(NumISO)
     D  RtnISO                             like(NumISO)

     D RtnISO          s                   like(NumISO)

      /Free

         callp  UT0307R(InpISO:RtnISO);

         return RtnISO;

      /End-Free

     P PmtCal          E
      ***********************************************************
      * GetMicroTime() -- Get timestamp to the microsecond.
      ***********************************************************
      *
     P GetMicroTime    B
      *
     D GetMicroTime    PI                  like(StdTms)
      *
     D gettimeofday    PR                  extproc('gettimeofday')
     D                                     like(StdInt)
     D   time                              like(StdPtr) value
     D   timezone                          like(StdPtr) value
      *
     D timeval         ds
     D   tv_sec                            like(StdInt)
     D   tv_usec                           like(StdInt)
      *
     D RetVal          s                   like(StdTms)
     D                                     inz(z'1970-01-01-00.00.00')
     D hours           s                   like(StdInt)
     D mins            s                   like(StdInt)
     D FSecs           s                   like(StdDblFlt)
     D Secs            s             20  0
      *
     c                   callp     CEEUTCO(hours: mins: FSecs)
     c                   eval      Secs = FSecs
      *
     c                   callp     gettimeofday(%addr(timeval):*null)
     c                   adddur    secs:*S       RetVal
     c                   adddur    tv_sec:*S     RetVal
     c                   adddur    tv_usec:*MS   RetVal
      *
     c                   return    RetVal
      *
     P GetMicroTime    E
