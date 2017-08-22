      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONCATENATE QUERY SELECT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $QRYSL        BEGSR
      *
     C                   CALL      'UT1100R'
     C                   PARM                    QSQUO             1
     C                   PARM                    QSPAR             1
     C                   PARM                    QSREL            50
     C                   PARM                    QSFLD            80
     C                   PARM                    QSVAL           256
     C                   PARM                    QRYSLT
      *
     CSR   #QRYSL        ENDSR
