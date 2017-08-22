      /TITLE RPG - List History on a User
      ************************************************************************
      *
      *   PROGRAM ID:    LSTQHSTR
      *   PROGRAM TITLE: LIST HISTORY ON A USER
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: 02/17/89
      *
      *   REMARKS:       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   CALLED BY:     TMXXXXC - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   REVISED:       MM/DD/YY  BY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *   REVISED DESC:                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *   *  Property of Travel Management Systems, Inc.  *
      *   *  873 Sutter Street                            *
      *   *  San Francisco, California  94109             *
      *   *                                               *
      *   *  Technical Support Center                     *
      *   *  1250 Oakmead Parkway, Suite 308              *
      *   *  Sunnyvale, California  94086                 *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      ************************************************************************
      /EJECT
      *
      *
     FQHST      IP   F  142        DISK
     FLSTQHST   UF A E           K DISK
     FLSTQHSTL  IF   E           K DISK
     F                                     RENAME(LSTQHSTR:LSTQHSTS)
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
     F                                     FORMLEN(88)
     F                                     FORMOFL(84)
      *
      *
     D DATA2           DS           142
     D  DATE                  38     43  0
     D  TIME                  44     49  0
      *
     IQHST      NS
     I                             B    9   10 0RECNBR
     I                                 11   20  JOBNAM
     I                                 21   30  JOBUSR
     I                                 31   36  JOBNBR
     I                                  1  142  DATA1
     I                                 50   56  MSGID
      /SPACE 3
     C     FSTTIM        CASEQ     *BLANKS       $ZINIT                         FIRST
     C                   END                                                     TIME
      *
     C     FUNCT         IFEQ      '*COLLECT'
     C     RECNBR        IFEQ      1
     C     JOBUSR        ANDEQ     USER
      *
     C     MSGID         IFEQ      'CPF1124'                                    STR
     C                   MOVE      DATA1         DATA2
     C                   MOVE      DATE          STRDTE
     C                   MOVE      TIME          STRTIM
     C                   MOVE      *ZERO         ENDDTE
     C                   MOVE      *ZERO         ENDTIM
     C                   WRITE     LSTQHSTR
     C                   END
      *
     C     MSGID         IFEQ      'CPF1164'                                    END
     C     HSTKEY        CHAIN     LSTQHSTR                           99
     C     *IN99         IFEQ      OFF
     C                   MOVE      DATA1         DATA2
     C                   MOVE      DATE          ENDDTE
     C                   MOVE      TIME          ENDTIM
     C                   UPDATE    LSTQHSTR
     C                   END
     C                   END
      *
     C                   END
     C                   END
      *
     C     FUNCT         IFEQ      '*PRINT'
     C                   EXSR      $PRINT
     C                   END
      /SPACE 3
      *****************************************************************
      *  PRINT REPORT
      *****************************************************************
     CSR   $PRINT        BEGSR
      *
     C     *INLR         DOUEQ     ON
     C                   READ      LSTQHSTS                               LR
     C     *INLR         IFEQ      OFF
      *
     C     *INOF         IFEQ      ON
     C                   EXCEPT    HDG01                                         HEADINGS
     C                   MOVE      OFF           *INOF
     C                   END
      *
     C     SAVDTE        IFNE      STRDTE
     C     SAVDTE        ANDNE     *ZERO
     C                   EXCEPT    SPACE
     C                   MOVE      STRDTE        SAVDTE
     C                   END
      *
     C     STRDTE        COMP      LSTSTR                             4040
     C     ENDDTE        COMP      LSTEND                             4141
     C                   MOVE      STRDTE        LSTSTR
     C                   MOVE      ENDDTE        LSTEND
      *
     C                   MULT      100.0001      STRDTE
     C                   MULT      100.0001      ENDDTE
     C                   EXCEPT    DTL01
     C                   END
     C                   END
      *
     CSR   #PRINT        ENDSR
      /SPACE 3
      *****************************************************************
      *  INITIALIZE FIELDS
      *****************************************************************
     CSR   $ZINIT        BEGSR
      *
     C                   MOVE      '0'           OFF               1
     C                   MOVE      '1'           ON                1
      *
     C     *LIKE         DEFINE    STRDTE        SAVDTE
     C     *LIKE         DEFINE    STRDTE        LSTSTR
     C     *LIKE         DEFINE    ENDDTE        LSTEND
     C     *LIKE         DEFINE    OFF           FSTTIM
     C                   MOVE      OFF           FSTTIM
     C                   TIME                    UTIME             6 0
     C                   MOVE      ON            *INOF
      *
     C     HSTKEY        KLIST
     C                   KFLD                    JOBNAM
     C                   KFLD                    JOBUSR
     C                   KFLD                    JOBNBR
      *
     C     *ENTRY        PLIST
     C                   PARM                    USER             10
     C                   PARM                    FUNCT            10
      *
     CSR   #ZINIT        ENDSR
      *
     OQSYSPRT   E            HDG01          2 03
     O                       UDATE         Y      8
     O                       UTIME               19 ' 0.  .  '
     O                                           69 'LIST HISTORY ON A USER'
     O                                          128 '''LSTQHSTR''   PAGE'
     O                       PAGE          Z    132
      *
     OQSYSPRT   E            HDG01          1
     O                                         +  1 '          '
     O                                         +  1 '          '
     O                                         +  1 '       '
     O                                         +  1 ' START  '
     O                                         +  1 ' START  '
     O                                         +  1 '  END   '
     O                                         +  1 '  END   '
      *
     OQSYSPRT   E            HDG01          1
     O                                         +  1 'JOB NAME  '
     O                                         +  1 'JOB USER  '
     O                                         +  1 'JOB NBR'
     O                                         +  1 '  DATE  '
     O                                         +  1 '  TIME  '
     O                                         +  1 '  DATE  '
     O                                         +  1 '  TIME  '
      *
     OQSYSPRT   E            HDG01          1
     O                                         +  1 '----------'
     O                                         +  1 '----------'
     O                                         +  1 '-------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
     O                                         +  1 '--------'
      *
     OQSYSPRT   E            DTL01          1
     O                       JOBNAM            +  1
     O                       JOBUSR            +  1
     O                       JOBNBR            +  1
     O               40      STRDTE            +  2 '  /  / 0'
     O                       STRTIM            +  1 ' 0:  :  '
     O               41      ENDDTE            +  1 '  /  / 0'
     O                       ENDTIM            +  1 ' 0:  :  '
      *
     OQSYSPRT   E            SPACE          1
