      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/time duration prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  DaysDuration() -- Days between two dates.
      *
     D DaysDuration    PR                  like(Days)
     D  InpFromISO                         like(NumISO) value
     D  InpThruISO                         like(NumISO) value
      * ---------------------------------------------------------
      *
      *  YearsDuration() -- Years between two dates.
      *
     D YearsDuration   PR                  like(Years)
     D  InpFromISO                         like(NumISO) value
     D  InpThruISO                         like(NumISO) value
      * ---------------------------------------------------------
      *
      *  TimeDuration() -- Time between two dates/times.
      *
     D TimeDuration    PR                  like(TimDur)
     D  InpFromISO                         like(NumISO) value
     D  InpFromHMS                         like(NumHMS) value
     D  InpThruISO                         like(NumISO) value
     D  InpThruHMS                         like(NumHMS) value
      * ---------------------------------------------------------
      *
      *  HoursDuration() -- Hours between two dates/times.
      *
     D HoursDuration   PR                  like(Hours)
     D  InpFromISO                         like(NumISO) value
     D  InpFromHMS                         like(NumHMS) value
     D  InpThruISO                         like(NumISO) value
     D  InpThruHMS                         like(NumHMS) value
      * ---------------------------------------------------------
      *
      *  SecsDuration() -- Seconds between two dates/times.
      *
     D SecsDuration    PR                  like(Secs)
     D  InpFromISO                         like(NumISO) value
     D  InpFromHMS                         like(NumHMS) value
     D  InpThruISO                         like(NumISO) value
     D  InpThruHMS                         like(NumHMS) value
      * ---------------------------------------------------------
      *
      *  ElpSecFromTSP() -- Elapsed seconds from a timestamp.
      *
     D ElpSecFromTSP   PR                  like(Secs)
     D  FromTSP                            like(TimStp) value
     D  ThruTSP                            like(TimStp) value
      * ---------------------------------------------------------
      *
      *  ElpMinFromTSP() -- Elapsed minutes from a timestamp.
      *
     D ElpMinFromTSP   PR                  like(Mins)
     D  FromTSP                            like(TimStp) value
     D  ThruTSP                            like(TimStp) value
