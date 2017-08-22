      /TITLE Create Object
      *CMDBFR dltpgm pgm(qrplobj/%OBJNAM)                                     */
      *CMDBFR movobj obj(%OBJNAM) objtype(*pgm) tolib(qrplobj)                */
      *CMDAFT chgobjown obj(%OBJNAM) objtype(*pgm) newown(SISallobj)          */
      *CMDAFT chgpgm pgm(%OBJNAM) usrprf(*owner)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      * Synopsis: Creates objects as requested.
      *
      * Created: TimH  07/07/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: Modifications --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *copy qcpysrc,Hspec
      *
     H ACTGRP(*NEW) DFTACTGRP(*NO)
      *
     Fsource    uf   f  112        disk    infds(DSdbf) usropn
      *
     D coj000        e ds                  extname(coj000p) inz
     D DSdbf         e ds                  extname(DSdbf)
      * ---------------------------------------------------------
      *
      *  Prototype for ExecCmd
      *
     D ExecCmd         PR                  like(msgid )
     D  CmdString                          like(CmdStg) value
     D  RmvErrMsg                     4    const options(*omit:*nopass)
      *
      *  Prototype for Test for passed parameters
      *
     D CEETSTA         PR                  extproc('CEETSTA')
     D  Present                            like(StdInt)
     D  NumberofArg                        like(StdInt) const
     D  FeedBack                     12A   options(*omit)
      *
      *  Prototype for QCAPCMD - Execute command
      *
     D QCAPCMD         PR                  extpgm('QCAPCMD')
     D   CmdString                         like(CmdStg)
     D   CmdLength                    9B 0
     D   OptCtlBlk                   20A
     D   OCBLen                       9B 0
     D   OCBFmt                       8A
     D   ChgCmdStr                    1A
     D   LenAvailCS                   9B 0
     D   LenOfChgCS                   9B 0
     D   ErrorCode                  116A
      * ---------------------------------------------------------
      *
      *  Retrieve user library list.
      *
     D RtvUsrLibL      Pr           550
     D                               10    value  options(*nopass)
     D                               10    value  options(*nopass)
     D                                6  0 Value  options(*nopass)
     D                              272           options(*nopass)
      * ---------------------------------------------------------
      *
      *  Retrieve job information.
      *
     D RtvJob          Pr                  ExtPgm( 'QUSRJOBI' )
     D                            32767
     D                               10i 0
     D                                8
     D                               26
     D                               16
     D                              272
      * ---------------------------------------------------------
      *
      *  Workfields.
      *
     D Obj             s                   like(StdNam)
     D ObjLib          s                   like(StdNam)
     D ObjType         s                   like(StdNam)          inz
     D SrcFile         s                   like(StdNam)
     D SrcFileLib      s                   like(StdNam)
     D SrcMbr          s                   like(StdNam)
     D SrcType         s                   like(StdNam)
     D pvObj           s                   like(StdNam)
     D pvObjLib        s                   like(StdNam)
     D pvSrcType       s                   like(StdNam)
     D pvSrcFile       s                   like(StdNam)
     D pvSrcFileL      s                   like(StdNam)
     D SrcText         s                   like(StdTxt)
     D ScnRplPgm       s                   like(StdNam)          inz
     D ObjLibOvr       s                   like(StdNam)          inz
     D FmtOpt          s                   like(StdNam)
     D oldfile         s                   like(StdNam)          inz
     D newfile         s                   like(StdNam)          inz
     D PVmsgid         s                   like(msgid)           inz
     D DltSplf         s              4
     D ChkDtaLib       s                   like(DltSplf)
     D CrtSrvPgm       s                   like(DltSplf)
     D IgnLckObj       s                   like(DltSplf)
     D IncParms        s                   like(StdInd)          inz
     D Reply           s                   like(StdChr)          inz
     D Exists          s                   like(StdInd)          inz
     D Module          s                   like(StdInd)          inz
     D SrvPgm          s                   like(StdInd)          inz
     D BfrPlus         s                   like(StdInd)          inz
     D AftPlus         s                   like(StdInd)          inz
     D LstPlus         s                   like(StdInd)          inz
      *
     D x               s                   like(StdInt)          inz
     D MaxRplLin       s                   like(StdInt)          inz
     D CmdBfrIdx       s                   like(StdInt)          inz
     D CmdAftIdx       s                   like(StdInt)          inz
     D CmdLstIdx       s                   like(StdInt)          inz
     D CmdStg          S           2048                          inz
     D Parms           s                   like(CmdStg)          inz
     D Cmd             s                   like(CmdStg)          inz
     D CmdBfr          s                   like(CmdStg) dim(10)  inz
     D CmdAft          s                   like(CmdStg) dim(10)  inz
     D CmdLst          s                   like(CmdStg) dim(10)  inz
      * ---------------------------------------------------------
      *
      *  Copy books.
      *
      /copy qcpysrc,StdTypD
      /copy qcpysrc,NameConst
      * ---------------------------------------------------------
      *
      *  Source records.
      *
     ISOURCE    NS  01
     I                                  1    6  SRCSEQ
     I                                  7   12  SRCDAT
     I                                 13  112  SRCDTA
      * ---------------------------------------------------------
      *
      *    Scan text for control value.
      *
     C                   exsr      $ScnTxtCtl
      * ---------------------------------------------------------
      *
      *    Set object type.
      *
     C                   exsr      $SetObjType
      * ---------------------------------------------------------
      *
      *    Retrieve library names based on source location.
      *
     C                   exsr      $RtvDftLib
      * ---------------------------------------------------------
      *
      *    Set object library (first execution).
      *
     C                   exsr      $SetObjLib
      * ---------------------------------------------------------
      *
      *    Process parms line.
      *
     C                   eval      pvSrcType   = SrcType
      *
