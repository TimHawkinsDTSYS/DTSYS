      /TITLE Utility, System Values (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides error routines via function calls
      *              for handling C and UNIX error codes.
      *
      *  Notes   :  Copied from Scott Klement (c) 2001
      *              at klement.dstorm.net/rpg/socktut/tutorial.html
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  09/10/02  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      * **********************************************************
      *  RtvSysVal() - Retrieve system value.
      * **********************************************************
     P RtvSysVal       b                   Export

     D RtvSysVal       pi          2080a   varying
     D  iSysval                            like(StdNam) const

     D QwcRsvAL        pr                  ExtPgm('QWCRSVAL')
     D  valRcvVar                          like(RcvVariable)
     D  valRcvVarLen                       like(StdInt) const
     D  valNoSysVals                       like(StdInt) const
     D  valSysValName                      like(StdNam) const
     D  valErrCode                         like(dsEC)

     D RcvVariable     ds
     D  rcvNbrSysVals                      like(StdInt)
     D  rcvOffSysVals                      like(StdInt)
     D  rcvSysValTbl                       like(SysValInfTbl)

     D SysValInfTbl    ds
     D  tblSysVal                          like(StdNam)
     D  tblDtaTyp                          like(StdChr)
     D  tblInfSts                          like(StdChr)
     D  tblDtaLen                          like(StdInt)
     D  tblDtaVal                  2080a

     D  tblChar001                    1a   overlay(tblDtaVal : 1)
     D  tblChar002                    2a   overlay(tblDtaVal : 1)
     D  tblChar003                    3a   overlay(tblDtaVal : 1)
     D  tblChar004                    4a   overlay(tblDtaVal : 1)
     D  tblChar005                    5a   overlay(tblDtaVal : 1)
     D  tblChar006                    6a   overlay(tblDtaVal : 1)
     D  tblChar007                    7a   overlay(tblDtaVal : 1)
     D  tblChar008                    8a   overlay(tblDtaVal : 1)
     D  tblChar009                    9a   overlay(tblDtaVal : 1)
     D  tblChar010                   10a   overlay(tblDtaVal : 1)
     D  tblChar013                   13a   overlay(tblDtaVal : 1)
     D  tblChar020                   20a   overlay(tblDtaVal : 1)
     D  tblChar030                   30a   overlay(tblDtaVal : 1)
     D  tblChar050                   50a   overlay(tblDtaVal : 1)
     D  tblChar080                   80a   overlay(tblDtaVal : 1)
     D  tblChar150                  150a   overlay(tblDtaVal : 1)
     D  tblChar160                  160a   overlay(tblDtaVal : 1)
     D  tblChar250                  250a   overlay(tblDtaVal : 1)
     D  tblChar315                  315a   overlay(tblDtaVal : 1)
     D  tblChar500                  500a   overlay(tblDtaVal : 1)

     D  tblBin004                          like(StdInt)
     D                                     overlay(tblDtaVal : 1)

     D Binary          c                   Const('B')
     D Char            c                   Const('C')
     D Locked          c                   Const('L')

     D Wk010a          s                   like(StdNam) inz
     D wSysVal         s                   like(StdNam) inz
     D Pos             s                   like(StdInt) inz
     D Len             s                   like(StdInt) inz
      * ---------------------------------------------------------
      * Retrieve system value.
      *
     C                   Eval      wSysVal = upper(iSysVal)

     C                   CallP     QwcRsvAL(RcvVariable      :
     C                                       %Len(RcvVariable) :
     C                                       1                :
     C                                       wSysVal          :
     C                                       dsEC              )
      *
     C                   If        dsEC.avl <> *zero
     C                   return    '*ERROR: ' + dsEC.msgid
     C                   endif
      * ---------------------------------------------------------
      * Return value based on length.
      *
     C                   eval      Pos = rcvOffSysVals - 8 + 1
     C                   eval      Len = %Len(SysValInfTbl) - Pos + 1
     C                   eval      SysValInfTbl =
     C                             %subst(RcvSysValTbl:pos:len)
      *
     C                   select
     C                   when      tblDtaTyp = Binary
     C                   movel     tblBin004     wk010a
     C                   return    Wk010a
     C                   when      tblDtaTyp = char and tblDtaLen = 0001
     C                   return    tblChar001
     C                   when      tblDtaTyp = char and tblDtaLen = 0002
     C                   return    tblChar002
     C                   when      tblDtaTyp = char and tblDtaLen = 0003
     C                   return    tblChar003
     C                   when      tblDtaTyp = char and tblDtaLen = 0004
     C                   return    tblChar004
     C                   when      tblDtaTyp = char and tblDtaLen = 0005
     C                   return    tblChar005
     C                   when      tblDtaTyp = char and tblDtaLen = 0006
     C                   return    tblChar006
     C                   when      tblDtaTyp = char and tblDtaLen = 0007
     C                   return    tblChar007
     C                   when      tblDtaTyp = char and tblDtaLen = 0008
     C                   return    tblChar008
     C                   when      tblDtaTyp = char and tblDtaLen = 0009
     C                   return    tblChar009
     C                   when      tblDtaTyp = char and tblDtaLen = 0010
     C                   return    tblChar010
     C                   when      tblDtaTyp = char and tblDtaLen = 0013
     C                   return    tblChar013
     C                   when      tblDtaTyp = char and tblDtaLen = 0020
     C                   return    tblChar020
     C                   when      tblDtaTyp = char and tblDtaLen = 0030
     C                   return    tblChar030
     C                   when      tblDtaTyp = char and tblDtaLen = 0050
     C                   return    tblChar050
     C                   when      tblDtaTyp = char and tblDtaLen = 0080
     C                   return    tblChar080
     C                   when      tblDtaTyp = char and tblDtaLen = 0150
     C                   return    tblChar150
     C                   when      tblDtaTyp = char and tblDtaLen = 0160
     C                   return    tblChar160
     C                   when      tblDtaTyp = char and tblDtaLen = 0250
     C                   return    tblChar250
     C                   when      tblDtaTyp = char and tblDtaLen = 0315
     C                   return    tblChar315
     C                   when      tblDtaTyp = char and tblDtaLen = 0500
     C                   return    tblChar500
     C                   when      tblDtaTyp = char and tblDtaLen = 2080
     C                   return    tblDtaVal
     C                   other
     C                   return    '*ERROR: Locked'
     C                   endsl

     P RtvSysVal       e
