      /TITLE Utility, Objects (SrvPgm)
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
      /define DSpgm
      /copy qcpysrc,Dspec
      /COPY QCPYSRC,UT8055S
      * *********************************************************
      * RtvObjOwn( -- Retrieve object owner
      * *********************************************************
     P RtvObjOwn       B                   Export
      *
     D RtvObjOwn       PI                  like(StdNam)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      *
     D RoDS            ds                  likeDS(RoData)
      *
     D ObjNam          s                   like(StdNam) inz
     D ObjLib          s                   like(StdNam) inz
     D ObjTyp          s                   like(StdNam) inz
      * -----------------------------------------------------
      *
      *   Set defaults.
      *
     C                   if        %parms   < 1
     C                   eval      ObjNam   = 'PR0200R'
     C                   else
     C                   eval      ObjNam   = ObjNam_p
     C                   endif
      *
     C                   if        %parms   < 2
     C                   eval      ObjLib   = '*LIBL'
     C                   else
     C                   eval      ObjLib   = ObjLib_p
     C                   endif
      *
     C                   if        %parms   < 3
     C                   eval      ObjTyp   = '*PGM'
     C                   else
     C                   eval      ObjTyp   = ObjTyp_p
     C                   endif
      * -----------------------------------------------------
      *
      *   Retrieve object description
      *
     C                   callp     RtvObjD(RoDS:%Size(RoDS):
     C                                     'OBJD0100':
     C                                      ObjNam + ObjLib:ObjTyp:
     C                                      dsEC)
      *
     C                   If        dsEC.avl   > *zero      and
     C                             dsEC.msgid = 'CPF9801'
     C                   return    *blanks
     C                   endIf
      *
     C                   return    RoDS.RoObjOwn
      *
     P RtvObjOwn       E
      * *********************************************************
      * RtvObjTxt() -- Retrieve object text
      * *********************************************************
     P RtvObjTxt       B                   Export
      *
     D RtvObjTxt       PI                  like(StdTxt)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      *
     D RoDS            ds                  likeDS(RoData)
      *
     D ObjNam          s                   like(StdNam) inz('PR0202R')
     D ObjLib          s                   like(StdNam) inz('*LIBL')
     D ObjTyp          s                   like(StdNam) inz('*PGM')
      * -----------------------------------------------------
      *
      *   Set defaults.
      *
     C                   if        %parms  >= 1
     C                   eval      ObjNam   = ObjNam_p
     C                   endif
      *
     C                   if        %parms  >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
     C                   if        ParmPassed = 1
     C                   eval      ObjLib   = ObjLib_p
     C                   endif
     C                   endif
      *
     C                   if        %parms  >= 3
     C                   callp     CEETSTA(ParmPassed:3:*omit)
     C                   if        ParmPassed = 1
     C                   eval      ObjTyp   = ObjTyp_p
     C                   endif
     C                   endif
      * -----------------------------------------------------
      *
      *   Retrieve object description
      *
     C                   callp     RtvObjD(RoDS:%Size(RoDS):
     C                                     'OBJD0100':
     C                                      ObjNam + ObjLib:ObjTyp:
     C                                      dsEC)
      *
     C                   If        dsEC.avl   > *zero      and
     C                             dsEC.msgid = 'CPF9801'
     C                   return    *blanks
     C                   endIf
      *
     C                   return    RoDS.RoObjTxt
      *
     P RtvObjTxt       E
      ***********************************************************
      * Check object.
      ***********************************************************
     P ChkObj          B                   Export
      *
     D ChkObj          PI                  like(d_ChkObj)
     D  p_ObjNam                           like(StdNam) const
     D  p_ObjLib                           like(StdNam) const
     D  p_ObjTyp                           like(StdNam) const
     D  p_MbrNam                           like(StdNam) const
     D                                     options(*omit:*nopass)
      *
      *  Standalone fields
      *
     D  ObjNam         s                   like(StdNam) inz
     D  ObjLib         s                   like(StdNam) inz
     D  ObjTyp         s                   like(StdNam) inz
     D  MbrNam         s                   like(StdNam) inz
      * ---------------------------------------------------------
      *
      *    Set internal variables.
      *
     C                   eval      ObjNam = p_ObjNam
     C                   eval      ObjLib = p_ObjLib
     C                   eval      ObjTyp = p_ObjTyp
      *
      *    Check for omitted parameters.
      *
     C                   eval      MbrNam     = '*NONE'
      *
     C                   if        %parms    >= 4
     C                   callp     CEETSTA(ParmPassed:4:*omit)
     C                   if        ParmPassed = 1
     C                   eval      MbrNam     = p_MbrNam
     C                   endif
     C                   endif
      * ---------------------------------------------------------
      *
      *    Check object.
      *
     C                   call      'UT1140C'
     C                   parm                    ObjNam
     C                   parm                    ObjLib
     C                   parm                    ObjTyp
     C                   parm                    MbrNam
     C                   parm                    msgid
     C                   parm                    msgdta
      *
     C                   eval      ChkObj_msgid  = msgid
     C                   eval      ChkObj_msgdta = msgdta
      *
     C                   return    d_ChkObj
      *
     P ChkObj          E
      * *********************************************************
      * ChkObjLck() -- Check for object lock.
      * *********************************************************
     P ChkObjLck       B                   Export
      *
     D ChkObjLck       PI                  like(StdInd)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      *
      * Work variables.
      *
     D ObjNam          s                   like(StdNam) inz
     D ObjLib          s                   like(StdNam) inz
     D ObjTyp          s                   like(StdNam) inz
      *
     D x               s                   like(StdInt) inz
      * -----------------------------------------------------
      *
      *    Set defaults.
      *
     C                   if        %parms   < 1
     C                   eval      ObjNam   = 'BKGMAP01'
     C                   else
     C                   eval      ObjNam   = ObjNam_p
     C                   endif
      *
     C                   if        %parms   < 2
     C                   eval      ObjLib   = '*LIBL'
     C                   else
     C                   eval      ObjLib   = ObjLib_p
     C                   endif
      *
     C                   if        %parms   < 3
     C                   eval      ObjTyp   = '*FILE'
     C                   else
     C                   eval      ObjTyp   = ObjTyp_p
     C                   endif
      * ---------------------------------------------------------
      *
      *    List object locks.
      *
     c                   eval      d_LstObjLck.EntCnt = 1
      *
     c                   for       x = 1 to d_LstObjLck.EntCnt
     c                   eval      d_LstObjLck =
     c                             LstObjLck(x:ObjNam:ObjLib:ObjTyp)
      *
     c                   if        d_LstObjLck.EntCnt = *zero
     c                   return    *off
     c                   endif
      *
      *    Don't count waiters or requesters.
      *
     c                   select
     c                   when      d_LstObjLck.Status = '*HELD'
     c                   return    *on
      *
     c                   when      d_LstObjLck.Status = '*WAIT'
      *
     c                   when      d_LstObjLck.Status = '*REQ'
     c                   endsl
     c                   endfor
      *
     c                   return    *off
      *
     P ChkObjLck       E
      * *********************************************************
      * LstObjLck() -- List object locks.
      * *********************************************************
     P LstObjLck       B                   Export
      *
     D LstObjLck       PI                  like(d_LstObjLck)
     D  RtvEnt_p                           like(StdInt) const
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      *
      * QWCLOBJL() -- List object locks
      *
     D QWCLOBJL        PR                  ExtPgm('QWCLOBJL')
     D   UsrSpc                            like(StdNamLib)   const
     D   Format                            like(StdFmt)      const
     D   Object                            like(StdNamLib)   const
     D   ObjType                           like(StdNam)      const
     D   Member                            like(StdNam)      const
     D   ErrorCode                32766A   options(*varsize)
      *
      * List API generic header data structure
      *
     D dsLH            DS                  based(p_UsrSpc)
     D   dsLHFill1                  103A
     D   dsLHStatus                        like(StdChr)
     D   dsLHFill2                   12A
     D   dsLHHdrOff                        like(StdInt)
     D   dsLHHdrSiz                        like(StdInt)
     D   dsLHLstOff                        like(StdInt)
     D   dsLHLstSiz                        like(StdInt)
     D   dsLHEntCnt                        like(StdInt)
     D   dsLHEntSiz                        like(StdInt)
      *
      *  List Object Locks API format OBJL0100
      *
     D dsOL            DS                  based(p_Entry)
     D  dsOL_JobName                       like(StdNam)
     D  dsOL_UserName                      like(StdNam)
     D  dsOL_JobNbr                        like(StdJobNbr)
     D  dsOL_LckState                      like(StdNam)
     D  dsOL_LckSts                        like(StdInt)
     D  dsOL_LckType                       like(StdInt)
     D  dsOL_Member                        like(StdNam)
     D  dsOL_Share                         like(StdChr)
     D  dsOL_LckScope                      like(StdChr)
     D  dsOL_ThreadID                      like(StdFmt)
      * ---------------------------------------------------------
      *
      * Work variables.
      *
     D RtvEnt          s                   like(StdInt) inz
     D ObjNam          s                   like(StdNam) inz
     D ObjLib          s                   like(StdNam) inz
     D ObjTyp          s                   like(StdNam) inz
     D x               s                   like(StdInt)
      * -----------------------------------------------------
      *
      *    Set defaults.
      *
     C                   eval      RtvEnt   = RtvEnt_p
      *
     C                   if        %parms   < 2
     C                   eval      ObjNam   = 'BKGMAP01'
     C                   else
     C                   eval      ObjNam   = ObjNam_p
     C                   endif
      *
     C                   if        %parms   < 3
     C                   eval      ObjLib   = '*LIBL'
     C                   else
     C                   eval      ObjLib   = ObjLib_p
     C                   endif
      *
     C                   if        %parms   < 4
     C                   eval      ObjTyp   = '*FILE'
     C                   else
     C                   eval      ObjTyp   = ObjTyp_p
     C                   endif
      * ---------------------------------------------------------
      *
      *    Create user space.
      *
     c                   if        RtvEnt = 1
     c                   callp     CrtUsrSpc('LSTOBJLCK':'QTEMP':
     c                                       32767:' ':
     c                                       'List object locks')
     c                   endif
      * ---------------------------------------------------------
      *
      *    List object locks.
      *
     c                   if        RtvEnt = 1
     c                   callp     QWCLOBJL('LSTOBJLCK QTEMP':
     c                               'OBJL0100':ObjNam+ObjLib:
     c                               ObjTyp:' ':dsEC)
     c                   endif
      * ---------------------------------------------------------
      *
      *    Get pointer to user space.
      *
     c                   if        RtvEnt = 1
     c                   eval      p_UsrSpc =
     c                             GetUsrSpcP('LSTOBJLCK':'QTEMP')
     c                   endif
      * ---------------------------------------------------------
      *
      *    Set pointer to entry.
      *    -- entry starts at zero, so we backup by one.
      *
     c                   eval      RtvEnt -= 1
      *
     c                   eval      p_Entry = p_UsrSpc +
     c                             (dsLHLstOff + (RtvEnt * dsLHEntSiz))
      *
      *    Entry count.
      *
     c                   clear                   d_LstObjLck
     c                   eval      d_LstObjLck.EntCnt = dsLHEntCnt
      *
      *    Job locking object.
      *
     c                   eval      d_LstObjLck.JobNam = dsOL_JobName
     c                   eval      d_LstObjLck.JobUsr = dsOL_UserName
     c                   eval      d_LstObjLck.JobNbr = dsOL_JobNbr
      *
      *    Lock state
      *
     c                   eval      d_LstObjLck.State = dsOL_LckState
      *
      *    Lock status
      *
     c                   select
     c                   when      dsOL_LckSts = 1
     c                   eval      d_LstObjLck.Status = '*HELD'

     c                   when      dsOL_LckSts = 2
     c                   eval      d_LstObjLck.Status = '*WAIT'

     c                   when      dsOL_LckSts = 2
     c                   eval      d_LstObjLck.Status = '*REQ'
     c                   endsl
      *
      *    Lock type.
      *
     c                   select
     c                   when      dsOL_LckType = 1
     c                   eval      d_LstObjLck.Type = '*OBJECT'
      *
     c                   when      dsOL_LckType = 2
     c                   eval      d_LstObjLck.Type = '*MBRCTLBLK'
      *
     c                   when      dsOL_LckType = 3
     c                   eval      d_LstObjLck.Type = '*MBRACCPTH'
      *
     c                   when      dsOL_LckType = 3
     c                   eval      d_LstObjLck.Type = '*MBRDTA'
     c                   endsl
      *
      *    Member
      *
     c                   eval      d_LstObjLck.MbrNam = dsOL_Member
      *
      *    Shared.
      *
     c                   if        dsOL_Share = '1'
     c                   eval      d_LstObjLck.Shared = '*YES'
     c                   else
     c                   eval      d_LstObjLck.Shared = '*NO'
     c                   endif
      *
      *    Scope.
      *
     c                   if        dsOL_LckScope = '1'
     c                   eval      d_LstObjLck.Scope = '*THREAD'
     c                   else
     c                   eval      d_LstObjLck.Scope = '*JOB'
     c                   endif
      *
     c                   return    d_LstObjLck
      *
     P LstObjLck       E
      * *********************************************************
      * RtvObjLib( -- Retrieve object library
      * *********************************************************
     P RtvObjLib       B                   Export
      *
     D RtvObjLib       PI                  like(StdNam)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      *
     D RoDS            ds                  likeDS(RoData)
      *
     D ObjNam          s                   like(StdNam) inz
     D ObjLib          s                   like(StdNam) inz('*LIBL')
     D ObjTyp          s                   like(StdNam) inz
      * -----------------------------------------------------
      *
      *   Set defaults.
      *
     C                   if        %parms   < 1
     C                   eval      ObjNam   = 'PR0200R'
     C                   else
     C                   eval      ObjNam   = ObjNam_p
     C                   endif
      *
     C                   if        %parms   < 2
     C                   eval      ObjTyp   = '*PGM'
     C                   else
     C                   eval      ObjTyp   = ObjTyp_p
     C                   endif
      * -----------------------------------------------------
      *
      *   Retrieve object description
      *
     C                   callp     RtvObjD(RoDS:%Size(RoDS):
     C                                     'OBJD0100':
     C                                      ObjNam + ObjLib:ObjTyp:
     C                                      dsEC)
      *
     C                   If        dsEC.avl   > *zero      and
     C                             dsEC.msgid = 'CPF9801'
     C                   return    *blanks
     C                   endIf
      *
     C                   return    RoDS.RoObjLib
      *
     P RtvObjLib       E
      * *********************************************************
      * RtnPthQSYSobj -- Return path to QSYS object.
      * *********************************************************
     P RtnPthQSYSobj   B                   Export
      *
     D RtnPthQSYSobj   PI                  like(StdStr)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      *
     D ObjNam          s                   like(StdNam) inz
     D ObjLib          s                   like(StdNam) inz('*LIBL')
     D ObjTyp          s                   like(StdNam) inz
     D RtnPth          s                   like(StdStr) inz
      * -----------------------------------------------------
      *
      *   Set defaults.
      *
     C                   if        %parms   < 1
     C                   eval      ObjNam   = 'PR0200R'
     C                   else
     C                   eval      ObjNam   = ObjNam_p
     C                   endif
      *
     C                   if        %parms   < 2
     C                   eval      ObjTyp   = '*PGM'
     C                   else
     C                   eval      ObjTyp   = ObjTyp_p
     C                   endif
      * -----------------------------------------------------
      *
      *   Retrieve library name.
      *
     C                   eval      ObjLib = RtvObjLib(ObjNam:ObjTyp)
      * -----------------------------------------------------
      *
      *   Set path to QSYS object.
      *
     C                   eval      RtnPth = '/QSYS.LIB/' +
     C                             %trim(ObjLib) + '.LIB/' +
     C                             %trim(ObjNam) + '.' +
     C                             %subst(ObjTyp:2)
      *
     C                   return    RtnPth
      *
     P RtnPthQSYSobj   E