š2b€ C                   if        SrcType = 'SQL'      or
š2b€ C                             SrcType = 'SQLFUN'   or
š2b€ C                             SrcType = 'SQLPF'    or
š2b€ C                             SrcType = 'SQLLF'
     C                   eval      SrcFile    = 'QSQLSRC'
     C                   eval      SrcFileLib = 'QTEMP'
     C                   endif
      *
     C                   exsr      $PrcParms
      * ---------------------------------------------------------
      *
      *    Set using library override.
      *
š2b€ C                   if        pvObjLib   = '*DFT' and
š2b€ C                             ObjLibOvr <> *blanks
     C                   eval      ObjLib     = ObjLibOvr
š2e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Check for existing physical safety file.
      *
š2b€ C                   if        SrcType = 'PF'     or
     C                             SrcType = 'SQLPF'
     C                   exsr      $ChkPhySafFil
     C                   endif
      * ---------------------------------------------------------
      *
      *    Try to allocate.
      *    -- we don't know if the SQL will generate *SRVPGM or *FILE
      *
š2b€ C                   if         IgnLckObj = '*NO'     and
š2b€ C                             (ObjType   = '*PGM'    or
š2b€ C                              ObjType   = '*MENU'   or
š2b€ C                              ObjType   = '*FILE')
     C                   exsr      $AlcObj
     C                   endif
      * ---------------------------------------------------------
      *
      *    Execute CMDBFR.
      *
š2b€ C                   for       x = 1 to CmdBfrIdx
     C                   eval      msgid = ExecCmd(CmdBfr(x))
     C                   eval      msgid = *blanks
š2e€ C                   endfor
      * ---------------------------------------------------------
      *
      *    Delete physical or logical from QTEMP.
      *
š2b€ C                   if        SrcType = 'PF'     or
š2b€ C                             SrcType = 'LF'     or
     C                             SrcType = 'SQLPF'  or
     C                             SrcType = 'SQLLF'
     C                   exsr      $DltDDStemp
     C                   endif
      * ---------------------------------------------------------
      *
      *    Delete file.
      *    -- PF's are handled in a special program.
      *
š2b€ C                   if        ObjType  = '*FILE'  and
š2b€ C                             SrcType <> 'PF'     and
     C                             SrcType <> 'SQLPF'
     C                   exsr      $DltFile
     C                   endif
      * ---------------------------------------------------------
      *
      *    Setup command.
      *
     C                   exsr      $SetupCmd
      * ---------------------------------------------------------
      *
      *    Execute the CREATE command.
      *
     C                   eval      msgid  = ExecCmd(Cmd)
š2b€ C                   exsr      $Exit
      * ---------------------------------------------------------
      *
      *    Handle physical file (DLTDEPLGL/CPYF/CRTDEPLGL)
      *
š2b€ C                   if        SrcType = 'PF'      or
š2b€ C                             SrcType = 'SQLPF'
     C                   call(e)   'COJ010C'
š2e€ C                   parm                    Obj
š2e€ C                   parm                    ObjLib
š2e€ C                   parm                    SrcType
š2e€ C                   parm                    SrcFile
š2e€ C                   parm                    SrcFileLib
š2e€ C                   parm                    SrcMbr
š2e€ C                   parm                    DltSplf
š2e€ C                   parm                    FmtOpt
š2e€ C                   parm                    pvObj
š2e€ C                   parm                    pvSrcType
š2e€ C                   parm                    pvSrcFile
š2e€ C                   parm                    pvSrcFileL
      *
š2b€ C                   if        %error
š2b€ C                   eval      msgid = *hival
š2b€ C                   exsr      $Exit
š2b€ C                   endif
š2e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Handle logical file.
      *
š2b€ C                   if        SrcType = 'LF'
     C                   exsr      $MovLglFil
     C                   endif
      * ---------------------------------------------------------
      *
      *    Execute CMDAFT (commands to be executed before the service program)
      *
š2b€ C                   for       x = 1 to CmdaftIdx
     C                   eval      msgid = ExecCmd(CmdAft(x))
š2b€ C                   exsr      $Exit
š2e€ C                   endfor
      * ---------------------------------------------------------
      *
      *    Create service program if requested.
      *
š2b€ C                   if        SrvPgm      and
š2b€ C                             CrtSrvPgm = '*NO'
š2b€ C                   exsr      $CrtSrvPgm
š2e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Execute CMDLST (commands to be executed dead last)
      *
š2b€ C                   for       x = 1 to CmdlstIdx
     C                   eval      msgid = ExecCmd(CmdLst(x))
š2b€ C                   exsr      $Exit
š2e€ C                   endfor
      * ---------------------------------------------------------
      *
      *    Delete spoolfile.
      *
š2b€ C                   if        DltSplf = '*YES'
     C                   exsr      $DltSplf
š2e€ C                   endif
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Move logical file.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $MovLglFil    BEGSR
      *
     C                   eval      CmdStg = 'movobj obj(' +
