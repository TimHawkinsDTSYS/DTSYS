      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/time extract prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  Prototype for CatDat
      *
     D CatDat          PR                  like(NumISO)
     D  InpYYYY                            like(NumYYYY) value
     D  InpMM                              like(NumMM  ) value
     D  InpDD                              like(NumDD  ) value
      * ---------------------------------------------------------
      *
      *  ExtractDate() -- Extract date elements.
      *
     D ExtractDate     PR                  like(d_ExtractDate)
     D  InpISO                             like(NumISO ) value
      *
     D d_ExtractDate   DS
     D ExtractDate_YYYY...
     D                                     like(NumYYYY) inz
     D ExtractDate_CC                      like(NumCC  ) inz
     D ExtractDate_YY                      like(NumYY  ) inz
     D ExtractDate_MM                      like(NumMM  ) inz
     D ExtractDate_DD                      like(NumDD  ) inz
      * ---------------------------------------------------------
      *
      *  ExtractTime() -- Extract time elements.
      *
     D ExtractTime     PR                  like(d_ExtractTime)
     D  InpHMS                             like(NumHMS ) value
      *
     D d_ExtractTime   DS
     D ExtractTime_HH                      like(NumHH ) inz
     D ExtractTime_MN                      like(NumMN ) inz
     D ExtractTime_SS                      like(NumSS ) inz
      * ---------------------------------------------------------
      *
      *  DayofWeek() -- Return day of week.
      *
     D DayofWeek       PR                  like(d_DayofWeek)
     D  InpISO                             like(NumISO ) value
      *
     D d_DayofWeek     DS
     D  DayofWeek_DayN...
     D                                1  0 inz
     D  DayofWeek_Daytext2...
     D                                2    inz
     D  DayofWeek_Daytext3...
     D                                3    inz
     D  DayofWeek_Daytext9...
     D                                9    inz
      * ---------------------------------------------------------
      *
      *  DaysinMonth() -- Return days in the month.
      *
     D DaysinMonth     PR                  like(NumDD  )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *  FirstDateinMonth() -- First date in month.
      *
     D FirstDateInMonth...
     D                 PR                  like(NumISO)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *  LastDateinMonth() -- Last date in month.
      *
     D LastDateInMonth...
     D                 PR                  like(NumISO)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *  FirstDateinYear() -- First date in year.
      *
     D FirstDateInYear...
     D                 PR                  like(NumISO)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *  LastDateinYear() -- Last date in year.
      *
     D LastDateInYear...
     D                 PR                  like(NumISO)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *  WeekofYear() -- Return week number of the year.
      *
     D WeekofYear      PR                  like(Week   )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *  QuarterofYear() -- Return quarter number of year.
      *
     D QuarterofYear   PR                  like(Quarter)
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *  AlphaMonth() -- Return name of the month.
      *
     D AlphaMonth      PR                  like(AlpMMM )
     D  InpMM                              like(NumMM  ) value
      * ---------------------------------------------------------
      *
      *  RtvMthNam() -- Retrieve month name.
      *
     D RtvMthNam       PR             9
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *  RtvLongDate() -- Retrieve long date.
      *
     D RtvLongDate     PR            30
     D  InpISO                             like(NumISO ) value
     D  InpOption                          like(StdNam)  const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *  Prototype for Calculate day of week.
      *
     D CEEDYWK         PR                  extproc('CEEDYWK')
     D  LillianDate                  10i 0 const
     D  DayofWeek                    10i 0
     D  ErrorCode                   116    options(*omit)
      * ---------------------------------------------------------
      *  ExtTSPfromdateTime() - Extract TSP from dateTime.
      *
     D ExtTSPfromdateTime...
     D                 PR                  like(StdTsp)
     D  dateTime                           like(StdTxt) const
     D  Options_p                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  p_ErrInfo                          likeDS(dsErrInfo)
     D                                     options(*omit:*nopass)
