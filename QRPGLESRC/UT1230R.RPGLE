      /TITLE Edit Variable
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: 11/28/87
      *   REMARKS:       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   REVISED:       MM/DD/YY  BY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *   REVISED DESC:                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *   *  Property of Bogar Incorporated               *
      *   *  18800 Cox Avenue                             *
      *   *  Saratoga, California  95070                  *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      ************************************************************************
      *
      /copy qcpysrc,Hspec
      *
     D AY2             S              1    DIM(22)                              WORK ARRAY 2
      *
      /copy qcpysrc,Dspec
      *
     C                   EXSR      $EDVAR
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  EDIT VARIABLE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $EDVAR        BEGSR
      *
     C                   CLEAR                   AY2
     C                   CLEAR                   NUMVRC
     C                   CLEAR                   CHRVAR
     C                   MOVE      *OFF          PRTSW
     C                   Z-ADD     1             X
     C                   CLEAR                   Y
     C                   CLEAR                   Z
      *
     C     PLedtcde      IFEQ      'W'                                          CANNOT HAVE
     C     PLedtcde      OREQ      'Y'                                           ANY DECIMALS.
     C     PLedtcde      OREQ      'Z'
     C     PLnbrdec      IFNE      *ZERO
     C                   MOVE      'GNL0063'     MSGID
     C                   MOVE      ZZPGM         TOPGM
     C                   MOVEL     '*PRV'        TOREL
     C                   EXSR      $PMSND
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C     PLedtcde      IFEQ      'K'
     C     PLedtcde      OREQ      'M'
     C     PLedtcde      OREQ      'O'
     C     PLedtcde      OREQ      'Q'
     C     PLedtcde      OREQ      'Z'
     C     NUMVAR        IFEQ      *ZERO
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C     PLnbrdec      ADD       1             Z
     C                   MOVE      NUMVAR        NUMVR2
      *
     C     NUMVAR        IFLT      *ZERO
     C                   Z-SUB     NUMVAR        NUMVR2
     C                   ENDIF
      *
     C                   MOVE      NUMVR2        NUMVRC
      *
     C     LDGSYM        IFEQ      '*YES'
     C                   ADD       1             Y
     C                   MOVEL     CURSYM        AY2(Y)
     C                   ENDIF
      *
     C     PLedtcde      IFEQ      'N'
     C     PLedtcde      OREQ      'O'
     C     PLedtcde      OREQ      'P'
     C     PLedtcde      OREQ      'Q'
     C     NUMVAR        IFLT      *ZERO
     C                   ADD       1             Y
     C                   MOVEA     '-'           AY2(Y)
     C                   ENDIF
     C                   ENDIF
      *
     C     X             DOUEQ     16
     C     16            SUB       X             WK030N            3 0
     C     WK030N        IFEQ      PLnbrdec
     C                   ADD       1             Y
     C                   MOVEA     DECCHR        AY2(Y)
     C                   MOVE      *ON           PRTSW
     C                   ENDIF
      *
     C     PLedtcde      IFEQ      'W'
     C     PLedtcde      OREQ      'Y'
     C     Z             IFEQ      10
     C                   MOVE      *ON           PRTSW
     C                   ENDIF
     C                   ENDIF
      *
     C     1             SUBST     NUMVRC:X      WK001A            1
     C     PRTSW         IFEQ      *ON
     C     WK001A        ORNE      '0'
     C                   ADD       1             Y
     C                   MOVEA     WK001A        AY2(Y)
     C                   MOVE      *ON           PRTSW
      *
     C     PLedtcde      IFEQ      'J'
     C     PLedtcde      OREQ      'K'
     C     PLedtcde      OREQ      'N'
     C     PLedtcde      OREQ      'O'
     C     Z             IFEQ      3
     C     Z             OREQ      6
     C     Z             OREQ      9
     C     Z             OREQ      12
     C                   ADD       1             Y
     C                   MOVEA     SEPCHR        AY2(Y)
     C                   ENDIF
     C                   ENDIF
      *
     C     Z             IFEQ      11
     C     Z             OREQ      13
     C     PLedtcde      IFEQ      'W'
     C                   ADD       1             Y
     C                   MOVEA     ':'           AY2(Y)
     C                   ENDIF
     C     PLedtcde      IFEQ      'Y'
     C                   ADD       1             Y
     C                   MOVEA     '/'           AY2(Y)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             Z
     C                   ADD       1             X
      *
     C     X             IFEQ      15
     C                   MOVE      *ON           PRTSW
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     PLedtcde      IFEQ      'J'
     C     PLedtcde      OREQ      'K'
     C     PLedtcde      OREQ      'L'
     C     PLedtcde      OREQ      'M'
     C     NUMVAR        IFLT      *ZERO
     C                   ADD       1             Y
     C                   MOVEA     '-'           AY2(Y)
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEA     AY2           CHRVAR
      *
     CSR   #EDVAR        ENDSR
      /SPACE 4
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      '$'           CURSYM            1
     C                   MOVE      '.'           DECCHR            1
     C                   MOVE      ','           SEPCHR            1
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    CHRVAR           22
     C                   PARM                    NUMVAR           15 0
     C                   PARM                    PLnbrdec          1 0
     C                   PARM                    PLedtcde          1
     C                   PARM                    LDGSYM            4
      *
     C                   CLEAR                   WK030N            3 0
     C                   CLEAR                   NUMVR2           15 0
     C                   CLEAR                   NUMVRC           15
     C                   MOVE      *OFF          PRTSW             1
     C                   CLEAR                   X                 3 0
     C                   CLEAR                   Y                 3 0
     C                   CLEAR                   Z                 3 0
      *
     CSR   #DEFN         ENDSR