š2e€ C                             'QTEMP'    + '/' +
š2e€ C                             %trim(obj) +  ') ' +
š2e€ C                             'objtype(*file) ' +
š2e€ C                             'tolib(' + %trim(objlib) + ')'
      *
     C                   eval      msgid   = ExecCmd(CmdStg)
     C                   exsr      $Exit
      *
     CSR   #MovLglFil    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Scan text for control value.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ScnTxtCtl    BEGSR
      *
     C                   if        %scan('(Module)':SrcText) > *zero
     C                   eval      Module = *on
     C                   endif
      *
     C                   if        %scan('(SrvPgm)':SrcText) > *zero
     C                   eval      SrvPgm = *on
     C                   endif
      *
     C                   if        %scan('(NoCompile)':SrcText) > *zero
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      *
     CSR   #ScnTxtCtl    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve default library names.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvDftLib    BEGSR
      * ---------------------------------------------------------
      *
      *    Retrieve library names based on source location.
      *
     C                   call      'COJ005R'
     C                   parm                    SrcFileLib
     C                   parm                    SrcType
     C                   parm                    CLpgmlib
     C                   parm                    CLdtalib
     C                   parm                    CLopslib
     C                   parm                    CLsyslib
      *
     CSR   #RtvDftLib    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Set object type.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SetObjType   BEGSR
      * ---------------------------------------------------------
      *
      *    Set object type.
      *
     C                   select
     C                   when      SrcType = 'CLP'      or
     C                             SrcType = 'CLLE'     or
     C                             SrcType = 'RPG'      or
     C                             SrcType = 'RPGLE'    or
     C                             SrcType = 'SQLRPG'   or
     C                             SrcType = 'SQLRPGLE'
     C                   eval      ObjType = '*PGM'
      *
     C                   when      SrcType = 'PF'       or
     C                             SrcType = 'LF'       or
     C                             SrcType = 'DSPF'     or
     C                             SrcType = 'PRTF'     or
     C                             SrcType = 'SQLPF'    or
     C                             SrcType = 'SQLLF'
     C                   eval      ObjType = '*FILE'
      *
     C                   other
     C                   eval      ObjType = '*' + SrcType
     C                   endsl
      *
     CSR   #SetObjType   ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check for existing safety file.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChkPhySafFil BEGSR
      *
     C                   eval      CmdStg = 'chkobj obj(' +
š2e€ C                             %trim(objlib) + '/@' +
š2e€ C                             %trim(%subst(obj:2)) +
š2e€ C                             ') objtype(*file)'
      *
     C                   eval      msgid   = ExecCmd(CmdStg)
     C                   if        msgid   = *blanks
     C                   eval      msgid   = 'DTD0302'
     C                   eval      msgdta  = '@' + %subst(obj:2) + objlib
     C                   eval      msgf    = 'DTSYSMSGF'
     C                   eval      msgflib = '*LIBL'
     C                   exsr      $PMsnd
     C                   eval      *inLR = *on
     C                   return
     C                   else
     C                   call      'COJ020C'
     C                   endif
      *
     CSR   #ChkPhySafFil ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Process the parms lines.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PrcParms     BEGSR
      * ---------------------------------------------------------
      *
      *    Setup override to source member.
      *
     C                   eval      CmdStg = 'ovrdbf source tofile(' +
     C                             %trim(SrcFileLib) + '/' +
     C                             %trim(SrcFile) + ') mbr(' +
     C                             %trim(SrcMbr) + ')'
      *
     C                   eval      msgid = ExecCmd(CmdStg)
š2b€ C                   exsr      $Exit
     C                   open      source
     C                   call      'COJ020C'
      * ---------------------------------------------------------
      *
      *    Determine lines to read.
      *
š2b€ C                   if        SrcType = 'SQL'      or
š2b€ C                             SrcType = 'SQLFUN'   or
š2b€ C                             SrcType = 'SQLPF'    or
š2b€ C                             SrcType = 'SQLLF'
     C                   eval      MaxRplLin = *hival
     C                   else
     C                   eval      MaxRplLin = 25
     C                   endif
      * ---------------------------------------------------------
      *
      *    Scan thru the source.
      *
     C                   read      source
     C                   dow       not %eof       and
     C                             Z1rcno < MaxRplLin
      *
     C                   exsr      $ScnSrc
      *
     C                   read      source
     C                   enddo
      * ---------------------------------------------------------
      *
      *    Close the source file.
      *
     C                   close     source
     C                   eval      msgid = ExecCmd('dltovr source')
š2b€ C                   exsr      $Exit
      *
     CSR   #PrcParms     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Scan source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ScnSrc       BEGSR
      * ---------------------------------------------------------
      *
      *    Remove comment delimiters.
      *
     C                   exsr      $RmvCmtDlm
      * ---------------------------------------------------------
      *
      *    Scan for %keyword overrides.
      *
     C                   eval      ScnRplPgm = 'COJ010R'
     C                   exsr      $ScnRpl
      * ---------------------------------------------------------
      *
      *    Scan for non-%keyword overrides.
      *
     C                   eval      ScnRplPgm = 'COJ015R'
     C                   exsr      $ScnRpl
      * ---------------------------------------------------------
      *
      *    Change file name in DDL table source.
      *
     C                   if        SrcType = 'SQLPF'           and
     C                             %scan(%trim(obj):srcdta) <> *zero
     C                   eval      srcdta =
     C                             %replace(%trim('@' + %subst(obj:2)):
     C                             srcdta:
     C                             %scan(%trim(obj):srcdta):
     C                             %len(%trim(obj)))
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract source (CMDBFR, PARMS, CMDAFT, CMDLST).
      *
     C                   exsr      $ExtSrc
      * ---------------------------------------------------------
      *
      *    Update the record if SQL.
      *
š2b€ C                   if        SrcType = 'SQL'      or
š2b€ C                             SrcType = 'SQLFUN'   or
š2b€ C                             SrcType = 'SQLPF'    or
š2b€ C                             SrcType = 'SQLLF'
     C                   except    UpdSrc
     C                   endif
      *
     CSR   #ScnSrc       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Set object library.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SetObjLib    BEGSR
      *
     C                   eval      pvObjLib = ObjLib
      *
      *    Reset libraries if not default.
      *
