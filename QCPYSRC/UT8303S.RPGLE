      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PNR prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      * SetPnrDlm() -- Set PNR delimiter.
      *
     D SetPnrDlm       PR                  like(dfnBAcurpnr)
     D  CurPnr                             like(dfnBAcurpnr)   const
      * ---------------------------------------------------------
      *
      * SetPrvPnr() -- Set previous PNR.
      *
     D SetPrvPnr       PR                  like(dfnBAprvpnr)
     D  CurPnr                             like(dfnBAcurpnr)   const
     D  pvCurPnr                           like(dfnBAcurpnr)   const
     D  PrvPnr                             like(dfnBAprvpnr)   const
