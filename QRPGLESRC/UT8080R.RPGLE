      /TITLE Utility, System Directory (SrvPgm)
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
      *define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8080S
      * *********************************************************
      * RtvSmtpAddr() -- Retrieve SMTP Address.
      * *********************************************************
      *
      *
     P RtvSmtpAddr     B                   export
      *
     D RtvSmtpAddr     Pi           321a
     D  PxUser                             like(StdNam) const
     D  PxAddr                             like(StdFmt) const
     D                                     options(*nopass)
      *
      * -- API error data structure:
     D ApiError        Ds
     D  AeBytPrv                           like(StdInt)
     D                                     inz(%size(ApiError))
     D  AeBytAvl                           like(StdInt) inz
     D  AeMsgId                       7a
     D                                1a
     D  AeMsgDta                    128a
      *
      * -- Search directory parameters:
     D Sreq0100        Ds
     D  SrCcsId                            like(StdInt) inz
     D  SrChrSet                           like(StdInt) inz
     D  SrCodPag                           like(StdInt) inz
     D  SrWldCrd                      4a   inz
     D  SrCvtRcv                           like(StdChr) inz(*off)
     D  SrSchDta                           like(StdChr) inz(*off)
     D  SrRunVfy                           like(StdChr) inz(*on)
     D  SrConHdl                           like(StdChr) inz(*off)
     D  SrRscHdl                           like(StdHdl) inz
     D  SrSrqFmt                           like(StdFmt) inz('SREQ0101')
     D  SrSrqOfs                           like(StdInt) inz(110)
     D  SrSrqNbrElm                        like(StdInt) inz
     D  SrRtnFmt                           like(StdFmt) inz('SREQ0103')
     D  SrRtnOfs                           like(StdInt) inz(100)
     D  SrRtnNbrElm                        like(StdInt) inz(1)
     D  SrRcvFmt                           like(StdFmt) inz('SRCV0101')
     D  SrRcvNbrElm                        like(StdInt) inz(1)
     D  SrUsrFmt                           like(StdFmt) inz('SRCV0111')
     D  SrOrdFmt                           like(StdFmt) inz
     D  SrOrdRtnOpt                        like(StdChr) inz(*off)
     D                                3a
     D  Sr0103                             like(Sreq0103)
     D  Sr0101                             like(Sreq0101)
      *
     D Sreq0101        Ds                  inz
     D  S1Entry                            Dim(2)
     D  S1EntLen                           like(StdInt)
     D                                     inz(%size(S1Entry))
     D                                     overlay(S1Entry:1)
     D  S1CmpVal                           like(StdChr) inz(*on)
     D                                     overlay(S1Entry: *next)
     D  S1FldNam                           like(StdNam)
     D                                     overlay(S1Entry: *next)
     D  S1PrdId                       7a   inz('*IBM')
     D                                     overlay(S1Entry: *next)
     D  S1DtaCas                      1a   overlay(S1Entry: *next)
     D                                1a   overlay(S1Entry: *next)
     D  S1ValLen                           like(StdInt)
     D                                     inz(%size(S1ValMtc))
     D                                     overlay(S1Entry: *next)
     D  S1ValMtc                           like(StdNam)
     D                                     overlay(S1Entry: *next)
      *
     D Sreq0103        Ds
     D  S3SpcRtn                           like(StdNam) inz('*SMTP')
      *
     D Srcv0100        Ds         32767
     D  R00BytRtn                          like(StdInt)
     D  R00OrdFldOfs                       like(StdInt)
     D  R00UsrEntOfs                       like(StdInt)
     D  R00DirEntNbr                       like(StdInt)
     D  R00ConHdl                          like(StdChr)
     D  R00RscHdl                          like(StdHdl) inz
     D  R00UsrMtcAry                       like( Srcv0101 )
      *
     D Srcv0101        Ds                  Based(pSrcv0101)
     D  R01UsrDtaLen                       like(StdInt)
     D  R01RtnNbrFld                       like(StdInt)
      *
     D Srcv0111        Ds                  Based(pSrcv0111)
     D  R11FldNam                    10a
     D  R11PrdId                      7a
     D                                3a
     D  R11CcsId                           like(StdInt)
     D  R11CodPag                          like(StdInt)
     D  R11RtnFldLen                       like(StdInt)
      *
     D Srcv0111v       Ds                  Based(pSrcv0111v)
     D  R11RtnFld                   256a
      *
      * -- Local constants & variables:
     D WkUser          s                   like(PxUser) inz
     D SmtpDmn         s            256a   varying      inz
     D SmtpUsrId       s             64a   varying      inz
      *
      * -- Search directory:
     D SchDir          Pr                  Extpgm('QOKSCHD')
     D  SdRcvVar                           like(Srcv0100)
     D  SdRcvVarLen                        like(StdInt) const
     D  SdFmtNam                           like(StdFmt) const
     D  SdFunction                         like(StdNam) const
     D  SdKeepTmpRsc                       like(StdChr) const
     D  SdRqsVar                           like(Sreq0100) const
     D  SdRqsVarLen                        like(StdInt) const
     D  SdRqsFmtNam                        like(StdFmt) const
     D  SdError                            like(StdFmt)
      * ---------------------------------------------------------
      *
      * Retrieve SMTP address
      *
     C                   If        PxUser      = '*CURRENT'
     C                   eval      WkUser      = ZZcurusr
     C                   else
     C                   eval      WkUser      = PxUser
     C                   endif
      *
     C                   If        %parms      = 1
     C                   eval      SrSrqNbrElm = 1
     C                   eval      S1ValMtc(1) = WkUser
     C                   eval      S1FldNam(1) = 'USER'
      *
     C                   else
     C                   eval      SrSrqNbrElm = 2
     C                   eval      S1ValMtc(1) = WkUser
     C                   eval      S1ValMtc(2) = PxAddr
     C                   eval      S1FldNam(1) = 'USRID'
     C                   eval      S1FldNam(2) = 'USRADDR'
     C                   endif
      *
     C                   eval      Sr0103      = Sreq0103
     C                   eval      Sr0101      = Sreq0101
      *
     C                   callp     SchDir( Srcv0100
     C                                   : %size(Srcv0100)
     C                                   : 'SRCV0100'
     C                                   : '*SEARCH'
     C                                   : *off
     C                                   : Sreq0100
     C                                   : %size(Sreq0100)
     C                                   : 'SREQ0100'
     C                                   : ApiError)
      *
     C                   if        AeBytAvl     > *zero or
     C                             R00DirEntNbr = *zero
      *
     C                   return    *blanks
      *
     C                   else
     C                   eval      pSrcv0101    = %addr(Srcv0100) +
     C                                            R00UsrEntOfs
     C                   eval      pSrcv0111    = pSrcv0101       +
     C                                            %size(Srcv0101)
      *
     C                   do        R01RtnNbrFld
      *
     C                   eval      pSrcv0111v   = pSrcv0111       +
     C                                            %size(Srcv0111)
      *
     C                   select
     C                   when      R11FldNam    = 'SMTPUSRID'
     C                   eval      SmtpUsrId    = %Subst(R11RtnFld
     C                                            :1:R11RtnFldLen)
      *
     C                   when      R11FldNam    = 'SMTPDMN'
     C                   eval      SmtpDmn      = %Subst(R11RtnFld
     C                                            :1:R11RtnFldLen)
     C                   endsl
      *
     C                   eval      pSrcv0111    = pSrcv0111       +
     C                                            %size(Srcv0111) +
     C                                            R11RtnFldLen
     C                   enddo
      *
     C                   return    SmtpUsrId + '@' + SmtpDmn
     C                   endif
      *
     P RtvSmtpAddr     E
      * *********************************************************
      * RtvSysDirUsr() -- Retrieve System Directory user.
      * *********************************************************
      *
     P RtvSysDirUsr    B                   export
      *
     D RtvSysDirUsr    pi                  like(RtvSysDirUsr_DS)
     D  PxUser                             like(StdNam) const
      *
      * -- API error data structure:
     D ApiError        Ds
     D  AeBytPrv                     10i 0 inz(%size(ApiError))
     D  AeBytAvl                           like(StdInt) inz
     D  AeMsgId                       7a
     D                                1a
     D  AeMsgDta                    128a
      *
      * -- Search directory parameters:
     D Sreq0100        Ds
     D  SrCcsId                            like(StdInt) inz
     D  SrChrSet                           like(StdInt) inz
     D  SrCodPag                           like(StdInt) inz
     D  SrWldCrd                      4a   inz
     D  SrCvtRcv                           like(StdChr) inz(*off)
     D  SrSchDta                           like(StdChr) inz(*off)
     D  SrRunVfy                           like(StdChr) inz(*on)
     D  SrConHdl                           like(StdChr) inz(*off)
     D  SrRscHdl                           like(StdHdl) inz
     D  SrSrqFmt                           like(StdFmt) inz('SREQ0101')
     D  SrSrqOfs                           like(StdInt) inz(110)
     D  SrSrqNbrElm                        like(StdInt) inz
     D  SrRtnFmt                           like(StdFmt) inz('SREQ0103')
     D  SrRtnOfs                           like(StdInt) inz(100)
     D  SrRtnNbrElm                        like(StdInt) inz(1)
     D  SrRcvFmt                           like(StdFmt) inz('SRCV0101')
     D  SrRcvNbrElm                        like(StdInt) inz(1)
     D  SrUsrFmt                           like(StdFmt) inz('SRCV0111')
     D  SrOrdFmt                           like(StdFmt) inz
     D  SrOrdRtnOpt                        like(StdChr) inz(*off)
     D                                3a
     D  Sr0103                             like(Sreq0103)
     D  Sr0101                             like(Sreq0101)
      *
     D Sreq0101        Ds                  inz
     D  S1Entry                            dim(2)
     D  S1EntLen                           like(StdInt)
     D                                     inz(%size( S1Entry))
     D                                     overlay(S1Entry: 1)
     D  S1CmpVal                           like(StdChr) inz(*on)
     D                                     overlay(S1Entry: *next)
     D  S1FldNam                           like(StdNam)
     D                                     overlay(S1Entry: *next)
     D  S1PrdId                       7a   inz('*IBM')
     D                                     overlay(S1Entry: *next)
     D  S1DtaCas                      1a   overlay(S1Entry: *next)
     D                                1a   overlay(S1Entry: *next)
     D  S1ValLen                           like(StdInt)
     D                                     inz( %size( S1ValMtc ))
     D                                     overlay(S1Entry: *next)
     D  S1ValMtc                           like(StdNam)
     D                                     overlay(S1Entry: *next)
      *
     D Sreq0103        Ds
     D  S3SpcRtn                           like(StdNam) inz('*SYSDIR')
      *
     D Srcv0100        Ds         32767
     D  R00BytRtn                          like(StdInt)
     D  R00OrdFldOfs                       like(StdInt)
     D  R00UsrEntOfs                       like(StdInt)
     D  R00DirEntNbr                       like(StdInt)
     D  R00ConHdl                          like(StdChr)
     D  R00RscHdl                          like(StdHdl) inz
     D  R00UsrMtcAry                       like(Srcv0101)
      *
     D Srcv0101        Ds                  Based(pSrcv0101)
     D  R01UsrDtaLen                       like(StdInt)
     D  R01RtnNbrFld                       like(StdInt)
      *
     D Srcv0111        Ds                  Based(pSrcv0111)
     D  R11FldNam                          like(StdNam)
     D  R11PrdId                      7a
     D                                3a
     D  R11CcsId                           like(StdInt)
     D  R11CodPag                          like(StdInt)
     D  R11RtnFldLen                       like(StdInt)
      *
     D Srcv0111v       Ds                  Based(pSrcv0111v)
     D  R11RtnFld                   256a
      *
      * -- Local constants & variables:
     D WkUser          s                   like(PxUser) inz
     D*SysDirUsr       s                   like(StdNam) inz
     D*SysDirAddr      s                   like(StdFmt) inz
     D*SysDirSysNam    s                   like(StdFmt) inz
      *
      * -- Search directory:
     D SchDir          Pr                  Extpgm('QOKSCHD')
     D  SdRcvVar                           like(Srcv0100)
     D  SdRcvVarLen                        like(StdInt) const
     D  SdFmtNam                           like(StdFmt) const
     D  SdFunction                         like(StdNam) const
     D  SdKeepTmpRsc                       like(StdChr) const
     D  SdRqsVar                           like(Sreq0100) const
     D  SdRqsVarLen                        like(StdInt) const
     D  SdRqsFmtNam                        like(StdFmt) const
     D  SdError                            like(StdFmt)
      * ---------------------------------------------------------
      *
      * Retrieve System Directory User
      *
     C                   If        PxUser      = '*CURRENT'
     C                   eval      WkUser      = ZZcurusr
     C                   else
     C                   eval      WkUser      = PxUser
     C                   endif
      *
     C                   eval      SrSrqNbrElm = 1
     C                   eval      S1ValMtc(1) = WkUser
     C                   eval      S1FldNam(1) = 'USER'
      *
     C                   eval      Sr0103      = Sreq0103
     C                   eval      Sr0101      = Sreq0101
      *
     C                   callp     SchDir( Srcv0100
     C                                   : %size(Srcv0100)
     C                                   : 'SRCV0100'
     C                                   : '*SEARCH'
     C                                   : *off
     C                                   : Sreq0100
     C                                   : %size(Sreq0100)
     C                                   : 'SREQ0100'
     C                                   : ApiError)
      *
     C                   if        AeBytAvl     > *zero   or
     C                             R00DirEntNbr = *zero
      *
     C                   return    *blanks
      *
     C                   else
     C                   eval      pSrcv0101    = %addr(Srcv0100) +
     C                                            R00UsrEntOfs
     C                   eval      pSrcv0111    = pSrcv0101       +
     C                                            %size(Srcv0101)
      *
     C                   do        R01RtnNbrFld
      *
     C                   eval      pSrcv0111v   = pSrcv0111       +
     C                                            %size(Srcv0111)
      *
     C                   select
     C                   when      R11FldNam    = 'USRID'
     C                   eval      RtvSysDirUsr_DS.RvUsrID =
     C                                            %Subst(R11RtnFld
     C                                            :1:R11RtnFldLen)
      *
     C                   when      R11FldNam    = 'USRADDR'
     C                   eval      RtvSysDirUsr_DS.RvSysAdr =
     C                                            %Subst(R11RtnFld
     C                                            :1:R11RtnFldLen)
     C                   endsl
      *
     C                   eval      pSrcv0111    =  pSrcv0111       +
     C                                             %size(Srcv0111) +
     C                                             R11RtnFldLen
     C                   enddo
      *
     C                   return    RtvSysDirUsr_DS
     C                   endif
      *
     P RtvSysDirUsr    E
