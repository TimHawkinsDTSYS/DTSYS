      /TITLE Utility, Date/Time conversion (SrvPgm)
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
      * CvtISOtoMDY() - Convert from ISO to MDY.
      ***********************************************************
     P CvtISOtoMDY     B                   Export
      *
      * Input values
      *
     D CvtISOtoMDY     PI                  like(NumMDY )
     D  InpISO                             like(NumISO ) value
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      *
      *   Convert from ISO to MDY.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpYYYY  = %subst(AlpISO:1)
     C                   eval      AlpYY    = %subst(AlpISO:3)
     C                   eval      AlpMM    = %subst(AlpISO:5)
     C                   eval      AlpDD    = %subst(AlpISO:7)
     C                   eval      AlpMDY   = AlpMM + AlpDD + AlpYY
     C                   return    num(AlpMDY)
      *
     P CvtISOtoMDY     E
      ***********************************************************
      * CvtISOtoUSA() - Convert from ISO to USA.
      ***********************************************************
     P CvtISOtoUSA     B                   Export
      *
      * Input values
      *
     D CvtISOtoUSA     PI                  like(NumUSA )
     D  InpISO                             like(NumISO ) value
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      *
      *   Convert from ISO to USA.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpYYYY  = %subst(AlpISO:1)
     C                   eval      AlpYY    = %subst(AlpISO:3)
     C                   eval      AlpMM    = %subst(AlpISO:5)
     C                   eval      AlpDD    = %subst(AlpISO:7)
     C                   eval      AlpUSA   = AlpMM + AlpDD + AlpYYYY
     C                   return    num(AlpUSA)
      *
     P CvtISOtoUSA     E
      ***********************************************************
      * CvtISOtoYMD() - Convert from ISO to YMD.
      ***********************************************************
     P CvtISOtoYMD     B                   Export
      *
     D CvtISOtoYMD     PI                  like(NumYMD )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from ISO to YMD.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpYYYY  = %subst(AlpISO:1)
     C                   eval      AlpYY    = %subst(AlpISO:3)
     C                   eval      AlpMM    = %subst(AlpISO:5)
     C                   eval      AlpDD    = %subst(AlpISO:7)
     C                   eval      AlpYMD   = AlpYY + AlpMM + AlpDD
     C                   return    num(AlpYMD)
      *
     P CvtISOtoYMD     E
      ***********************************************************
      * CvtISOtoDte() - Convert from ISO to Date.
      **********************************************************
     P CvtISOtoDte     B                   Export
      *
      * Input values
      *
     D CvtISOtoDte     PI                  like(DteUSA)
     D  InpISO                             like(NumISO) value
      *
     D wkAlpISO        s                   like(AlpISO)  inz
     D wkAlpYYYY       s                   like(AlpYYYY) inz
     D wkAlpMM         s                   like(AlpMM)   inz
     D wkAlpDD         s                   like(AlpDD)   inz
     D wkEdtUSA        s                   like(EdtUSA)  inz
     D wkDteUSA        s                   like(DteUSA)  inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
š1b€ C                   if        InpISO   = *zero
     C                   eval      wkDteUSA = %date('01/01/0001':*USA)
     C                   return    wkDteUSA
