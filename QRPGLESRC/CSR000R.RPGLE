      /TITLE Check Object/Source Relationship
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S: COMPARE THE RELATIONSHIPS BETWEEN SOURCE AND OBJECT FOUND
      * S:  IN THE NAMED LIBRARIES.
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
     FCSR100P1  IF   E           K DISK
     F                                     RENAME(QLIDOBJD:CSR100R1)
     FCSR100P2  IF   E           K DISK
     F                                     RENAME(QWHFDML:CSR100R2)
     FCSR100L3  UF   E           K DISK
     F                                     RENAME(QLIDOBJD:CSR100R3)
     FCSR100L4  UF   E           K DISK
     F                                     RENAME(QWHFDML:CSR100R4)
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
     D                 DS
     D  MLCHGD                 1      6
     D  MLCHG                  1      6  0
     D  ODSRCD                11     16
     D  ODSRC                 11     16  0
      *
      /EJECT
     C     *IN99         DOUEQ     ON
     C                   READ      CSR100R1                               99
     C  N99              EXSR      $OBJ
     C                   ENDDO
      *
     C                   MOVE      ON            *INOF
      *
     C     *IN99         DOUEQ     ON
     C                   READ      CSR100R2                               99
     C  N99              EXSR      $SRC
     C                   ENDDO
      *
     C                   MOVE      ON            *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * OBJECT/SOURCE RELATIONSHIP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OBJ          BEGSR
      *
     C                   MOVEL     ODLBNM        WK001A            1
     C     WK001A        IFEQ      'Q'
     C     ODOBNM        OREQ      'QCLSRC'
     C     ODOBNM        OREQ      'QRPGSRC'
     C     ODOBNM        OREQ      'QCBLSRC'
     C     ODOBNM        OREQ      'QDDSSRC'
     C     ODOBNM        OREQ      'QS36SRC'
     C     ODOBNM        OREQ      'QS36PRC'
     C     ODOBNM        OREQ      'QREXSRC'
     C     ODOBNM        OREQ      'QCMDSRC'
     C     ODOBNM        OREQ      'QTXTSRC'
     C     ODOBNM        OREQ      'QFMTSRC'
     C     ODOBNM        OREQ      'QMENUSRC'
     C     ODOBNM        OREQ      'QS36DDSS'
     C     ODOBTP        OREQ      '*DTAQ'
     C     ODOBTP        OREQ      '*JOBD'
     C     ODOBTP        OREQ      '*MSGQ'
     C     ODOBTP        OREQ      '*OUTQ'
     C     ODOBTP        OREQ      '*TBL'
     C     ODOBTP        OREQ      '*MENU'
     C     ODOBTP        OREQ      '*DTAQ'
     C     ODOBTP        OREQ      '*MSGF'
     C     ODOBTP        OREQ      '*DTAARA'
     C     ODOBTP        OREQ      '*QRYDFN'
     C     ODOBAT        OREQ      'QRYEXC'
     C     ODOBAT        OREQ      'DFU'
     C     ODOBAT        OREQ      'SAVF'
     C     ODOBAT        OREQ      'MI'
     C                   GOTO      #OBJ
     C                   ENDIF
      *
     C     ODOBTP        IFEQ      '*CMD  '
     C                   MOVEL     'CMD'         SRCATR
     C                   ELSE
     C                   MOVE      ODOBAT        SRCATR
     C                   ENDIF
      *
     C     ODOBTP        IFEQ      '*CMD  '
     C                   MOVE      *BLANKS       OBJATR
     C                   ELSE
     C                   MOVE      ODOBAT        OBJATR
     C                   ENDIF
      *
     C                   MOVE      OFF           EXECPT
      *
     C     OMTSGL        IFEQ      '*YES'
     C     SRCKEY        SETLL     CSR100R4
     C     SRCKEY        READE     CSR100R4                               98
     C     *IN98         IFEQ      ON
     C                   MOVE      ON            EXECPT
     C                   ELSE
     C     SRCKEY        READE     CSR100R4                               98
     C     *IN98         IFEQ      OFF
     C                   MOVE      ON            EXECPT
     C                   ELSE
     C     OBJKEY        SETLL     CSR100R3
     C     OBJKEY        READE     CSR100R3                               98
     C     *IN98         IFEQ      ON
     C                   MOVE      ON            EXECPT
     C                   ELSE
     C     OBJKEY        READE     CSR100R3                               98
     C     *IN98         IFEQ      OFF
     C                   MOVE      ON            EXECPT
     C                   ELSE
     C                   GOTO      #OBJ
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     PRTEXP        IFEQ      '*YES'
     C     SRCKEY        SETLL     CSR100R4
     C     SRCKEY        READE     CSR100R4                               98
     C     EXECPT        IFEQ      ON
     C     ODSRCC        ORNE      MLCHGC
     C     ODSRCD        ORNE      MLCHGD
     C     ODSRCT        ORNE      MLCHGT
     C                   EXSR      $OBJPR
     C                   ENDIF
     C                   ELSE
     C                   EXSR      $OBJPR
     C                   ENDIF
      *
     CSR   #OBJ          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * OBJECT/SOURCE RELATIONSHIP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OBJPR        BEGSR
      *
     C                   EXCEPT    OBJDTL
     C                   MOVE      OFF           PRTSPC
      *
     C     *IN98         DOUEQ     ON
     C     *IN97         ANDEQ     ON
     C     OBJKEY        SETLL     CSR100R3
     C     OBJKEY        READE     CSR100R3                               98
     C     *IN98         IFEQ      OFF
     C                   DELETE    CSR100R3
     C                   TESTN                   ODSRCD               30
     C  N30              MOVE      *ZERO         ODSRC
     C                   MULT      100.0001      ODSRC
     C                   EXCEPT    OBJOBJ
     C                   MOVE      ON            PRTSPC
     C                   ENDIF
      *
     C     SRCKEY        SETLL     CSR100R4
     C     SRCKEY        READE     CSR100R4                               97
     C     *IN97         IFEQ      OFF
     C                   DELETE    CSR100R4
     C                   TESTN                   MLCHGD               30
     C  N30              MOVE      *ZERO         MLCHG
     C                   MULT      100.0001      MLCHG
     C                   EXCEPT    OBJSRC
     C                   MOVE      ON            PRTSPC
     C                   ENDIF
      *
     C     PRTSPC        IFEQ      ON
     C                   MOVE      OFF           PRTSPC
     C                   EXCEPT    SPACE1
     C                   ENDIF
     C                   ENDDO
      *
     C                   EXCEPT    SPACE1
      *
     CSR   #OBJPR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SOURCE/OBJECT RELATIONSHIP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SRC          BEGSR
      *
     C     OSRW3         CHAIN     CSR100R3                           98
     C     *IN98         IFEQ      ON
     C                   EXCEPT    SRCDTL
     C                   ENDIF
      *
     CSR   #SRC          ENDSR
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
     C                   MOVE      OFF           EXECPT            1
     C                   MOVE      OFF           FSTTIM            1
     C                   MOVE      OFF           PRTSPC            1
     C                   MOVE      OFF           PRTOBJ            1
     C                   MOVE      ON            *INOF
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ZDEFN        BEGSR
      *
     C     *LIKE         DEFINE    ODOBAT        SRCATR
     C     *LIKE         DEFINE    ODOBAT        OBJATR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTEXP            4
     C                   PARM                    OMTSGL            4
      *
     C     OSRW3         KLIST
     C                   KFLD                    MLNAME
     C                   KFLD                    MLSEU2
      *
     C     SRCKEY        KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    SRCATR
      *
     C     OBJKEY        KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    OBJATR
      *
     CSR   #ZDEFN        ENDSR
      *
     OQSYSPRT   H    OF                     2 03
     O                       UDATE         Y      8
     O                       UTIME               19 ' 0.  .  '
     O                                         + 36 'OBJECT/SOURCE'
     O                                         +  1 'RELATIONSHIP'
     O                       ZZPGM              122
     O                                          128 'PAGE'
     O                       PAGE          Z    132
      *
     OQSYSPRT   H    OF                     1
     O                                         +  0 '          '
     O                                         +  1 '          '
     O                                         + 61 '          '
     O                                         +  1 'Object  '
     O                                         +  1 '          '
     O                                         +  1 '          '
     O                                         +  1 '        '
      *
     OQSYSPRT   H    OF                     1
     O                                         +  0 'Object/   '
     O                                         +  1 'Type/     '
     O                                         + 61 'Object    '
     O                                         +  1 'Source  '
     O                                         +  1 'Source    '
     O                                         +  1 'Source    '
     O                                         +  1 ' Changed'
      *
     OQSYSPRT   H    OF                     1
     O                                         +  0 'File      '
     O                                         +  1 'Member    '
     O                                         +  1 'Attr    '
     O                                         +  1 'Text                '
     O                                         +  0 '                    '
     O                                         +  0 '          '
     O                                         +  1 'Library   '
     O                                         +  1 '  Date  '
     O                                         +  1 'Library   '
     O                                         +  1 'File      '
     O                                         +  1 '  Date  '
      *
     OQSYSPRT   H    OF                     1
     O                                         +  0 '----------'
     O                                         +  1 '--------'
     O                                         +  1 '----------'
     O                                         +  1 '--------------------'
     O                                         +  0 '--------------------'
     O                                         +  0 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '--------'
     O                                         +  1 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '--------'
      *
     OQSYSPRT   EF           OBJDTL      0  0
     O                       ODOBNM            +  0
     O                       ODOBTP            +  1
     O                       ODOBAT            +  1
     O                       ODOBTX            +  1
      *
     OQSYSPRT   E            OBJOBJ      0  0
     O                       ODLBNM            + 82
     O                       ODSRC             +  1 '  /  / 0'
      *
     OQSYSPRT   E            OBJSRC      0  0
     O                       MLLIB             +102
     O                       MLFILE            +  1
     O                       MLCHG             +  1 '  /  / 0'
      *
     OQSYSPRT   EF           SRCDTL         1
     O                       MLFILE            +  0
     O                       MLNAME            +  1
     O                       MLSEU2            +  1
     O                       MLMTXT            +  1
      *
     OQSYSPRT   EF           SPACE1         1
