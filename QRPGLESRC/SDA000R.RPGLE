      /TITLE Set Display Attributes
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S: The SETDSPATR command applies display attributes
      * S: to a source member, highlighting words or phrases
      * S: that require additional attention.
      *
      * C: 92/07/21  TIM HAWKINS
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     FSRCMBR    UF   F   92        DISK
     F                                     INFDS(DBFDS)
      *
     D AY1             S              1    DIM(80)
      *
     D TAG             S              6    DIM(20) CTDATA PERRCD(1)
     D ATR             S              1    DIM(20) ALT(TAG)
      *
     D SRCDS           DS
     D  SRCDTA                13     92
      *
     D DBFDS         E DS                  EXTNAME(DSDBF)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
      *
     C                   EXSR      $READ
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * READ THROUGH THE SOURCE FILE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $READ         BEGSR
      *
     C     *INLR         DOUEQ     *ON
     C                   READ      SRCMBR        SRCDS                    LR
     C     *INLR         IFEQ      *OFF
     C     ATTR          CASEQ     '*ON '        $TAGS
     C     ATTR          CASEQ     '*OFF'        $ATRS
     C                   ENDCS
     C     UPDATE        IFEQ      *ON
     C                   UPDATE    SRCMBR        SRCDS
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #READ         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SCAN THE SOURCE STATEMENT FOR THE UIM TAGS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TAGS         BEGSR
      *
     C                   MOVE      *OFF          UPDATE            1
      *
     C     SCNPOS        DOUEQ     *ZERO
     C                   DO        20            X
     C                   MOVEL     ATR(X)        DSPATR
     C     X             IFLE      10
     C                   MOVEL     TAG(X)        TAG5
     C                   MOVE      5             LENGTH
     C     TAG5          SCAN      SRCDTA        SCNPOS
     C                   ELSE
     C                   MOVEL     TAG(X)        TAG6
     C                   MOVE      6             LENGTH
     C     TAG6          SCAN      SRCDTA        SCNPOS
     C                   ENDIF
      *
     C     SCNPOS        IFNE      *ZERO
     C                   MOVE      *ON           UPDATE
     C                   EXSR      $RPLT
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDDO
      *
     CSR   #TAGS         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * REPLACE TAGS WITH DISPLAY ATTRIBUTES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RPLT         BEGSR
      *
     C                   MOVEA     SRCDTA        AY1(1)
     C                   MOVE      SCNPOS        X
     C     LENGTH        IFEQ      5
     C                   MOVEA     '     '       AY1(X)
     C     SCNPOS        ADD       LENGTH        X
     C                   SUB       1             X
     C                   ELSE
     C                   MOVEA     '      '      AY1(X)
     C                   MOVE      SCNPOS        X
     C                   ENDIF
     C                   MOVEA     DSPATR        AY1(X)
     C                   MOVEA     AY1           SRCDTA
      *
     CSR   #RPLT         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SCAN THE SOURCE STATEMENT FOR THE DSPATRS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ATRS         BEGSR
      *
     C                   MOVE      *OFF          UPDATE
      *
     C     SCNPOS        DOUEQ     *ZERO
     C                   DO        10            X
     C     X             ADD       10            Y
     C                   MOVEL     ATR(X)        DSPATR
     C     DSPATR        SCAN      SRCDTA        SCNPOS
      *
     C     SCNPOS        IFNE      *ZERO
     C                   MOVEL     TAG(X)        TAG5
     C                   MOVE      5             LENGTH
     C                   MOVE      *ON           UPDATE
     C                   EXSR      $RPLA
      *
     C                   MOVE      *LOVAL        DSPATR
     C                   BITON     '2'           DSPATR
     C     DSPATR        SCAN      SRCDTA        SCNPOS
      *
     C     SCNPOS        IFNE      *ZERO
     C                   MOVEL     TAG(Y)        TAG6
     C                   MOVE      6             LENGTH
     C                   MOVE      *ON           UPDATE
     C                   EXSR      $RPLA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDDO
      *
     CSR   #ATRS         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * REPLACE TAGS WITH DISPLAY ATTRIBUTES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RPLA         BEGSR
      *
     C                   MOVEA     SRCDTA        AY1(1)
     C     LENGTH        IFEQ      5
     C     SCNPOS        SUB       LENGTH        X
     C                   ADD       1             X
     C                   MOVEA     '     '       AY1(X)
     C                   MOVEA     TAG5          AY1(X)
     C                   ELSE
     C                   MOVE      SCNPOS        X
     C                   MOVEA     '      '      AY1(X)
     C                   MOVEA     TAG6          AY1(X)
     C                   ENDIF
     C                   MOVEA     AY1           SRCDTA
      *
     CSR   #RPLA         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *LOVAL        ATR
     C**                   BITON'2'       ATR,01           X'20'         HP0
     C                   BITON     '25'          ATR(02)
     C                   BITON     '26'          ATR(03)
     C                   BITON     '256'         ATR(04)
     C**                   BITON'2'       ATR,05           X'20'         HP4
     C                   BITON     '27'          ATR(06)
     C                   BITON     '257'         ATR(07)
     C                   BITON     '267'         ATR(08)
     C**                   BITON'267'     ATR,09           X'23' HI  RI  HP8
     C**                   BITON'27'      ATR,10           X'21'     RI  HP9
     C**                   BITON'2'       ATR,11           X'20'        EHP0
     C                   BITON     '2'           ATR(12)
     C                   BITON     '2'           ATR(13)
     C                   BITON     '2'           ATR(14)
     C**                   BITON'2'       ATR,15           X'20'        EHP4
     C                   BITON     '2'           ATR(16)
     C                   BITON     '2'           ATR(17)
     C                   BITON     '2'           ATR(18)
     C**                   BITON'2'       ATR,19           X'20'        EHP8
     C**                   BITON'2'       ATR,20           X'20'        EHP9
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ATTR              4
      *
     C                   MOVE      *ZERO         X                 5 0
     C                   MOVE      *ZERO         Y                 5 0
     C                   MOVE      *BLANKS       DSPATR            1
     C                   MOVE      *ZERO         SCNPOS            5 0
     C                   MOVE      *BLANKS       TAG5              5
     C                   MOVE      *BLANKS       TAG6              6
     C                   MOVE      *ZERO         LENGTH            1 0
     C                   MOVE      *OFF          UPDATE            1
      *
     CSR   #DEFN         ENDSR
**    * TAG/ATR -- UIM TAGS AND DISPLAY ATTRIBUTES
///0.
:HP1.
:HP2.
:HP3.
///4.
:HP5.
:HP6.
:HP7.
///8.
///9.
////0.
:EHP1.
:EHP2.
:EHP3.
////4.
:EHP5.
:EHP6.
:EHP7.
////8.
////9.
