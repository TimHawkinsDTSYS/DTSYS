      *PARMS dftactgrp(*no)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  01/25/10  TimH        Copied from the interent.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      *copy qcpysrc,Hspec

     FQADspObj  ip   e             disk
     FAIP010P   o    e             disk
     FAIP020P   o    e             disk

     D BldModLst       PR
     D  PgmNamLib                          like(StdQnm   ) value
     D  ObjType                            like(StdFmt)    value

     D BldSvcLst       PR
     D  PgmNamLib                          like(StdQnm   ) value
     D  ObjType                            like(StdFmt)    value

     D RtvModSig       PR                  like(IMmodsig)
     D  ModNamLib                          like(StdQnm   ) value

     D CrtUsrSpc       PR
     D  USpcName                           like(StdQnm   ) value

     D UsrSpcCrt       S                   like(StdInd) inz
     D APIUsrSpc       S                   like(StdQnm   )
     D                                     inz('ANZILEPGM QTEMP     ')
     D APIUsrSpc2      S                   like(StdQnm   )
     D                                     inz('RTVMODSIG QTEMP     ')

     D GetLstInf       PR
     D  USpcName                           like(StdQnm   ) value
     D  LstPos                             like(StdInt)
     D  LstNbrEnt                          like(StdInt)
     D  LstSizEnt                          like(StdInt)

     D PgmIsILE        PR                  like(StdInd)
     D  PgmNamLib                          like(StdQnm   ) value

     D CvtChrToHex     pr         32767
     D  input                     16384    options(*varsize) const

     D PgmNamLib       s                   like(StdQnm   ) inz

      /COPY QCPYSRC,StdTypD

      *  ---------------------------------------------------------------
      *  - Main procedure                                              -
      *  ---------------------------------------------------------------

     C                   if        not UsrSpcCrt
     C                   eval      UsrSpcCrt = *on
     C                   CallP     CrtUsrSpc(APIUsrSpc)
     C                   CallP     CrtUsrSpc(APIUsrSpc2)
     C                   endif

     C                   eval      PgmNamLib = ODobnm + ODlbnm

     C                   If        ODobtp = '*SRVPGM' or
     C                             PgmIsILE(PgmNamLib)

     C                   CallP     BldModLst(PgmNamLib: odObTp)
     C                   CallP     BldSvcLst(PgmNamLib: odObTp)
     C                   endif

      *  ===============================================================
      *  = Procedure: BldModLst - Populate database with modules used  =
      *  ===============================================================

     P BldModLst       B

     D BldModLst       PI
     D  PgmNamLib                          like(StdQnm   ) value
     D  ObjType                            like(StdFmt)    value

      /copy QSYSINC/QRPGLESRC,QBNLPGMI
      /copy QSYSINC/QRPGLESRC,QBNLSPGM

     D APIErr          S             16
     D APILstFmt       S                   like(StdFmt) inz
     D APILstPos       S                   like(StdInt) inz
     D APILstSiz       S                   like(StdInt) inz
     D APILstDta       s                   like(StdBuf) inz
     D APINbrEnt       S                   like(StdInt) inz
     D APINam          S                   like(StdNam) inz
     D APISizEnt       S                   like(StdInt) inz

      *  ---------------------------------------------------------------
      *  - Build module list                                           -

     C                   select
     C                   when      ObjType   = '*SRVPGM'
     C                   eval      APINam    = 'QBNLSPGM'
     C                   eval      APILstFmt = 'SPGL0100'
     C                   eval      APILstsiz = %len(QBNL010000)

     C                   when      ObjType   = '*PGM'
     C                   eval      APINam    = 'QBNLPGMI'
     C                   eval      APILstFmt = 'PGML0100'
     C                   eval      APILstsiz = %len(QBNL0100)
     C                   endsl

     C                   Call      APINam
     C                   parm                    APIUsrSpc
     C                   parm                    APILstFmt
     C                   parm                    PgmNamLib
     C                   parm                    APIErr

      *  ---------------------------------------------------------------
      *  - Get list header                                             -

     C                   CallP     GetLstInf(APIUsrSpc :
     C                                       APILstPos :
     C                                       APINbrEnt :
     C                                       APISizEnt)

      *  ---------------------------------------------------------------
      *  - Process list                                                -

     C                   if        APINbrEnt < 1
     C                   return
     C                   endif

     C                   do        APINbrEnt
     C                   call      'QUSRTVUS'
     C                   parm                    APIUsrSpc
     C                   parm                    APILstPos
     C                   parm                    APILstsiz
     C                   parm                    APILstDta

     C                   select
     C                   when      ObjType    = '*SRVPGM'
     C                   eval      QBNL010000 = APILstDta
     C                   eval      IMpgmnam   = QBNSN00
     C                   eval      IMlibnam   = QBNSLIBN
     C                   eval      IMobjtyp   = ObjType
     C                   eval      IMmodnam   = QBNBMN00
     C                   eval      IMmodlib   = QBNBMLN00
     C                   eval      IMmodsrc   = QBNSFILN00
     C                   eval      IMmodsrclb = QBNSFLN00
     C                   eval      IMmodsrcmb = QBNSFILM00
     C                   eval      IMmodatr   = QBNMA00
     C                   eval      IMmodsig   = RtvModSig(PgmNamLib)

     C                   when      ObjType    = '*PGM'
     C                   eval      QBNL0100   = APILstDta
     C                   eval      IMpgmnam   = QBNPGMN00
     C                   eval      IMlibnam   = QBNPGMLN
     C                   eval      IMobjtyp   = ObjType
     C                   eval      IMmodnam   = QBNBMN
     C                   eval      IMmodlib   = QBNBMLN
     C                   eval      IMmodsrc   = QBNSFILN
     C                   eval      IMmodsrclb = QBNSFLN
     C                   eval      IMmodsrcmb = QBNSFILM
     C                   eval      IMmodatr   = QBNMA
     C                   endsl

     C                   write     AIP010R

     C                   eval      APILstPos += APISizEnt
     C                   enddo

     C                   return

     P BldModLst       E

      *  ===============================================================
      *  = RtvModSig() - Retrieve module signature.
      *  ===============================================================

     P RtvModSig       B

     D RtvModSig       PI                  like(IMmodsig)
     D  ModNamLib                          like(StdQnm   ) value

      /copy QSYSINC/QRPGLESRC,QBNLSPGM

     D APIErr          S             16
     D APILstFmt       S                   like(StdFmt) inz
     D APILstPos       S                   like(StdInt) inz
     D APILstSiz       S                   like(StdInt) inz
     D APILstDta       s                   like(StdBuf) inz
     D APINbrEnt       S                   like(StdInt) inz
     D APINam          S                   like(StdNam) inz
     D APISizEnt       S                   like(StdInt) inz

      *  ---------------------------------------------------------------
      *  - Build module list                                           -

     C                   eval      APILstsiz = %len(QBNL0800)

     C                   Call      'QBNLSPGM'
     C                   parm                    APIUsrSpc2
     C                   parm      'SPGL0800'    APILstFmt
     C                   parm                    ModNamLib
     C                   parm                    APIErr

      *  ---------------------------------------------------------------
      *  - Get list header                                             -

     C                   CallP     GetLstInf(APIUsrSpc2:
     C                                       APILstPos:
     C                                       APINbrEnt:
     C                                       APISizEnt)

      *  ---------------------------------------------------------------
      *  - Process list                                                -

     C                   if        APINbrEnt <> *zero
     C                   call      'QUSRTVUS'
     C                   parm                    APIUsrSpc2
     C                   parm                    APILstPos
     C                   parm                    APILstsiz
     C                   parm                    APILstDta

     C                   eval      QBNL0800   = APILstDta
     C                   eval      IMmodsig   = CvtChrToHex(QBNATURE)
     C                   else
     C                   eval      IMmodsig   = *blanks
     C                   endif

     C                   return    IMmodsig

     P RtvModSig       E

      *  ===============================================================
      *  = Procedure: BldSvcLst - Populate database with service       =
      *  =                        programs used                        =
      *  ===============================================================

     P BldSvcLst       B

     D BldSvcLst       PI
     D  PgmNamLib                          like(StdQnm   ) value
     D  ObjType                            like(StdFmt)    value

      /copy QSYSINC/QRPGLESRC,QBNLPGMI
      /copy QSYSINC/QRPGLESRC,QBNLSPGM

     D APIErr          S             16
     D APILstFmt       S                   like(StdFmt) inz
     D APILstPos       S                   like(StdInt) inz
     D APILstSiz       S                   like(StdInt) inz
     D APILstDta       s                   like(StdBuf) inz
     D APINbrEnt       S                   like(StdInt) inz
     D APINam          S                   like(StdNam) inz
     D APISizEnt       S                   like(StdInt) inz

      *  ---------------------------------------------------------------
      *  - Build service program list                                  -
      *  ---------------------------------------------------------------

     C                   select
     C                   when      ObjType   = '*SRVPGM'
     C                   eval      APINam    = 'QBNLSPGM'
     C                   eval      APILstFmt = 'SPGL0200'
     C                   eval      APILstsiz = %len(QBNM0200)

     C                   when      ObjType   = '*PGM'
     C                   eval      APINam    = 'QBNLPGMI'
     C                   eval      APILstFmt = 'PGML0200'
     C                   eval      APILstsiz = %len(QBNL0200)
     C                   endsl

     C                   call      APINam
     C                   parm                    APIUsrSpc
     C                   parm                    APILstFmt
     C                   parm                    PgmNamLib
     C                   parm                    APIErr

      *  ---------------------------------------------------------------
      *  - Get list header                                             -
      *  ---------------------------------------------------------------

     C                   CallP     GetLstInf(APIUsrSpc :
     C                                       APILstPos :
     C                                       APINbrEnt :
     C                                       APISizEnt)

      *  ---------------------------------------------------------------
      *  - Process list                                                -
      *  ---------------------------------------------------------------

     C                   if        APINbrEnt < 1
     C                   return
     C                   endif

     C                   do        APINbrEnt
     C                   call      'QUSRTVUS'
     C                   parm                    APIUsrSpc
     C                   parm                    APILstPos
     C                   parm                    APILstsiz
     C                   parm                    APILstDta

     C                   select
     C                   when      ObjType    = '*SRVPGM'
     C                   eval      QBNM0200   = APILstDta
     C                   eval      ISpgmnam   = QBNSN01
     C                   eval      ISlibnam   = QBNSLIBN00
     C                   eval      ISobjtyp   = ObjType
     C                   eval      ISsvcnam   = QBNBSN
     C                   eval      ISsvclib   = QBNBSLN00
     C                   eval      ISsvcsig   = CvtChrToHex(QBNBSS00)
     C                   eval      ISsvcact   = QBNBSA00

     C                   when      ObjType    = '*PGM'
     C                   eval      QBNL0200   = APILstDta
     C                   eval      ISpgmnam   = QBNPGMN01
     C                   eval      ISlibnam   = QBNPGMLN00
     C                   eval      ISobjtyp   = ObjType
     C                   eval      ISsvcnam   = QBNBSPGM
     C                   eval      ISsvclib   = QBNBSLN
     C                   eval      ISsvcsig   = CvtChrToHex(QBNBSS)
     C                   eval      ISsvcact   = QBNBSA
     C                   endsl

     C                   if        ISsvclib  = *allx'00'
     C                   eval      ISsvclib  = *blanks
     C                   endif

     C                   if        ISsvclib <> 'QSYS'
     C                   write     AIP020R
     C                   endif

     C                   eval      APILstPos += APISizEnt
     C                   enddo

     C                   return

     P BldSvcLst       E

      *  ===============================================================
      *  = Procedure: CrtUsrSpc - Creates a user space                 =
      *  ===============================================================

     P CrtUsrSpc       B

     D CrtUsrSpc       PI
     D  USpcName                           like(StdQnm   ) value

     D APIErr          S             16
     D USpcExtAtr      S                   like(StdNam) inz('ANZILEPGM')
     D USpcinzVal      S                   like(StdChr) inz(X'00')
     D USpcPubAut      S                   like(StdNam) inz('*ALL')
     D USpcRpl         S                   like(StdNam) inz('*YES')
     D USpcSiz         S                   like(StdInt) inz(64000)
     D USpcText        S                   like(StdTxt)
     D                                     inz('Analyze ILE Programs')

     C                   call      'QUSCRTUS'
     C                   parm                    USpcName
     C                   parm                    USpcExtAtr
     C                   parm                    USpcSiz
     C                   parm                    USpcinzVal
     C                   parm                    USpcPubAut
     C                   parm                    USpcText
     C                   parm                    USpcRpl
     C                   parm                    APIErr

     C                   return

     P CrtUsrSpc       E

      *  ===============================================================
      *  = Procedure: GetLstInf - Retrieves generic header lisr format =
      *  ===============================================================

     P GetLstInf       B

     D GetLstInf       PI
     D  USpcName                           like(StdQnm   ) value
     D  LstPos                             like(StdInt)
     D  LstNbrEnt                          like(StdInt)
     D  LstSizEnt                          like(StdInt)

     D USpcRtnVar      DS
     D  USpcLstPos                         like(StdInt) inz
     D  USpcLstSiz                         like(StdInt) inz
     D  USpcNbrEnt                         like(StdInt) inz
     D  USpcSizEnt                         like(StdInt) inz

     D USpcPos         S                   like(StdInt) inz(125)
     D USpcLen         S                   like(StdInt)
     D                                     inz(%Len(USpcRtnVar))

      *  ---------------------------------------------------------------
      *  - Get list position                                           -
      *  ---------------------------------------------------------------

     C                   call      'QUSRTVUS'
     C                   parm                    USpcName
     C                   parm                    USpcPos
     C                   parm                    USpcLen
     C                   parm                    USpcRtnVar

     C                   eval      LstPos    = USpcLstPos + 1
     C                   eval      LstNbrEnt = USpcNbrEnt
     C                   eval      LstSizEnt = USpcSizEnt

     C                   return

     P GetLstInf       E

      *  ===============================================================
      *  = Procedure: PgmIsILE - Returns indicator for program type    =
      *  =                      '1' = ILE program                      =
      *  =                      '0' = Not ILE program                  =
      *  ===============================================================

     P PgmIsILE        B

     D PgmIsILE        PI                  like(StdInd)
     D  PgmNamLib                          like(StdQnm   ) value

     D PgmI0100        DS
     D  PgmIPgmTyp           161    161

     D APIErr          S             16
     D PgmIFmt         S                   like(StdFmt) inz('PGMI0100')
     D PgmILen         S                   like(StdInt)
     D                                     inz(%Len(PgmI0100))

     C                   call      'QCLRPGMI'
     C                   parm                    PgmI0100
     C                   parm                    PgmILen
     C                   parm                    PgmIFmt
     C                   parm                    PgmNamLib
     C                   parm                    APIErr

     C                   if        PgmIPgmTyp = 'B'
     C                   return    *on
     C                   else
     C                   return    *off
     C                   endif

     P PgmIsILE        E
      * *********************************************************
      * CvtChrToHex() -- Convert Character to Hex.
      * *********************************************************
     P CvtChrToHex     b                   export

     D CvtChrToHex     pi         32767
     D  input                     16384    options(*varsize) const
      *
     D cvthc           pr                  extproc('cvthc')
     D  output                    32767    options(*varsize)
     D  input                     16384    options(*varsize) const
     D  outputlen                          like(StdInt)      value

     D output          s          32767    inz

      /free
       // -------------------------------------------------------
       // CvtChrToHex() -- Convert Character to Hex.

       cvthc(output:input:%len(input)*2);

       return output;

      /end-free

     P CvtChrToHex     e