š2b€ C                   if        ObjLib  <> '*DFT'
     C                   eval      CLpgmlib = ObjLib
     C                   eval      CLdtalib = ObjLib
š2e€ C                   endif
      *
      *    Set based on source type.
      *
š2b€ C                   if        ObjLib = '*DFT'
š2e€ C                   select
š2b€ C                   when      SrcType = 'PF'       or
š2b€ C                             SrcType = 'LF'       or
     C                             SrcType = 'SQLPF'    or
     C                             SrcType = 'SQLLF'
     C                   eval      ObjLib  = CLdtalib
      *
š2b€ C                   other
     C                   eval      ObjLib = CLpgmlib
š2e€ C                   endsl
š2e€ C                   endif
      *
     CSR   #SetObjLib    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Remove comment delimiters.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RmvCmtDlm    BEGSR
      *
š2b€ C                   if        %scan('/*':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:
     C                                      %scan('/*':srcdta):2)
š2e€ C                   endif
      *
š2b€ C                   if        %scan('*/':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:
     C                                      %scan('*/':srcdta):2)
š2e€ C                   endif
      *
     CSR   #RmvCmtDlm    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Extract source (CMDBFR,PARMS,CMDAFT,CMDLST).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ExtSrc       BEGSR
      * ---------------------------------------------------------
      *
      *    Scan for CMDBFR.
      *    ----------------
      *
š2b€ C                   select
š2b€ C                   when      %scan('CMDBFR':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:1:
     C                                      %scan('CMDBFR':srcdta)+6)
      *
     C                   if        not BfrPlus
     C                   eval      CmdBfrIdx += 1
š2e€ C                   endif
      *
      *    Assure that overrides are scoped to the job.
      *
š2b€ C                   if        ((%scan('OVRDBF':srcdta)   > *zero  and
š2b€ C                              (%scan('*OVRDBF':srcdta)) = *zero) or
š2b€ C                               %scan('OVRPRTF':srcdta)  > *zero) and
š2b€ C                               %scan('OVRSCOPE':srcdta) = *zero
     C                   eval      srcdta = %trim(srcdta) +
     C                                      ' ovrscope(*job)'
š2e€ C                   endif
      *
     C                   eval      CmdBfr(CmdBfrIdx) =
     C                             %trim(CmdBfr(CmdBfrIdx)) + ' ' +
     C                             %trim(SrcDta)
      *
      *    Continuation line.
      *
š2b€ C                   if        %scan('+':srcdta) > *zero
     C                   eval      BfrPlus = *on
     C                   eval      CmdBfr(CmdBfrIdx) =
     C                                      %replace('':CmdBfr(CmdBfrIdx):
     C                                      %scan('+':CmdBfr(CmdBfrIdx)))
š2e€ C                   else
     C                   eval      BfrPlus = *off
š2e€ C                   endif
      *
     C                   eval      srcdta = *blanks
      * ---------------------------------------------------------
      *
      *    Scan for PARMS.
      *    ---------------
      *
š2b€ C                   when      %scan('PARMS':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:1:
     C                                      %scan('PARMS':srcdta)+5)
     C                   eval      parms = %trim(parms) + ' ' +
     C                                     %trim(srcdta)
      *
     C                   eval      srcdta = *blanks
      * ---------------------------------------------------------
      *
      *    Scan for CMDAFT.
      *
š2b€ C                   when      %scan('CMDAFT':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:1:
     C                                      %scan('CMDAFT':srcdta)+6)
      *
     C                   if        not AftPlus
     C                   eval      CmdAftIdx += 1
š2e€ C                   endif
      *
     C                   eval      CmdAft(CmdAftIdx) =
     C                             %trim(CmdAft(CmdAftIdx)) + ' ' +
     C                             %trim(SrcDta)
      *
      *    Continuation line.
      *
š2b€ C                   if        %scan('+':srcdta) > *zero
     C                   eval      AftPlus = *on
     C                   eval      CmdAft(CmdAftIdx) =
     C                                      %replace(' ':CmdAft(CmdAftIdx):
     C                                      %scan('+':CmdAft(CmdAftIdx)))
š2e€ C                   else
     C                   eval      AftPlus = *off
š2e€ C                   endif
      *
     C                   eval      srcdta = *blanks
      * ---------------------------------------------------------
      *
      *    Scan for CMDLST.
      *    ----------------
      *
š2b€ C                   when      %scan('CMDLST':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:1:
     C                                      %scan('CMDLST':srcdta)+6)
      *
     C                   if        not LstPlus
     C                   eval      CmdLstIdx += 1
š2e€ C                   endif
      *
     C                   eval      CmdLst(CmdLstIdx) =
     C                             %trim(CmdLst(CmdLstIdx)) + ' ' +
     C                             %trim(SrcDta)
      *
      *    Continuation line.
      *
š2b€ C                   if        %scan('+':srcdta) > *zero
     C                   eval      LstPlus = *on
     C                   eval      CmdLst(CmdLstIdx) =
     C                                      %replace(' ':CmdLst(CmdLstIdx):
     C                                      %scan('+':CmdLst(CmdLstIdx)))
š2e€ C                   else
     C                   eval      LstPlus = *off
š2e€ C                   endif
      *
     C                   eval      srcdta = *blanks
š2e€ C                   endsl
      *
     CSR   #ExtSrc       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Scan replace keyword/non-keywords.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ScnRpl       BEGSR
      * ---------------------------------------------------------
      *
      *    Change to uppercase for scans if no apostrophies or quotes.
      *
