      /TITLE Utility, Date/Time validate (SrvPgm)
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
      * ChkDte - Check date for validity.
      ***********************************************************
     P ChkDte          B                   Export
      *
      * Input values
      *
     D ChkDte          PI                  like(d_ChkDte)
     D  InpISO                             like(NumISO ) value
     D  out_errinfo                        likeDS(DSerrinfo)
     D                                     options(*omit: *nopass)
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero  or
     C                             InpISO = *hival
     C                   eval      ChkDte_MSGID = 'GNL0023'
     C                   eval      ChkDte_MSGDTA = %editc(InpISO:'X')
     C                   return    d_ChkDte
     C                   endif
      *
      *   Test ISO input.
      *
     C                   eval      d_TstDte = TstDte(InpISO)
     C                   if        TstDte_msgid <> *blanks
     C                   eval      ChkDte_msgid  = TstDte_msgid
     C                   eval      ChkDte_msgdta = TstDte_msgdta
     C                   return    d_ChkDte
     C                   endif
      *
     C                   return    *blanks
      *
      /UNDEFINE $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P ChkDte          E
      ***********************************************************
      * ChkTim - Check time for validity.
      ***********************************************************
     P ChkTim          B                   Export
      *
      * Input values
      *
     D ChkTim          PI                  like(d_RtnMsg)
     D  InpHMS                             like(NumHMS ) value
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero  or
     C                             InpHMS = *hival
     C                   eval      RtnMsgid  = 'GNL0014'
     C                   eval      RtnMsgdta = %editc(InpHMS:'X')
     C                   return    d_RtnMsg
     C                   endif
      *
      *   Test HMS input.
      *
     C                   eval      d_TstTim = TstTim(InpHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      RtnMsgid  = 'GNL0014'
     C                   eval      RtnMsgdta = %editc(InpHMS:'X')
     C                   return    d_RtnMsg
     C                   endif
      *
     C                   return    *blanks
      *
     P ChkTim          E
      ***********************************************************
      * ChkTimAMPM - Check time for validity.
      ***********************************************************
     P ChkTimAMPM      B                   Export
      *
      * Input values
      *
     D ChkTimAMPM      PI                  like(d_RtnMsg)
     D  InpHMS                             like(NumHMS ) value
     D  InpAMPM                            like(AlpAMPM) value
      *
      * Standalone fields
      *
     D WrkHMS          S                   like(TimHMS ) Inz
      *
      * Conversion: AM/PM to military
      *
     D time010000      S               T   inz(T'01.00.00')
     D time115959      S               T   inz(T'11.59.59')
     D time120000      S               T   inz(T'12.00.00')
     D time125959      S               T   inz(T'12.59.59')
      *---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   eval      RtnMsgid  = 'GNL0014'
     C                   eval      RtnMsgdta =
     C                             %editc(InpHMS:'X') + ' ' + InpAMPM
     C                   return    d_RtnMsg
     C                   endif
      *
      *   Test HMS input.
      *
     C                   eval      d_TstTim = TstTim(InpHMS)
     C                   if        TstTim_msgid <> *blanks
     C                   eval      Rtnmsgid  = TstTim_msgid
     C                   eval      RtnMsgdta =
     C                             %editc(InpHMS:'X') + ' ' + InpAMPM
     C                   return    d_RtnMsg
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
      *   Check combination of AMPM and time.
      *
     C     InpAMPM       ifeq      'A'
     C     WrkHMS        andgt     time125959
     C     InpAMPM       oreq      'P'
     C     WrkHMS        andgt     time125959
     C     InpAMPM       oreq      'N'
     C     WrkHMS        andne     time120000
     C                   eval      RtnMsgid  = 'GNL0014'
     C                   eval      RtnMsgdta =
     C                             %editc(InpHMS:'X') + ' ' + InpAMPM
     C                   return    d_RtnMsg
     C                   endif
      *
     C                   return    *blanks
      *
     P ChkTimAMPM      E
      ***********************************************************
      * ChkTimHM - Check time for validity.
      ***********************************************************
     P ChkTimHM        B                   Export
      *
      * Input values
      *
     D ChkTimHM        PI                  like(d_RtnMsg)
     D  InpHM                              like(NumHM  ) value
      *---------------------------------------------------------
      *
      *   Convert HM into HMS.
      *
     C                   eval      NumHMS = InpHM * 100
      *
      *   Check the time.
      *
     C                   eval      d_RtnMsg  = ChkTim(NumHMS)
     C                   if        RtnMsgid <> *blanks
     C                   eval      RtnMsgid  = 'GNL0014'
     C                   eval      RtnMsgdta = %editc(NumHMS:'X')
     C                   return    d_RtnMsg
     C                   endif
      *
     C                   return    *blanks
      *
     P ChkTimHM        E
      ***********************************************************
      * ChkTimHMAMPM - Check time for validity.
      ***********************************************************
     P ChkTimHMAMPM    B                   Export
      *
      * Input values
      *
     D ChkTimHMAMPM    PI                  like(d_RtnMsg)
     D  InpHM                              like(NumHM  ) value
     D  InpAMPM                            like(AlpAMPM) value
      *---------------------------------------------------------
      *
      *   Convert HM into HMS.
      *
     C                   eval      NumHMS = InpHM * 100
      *
      *   Check the time.
      *
     C                   eval      d_RtnMsg = ChkTimAMPM(NumHMS:InpAMPM)
      *
     C                   return    d_RtnMsg
      *
     P ChkTimHMAMPM    E
      ***********************************************************
      * TstDte - Test date for validity.
      ***********************************************************
     P TstDte          B                   Export
      *
      * Input values
      *
     D TstDte          PI                  like(d_TstDte)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      *   Clear return parameters.
      *
     C                   eval      TstDte_msgid  = *blanks
     C                   eval      tstDte_msgdta = *blanks
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test ISO input.
      *
     C     *iso          test(D E)               InpISO
     C                   if        %error
     C                   eval      TstDte_msgid  = 'GNL0023'
     C                   eval      TstDte_msgdta = %editc(InpISO:'X')
     C                   return    d_TstDte
     C                   endif
      *
     C                   return    *blanks
      *
     P TstDte          E
      ***********************************************************
      * TstTim - Test time for validity.
      ***********************************************************
     P TstTim          B                   Export
      *
      * Input values
      *
     D TstTim          PI                  like(d_TstTim)
     D  InpHMS                             like(NumHMS) value
      *
     D WindowHMS       s                   like(NumHMS) inz
      * ---------------------------------------------------------
      *
      *   Clear return parameters.
      *
     C                   eval      TstTim_msgid  = *blanks
     C                   eval      tstTim_msgdta = *blanks
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Test HMS input.
      *
     C     *HMS          test(t E)               InpHMS
     C                   if        %error
     C                   eval      TstTim_msgid  = 'GNL0014'
     C                   eval      TstTim_msgdta = %editc(InpHMS:'X')
     C                   return    d_TstTim
     C                   endif
      *
     C                   return    *blanks
      *
     P TstTim          E