š1e€ C                   endif
      *
      *   Convert from ISO to Date.
      *
     C                   eval      wkAlpISO   = %editc(InpISO:'X')
     C                   eval      wkAlpYYYY  = %subst(wkAlpISO:1)
     C                   eval      wkAlpMM    = %subst(wkAlpISO:5)
     C                   eval      wkAlpDD    = %subst(wkAlpISO:7)
     C                   eval      wkEdtUSA   = wkAlpMM + '/' +
     C                                          wkAlpDD + '/' +
     C                                          wkAlpYYYY
      *
     C                   eval      wkDteUSA   = %date(wkEdtUSA:*USA)
     C                   return    wkDteUSA
      *
     P CvtISOtoDte     E
      ***********************************************************
      * CvtYMDtoISO() - Convert from YMD to ISO.
      ***********************************************************
     P CvtYMDtoISO     B                   Export
      *
     D CvtYMDtoISO     PI                  like(NumISO )
     D  InpYMD                             like(NumYMD ) value
      *
      * Standalone fields
      *
     D RtnISO          S                   like(NumISO ) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpYMD = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from YMD to ISO.
      *
     C                   eval      AlpYMD  = %editc(InpYMD:'X')
     C                   eval      AlpYY   = %subst(AlpYMD:1)
     C                   eval      AlpMM   = %subst(AlpYMD:3)
     C                   eval      AlpDD   = %subst(AlpYMD:5)
      *
     C                   eval      NumYY   = num(AlpYY)
     C                   eval      NumYYYY = CvtYYtoYYYY(NumYY)
     C                   eval      AlpYYYY = %editc(NumYYYY:'X')
      *
     C                   eval      AlpISO  = AlpYYYY + AlpMM + AlpDD
     C                   return    num(AlpISO)
      *
     P CvtYMDtoISO     E
      ***********************************************************
      * CvtUSAtoISO() - Convert from USA to ISO.
      ***********************************************************
     P CvtUSAtoISO     B                   Export
      *
     D CvtUSAtoISO     PI                  like(NumISO )
     D  InpUSA                             like(NumUSA ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpUSA = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from USA to ISO.
      *
     C                   eval      AlpUSA   = %editc(InpUSA:'X')
     C                   eval      AlpMM    = %subst(AlpUSA:1)
     C                   eval      AlpDD    = %subst(AlpUSA:3)
     C                   eval      AlpYYYY  = %subst(AlpUSA:5)
     C                   eval      AlpISO   = AlpYYYY + AlpMM + AlpDD
     C                   return    num(AlpISO)
      *
     P CvtUSAtoISO     E
      ***********************************************************
      * CvtMDYtoISO() - Convert from MDY to ISO.
      ***********************************************************
     P CvtMDYtoISO     B                   Export
      *
     D CvtMDYtoISO     PI                  like(NumISO )
     D  InpMDY                             like(NumMDY ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpMDY = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from MDY to ISO.
      *
     C                   eval      AlpMDY   = %editc(InpMDY:'X')
     C                   eval      AlpMM    = %subst(AlpMDY:1)
     C                   eval      AlpDD    = %subst(AlpMDY:3)
     C                   eval      AlpYY    = %subst(AlpMDY:5)
      *
     C                   eval      NumYYYY  = CvtYYtoYYYY(num(AlpYY))
     C                   eval      AlpYYYY  = %editc(NumYYYY:'X')
      *
     C                   eval      AlpISO   = AlpYYYY + AlpMM + AlpDD
     C                   return    num(AlpISO)
      *
     P CvtMDYtoISO     E
      ***********************************************************
      * CvtYYtoYYYY() - Convert from YY to YYYY.
      ***********************************************************
     P CvtYYtoYYYY     B                   Export
      *
     D CvtYYtoYYYY     PI                  like(NumYYYY)
     D  InpYY                              like(NumYY  ) value
      *
     D WindowYY        s                   like(NumYY)
      * ---------------------------------------------------------
      *
      *   Convert from YY to YYYY.
      *
     C                   if        InpYY < 39
     C                   return    2000  + InpYY
     C                   else
     C                   return    1900  + InpYY
     C                   endif
      *
     P CvtYYtoYYYY     E
      ***********************************************************
      * CvtYYYYtoYY() -- Convert from YYYY to YY.
      ***********************************************************
     P CvtYYYYtoYY     B                   Export
      *
     D CvtYYYYtoYY     PI                  like(NumYY)
     D  InpYYYY                            like(NumYYYY  ) value
      * ---------------------------------------------------------
      *
      *   Convert from YYYY to YY.
      *
     C                   if        InpYYYY >= 2000
     C                   return    InpYYYY - 2000
     C                   else
     C                   return    InpYYYY - 1900
     C                   endif
      *
     P CvtYYYYtoYY     E
      ***********************************************************
      * CvtMYtoYYM() -- Convert from MMYY to YYYYMM.
      ***********************************************************
     P CvtMYtoYYM      B                   Export
      *
     D CvtMYtoYYM      PI                  like(NumYYM )
     D  InpMY                              like(NumMY  ) value
      *
      * Standalone fields
      *
     D RtnYYM          S                   like(NumYYM  ) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpMY = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from MMYY to YYYYMM.
      *
     C                   eval      AlpMY    = %editc(InpMY:'X')
     C                   eval      AlpMM    = %subst(AlpMY:1)
     C                   eval      AlpYY    = %subst(AlpMY:3)
      *
     C                   eval      NumYYYY  = CvtYYtoYYYY(num(AlpYY))
     C                   eval      AlpYYYY  = %editc(NumYYYY:'X')
      *
     C                   eval      AlpYYM   = AlpYYYY + AlpMM
     C                   return    num(AlpYYM)
      *
     P CvtMYtoYYM      E
      ***********************************************************
      * CvtYYMtoMY() -- Convert from YYYYMM to MMYY.
      ***********************************************************
     P CvtYYMtoMY      B                   Export
      *
     D CvtYYMtoMY      PI                  like(NumMY  )
     D  InpYYM                             like(NumYYM ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpYYM = *zero
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from YYYYMM to MMYY.
      *
     C                   eval      AlpYYM   = %editc(InpYYM:'X')
     C                   eval      AlpYY    = %subst(AlpYYM:3)
     C                   eval      AlpMM    = %subst(AlpYYM:5)
     C                   eval      AlpMY    = AlpMM + AlpYY
     C                   return    num(AlpMY)
      *
     P CvtYYMtoMY      E
      ***********************************************************
      * CvtTSPtoHMS - Convert from TSP to HMS.
      ***********************************************************
     P CvtTSPtoHMS     B                   Export
      *
     D CvtTSPtoHMS     PI                  like(NumHMS )
     D  InpTSP                             like(TimStp ) value
      *
      * Standalone fields
      *
     D RtnHMS          S                   like(NumHMS) Inz
     D WrkTimHMS       S                   like(TimHMS) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpTSP = *loval
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from TSP to HMS.
      *
     C                   monitor
     C                   move      InpTSP        WrkTimHMS
     C                   move      WrkTimHMS     RtnHMS
      *
     C                   on-error  *program
     C                   return    *zero
     C                   endmon
      *
     C                   return    RtnHMS
      *
     P CvtTSPtoHMS     E
      ***********************************************************
      * CvtTSPtoISO - Convert from TSP to ISO.
      ***********************************************************
     P CvtTSPtoISO     B                   Export
      *
     D CvtTSPtoISO     PI                  like(NumISO )
     D  InpTSP                             like(TimStp ) value
      *
      * Standalone fields
      *
     D WrkDteISO       S                   like(DteISO) inz
     D RtnISO          S                   like(NumISO) inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpTSP = *loval
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from TSP to ISO.
      *
     C                   move      InpTSP        WrkDteISO
     C                   move      WrkDteISO     RtnISO
      *
     C                   return    RtnISO
      *
     P CvtTSPtoISO     E
      ***********************************************************
      * CvtAMPMtoMIL - Convert from AMPM to MIL.
      ***********************************************************
     P CvtAMPMtoMIL    B                   Export
      *
      * Input values
      *
     D CvtAMPMtoMIL    PI                  like(NumHMS )
     D  InpHMS                             like(NumHMS ) value
     D  InpAMPM                            like(AlpAMPM) value
      *
      * Standalone fields
      *
     D WrkHMS          S                   like(TimHMS ) Inz
     D RtnHMS          S                   like(NumHMS ) Inz
      *
      * Conversion: AM/PM to military
      *
     D time010000      S               T   inz(T'01.00.00')
     D time115959      S               T   inz(T'11.59.59')
     D time120000      S               T   inz(T'12.00.00')
     D time125959      S               T   inz(T'12.59.59')
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   return    *zero
     C                   endif
      *
      *   Test HMS input.
      *
     C                   eval      d_TstTim = TstTim(InpHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *zero
     C                   endif
      *
      *   Convert numeric to time.
      *
     C                   monitor
     C                   move      InpHMS        WrkHMS
      *
     C                   on-error  *program
     C                   eval      WrkHMS = *loval
     C                   endmon
      *
      *   Handle inbound AM/PM to military.
      *
     C                   select
     C     InpAMPM       wheneq    'A'
     C     WrkHMS        andge     time120000
     C     WrkHMS        andle     time125959
     C                   subdur    12:*hours     WrkHMS
      *
     C     InpAMPM       wheneq    'P'
     C     WrkHMS        andge     time010000
     C     WrkHMS        andle     time115959
     C                   adddur    12:*hours     WrkHMS
     C                   endsl
      *
      *   Convert from time to numeric.
      *
     C     *hms          move      WrkHMS        RtnHMS
      *
     C                   return    RtnHMS
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P CvtAMPMtoMIL    E
      ***********************************************************
      * CvtDteTimtoTSP - Convert date/time to timestamp.
      ***********************************************************
     P CvtDteTimtoTSP  B                   Export
      *
      * Input values
      *
     D CvtDteTimtoTSP  PI                  like(TimStp)
     D  InpISO                             like(NumISO) value
     D  InpHMS                             like(NumHMS) value
      *
      * Standalone fields
      *
     D WrkDteISO       S                   like(DteISO) inz
     D WrkTimHMS       S                   like(TimHMS) Inz
     D RtnTSP          S                   like(TimStp) inz
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   eval      RtnTSP = *loval
     C                   return    RtnTSP
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
     C                   eval      RtnTSP = *loval
     C                   return    RtnTSP
     C                   endif
      *
     C                   eval      d_TstTim = TstTim(InpHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   eval      RtnTSP = *loval
     C                   return    RtnTSP
     C                   endif
      *
      *   Convert numeric to ISO dates/times.
      *
     C                   monitor
     C     *iso          move      InpISO        WrkDteISO
     C     *hms          move      InpHMS        WrkTimHMS
      *
     C                   on-error  *program
     C                   eval      WrkDteISO = *loval
     C                   eval      WrkTimHMS = *loval
     C                   endmon
      *
      *   Convert dates/times to timestamps.
      *
     C                   move      WrkDteISO     RtnTSP
     C                   move      WrkTimHMS     RtnTSP
      *
     C                   return    RtnTSP
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P CvtDteTimtoTSP  E
      *
      ***********************************************************
      * CvtHMtoHMS - Convert from HM to HMS.
      ***********************************************************
     P CvtHMtoHMS      B                   Export
      *
      * Input values
      *
     D CvtHMtoHMS      PI                  like(NumHMS )
     D  InpHHMM                            like(NumHHMM) value
      *
      *   Test for zero value input.
      *
     C                   if        InpHHMM = *zero
     C                   return    *zero
     C                   endif
      *
      *   Convert from HM to HMS.
      *
     C                   return    InpHHMM * 100
      *
     P CvtHMtoHMS      E
      *
      ***********************************************************
      * CvtHMStoHM - Convert from HMS to HM.
      ***********************************************************
     P CvtHMStoHM      B                   Export
      *
      * Input values
      *
     D CvtHMStoHM      PI                  like(NumHHMM)
     D  InpHMS                             like(NumHMS ) value
      *
      * Standalone fields
      *
     D RtnHHMM         S                   like(NumHHMM) Inz
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   return    *zero
     C                   endif
      *
      *   Convert from HMS to HM.
      *
     C                   moveL     InpHMS        RtnHHMM
      *
     C                   return    RtnHHMM
      *
     P CvtHMStoHM      E
      ***********************************************************
      * CvtHMStoTim() - Convert from HMS to Time.
      **********************************************************
     P CvtHMStoTim     B                   Export
      *
      * Input values
      *
     D CvtHMStoTim     PI                  like(TimHMS)
     D  InpHMS                             like(NumHMS) value
      *
     D wkAlpHMS        s                   like(AlpHMS)  inz
     D wkAlpHH         s                   like(AlpHH)   inz
     D wkAlpMN         s                   like(AlpMN)   inz
     D wkAlpSS         s                   like(AlpSS)   inz
     D wkEdtHMS        s                   like(EdtHMS)  inz
     D wkTimHMS        s                   like(TimHMS)  inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
š1b€ C                   if        InpHMS   = *zero
     C                   eval      wkTimHMS = %time('00:00:00':*HMS)
     C                   return    wkTimHMS
š1e€ C                   endif
      *
      *   Convert from HMS to Time.
      *
     C                   eval      wkAlpHMS   = %editc(InpHMS:'X')
     C                   eval      wkAlpHH    = %subst(wkAlpHMS:1)
     C                   eval      wkAlpMN    = %subst(wkAlpHMS:3)
     C                   eval      wkAlpSS    = %subst(wkAlpHMS:5)
     C                   eval      wkEdtHMS   = wkAlpHH + ':' +
     C                                          wkAlpMN + ':' +
     C                                          wkAlpSS
      *
     C                   eval      wkTimHMS   = %time(wkEdtHMS:*HMS)
     C                   return    wkTimHMS
      *
     P CvtHMStoTim     E
      ***********************************************************
      * CvtMILtoAMPM - Convert from MIL to AMPM.
      ***********************************************************
     P CvtMILtoAMPM    B                   Export
      *
     D CvtMILtoAMPM    PI                  like(d_CvtMILtoAMPM)
     D  InpHMS                             like(NumHMS ) value
      *
      * Standalone fields
      *
     D WrkHMS          S                   like(TimHMS) Inz
      *
      * Conversion: military to AM/PM
      *
     D time000000      S               T   inz(T'00.00.00')
     D time005959      S               T   inz(T'00.59.59')
     D time120000      S               T   inz(T'12.00.00')
     D time130000      S               T   inz(T'13.00.00')
     D time240000      S               T   inz(T'24.00.00')
      * ---------------------------------------------------------
      *
     C                   eval      CvtMILtoAMPM_AMPM = *blanks
     C                   eval      CvtMILtoAMPM_HMS  = *zero
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   return    d_CvtMILtoAMPM
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test HMS input.
      *
     C                   eval      d_TstTim = TstTim(InpHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      msgid  = TstTim_msgid
     C                   eval      msgdta = TstTim_msgdta
     C                   eval      TOrel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    d_CvtMILtoAMPM
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from numeric to time.
      *
     C                   monitor
     C     *hms          move      InpHMS        WrkHMS
     C                   on-error  *program
     C                   eval      WrkHMS = *loval
     C                   endmon
      * ---------------------------------------------------------
      *
      *   Handle outbound military to AM/PM.
      *
     C     WrkHMS        ifge      time120000
     C                   eval      CvtMILtoAMPM_AMPM = 'P'
     C                   else
     C                   eval      CvtMILtoAMPM_AMPM = 'A'
     C                   endif
      *
     C                   select
     C     WrkHMS        whenge    time000000
     C     WrkHMS        andle     time005959
     C                   adddur    12:*hours     WrkHMS
      *
     C     WrkHMS        whenge    time130000
     C     WrkHMS        andle     time240000
     C                   subdur    12:*hours     WrkHMS
     C                   endsl
      *
      *   Convert from time to numeric.
      *
     C     *hms          move      WrkHMS        NumHMS
     C                   eval      CvtMILtoAMPM_HMS = NumHMS
      *
     C                   return    d_CvtMILtoAMPM
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P CvtMILtoAMPM    E
      ***********************************************************
      * CvtAMPMtoHM() -- Convert from AMPM to military time (HM).
      ***********************************************************
     P CvtAMPMtoHM     B                   Export
      *
      * Input values
      *
     D CvtAMPMtoHM     PI                  like(NumHM  )
     D  InpHM                              like(NumHM  ) value
     D  InpAMPM                            like(AlpAMPM) value
      *
      * Standalone fields
      *
     D WrkHMS          S                   like(NumHMS ) Inz
     D RtnHM           S                   like(NumHM  ) Inz
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHM = *zero
     C                   return    *zero
     C                   endif
      *---------------------------------------------------------
      *
      *   Convert HM to HMS.
      *
     C                   eval      WrkHMS = CvtHMtoHMS(InpHM)
      *
      *   Convert from AMPM to Military time.
      *
     C                   eval      WrkHMS = CvtAMPMtoMil(WrkHMS:InpAMPM)
      *
      *   Convert HMS to HM.
      *
     C                   eval      RtnHM = CvtHMStoHM(WrkHMS)
      *
     C                   return    RtnHM
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P CvtAMPMtoHM     E
      ***********************************************************
      * CvtMintoHM() -- Convert minutes to hours/minutes.
      ***********************************************************
     P CvtMintoHM      B                   Export
      *
      * Input values
      *
     D CvtMintoHM      PI                  like(NumHM  )
     D  InpMin                             like(StdInt ) value
      *
      * Standalone fields
      *
     D WrkMN           S                   like(NumMN  ) Inz
     D WrkSS           S                   like(NumSS  ) Inz
     D RtnHM           S                   like(NumHM  ) Inz
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpMin = *zero
     C                   return    *zero
     C                   endif
      *---------------------------------------------------------
      *
      *   Convert elapsed minutes to hours/minutes.
      *
     C                   eval      WrkHH = InpMin / 60
     C                   eval      WrkMN = InpMin - (WrkHH * 60)
      *
      *   Convert hours/minutes to HM.
      *
     C                   eval      RtnHM = (WrkHH * 100) + WrkMN
      *
     C                   return    RtnHM
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P CvtMintoHM      E
      ***********************************************************
      * CvtTSPtoMDY - Convert from TSP to MDY.
      ***********************************************************
     P CvtTSPtoMDY     B                   Export
      *
     D CvtTSPtoMDY     PI                  like(NumMDY )
     D  InpTSP                             like(TimStp ) value
      *
      * Standalone fields
      *
     D WrkDteISO       s                   like(DteISO) inz
     D RtnMDY          s                   like(NumMDY) inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpTSP = *loval
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from TSP to MDY.
      *
     C                   move      InpTSP        WrkDteISO
     C     *MDY          move      WrkDteISO     RtnMDY
      *
     C                   return    RtnMDY
      *
     P CvtTSPtoMDY     E
      ***********************************************************
      * CvtCYYMMDDtoISO() - Convert CYYMMDD to ISO.
      ***********************************************************
     P CvtCYYMMDDtoISO...
     P                 B                   Export
      *
     D CvtCYYMMDDtoISO...
     D                 PI                  like(NumISO)
     D  InpCYYMMDD                    7  0 const
      *
     D AlpCYYMMDD      DS                  qualified
     D  C                             1    overlay(AlpCYYMMDD:*next)
     D  YY                            2    overlay(AlpCYYMMDD:*next)
     D  MM                            2    overlay(AlpCYYMMDD:*next)
     D  DD                            2    overlay(AlpCYYMMDD:*next)
      /free
       // -------------------------------------------------------
       // Test for zero value input.

       if InpCYYMMDD = *zero;
          return *zero;
       endif;

       // -------------------------------------------------------
       // Convert CYYMMDD to ISO.

       AlpCYYMMDD = %char(InpCYYMMDD);

       if AlpCYYMMDD.C = '0';
          AlpYYYY = '19' + AlpCYYMMDD.YY;
       else;
          AlpYYYY = '20' + AlpCYYMMDD.YY;
       endif;

       AlpISO = AlpYYYY + AlpCYYMMDD.MM + AlpCYYMMDD.DD;

       return num(AlpISO);

      /end-free
     P CvtCYYMMDDtoISO...
     P                 E
      ***********************************************************
      * OfsUTCtsp() -- Offset UTC timestamp.
      ***********************************************************
     P OfsUTCtsp       B                   Export
      *
     D OfsUTCtsp       PI                  like(TimStp)
     D  InpUTC                             like(TimStp) const
      *
     D RtnTSP          s                   like(TimStp) inz
     D hours           s                   like(StdInt)
     D mins            s                   like(StdInt)
     D FSecs           s                   like(StdDblFlt)
     D Secs            s             20  0
      /free
       // -------------------------------------------------------
       // Get UTC offset.

       CEEUTCO(hours: mins: FSecs);
       Secs = FSecs;

       // -------------------------------------------------------
       // Offset the timestamp.

       RtnTSP = InpUTC + %seconds(secs);

       return RtnTSP;

      /end-free
     P OfsUTCtsp       E
      * **********************************************************
      *  CvtISOHMStodateTime() - Convert ISO/HMS to dateTime.
      *  -- Format is: yyyy-mm-ddThh.mm.ss.nn
      * **********************************************************
     P CvtISOHMStodateTime...
     P                 B                   Export
      *
     D CvtISOHMStodateTime...
     D                 PI                  like(StdTxt)
     D  InpISO                             like(NumISO) const
     D  InpHMS                             like(NumHMS) const
      *
     D WrkISO          s                   like(AlpISO) inz
     D WrkHMS          s                   like(AlpHMS) inz
     D dateTime        s                   like(StdTxt) inz
      /free
       // -------------------------------------------------------
       // Test for zero value input.

       if InpISO = *zero   and
          InpHMS = *zero;
          return   *blanks;
       endif;

       // -------------------------------------------------------
       // Convert from ISO/HMS to dateTime.
       // -- WEX format is: yyyy-mm-ddThh.mm.ss.ms

       WrkISO   = %editc(InpISO:'X');
       WrkHMS   = %editc(InpHMS:'X');

       dateTime = %subst(WrkISO:1:4) + '-' +
                  %subst(WrkISO:5:2) + '-' +
                  %subst(WrkISO:7:2) + 'T' +
                  %subst(WrkHMS:1:2) + '.' +
                  %subst(WrkHMS:3:2) + '.' +
                  %subst(WrkHMS:5:2) + '.00';

       return dateTime;

      /end-free
     P CvtISOHMStodateTime...
     P                 E
