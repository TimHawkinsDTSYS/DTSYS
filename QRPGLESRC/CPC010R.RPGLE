      *********************************************************************
      * RPG Program CVTPCDRPG                                             *
      *                                                                   *
      * Program Summary:                                                  *
      *  Reads DSPFFD outfile output and converts each data field into    *
      *  work file.                                                       *
      *********************************************************************
      *
      * Files Used: QADSPFFD - DSPFFD outfile output
      *              AS400FIL - File being converted
      *              PCFILE   - Temporary work file
      *
      * Indicators Used:
      *   95 - End of file on QADSPFFD
      *   LR - Program Termination
      *
      * Calls:
      *             QMHSNDPM (Send program message API)
      *
      * Called by:  CVTPCDCL (Command processing program for CVTTOPCD)
      *
      ****************************************************************
      *
      *                 SUBROUTINE LIST
      *                 ~~~~~~~~~~~~~~~
      * NAME            DESCRIPTION
      * ~~~~            ~~~~~~~~~~
      * *PSSR           Error Handler
      * CVTBIN          Convert binary number
      * CVTNBR          Convert numeric to alpha
      * CVTPCK          Convert packed number
      * CVTRCD          Convert an input record
      * CVTTXT          Convert a text field (alpha, date, time, etc.)
      * CVTZON          Convert zoned decimal number
      * DEFINE          Definition of working variables
      * ENDPGM          Program Termination
      * INZPGM          Program Initialization
      * MAIN            Mainline subroutine
      * RTVFLD          Retrieve field descriptions into arrays
      ****************************************************************
     H DEBUG
      *
      * DSPFFD outfile:
     FQADSPFFD  IF   E           K DISK    INFSR(*PSSR)
      *
      * File to be converted:
     FAS400FIL  IF   F 9999        DISK    INFSR(*PSSR)
      *
      * File to receive output:
     FPCFILE    O    F 9999        DISK    INFSR(*PSSR)
      *
      * Input AS/400 File Data:
     D AS              S              1    DIM(9999)
      *
      * Output PC File Data:
      *
      * Field definition arrays:
     D POS             S              5  0 DIM(1000)
     D LEN             S              5  0 DIM(1000)
     D DGT             S              2  0 DIM(1000)
     D DEC             S              2  0 DIM(1000)
     D TYP             S              1    DIM(1000)
      *
      * Work arrays for field conversion:
      *
      * Output PC File:
     D DSPC            DS          9999    INZ
     D  PC                     1   9999
     D                                     DIM(9999)
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
      * Number of records - character for message handling in CVTTOPCD:
     D $$#RCD          DS             5
     D  #D#RCD                 1      5P 0
      *
      * Send Message API parameters:
     D DSSMSG          DS
     D  $1DLEN                 1      4B 0 INZ(100)
     D  $1MSGF                 5     24    INZ('DTSYSMSGF *LIBL')
     D  $1MSGT                25     34    INZ('*STATUS')
     D  $1PGMQ                35     44    INZ('*EXT      ')
     D  $1STAK                75     78B 0 INZ(0)
     D  $1RPYQ                79     98
     D  $1MSGK                99    102
     D  $1MSG#               103    109    INZ('DTC0009')
     D  $1MSGD               110    209
      *
      * API error structure:
     D DSERR           DS           114
     D  W1ERRB                 1      4B 0 INZ(100)
     D  W2ERRB                 5      8B 0 INZ(0)
     D  W1ERR#                 9     15
      *
      * Named constants:
     D #CQUOT          C                   CONST('"')
     D #CCOMA          C                   CONST(',')
     D #CSTOP          C                   CONST('.')
      *
      * Output PC File:
     D P_SLTFLD        DS           502
     D  SLTFLDidx              1      2B 0
     D  SLTFLD                 3    502    DIM(50)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      * Input AS/400 File:
     IAS400FIL  NS
     I                                  1 9999  AS
      *
      *
      * Initialization
     C                   EXSR      INZPGM
      *
      * Retrieve file field descriptions into arrays
      *
     C                   EXSR      RTVFLD
      *
      * Main Processing
     C                   EXSR      MAIN
      *
      * Termination
     C                   EXSR      ENDPGM
      *****************************************************************
      * Main Processing
      *****************************************************************
     C     MAIN          BEGSR
      *
     C                   READ      AS400FIL                               LR
      *
     C     *INLR         DOWEQ     *OFF
     C                   EXSR      CVTRCD
      *
      * Send status message every 100 records
      *
     C     W1#RCD        IFEQ      100
     C                   RESET                   DSSMSG
     C                   RESET                   DSERR
     C                   MOVEL(P)  $$#RCD        $1MSGD
     C                   CALL      'QMHSNDPM'    $1SMSG                 99
     C                   MOVE      *ZERO         W1#RCD
     C                   ENDIF
      *
     C                   READ      AS400FIL                               LR
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * Convert data
      *****************************************************************
     C     CVTRCD        BEGSR
      *
      * Initialize output buffer
      *
     C                   RESET                   DSPC
      *
      * Initialize pointers
      *
     C                   Z-ADD     1             #A
     C                   Z-ADD     1             #P
      *
      * For each field in the file...
      *
     C                   DO        WHFLDN        #F
      *
     C                   eval      SltFldFnd = *off
      *
     C                   DO        SLTFLDidx     x
     C     SltFld(x)     ifeq      '*NONE'
     C     WHFLDI        oreq      SltFld(x)
     C                   eval      SltFldFnd = *on
     C                   endif
     C                   enddo
      *
      * Convert according to field type
      *
     C     TYP(#F)       CASEQ     'A'           CVTTXT
     C     TYP(#F)       CASEQ     'S'           CVTZON
     C     TYP(#F)       CASEQ     'P'           CVTPCK
     C     TYP(#F)       CASEQ     'B'           CVTBIN
     C     TYP(#F)       CASEQ     'L'           CVTTXT
     C     TYP(#F)       CASEQ     'T'           CVTTXT
     C     TYP(#F)       CASEQ     'Z'           CVTTXT
     C     TYP(#F)       CASEQ     'H'           CVTTXT
     C                   ENDCS
      *
      * Place , in output buffer unless the last field
      *
     C     #F            IFNE      WHFLDN
     C                   MOVE      #CCOMA        PC(#P)
     C                   ADD       1             #P
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Output record to PC file
      *
     C                   WRITE     PCFILE        DSPC
      *
      * Remember maximum record length and number of records
      *
     C     #P            SUB       1             W1RCDL
     C     W1RCDL        IFGT      $$RCDL
     C                   Z-ADD     W1RCDL        $$RCDL
     C                   ENDIF
     C                   ADD       1             #D#RCD
     C                   ADD       1             W1#RCD
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
     C                   DO        LEN(#F)       #X
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
      * Place " in output buffer
      *
     C                   if        SltFldFnd = *on
     C                   MOVE      #CQUOT        PC(#P)
     C                   ADD       1             #P
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
      * Place " in output buffer
      *
     C                   MOVE      #CQUOT        PC(#P)
     C                   ADD       1             #P
     C                   endif
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
     C     30            SUB       LEN(#F)       #Z                5 0
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
     C     DGT(#F)       SUB       DEC(#F)       W1DGTS
     C     31            SUB       DGT(#F)       #Z
     C                   Z-ADD     1             #Y
      *
      * Set sign
      *
     C                   if        SltFldFnd = *on
     C     #DZONE        IFLT      *ZERO
     C                   Z-SUB     #DZONE        #DZONE
     C                   MOVE      '-'           PC(#P)
     C                   ADD       1             #P
     C                   ENDIF
     C                   endif
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
     C                   if        SltFldFnd = *on
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
     C     DEC(#F)       IFGT      *ZERO
     C                   MOVE      #CSTOP        PC(#P)
     C                   ADD       1             #P
      *
     C                   DO        DEC(#F)       #Y
     C                   MOVE      ZN(#Z)        PC(#P)
     C                   ADD       1             #P
     C                   ADD       1             #Z
     C                   ENDDO
      *
     C                   ENDIF
     C                   endif
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
     C     17            SUB       LEN(#F)       #Y
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
     C     5             SUB       LEN(#F)       #Y
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
      *****************************************************************
      * Retrieve field descriptions into arrays
      *****************************************************************
     C     RTVFLD        BEGSR
      *
     C                   MOVE      *ZERO         #F
      *
     C                   READ      QADSPFFD                               95
      *
     C     *IN95         DOWEQ     *OFF
     C                   ADD       1             #F
     C                   MOVEL     WHFLDT        TYP(#F)
     C                   Z-ADD     WHFOBO        POS(#F)
     C                   Z-ADD     WHFLDB        LEN(#F)
     C                   Z-ADD     WHFLDD        DGT(#F)
     C                   Z-ADD     WHFLDP        DEC(#F)
     C                   READ      QADSPFFD                               95
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * *PSSR  Standard Error-Handling Routine
      *****************************************************************
     C     *PSSR         BEGSR
      *
      * Check flag to avoid looping in error-handling routine
      *
     C     W1PSSR        IFNE      *ON
     C                   MOVE      *ON           W1PSSR
     C                   DUMP
     C                   ENDIF
      *
      * Terminate abnormally
      *
     C                   ENDSR     '*CANCL'
      *****************************************************************
      * Termination
      *****************************************************************
     C     ENDPGM        BEGSR
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CLEAR PROGRAM MESSAGE QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMCLR        BEGSR
      *
     C     TOPGM         IFEQ      *BLANKS
     C                   MOVEL     '*'           TOPGM
     C                   ENDIF
      *
     C     TOREL         IFEQ      '*PRV'
     C                   MOVE      *LOVAL        PGMSTK
     C                   MOVE      X'01'         PGMSTK
     C                   ELSE
     C                   MOVE      *LOVAL        PGMSTK
     C                   ENDIF
      *
     C                   CALL      'QMHRMVPM'                           98
     C                   PARM                    TOPGM            10
     C                   PARM                    PGMSTK            4
     C                   PARM      *BLANKS       MSGKEY            4
     C                   PARM      '*ALL'        RMVOPT           10
     C                   PARM      *LOVAL        RTNCDE            4
      *
     C                   MOVE      *BLANKS       TOREL            10
     C                   MOVE      *OFF          MSGSNT            1
      *
     CSR   #PMCLR        ENDSR
      *****************************************************************
      * Initialization
      *****************************************************************
     C     INZPGM        BEGSR
      *
      * Initialize returned maximum record length
      *
     C                   MOVE      *ZERO         $$RCDL
     C                   MOVE      *ZERO         #D#RCD
     C                   MOVE      *ZERO         W1#RCD           11 0
     C                   exsr      $PMclr
      *
     C                   ENDSR
      *****************************************************************
      * Definitions
      *****************************************************************
     C     DEFINE        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    $$RCDL            5 0
     C                   PARM                    $$#RCD
     C                   PARM                    P_SLTFLD
      *
     C     $1SMSG        PLIST
     C                   PARM                    $1MSG#
     C                   PARM                    $1MSGF
     C                   PARM                    $1MSGD
     C                   PARM                    $1DLEN
     C                   PARM                    $1MSGT
     C                   PARM                    $1PGMQ
     C                   PARM                    $1STAK
     C                   PARM                    $1MSGK
     C                   PARM                    DSERR
      *
     C                   MOVE      *BLANK        W1PSSR            1
     C                   MOVE      *off          SltFldFnd         1
     C                   MOVE      *ZERO         W1DGTS            5 0
     C                   MOVE      *ZERO         W1RCDL           15 0
     C                   MOVE      *ZERO         #A                5 0
     C                   MOVE      *ZERO         #F                7 0
     C                   MOVE      *ZERO         #P                5 0
     C                   MOVE      *ZERO         #T                5 0
     C                   MOVE      *ZERO         #X                5 0
     C                   MOVE      *ZERO         #Y                5 0
     C                   MOVE      *ZERO         #Z                5 0
     C                   MOVE      *ZERO         x                 5 0
      *
     C                   ENDSR
