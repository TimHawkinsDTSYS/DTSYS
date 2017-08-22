      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Locks prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  ChkRcdLck() -- Check for Record Locks
      *
     D ChkRcdLck       PR                  like(StdInd)
     D  p_stscde                           like(StdInt)   const
     D  RecInfo                            like(StdStr)   const
     D  Wait                               like(StdInt)   const
     D                                     options(*omit:*nopass)
     D  TimeOut                            like(StdInt)   const
     D                                     options(*omit:*nopass)
     D  Options                            like(StdTxt)   const
     D                                     options(*nopass)