š2b€ C                   if        %scan('"' :srcdta) = *zero    and
š2b€ C                             %scan('''':srcdta) = *zero
     C                   eval      srcdta = %xlate(lowr:uppr:srcdta)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Scan/Replace %keywords.
      *
     C                   call      ScnRplPgm
     C                   parm                    Obj
     C                   parm                    SrcFile
     C                   parm                    SrcFileLib
     C                   parm                    SrcMbr
     C                   parm                    SrcText
     C                   parm                    ObjLib
     C                   parm                    coj000
     C                   parm                    SrcDta
     C                   parm                    ObjLibOvr
      *
     CSR   #ScnRpl       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Allocate object.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $AlcObj       BEGSR
      * ---------------------------------------------------------
      *
      *    See if the object exists.
      *
     C                   eval      Exists = *on
      *
š2b€ C                   dou       msgid  = *blanks
š2b€ C                   eval      CmdStg = 'chkobj obj(' +
     C                             %trim(ObjLib) + '/' +
     C                             %trim(Obj) + ') objtype(' +
     C                             %trim(ObjType) + ')'
     C                   eval      msgid = ExecCmd(CmdStg)
      *
      *    Don't allocate if it doesn't exist.
      *
     C                   if        msgid >= 'CPF9800'
     C                   eval      Exists = *off
     C                   eval      msgid   = *blanks
     C                   call      'COJ020C'
     C                   leavesr
     C                   endif
      *
      *    Allocate if object found.
      *
š2b€ C                   eval      CmdStg = 'alcobj obj((' +
     C                             %trim(ObjLib) + '/' +
     C                             %trim(Obj) + ' ' +
     C                             %trim(ObjType) + ' *excl)) +
     C                             wait(5)'
      *
     C                   eval      msgid  = ExecCmd(CmdStg)
     C                   if        msgid  = 'CPF0944' or
     C                             msgid  = 'CPF1085'
     C                   leavesr
     C                   endif
      *
      *    Unable to allocate, prompt user.
      *
     C                   if        msgid <> *blanks
     C                   call      'COJ015C'
     C                   parm                    Obj
     C                   parm                    ObjLib
     C                   parm                    ObjType
     C                   parm                    Reply
      *
     C                   if        Reply = 'C'
     C                   exsr      $Exit
     C                   endif
     C                   endif
      *
      *    Deallocate.
      *
     C                   if        msgid  = *blanks
š2b€ C                   eval      CmdStg = 'dlcobj obj((' +
     C                             %trim(ObjLib) + '/' +
     C                             %trim(Obj) + ' ' +
     C                             %trim(ObjType) + ' *excl))'
      *
     C                   callp     ExecCmd(CmdStg)
     C                   endif
     C                   enddo
      *
     CSR   #AlcObj       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Setup command.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SetupCmd     BEGSR
      *
     C                   eval      IncParms = *on
      * ---------------------------------------------------------
      *
      *    Setup appropriate command.
      *
     C                   select
     C                   when      SrcType = 'CMD'
     C                   eval      Cmd     = 'CRTCMD CMD('
      *
     C                   when      SrcType = 'MENU'
     C                   eval      Cmd     = 'CRTMNU MENU('
      *
     C                   when      SrcType = 'MNUDDS'
     C                   eval      Cmd     = 'CRTDSPFMNU MENU('
      *
     C                   when      SrcType = 'PNLGRP'
     C                   eval      Cmd     = 'CRTPNLGRP PNLGRP('
      *
     C                   when      SrcType = 'DSPF'
     C                   eval      Cmd     = 'CRTDSPF FILE('
      *
     C                   when      SrcType = 'PRTF'
     C                   eval      Cmd     = 'CRTPRTF FILE('
      *
     C                   when      SrcType = 'PF'
     C                   eval      Cmd     = 'CRTPF FILE('
      *
     C                   when      SrcType = 'LF'
     C                   eval      Cmd     = 'CRTLF FILE('
      * CL
     C                   when      SrcType = 'CLP'
     C                   eval      Cmd = 'CRTCLPGM PGM('
      *
     C                   when      SrcType = 'CLLE'  and
     C                             not module
     C                   eval      Cmd = 'CRTBNDCL PGM('
      *
     C                   when      SrcType = 'CLLE'  and
     C                             module
     C                   eval      Cmd = 'CRTCLMOD MODULE('
      * RPG
     C                   when      SrcType = 'RPG'
     C                   eval      Cmd = 'CRTRPGPGM PGM('
      *
     C                   when      SrcType = 'RPGLE' and
     C                             not module        and
     C                             not srvpgm
     C                   eval      Cmd = 'CRTBNDRPG PGM('
      *
     C                   when      SrcType = 'RPGLE' and
     C                              crtsrvpgm = '*NO' and
     C                             (module            or
     C                              srvpgm)
     C                   eval      Cmd = 'CRTRPGMOD MODULE('
      *
     C                   when      SrcType  = 'RPGLE' and
     C                             crtsrvpgm = '*YES' and
     C                             srvpgm
     C                   eval      Cmd = 'CRTSRVPGM SRVPGM('
      * SQL programs
     C                   when      SrcType = 'SQLRPG'
     C                   eval      Cmd = 'CRTSQLRPG PGM('
      *
     C                   when      SrcType = 'SQLRPGLE' and
     C                             not module        and
     C                             not srvpgm
     C                   eval      Cmd = 'CRTSQLRPGI OBJ('
      *
     C                   when      SrcType = 'SQLRPGLE' and
     C                              crtsrvpgm = '*NO' and
     C                             (module            or
     C                              srvpgm)
     C                   eval      Cmd = 'CRTSQLRPGI OBJTYPE(*MODULE) OBJ('
      *
     C                   when      SrcType   = 'SQLRPGLE' and
     C                             crtsrvpgm = '*YES' and
     C                             srvpgm
     C                   eval      Cmd = 'CRTSRVPGM SRVPGM('
     C                   eval      IncParms = *off
      * SQL source
š2b€ C                   when      SrcType = 'SQL'      or
š2b€ C                             SrcType = 'SQLFUN'   or
š2b€ C                             SrcType = 'SQLPF'    or
š2b€ C                             SrcType = 'SQLLF'
     C                   eval      Cmd     = 'RUNSQLSTM'
     C                   endsl
      * ---------------------------------------------------------
      *
      *    String the command back together.
      *
     C                   select
š2b€ C                   when      SrcType = 'SQL'      or
š2b€ C                             SrcType = 'SQLFUN'   or
š2b€ C                             SrcType = 'SQLPF'    or
š2b€ C                             SrcType = 'SQLLF'
     C                   eval      Cmd = %trim(Cmd ) + ' SRCFILE(' +
     C                             %trim(SrcFileLib) + '/' +
     C                             %trim(SrcFile   ) + ') SRCMBR(' +
     C                             %trim(SrcMbr    ) + ')'
      *
     C                   when      SrcType = 'PF'          or
     C                             SrcType = 'LF'
     C                   eval      Cmd = %trim(Cmd ) + 'QTEMP/' +
     C                             %trim(Obj       ) + ') SRCFILE(' +
     C                             %trim(SrcFileLib) + '/' +
     C                             %trim(SrcFile   ) + ') SRCMBR(' +
     C                             %trim(SrcMbr    ) + ')'
      *
     C                   other
     C                   eval      Cmd = %trim(Cmd ) +
     C                             %trim(ObjLib    ) + '/' +
     C                             %trim(Obj       ) + ') SRCFILE(' +
     C                             %trim(SrcFileLib) + '/' +
     C                             %trim(SrcFile   ) + ') SRCMBR(' +
     C                             %trim(SrcMbr    ) + ')'
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Include the source imbeded parameters.
      *
     C                   if        IncParms
     C                   eval      Cmd = %trim(Cmd) + ' ' +
     C                             %trim(Parms)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Service programs are not supplied text by the command.
      *
     C                   if        SrvPgm      and
     C                             CrtSrvPgm = '*YES'
     C                   eval      Cmd = %trim(Cmd) + ' TEXT(''' +
     C                             %trim(SrcText)   + ''')'
     C                   eval      Cmd = %trim(Cmd) +
     C                             ' EXPORT(*ALL)'
     C                   eval      Cmd = %trim(Cmd) +
     C                             ' OPTION(*DUPPROC)'
     C                   endif
      *
     CSR   #SetupCmd     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete DDS physical or logical from QTEMP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DltDDStemp   BEGSR
      *
     C                   if        pvSrcType = 'PF'        or
     C                             pvSrcType = 'LF'        or
     C                             pvSrcType = 'SQLPF'     or
     C                             pvSrcType = 'SQLLF'
š2b€ C                   eval      CmdStg = 'dltf file(qtemp/' +
     C                                       %trim(Obj) + ')'
      *
     C                   eval      msgid   = ExecCmd(CmdStg)
     C                   call      'COJ020C'
     C                   endif
      *
     C                   if        pvSrcType = 'PF'        or
     C                             pvSrcType = 'SQLPF'
š2b€ C                   eval      CmdStg = 'dltf file('+%trim(objlib)+'/'+
     C                                       %trim('$'+%subst(Obj:2)) + ')'
      *
     C                   eval      msgid   = ExecCmd(CmdStg)
     C                   call      'COJ020C'
     C                   endif
      *
     CSR   #DltDDStemp   ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete file (not PF's).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DltFile      BEGSR
      * ---------------------------------------------------------
      *
      *    Delete the file if it exists.
      *
š2b€ C                   eval      CmdStg = 'dltf file(' +
     C                                      %trim(ObjLib) + '/' +
     C                                      %trim(Obj) + ')'
      *
     C                   eval      msgid   = ExecCmd(CmdStg)
     C                   call      'COJ020C'
      *
     CSR   #DltFile      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Run CHGPF/CHGLF command.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RunCHGXXcmd  BEGSR
      * ---------------------------------------------------------
      *
      *    MAXMBRS(*NOMAX) not valid for SQL tables.
      *
     C                   if        parms <> *blanks and
     C                             %scan('MAXMBRS(*NOMAX)':parms) > *zero
     C                   eval      parms =
     C                             %replace(' ':parms:
     C                             %scan('MAXMBRS(*NOMAX)':parms):15)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Run the CHGxx command.
      *
     C                   if        parms <> *blanks
     C                   eval      CmdStg = 'chg' + pvSrcType
      *
     C                   eval      CmdStg = %trim(CmdStg) +
     C                                      ' file(' +
     C                                      %trim(ObjLib) + '/' +
     C                                      %trim(Obj) + ') ' +
     C                                      %trim(parms)
      *
     C                   eval      msgid = ExecCmd(CmdStg)
š2b€ C                   exsr      $Exit
     C                   call      'COJ020C'
     C                   endif
      *
     CSR   #RunCHGXXcmd  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Create service program.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CrtSrvPgm    BEGSR
      * ---------------------------------------------------------
      *
      *    Create service program if requested.
      *
     C                   eval      CmdStg = 'crtobj obj(' +
š2e€ C                             %trim(objlib) + '/' +
š2e€ C                             %trim(obj) + ') srcfile(' +
š2e€ C                             %trim(srcfilelib) + '/' +
š2e€ C                             %trim(srcfile) + ') dltsplf(' +
š2e€ C                             %trim(dltsplf) + ') chkdtalib(' +
š2e€ C                             %trim(chkdtalib) +
š2e€ C                             ') crtsrvpgm(*yes)'
      *
     C                   eval      msgid = ExecCmd(CmdStg)
š2b€ C                   exsr      $Exit
      *
     CSR   #CrtSrvPgm    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete spoolfile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DltSplf      BEGSR
      * ---------------------------------------------------------
      *
      *    Delete spoolfile.
      *
     C                   eval      CmdStg = 'dltsplf file(' +
š2e€ C                             %trim(obj) + ') splnbr(*last)'
      *
     C                   callp     ExecCmd(CmdStg)
     C                   call      'COJ020C'
     C                   callp     ExecCmd(CmdStg)
     C                   call      'COJ020C'
     C                   callp     ExecCmd(CmdStg)
     C                   call      'COJ020C'
     C                   callp     ExecCmd(CmdStg)
     C                   call      'COJ020C'
     C                   eval      msgid = *blanks
      *
     CSR   #DltSplf      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Exit application.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Exit         BEGSR
      *
š2b€ C                   if        msgid  <> *blanks
š2b€ C                   eval      PVmsgid = msgid
     C                   exsr      $PMrcv
š2b€ C                   if        msgid   = *blanks
š2b€ C                   eval      msgid   = PVmsgid
š2b€ C                   endif
      *
š2b€ C                   if        msgf    = *blanks
š2b€ C                   eval      msgf    = 'QCPFMSG'
š2b€ C                   eval      msgflib = '*LIBL'
š2b€ C                   endif
      *
     C                   exsr      $PMsnd
     C                   eval      *inLR = *on
     C                   return
š2b€ C                   endif
      *
     CSR   #Exit         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Receive message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMrcv        BEGSR
      *
     C                   CALL(e)   'UT0150C'
     C                   PARM                    ZZpgm            10
     C                   PARM                    fmrel            10
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          512
     C                   PARM                    MSG             100
     C                   PARM                    SECLVL          250
     C                   PARM                    SEV               2 0
     C                   PARM                    MSGF             10
     C                   PARM                    MSGFLIB          10
      *
     CSR   #PMrcv        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SEND A MESSAGE TO A PROGRAM QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMSND        BEGSR
      *
     C     *like         define    StdNam        msgf
     C     *like         define    StdNam        msgflib
      *
     C                   eval      msgfil = msgf + msgflib
      *
     C                   CALL(e)   'QMHSNDPM'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGFIL           20
     C                   PARM                    MSGDTA          512
     C                   PARM      x'00000200'   MSDLEN            4
     C                   PARM      '*DIAG'       MSGTYP           10
     C                   PARM      '*'           TOPGM            10
     C                   PARM      X'00000002'   PGMSTK            4
     C                   PARM      *blanks       MSGKEY            4
     C                   PARM      *LOVAL        ERRCDE            4
      *
     C                   eval      msgdta = *blanks
      *
     CSR   #PMSND        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *ENTRY        PLIST
     C                   parm                    obj
     C                   parm                    objlib
     C                   parm                    SrcFile
     C                   parm                    SrcFileLib
     C                   parm                    SrcMbr
     C                   parm                    SrcType
     C                   parm                    DltSplf
     C                   parm                    FmtOpt
     C                   parm                    ChkDtaLib
     C                   parm                    CrtSrvPgm
     C                   parm                    IgnLckObj
     C                   parm                    SrcText
     C                   parm                    msgid
š2e€ C                   parm                    pvObj
š2e€ C                   parm                    pvSrcType
š2e€ C                   parm                    pvSrcFile
š2e€ C                   parm                    pvSrcFileL
      *
     CSR   #Define       ENDSR
      * ---------------------------------------------------------
      *
      *    Source records.
      *
     OSOURCE    E            UpdSrc
     O                       srcseq               6
     O                       srcdat              12
     O                       srcdta             112
      ***********************************************************
      *  Execute Command.
      ***********************************************************
     P ExecCmd         B                   export
      *
     D ExecCmd         PI                  like(msgid )
     D   CmdString                         like(CmdStg) value
     D   RmvErrMsg_p                  4    const options(*omit:*nopass)
      *
      * Locals:
     D   CmdLength     S              9B 0 inz(2048)
     D   RmvErrMsg     s                   like(RmvErrMsg_p) inz
      *
     D ParmPassed      S                   like(StdInt)
      *
     D   OCBLen        s              9B 0 inz(20)
     D   OCBFmt        s              8A   inz('CPOP0100')
     D   ChgCmdStr     s              1A   inz(*blanks)
     D   LenAvailCS    s              9B 0 inz(0)
     D   LenOfChgCS    s              9B 0 inz(0)
      *
     D   OptCtlBlk     DS
     D    TypOfCmdP            1      4B 0 inz(0)
     D    DBCS                 5      5A   inz('0')
     D    Prompt               6      6A   inz('2')
     D    CmdStrSyn            7      7A   inz('0')
     D    MsgKey               8     11A   inz(*blanks)
     D    Resvd1              12     20A   inz(*LOVAL)
      *
     D   ERRC0100      DS
     D    BytesProv            1      4B 0 inz(144)
     D    BytesAvail           5      8B 0 inz(0)
     D    ExcepID              9     15A   inz(*blanks)
     D    Resvd2              16     16A   inz(*blanks)
     D    Exception           17    144A   inz(*blanks)
      *
     C                   eval      ExcepID = *blanks
      *
      *    Check for omitted parameters.
      *
š1b€ C                   if        %parms    >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
š2b€ C                   if        ParmPassed = 1
     C                   eval      RmvErrMsg =
     C                             %xlate(lowr:uppr:RmvErrMsg_p)
š2e€ C                   endif
š1e€ C                   endif
      *
      *    Execute the command.
      *
     C                   callp     QCAPCMD(CmdString  : CmdLength  :
     C                                     OptCtlBlk  : OCBLen     :
     C                                     OCBFmt     : ChgCmdStr  :
     C                                     LenAvailCS : LenOfChgCS :
     C                                     ERRC0100)
      *
      *    Send error message to caller.
      *
š1b€ C                   if        ExcepID   <> *blanks and
š1b€ C                             RmvErrMsg <> '*YES'
     C                   eval      msgid  = 'GNL0086'
     C                   eval      msgdta = %subst(CmdString:1:CmdLength)
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
š1e€ C                   endif
      *
     C                   return    ExcepID
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SEND A MESSAGE TO A PROGRAM QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMSND        BEGSR
      *
     C     *like         define    StdNam        msgf
     C     *like         define    StdNam        msgflib
      *
     C                   eval      msgf    = 'DTSYSMSGF'
     C                   eval      msgflib = '*LIBL'
     C                   eval      msgfil  = msgf + msgflib
      *
š1b€ C                   if        torel  = '*PRV'
     C                   eval      pgmstk = x'00000002'
š1x€ C                   else
     C                   eval      pgmstk = *loval
š1e€ C                   endif
      *
     C                   CALL(e)   'QMHSNDPM'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGFIL           20
     C                   PARM                    MSGDTA          512
     C                   PARM      x'00000200'   MSDLEN            4
     C                   PARM      '*INFO'       MSGTYP           10
     C                   PARM      '*'           TOPGM            10
     C                   PARM                    PGMSTK            4
     C                   PARM      *blanks       MSGKEY            4
     C                   PARM      *LOVAL        ERRCDE            4
      *
     C                   MOVE      *BLANKS       TOREL            10
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGDTA
     C                   MOVE      *BLANKS       MSGF             10
      *
     CSR   #PMSND        ENDSR
      *
     P ExecCmd         E
      * **********************************************************
      * Retrieve user library list.
      * **********************************************************
     P RtvUsrLibL      B                   Export

     D RtvUsrLibL      PI           550
     D  JobName                      10    Value  options(*nopass)
     D  JobUser                      10    value  options(*nopass)
     D  JobNumber                     6  0 Value  options(*nopass)
     D  APIError                    272           options(*nopass)

      *  -------------------------------------------------------------------
      *  - Data definitions                                                -
      *  -------------------------------------------------------------------

     D CharJobNumber   DS
     D  NbrJobNumber                  6  0

     D IntJobID        S             16    Inz( *Blank )
     D QualJobName     S             26    Inz ( '*' )

     D RcvVar          DS         32767
     D                               64                 inz
     D  NbrSysLibs                         like(StdInt) inz
     D  NbrPrdLibs                         like(StdInt) inz
     D  NbrCurLibs                         like(StdInt) inz
     D  NbrUsrLibs                         like(StdInt) inz

     D LibsToSkip      S                   like(StdInt) inz

     D RcvVarLen       S                   like(StdInt) inz(%Len(RcvVar))
     D Format          S              8    Inz( 'JOBI0700' )

     D UsrLibs         S            550    Inz

     D Pos             S                   like(StdInt) inz

     D NoAPIError      C                   Const( *Zero )
     D APIErrorPassed  S                   like(StdInd) inz

     D APIErrorDS      DS
     D  BytesProvided                10I 0 Inz( %Size( APIErrorDS ) )
     D  BytesAvail                   10I 0 Inz( *Zero )
     D  MsgID                         7    Inz( *Blanks )
     D                                1    Inz( X'00' )
     D  MsgDta                      256    Inz( *Blanks )

      *  -------------------------------------------------------------------
      *  - Determine whether API error parameter was passed                -
      *  -------------------------------------------------------------------

     C                   If        %Parms > 3
     C                   Eval      APIErrorPassed = *On
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Retrieve job information                                        -
      *  -------------------------------------------------------------------

     C                   Reset                   APIErrorDS

     C                   select
     C                   when      %Parms       = *zero
     C                   eval      QualJobName  = '*'

     C                   when      JobName     <> '*'
     C                   eval      NbrJobNumber = JobNumber
     C                   eval      QualJobName  = JobName       +
     C                                            JobUser       +
     C                                            CharJobNumber
     C                   endsl

     C                   CallP     RtvJob(RcvVar     :
     C                                    RcvVarLen  :
     C                                    Format     :
     C                                    QualJobName:
     C                                    IntJobID   :
     C                                    APIErrorDS)

     C                   If        BytesAvail <> NoAPIError
     C                   ExSr      ReturnError
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Extract user library list and return it to caller               -
      *  -------------------------------------------------------------------

     C                   Eval      LibsToSkip = NbrSysLibs +
     C                                          NbrPrdLibs +
     C                                          NbrCurLibs

     C                   Eval      Pos = ( LibsToSkip * 11 ) + 81

     C                   Eval      UsrLibs = %Subst( RcvVar          :
     C                                               Pos             :
     C                                               NbrUsrLibs * 11)

     C                   Return    UsrLibs

      *  -------------------------------------------------------------------
      *  - Subroutine.... ReturnError                                      -
      *  - Description... Return error condition to caller                 -
      *  -------------------------------------------------------------------

     C     ReturnError   BegSr

     C                   If        APIErrorPassed
     C                   Eval      APIError = APIErrorDS
     C                   EndIf

     C                   Return    *Blank

     C                   EndSr

     P RtvUsrLibL      E
