      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  EXECUTE QCMDEXC.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $QCMDEXC      BEGSR
      *
     C     TOPGM         IFEQ      *BLANKS
     C                   MOVEL     '*'           TOPGM
     C                   ENDIF
      *
     C                   CALL      'QCMDEXC'     CMDEXC                 95
      *
     C     *IN95         IFEQ      *ON
     C                   ADD       1             @@ERR             3 0
     C                   MOVE      'GNL0086'     MSGID
     C                   MOVEL     CMDSTG        MSGDTA
     C                   MOVEL     '*PRV'        TOREL
     C                   EXSR      $PMSND
      *
     C     @@ERR         IFGT      10
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C     CMDEXC        PLIST
     C                   PARM                    CMDSTG          512
     C                   PARM      512           CMDLEN           15 5
      *
     CSR   #QCMDEXC      ENDSR
