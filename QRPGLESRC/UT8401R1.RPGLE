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
      * CurrentDate()-- Return todays date in ISO format.
      * **********************************************************
     P CurrentDate     B                   Export
      *
      *  Input values
      *
     D CurrentDate     PI                  like(NumISO)
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
     P CurrentDate     E
