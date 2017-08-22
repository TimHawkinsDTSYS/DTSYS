      /TITLE Utility, Date/Time extract (SrvPgm)
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
      *  01/23/08  TimH        Changed extract date to move values rather
      *                         than substring alpha values and use the
      *                         convert to numeric procedure for performance.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * CatDat() - Concatenate date.
      ***********************************************************
     P CatDat          B                   Export
      *
     D CatDat          PI                  like(NumISO)
     D  InpYYYY                            like(NumYYYY) value
     D  InpMM                              like(NumMM  ) value
     D  InpDD                              like(NumDD  ) value
      * ---------------------------------------------------------
      * Concatenate each piece into ISO.
      *
     C                   eval      AlpISO = %editc(InpYYYY:'X') +
     C                                      %editc(InpMM  :'X') +
     C                                      %editc(InpDD  :'X')
      *
     C                   return    num(AlpISO)
      *
     P CatDat          E
      ***********************************************************
      * ExtractDate() - Extract year/month/day from date.
      ***********************************************************
     P ExtractDate     B                   Export
      *
     D ExtractDate     PI                  like(d_ExtractDate)
     D  InpISO                             like(NumISO ) value
      *
     D ExtractDS       DS
     D  YYYY                          4s 0
     D  CC                            2s 0 overlay(YYYY:1)
     D  YY                            2s 0 overlay(YYYY:3)
     D  MM                            2s 0
     D  DD                            2s 0
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   clear                   d_ExtractDate
     C                   return    d_ExtractDate
     C                   endif
      * ---------------------------------------------------------
      * Extract ISO.
      *
     C                   move      InpISO        ExtractDS
      *
     C                   eval      ExtractDate_YYYY = YYYY
     C                   eval      ExtractDate_CC   = CC
     C                   eval      ExtractDate_YY   = YY
     C                   eval      ExtractDate_MM   = MM
     C                   eval      ExtractDate_DD   = DD
      *
     C                   return    d_ExtractDate
      *
     P ExtractDate     E
      * **********************************************************
      * ExtractTime() - Extract hours/minutes/seconds from time.
      * **********************************************************
     P ExtractTime     B                   Export
      *
     D ExtractTime     PI                  like(d_ExtractTime)
     D  InpHMS                             like(NumHMS ) value
      *
     D ExtractDS       DS
     D  HH                            2s 0
     D  MN                            2s 0
     D  SS                            2s 0
      * ---------------------------------------------------------
      * Extract HMS.
      *
     C                   move      InpHMS        ExtractDS
      *
     C                   eval      ExtractTime_HH = HH
     C                   eval      ExtractTime_MN = MN
     C                   eval      ExtractTime_SS = SS
      *
     C                   return    d_ExtractTime
      *
     P ExtractTime     E
      * **********************************************************
      * DayofWeek() - Day of week.
      * **********************************************************
     P DayofWeek       B                   Export
      *
     D DayofWeek       PI                  like(d_DayofWeek)
     D  InpISO                             like(NumISO ) value
      *
     D LilDate         S                    like(StdInt)  inz
     D Dwkparm         S                    like(StdInt)  inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   reset                   d_DayofWeek
     C                   return    d_DayofWeek
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   reset                   d_DayofWeek
     C                   return    d_DayofWeek
     C                   endif
      * ---------------------------------------------------------
      * Convert numeric to lillian date.
      *
     C                   eval      AlpISO = %editc(InpISO:'X')
      *
     C                   monitor
     C                   callp     CEEDAYS(AlpISO:'YYYYMMDD':LilDate:*OMIT)
      *
     C                   on-error  *program
     C                   eval      LilDate = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Calculate day of week.
      *
     C                   monitor
     C                   callp     CEEDYWK(LilDate:DWKparm:*OMIT)
      *
     C                   on-error  *program
     C                   eval      DWKparm = *loval
     C                   endmon
      *
     C                   eval      DayofWeek_DayN = DWKparm
      * ---------------------------------------------------------
      * Move back to parameters.
      *
     C                   select
     C                   when      DayofWeek_DayN = 1
     C                   eval      DayofWeek_Daytext2 = 'Su'
     C                   eval      DayofWeek_Daytext3 = 'Sun'
     C                   eval      DayofWeek_Daytext9 = 'Sunday'
      *
     C                   when      DayofWeek_DayN = 2
     C                   eval      DayofWeek_Daytext2 = 'Mo'
     C                   eval      DayofWeek_Daytext3 = 'Mon'
     C                   eval      DayofWeek_Daytext9 = 'Monday'
      *
     C                   when      DayofWeek_DayN = 3
     C                   eval      DayofWeek_Daytext2 = 'Tu'
     C                   eval      DayofWeek_Daytext3 = 'Tue'
     C                   eval      DayofWeek_Daytext9 = 'Tuesday'
      *
     C                   when      DayofWeek_DayN = 4
     C                   eval      DayofWeek_Daytext2 = 'We'
     C                   eval      DayofWeek_Daytext3 = 'Wed'
     C                   eval      DayofWeek_Daytext9 = 'Wednesday'
      *
     C                   when      DayofWeek_DayN = 5
     C                   eval      DayofWeek_Daytext2 = 'Th'
     C                   eval      DayofWeek_Daytext3 = 'Thu'
     C                   eval      DayofWeek_Daytext9 = 'Thursday'
      *
     C                   when      DayofWeek_DayN = 6
     C                   eval      DayofWeek_Daytext2 = 'Fr'
     C                   eval      DayofWeek_Daytext3 = 'Fri'
     C                   eval      DayofWeek_Daytext9 = 'Friday'
      *
     C                   when      DayofWeek_DayN = 7
     C                   eval      DayofWeek_Daytext2 = 'Sa'
     C                   eval      DayofWeek_Daytext3 = 'Sat'
     C                   eval      DayofWeek_Daytext9 = 'Saturday'
     C                   endsl
      *
     C                   return    d_DayofWeek
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P DayofWeek       E
      ***********************************************************
      * DaysinMonth() - Days in Month.
      ***********************************************************
     P DaysinMonth     B                   Export
      *
     D DaysinMonth     PI                  like(NumDD  )
     D  InpISO                             like(NumISO ) value
      *
     D wkDteISO        S                   like(DteISO) inz
     D wkNumISO        S                   like(NumISO) inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   reset                   NumDD
     C                   return    NumDD
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   reset                   NumDD
     C                   return    NumDD
     C                   endif
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C                   monitor
     C     *iso          move      InpISO        wkDteISO
      *
     C                   on-error  *program
     C                   eval      wkDteISO = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Extract date components.
      *
     C                   extrct    wkDteISO:*Y   NumYYYY
     C                   extrct    wkDteISO:*M   NumMM
     C                   extrct    wkDteISO:*D   NumDD
      * ---------------------------------------------------------
      * Set day to the 1st and concatenate back.
      *
     C                   eval      WkNumISO = CatDat(NumYYYY:NumMM:01)
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C     *iso          move      wkNumISO      wkDteISO
      * ---------------------------------------------------------
      * Add one month; to get the 1st of next month.
      *
     C                   adddur    1:*M          wkDteISO
      * ---------------------------------------------------------
      * Backup one day; to get the last of current month.
      *
     C                   subdur    1:*D          wkDteISO
      * ---------------------------------------------------------
      * Move back to parameters.
      *
     C                   extrct    wkDteISO:*D   NumDD
      *
     C                   return    NumDD
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P DaysinMonth     E
      * **********************************************************
      * WeekofYear() - Week of Year.
      * **********************************************************
     P WeekofYear      B                   Export
      *
     D WeekofYear      PI                  like(Week   )
     D  InpISO                             like(NumISO ) value
      *
     D todayISO        S                   like(NumISO)
     D RtnWEEK         S                   like(NumWEEK)
     D wkdteISO        S                   like(DteISO) inz
     D wknumISO        S                   like(NumISO) inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Set date to first of year.
      *
     C                   move      InpISO        wkNumISO
     C                   move      '0101'        wkNumISO
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C                   monitor
     C     *iso          move      wkNumISO      wkDteISO
      *
     C                   on-error  *program
     C                   eval      wkDteISO = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Backup one day; to get the last day of last year.
      *
     C                   subdur    1:*D          wkDteISO
      * ---------------------------------------------------------
      * Determine number of days between then and today.
      *
     C                   move      wkDteISO      wkNumISO
     C                   eval      Days = DaysDuration(wkNumISO:InpISO)
      * ---------------------------------------------------------
      * Calculate the week number.
      *
     C     days          div       7             RtnWEEK
     C                   mvr                     days
      *
     C                   if        days <> *zero
     C                   eval      RtnWeek = RtnWEEK + 1
     C                   return    RtnWEEK
     C                   endif
      *
     C                   return    RtnWEEK
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P WeekofYear      E
      * **********************************************************
      * QuarterofYear() - Quarter of Year.
      * **********************************************************
     P QuarterofYear   B                   Export
      *
     D QuarterofYear   PI                  like(Quarter)
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Extract date components.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpMM    = %subst(AlpISO:5)
      * ---------------------------------------------------------
      * Determine quarter.
      *
     C                   select
     C                   when      AlpMM >= '01' and AlpMM <= '03'
     C                   return    1
      *
     C                   when      AlpMM >= '04' and AlpMM <= '06'
     C                   return    2
      *
     C                   when      AlpMM >= '07' and AlpMM <= '09'
     C                   return    3
      *
     C                   when      AlpMM >= '10' and AlpMM <= '12'
     C                   return    4
     C                   endsl
      *
     C                   return    *zero
      *
     P QuarterofYear   E
      * **********************************************************
      * AlphaMonth() - Return MMM from ISO.
      * **********************************************************
     P AlphaMonth      B                   Export
      *
     D AlphaMonth      PI                  like(AlpMMM )
     D  InpMM                              like(NumMM  ) value
      * ---------------------------------------------------------
      * Test for month.
      *
     C                   if        InpMM  <= *zero or
     C                             InpMM  >  12
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      * Determine the alpha month.
      *
     C                   select
     C                   when      InpMM = 01
     C                   return    'Jan'
      *
     C                   when      InpMM = 02
     C                   return    'Feb'
      *
     C                   when      InpMM = 03
     C                   return    'Mar'
      *
     C                   when      InpMM = 04
     C                   return    'Apr'
      *
     C                   when      InpMM = 05
     C                   return    'May'
      *
     C                   when      InpMM = 06
     C                   return    'Jun'
      *
     C                   when      InpMM = 07
     C                   return    'Jul'
      *
     C                   when      InpMM = 08
     C                   return    'Aug'
      *
     C                   when      InpMM = 09
     C                   return    'Sep'
      *
     C                   when      InpMM = 10
     C                   return    'Oct'
      *
     C                   when      InpMM = 11
     C                   return    'Nov'
      *
     C                   when      InpMM = 12
     C                   return    'Dec'
     C                   endsl
      *
     C                   return    *blanks
      *
     P AlphaMonth      E
      * **********************************************************
      * RtvMthNam() - Retrieve month name.
      * **********************************************************
     P RtvMthNam       B                   Export
      *
     D RtvMthNam       PI             9
     D  InpISO                             like(NumISO ) value
      *
     D AryMonths       c                   'January  -
     D                                     February -
     D                                     March    -
     D                                     April    -
     D                                     May      -
     D                                     June     -
     D                                     July     -
     D                                     August   -
     D                                     September-
     D                                     October  -
     D                                     November -
     D                                     December '
      *
     D RtnMthNam       S              9
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      * Extract date.
      *
     C                   eval      d_ExtractDate = ExtractDate(InpISO)
      * ---------------------------------------------------------
      * Retrieve month of year.
      *
     C                   eval      RtnMthNam =
     C                             %subst(AryMonths:(ExtractDate_MM*9)-8)
      *
     C                   return    RtnMthNam
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P RtvMthNam       E
      * **********************************************************
      * RtvLongDate() - Retrieve long date.
      * -- option can be *NODAY.
      * **********************************************************
     P RtvLongDate     B                   Export
      *
     D RtvLongDate     PI            30
     D  InpISO                             like(NumISO ) value
     D  InpOption                          like(StdNam)  const
     D                                     options(*nopass)
      *
     D AryMonths       c                   'January  -
     D                                     February -
     D                                     March    -
     D                                     April    -
     D                                     May      -
     D                                     June     -
     D                                     July     -
     D                                     August   -
     D                                     September-
     D                                     October  -
     D                                     November -
     D                                     December '
      *
     D RtnLongDate     S             30
     D wkMonth         S              9
     D wkOption        s                   like(StdNam) inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Handle optional parameter.
      *
     C                   if        %parms    >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
     C                   if        ParmPassed = 1
     C                   eval      wkOption  = InpOption
     C                   endif
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Extract date for it's components.
      *
     C                   eval      d_ExtractDate = ExtractDate(InpISO)
      * ---------------------------------------------------------
      * Retrieve day of week.
      *
     C                   eval      d_dayofweek = DayOfWeek(InpISO)
      * ---------------------------------------------------------
      * Retrieve month of year.
      *
     C                   eval      wkMonth =
     C                             %subst(AryMonths:(ExtractDate_MM*9)-8)
      * ---------------------------------------------------------
      * String together the date.
      *
      /free

       if wkOption   = '*NODAY';
          RtnLongDate = %trim(wkMonth)             + ' '  +
                        %char(ExtractDate_DD)       + ', ' +
                        %char(ExtractDate_YYYY);
       else;
          RtnLongDate = %trim(DayOfWeek_DayText9)   + ', ' +
                        %trim(wkMonth)             + ' '  +
                        %char(ExtractDate_DD)       + ', ' +
                        %char(ExtractDate_YYYY);
       endif;

       return    RtnLongDate;

      /end-free
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P RtvLongDate     E
      * **********************************************************
      * LastDateinMonth() - Last date in month.
      * **********************************************************
     P LastDateInMonth...
     P                 B                   Export
      *
     D LastDateInMonth...
     D                 PI                  like(NumISO)
     D  InpISO                             like(NumISO) value
      *
     D wkDteISO        s                   like(DteISO)
     D wkNumISO        s                   like(NumISO)
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C                   monitor
     C     *iso          move      InpISO        wkDteISO
      *
     C                   on-error  *program
     C                   eval      wkDteISO = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Extract date components.
      *
     C                   extrct    wkDteISO:*Y   NumYYYY
     C                   extrct    wkDteISO:*M   NumMM
     C                   extrct    wkDteISO:*D   NumDD
      *
      * Set day to the 1st and concatenate back.
      *
     C                   eval      wkNumISO = CatDat(NumYYYY:NumMM:01)
      *
      * Convert numeric to ISO date.
      *
     C     *iso          move      wkNumISO      wkDteISO
      *
      * Add one month; to get the 1st of next month.
      *
     C                   adddur    1:*M          wkDteISO
      *
      * Backup one day; to get the last of current month.
      *
     C                   subdur    1:*D          wkDteISO
      *
      * Extract and concatenate back.
      *
     C                   extrct    wkDteISO:*Y   NumYYYY
     C                   extrct    wkDteISO:*M   NumMM
     C                   extrct    wkDteISO:*D   NumDD
     C                   eval      wkNumISO = CatDat(NumYYYY:NumMM:NumDD)
      *
     C                   return    wkNumISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P LastDateInMonth...
     P                 E
      * **********************************************************
      * FirstDateinMonth() - First date in month.
      * **********************************************************
     P FirstDateInMonth...
     P                 B                   Export
      *
     D FirstDateInMonth...
     D                 PI                  like(NumISO)
     D  InpISO                             like(NumISO) value
      *
     D wkDteISO        s                   like(DteISO) inz
     D wkNumISO        s                   like(NumISO) inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C                   monitor
     C     *iso          move      InpISO        wkDteISO
      *
     C                   on-error  *program
     C                   eval      wkDteISO = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Extract date components.
      *
     C                   extrct    wkDteISO:*Y   NumYYYY
     C                   extrct    wkDteISO:*M   NumMM
     C                   extrct    wkDteISO:*D   NumDD
      * ---------------------------------------------------------
      * Set day to the 1st and concatenate back.
      *
     C                   eval      wkNumISO = CatDat(NumYYYY:NumMM:01)
      *
     C                   return    wkNumISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P FirstDateInMonth...
     P                 E
      * **********************************************************
      * FirstDateinYear() - First date in year.
      * **********************************************************
     P FirstDateInYear...
     P                 B                   Export
      *
     D FirstDateInYear...
     D                 PI                  like(NumISO)
     D  InpISO                             like(NumISO) value
      *
     D wkDteISO        s                   like(DteISO) inz
     D wkNumISO        s                   like(NumISO) inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C                   monitor
     C     *iso          move      InpISO        wkDteISO
      *
     C                   on-error  *program
     C                   eval      wkDteISO = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Extract date components.
      *
     C                   extrct    wkDteISO:*Y   NumYYYY
     C                   extrct    wkDteISO:*M   NumMM
     C                   extrct    wkDteISO:*D   NumDD
      * ---------------------------------------------------------
      * Set day to the 1st and concatenate back.
      *
     C                   eval      wkNumISO = CatDat(NumYYYY:01:01)
      *
     C                   return    wkNumISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P FirstDateInYear...
     P                 E
      * **********************************************************
      * LastDateinYear() - Last date in year.
      ***********************************************************
     P LastDateInYear...
     P                 B                   Export
      *
     D LastDateInYear...
     D                 PI                  like(NumISO)
     D  InpISO                             like(NumISO) value
      *
     D wkDteISO        s                   like(DteISO) inz
     D wkNumISO        s                   like(NumISO) inz
      * ---------------------------------------------------------
      * Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      * Convert numeric to ISO date.
      *
     C                   monitor
     C     *iso          move      InpISO        wkDteISO
      *
     C                   on-error  *program
     C                   eval      wkDteISO = *loval
     C                   endmon
      * ---------------------------------------------------------
      * Extract date components.
      *
     C                   extrct    wkDteISO:*Y   NumYYYY
     C                   extrct    wkDteISO:*M   NumMM
     C                   extrct    wkDteISO:*D   NumDD
      * ---------------------------------------------------------
      * Set day to the 1st and concatenate back.
      *
     C                   eval      wkNumISO = CatDat(NumYYYY:12:31)
      *
     C                   return    wkNumISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P LastDateInYear...
     P                 E
      /eof
      * **********************************************************
      *  ExtTSPfromdateTime() - Extract TSP from dateTime.
      *
      *  -- Formats : yyyy-mm-ddThh:mm:ss+hh:mm     Lexical
      *               yyyy-mm-ddThh:mm:ssZ          Canonical
      *               yyyy-mm-ddThh:mm:ss.nnn+hh:mm Lexical
      *               yyyy-mm-ddThh:mm:ss.nnnZ      Canonical
      *
      *  -- Examples: 2010-06-11T00:00:00-04:00
      *               2010-06-11T10:15:01.883
      *               2010-06-11T10:40:20.06
      *               2010-06-11T00:00-04:00
      *               2010-06-11T10:40
      * **********************************************************
     P ExtTSPfromdateTime...
     P                 B                   Export
      *
     D ExtTSPfromdateTime...
     D                 PI                  like(StdTsp)
     D  dateTime                           like(StdTxt) const
     D  Options_p                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  p_ErrInfo                          likeDS(dsErrInfo)
     D                                     options(*omit:*nopass)
      *
     D Options         s                   like(StdStr) inz
     D StrPos          s                   like(StdInt) inz
     D Lexical         s                   like(StdInd) inz
     D Canonical       s                   like(StdInd) inz
     D LexSign         s                   like(StdChr) inz
     D WkTXT           s                   like(StdTxt) inz
     D WkISO           s                   like(NumISO) inz
     D WkHMS           s                   like(NumHMS) inz
     D WkMIL           s                   like(StdInt) inz
     D WkLEX           s                   like(NumHM)  inz
     D WkLexHH         s                   like(StdInt) inz
     D WkLexMM         s                   like(StdInt) inz
     D WkTSP           s                   like(StdTsp) inz
     D x               s                   like(StdInt) inz
      /free
       // -------------------------------------------------------
       // Test for no input.

       if dateTime = *blanks;
          return     NullTSP;
       endif;

       // --------------------------------------------------------
       // Handle optional parameters.

       if  %parms >= 2;
           CEETSTA(ParmPassed:2:*omit);
           if  ParmPassed = 1;
               Options = upper(Options_p);
           endif;
       endif;

       // -------------------------------------------------------
       // Extract the date.
       // -- Format: yyyy-mm-ddThh:mm:ss.mss-00:00
       //            123456789.123456789.123456789

       WkTxt = *blanks;

       for  x = 1 to %len(%trim(dateTime));
            if  %subst(dateTime:x:1) = 'T';
                leave;
            endif;

            if  %subst(dateTime:x:1) >= '0'   and
                %subst(dateTime:x:1) <= '9';
                WkTxt = %trim(WkTxt) + %subst(dateTime:x:1);
            endif;
       endfor;

       WkISO = num(WkTxt);

       // Verify value.

       if  not ChkDte(WkISO);
       //  not ChkDte(WkISO: dsErrInfo);
           if  %parms = 3;
               p_ErrInfo = dsErrInfo;
           endif;

           return NullTSP;
       endif;

       // -------------------------------------------------------
       // Extract the time.
       // -- Format: yyyy-mm-ddThh:mm:ss.mss-00:00
       //            123456789.123456789.123456789

       WkTxt = *blanks;
       StrPos = %scan('T':dateTime);

       for x = StrPos to %len(%trim(dateTime));
           if %subst(dateTime:x:1) = '.'    or
              %subst(dateTime:x:1) = '+'    or
              %subst(dateTime:x:1) = '-'    or
              %subst(dateTime:x:1) = 'Z'    or
              %subst(dateTime:x:1) = ' ';
              leave;
           endif;

           if %subst(dateTime:x:1) >= '0'   and
              %subst(dateTime:x:1) <= '9';
              WkTxt = %trim(WkTxt) + %subst(dateTime:x:1);
           endif;
       endfor;

       WkHMS = num(WkTxt);

       // If seconds not passed, adjust HHMM to HHMMSS.

       for x = 1 to %len(WkHMS) - %len(%trim(wkTxt));
           wkHMS *= 10;
       endfor;

       // Verify value.

       if not ChkTim(wkHMS);
       // not ChkTim(wkHMS: '*alwzero': dsErrInfo);
          if %parms = 3;
             p_ErrInfo = dsErrInfo;
          endif;

          return NullTSP;
       endif;

       // -------------------------------------------------------
       // Extract the milliseconds.
       // -- Format: yyyy-mm-ddThh:mm:ss.mss-00:00
       //            123456789.123456789.123456789

       wkTxt = *blanks;
       StrPos = %scan('T':dateTime);
       StrPos = %scan('.':dateTime:StrPos);

       if StrPos <> *zero;
          for x = StrPos to %len(%trim(dateTime));
              if %subst(dateTime:x:1) = '+'    or
                 %subst(dateTime:x:1) = '-'    or
                 %subst(dateTime:x:1) = 'Z'    or
                 %subst(dateTime:x:1) = ' ';
                 leave;
              endif;

              if %subst(dateTime:x:1) >= '0'   and
                 %subst(dateTime:x:1) <= '9';
                 wkTxt = %trim(wkTxt) + %subst(dateTime:x:1);
              endif;
          endfor;
       endif;

       wkMIL = num(wkTxt);

       // Convert from decimal to whole milliseconds.

       for x = 1 to %len(wkMIL) - %len(%trim(wkTxt));
           wkMIL *= 10;
       endfor;

       // -------------------------------------------------------
       // Determine if Lexical or Canonical representation.
       // a) Lexical        yyyy-mm-ddThh:mm:ss.mss-00:00
       // b) Canonical      yyyy-mm-ddThh:mm:ss.mssZ
       // c) Lexical        yyyy-mm-ddThh:mm:ss.mss
       //                   123456789.123456789.123456789

       wkTxt = *blanks;
       StrPos = %scan('T':dateTime);
       Lexical   = *off;
       Canonical = *off;

       if StrPos <> *zero;
          for x = StrPos to %len(%trim(dateTime));
              select;
              when %subst(dateTime:x:1) = '+'    or
                   %subst(dateTime:x:1) = '-'    or
                   %subst(dateTime:x:1) = ' ';
                   Lexical = *on;
                   LexSign = %subst(dateTime:x:1);

              when %subst(dateTime:x:1) = 'Z';
                   Canonical = *on;
              endsl;

              if Lexical                       and
                 %subst(dateTime:x:1) >= '0'   and
                 %subst(dateTime:x:1) <= '9';
                 wkTxt = %trim(wkTxt) + %subst(dateTime:x:1);
              endif;
          endfor;
       endif;

       // Extract hours and minutes.

       select;
       when %len(%trim(wkTxt)) = %len(wkLexHH);
            wkLexHH = num(%subst(wkTxt:1:2));
            wkLexMM = *zero;

       when %len(%trim(wkTxt)) = %len(wkLEX);
            wkLexHH = num(%subst(wkTxt:1:2));
            wkLexMM = num(%subst(wkTxt:3:2));
       endsl;

       wkLEX = num(wkTxt);

       // Convert from HH to HHMM.

       for x = 1 to %len(wkLEX) - %len(%trim(wkTxt));
           wkLEX *= 10;
       endfor;

       // Verify value.

       if not ChkTimHM(wkLEX: '*alwzero': dsErrInfo);
          if %parms = 3;
             p_ErrInfo = dsErrInfo;
          endif;

          return NullTSP;
       endif;

       // -------------------------------------------------------
       // Convert date/time to a timestamp.

       wkTSP = CvtDteTimtoTSP(wkISO:wkHMS);

       // add in milliseconds.

       wkTSP += %mseconds(wkMIL);

       // -------------------------------------------------------
       // If lexical and option is *UTC, convert to *UTC.

       if Lexical                  and
          %scan('*UTC':Options) <> *zero;

          select;
          when LexSign = '+';
               wkTSP += %hours(wkLexHH);
               wkTSP += %minutes(wkLexMM);

          when LexSign = '-';
               wkTSP -= %hours(wkLexHH);
               wkTSP -= %minutes(wkLexMM);
          endsl;
       endif;

       return wkTSP;

      /end-free
     P ExtTSPfromdateTime...
     P                 E
