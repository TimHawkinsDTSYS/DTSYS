      /TITLE Utility, Date/Time duration (SrvPgm)
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
      ***********************************************************
      * SecondsDuration - Seconds between 2 dates/times.
      ***********************************************************
     P SecsDuration    B                   Export
      *
     D SecsDuration    PI                  like(Secs)
     D  InpFromISO                         like(NumISO ) value
     D  InpFromHMS                         like(NumHMS ) value
     D  InpThruISO                         like(NumISO ) value
     D  InpThruHMS                         like(NumHMS ) value
      *
      * Standalone fields
      *
     D RtnSecs         S                   like(Secs   ) inz
     D DteFromISO      S                   like(DteISO ) Inz
     D TimFromHMS      S                   like(TimHMS ) Inz
     D DteThruISO      S                   like(DteISO ) Inz
     D TimThruHMS      S                   like(TimHMS ) Inz
     D FromTSP         S                   like(TimStp ) Inz
     D ThruTSP         S                   like(TimStp ) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpFromISO = *zero or
     C                             InpFromHMS = *zero or
     C                             InpThruISO = *zero or
     C                             InpThruHMS = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpFromISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpFromHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstDte = TstDte(InpThruISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpThruHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert numeric to ISO dates/times.
      *
     C                   monitor
     C     *iso          move      InpFromISO    DteFromISO
     C     *hms          move      InpFromHMS    TimFromHMS
     C     *iso          move      InpThruISO    DteThruISO
     C     *hms          move      InpThruHMS    TimThruHMS
      *
     C                   on-error  *program
     C                   eval      DteFromISO = *loval
     C                   eval      TimFromHMS = *loval
     C                   eval      DteThruISO = *loval
     C                   eval      TimThruHMS = *loval
     C                   endmon
      *
      *   Convert dates/times to timestamps.
      *
     C                   move      DteFromISO    FromTSP
     C                   move      TimFromHMS    FromTSP
      *
     C                   move      DteThruISO    ThruTSP
     C                   move      TimThruHMS    ThruTSP
      *
      *   Determine seconds between the two.
      *
     C     FromTSP       subdur    ThruTSP       RtnSecs:*S
      *
     C                   return    RtnSecs
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P SecsDuration    E
      ***********************************************************
      * HoursDuration - Hours between 2 dates/times.
      ***********************************************************
     P HoursDuration   B                   Export
      *
     D HoursDuration   PI                  like(Hours)
     D  InpFromISO                         like(NumISO ) value
     D  InpFromHMS                         like(NumHMS ) value
     D  InpThruISO                         like(NumISO ) value
     D  InpThruHMS                         like(NumHMS ) value
      *
      * Standalone fields
      *
     D RtnHours        S              9  0  Inz
     D DteFromISO      S                   like(DteISO ) Inz
     D TimFromHMS      S                   like(TimHMS ) Inz
     D DteThruISO      S                   like(DteISO ) Inz
     D TimThruHMS      S                   like(TimHMS ) Inz
     D FromTSP         S                   like(TimStp ) Inz
     D ThruTSP         S                   like(TimStp ) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpFromISO = *zero or
     C                             InpFromHMS = *zero or
     C                             InpThruISO = *zero or
     C                             InpThruHMS = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpFromISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpFromHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstDte = TstDte(InpThruISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpThruHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    *zero
     C                   endif
      *
      *   Convert numeric to ISO dates/times.
      *
     C                   monitor
     C     *iso          move      InpFromISO    DteFromISO
     C     *hms          move      InpFromHMS    TimFromHMS
     C     *iso          move      InpThruISO    DteThruISO
     C     *hms          move      InpThruHMS    TimThruHMS
      *
     C                   on-error  *program
     C                   eval      DteFromISO = *loval
     C                   eval      TimFromHMS = *loval
     C                   eval      DteThruISO = *loval
     C                   eval      TimThruHMS = *loval
     C                   endmon
      *
      *   Convert dates/times to timestamps.
      *
     C                   move      DteFromISO    FromTSP
     C                   move      TimFromHMS    FromTSP
      *
     C                   move      DteThruISO    ThruTSP
     C                   move      TimThruHMS    ThruTSP
      *
      *   Determine hours between the two.
      *
     C     FromTSP       subdur    ThruTSP       RtnHours:*H
      *
     C                   return    RtnHours
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P HoursDuration   E
      ***********************************************************
      * DaysDuration - Days between 2 dates.
      ***********************************************************
     P DaysDuration    B                   Export
      *
     D DaysDuration    PI                  like(Days)
     D  InpFromISO                         like(NumISO ) value
     D  InpThruISO                         like(NumISO ) value
      *
      * Standalone fields
      *
     D RtnDays         S                   like(Days) Inz
     D DteFromISO      S                   like(DteISO) Inz
     D DteThruISO      S                   like(DteISO) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if           InpFromISO = *zero
     C                             or InpThruISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpFromISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstDte = TstDte(InpThruISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
      *   Convert numeric to ISO dates.
      *
     C                   monitor
     C     *iso          move      InpFromISO    DteFromISO
     C     *iso          move      InpThruISO    DteThruISO
      *
     C                   on-error  *program
     C                   eval      DteFromISO = *loval
     C                   eval      DteThruISO = *loval
     C                   endmon
      *
      *   Determine number of days between the two dates.
      *
     C     DteThruISO    subdur    DteFromISO    RtnDays:*D
      *
     C                   return    RtnDays
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P DaysDuration    E
      ***********************************************************
      * YearsDuration - Years between 2 dates.
      ***********************************************************
     P YearsDuration   B                   Export
      *
     D YearsDuration   PI                  like(Years)
     D  InpFromISO                         like(NumISO ) value
     D  InpThruISO                         like(NumISO ) value
      *
      * Standalone fields
      *
     D RtnYears        S                   like(Years)  inz
     D DteFromISO      S                   like(DteISO) inz
     D DteThruISO      S                   like(DteISO) inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpFromISO = *zero  or
     C                             InpThruISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpFromISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstDte = TstDte(InpThruISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
      *   Convert numeric to ISO dates.
      *
     C                   monitor
     C     *iso          move      InpFromISO    DteFromISO
     C     *iso          move      InpThruISO    DteThruISO
      *
     C                   on-error  *program
     C                   eval      DteFromISO = *loval
     C                   eval      DteThruISO = *loval
     C                   endmon
      *
      *   Determine number of years between the two dates.
      *
     C     DteThruISO    subdur    DteFromISO    RtnYears:*Y
      *
     C                   return    RtnYears
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P YearsDuration   E
      ***********************************************************
      * TimeDuration - Time between 2 dates/times (dddD hhH mmM)
      ***********************************************************
     P TimeDuration    B                   Export
      *
     D TimeDuration    PI                  like(TimDur )
     D  InpFromISO                         like(NumISO ) value
     D  InpFromHMS                         like(NumHMS ) value
     D  InpThruISO                         like(NumISO ) value
     D  InpThruHMS                         like(NumHMS ) value
      *
      * Standalone fields
      *
     D RtnDur          S                   like(TimDur ) Inz
     D DteFromISO      S                   like(DteISO ) Inz
     D TimFromHMS      S                   like(TimHMS ) Inz
     D DteThruISO      S                   like(DteISO ) Inz
     D TimThruHMS      S                   like(TimHMS ) Inz
     D FromTSP         S                   like(TimStp ) Inz
     D ThruTSP         S                   like(TimStp ) Inz
     D WrkFromTSP      S                   like(TimStp ) Inz
     D WrkThruTSP      S                   like(TimStp ) Inz
      *
     D WrkDays         S                   like(Days   ) Inz
     D WrkHours        S                   like(Days   ) Inz
     D WrkMins         S                   like(Days   ) Inz
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpFromISO = *zero or
     C                             InpFromHMS = *zero or
     C                             InpThruISO = *zero or
     C                             InpThruHMS = *zero
     C                   return    *blanks
     C                   endif
      *---------------------------------------------------------
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpFromISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpFromHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstDte = TstDte(InpThruISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    *zero
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpThruHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    *zero
     C                   endif
      *---------------------------------------------------------
      *
      *   Convert numeric to ISO dates/times.
      *
     C                   monitor
     C     *iso          move      InpFromISO    DteFromISO
     C     *hms          move      InpFromHMS    TimFromHMS
     C     *iso          move      InpThruISO    DteThruISO
     C     *hms          move      InpThruHMS    TimThruHMS
      *
     C                   on-error  *program
     C                   eval      DteFromISO = *loval
     C                   eval      TimFromHMS = *loval
     C                   eval      DteThruISO = *loval
     C                   eval      TimThruHMS = *loval
     C                   endmon
      *---------------------------------------------------------
      *
      *   Convert dates/times to timestamps.
      *
     C                   move      DteFromISO    FromTSP
     C                   move      TimFromHMS    FromTSP
      *
     C                   move      DteThruISO    ThruTSP
     C                   move      TimThruHMS    ThruTSP
      *---------------------------------------------------------
      *
      *   Determine time between the two.
      *
     C                   eval      WrkfromTSP = FromTSP
     C                   eval      WrkthruTSP = ThruTSP
      *
     C     WrkthruTSP    subdur    WrkfromTSP    WrkDays:*D
     C                   subdur    WrkDays:*D    WrkthruTSP
      *
     C     WrkthruTSP    subdur    WrkfromTSP    WrkHours:*H
     C                   subdur    WrkHours:*H   WrkthruTSP
      *
     C     WrkthruTSP    subdur    WrkfromTSP    WrkMins:*MN
     C                   subdur    WrkMins:*MN   WrkthruTSP
      *---------------------------------------------------------
      *
      *   Format into DDDd HHh DDm
      *               123456789.12
      *
     C                   if        WrkDays <> *zero
     C                   evalR     %subst(RtnDur:01:3)=%char(WrkDays)
     C                   eval      %subst(RtnDur:04:1) = 'd'
     C                   endif
      *
     C                   if        WrkHours <> *zero
     C                   evalR     %subst(RtnDur:06:2)=%char(WrkHours)
     C                   eval      %subst(RtnDur:08:1) = 'h'
     C                   endif
      *
     C                   if        WrkMins <> *zero
     C                   evalR     %subst(RtnDur:10:2)=%char(WrkMins)
     C                   eval      %subst(RtnDur:12:1) = 'm'
     C                   endif
      *
     C                   return    RtnDur
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P TimeDuration    E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Elapsed minutes from a timestamp.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P ElpMinFromTSP   B                   Export
      *
     D ElpMinFromTSP   PI                  like(Mins)
     D  FromTSP                            like(TimStp) value
     D  ThruTSP                            like(TimStp) value
      *
     D WrkDteISO       s                   like(DteISO) inz
     D WrkTimHMS       s                   like(TimHMS) inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        FromTSP = *loval or
     C                             ThruTSP = *loval
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Check timestamps for valid values
      *
     C                   monitor
     C                   move      FromTSP       WrkDteISO
     C                   move      FromTSP       WrkTimHMS
     C                   move      ThruTSP       WrkDteISO
     C                   move      ThruTSP       WrkTimHMS
      *
     C                   on-error  *program
     C                   return    *zero
     C                   endmon
      * ---------------------------------------------------------
      *
      *   Determine minutes between the two.
      *
     C                   monitor
     C                   eval      Secs = ElpSecFromTSP(FromTSP:ThruTSP)
     C                   eval      Mins = Secs / 60
      *
     C                   on-error  *program
     C                   eval      Mins = *hival
     C                   endmon
      *
     C                   return    %abs(Mins)
      *
     P ElpMinFromTSP   E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Elapsed seconds from a timestamp.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P ElpSecFromTSP   B                   Export
      *
     D ElpSecFromTSP   PI                  like(Secs)
     D  FromTSP                            like(TimStp) value
     D  ThruTSP                            like(TimStp) value
      *
      * Standalone fields
      *
     D RtnSecs         S                   like(Secs) inz
      *
     D WrkDteISO       s                   like(DteISO) inz
     D WrkTimHMS       s                   like(TimHMS) inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        FromTSP = *loval or
     C                             ThruTSP = *loval
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Check timestamps for valid values
      *
     C                   monitor
     C                   move      FromTSP       WrkDteISO
     C                   move      FromTSP       WrkTimHMS
     C                   move      ThruTSP       WrkDteISO
     C                   move      ThruTSP       WrkTimHMS
      *
     C                   on-error  *program
     C                   return    *zero
     C                   endmon
      * ---------------------------------------------------------
      *
      *   Determine seconds between the two.
      *
      /free
         eval      RtnSecs = %diff(ThruTSP:FromTSP:*S);
         return    %abs(RtnSecs);
      /end-free
      *
     P ElpSecFromTSP   E
