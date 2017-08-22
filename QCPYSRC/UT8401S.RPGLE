      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/Time job value prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  TodaysDate() -- Return todays date in ISO format.
      *
     D TodaysDate      PR                  like(NumISO)
     D  DateType                           like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  CurrentDate() -- Return todays date in ISO format.
      *
     D CurrentDate     PR                  like(NumISO)
     D  DateType                           like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  CurrentTime() - Return current time in HMS format.
      *
     D CurrentTime     PR                  like(NumHMS )
      * ---------------------------------------------------------
      *
      *  TimeStamp() -- Return timestamp in ISO format.
      *
     D TimeStamp       PR                  like(TimStp )
     D  DateType                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  Options                            like(StdStr) const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      *
      *  TimeStampAlpha() -- Return timestamp in alpha format.
      *
     D TimeStampAlpha  PR                  like(AlpTimStp)
     D  DateType                           like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *  PmtCal() -- Prompt for calendar.
      *
     D PmtCal          PR                  like(NumISO)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *  GetMicroTime() -- Get timestamp to the microsecond.
      *
     D GetMicroTime    PR                  like(StdTms)
