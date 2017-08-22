      /TITLE Print Journal Analysis, by Date/Time
      *
      * P: PARMS USRPRF(*OWNER) AUT(*ALL)
      *
      * S: PRINTS JOURNAL ANALYSIS BY DATE AND TIME.
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
      *                                                  (XFER BASED)
     D XFRT            S              9  0 DIM(50)
      *
     D ENTDS           DS           250
     D  XFRL                   1    250  0
     D                                     DIM(50)
      *
     IPJA000R
     I                                          FSDTE         L2
     I                                          FSTME         L1
      /EJECT
     C     *INL2         IFEQ      ON
     C                   MOVE      ON            *INOF
     C                   ENDIF
      *
     C                   EXSR      $ACCUM
      *
     C                   EXSR      $LENGT
      *
     CL1                 EXSR      $L1TOT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ACCUMULATE TOTALS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ACCUM        BEGSR
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
     C                   MOVE      *ZERO         TRNCNT            9 0
     C                   ADD       FSADD         TRNCNT
     C                   ADD       FSUPD         TRNCNT
     C                   ADD       FSDLT         TRNCNT
      *
     CSR   #ACCUM        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE FILE LENGTH AND INDEX.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LENGT        BEGSR
      *
     C                   DO        PRMCNT        X
     C     FSLEN         IFLE      XFRL(X)
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
     CSR   #LENGT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * L1 TOTALS PRE-PROCESSING  (EACH HOUR)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $L1TOT        BEGSR
      *
     C                   DO        PRMCNT        X
     C     XFRT(X)       IFNE      *ZERO
     C     XFRT(X)       MULT      XFRL(X)       WK150N           15 0
     C                   ADD       WK150N        L1BYTE           15 0
     C                   ADD       WK150N        LRBYTE           15 0
     C                   MOVE      *ZERO         XFRT(X)
     C                   ENDIF
     C                   ENDDO
      *
     C                   ADD       L1BYTE        OVRFLW           15 0
     C                   SUB       BYTEHR        OVRFLW
      *
     C     OVRFLW        IFLT      *ZERO
     C                   MOVE      *ZERO         OVRFLW
     C                   END
      *
     C     BYTEHR        IFNE      *ZERO
     C     L1BYTE        ADD       OVRFLW        WK155N           15 5
     C                   DIV       BYTEHR        WK155N
     C     WK155N        MULT      100           LINUTL            4 1
     C                   END
      *
     C     LINUTL        IFGT      100
     C                   Z-ADD     100           LINUTL
     C                   END
      *
     C                   EXCEPT    #TTL01
     C                   MOVE      *ZERO         L1OPN
     C                   MOVE      *ZERO         L1CLO
     C                   MOVE      *ZERO         L1ADD
     C                   MOVE      *ZERO         L1UPD
     C                   MOVE      *ZERO         L1DLT
     C                   MOVE      *ZERO         L1BYTE
      *
     CSR   #L1TOT        ENDSR
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
      *
     C     LINSPD        IFNE      *ZERO
     C     LINSPD        DIV       8             BYTEHR           15 0
     C                   MULT      LINEFC        BYTEHR
     C                   MULT      60            BYTEHR
     C                   MULT      60            BYTEHR
     C                   END
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
     OQSYSPRT   H    OF                     2 06
     O                       UDATE         Y   +  0
     O                       UTIME             +  1 '0 .  .  '
     O                                           55 'Print Journal Analysis'
     O                                         +  3 'Type . . . *DATTIM'
     O                                         +  3 'Member . .'
     O                       MBR               +  1
     O                                          127 'Page'
     O                       PAGE          Z   +  1
      *
     OQSYSPRT   H    OF                     1
     O                                         +  0 '  Date  '
     O                                         +  1 'Time'
     O                                         +  1 '    Opens'
     O                                         +  1 '   Closes'
     O                                         +  1 '     Adds'
     O                                         +  1 '  Updates'
     O                                         +  1 '  Deletes'
     O                                         +  1 '              Bytes'
     O                                         +  1 '     Overflow Bytes'
     O                                         +  1 'Line Utl'
      *
     OQSYSPRT   H    OF                     1
     O                                         +  0 '--------'
     O                                         +  1 '----'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '---------'
     O                                         +  1 '-------------------'
     O                                         +  1 '-------------------'
     O                                         +  1 '--------'
      *
     OQSYSPRT   EF           #TTL01         1
     O                       FSDTE         Y   +  0
     O                       FSTME         2   +  2
     O                       L1OPN         Z   +  2
     O                       L1CLO         Z   +  1
     O                       L1ADD         Z   +  1
     O                       L1UPD         Z   +  1
     O                       L1DLT         Z   +  1
     O                       L1BYTE        2   +  1
     O                       OVRFLW        2   +  1
     O                       LINUTL        1   +  4
     O                                         +  0 '%'
      *
     OQSYSPRT   TF   LR                  1  1
     O                                         +  0 '        '
     O                                         +  1 '    '
     O                       LROPN         Z   +  1
     O                       LRCLO         Z   +  1
     O                       LRADD         Z   +  1
     O                       LRUPD         Z   +  1
     O                       LRDLT         Z   +  1
     O                       LRBYTE        2   +  1
     O                                         +  1 '*'
      *
     OQSYSPRT   TF   LR                  1  1
     O                                         +  0 'Records processed  . . .'
     O                       TRNCNT        1   +  9
      *
     OQSYSPRT   TF   LR                  1  1
     O                                         +  0 'Line speed . . . . . . .'
     O                       LINSPD        1   +  9
      *
     OQSYSPRT   TF   LR                     1
     O                                         +  0 'Line efficiency  . . . .'
     O                       LINEFC        1   + 14
      *
     OQSYSPRT   TF   LR                     1
     O                                         +  0 'Bytes per hour . . . . .'
     O                       BYTEHR        1   +  1
