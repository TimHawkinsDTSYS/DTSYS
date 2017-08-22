      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  EDIT PRINT CODES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $EDTPC        BEGSR
      *
     C                   CALL      'DP0810R'                                      Edit Rmk PC
     C                   PARM                    ERROR                            1=Yes, 0=No
     C                   PARM                    RWPRTC                           Print cde
      *
     CSR   #EDTPC        ENDSR
