      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Spoolfile prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * Get spoolfile list.
      *
     D GetSplfLst      PR
     D  GetSplfLstJob                      like(StdQalJob)  const
     D                                     options(*nopass:*omit)
     D  GetSplfLstUsr                      like(StdNam)     const
     D                                     options(*nopass:*omit)
     D  GetSplfLst...
     D   Outq                              like(StdNam)     const
     D                                     options(*nopass:*omit)
     D  GetSplfLst...
     D   FrmTyp                            like(StdNam)     const
     D                                     options(*nopass:*omit)
     D  GetSplfLst...
     D   UsrDta                            like(StdNam)     const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      * Get spoolfile list API.
      *
     D GetSplfLstAPI   PR                  extpgm('QUSLSPL')
     D  UsrSpc                             like(StdNamLib) const
     D  GetSplfLstFmt                      like(StdFmt)    const
     D  GetSplfLstUsr                      like(StdNam)    const
     D  GetSplfLstOutq...
     D                                     like(StdNamLib) const
     D  GetSplfLstFrmTyp...
     D                                     like(StdNam)    const
     D  GetSplfLstUsrDta...
     D                                     like(StdNam)    const
      * optional group 1:
     D  d_ES                               likeDS(dsEC)
     D                                     options(*nopass)
      * optional group 2:
     D  GetSplfLstJob                      like(StdQalJob)
     D                                     options(*nopass) const
     D  GetSplfLstFldKeys...
     D                                     like(StdInt) dim(9999)
     D                                     options(*nopass) const
     D  GetSplfLstNumFlds...
     D                                     like(StdInt)
     D                                     options(*nopass) const
      * optional group 3:
     D  GetSplfLstAuxStgPool...
     D                                     like(StdInt)
     D                                     options(*nopass) const
      * optional group 4:
     D  GetSplfLstJobSysName...
     D                                8A   options(*nopass) const
     D  GetSplfLstStartCrtDate...
     D                                7A   options(*nopass) const
     D  GetSplfLstStartCrtTime...
     D                                6A   options(*nopass) const
     D  GetSplfLstEndCrtDate...
     D                                7A   options(*nopass) const
     D  GetSplfLstEndCrtTime...
     D                                6A   options(*nopass) const
      *
     D APIheader       DS                  based(p_APIheader)
     D                                     qualified
     D   Offset                            like(StdInt)
     D                                     overlay(APIheader:125)
     D   Count                             like(StdInt)
     D                                     overlay(APIheader:133)
     D   Size                              like(StdInt)
     D                                     overlay(APIheader:137)
      *
     D GetSplfLstEnt   DS                  based(p_GetSplfLstEnt)
     D                                     qualified
     D   JobName                           like(StdNam)
     D   UserName                          like(StdNam)
     D   JobNumber                         like(StdJobNbr)
     D   SplfName                          like(StdNam)
     D   SplfNbr                           like(StdInt)
     D   SplfStatus                        like(StdInt)
     D   OpenDate                     7A
     D   OpenTime                     6A
     D   Schedule                          like(StdChr)
     D   SysName                           like(StdNam)
     D   UserData                          like(StdNam)
     D   FormType                          like(StdNam)
     D   OutQueue                          like(StdNam)
     D   OutQueueLib                       like(StdNam)
     D   AuxPool                           like(StdInt)
     D   SplfSize                          like(StdInt)
     D   SizeMult                          like(StdInt)
      *
     D   TotalPages                        like(StdInt)
     D   CopiesLeft                        like(StdInt)
     D   Priority                          like(StdChr)
     D   Reserved                     3A
     D   IppJobId                          like(StdInt)
      * ---------------------------------------------------------
      * Retrieve spoolfile attributes.
      *
     D RtvSplfa        pr                  extpgm('QUSRSPLA')
     D  RtvSplaRcv                         like(StdMaxLen) options(*varsize)
     D  RtvSplaLen                         like(StdInt)    const
     D  RtvSplaFmt                         like(StdFmt)    const
     D  RtvSplaJob                         like(StdQalJob) const
     D  RtvSplaJobID                       like(StdIntID)  const
     D  RtvSplaSplID                       like(StdIntID)  const
     D  RtvSplaSplNam                      like(StdNam)    const
     D  RtvSplaSplNbr                      like(StdInt)    const
     D  ErrCde                             like(StdMaxLen)
     D                                     options(*nopass:*varsize)
      * ---------------------------------------------------------
      * Create spoolfile.
      **
     D*CrtSplf         PR                  extpgm('QSPCRTSP')
     D**CrtSplfHdl                         like(StdInt)    const
     D**CrtSplfAtr                         like(StdMaxLen) const
     D**ErrCde                             like(StdMaxLen)
     D**                                   options(*nopass:*varsize)
      **---------------------------------------------------------
      * Open spoolfile.
      **
     D*OpnSplf         PR                  extpgm('QSPOPNSP')
     D**OpnSplfHdl                         like(StdInt)    const
     D**OpnSplfJob                         like(StdQalJob) const
     D**OpnSplfJobID                       like(StdIntID ) const
     D**OpnSplfSplID                       like(StdIntID ) const
     D**OpnSplfNam                         like(StdNam   ) const
     D**OpnSplfNbr                         like(StdInt   ) const
     D**OpnSplf...
     D** GetBuf                            like(StdInt   ) const
     D**ErrCde                             like(StdMaxLen)
     D**                                   options(*nopass:*varsize)
      **---------------------------------------------------------
      * Get spoolfile data.
      **
     D*GetSplfDta      PR                  extpgm('QSPGETSP')
     D**GetSplfDta...
     D** Hdl                               like(StdInt)    const
     D**GetSplfDta...
     D** UsrSpc                            like(StdQalJob) const
     D**GetSplfDtaFmt                      like(StdFmt   ) const
     D**GetSplfDta...
     D** GetBuf                            like(StdInt   ) const
     D**GetSplfDta...
     D** UsrSpc                            like(StdQalJob) const
     D**GetSplfDta...
     D** EndOpr                            like(StdNam   ) const
     D**ErrCde                             like(StdMaxLen)
     D**                                   options(*nopass:*varsize)
      **---------------------------------------------------------
      * Put spoolfile data.
      **
     D*PutSplfDta      PR                  extpgm('QSPPUTSP')
     D**PutSplfhdl                         like(StdInt)    const
     D**UsrSpc                             like(StdNamLib) const
     D**ErrCde                             like(StdMaxLen)
     D**                                   options(*nopass:*varsize)
      **---------------------------------------------------------
      * Close spoolfile.
      **
     D*CloSplf         PR                  extpgm('QSPCLOSP')
     D**CloSplfhdl                         like(StdInt) const
     D**ErrCde                             like(StdMaxLen)
     D**                                   options(*nopass:*varsize)
      * ---------------------------------------------------------
      * CrtPDFcnvdir() -- Create PDF conversion directory
      *
     D CrtPDFcnvdir    PR                  like(StdStr)
      *
      /if defined(dfnEmlStmf)
     D BasePath        s                   like(StdStr)    inz
     D file            s                   like(StdStr)    inz
     D stmf            s                   like(StdStr)    inz
     D envnam          s                   like(StdNam)    inz
     D owner           s                   like(StdNam)    inz
      /endif
      * ---------------------------------------------------------
      * CvtSplf() -- Convert spoolfile to PDF/TXT/HTM
      *
     D CvtSplf         PR
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  EmlTyp                             like(StdNam)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * CvtSplfTXT() -- Convert spoolfile to TXT
      *
     D CvtSplfTXT      PR
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * CvtSplfHTM() -- Convert spoolfile to HTM
      *
     D CvtSplfHTM      PR
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * CvtSplfPDF() -- Convert spoolfile to PDF
      *
     D CvtSplfPDF      PR
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * DltSplf() -- Delete spoolfile.
      *
     D DltSplf         PR
     D  SplfName                           like(StdNam) const
