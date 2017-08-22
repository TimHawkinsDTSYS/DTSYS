      /TITLE Scan and Replace String
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * S:  SYNOPSIS
      * S:
      * S:   DETERMINE SCAN AND REPLACEMENT STRING POSTIONS
      * S:   DETERMINE DISPLACEMENTS & LENGTHS
      * S:   PROCESS STRING
      * S:      DETERMINE LOCATION OF STRINGS TO BE REPLACED FOR NTH SCAN
      * S:      COPY UP TO THE REPLACEMENT
      * S:      COPY IN REPLACEMENT
      * S:      REPEAT
      * S:      MOVE REST OF STRING IN
      * S:      DO NEXT STRING TO BE REPLACED
      * S:
      * S:
      * S:    ERRORS   DESCRIPTION
      * S:  ---------  ---------------------------------------------------
      * S:  'SCN0100'  NOT A 1 TO 1 CORRESPONDENCE BETWEEN SCAN STRINGS
      * S:              AND REPLACE STRINGS.
      * S:  'SCN0101'  REPLACE STRING FORCES OVERFLOW CONDITION OF
      * S:              STRING.
      * S:  'SCN0102'  REPLACE STRING LENGTH IS GREATHER THAN SCAN STRING
      * S:              LENGTH AND NO ADJUSTMENT IS ALLOWED.
      * S:
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M:  MODIFICATIONS
      * M:
      * M:  MM/DD/YY PROGRAMMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     D SSP             S              3  0 DIM(128)                             SCAN STR DELM POS
     D RSP             S              3  0 DIM(128)                             REPL STR DELM POS
     D SSL             S              3  0 DIM(128)                             SCAN STR LENGTH
     D RSL             S              3  0 DIM(128)                             REPLACE STR LENGTH
     D SSS             S              3  0 DIM(128)                             SCN STR STR POS
     D RSS             S              3  0 DIM(128)                             RPL STR STR POS
     D SIT             S              3  0 DIM(128)                             SCAN STRIN IN STG
     D STR             S              1    DIM(512)                             NEW STRING    ING
      *
     D SCNX            DS
     D  SCN                    1    512
     D                                     DIM(512)                             SCAN    STRING
      *
     D RPLX            DS
     D  RPL                    1    512
     D                                     DIM(512)                             REPLACE STRING
      *
     D STGX            DS
     D  STG                    1    512
     D                                     DIM(512)                             STRING
      *
      /EJECT
     C                   EXSR      *INZSR                                       INITIALIZE VAR.
      *
     C     DBL           IFEQ      'Y'                                          DOUBLE REPLACE
     C     FOUND         DOUEQ     *OFF
     C                   EXSR      $POSIT                                       POSTIONS/LENGTHS.
     C                   EXSR      $EDIT                                        EDIT LENGTHS.
     C                   EXSR      $SCAN                                        SCAN/REPLACE.
     C                   ENDDO
     C                   ELSE
      *
     C                   EXSR      $POSIT                                       POSTIONS/LENGTHS.
     C                   EXSR      $EDIT                                        EDIT LENGTHS.
     C                   EXSR      $SCAN                                        SCAN/REPLACE.
     C                   ENDIF
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE POSITIONING OF SCAN & REPL VARIABLES
      * ---------------------------------------------------
      *  1) DETERMINE DELIMITER POSITIONS WITHIN SCAN STRING.
      *  2) DETERMINE DELIMITER POSITIONS WITHIN REPLACE STRING.
      *  3) DETERMINE START START POSITION AND LENGTH.
      *  4) DETERMINE REPLACE START POSITION AND LENGTH.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $POSIT        BEGSR
      *
     C     DLIM          SCAN      SCNX          SSP                            SCAN FOR ALL
     C     DLIM          SCAN      RPLX          RSP                             DELIMITERS.
      *
     C                   Z-ADD     1             POSS              3 0          START POSN SCAN
     C                   Z-ADD     1             POST              3 0          START POSN TRGT
      *
     C                   DO        MAXSTG        I                 3 0          PROCESS EACH
     C                   Z-ADD     SSP(I)        SSPI              3 0           SCAN STRING.
     C                   Z-ADD     RSP(I)        RSPI              3 0
      *
     C     SSPI          IFEQ      *ZERO                                        NO MORE TO
     C                   LEAVE                                                   PROCESS;
     C                   ENDIF                                                   GET OUT.
      *
     C     RSPI          IFEQ      *ZERO                                        NO MORE THEN
     C                   MOVE      'SCN0100'     ERRMID                         ERROR SHOULD BE
     C                   RETURN                                                 1:1 SCAN/REPLCE
     C                   ENDIF                                                  RSPI=0
      *
     C     SSPI          SUB       POSS          SSL(I)                         LENGTH SCAN
     C     RSPI          SUB       POST          RSL(I)                         LENGTH REPLACE
     C                   Z-ADD     POSS          SSS(I)                         START POS SCAN
     C                   Z-ADD     POST          RSS(I)                         START POS REPL
     C     SSPI          ADD       1             POSS                           POS IN SCAN STR
     C     RSPI          ADD       1             POST                           POS IN REPL STR
      *
     C                   ENDDO                                                  EACH STRING.
      *
     CSR   #POSIT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * EDIT LENGTHS.
      * ---------------------------------------------------
      *  1) DETERMINE IF REPLACE STRING IS GREATER THAN SCAN
      *      STRING AND ADJUSTMENT OPTION IS N=NO.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $EDIT         BEGSR
      *
     C                   DO        MAXSTG        I                 3 0          PROCESS STRINGS.
      *
     C     SSS(I)        IFEQ      *ZERO                                        NO MORE TO
     C                   LEAVE                                                   PROCESS;
     C                   ENDIF                                                   GET OUT.
      *
     C     ADJ           IFNE      'Y'
     C     RSL(I)        ANDGT     SSL(I)                                       REPLACE LEN *GT
     C                   MOVE      'SCN0102'     ERRMID                          SCAN LENGTH;
     C                   RETURN                                                  AND NO ADJ.
     C                   ENDIF
      *
     C                   ENDDO                                                  EACH STRING.
      *
     CSR   #EDIT         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SCAN FOR STRINGS.
      * ---------------------------------------------------
      *  1) SCAN FOR EACH SCAN STRING.
      *  2) EXECUTE REPLACE FUNCTION.
      *  3) COPY IN REMAINING CHARACTERS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SCAN         BEGSR
      *
     C                   MOVE      *OFF          FOUND             1
      *
     C                   DO        MAXSTG        I                              PROCESS EACH
     C                   Z-ADD     SSL(I)        J                 3 0           SCAN STRING.
      *
     C     J             IFEQ      *ZERO                                        NO MORE TO
     C                   LEAVE                                                   PROCESS;
     C                   ENDIF                                                   GET OUT.
      *
     C                   Z-ADD     SSS(I)        J                              SCAN STR POS
     C                   Z-ADD     SSL(I)        L                 3 0          SCAN STR LEN
     C                   RESET                   SCAN                           SCAN STRING
     C                   MOVEA     SCN(J)        SCAN                           SCAN STRING
      *
     C     SCAN:L        SCAN      STGX          SIT                      99     FIND STRINGS
      *
     C     *IN99         IFEQ      *ON                                          FOUND A STRING.
     C                   MOVE      *ON           FOUND
     C                   EXSR      $REPL                                        REPLACE
     C                   EXSR      $OVER                                        OVERFLOW?
     C                   MOVEA     STG(M)        STR(N)                         COPY THRU END
     C                   MOVEA     STR           STG                            REPLACE WITH NEW
     C                   ENDIF                                                  *IN99='1' FND SOM
      *
     C                   ENDDO                                                  EACH STRING.
      *
     CSR   #SCAN         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * REPLACE STRING.
      * ---------------------------------------------------
      *  1) COPY ALL CHARACTERS UP TO SCAN START POSITION.
      *  2) COPY IN REPLACEMENT CHARACTERS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $REPL         BEGSR
      *
     C                   RESET                   STR                            WORK STR
     C                   Z-ADD     1             M                 3 0          OLD STRING POS
     C                   Z-ADD     1             N                 3 0          NEW STRING POS
      *
     C                   DO        MAXSTG        Z                 3 0          STRING
     C                   Z-ADD     SIT(Z)        SITZ              3 0           OCCURANCES.
      *
     C     SITZ          IFEQ      *ZERO                                        NO MORE TO
     C                   LEAVE                                                   PROCESS;
     C                   ENDIF                                                   GET OUT.
      *
     C     M             DOWLT     SITZ                                         COPY UP TO
     C                   MOVEL     STG(M)        STR(N)                          REPLACEMENT
     C                   ADD       1             M                               POSITION.
     C                   ADD       1             N
     C                   EXSR      $OVER
     C                   ENDDO
      *
     C                   ADD       L             M                              POS OVER SCN
     C                   Z-ADD     RSL(I)        R                 3 0          REPL STR LEN
     C                   Z-ADD     RSS(I)        S                 3 0          REPL STR POS
      *
     C                   DO        R                                            REPLACE
     C                   MOVEL     RPL(S)        STR(N)                          CHARACTERS
     C                   ADD       1             S                               IN STRING.
     C                   ADD       1             N
     C                   EXSR      $OVER
     C                   ENDDO
      *
     C     ADJ           IFNE      'Y'                                          -- PAD IT --
     C     SSL(I)        SUB       RSL(I)        R                              PAD STR LEN
     C                   DO        R                                            REPLACE
     C                   MOVEL     PAD           STR(N)                          CHARACTERS
     C                   ADD       1             S                               IN STRING.
     C                   ADD       1             N
     C                   EXSR      $OVER
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDDO                                                  STRING OCCUR.
      *
     CSR   #REPL         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CHECK FOR STRING OVERFLOW ERROR.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OVER         BEGSR
      *
     C     N             IFGT      MAXLEN                                       STRING
     C                   MOVE      'SCN0101'     ERRMID                          OVERFLOWED;
     C                   RETURN                                                  ERROR;
     C                   ENDIF                                                   GET OUT.
      *
     CSR   #OVER         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   CLEAR                   SCAN            128            SCAN STRING
     C                   CLEAR                   ERRMID                         CLEAR ERROR
     C                   MOVE      512           MAXLEN            3 0          MAX LENGTH
     C                   MOVE      128           MAXSTG            3 0          MAX STRINGS
      *
     C                   MOVE      @DLIM         DLIM                           DELIMITER
     C                   MOVE      @ADJ          ADJ                            ADJUST Y/N
     C                   MOVE      @PAD          PAD                            PAD CHARACTER
     C                   MOVE      @DBL          DBL                            DOUBLE REPLACE
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES/PARMS/KLIST.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    @DLIM             1            DELIMITER VALUE
     C                   PARM                    @ADJ              1            ADJUST Y=YES,N=NO
     C                   PARM                    @PAD              1            PAD CHARACTER
     C                   PARM                    @DBL              1            DOUBLE REPLACE
     C     STGX          PARM      STGX          @STNG           512            STRING VALUE
     C     SCNX          PARM                    @SCAN           512            SCAN   VALUES
     C     RPLX          PARM                    @REPL           512            REPLAC VALUES
     C                   PARM      ERRMID        @ERRMI            7            ERROR MSGID
      *
     C     *LIKE         DEFINE    @ERRMI        ERRMID                         ERROR MSGID
     C     *LIKE         DEFINE    @DLIM         DLIM                           DELIMITER
     C     *LIKE         DEFINE    @ADJ          ADJ                            ADJUST Y/N
     C     *LIKE         DEFINE    @PAD          PAD                            PAD CHARACTER
     C     *LIKE         DEFINE    @DBL          DBL                            DOUBLE REPLACE
      *
     CSR   #DEFN         ENDSR
