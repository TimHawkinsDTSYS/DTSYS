      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Record ID prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *
      *  Retrieve record ID.
      *
     D RtvRecID        PR                  like(dfnNRrcid)
     D  RtvRecIDkey                        like(dfnNRtype) value
      *
      *  Clear record ID.
      *
     D ClrRecID        PR
     D  RtvRecIDkey                        like(StdNam) value
