      /TITLE Display PCS Exit Program Log
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      *
      * S: PROGRAM AUT100R THE PC SUPPORT EXIT PROGRAMS WRITES
      * S:  LOG RECORDS WHICH ARE PRINTED IF A USER GETS DENIED
      * S:  MORE THAN 10 TIMES IN ONE DAY.
      *
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
     FAUT800P   IF   E           K DISK
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      *
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C                   EXSR      $READ
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * READ THROUGH RECORDS AND BREAK BY USER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $READ         BEGSR
      *
     C     *INLR         DOUEQ     *ON
     C                   READ      AUT800R                                LR
     C     *INLR         IFEQ      *OFF
      *
     C     ALUSR         IFNE      PVUSR
     C                   MOVE      *ZERO         DENIED
     C                   MOVE      ALUSR         PVUSR
     C                   ENDIF
      *
     C     ALRTN         IFEQ      *OFF
     C                   ADD       1             DENIED
     C                   ENDIF
      *
     C     DENONL        IFEQ      '*YES'
     C     DENIED        ANDGT     DENMIN
     C     DENONL        OREQ      '*NO'
     C                   EXSR      $PRINT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C     PRTCNT        IFEQ      *ZERO
     C                   EXCEPT    #HDG01
     C                   EXCEPT    #MSG01
     C                   ENDIF
      *
     CSR   #READ         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL OF REQUESTS AND COUNT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PRINT        BEGSR
      *
     C     ALUSR         SETLL     AUT800R
      *
     C     *IN99         DOUEQ     *ON
     C     ALUSR         READE     AUT800R                                99
     C     *IN99         IFEQ      *OFF
      *
     C     *INOF         IFEQ      *ON
     C                   EXCEPT    #HDG01
     C                   MOVE      *OFF          *INOF
     C                   ENDIF
      *
     C                   EXSR      $CLEAN
     C                   ADD       1             PRTCNT
      *
     C     ALRTN         IFEQ      *OFF
     C     DENONL        ANDEQ     '*YES'
     C     DENONL        OREQ      '*NO'
     C                   EXCEPT    #DTL01
      *
     C     ALTFR         IFNE      *BLANKS
     C                   EXCEPT    #DTL02
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C     ALUSR         SETGT     AUT800R
      *                                                     SAME USER.
     CSR   #PRINT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CLEAN UP PCS EXIT INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CLEAN        BEGSR
      *
     C     ALOBJ         IFEQ      '*SPC'
     C                   MOVE      *BLANKS       ALOBJ
     C                   ENDIF
      *
     C     ALLIB         IFEQ      '*SPC'
     C                   MOVE      *BLANKS       ALLIB
     C                   ENDIF
      *
     C     ALMBR         IFEQ      '*N'
     C                   MOVE      *BLANKS       ALMBR
     C                   ENDIF
      *
     CSR   #CLEAN        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *ON           *INOF
     C                   TIME                    UTIME             6 0
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    DENONL            4
     C                   PARM                    DENMIN            5 0
      *
     C     *LIKE         DEFINE    ALUSR         PVUSR
      *
     C                   MOVE      *ZERO         X                 5 0
     C                   MOVE      *ZERO         DENIED            5 0
     C                   MOVE      *ZERO         PRTCNT            5 0
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   E            #HDG01         2 06
     O                       UDATE         Y   +  0
     O                       UTIME             +  1 '0 .  .  '
     O                                           67 'PC Support Authority,'
     O                                         +  1 'Log Report'
     O                                          127 'Page'
     O                       PAGE          Z   +  1
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '          '
     O                                         +  1 '           '
     O                                         +  1 '          '
     O                                         +  1 'Allow/'
     O                                         +  1 '          '
     O                                         +  1 '        '
     O                                         +  1 '          '
     O                                         +  1 '            '
     O                                         +  1 '                    '
     O                                         +  1 '          '
     O                                         +  1 '          '
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 'User      '
     O                                         +  1 'Application'
     O                                         +  1 'Request   '
     O                                         +  1 'Denied'
     O                                         +  1 '   Date   '
     O                                         +  1 '  Time  '
     O                                         +  1 'Document    '
     O                                         +  1 'Folder              '
     O                                         +  1 'Object    '
     O                                         +  1 'Library   '
     O                                         +  1 'Member    '
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '----------'
     O                                         +  1 '-----------'
     O                                         +  1 '----------'
     O                                         +  1 '------'
     O                                         +  1 '----------'
     O                                         +  1 '--------'
     O                                         +  1 '------------'
     O                                         +  1 '--------------------'
     O                                         +  1 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '----------'
      *
     OQSYSPRT   E            #DTL01         1
     O                       ALUSR             +  0
     O                       ALAPP             +  1
     O                       ALREQ             +  2
     O                       ALRTN             +  4
     O                       ALDTE             +  3 '    /  / 0'
     O                       ALTIM             +  1 '  .  . 0'
     O                       ALDLO             +  1
     O                       ALFLR             +  1
     O                       ALOBJ             +  1
     O                       ALLIB             +  1
     O                       ALMBR             +  1
      *
     OQSYSPRT   E            #DTL02         1
     O                       ALTFR             + 41
      *
     OQSYSPRT   E            #MSG01      1  1
     O                                         +  1 'No records meet'
     O                                         +  1 'selection criteria.'
