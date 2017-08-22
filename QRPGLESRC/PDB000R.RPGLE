      /TITLE Print DB Record
     H DATEDIT(*YMD)
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
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
     FQADSPFFD  IF   E             DISK
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      *
     D AS              S              1    DIM(9999)
     D PC              S              1    DIM(80)
      *
      * Work arrays for field conversion:
      *
      *
     D CMD             S             80    DIM(3) CTDATA PERRCD(1)
      *
      * Work area for text conversion:
     D DSTEXT          DS          9999    INZ
     D  TX                     1   9999
     D                                     DIM(9999)
      *
      * Work area for packed decimal conversion:
     D DSPACK          DS                  INZ
     D  #DPACK                 1     16P 0
     D                                     PACKEVEN
     D  PK                     1     16
     D                                     DIM(16)
      *
      * Work area for binary conversion:
     D DSBNRY          DS                  INZ
     D  #DBNRY                 1      4B 0
     D  BN                     1      4
     D                                     DIM(4)
      *
      * Work area for zoned decimal conversion:
     D DSZONE          DS                  INZ
     D  #DZONE                 1     30  0
     D  ZN                     1     30
     D                                     DIM(30)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      * Main Processing
     C                   EXSR      CVTRCD
      *
      * Termination
     C                   EXSR      ENDPGM
      *****************************************************************
      * Convert data
      *****************************************************************
     C     CVTRCD        BEGSR
      *
      * Initialize output buffer
      *
     C                   RESET                   PC
      *
      * Initialize pointers
      *
     C                   Z-ADD     1             #A
     C                   Z-ADD     1             #P
      *
      * For each field in the file...
      *
     C                   READ      QADSPFFD                               LR
      *
      * Convert according to field type
      *
     C     *INLR         DOWEQ     *OFF
     C     WHFLDT        CASEQ     'A'           CVTTXT
     C     WHFLDT        CASEQ     'S'           CVTZON
     C     WHFLDT        CASEQ     'P'           CVTPCK
     C     WHFLDT        CASEQ     'B'           CVTBIN
     C     WHFLDT        CASEQ     'L'           CVTTXT
     C     WHFLDT        CASEQ     'T'           CVTTXT
     C     WHFLDT        CASEQ     'Z'           CVTTXT
     C     WHFLDT        CASEQ     'H'           CVTTXT
     C                   ENDCS
      *
     C                   READ      QADSPFFD                               LR
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * Convert alphanumeric field
      *****************************************************************
     C     CVTTXT        BEGSR
      *
      * Initialize work area
      *
     C                   RESET                   DSTEXT
      *
      * Move characters into work area
      *
     C                   Z-ADD     1             #T
      *
     C                   DO        WHFLDB        #X
     C                   MOVE      AS(#A)        TX(#T)
     C                   ADD       1             #A
     C                   ADD       1             #T
     C                   ENDDO
      *
     C     #T            DOWGT     *ZERO
     C     TX(#T)        ANDEQ     *BLANK
     C                   SUB       1             #T
     C                   ENDDO
      *
      * Move characters to output buffer
      *
     C                   Z-ADD     1             #X
     C     #X            DOWLE     #T
     C                   MOVE      TX(#X)        PC(#P)
     C                   ADD       1             #X
     C                   ADD       1             #P
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * Convert zoned numeric field
      *****************************************************************
     C     CVTZON        BEGSR
      *
      * Move characters into work area
      *
     C                   MOVE      *ZERO         #DZONE
     C     30            SUB       WHFLDB        #Z                5 0
     C                   ADD       1             #Z
     C     #Z            DOWLE     30
     C                   MOVE      AS(#A)        ZN(#Z)
     C                   ADD       1             #A
     C                   ADD       1             #Z
     C                   ENDDO
      *
      * Convert number in work area
      *
     C                   EXSR      CVTNBR
      *
     C                   ENDSR
      *****************************************************************
      * Convert numeric field from zoned work area
      *****************************************************************
     C     CVTNBR        BEGSR
      *
      * Calculate number of digits before decimal place
      *
     C     WHFLDD        SUB       WHFLDP        W1DGTS
     C     31            SUB       WHFLDD        #Z
     C                   Z-ADD     1             #Y
      *
      * Set sign
      *
     C     #DZONE        IFLT      *ZERO
     C                   Z-SUB     #DZONE        #DZONE
     C                   MOVE      '-'           PC(#P)
     C                   ADD       1             #P
     C                   ENDIF
      *
      * Ignore leading zeros
      *
     C     ZN(#Z)        DOWEQ     *ZERO
     C     #Y            ANDLT     W1DGTS
     C                   ADD       1             #Z
     C                   ADD       1             #Y
     C                   ENDDO
      *
      * Move digits before decimal place to output buffer
      *
     C     #Z            DOWLE     30
     C     #Y            ANDLE     W1DGTS
     C                   MOVE      ZN(#Z)        PC(#P)
     C                   ADD       1             #P
     C                   ADD       1             #Z
     C                   ADD       1             #Y
     C                   ENDDO
      *
      * Move digits after decimal place to output buffer
      *
     C     WHFLDP        IFGT      *ZERO
     C                   MOVE      '.'           PC(#P)
     C                   ADD       1             #P
      *
     C                   DO        WHFLDP        #Y
     C                   MOVE      ZN(#Z)        PC(#P)
     C                   ADD       1             #P
     C                   ADD       1             #Z
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Convert packed numeric field
      *****************************************************************
     C     CVTPCK        BEGSR
      *
      * Initialize work area
      *
     C                   MOVE      *ZERO         #DPACK
      *
      * Move characters into work area
      *
     C     17            SUB       WHFLDB        #Y
     C     #Y            DOWLE     16
     C                   MOVE      AS(#A)        PK(#Y)
     C                   ADD       1             #A
     C                   ADD       1             #Y
     C                   ENDDO
      *
      * Convert packed to zoned
      *
     C                   Z-ADD     #DPACK        #DZONE
      *
      * Convert number in work area
      *
     C                   EXSR      CVTNBR
      *
     C                   ENDSR
      *****************************************************************
      * Convert binary field
      *****************************************************************
     C     CVTBIN        BEGSR
      *
      * Initialize work area
      *
     C                   MOVE      *ZERO         #DBNRY
      *
      * Move characters into work area
      *
     C     5             SUB       WHFLDB        #Y
     C     #Y            DOWLE     4
     C                   MOVE      AS(#A)        BN(#Y)
     C                   ADD       1             #A
     C                   ADD       1             #Y
     C                   ENDDO
      *
      * Convert binary to zoned
      *
     C                   Z-ADD     #DBNRY        #DZONE
      *
      * Convert number in work area
      *
     C                   EXSR      CVTNBR
      *
     C                   ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL LINE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PRINT        BEGSR
      *
     C     *INOF         IFEQ      *ON
     C                   MOVE      *OFF          *INOF
     C                   EXCEPT    #HDG01
     C                   ENDIF
      *
     C                   EXCEPT    #DTL01
      *
     CSR   #PRINT        ENDSR
      *****************************************************************
      * Termination
      *****************************************************************
     CSR   ENDPGM        BEGSR
      *
     C                   CALL      'QCMDEXC'                            95
     C                   PARM                    CMD(3)
     C                   PARM      80            CMDLEN           15 5
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     CSR                 ENDSR
      *****************************************************************
      * Initialization
      *****************************************************************
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *ON           *INOF
     C                   TIME                    UTIME             6 0
      *
     C                   MOVEL     PFILE         FILE             10
     C                   MOVE      PFILE         FILLIB           10
      *
     C     FILLIB        IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       FILLIB
     C                   ENDIF
      *
     C                   CAT       FILLIB:0      CMD(1)
     C                   CAT       '/':0         CMD(1)
     C                   CAT       FILE:0        CMD(1)
     C                   CAT       ')':0         CMD(1)
      *
     C                   DO        2             X                 5 0
     C                   CALL      'QCMDEXC'                            95
     C                   PARM                    CMD(X)
     C                   PARM      80            CMDLEN           15 5
     C                   ENDDO
      *
     C**         *NAMVAR   DEFN CONAME    CONAM  35
     C**                   IN   CONAM
      *
     CSR   #INZSR        ENDSR
      *****************************************************************
      * Definitions
      *****************************************************************
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFILE            20
     C                   PARM                    AS
      *
     C                   MOVE      *ZERO         W1DGTS            5 0
     C                   MOVE      *ZERO         #A                5 0
     C                   MOVE      *ZERO         #F                7 0
     C                   MOVE      *ZERO         #P                5 0
     C                   MOVE      *ZERO         #T                5 0
     C                   MOVE      *ZERO         #X                5 0
     C                   MOVE      *ZERO         #Y                5 0
     C                   MOVE      *ZERO         #Z                5 0
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   E            #HDG01         1 03
     O                       ZZUSR             +  0
     O**                       CONAM     84
     O                                          126 'Page'
     O                       PAGE          Z    132
      *
     OQSYSPRT   E            #HDG01         1
     O                       UDATE         Y   +  0
     O                       ZZJOB              132
      *
     OQSYSPRT   E            #HDG01         2
     O                       UTIME             +  0 '0 .  .  '
     O                       WHTEXT            +  9
     O                       ZZPGM              132
      *
     OQSYSPRT   EF           #DTL01         1
     O                       WHFTXT            +  0
     O                       PC                +  1
      *
      *
**
DSPFFD OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPFFD) FILE(
OVRDBF QADSPFFD TOFILE(QTEMP/DSPFFD)
DLTOVR QADSPFFD
