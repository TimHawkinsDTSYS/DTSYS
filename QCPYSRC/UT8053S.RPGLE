      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Copy: Object prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  RtvObjLib() -- Retrieve object library
      *
     D RtvObjLib       PR                  like(StdNam)
     D  ObjNam                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp                             like(StdNam) const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      *
      *  RtvObjOwn() -- Retrieve object owner
      *
     D RtvObjOwn       PR                  like(StdNam)
     D  ObjNam                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp                             like(StdNam) const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      *
      *  RtvObjTxt() -- Retrieve object text
      *
     D RtvObjTxt       PR                  like(StdTxt)
     D  ObjNam                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp                             like(StdNam) const
     D                                     options(*nopass:*omit)
      * -----------------------------------------------------
      *  RtvObjd() -- Retrieve object description:
      *
     D RtvObjD         PR                  ExtPgm( 'QUSROBJD' )
     D  RoRcvVar                           like(StdBuf)
     D                                     options(*varsize)
     D  RoRcvVarLen                        like(StdInt)    const
     D  RoFmtNam                           like(StdFmt)    const
     D  RoObjNamQ                          like(StdNamLib) const
     D  RoObjTyp                           like(StdNam)    const
     D  RoError                            like(StdBuf)
     D                                     options(*varsize)
      * -----------------------------------------------------
      *  RoData -- Object description structure OBJD0100:
      *
     D RoData          Ds                  based(StdNulPtr)
     D  RoBytRtn                           like(StdInt)
     D  RoBytAvl                           like(StdInt)
     D  RoObjNam                           like(StdNam)
     D  RoObjLib                           like(StdNam)
     D  RoObjTypRt                         like(StdNam)
     D  RoObjLibRt                         like(StdNam)
     D  RoObjASP                           like(StdInt)
     D  RoObjOwn                           like(StdNam)
     D  RoObjDmn                      2a
     D  RoObjCrtDts                  13a
     D  RoObjChgDts                  13a
     D  RoExtAtr                           like(StdNam)
     D  RoObjTxt                           like(StdTxt)
     D  RoSrcF                             like(StdNam)
     D  RoSrcLib                           like(StdNam)
     D  RoSrcMbr                           like(StdNam)
      * ---------------------------------------------------------
      *
      *  ChkObj() -- Check object.
      *
     D ChkObj          PR                  like(d_ChkObj)
     D  ObjNam                             like(StdNam) const
     D  ObjLib                             like(StdNam) const
     D  ObjTyp                             like(StdNam) const
     D  MbrNam_p                           like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D d_ChkObj        ds
     D  ChkObj_msgid                       like(msgid)
     D  ChkObj_msgdta                      like(msgdta)
      * ---------------------------------------------------------
      *
      * ChkObjLck() -- Check for object lock.
      *
     D ChkObjLck       PR                  like(StdInd)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      * ---------------------------------------------------------
      *
      * LstObjLck() -- List object locks.
      *
     D LstObjLck       PR                  like(d_LstObjLck)
     D  RtvEnt_p                           like(StdInt) const
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjLib_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
      *
      *  Structure for returning List Object Locks.
      *
     D d_LstObjLck     DS                  qualified
     D  EntCnt                             like(StdInt)
     D  JobNam                             like(StdNam)
     D  JobUsr                             like(StdNam)
     D  JobNbr                             like(StdJobNbr)
     D  State                              like(StdNam)
     D  Status                             like(StdNam)
     D  Type                               like(StdNam)
     D  MbrNam                             like(StdNam)
     D  Shared                             like(StdNam)
     D  Scope                              like(StdNam)
      * ---------------------------------------------------------
      *
      * RtnPthQSYSobj -- Return path to QSYS object.
      *
     D RtnPthQSYSobj   PR                  like(StdStr)
     D  ObjNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  ObjTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
