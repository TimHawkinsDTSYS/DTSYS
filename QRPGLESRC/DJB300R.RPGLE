      /TITLE Display Job Analysis, by Start Time
      *
      * P: PARMS USRPRF(*OWNER) AUT(*ALL)
      *
      * S: DISPLAY JOB ANALYSIS
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
     FDJB100P   IP   E             DISK
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      *
      /EJECT
     C                   EXSR      $DETAL
      *
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DETAL        BEGSR
      *
     C     *INOF         IFEQ      *ON
     C                   EXCEPT    #HDG01
     C                   MOVE      *OFF          *INOF
     C                   END
      *
     C                   MOVE      ENTDTE        @CFDAT
     C                   MOVEL     '*YMD'        @CFFMT
     C                   MOVEL     '*JOB'        @CTFMT
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        ENTDTE
      *
     C                   MOVE      STRDTE        @CFDAT
     C                   MOVEL     '*YMD'        @CFFMT
     C                   MOVEL     '*JOB'        @CTFMT
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        STRDTE
      *
     C                   MOVE      ENDDTE        @CFDAT
     C                   MOVEL     '*YMD'        @CFFMT
     C                   MOVEL     '*JOB'        @CTFMT
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        ENDDTE
      *
     C                   EXCEPT    #DTL01
      *
     CSR   #DETAL        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   TIME                    UTIME             6 0
     C                   MOVE      *ON           *INOF
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    SEQUEN           10
     C                   PARM                    DETAIL           10
     C                   PARM                    TOTALS           10
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   E            #HDG01         2 06
     O                       UDATE         Y   +  0
     O                       UTIME             +  1 '0 .  .  '
     O                                           57 'Display Job Analysis'
     O                                         + 10 'Sequence -'
     O                       SEQUEN            +  1
     O                                          127 'Page'
     O                       PAGE          Z   +  1
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '          '
     O                                         +  1 '          '
     O                                         +  1 '      '
     O                                         +  1 '                 '
     O                                         +  1 '                 '
     O                                         +  1 '                 '
     O                                         +  1 '.... Jobq ....'
     O                                         +  1 '..... Run ....'
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '          '
     O                                         +  1 '          '
     O                                         +  1 '      '
     O                                         +  1 '.... Entered ....'
     O                                         +  1 '..... Start .....'
     O                                         +  1 '...... End ......'
     O                                         +  1 '... Elapsed ..'
     O                                         +  1 '... Elapsed ..'
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 'Name      '
     O                                         +  1 'User      '
     O                                         +  1 'Number'
     O                                         +  1 '  Date  '
     O                                         +  1 '  Time  '
     O                                         +  1 '  Date  '
     O                                         +  1 '  Time  '
     O                                         +  1 '  Date  '
     O                                         +  1 '  Time  '
     O                                         +  1 ' Days'
     O                                         +  1 '  Time  '
     O                                         +  1 ' Days'
     O                                         +  1 '  Time  '
      *
     OQSYSPRT   E            #HDG01         1
     O                                         +  0 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '-----'
     O                                         +  1 '--------'
     O                                         +  1 '-----'
     O                                         +  1 '--------'
      *
     OQSYSPRT   E            #DTL01         1
     O                       JOBNAM            +  0
     O                       USRNAM            +  1
     O                       JOBNBR            +  1
     O                       ENTDTE            +  1 '  /  / 0'
     O                       ENTTME            +  1 '  .  . 0'
     O                       STRDTE            +  1 '  /  / 0'
     O                       STRTME            +  1 ' 0.  .  '
     O                       ENDDTE            +  1 '  /  / 0'
     O                       ENDTME            +  1 ' 0.  .  '
     O                       ENEDAY        Z   +  1
     O                       ENETME            +  1 '  . 0.  '
     O                       RNEDAY        Z   +  1
     O                       RNETME            +  1 '  . 0.  '
