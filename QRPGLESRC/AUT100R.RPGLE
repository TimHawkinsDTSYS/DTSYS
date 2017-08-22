      /TITLE PC Support Exit Program
     H DEBUG DATEDIT(*YMD)
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S: PC SUPPORT/400 SUPPORTS USER-WRITTEN EXIT PROGRAMS.
      * S:  THIS PROGAM HELPS INSURE THAT DATA IS BOTH SECURE AND CORRECT.
      * S:  THIS EXIT PROGRAM CAN DETERMINE IF USERS HAVE AUTHORITY
      * S:  TO PERFORM A PARTICULAR OPERATION ON THE AS/400 SYSTEM.
      *
      * N: THE AS/400 PROVIDES THE ABILITY TO SPECIFY A PC SUPPORT
      * N:  EXIT PROGRAM ON THE CHANGE NETWORK ATTRIBUTES (CHGNETA) COMMAND.
      * N:  THIS PROGRAM CAN CHECK A DATABASE FILE FOR USER AUTHORITY
      * N:  TO A FOLDER OR LIBRARY, IF THE AUTHORITY SPECIFIED IS NOT
      * N:  SUFFICIENT THEN ACCESS IS NOT GRANTED.
      *
      * N: MAINTENANCE TO THE TABLES ARE ACCOMPLISHED THROUGH THE
      * N:  USE OF SEVERAL COMMANDS:
      * N:   ADDFLRAUT - ADD FOLDER AUTHORITY.
      * N:   CHGFLRAUT - CHANGE FOLDER AUTHORITY.
      * N:   RMVFLRAUT - REMOVE FOLDER AUTHORITY.
      * N:   DSPFLRAUT - DISPLAY FOLDER AUTHORITY.
      * N:   ADDTFRAUT - ADD TRANSFER AUTHORITY.
      * N:   CHGTFRAUT - CHANGE TRANSFER AUTHORITY.
      * N:   RMVTFRAUT - REMOVE TRANSFER AUTHORITY.
      * N:   DSPTFRAUT - DISPLAY TRANSFER AUTHORITY.
      * N:    - REFER TO THE HELP TEXT FOR THE COMMANDS FOR MORE
      * N:    - INFORMATION ON WHAT THEY DO AND AFFECT.
      *
      * N: THIS PROGRAM RUNS IN TWO MODES;
      * N:  1) NORMAL PCSEXIT PROGRAM MODE RECEIVES TWO PARAMETERS
      * N:     (RETURN CODE AND REQUEST).  THE REQUEST IS PROCESSED
      * N:     AND THE RETURN CODE IS LOADED WITH A '0'=ACCESS DENIED,
      * N:     OR THE RETURN CODE IS LOADED WITH A '1'=ACCESS ALLOWED.
      * N:  2) IN TEST MODE THE PROGRAM READS A FILE WHICH IS EXTERNALLY
      * N:     DESCRIBED.  THIS FILE IS LOADED BY DISPLAYING THE JOURNAL
      * N:     TO AN OUTFILE AND THEN USING CPYF (W/FMTOPT(*NOCHK))
      * N:     TO COPY FROM THE OUTFILE TO THE DB FILE.
      *
      * N: DATABASE FILES:
      * N:  AUT100P - FOLDER AUTHORITIES, ONLY FIRST LEVEL FOLDER
      * N:              IS SUPPORTED.
      * N:  AUT110P - LIBRARY AUTHORITIES.
      * N:  AUT800P - LOG FILE CREATED BY THIS PROGRAM.
      * N:  AUT810P - TEST JOURNAL OUTFILE *TYPE2 FORMAT.
      *
      * N: DATA AREAS:
      * N:  AUT000D - AUTHORITY CONTROL INFORMATION.
      * N:  AUT100D - FOLDER AUTHORITIES, USERS WITH *ALLOBJ AUTHORITY.
      * N:  AUT101D - FOLDER AUTHORITIES, FOLDERS WITH *PUBLIC ACCESS.
      * N:  AUT110D - LIBRARY AUTHORITIES, USERS WITH *ALLOBJ AUTHORITY.
      * N:  AUT111D - LIBRARY AUTHORITIES, LIBRARIES WITH *PUBLIC ACCESS.
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
     FAUT100P   IF   E           K DISK    USROPN
     FAUT110P   IF A E           K DISK    USROPN
     FAUT800P   O  A E             DISK    USROPN
     FAUT810P   UF   E             DISK    USROPN
      *
     D PLRQS           DS          4171
      *
     D RQSDS           DS          4171
     D  RQUSR                  1     10
     D  RQAPP                 11     20
     D  RQREQ                 21     30
     D  RQOBJ                 31     40
     D  RQLIB                 41     50
     D  RQMBR                 51     60
     D  RQFMT                 61     70
     D  RQLEN                 71     75  0
     D  RQOTQ                 76     85
     D  RQOTL                 86     95
     D  RQRED                 96     96
     D  RQWRT                 97     97
     D  RQUPD                 98     98
     D  RQDLT                 99     99
     D  RQDLO                100    111
     D  RQFLR                112    174
     D  RQTFR                 76    155
      *
     D DSINFO          DS          2000
      *                                                WRT TFR REQ
     D  WRTTFR                30     30
      *                                                CHK TFR REQ
     D  CHKTFR                80     80
      *                                                DENIED LIMIT
     D  DENLMT               130    134  0
      *
      *                                                USRS W/*ALLOBJ(FLR)
     D DSUSRF          DS          1000
      *                                                USRS W/*ALLOBJ(TFR)
     D DSUSRT          DS          1000
      *                                                FLRS W/*PUBLIC
     D DSFLR           DS          1000
      *                                                LIBS W/*PUBLIC
     D DSLIB           DS          1000
      *                                                LIBS W/*PUBLIC
      *
     D TFRTXT          C                   CONST('Authority added by P-
     D                                     CS exit program')
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C     TSTMOD        IFEQ      *OFF
     C                   EXSR      $RQS
     C                   RETURN
     C                   ENDIF
      *
     C     TSTMOD        IFEQ      *ON
     C     *INLR         DOUEQ     *ON
     C                   READ      AUT810R                                LR
     C     *INLR         IFEQ      *OFF
     C                   EXSR      $RQS
     C                   UPDATE    AUT810R
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PROCESS REQUEST.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RQS          BEGSR
      *
     C     ZZPMCT        IFNE      *ZERO
     C                   MOVE      *OFF          RQRTN             1
     C                   MOVE      PLRQS         RQSDS
     C                   ENDIF
      *
     C     RQAPP         CASEQ     '*TFRFCL'     $TFR
     C     RQAPP         CASEQ     '*FLRSRV'     $FLR
     C     RQAPP         CASEQ     '*DDM   '     $DDM
     C     RQAPP         CASEQ     '*MSGFCL'     $MSG
     C     RQAPP         CASEQ     '*VPRT'       $PRT
     C                   ENDCS
      *
     C                   EXSR      $LOG
      *
     C     ZZPMCT        IFNE      *ZERO
     C                   MOVE      RQRTN         PLRTN
     C                   ENDIF
      *
     C     RQRTN         IFEQ      *ON
     C                   MOVE      *ZERO         DENIED
     C                   ELSE
     C                   ADD       1             DENIED
     C     DENIED        IFGT      DENLMT
     C     TSTMOD        ANDEQ     *OFF
     C                   CALL      'AUT100C'
     C                   PARM                    DENLMT
     C                   MOVE      *ZERO         DENIED
     C                   ENDIF
     C                   ENDIF
      *
     CSR   #RQS          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * FOLDERS/DOCUMENTS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FLR          BEGSR
      *
     C                   MOVE      *ON           RQRTN
      *
     C                   SELECT
     C     RQREQ         WHENEQ    'EXTRACT'
     C     RQFLR         ANDEQ     *BLANKS
     C                   GOTO      #FLR
     C     RQREQ         WHENEQ    'CREATE'
     C     RQREQ         OREQ      'OPEN'
     C     RQRED         ANDEQ     *ON
     C     RQWRT         ANDEQ     *ON
     C     RQUPD         ANDEQ     *ON
     C     RQDLT         ANDEQ     *ON
     C                   GOTO      #FLR
     C     RQREQ         WHENEQ    'EXTRACT'
     C     RQREQ         OREQ      'OPEN'
     C     RQRED         ANDEQ     *ON
     C                   MOVE      1             FAASEQ
     C     RQREQ         WHENEQ    'OPEN'
     C     RQWRT         IFEQ      *ON
     C     RQUPD         OREQ      *ON
     C     RQDLT         OREQ      *ON
     C                   MOVE      2             FAASEQ
     C                   ENDIF
     C     RQREQ         WHENEQ    'CHANGE'
     C     RQREQ         OREQ      'MOVE'
     C     RQREQ         OREQ      'RENAME'
     C     RQREQ         OREQ      'DELETE'
     C                   MOVE      3             FAASEQ
     C                   ENDSL
      *
     C                   EXSR      $PARSE
     C     RQFLRN        CABEQ     *BLANKS       #FLR
      *
     C     RQUSR         CABEQ     RQFLRN        #FLR
      *
     C                   EXSR      $FAUSR
     C     FOUND         CABEQ     *ON           #FLR
      *
     C     OPN100        IFEQ      *OFF
     C                   MOVE      *ON           OPN100
     C                   OPEN      AUT100P
     C                   ENDIF
      *
     C                   MOVEL     RQFLRN        FAFLR
     C                   EXSR      $FAFLR
     C     FOUND         IFEQ      *ON
     C                   MOVEL(P)  '*PUBLIC'     FAUSR
     C                   ELSE
     C                   MOVE      RQUSR         FAUSR
     C                   ENDIF
      *
     C     FAKEY3        SETLL     AUT100R
     C     FAKEY2        READE     AUT100R                                99
     C     *IN99         IFEQ      *ON
     C                   MOVE      *OFF          RQRTN
     C                   ENDIF
      *
     CSR   #FLR          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * FILE TRANSFER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TFR          BEGSR
      *
     C                   MOVE      *ON           RQRTN
     C     CHKTFR        CABEQ     *OFF          #TFR
      *
     C                   MOVEL     RQLIB         WK001A
     C     RQREQ         IFEQ      'EXTRACT'
     C     WK001A        ANDEQ     '*'
     C     RQOBJ         ANDEQ     *BLANKS
     C                   GOTO      #TFR
     C                   ENDIF
      *
     C                   SELECT
     C     RQREQ         WHENEQ    'SELECT'
     C     RQREQ         OREQ      'JOIN'
     C     RQREQ         OREQ      'EXTRACT'
     C                   MOVEL     '*DOWNLOA'    TAAUT
     C                   MOVE      'D '          TAAUT
     C                   MOVE      1             TAASEQ
     C     RQREQ         WHENEQ    'REPLACE'
     C                   MOVEL     '*UPLOAD '    TAAUT
     C                   MOVE      '  '          TAAUT
     C                   MOVE      2             TAASEQ
     C                   ENDSL
      *
     C                   EXSR      $TAUSR
     C     FOUND         CABEQ     *ON           #TFR
      *
     C     OPN110        IFEQ      *OFF
     C                   MOVE      *ON           OPN110
     C                   OPEN      AUT110P
     C                   ENDIF
      *
     C                   MOVEL     RQLIB         TALIB
     C                   EXSR      $TALIB
     C     FOUND         IFEQ      *ON
     C                   MOVEL(P)  '*PUBLIC'     TAUSR
     C                   ELSE
     C                   MOVE      RQUSR         TAUSR
     C                   ENDIF
      *
     C     TAKEY3        SETLL     AUT110R
     C     TAKEY2        READE     AUT110R                                99
     C     *IN99         IFEQ      *ON
     C     WRTTFR        IFEQ      *ON
     C                   EXSR      $WRTTF
     C                   ELSE
     C                   MOVE      *OFF          RQRTN
     C                   ENDIF
     C                   ENDIF
      *
     CSR   #TFR          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * WRITE TRANSFER RECORD AS WE DONT WANT TO FORCE
      *  USERS TO CALL US FOR ACCESS ON TRANSFERS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WRTTF        BEGSR
      *
     C                   MOVE      *DATE         TACDTE
     C                   TIME                    TACTIM
     C                   MOVE      ZZUSR         TACUSR
     C                   MOVEL(P)  TFRTXT        TATXT
     C                   CAT       ZZPGM:1       TATXT
     C                   WRITE     AUT110R
      *
     CSR   #WRTTF        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * USERS WITH *ALLOBJ (FOLDERS).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FAUSR        BEGSR
      *
     C                   MOVE      *OFF          FOUND
     C     DSUSRF        IFEQ      *BLANKS
     C                   IN        DSUSRF
     C                   ENDIF
      *
     C     RQUSR         SCAN      DSUSRF        RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVE      *ON           FOUND
     C                   ENDIF
      *
     CSR   #FAUSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * FOLDERS WITH *PUBLIC.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FAFLR        BEGSR
      *
     C                   MOVE      *OFF          FOUND
     C     DSFLR         IFEQ      *BLANKS
     C                   IN        DSFLR
     C                   ENDIF
      *
     C     RQFLRN        SCAN      DSFLR         RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVE      *ON           FOUND
     C                   ENDIF
      *
     CSR   #FAFLR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * USERS WITH *ALLOBJ (TRANSFER).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TAUSR        BEGSR
      *
     C                   MOVE      *OFF          FOUND
     C     DSUSRT        IFEQ      *BLANKS
     C                   IN        DSUSRT
     C                   ENDIF
      *
     C     RQUSR         SCAN      DSUSRT        RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVE      *ON           FOUND
     C                   ENDIF
      *
     CSR   #TAUSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * LIBRARIES WITH *PUBLIC.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TALIB        BEGSR
      *
     C                   MOVE      *OFF          FOUND
     C     DSLIB         IFEQ      *BLANKS
     C                   IN        DSLIB
     C                   ENDIF
      *
     C     RQLIB         SCAN      DSLIB         RESULT
     C     RESULT        IFNE      *ZERO
     C                   MOVE      *ON           FOUND
     C                   ENDIF
      *
     CSR   #TALIB        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PARSE OUT FOLDER NAME.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PARSE        BEGSR
      *
     C                   MOVE      *BLANKS       RQFLRN
      *
     C     RQFLR         IFEQ      *BLANKS
     C                   MOVEL     RQDLO         RQFLRN
     C                   GOTO      #PARSE
     C                   ENDIF
      *
     C     RQDLO         IFEQ      *BLANKS
     C                   GOTO      #PARSE
     C                   ENDIF
      *
     C                   DO        63            X
     C                   SUBST     RQFLR:X       WK001A
     C     WK001A        IFEQ      '/'
     C     WK001A        OREQ      *BLANKS
     C                   LEAVE
     C                   ELSE
     C                   CAT       WK001A:0      RQFLRN
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #PARSE        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * VIRTUAL PRINTING.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PRT          BEGSR
      *
     C                   MOVE      *ON           RQRTN
      *
     CSR   #PRT          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * COMMANDS AND OTHER STUFF.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DDM          BEGSR
      *
     C                   MOVE      *ON           RQRTN
      *
     CSR   #DDM          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * MESSAGE FUNCTION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $MSG          BEGSR
      *
     C                   MOVE      *ON           RQRTN
      *
     CSR   #MSG          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * WRITE LOG RECORD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LOG          BEGSR
      *
     C                   CLEAR                   AUT800R
     C                   MOVE      *DATE         ALDTE
     C                   TIME                    ALTIM
     C                   MOVE      RQUSR         ALUSR
     C                   MOVE      RQAPP         ALAPP
     C                   MOVE      RQREQ         ALREQ
     C                   MOVE      RQOBJ         ALOBJ
     C                   MOVE      RQLIB         ALLIB
     C                   MOVE      RQMBR         ALMBR
     C                   MOVE      RQFMT         ALFMT
     C     RQAPP         IFEQ      '*VPRT'
     C                   MOVE      RQOTQ         ALOTQ
     C                   MOVE      RQOTL         ALOTL
     C                   ENDIF
     C     RQAPP         IFEQ      '*FLRSRV'
     C                   MOVE      RQRED         ALRED
     C                   MOVE      RQWRT         ALWRT
     C                   MOVE      RQUPD         ALUPD
     C                   MOVE      RQDLT         ALDLT
     C                   MOVEL     RQDLO         ALDLO
     C                   MOVEL     RQFLR         ALFLR
     C                   ENDIF
     C     RQAPP         IFEQ      '*TFRFCL'
     C                   MOVEL     RQTFR         ALTFR
     C                   ENDIF
     C                   MOVE      RQRTN         ALRTN
     C                   WRITE     AUT800R
      *
     CSR   #LOG          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          OPN100            1
     C                   MOVE      *OFF          OPN110            1
     C                   MOVE      *OFF          TSTMOD            1
      *
     C                   MOVEL     'ADDLIBLE'    CMD              80
     C                   CAT       ZZPGLB:1      CMD
     C                   CALL      'QCMDEXC'                            99
     C                   PARM                    CMD
     C                   PARM      80            CMDLEN           15 5
      *
     C                   IN        DSINFO
      *
     C                   OPEN      AUT800P
      *
     C     ZZPMCT        IFEQ      *ZERO
     C                   OPEN      AUT810P
     C                   MOVE      *ON           TSTMOD
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
     C                   PARM                    PLRTN             1
     C                   PARM                    PLRQS
      *
     C     FAKEY2        KLIST
     C                   KFLD                    FAFLR
     C                   KFLD                    FAUSR
      *
     C     FAKEY3        KLIST
     C                   KFLD                    FAFLR
     C                   KFLD                    FAUSR
     C                   KFLD                    FAASEQ
      *
     C     TAKEY2        KLIST
     C                   KFLD                    TALIB
     C                   KFLD                    TAUSR
      *
     C     TAKEY3        KLIST
     C                   KFLD                    TALIB
     C                   KFLD                    TAUSR
     C                   KFLD                    TAASEQ
      *
     C     *DTAARA       DEFINE    AUT000D       DSINFO
     C     *DTAARA       DEFINE    AUT100D       DSUSRF
     C     *DTAARA       DEFINE    AUT101D       DSFLR
     C     *DTAARA       DEFINE    AUT110D       DSUSRT
     C     *DTAARA       DEFINE    AUT111D       DSLIB
      *
     C     *LIKE         DEFINE    RQFLRN        PVFLRN
     C     *LIKE         DEFINE    RQRTN         PVRTN
      *
     C                   MOVE      *OFF          FOUND             1
     C                   MOVE      *ZERO         RESULT            5 0
     C                   MOVE      *ZERO         X                 5 0
     C                   MOVE      *ZERO         STRPOS            5 0
     C                   MOVE      *ZERO         DENIED            5 0
     C                   MOVE      *BLANKS       WK001A            1
     C                   MOVE      *BLANKS       RQFLRN           10
     C                   MOVE      *OFF          RQRED             1
     C                   MOVE      *OFF          RQWRT             1
     C                   MOVE      *OFF          RQUPD             1
     C                   MOVE      *OFF          RQDLT             1
      *
     CSR   #DEFN         ENDSR
