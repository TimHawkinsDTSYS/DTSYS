      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Booking DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  RtvNxtIseq() -- Retrieve next itinerary sequence.
      *
     D RtvNxtIseq      PR                  like(DFNbmlisq)
     D  RtvNxtIseqBkgm...
     D                                     like(DFNbkgma)
      * ---------------------------------------------------------
      *  RstHisbmBkgma() -- Restore history to booking master.
      *
     D RstHisbmBkgma   PR                  like(DFNbkgma)
     D  hisbm                              like(DFNhisbm) value
      * ---------------------------------------------------------
      *  ClrBkgmaCostSummary() -- Clear booking master cost summary.
      *
     D ClrBkgmaCostSummary...
     D                 PR                  like(DFNbkgma)
     D  bkgma                              like(DFNbkgma) value
      * ---------------------------------------------------------
      * RtvNamAdrOfBkg() -- Retrieve name and address of booking.
      *
     D RtvNamAdrOfBkg  PR                  like(t_RtvNamAdrOfBkg)
     D  BMbkgn                             like(dfnBMbkgn)
     D  Options                            like(StdStr) const
     D                                     options(*nopass)
      *
     D t_RtvNamAdrOfBkg...
     D                 DS                  qualified template
     D  NAsnddoc                           like(dfnBMsnddoc)
     D  NApaxnam                           like(dfnAMname)
     D  NAname                             like(dfnAMname)
     D  NAadr1                             like(dfnAMadr1)
     D  NAadr2                             like(dfnAMadr2)
     D  NAadr3                             like(dfnAMadr3)
     D  NAcity                             like(dfnAMcity)
     D  NAstcd                             like(dfnAMstcd)
     D  NApscd                             like(dfnAMpscd)
     D  NActry                             like(dfnAMctry)
     D  NAadrary                           like(dfnAMadr1) dim(10)
     D  NAphon                             like(dfnAMphon)
     D  NAemail                            like(dfnAMemail)
     D  NAadrtyp                           like(Stdtxt)
      * ---------------------------------------------------------
      * ChkSegErr() - Check for segment errors.
      *
     D ChkSegErr       PR                  like(StdInd)
     D  BkgID                              like(dfnBMbkgn) const
      * ---------------------------------------------------------
      * AcmPndPay() - Accumulate pending payments.
      *
     D AcmPndPay       PR                  like(DFNbmrcvttl)
     D  bkgma                              like(DFNbkgma) value
      * ---------------------------------------------------------
      * FmtFltDes() -- Format flight description.
      *
     D FmtFltDes       PR                  like(StdTxt)
     D  i_bkgaf                            like(DFNbkgaf) const
     D  i_fmtcde                           like(StdChr)   const
      * ---------------------------------------------------------
      * RtvBkgEmail() -- Retrieve main booking email address.
      * -- options = *AGYINV=Agency invoice
      * --           *CUSINV=Customer invoice
      *
     D RtvBkgEmail     PR                  like(dfnAMemail)
     D  BMbkgn                             like(dfnBMbkgn)
     D  Options                            like(StdStr) const
     D                                     options(*nopass)
