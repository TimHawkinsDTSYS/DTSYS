      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Send a break message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMSBM        BEGSR
      *
     C     MSGTYP        IFEQ      *BLANKS
     C                   MOVEL     '*INFO'       MSGTYP
     C                   ENDIF
      *
     C     MSGDLV        IFEQ      *BLANKS
     C                   MOVEL     '*BREAK'      MSGDLV
     C                   ENDIF
      *
     C                   CALL      'QEZSNDMG'                           95
     C                   PARM                    MSGTYP           10
     C                   PARM                    MSGDLV           10
     C                   PARM                    MSG             100
     C                   PARM      X'00000064'   MSGLEN            4               DEC 256
     C                   PARM                    MSGQ             10
     C                   PARM      X'00000001'   NBRMSQ            4
     C                   PARM      *LOVAL        MSGSNTRTN         4
     C                   PARM      *LOVAL        FUNREQ            4
     C                   PARM      *LOVAL        ERRCDE            4
     C                   PARM      'N'           SHWSNDMSG         1
     C                   PARM      *BLANKS       RCVRPYMSGQ       20
     C                   PARM      '*USR'        MSGQTYPE          4
      *
     CSR   #PMSBM        ENDSR
