0002 F* * * * * * * * * * * * * * * * * * * * * * * * * * *
0003 F*  SEND NONPROGRAM MESSAGE.
0004 F* * * * * * * * * * * * * * * * * * * * * * * * * * *
0005 CSR   $NPSND        BEGSR
0006 C*
0007 C     MSGFLB        IFEQ      *BLANKS
0008 C                   MOVEL     '*LIBL'       MSGFLB
0009 C                   ENDIF
0010 C*
0011 C     MSGQLB        IFEQ      *BLANKS
0012 C                   MOVEL     '*LIBL'       MSGQLB
0013 C                   ENDIF
0014 C*
0015 C                   CALL      'UTL100C'
0016 C                   PARM                    MSGID
0017 C                   PARM                    MSGF             10
0018 C                   PARM                    MSGFLB           10
0019 C                   PARM                    MSGDTA
0020 C                   PARM                    MSGQ             10
0021 C                   PARM                    MSGQLB           10
0022 C*
0023 CSR   #NPSND        ENDSR
