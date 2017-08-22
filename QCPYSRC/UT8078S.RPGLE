      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Performance tracking Prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * WrtJobTrk2() -- Write job tracking.
      *
     D WrtJobTrk2      PR
     D  bgnend                             like(StdNam) const
     D                                     options(*nopass)
     D  job                                like(StdNam) const
     D                                     options(*nopass)
     D  step                               like(StdNam) const
     D                                     options(*nopass)
     D  text                               like(StdTxt) const
     D                                     options(*nopass)
     D  dattyp                             like(Stdnam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * StrSrvJob() -- Start service job
      *
     D StrSrvJob       PR
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * EndSrvJob() -- End service job
      *
     D EndSrvJob       PR
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * StrSrvJobTrn() -- Start service job transaction.
      *
     D StrSrvJobTrn    PR
     D  P_jbna                             like(StdNam) const
     D                                     options(*omit:*nopass)
     D  P_strd                             like(NumISO) const
     D                                     options(*omit:*nopass)
     D  P_strt                             like(NumHMS) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * EndSrvJobTrn() -- End service job transaction.
      *
     D EndSrvJobTrn    PR
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * DstSrvJobReq() -- Distribute service job request.
      *
     D DstSrvJobReq    PR                  like(StdNam)
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
