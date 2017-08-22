      /TITLE Utility, Credit Cards (SrvPgm)
      *PARMS ALWCPYDTA(*optimize) COMMIT(*none)
      *PARMS RPGPPOPT(*lvl2)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides for credit card related routines via function
      *              calls.
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
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      *
      * *********************************************************
      * RtvCreCrdCo() -- Retrieve credit card company.
      * *********************************************************
     P RtvCreCrdCo     b                   export
      *
     D RtvCreCrdCo     pi                  like(t_bkgpi.BPccco)
     D  CreCrdNbr                          like(t_bkgpi.BPpmtdcr) const

     D  CreCrdCo       s                   like(t_bkgpi.BPccco)

      /free

       EXEC SQL select CXcmpcde into :CreCrdCo
                  from ctlcpp01
                 where substr(:CreCrdNbr, 1, length(trim(CXcrdpfx)))
                     = substr(CXcrdpfx,   1, length(trim(CXcrdpfx)))
                   and length(trim(:CreCrdNbr)) = CXcrdlen;

       return CreCrdCo;

      /end-free

     P RtvCreCrdCo     e
      ***********************************************************
      * MskCreCrdNbr() -- Mask credit card number.
      ***********************************************************
     P MskCreCrdNbr    B                   Export
      *
     D MskCreCrdNbr    PI                  like(t_bkgpi.BPpmtdcr)
     D  i_CreCrdNbr                        like(t_bkgpi.BPpmtdcr) const
      *
     D o_CreCrdNbr     s                   like(t_bkgpi.BPpmtdcr) inz
     D x               s                   like(StdInt)           inz
      * ---------------------------------------------------------
      *
      *    Return if nothing passed.
      *
     C                   if        i_CreCrdNbr = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Mask all but the first 6 bytes, and last 4 bytes.
      *
     C                   eval      o_CreCrdNbr = i_CreCrdNbr
      *
     C                   for       x = 1 to %len(%trim(o_CreCrdNbr))
      *
     C                   if        x >  6                              and
     C                             x <= %len(%trim(o_CreCrdNbr)) - 4   and
     C                             %subst(o_CreCrdNbr:x:1) <> *blanks
     C                   eval      %subst(o_CreCrdNbr:x:1)  = 'x'
     C                   endif
     C                   endfor
      *
     C                   return    o_CreCrdNbr
      *
     P MskCreCrdNbr    E
      ***********************************************************
      * MskPmtDcr() - Mask payment number decrypted.
      ***********************************************************
     P MskPmtDcr       B                   Export
      *
     D MskPmtDcr       PI                  like(dfnBPpmtdcr)
     D  ChrValue                           like(dfnBPpmtdcr) const
      *
     D RtnPmtDcr       s                   like(dfnBPpmtdcr) inz
     D x               s                   like(StdInt)      inz
     D y               s                   like(StdInt)      inz
      * ---------------------------------------------------------
      *
      *    Mask all but the first 6 bytes, and last 4 bytes.
      *
     C                   eval      RtnPmtDcr = ChrValue
      *
     C                   for       x = 1 to %len(RtnPmtDcr)
      *
     C                   if        %subst(RtnPmtDcr:x:1) <> *blanks
     C                   eval      y += 1
     C                   endif
      *
     C                   if        y  > 6                       and
     C                             x <= %len(RtnPmtDcr) - 4     and
     C                             %subst(RtnPmtDcr:x:1) <> *blanks
     C                   eval      %subst(RtnPmtDcr:x:1)  = 'x'
     C                   endif
     C                   endfor
      *
     C                   return    RtnPmtDcr
      *
     P MskPmtDcr       E
