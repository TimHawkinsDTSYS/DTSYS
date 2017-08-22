      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Credit Card prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /if not defined(t_bkgpi)
      /define t_bkgpi
     D t_bkgpi       e ds                  extname(bkgpip01)
     D                                     qualified template
      /endif
      * ---------------------------------------------------------
      * RtvCreCrdCo() -- Retrieve credit card company.
      *
     D RtvCreCrdCo     pr                  like(t_bkgpi.BPccco)
     D  CrdNbr                             like(t_bkgpi.BPpmtdcr) const
      * ---------------------------------------------------------
      * MskCreCrdNbr() -- Mask credit card number.
      *
     D MskCreCrdNbr    PR                  like(t_bkgpi.BPpmtdcr)
     D  i_CreCrdNbr                        like(t_bkgpi.BPpmtdcr) const
      * ---------------------------------------------------------
      * MskPmtDcr() - Mask payment number decrypted.
      *
     D MskPmtDcr       PR                  like(dfnBPpmtdcr)
     D  ChrValue                           like(dfnBPpmtdcr) const
