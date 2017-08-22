      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Data Area prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  ChgDtaAra() -- Change data area.
      *
     D ChgDtaAra       PR                  like(StdInd)
     D  DtaAraNam                          like(StdNam) const
     D  StrPos                             like(StdInt) const
     D  Len                                like(StdInt) const
     D  Value                              like(StdStr) const
      * ---------------------------------------------------------
      *  SetCurTskGDA() -- Set current task into GDA.
      *
     D SetCurTskGDA    PR
     D  Value                              like(StdStr) const
