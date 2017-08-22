      /TITLE Display Job Analysis, by Job
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
     C                   EXSR      $HDG
      *
     C     TOTALS        IFNE      '*NONE'
     C                   EXSR      $BREAK
     C                   END
      *
     C     DETAIL        IFEQ      '*YES'
     C                   EXSR      $DETAL
     C                   END
      *
     C                   ADD       1             L1TRUN
     C                   ADD       1             L2TRUN
     C                   ADD       1             LRTRUN
     C                   ADD       ENESEC        L1ENE
     C                   ADD       ENESEC        L2ENE
     C                   ADD       ENESEC        LRENE
     C                   ADD       RNESEC        L1RNE
     C                   ADD       RNESEC        L2RNE
     C                   ADD       RNESEC        LRRNE
      *
     C                   MOVE      JOBNAM        L2JNAM
     C                   MOVE      STRDTE        L1SDTE
      *
     CLR                 EXSR      $LRTOT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT HEADINGS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $HDG          BEGSR
      *
     C     *INOF         IFEQ      *ON
     C                   EXCEPT    #HDG01
     C                   MOVE      *OFF          *INOF
     C                   END
      *
     CSR   #HDG          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DETAL        BEGSR
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
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE IF LEVEL BREAK ON JOB.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $BREAK        BEGSR
      *
     C     JOBNAM        IFNE      L2JNAM
     C     L2JNAM        ANDNE     *BLANKS
     C                   EXSR      $L1TOT
     C                   EXSR      $L2TOT
     C                   END
      *
     C     STRDTE        IFNE      L1SDTE
     C     L1SDTE        ANDNE     *ZERO
     C                   EXSR      $L1TOT
     C                   END
      *
     CSR   #BREAK        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * L1 TOTALS (START DTE - DETERMINE AVERAGE RUN TIME)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $L1TOT        BEGSR
      *
     C     L1TRUN        IFNE      *ZERO
     C     TOTALS        IFEQ      '*JOBDAT'
     C     TOTALS        OREQ      '*BOTH'
     C                   MOVE      L1TRUN        ERUNS
     C                   MOVE      L1ENE         ESECS
     C                   EXSR      $ELPTM
     C                   MOVE      EDAYS         ENDAYS
     C                   MOVE      ETIME         ENTIME
     C                   MOVE      L1RNE         ESECS
     C                   EXSR      $ELPTM
     C                   MOVE      EDAYS         RNDAYS
     C                   MOVE      ETIME         RNTIME
      *
     C                   MOVE      L1SDTE        @CFDAT
     C                   MOVEL     '*YMD'        @CFFMT
     C                   MOVEL     '*JOB'        @CTFMT
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        L1SDTE
      *
     C                   EXCEPT    #TTL01
      *
     C     DETAIL        IFEQ      '*YES'
     C                   EXCEPT    #SPC01
     C                   END
      *
     C                   END
     C                   END
      *
     C                   MOVE      *ZERO         L1ENE             9 0
     C                   MOVE      *ZERO         L1RNE             9 0
     C                   MOVE      *ZERO         L1TRUN            5 0
     C                   MOVE      *ZERO         L1SDTE
      *
     CSR   #L1TOT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * L2 TOTALS (JOB NAME - DETERMINE AVERAGE RUN TIME)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $L2TOT        BEGSR
      *
     C     L2TRUN        IFNE      *ZERO
     C     TOTALS        IFEQ      '*JOB'
     C     TOTALS        OREQ      '*BOTH'
     C                   MOVE      L2TRUN        ERUNS
     C                   MOVE      L2ENE         ESECS
     C                   EXSR      $ELPTM
     C                   MOVE      EDAYS         ENDAYS
     C                   MOVE      ETIME         ENTIME
     C                   MOVE      L2RNE         ESECS
     C                   EXSR      $ELPTM
     C                   MOVE      EDAYS         RNDAYS
     C                   MOVE      ETIME         RNTIME
      *
     C     TOTALS        IFNE      '*NONE'
     C                   EXCEPT    #TTL02
     C                   END
      *
     C                   END
     C                   END
      *
     C                   MOVE      *ZERO         L2ENE             9 0
     C                   MOVE      *ZERO         L2RNE             9 0
     C                   MOVE      *ZERO         L2TRUN            5 0
     C                   MOVE      *BLANKS       L2JNAM
      *
     CSR   #L2TOT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * LR TOTALS (REPORT - DETERMINE AVERAGE RUN TIME)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LRTOT        BEGSR
      *
     C     TOTALS        IFNE      '*NONE'
     C                   MOVE      *HIVAL        JOBNAM
     C                   MOVE      *HIVAL        STRDTE
     C                   EXSR      $BREAK
     C                   END
      *
     C     LRTRUN        IFNE      *ZERO
     C                   MOVE      LRTRUN        ERUNS
     C                   MOVE      LRENE         ESECS
     C                   EXSR      $ELPTM
     C                   MOVE      EDAYS         ENDAYS
     C                   MOVE      ETIME         ENTIME
     C                   MOVE      LRRNE         ESECS
     C                   EXSR      $ELPTM
     C                   MOVE      EDAYS         RNDAYS
     C                   MOVE      ETIME         RNTIME
      *
     C     TOTALS        IFNE      '*NONE'
     C                   EXCEPT    #TTL03
     C                   END
      *
     C                   END
      *
     C                   MOVE      *ZERO         LRENE             9 0
     C                   MOVE      *ZERO         LRRNE             9 0
     C                   MOVE      *ZERO         LRTRUN            5 0
      *
     CSR   #LRTOT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE JOB ELAPSED TIME (AVERAGE)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ELPTM        BEGSR
      *
     C                   DIV       ERUNS         ESECS
      *
     C     ESECS         DIV       86400         EDAYS             5 0
     C                   DO        EDAYS
     C                   SUB       86400         ESECS
     C                   END
      *
     C                   MOVE      *ZERO         @TBTIM
     C                   MOVE      *ZERO         @TBDAT
     C                   MOVEL     '*YMD    '    @TBFMT
     C                   MOVE      ESECS         @TSECS
     C                   MOVEL     '*YMD    '    @TEFMT
     C                   EXSR      $ADDSS
     C                   MOVE      @TETIM        ETIME             6 0
      *
     CSR   #ELPTM        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      /COPY QCPYSRC,$ADDSS
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
     C     *LIKE         DEFINE    JOBNAM        L2JNAM
     C     *LIKE         DEFINE    STRDTE        L1SDTE
      *
     C     *LIKE         DEFINE    L1RNE         ESECS
     C     *LIKE         DEFINE    L1TRUN        ERUNS
      *
     C                   MOVE      *ZERO         ENDAYS            5 0
     C                   MOVE      *ZERO         ENTIME            6 0
     C                   MOVE      *ZERO         RNDAYS            5 0
     C                   MOVE      *ZERO         RNTIME            6 0
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
     O                                         +  1 '     '
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
     O                                         +  1 '  Nbr'
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
     O                                         +  1 ' Runs'
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
     O                                         +  1 '     '
     O                       ENEDAY        Z   +  1
     O                       ENETME            +  1 '  . 0.  '
     O                       RNEDAY        Z   +  1
     O                       RNETME            +  1 '  . 0.  '
      *
     OQSYSPRT   E            #TTL01         1
     O                       L2JNAM            +  0
     O                                         +  1 '          '
     O                                         +  1 '      '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                       L1SDTE            +  1 '  /  / 0'
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                       L1TRUN        Z   +  1
     O                       ENDAYS        Z   +  1
     O                       ENTIME            +  1 '  . 0.  '
     O                       RNDAYS        Z   +  1
     O                       RNTIME            +  1 '  . 0.  '
     O                                         +  1 '*'
      *
     OQSYSPRT   E            #TTL02         2
     O                       L2JNAM            +  0
     O                                         +  1 '          '
     O                                         +  1 '      '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                       L2TRUN        Z   +  1
     O                       ENDAYS        Z   +  1
     O                       ENTIME            +  1 '  . 0.  '
     O                       RNDAYS        Z   +  1
     O                       RNTIME            +  1 '  . 0.  '
     O                                         +  1 '**'
      *
     OQSYSPRT   E            #TTL03         1
     O                                         +  0 '          '
     O                                         +  1 '          '
     O                                         +  1 '      '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                                         +  1 '        '
     O                       LRTRUN        Z   +  1
     O                       ENDAYS        Z   +  1
     O                       ENTIME            +  1 '  . 0.  '
     O                       RNDAYS        Z   +  1
     O                       RNTIME            +  1 '  . 0.  '
     O                                         +  1 '***'
      *
     OQSYSPRT   E            #SPC01         1
