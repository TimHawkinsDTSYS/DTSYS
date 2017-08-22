      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  REMOVE MESSAGE FROM A MESSAGE QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMXMQ        BEGSR
      *
     C                   MOVE      MSGQ          MSGQ             10            DEFINE ONLY
     C                   MOVEL     MSGQ          MSGQLI
     C     MSGQLB        IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       MSGQLB           10
     C                   ENDIF
     C                   MOVE      MSGQLB        MSGQLI
      *
     C     ClrOpt        IFEQ      *BLANKS
     C                   MOVEL     '*BYKEY'      ClrOpt
     C                   ENDIF
      *
     C     ClrOpt        IFNE      '*BYKEY'
     C                   MOVE      *BLANKS       MSGKEY
     C                   ENDIF
      *
     C                   CALL(e)   'QMHRMVM'
     C                   PARM                    MSGQLI           20
     C                   PARM                    MSGKEY            4
     C                   PARM                    Clropt           10
     C                   PARM      *LOVAL        ERRCDE            4
      *
     CSR   #PMXMQ        ENDSR
