      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Convert date.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CVTDT        BEGSR
      *
      *  Date formats:
      *
      *  Value        Description
      *  ------------ -----------------------------------------------
      *  *JOB       - The format given in the DATFMT job attribute.
      *  *SYSVAL    - The format given in the QDATFMT system value.
      *  *YMD       - YYMMDD (year, month, day) format.
      *  *MDY       - MMDDYY (month, day, year) format.
      *  *DMY       - DDMMYY (day, month, year) format.
      *  *JUL       - Julian format (YYDDD (year, day of year)).
      *  *YYJUL     - Julian format (YYYYDDD (year, day of year)).
      *  *YYMD      - YYYYMMDD (year, month, day) format.
      *  *MDYY      - MMDDYYYY (month, day, year) format.
      *  *DMYY      - DDMMYYYY (day, month, year) format.
      *
     C     @CFDAT        IFNE      *BLANKS                                       TIME FORMAT.
     C                   MOVE      @CFDAT        @CFDAT           10             TIME FORMAT.
     C                   MOVE      @CFFMT        @CFFMT           10
     C                   MOVE      @CTDAT        @CTDAT           10
     C                   MOVE      @CTFMT        @CTFMT           10
     C                   MOVE      @CTSEP        @CTSEP           10            (LEN PROVIDED
      *
     C                   MOVE      @CFDAT        CvtFrmDat                       TIME FORMAT.
     C                   MOVE      @CFFMT        CvtFrmFmt
     C                   MOVE      @CTDAT        CvtToDat
     C                   MOVE      @CTFMT        CvtToFmt
     C                   MOVE      @CTSEP        CvtDatSep                      (LEN PROVIDED
     C                   ENDIF                                                  (LEN PROVIDED
      *
     C                   CALL      'UTL104R'                            95      CONVERT DATE &
     C                   PARM                    CvtFrmDat        10
     C                   PARM                    CvtFrmFmt        10
     C                   PARM                    CvtToDat         10
     C                   PARM                    CvtToDatYYYY      4
     C                   PARM                    CvtToDatYY        2
     C                   PARM                    CvtToDatMM        2
     C                   PARM                    CvtToDatDD        2
     C                   PARM                    CvtToDatDDD       3
     C                   PARM                    CvtToFmt         10
     C                   PARM                    CvtDatSep        10
      *
     C                   MOVE      CvtToDatYYYY  CvtToDteYYYY      4 0
     C                   MOVE      CvtToDatYY    CvtToDteYY        2 0
     C                   MOVE      CvtToDatMM    CvtToDteMM        2 0
     C                   MOVE      CvtToDatDD    CvtToDteDD        2 0
     C                   MOVE      CvtToDatDDD   CvtToDteDDD       3 0
     C     CvtToDteDDD   DIV       7             CvtToDteWK        3 0
      *
     C     CvtToDteMM    IFLE      *ZERO
     C                   Z-ADD     1             CvtToDteMM
     C                   ENDIF
     C     CvtToDteMM    IFGT      12
     C                   Z-ADD     12            CvtToDteMM
     C                   ENDIF
      *
     C     CvtToDteWK    IFLE      *ZERO
     C                   Z-ADD     1             CvtToDteWK
     C                   ENDIF
     C     CvtToDteWK    IFGT      52
     C                   Z-ADD     52            CvtToDteWK
     C                   ENDIF
      *
     CSR   #CVTDT        ENDSR
