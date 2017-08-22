      /TITLE Transfer to PC Document
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
      *   *                                               *
      *   *                                               *
      *   *                                               *
      *   *                                               *
      *   *                                               *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      ************************************************************************
      /EJECT
      *
      *
     FQADSPFFD  IF   E             DISK
     FXFRINPF   IF   F 1024        DISK
     FXFROUTF   O  A F 1024        DISK
      *
     D AY3             S              1    DIM(15)                              WORK ARRAY 3
      *
     D XFRINP          DS          1024
     D  AY1                    1   1024
     D                                     DIM(1024)                            WORK ARRAY 1
      *
     D XFROUT          DS          1024
     D  AY2                    1   1024
     D                                     DIM(1024)                            WORK ARRAY 2
      *
     D UNPACK          DS
     D  PCKNUM                 1     15P 0
      *
     D DSPFFD        E DS                  OCCURS(500) EXTNAME(QADSPFFD)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /EJECT
     C                   EXSR      $PROCS                                       PROCESS.
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PROCESS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PROCS        BEGSR
      *
     C     *INLR         DOUEQ     *ON                                          RETRIEVE
     C                   READ      XFRINPF       XFRINP                   LR     TRANSFER
     C     *INLR         IFEQ      *OFF                                          RECORDS.
     C                   CLEAR                   XFROUT
     C                   CLEAR                   Y                 5 0
      *
     C                   DO        MXOCUR        OCUR              5 0
     C     OCUR          OCCUR     DSPFFD
     C     WHIBO         ADD       WHFLDB        END               5 0          BGN+LEN=END+1
     C                   SUB       1             END                            -1 =END
     C     WHFLDD        CASNE     *ZERO         $NUMBR
     C     WHFLDD        CASEQ     *ZERO         $ALPHA
     C                   ENDCS
     C                   ADD       1             Y
     C                   MOVEA     ','           AY2(Y)
     C                   ENDDO
      *
     C                   EXCEPT    #WRITE
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #PROCS        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   NUMERIC FIELD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $NUMBR        BEGSR
      *
     C                   MOVE      *LOVAL        UNPACK
     C                   Z-ADD     15            X                 5 0
     C                   MOVE      *LOVAL        AY3
      *
     C     END           DOULT     WHIBO                                        SHIFT LEFT
     C                   MOVEA     AY1(END)      WK001A            1             JUSTIFIED
     C                   MOVEA     WK001A        AY3(X)                          TO RIGHT
     C                   SUB       1             X                               JUSTIFIED.
     C                   SUB       1             END
     C                   ENDDO
      *
     C     WHFLDT        IFEQ      'P'                                          PACKED.
     C                   MOVEA     AY3           UNPACK
     C                   MOVE      PCKNUM        NUMINP
     C                   ELSE                                                   ZONED.
     C                   MOVEA     AY3           WK015A           15
     C                   MOVE      WK015A        NUMINP
     C                   ENDIF
      *
     C                   MOVE      WHFLDP        NBRDEC                         EDIT.
     C                   MOVE      'P'           EDTCDE
     C                   EXSR      $EDVAR
     C                   ADD       1             Y
     C                   MOVEA     CHROUT        AY2(Y)
     C     ' '           SCAN      CHROUT        X
     C                   SUB       1             X
     C                   ADD       X             Y
      *
     CSR   #NUMBR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   ALPHA FIELD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ALPHA        BEGSR
      *
     C                   ADD       1             Y
     C                   MOVEA     '"'           AY2(Y)
      *
     C     WHIBO         DO        END           X                              REMOVE
     C     AY1(X)        IFEQ      *BLANKS                                       BLANKS,
     C     AY1(X)        OREQ      ''''                                          SGL QUOTES,
     C     AY1(X)        OREQ      '"'                                           DBL QUOTES,
     C     AY1(X)        OREQ      ','                                           COMMAS.
     C                   ADD       1             Y
     C                   ELSE
     C                   MOVEA     AY1(X)        WK001A
     C                   ADD       1             Y
     C                   MOVEA     WK001A        AY2(Y)
     C                   ENDIF
     C                   ENDDO
      *
     C     Y             DOULE     *ZERO
     C     AY2(Y)        ORNE      *BLANKS
     C                   SUB       1             Y
     C                   ENDDO
      *
     C                   ADD       1             Y
     C                   MOVEA     '"'           AY2(Y)
      *
     CSR   #ALPHA        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$EDVAR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   DO        500           MXOCUR            5 0
     C     MXOCUR        OCCUR     DSPFFD
     C                   READ      QADSPFFD                               99
     C  N99              ENDDO
     C                   SUB       1             MXOCUR
      *
     CSR   #INZSR        ENDSR
      *
     OXFROUTF   EADD         #WRITE
     O                       XFROUT
