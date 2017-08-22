      /TITLE Print Journal Analysis, by File
      *
      * P: PARMS USRPRF(*OWNER) AUT(*ALL)
      *
      * S: PRINTS JOURNAL ANALYSIS BY FILE
      *
      * C: 91/12/03  RCTHAWK
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
     FPJA000P   IP   E             DISK
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      *
     D SORT            S             14    DIM(1000)
      *
      *                                                  (FILE BASED)
     D FILL            S              5  0 DIM(1000)
     D FILT            S              9  0 DIM(1000)
      *
      *                                                  (GROUP BASED)
     D GRPL            S              5  0 DIM(50)
     D GRPT            S              9  0 DIM(50)
      *
      *                                                  (XFER BASED)
     D XFRT            S              9  0 DIM(50)
      *
     D ENTDS           DS           250
     D  XFRL                   1    250  0
     D                                     DIM(50)
      *
     IPJA000R
     I                                          FSLIB         L1
     I                                          FSOBJ         L1
      *
     C                   EXSR      $ACCUM
      *
     C                   EXSR      $LENGT
      *
     CL1                 EXSR      $L1TOT
      *
     CLR                 EXSR      $LRTOT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ACCUMULATE TOTALS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ACCUM        BEGSR
      *
     C     FSLEN         IFNE      *ZERO
     C                   Z-ADD     FSLEN         L1LEN             5 0
     C                   ENDIF
      *
     C                   ADD       FSOPN         L1OPN             9 0
     C                   ADD       FSCLO         L1CLO             9 0
     C                   ADD       FSADD         L1ADD             9 0
     C                   ADD       FSUPD         L1UPD             9 0
     C                   ADD       FSDLT         L1DLT             9 0
      *
     C                   ADD       FSOPN         LROPN             9 0
     C                   ADD       FSCLO         LRCLO             9 0
     C                   ADD       FSADD         LRADD             9 0
     C                   ADD       FSUPD         LRUPD             9 0
     C                   ADD       FSDLT         LRDLT             9 0
      *
     C                   ADD       FSADD         TRNCNT           11 0
     C                   ADD       FSUPD         TRNCNT
     C                   ADD       FSDLT         TRNCNT
      *
     CSR   #ACCUM        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CALCULATE FILE LENGTH TRANSACTION INDEX.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LENGT        BEGSR
      *
     C                   DO        PRMCNT        X
     C     L1LEN         IFLE      XFRL(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C     PRMCNT        IFGT      *ZERO
     C     X             ANDGT     *ZERO
     C     X             ANDLE     50
     C                   ADD       TRNCNT        XFRT(X)
     C                   ENDIF
      *
     C                   DO        1000          X
     C     FILL(X)       IFEQ      *ZERO
     C                   ADD       L1LEN         FILL(X)
     C                   ADD       TRNCNT        FILT(X)
     C                   LEAVE
     C                   ELSE
     C     L1LEN         IFEQ      FILL(X)
     C                   ADD       TRNCNT        FILT(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #LENGT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $L1TOT        BEGSR
      *
     C                   EXSR      $RTVTX
      *
     C                   DO        PRMCNT        X
     C     L1LEN         IFLE      XFRL(X)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C     PRMCNT        IFGT      *ZERO
     C     X             ANDGT     *ZERO
     C     X             ANDLE     50
     C     TRNCNT        MULT      XFRL(X)       LENGTH           15 0
     C                   ELSE
     C     TRNCNT        MULT      L1LEN         LENGTH
     C                   ENDIF
      *
     C     BYTEHR        IFNE      *ZERO
     C     LENGTH        DIV       BYTEHR        HRS1              4 2
     C                   ADD       HRS1          HRS2              4 2
     C                   ENDIF
      *
     C     *INOF         IFEQ      ON
     C                   EXCEPT    #HDG00
     C                   EXCEPT    #HDG01
     C                   MOVE      OFF           *INOF
     C                   ENDIF
      *
     C     TRNCNT        IFGE      MINTNS
     C                   EXCEPT    #TTL01
     C                   ENDIF
      *
     C                   MOVE      *ZERO         L1LEN
     C                   MOVE      *ZERO         L1OPN
     C                   MOVE      *ZERO         L1CLO
     C                   MOVE      *ZERO         L1ADD
     C                   MOVE      *ZERO         L1UPD
     C                   MOVE      *ZERO         L1DLT
     C                   MOVE      *ZERO         TRNCNT
      *
     CSR   #L1TOT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * LR TOTALS PRE-PROCESSING.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LRTOT        BEGSR
      *
     C                   EXCEPT    #TTL02
     C                   MOVE      *HIVAL        SORT
     C                   MOVE      ON            *INOF
      *
     C                   DO        1000          X
     C     FILL(X)       IFNE      *ZERO
     C                   MOVE      FILL(X)       WK005A            5
     C                   MOVE      FILT(X)       WK009A            9
     C                   MOVEL     WK005A        SORT(X)
     C                   MOVE      WK009A        SORT(X)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   SORTA     SORT
      *
     C                   DO        1000          X
     C     SORT(X)       IFNE      *HIVAL
     C                   MOVEL     SORT(X)       FILL(X)
     C                   MOVE      SORT(X)       FILT(X)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   DO        1000          X
     C     FILL(X)       IFNE      *ZERO
     C     FILL(X)       DIV       100           Y                 5 0
     C                   MVR                     REMNDR            5 0
     C     REMNDR        IFNE      *ZERO
     C                   ADD       1             Y
     C                   ENDIF
     C     Y             MULT      100           GRPL(Y)
     C                   ADD       FILT(X)       GRPT(Y)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   DO        50            X
     C     GRPL(X)       IFEQ      *ZERO
     C     X             MULT      100           GRPL(X)
     C                   ENDIF
     C                   ENDDO
      *
     C                   DO        50            X
     C     XFRL(X)       IFEQ      *HIVAL
     C                   MOVE      *ZERO         XFRL(X)
     C                   ENDIF
     C                   ENDDO
      *
     C                   DO        1000          X
      *
     C     *INOF         IFEQ      ON
     C                   EXCEPT    #HDG00
     C                   EXCEPT    #HDG90
     C                   MOVE      OFF           *INOF
     C                   ENDIF
      *
     C     FILT(X)       IFNE      *ZERO
     C     X             IFLE      50
     C                   EXCEPT    #TTL91
     C                   ENDIF
     C                   EXCEPT    #TTL92
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     CSR   #LRTOT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * RETRIEVE OBJECT TEXT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RTVTX        BEGSR
      *
     C                   CALL      'PJA900C'
     C                   PARM      FSOBJ         OBJNAM           10
     C                   PARM      FSLIB         OBJLIB           10
     C                   PARM      '*FILE'       OBJTYP           10
     C                   PARM      *BLANKS       OBJTXT           50
      *
     C                   MOVEL     OBJTXT        TEXT42           42
      *
     CSR   #RTVTX        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$EDVAR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      '0'           OFF               1
     C                   MOVE      '1'           ON                1
      *
     C                   TIME                    UTIME             6 0
     C                   MOVE      ON            *INOF
      *
     C     LINSPD        IFNE      *ZERO
     C     LINSPD        DIV       8             BYTEHR           15 0
     C                   MULT      LINEFC        BYTEHR
     C                   MULT      60            BYTEHR
     C                   MULT      60            BYTEHR
     C                   ENDIF
      *
     C                   DO        50            X                 5 0
     C     XFRL(X)       IFNE      *ZERO
     C                   ADD       1             PRMCNT            5 0
     C                   ELSE
     C                   MOVE      *HIVAL        XFRL(X)
     C                   ENDIF
     C                   ENDDO
      *
     C     PRMCNT        IFNE      *ZERO
     C                   ADD       1             PRMCNT
     C                   SORTA     XFRL
     C                   ENDIF
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MBR              10
     C                   PARM                    ENTDS
     C                   PARM                    MINTNS            5 0
     C                   PARM                    LINSPD            9 0
     C                   PARM                    LINEFC            5 4
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   E            #HDG00         2 06
     O                       UDATE         Y   +  0
     O                       UTIME             +  1 '0 .  .  '
     O                                           55 'Print Journal Analysis'
     O                                         +  3 'Type . . *FILE'
     O                                         +  3 'Member .'
     O                       MBR               +  1
     O                                          127 'Page'
     O                       PAGE          Z   +  1
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 'Library   '
     O                                         +  1 'File      '
     O                                         +  1 'Text                '
     O                                         +  0 '                    '
     O                                         +  0 '  '
     O                                         +  1 '    Opens'
     O                                         +  1 '   Closes'
     O                                         +  1 '     Adds'
     O                                         +  1 '  Updates'
     O                                         +  1 '  Deletes'
     O                                         +  1 'Length'
     O                                         +  1 'Hours'
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '--------------------'
     O                                         +  0 '--------------------'
     O                                         +  0 '--'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '------'
     O                                         +  1 '-----'
      *
     OQSYSPRT   E            #TTL01         1
     O                       FSLIB             +  0
     O                       FSOBJ             +  1
     O                       TEXT42            +  1
     O                       L1OPN         Z   +  1
     O                       L1CLO         Z   +  1
     O                       L1ADD         Z   +  1
     O                       L1UPD         Z   +  1
     O                       L1DLT         Z   +  1
     O                       L1LEN         1   +  1
     O                       HRS1          2   +  1
      *
     OQSYSPRT   E            #TTL02      1  1
     O                                         +  0 '          '
     O                                         +  1 '          '
     O                                         +  1 '                    '
     O                                         +  0 '                    '
     O                                         +  0 '  '
     O                       LROPN         Z   +  1
     O                       LRCLO         Z   +  1
     O                       LRADD         Z   +  1
     O                       LRUPD         Z   +  1
     O                       LRDLT         Z   +  1
     O                                         +  1 '      '
     O                       HRS2          2   +  1
     O                                         +  1 '*'
      *
     OQSYSPRT   E            #HDG90         2
     O                                         +  0 'Size analysis:'
      *
     OQSYSPRT   E            #HDG90         1
     O                                         +  1 '..... Database ....'
     O                                         +  5 '..... Grouping ....'
     O                                         +  5 '.. Communications .'
      *
     OQSYSPRT   E            #HDG90         1
     O                                         +  1 'Length'
     O                                         +  1 'Transactions'
     O                                         +  5 'Length'
     O                                         +  1 'Transactions'
     O                                         +  5 'Length'
     O                                         +  1 'Transactions'
      *
     OQSYSPRT   E            #HDG90         1
     O                                         +  1 '------'
     O                                         +  1 '------------'
     O                                         +  5 '------'
     O                                         +  1 '------------'
     O                                         +  5 '------'
     O                                         +  1 '------------'
      *
     OQSYSPRT   E            #TTL91      0  0
     O                                         +  1 '         '
     O                                         +  1 '         '
     O                       GRPL(X)       1   +  5
     O                       GRPT(X)       1   +  2
     O                       XFRL(X)       1   +  5
     O                       XFRT(X)       1   +  2
      *
     OQSYSPRT   E            #TTL92         1
     O                       FILL(X)       1   +  1
     O                       FILT(X)       1   +  2
      *
     OQSYSPRT   T    LR                  2  1
     O                                         +  0 'Minimum transactions . .'
     O                       MINTNS        1   + 14
      *
     OQSYSPRT   T    LR                  1  1
     O                                         +  0 'Line speed . . . . . . .'
     O                       LINSPD        1   +  9
      *
     OQSYSPRT   T    LR                     1
     O                                         +  0 'Line efficiency  . . . .'
     O                       LINEFC        1   + 14
      *
     OQSYSPRT   T    LR                     1
     O                                         +  0 'Bytes per hour . . . . .'
     O                       BYTEHR        1   +  1
