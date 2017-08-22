      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Command prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     D CmdStg          s           2048    inz
     D CmdLen          s             15  5 inz(2048)
      *
     D ErrMsgid        s                   like(msgid)
     D                                     import('_EXCP_MSGID')
      * ---------------------------------------------------------
      *  ExecCmd() - Execute command
      *
     D ExecCmd         PR                  like(msgid)
     D  CmdString                          like(CmdStg) const
     D  RmvErrMsg                     4    const options(*nopass)
      * ---------------------------------------------------------
      *  ChkCmd - Check command
      *
     D ChkCmd          PR                  like(msgid)
     D  CmdString                          like(CmdStg) const
     D  RmvErrMsg                     4    const options(*nopass)
      * ---------------------------------------------------------
      *  RtvFmtCmd() - Retrieve formatted command
      *
     D RtvFmtCmd       PR                  like(CmdStg)
     D  CmdString                          like(CmdStg) const
      * ---------------------------------------------------------
      *  System() - Execute system command
      *
     D System          PR                  like(msgid)
     D  CmdString                          like(CmdStg) const
     D  RmvErrMsg_p                   4    const options(*nopass)
      * ---------------------------------------------------------
      * QCAPCMD() - Execute command
      *
     D QCAPCMD         PR                  extpgm('QCAPCMD')
     D  CmdString                          like(CmdStg)    const
     D  CmdLength                          like(StdInt)    const
     D  OptCtlBlk                    20A                   const
     D  OCBLen                             like(StdInt)    const
     D  OCBFmt                             like(StdFmt)    const
     D  ChgCmdStr                          like(StdStr)    const
     D  LenAvailCS                         like(StdInt)    const
     D  LenOfChgCS                         like(StdInt)    const
     D  dsEC                               likeDS(dsEC)
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * RplCmdKwd() - Replace command keyword
      *
     D RplCmdKwd       PR                  like(CmdStg)
     D  WPcmdkwd                           like(CmdStg) const
     D  WPcmdstg                           like(CmdStg) const
      * ---------------------------------------------------------
      * RmvCmdKwd() - Remove command keyword
      *
     D RmvCmdKwd       PR                  like(CmdStg)
     D  WPcmdkwd                           like(CmdStg) const
     D  WPcmdstg                           like(CmdStg) const
      * ---------------------------------------------------------
      * ExtCmdKwdVal() - Extract command keyword value
      *
     D ExtCmdKwdVal    PR                  like(CmdStg)
     D  WPkwd                              like(CmdStg) const
     D  WPcmdstg                           like(CmdStg) const
      * ---------------------------------------------------------
      * CvtCmdLwrCas() - Convert comand to lower case
      *
     D CvtCmdLwrCas    PR                  like(StdSQL) opdesc
     D  CharValue                          like(StdSQL) const
