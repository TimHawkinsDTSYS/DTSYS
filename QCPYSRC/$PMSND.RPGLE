      /IF not DEFINED($PMSND_copied)
      /DEFINE $PMSND_copied
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SEND A MESSAGE TO A PROGRAM QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMSND        BEGSR
      *
     C     PLemsg        ifne      *blanks
     C     *like         define    TOpgm         PLemsg
     C                   move      PLemsg        TOPGM
     C                   ENDIF
      *
     C     TOPGM         IFEQ      *BLANKS
     C                   MOVEL     '*'           TOPGM
     C                   ENDIF
      *
     C                   if           MsgFil = *blanks
     C                             or %scan('CEE':MsgFil) <> *zero
     C                   eval      msgfil = 'DTSYSMSGF *LIBL     '
     C                   ENDIF
      *
     C     TOREL         IFEQ      '*PRV'
     C                   MOVE      X'00000002'   PGMSTK
     C                   ELSE
     C                   MOVE      *LOVAL        PGMSTK
     C                   ENDIF
      *
     C     msgtyp        ifeq      *blanks
     C                   eval      msgtyp = '*INFO'
     C                   ENDIF
      *
     C                   CALL(e)   'QMHSNDPM'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGFIL           20
     C                   PARM                    MSGDTA          512
     C                   PARM      x'00000200'   MSDLEN            4
     C                   PARM                    MSGTYP           10
     C                   PARM                    TOPGM            10
     C                   PARM                    PGMSTK            4
     C                   PARM      *blanks       MSGKEY            4
     C                   PARM      *LOVAL        ERRCDE            4
      *
     C                   MOVE      *BLANKS       TOREL            10
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGDTA
     C                   MOVE      *BLANKS       MSGF             10
      *
     CSR   #PMSND        ENDSR
      /ENDIF
