      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CHECK AND TRY TO HANDLE FILE ERROR SOFTLY.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CKERR        BEGSR
      *
     C     @@ERR         IFGT      10
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   END
      *
     C     *IN95         IFEQ      *ON                                           (FILE ERROR
     C                   ADD       1             @@ERR             3 0
     C                   END
      *
     CSR   #CKERR        ENDSR
