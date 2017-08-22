      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Determine difference between two dates.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DATDIF       BEGSR
      *
     C     *LIKE         DEFINE    D1900         @DIFFROM                       I    (YMD)
     C     *LIKE         DEFINE    D1900         @DIFTHRU                       I    (YMD)
     C     *LIKE         DEFINE    NBRDYS        @DIFDAYS                       I    (YMD)
      *
     C                   MOVE      @DIFTHRU      D1900                          I    (YMD)
     C                   EXSR      $D1900                                       I/O
     C                   MOVE      NBRDYS        @DIFDAYS                       I    (YMD)
      *
     C                   MOVE      @DIFFROM      D1900                          I    (YMD)
     C                   EXSR      $D1900                                       I/O
     C                   SUB       NBRDYS        @DIFDAYS                       I    (YMD)
      *
     CSR   #DATDIF       ENDSR
