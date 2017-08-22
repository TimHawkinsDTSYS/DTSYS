      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/time increment prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  AddSeconds() -- Add seconds to a date/time.
      *
     D AddSeconds      PR                  like(d_AddSeconds)
     D  InpISO                             like(NumISO ) value
     D  InpHMS                             like(NumHMS ) value
     D  InpSecs                            like(Secs   ) value
      *
     D d_AddSeconds    DS
     D  AddSeconds_ISO...
     D                                     like(NumISO) inz
     D  AddSeconds_HMS...
     D                                     like(NumHMS) inz
      * ---------------------------------------------------------
      *
      *  Prototype for AddDays
      *
     D AddDays         PR                  like(NumISO)
     D  InpISO                             like(NumISO ) value
     D  InpDays                            like(Days   ) value
      * ---------------------------------------------------------
      *
      *  Prototype for AddMonths
      *
     D AddMonths       PR                  like(NumISO)
     D  InpISO                             like(NumISO ) value
     D  InpMonths                          like(Months ) value
      * ---------------------------------------------------------
      *
      *  Prototype for AddYears
      *
     D AddYears        PR                  like(NumISO)
     D  InpISO                             like(NumISO ) value
     D  InpYears                           like(Days   ) value
      * ---------------------------------------------------------
      *
      *  AdjTimeStamp() -- Adjust timestamp to local time.
      *
     D AdjTimeStamp    PR                  like(StdTms)
     D  parmInputTS                        like(StdTms) const
     D  parmInputTZ                        like(StdNam) const
     D  parmOutputTZ                       like(StdNam) const
