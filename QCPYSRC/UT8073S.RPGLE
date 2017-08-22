      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Data queue prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------------
      *   SndDtaq() -- Send to data queue
      *
      *    parms:
      *       dtaqname -- name of data queue object
      *       dtaqlib  -- library containing data queue object
      *       dtaqlen  -- length of 'data' parameter
      *       data     -- data to place on data queue
      *
      *    optional parms 1:
      *       keylen   -- length of key data
      *       keydata  -- keys for this data queue entry
      *
      *    optional parms 2:
      *       asyncrec -- async request
      *
      *---------------------------------------------------------------
     D SndDtaQ         PR                  ExtPgm('QSNDDTAQ')
     D  dtaqname                           like(StdNam) const
     D  dtaqlib                            like(StdNam) const
     D  dtaqlen                       5  0 const
     D  data                      32766    const options(*varsize)
     D  keylen                        3  0 const options(*nopass)
     D  keydata                   32766    const options(*varsize:*nopass)
     D  asyncreq                           like(StdInt) const
     D                                     options(*nopass)
      * ---------------------------------------------------------------
      *   RcvDtaQ() -- Receive entry from data queue
      *
      *   parms:
      *      DtaqName -- name of data queue object
      *      DtaqLib  -- library containing data queue object
      *      DtaqLen  -- length of data queue entry
      *      Data     -- variable to hold retrieved data queue entry
      *      WaitTime -- Time to wait for data queue entry
      *                  (-1 = forever)
      *
      *   optional parms 1:
      *      KeyOrder   -- order to retrieve keys (GT, LT, LE, GE, etc)
      *      KeyLen     -- length of key data
      *      KeyData    -- key data
      *      SenderLen  -- length of sender data
      *      SenderInfo -- sender data
      *
      *   optional parms 2:
      *      RmvMsg     -- Remove from data queue? (*YES/*NO)
      *      RcvVarSize -- Size of receiver variable
      *      ErrorCode  -- error code data structure
      *
      * ---------------------------------------------------------------
     D RcvDtaQ         PR                  ExtPgm('QRCVDTAQ')
     D  dtaqname                           like(StdNam) const
     D  dtaqlib                            like(StdNam) const
     D  DtaqLen                       5  0
     D  Data                      32766    options(*varsize)
     D  WaitTime                      5  0 const
     D  KeyOrder                      2    const options(*nopass)
     D  KeyLen                        3  0 const options(*nopass)
     D  KeyData                   32766    options(*varsize: *nopass)
     D  SenderLen                     3  0 const options(*nopass)
     D  SenderInfo                32766    options(*varsize: *nopass)
     D  RmvMsg                             like(StdNam) const
     D                                     options(*nopass)
     D  RcvVarSize                    5  0 const options(*nopass)
     D  ErrorCode                 32766    options(*varsize: *nopass)
