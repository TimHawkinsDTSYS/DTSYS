      /TITLE PC Support Transfer Authority
     H DATEDIT(*YMD)
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
      *
      * C: T.HAWKINS   07/08/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     FAUT110P   UF A E           K DISK
      *
     D AY1             S             10    DIM(100)
      *
     D DSUSR           DS          1000
      *
     D DSLIB           DS          1000
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C     FUNCTN        CASEQ     '*ADD'        $WRITE
     C     FUNCTN        CASEQ     '*CHG'        $CHANG
     C     FUNCTN        CASEQ     '*RMV'        $REMOV
     C                   ENDCS
      *
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * WRITE INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WRITE        BEGSR
      *
     C     TALIB         IFEQ      '*ALL'
     C     *LOCK         IN        DSUSR
     C     TAUSR         SCAN      DSUSR         RESULT
     C     RESULT        IFEQ      *ZERO
     C                   MOVEA     DSUSR         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      *BLANKS
     C                   MOVEA     TAUSR         AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSUSR
     C                   OUT       DSUSR
     C                   ENDIF
     C                   ENDIF
      *
     C     TAUSR         IFEQ      '*PUBLIC'
     C     *LOCK         IN        DSLIB
     C     TALIB         SCAN      DSLIB         RESULT
     C     RESULT        IFEQ      *ZERO
     C                   MOVEA     DSLIB         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      *BLANKS
     C                   MOVEA     TALIB         AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSLIB
     C                   OUT       DSLIB
     C                   ENDIF
     C                   ENDIF
      *
     C     TAKEY2        CHAIN     AUT110R                            99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL(P)  '*ERROR'      RTNCDE
     C                   ELSE
     C                   EXSR      $SEQN
     C                   MOVEL(P)  '*WRITTEN'    RTNCDE
     C                   MOVE      *DATE         TACDTE
     C                   TIME                    TACTIM
     C                   MOVE      ZZUSR         TACUSR
     C                   WRITE     AUT110R
     C                   ENDIF
      *
     CSR   #WRITE        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CHANGE INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CHANG        BEGSR
      *
     C                   MOVE      TAAUT         SVAUT
     C                   MOVE      TATXT         SVTXT
     C     TAKEY2        CHAIN     AUT110R                            99
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  '*ERROR'      RTNCDE
     C                   ELSE
     C     SVAUT         IFNE      '*SAME'
     C                   MOVE      SVAUT         TAAUT
     C                   ENDIF
     C     SVTXT         IFNE      '*SAME'
     C                   MOVE      SVTXT         TATXT
     C                   ENDIF
     C                   EXSR      $SEQN
     C                   MOVEL(P)  '*CHANGED'    RTNCDE
     C                   UPDATE    AUT110R
     C                   ENDIF
      *
     CSR   #CHANG        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * REMOVE INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $REMOV        BEGSR
      *
     C     TALIB         IFEQ      '*ALL'
     C     *LOCK         IN        DSUSR
     C     TAUSR         SCAN      DSUSR         RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVEA     DSUSR         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      TAUSR
     C                   MOVE      *BLANKS       AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSUSR
     C                   OUT       DSUSR
     C                   ENDIF
     C                   ENDIF
      *
     C     TAKEY2        DELETE    AUT110R                            99
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  '*ERROR'      RTNCDE
     C                   ELSE
     C                   MOVEL(P)  '*REMOVED'    RTNCDE
     C                   ENDIF
      *
     C     TAUSR         IFEQ      '*PUBLIC'
     C     RTNCDE        ANDEQ     '*REMOVED'
     C     TAKEY2        SETLL     AUT110R                                99
     C     *IN99         IFEQ      *OFF
     C     *LOCK         IN        DSLIB
     C     TALIB         SCAN      DSLIB         RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVEA     DSLIB         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      TALIB
     C                   MOVE      *BLANKS       AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSLIB
     C                   OUT       DSLIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     CSR   #REMOV        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SET SEQUENCE NUMBER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SEQN         BEGSR
      *
     C     TATXT         IFEQ      '*NONE'
     C                   MOVE      *BLANKS       TATXT
     C                   ENDIF
      *
     C                   MOVEL     '*DOWNLOA'    DWNLOD           10
     C                   MOVE      'D '          DWNLOD
      *
     C                   SELECT
     C     TAAUT         WHENEQ    DWNLOD
     C                   MOVE      1             TAASEQ
     C     TAAUT         WHENEQ    '*UPLOAD'
     C                   MOVE      2             TAASEQ
     C     TAAUT         WHENEQ    '*ALL'
     C                   MOVE      3             TAASEQ
     C                   ENDSL
      *
     CSR   #SEQN         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *BLANKS       RTNCDE
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    FUNCTN           10
     C                   PARM                    RTNCDE           10
     C                   PARM                    TALIB
     C                   PARM                    TAUSR
     C                   PARM                    TAAUT
     C                   PARM                    TATXT
      *
     C     TAKEY2        KLIST
     C                   KFLD                    TALIB
     C                   KFLD                    TAUSR
      *
     C     *DTAARA       DEFINE    AUT110D       DSUSR
     C     *DTAARA       DEFINE    AUT111D       DSLIB
      *
     C     *LIKE         DEFINE    TAAUT         SVAUT
     C     *LIKE         DEFINE    TATXT         SVTXT
      *
     C                   MOVE      *ZERO         X                 5 0
     C                   MOVE      *ZERO         RESULT            5 0
      *
     CSR   #DEFN         ENDSR
