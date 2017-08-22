      /TITLE Display PCS Folder Authorities
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      *
      * S: PRINTS A LIST OF SELECTED AUTHORITIES.
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
     FAUT100P   IP   E           K DISK
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      *
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C                   EXSR      $PRINT
      *
     CLR   PRTCNT        IFEQ      *ZERO
     CLR                 EXCEPT    #HDG01
     CLR                 EXCEPT    #MSG01
     CLR                 ENDIF
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PRINT        BEGSR
      *
     C     *INOF         IFEQ      *ON
     C                   EXCEPT    #HDG01
     C                   MOVE      *OFF          *INOF
     C                   ENDIF
      *
     C                   EXCEPT    #DTL01
     C                   ADD       1             PRTCNT
      *
     CSR   #PRINT        ENDSR
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
     C                   MOVE      *ZERO         X                 5 0
     C                   MOVE      *ZERO         PRTCNT            5 0
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   E            #HDG01         2 06
     O                       UDATE         Y   +  0
     O                       UTIME             +  1 '0 .  .  '
     O                                           57 'Display PCS Folder'
     O                                         +  1 'Authority'
     O                                          127 'Page'
     O                       PAGE          Z   +  1
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '          '
     O                                         +  1 '            '
     O                                         +  1 '          '
     O                                         +  1 '          '
     O                                         + 41 '..........'
     O                                         +  0 ' Created ..'
     O                                         +  0 '.........'
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 'User      '
     O                                         +  1 'Folder      '
     O                                         +  1 'Authority '
     O                                         +  1 'Text      '
     O                                         + 41 'User      '
     O                                         +  1 '   Date   '
     O                                         +  1 '  Time  '
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '----------'
     O                                         +  1 '------------'
     O                                         +  1 '----------'
     O                                         +  1 '--------------------'
     O                                         +  0 '--------------------'
     O                                         +  0 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '--------'
      *
     OQSYSPRT   E            #DTL01         1
     O                       FAUSR             +  0
     O                       FAFLR             +  1
     O                       FAAUT             +  1
     O                       FATXT             +  1
     O                       FACUSR            +  1
     O                       FACDTE            +  1 '    /  / 0'
     O                       FACTIM            +  1 '  .  . 0'
      *
     OQSYSPRT   E            #MSG01      1  1
     O                                         +  1 'No records meet'
     O                                         +  1 'selection criteria.'
