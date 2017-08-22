      /TITLE Utility, Date/Time clean (SrvPgm)
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
      * ClnDte - Cleanse date if not valid.
      ***********************************************************
     P ClnDte          B                   Export
      *
      * Input values
      *
     D ClnDte          PI                  like(NumISO )
     D  InpISO                             like(NumISO ) value
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
     C                   return    *zero
     C                   endif
      *
      *   Return what was passed if no errors.
      *
     C                   return    InpISO
      *
     P ClnDte          E
      *
      ***********************************************************
      * ClnTim - Cleanse time if not valid.
      ***********************************************************
     P ClnTim          B                   Export
      *
      * Input values
      *
     D ClnTim          PI                  like(NumHMS )
     D  InpHMS                             like(NumHMS ) value
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
     C                   return    *zero
     C                   endif
      *
      *   Return what was passed if no errors.
      *
     C                   return    InpHMS
      *
     P ClnTim          E
