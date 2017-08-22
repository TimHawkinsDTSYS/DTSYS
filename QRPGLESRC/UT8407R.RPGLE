      /TITLE Utility, Date/Time increment (SrvPgm)
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
      * AddSeconds - Add seconds to date/time.
      ***********************************************************
     P AddSeconds      B                   Export
      *
      * Input values
      *
     D AddSeconds      PI                  like(d_AddSeconds)
     D  InpISO                             like(NumISO ) value
     D  InpHMS                             like(NumHMS ) value
     D  InpSecs                            like(Secs   ) value
      *
      * Standalone fields
      *
     D bgndat          S                   like(DteISO)
     D enddat          S                   like(DteISO)
     D bgntim          S                   like(TimHMS)
     D endtim          S                   like(TimHMS)
     D bgndattim       S                   like(TimStp)
     D enddattim       S                   like(TimStp)
      *---------------------------------------------------------
      *
      *   Clear return value.
      *
     C                   reset                   d_AddSeconds
      *
      *   Test for zero value input.
      *
     C                   if           InpISO = *zero
     C                             or InpHMS = *zero
     C                   return    d_AddSeconds
     C                   endif
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      msgid  = TstDte_msgid
     C                   eval      msgdta = TstDte_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    d_AddSeconds
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   exsr      $PMsnd
     C                   eval      TOrel  = '*PRV'
     C                   return    d_AddSeconds
     C                   endif
      *
      *   Convert numeric to ISO timestamp.
      *
     C                   monitor
     C     *iso          move      InpISO        bgndat
     C     *hms          move      InpHMS        bgntim
      *
     C                   on-error  *program
     C                   eval      BgnDat = *loval
     C                   eval      BgnTim = *loval
     C                   endmon
      *
     C                   move      bgndat        bgndattim
     C                   move      bgntim        bgndattim
      *
      *   Add/subtract number of seconds.
      *
     C     InpSecs       ifgt      *zero
     C     bgndattim     adddur    InpSecs:*S    enddattim
     C                   else
     C                   eval      InpSecs  = InpSecs * -1
     C     bgndattim     subdur    InpSecs:*S    enddattim
     C                   endif
      *
      *   Extract date/time from end date/time timestamp.
      *
     C                   move      enddattim     enddat
     C                   move      enddattim     endtim
      *
      *   Move back to parameters.
      *
     C                   move      enddat        AddSeconds_ISO
     C                   move      endtim        AddSeconds_HMS
      *
     C                   return    d_AddSeconds
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P AddSeconds      E
      ***********************************************************
      * AddDays() - Add number of days to a date.
      ***********************************************************
     P AddDays         B                   Export
      *
      * Input values
      *
     D AddDays         PI                  like(NumISO )
     D  InpISO                             like(NumISO ) value
     D  InpDays                            like(Days   ) value
      *
      * Standalone fields
      *
     D WrkDteISO       S                   like(DteISO) inz
     D RtnISO          S                   like(NumISO) inz
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
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
     C     *iso          move      InpISO        WrkDteISO
      *
     C                   on-error  *program
     C                   eval      WrkDteISO = *loval
     C                   endmon
      *
      *   Add/subtract number of days.
      *
     C     InpDays       ifgt      *zero
     C                   adddur    InpDays:*D    WrkDteISO
     C                   else
     C                   eval      InpDays = InpDays * -1
     C                   subdur    InpDays:*D    WrkDteISO
     C                   endif
      *
      *   Convert from date to numeric.
      *
     C     *iso          move      WrkDteISO     RtnISO
      *
     C                   return    RtnISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P AddDays         E
      ***********************************************************
      * AddMonths - Calculate adding months to a date.
      ***********************************************************
     P AddMonths       B                   Export
      *
      * Input values
      *
     D AddMonths       PI                  like(NumISO )
     D  InpISO                             like(NumISO ) value
     D  InpMonths                          like(Months ) value
      *
      * Standalone fields
      *
     D RtnISO          S                   like(NumISO) inz
     D WrkDteISO       S                   like(DteISO) inz
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
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
     C     *iso          move      InpISO        WrkDteISO
      *
     C                   on-error  *program
     C                   eval      WrkDteISO = *loval
     C                   endmon
      *
      *   Add/subtract number of months.
      *
     C     InpMonths     ifgt      *zero
     C                   adddur    InpMonths:*M  WrkDteISO
     C                   else
     C                   eval      InpMonths  = -InpMonths
     C                   subdur    InpMonths:*M  WrkDteISO
     C                   endif
      *
      *   Convert from date to numeric.
      *
     C     *iso          move      WrkDteISO     RtnISO
      *
     C                   return    RtnISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P AddMonths       E
      ***********************************************************
      * AddYears - Calculate adding years to a date.
      ***********************************************************
     P AddYears        B                   Export
      *
      * Input values
      *
     D AddYears        PI                  like(NumISO )
     D  InpISO                             like(NumISO ) value
     D  InpYears                           like(Days   ) value
      *
      * Standalone fields
      *
     D RtnISO          s                   like(NumISO ) Inz
     D WrkYears        s                   like(NumISO ) Inz
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      *
      *   Add/subtract number of years.
      *
     C                   eval      RtnISO = InpISO + (InpYears * 10000)
      *
     C                   return    RtnISO
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P AddYears        E
      ***********************************************************
      * AdjTimeStamp() -- Adjust timestamp to local time.
      ***********************************************************
      * Create Function xxxxx/AdjTS
      * (parmTimeStamp   Timestamp,
      *  parmInTimeZone  Char(10),
      *  parmOutTimeZone Char(10))
      * Returns TimeStamp
      * Language RPGLE
      * External Name 'xxxxx/ADJTS(ADJTIMESTAMP)'
      * Parameter Style General
      *
     P AdjTimeStamp    B                   Export

     D AdjTimeStamp    PI                  like(StdTms)
     D  parmInputTS                        like(StdTms) const
     D  parmInputTZ                        like(StdNam) const
     D  parmOutputTZ                       like(StdNam) const

     DCvtDateTimeFmt   PR                  ExtPgm('QWCCVTDT')
     D InputFormat                         like(StdNam)        const
     D InputTS                             LikeDS(dsDateStruc) const
     D OutputFormat                        like(StdNam)        const
     D OutputTS                            LikeDS(dsDateStruc)
     D dsErrCode                           LikeDS(dsErrCode)
     D InputTZ                             like(StdNam)        const
     D OutputTZ                            like(StdNam)        const
     D TimeZoneInfo                        LikeDS(dsTimeZone)
     D TimeZoneInfoL                       like(StdInt)        const
     D PrecisionInd                        like(StdChr)        const

     DdsErrCode        DS                  Qualified
     D BytesProvided                       like(StdInt)
     D                                     Inz(%Size(dsErrCode.MsgData))
     D BytesAvail                          like(StdInt)
     D ExceptionID                    7
     D Reserved                            like(StdChr)
     D MsgData                      128

     DdsDateStruc      DS                  Qualified
     D Date                           8S 0
     D Time                           6S 0
     D MilliSec                       6S 0

     D InputStruc      DS                  LikeDS(dsDateStruc) Inz
     D OutputStruc     DS                  LikeDS(dsDateStruc) Inz

     D dsTimeZone      DS                  Qualified
     D  BytesReturned                      like(StdInt)
     D  BytesAvail                         like(StdInt)
     D  TimeZoneName                       like(StdNam)
     D  Reserved1                          like(StdChr)
     D  DaylightSave                       like(StdChr)
     D  CurOffset                          like(StdInt)
     D  CurFullName                        like(StdTxt)
     D  CurAbbrName                        like(StdTxt)
     D  MsgFile                            like(StdNam)
     D  MsgFileLib                         like(StdNam)

     DWrkTimeStamp     S             26
      /Free

         InputStruc.Date     = %Int(%Char(%Date(parmInputTS):*ISO0));
         InputStruc.Time     = %Int(%Char(%Time(parmInputTS):*ISO0));
         InputStruc.MilliSec = %SubDt(parmInputTS:*MS);

         CvtDateTimeFmt('*YYMD':
                        InputStruc:
                        '*YYMD':
                        OutputStruc:
                        dsErrCode:
                        parmInputTZ:
                        parmOutputTZ:
                        dsTimeZone:
                        %Size(dsTimeZone):
                        (InputStruc.MilliSec>0));

         WrkTimeStamp= %Char(%Date(OutputStruc.Date:*ISO):*ISO) + '-' +
                       %Char(%Time(OutputStruc.Time:*ISO):*ISO) + '.' +
                       %EditC(OutputStruc.MilliSec:'X');

         Return %TimeStamp(WrkTimeStamp);

      /End-Free
      *
     P AdjTimeStamp    E
