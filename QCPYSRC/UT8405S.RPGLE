      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/time validate prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  ChkDte() -- Check date.
      *
     D ChkDte          PR                  like(d_ChkDte)
     D  InpISO                             like(NumISO ) value
     D  out_errinfo                        likeDS(DSerrinfo)
     D                                     options(*omit: *nopass)
      *
     D d_ChkDte        DS
     D ChkDte_MSGID                        like(Std_msgid)
     D ChkDte_MSGDTA                       like(Std_msgdta)
      * ---------------------------------------------------------
      *
      *  ChkTim() -- Check time.
      *
     D ChkTim          PR                  like(d_RtnMsg)
     D  InpHMS                             like(NumHMS ) value
      * ---------------------------------------------------------
      *
      *  ChkTimHM() -- Check time in HHMM format.
      *
     D ChkTimHM        PR                  like(d_RtnMsg)
     D  InpHM                              like(NumHM  ) value
      * ---------------------------------------------------------
      *
      *  ChkTimAMPM() -- Check time and AM/PM
      *
     D ChkTimAMPM      PR                  like(d_RtnMsg)
     D  InpHMS                             like(NumHMS ) value
     D  InpAMPM                            like(AlpAMPM) value
      * ---------------------------------------------------------
      *
      *  ChkTimHMAMPM() -- Check time in HMx format.
      *
     D ChkTimHMAMPM    PR                  like(d_RtnMsg)
     D  InpHM                              like(NumHM  ) value
     D  InpAMPM                            like(AlpAMPM) value
      * ---------------------------------------------------------
      *
      *  TstDte() -- Test date
      *
     D TstDte          PR                  like(d_TstDte)
     D  InpISO                             like(NumISO ) value
      *
     D d_TstDte        DS
     D TstDte_msgid                        like(Std_msgid)
     D TstDte_msgdta                       like(Std_msgdta)
      * ---------------------------------------------------------
      *
      *  TstTim() -- Test time.
      *
     D TstTim          PR                  like(d_TstTim)
     D  InpHMS                             like(NumHMS ) value
      *
     D d_TstTim        DS
     D TstTim_msgid                        like(Std_msgid)
     D TstTim_msgdta                       like(Std_msgdta)
