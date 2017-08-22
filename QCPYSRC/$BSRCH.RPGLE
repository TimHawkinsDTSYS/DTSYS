      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  BINARY SEARCH PROCESSOR.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $BSRCH        BEGSR
      *
     C                   CALL      'UT1300R'
     C                   PARM                    BSMODE            8            LOAD/FIND
     C                   PARM                    BSFIND            1            1=FOUND,0=LOADED
     C                   PARM                    BSKFLD           50
     C                   PARM                    BSDATA          256
      *
     CSR   #BSRCH        ENDSR
