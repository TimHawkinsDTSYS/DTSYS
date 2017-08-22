      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Procedure prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  CEEDOD() -- Retrieve operational descriptor
      *
     D CEEDOD          PR
     D  OPdescParms                        like(StdInt) const
     D  OPdesc1                            like(StdInt)
     D  OPdesc2                            like(StdInt)
     D  OPdesc3                            like(StdInt)
     D  OPdesc4                            like(StdInt)
     D  OPdesc5                            like(StdInt)
     D  OPdescErr                    12a   options(*omit)
      * ---------------------------------------------------------
      *  CEETSTA() -- Test for passed parameters
      *
     D CEETSTA         PR
     D  Present                            like(StdInt)
     D  NumberofArg                        like(StdInt) const
     D  FeedBack                     12A   options(*omit)
      *
     D ParmPassed      s                   like(StdInt)
      * ---------------------------------------------------------
      *  CEEUTCO() -- Get UTC offset.
      *
     D CEEUTCO         PR
     D  hours                              like(StdInt)
     D  minutes                            like(StdInt)
     D  seconds                            like(StdDblFlt)
      * ---------------------------------------------------------
      * QUILNGTX() - Display Long Text in a popup window
      *
     D QUILNGTX        PR                  ExtPgm('QUILNGTX')
     D  szMsgText                 65535A   const options(*varsize)
     D  nMsgLen                      10U 0 const
     D  szMsgID                       7A   const
     D  szMsgFile                    20A   const
     D  api_error                          Likeds(DSec)
     D                                     options(*varsize)
