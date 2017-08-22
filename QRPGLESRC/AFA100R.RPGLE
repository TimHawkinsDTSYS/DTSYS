      /TITLE PC Support Folder Authority
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
     FAUT100P   UF A E           K DISK
      *
     D AY1             S             10    DIM(100)
      *
     D DSUSR           DS          1000
      *
     D DSFLR           DS          1000
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
     D LO              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
      *
      /SPACE 3
     C     LO:UP         XLATE     FAFLR         FAFLR
      *
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
     C     FAFLR         IFEQ      '*ALL'
     C     *LOCK         IN        DSUSR
     C     FAUSR         SCAN      DSUSR         RESULT
     C     RESULT        IFEQ      *ZERO
     C                   MOVEA     DSUSR         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      *BLANKS
     C                   MOVEA     FAUSR         AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSUSR
     C                   OUT       DSUSR
     C                   ENDIF
     C                   ENDIF
      *
     C     FAUSR         IFEQ      '*PUBLIC'
     C     *LOCK         IN        DSFLR
     C     FAFLR         SCAN      DSFLR         RESULT
     C     RESULT        IFEQ      *ZERO
     C                   MOVEA     DSFLR         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      *BLANKS
     C                   MOVEA     FAFLR         AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSFLR
     C                   OUT       DSFLR
     C                   ENDIF
     C                   ENDIF
      *
     C     FAKEY2        CHAIN     AUT100R                            99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL(P)  '*ERROR'      RTNCDE
     C                   ELSE
     C                   EXSR      $SEQN
     C                   MOVEL(P)  '*WRITTEN'    RTNCDE
     C                   MOVE      *DATE         FACDTE
     C                   TIME                    FACTIM
     C                   MOVE      ZZUSR         FACUSR
     C                   WRITE     AUT100R
     C                   ENDIF
      *
     CSR   #WRITE        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CHANGE INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CHANG        BEGSR
      *
     C                   MOVE      FAAUT         SVAUT
     C                   MOVE      FATXT         SVTXT
     C     FAKEY2        CHAIN     AUT100R                            99
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  '*ERROR'      RTNCDE
     C                   ELSE
     C     SVAUT         IFNE      '*SAME'
     C                   MOVE      SVAUT         FAAUT
     C                   ENDIF
     C     SVTXT         IFNE      '*SAME'
     C                   MOVE      SVTXT         FATXT
     C                   ENDIF
     C                   EXSR      $SEQN
     C                   MOVEL(P)  '*CHANGED'    RTNCDE
     C                   UPDATE    AUT100R
     C                   ENDIF
      *
     CSR   #CHANG        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * REMOVE INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $REMOV        BEGSR
      *
     C     FAFLR         IFEQ      '*ALL'
     C     *LOCK         IN        DSUSR
     C     FAUSR         SCAN      DSUSR         RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVEA     DSUSR         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      FAUSR
     C                   MOVE      *BLANKS       AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSUSR
     C                   OUT       DSUSR
     C                   ENDIF
     C                   ENDIF
      *
     C     FAKEY2        DELETE    AUT100R                            99
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  '*ERROR'      RTNCDE
     C                   ELSE
     C                   MOVEL(P)  '*REMOVED'    RTNCDE
     C                   ENDIF
      *
     C     FAUSR         IFEQ      '*PUBLIC'
     C     RTNCDE        ANDEQ     '*REMOVED'
     C     FAKEY2        SETLL     AUT100R                                99
     C     *IN99         IFEQ      *OFF
     C     *LOCK         IN        DSFLR
     C     FAFLR         SCAN      DSFLR         RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVEA     DSFLR         AY1
     C                   DO        100           X
     C     AY1(X)        IFEQ      FAFLR
     C                   MOVE      *BLANKS       AY1(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   MOVEA     AY1           DSFLR
     C                   OUT       DSFLR
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
     C     FATXT         IFEQ      '*NONE'
     C                   MOVE      *BLANKS       FATXT
     C                   ENDIF
      *
     C                   SELECT
     C     FAAUT         WHENEQ    '*USE'
     C                   MOVE      1             FAASEQ
     C     FAAUT         WHENEQ    '*CHANGE'
     C                   MOVE      2             FAASEQ
     C     FAAUT         WHENEQ    '*ALL'
     C                   MOVE      3             FAASEQ
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
     C                   PARM                    FAUSR
     C                   PARM                    FAFLR
     C                   PARM                    FAAUT
     C                   PARM                    FATXT
      *
     C     FAKEY2        KLIST
     C                   KFLD                    FAFLR
     C                   KFLD                    FAUSR
      *
     C     *DTAARA       DEFINE    AUT100D       DSUSR
     C     *DTAARA       DEFINE    AUT101D       DSFLR
      *
     C     *LIKE         DEFINE    FAAUT         SVAUT
     C     *LIKE         DEFINE    FATXT         SVTXT
      *
     C                   MOVE      *ZERO         X                 5 0
     C                   MOVE      *ZERO         RESULT            5 0
      *
     CSR   #DEFN         ENDSR
