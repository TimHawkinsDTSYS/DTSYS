      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SEND A MESSAGE TO A MESSAGE QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMSMQ        BEGSR
      *
     C     MSGFN1        IFEQ      *BLANKS                                      RETRIEVE
     C     *DTAARA       DEFINE    USRMSGF       MsgFn1           10             MESSAGE
     C                   IN        MsgFn1                                        FILE NAME.
     C                   eval      msgfil = MsgFn1 + '*LIBL'
     C                   ENDIF
      *
     C                   MOVEL     MSGQ          MSGQLI
     C     MSGQLB        IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       MSGQLB
     C                   ENDIF
     C                   MOVE      MSGQLB        MSGQLI
      *
     C                   dou       not %error
     C                   CALL(e)   'QMHSNDM'
     C                   PARM                    MSGID
     C                   PARM                    MSGFIL           20
     C                   PARM                    MSGDTA
     C                   PARM      x'00000200'   MSDLEN            4
     C                   PARM      '*INFO'       MSGTYP           10
     C                   PARM                    MSGQLI           20
     C                   PARM      x'00000001'   NBRMSQ            4
     C                   PARM      *BLANKS       MSGRPY           20
     C                   PARM      *BLANKS       MSGKEY            4
     C                   PARM      *LOVAL        ERRCDE            4
      *
     C                   if        %error
     C                   callp     sleep(30)
     C                   endif
     C                   enddo
      *
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGF             10
     C                   MOVE      *BLANKS       MSGDTA
     C                   MOVE      *BLANKS       MSGQ             10
     C                   MOVE      *BLANKS       MSGQLB           10
      *
     CSR   #PMSMQ        ENDSR
