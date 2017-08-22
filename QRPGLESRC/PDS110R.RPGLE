      /TITLE Print Dump Summary, Detail Report
      *
      * P: PARMS USRPRF(*OWNER) AUT(*ALL)
      *
      * S: PRINTS DUMP SUMMARY DETAIL
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
     FPDS110P   IF   E             DISK    USROPN
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
     F                                     USROPN
      *
     D AY1             S              1    DIM(21)
     D AY2             S              1    DIM(10)
      *
     D TYPE            S             80    DIM(6) CTDATA PERRCD(1)
     D TCLP            S             80    DIM(8) CTDATA PERRCD(1)
     D TRPG            S             80    DIM(9) CTDATA PERRCD(1)
     D TPLI            S             80    DIM(3) CTDATA PERRCD(1)
     D TSRV            S             80    DIM(8) CTDATA PERRCD(1)
      *
      /SPACE 3
     C                   EXSR      $READ
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * READ THROUGH FILE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $READ         BEGSR
      *
     C                   EXSR      $CLEAR
     C                   OPEN      PDS110P
      *
     C     *IN99         DOUEQ     *ON
     C                   READ      PDS110PR                               99
     C     *IN99         IFEQ      *OFF
     C                   EXSR      $PROCS
     C                   END
     C                   END
      *
     C     PRTDTL        IFEQ      '*YES'
     C                   EXCEPT    SPC01
     C                   END
      *
     C     MSGID         IFEQ      *BLANKS
     C     FILMID        ANDNE     *BLANKS
     C                   MOVE      FILMID        MSGID
     C                   END
      *
     C                   CLOSE     PDS110P
      *
     CSR   #READ         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PROCESS SPOOL FILE RECORD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PROCS        BEGSR
      *
     C                   ADD       1             PRTCNT
      *
     C     CLP           IFEQ      *OFF
     C     RPG           ANDEQ     *OFF
     C     PLI           ANDEQ     *OFF
     C     SRV           ANDEQ     *OFF
     C                   EXSR      $TYPE
     C                   END
      *
     C     CLP           CASEQ     *ON           $CLP
     C     RPG           CASEQ     *ON           $RPG
     C     PLI           CASEQ     *ON           $PLI
     C     SRV           CASEQ     *ON           $SRV
     C                   END
      *
     CSR   #PROCS        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PRINT CLP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CLP          BEGSR
      *
     C     PGMNAM        IFEQ      *BLANKS
     C     TCLP(1):12    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   ADD       30            S
     C     10            SUBST     SPLDTA:S      PGMNAM
     C                   END
     C                   END
      *
     C     LIBNAM        IFEQ      *BLANKS
     C     TCLP(2):7     SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   ADD       30            S
     C     10            SUBST     SPLDTA:S      LIBNAM
     C                   EXSR      $QUAL
     C                   END
     C                   END
      *
     C     MSGID         IFEQ      *BLANKS
     C     TCLP(3):15    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   ADD       16            S
     C     7             SUBST     SPLDTA:S      MSGID
     C                   END
     C                   END
      *
     C     TCLP(4):15    SCAN      SPLDTA        S
     C     S             IFEQ      *ZERO
     C     TCLP(5):15    SCAN      SPLDTA        S
     C     S             IFEQ      *ZERO
     C     TCLP(6):15    SCAN      SPLDTA        S
     C     S             IFEQ      *ZERO
     C     TCLP(7):7     SCAN      SPLDTA        S
     C     S             IFEQ      *ZERO
     C     TCLP(8):9     SCAN      SPLDTA        S
     C     S             IFEQ      *ZERO
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     TCLP(8):9     SCAN      SPLDTA        S
     C     PRTCNT        IFGT      5
     C     FCFC          ANDEQ     '1'
     C     S             ORNE      *ZERO
     C                   FEOD      PDS110P
     C                   END
      *
     CSR   #CLP          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PRINT RPG.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RPG          BEGSR
      *
     C     QLFNAM        IFEQ      *BLANKS
     C     TRPG(1):12    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     21            SUBST     SPLDTA:45     QLFNAM
     C                   EXSR      $PRINT
     C                   END
     C                   END
      *
     C     STMTNO        IFEQ      *BLANKS
     C     TRPG(2):12    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     8             SUBST     SPLDTA:45     STMTNO            8
     C                   MOVEL     STMTNO        WK001A            1
     C     WK001A        IFNE      '*'
     C     STMTNO        ANDNE     *ZERO
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
      *
     C     MSGDTA        IFEQ      *BLANKS
     C     TRPG(3):12    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     10            SUBST     SPLDTA:45     MSGDTA           10
     C     MSGDTA        IFNE      *BLANKS
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
      *
     C     FILSTS        IFEQ      *BLANKS
     C     TRPG(4):15    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     4             SUBST     SPLDTA:46     WK004A            4
     C                   MOVEL     'RPG'         FILMID            7
     C                   MOVE      WK004A        FILMID
     C                   MOVEL     SPLDTA        FILSTS           44
     C                   READ      PDS110PR                               98
     C                   MOVEL     SPLDTA        WK010A           10
     C     WK010A        IFEQ      *BLANKS
     C     87            SUBST     SPLDTA:16     WK087A           87
     C                   MOVE      *BLANKS       SPLDTA
     C                   MOVEL     FILSTS        WK131A          131
     C                   MOVE      WK087A        WK131A
     C                   MOVEL     WK131A        SPLDTA
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
      *
     C     PGMSTS        IFEQ      *BLANKS
     C     TRPG(5):16    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVEL     SPLDTA        PGMSTS           44
     C                   READ      PDS110PR                               98
     C                   MOVEL     SPLDTA        WK010A           10
     C     WK010A        IFEQ      *BLANKS
     C     87            SUBST     SPLDTA:16     WK087A           87
     C                   MOVE      *BLANKS       SPLDTA
     C                   MOVEL     PGMSTS        WK131A          131
     C                   MOVE      WK087A        WK131A
     C                   MOVEL     WK131A        SPLDTA
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
      *
     C     FILUSE        IFEQ      *BLANKS
     C     TRPG(8):14    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     8             SUBST     SPLDTA:45     FILUSE            8
     C                   EXSR      $PRINT
     C                   END
     C                   END
      *
     C     FILNAM        IFEQ      *BLANKS
     C     TRPG(9):14    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     8             SUBST     SPLDTA:45     FILNAM            8
     C     FILNAM        IFEQ      FILUSE
     C                   EXSR      $PRINT
     C                   ELSE
     C                   MOVE      *BLANKS       FILNAM
     C                   END
     C                   END
     C                   END
      *
     C     FILNAM        IFEQ      FILUSE
     C     MSGID         ANDEQ     *BLANKS
     C     TRPG(6):18    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     7             SUBST     SPLDTA:45     MSGID
     C     MSGID         IFNE      *BLANKS
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
      *
     C     MSGID         IFEQ      *BLANKS
     C     TRPG(7):12    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     7             SUBST     SPLDTA:45     MSGID
     C     MSGID         IFNE      *BLANKS
     C                   EXSR      $PRINT
     C                   END
     C                   END
     C                   END
      *
     CSR   #RPG          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PRINT PLI.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PLI          BEGSR
      *
     C     PGMNAM        IFEQ      *BLANKS
     C     TPLI(1):16    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     TPLI(3):11    SCAN      SPLDTA        S
     C                   ADD       12            S
     C     21            SUBST     SPLDTA:S      WK021A           21
     C                   EXSR      $UQUAL
     C                   EXSR      $QUAL
     C                   END
     C                   END
      *
     C                   EXSR      $PRINT
      *
     C     PRTCNT        IFGT      5
     C     FCFC          ANDEQ     '1'
     C                   FEOD      PDS110P
     C                   END
      *
     CSR   #PLI          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PRINT SRV.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SRV          BEGSR
      *
     C     QLFNAM        IFEQ      *BLANKS
     C     TSRV(1):15    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     10            SUBST     SPLDTA:32     QLFNAM
     C                   MOVE      *BLANKS       SPLDTA
     C                   MOVEL     TSRV(5)       SPLDTA
     C                   MOVE      *BLANKS       WK087A
     C                   MOVEL     QLFNAM        WK087A
     C                   MOVE      WK087A        SPLDTA
     C                   EXSR      $PRINT
     C                   END
     C                   END
      *
     C     RCVNAM        IFEQ      *BLANKS
     C     TSRV(2):18    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     10            SUBST     SPLDTA:32     RCVNAM           10
     C                   MOVE      *BLANKS       SPLDTA
     C                   MOVEL     TSRV(6)       SPLDTA
     C                   MOVE      *BLANKS       WK087A
     C                   MOVEL     RCVNAM        WK087A
     C                   MOVE      WK087A        SPLDTA
     C                   EXSR      $PRINT
     C                   END
     C                   END
      *
     C     MESSAG        IFEQ      *BLANKS
     C     TSRV(3):9     SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVEL     SPLDTA        MESSAG            9
     C                   READ      PDS110PR                               98
     C     87            SUBST     SPLDTA:3      WK087A           87
     C                   MOVE      *BLANKS       SPLDTA
     C                   MOVEL     TSRV(7)       SPLDTA
     C                   MOVE      WK087A        SPLDTA
     C                   EXSR      $PRINT
     C                   END
     C                   END
      *
     C     MSGID         IFEQ      *BLANKS
     C     TSRV(4):12    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C     7             SUBST     SPLDTA:32     MSGID
     C                   MOVE      *BLANKS       SPLDTA
     C                   MOVEL     TSRV(8)       SPLDTA
     C                   MOVE      *BLANKS       WK087A
     C                   MOVEL     MSGID         WK087A
     C                   MOVE      WK087A        SPLDTA
     C                   EXSR      $PRINT
     C                   END
     C                   END
      *
     C     QLFNAM        IFNE      *BLANKS
     C     RCVNAM        ANDNE     *BLANKS
     C     MESSAG        ANDNE     *BLANKS
     C     MSGID         ANDNE     *BLANKS
     C                   FEOD      PDS110P
     C                   END
      *
     CSR   #SRV          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT DETAIL LINE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PRINT        BEGSR
      *
     C     PRTDTL        IFEQ      '*YES'
     C     HDGPRT        IFEQ      *OFF
     C                   MOVE      *ON           HDGPRT
     C                   EXCEPT    HDG01
     C                   END
     C                   EXCEPT    DTL01
     C                   END
      *
     CSR   #PRINT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE TYPE OF DUMP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TYPE         BEGSR
      *
     C     TYPE(1):13    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVE      *ON           CLP               1
     C                   GOTO      #TYPE
     C                   END
      *
     C     TYPE(2):7     SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVE      *ON           RPG               1
     C                   GOTO      #TYPE
     C                   END
      *
     C     TYPE(3):7     SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVE      *ON           RPG               1
     C                   GOTO      #TYPE
     C                   END
      *
     C     TYPE(6):4     SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVE      *ON           RPG               1
     C                   GOTO      #TYPE
     C                   END
      *
     C     TYPE(4):7     SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVE      *ON           PLI               1
     C                   GOTO      #TYPE
     C                   END
      *
     C     TYPE(5):11    SCAN      SPLDTA        S
     C     S             IFNE      *ZERO
     C                   MOVE      *ON           SRV               1
     C                   GOTO      #TYPE
     C                   END
      *
     CSR   #TYPE         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  QUALIFY PROGRAM NAME.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $QUAL         BEGSR
      *
     C                   MOVE      *BLANKS       QLFNAM
      *
     C     LIBNAM        IFNE      *BLANKS
     C                   MOVEL     LIBNAM        QLFNAM
     C     QLFNAM        CAT       '/':0         QLFNAM
     C                   END
      *
     C     QLFNAM        CAT       PGMNAM:0      QLFNAM
      *
     CSR   #QUAL         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  UN-QUALIFY PROGRAM NAME.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UQUAL        BEGSR
      *
     C                   MOVE      WK021A        AY1(1)
     C                   MOVE      *BLANKS       AY2
      *
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     21
     C     AY1(X)        OREQ      '.'
     C     AY1(X)        IFNE      '.'
     C                   MOVE      AY1(X)        AY2(X)
     C                   ADD       1             X
     C                   END
     C                   END
      *
     C                   ADD       1             X
     C                   MOVEA     AY2           PGMNAM
     C                   MOVE      *BLANKS       AY2
      *
     C     X             DOWLT     21
     C     AY1(X)        OREQ      *BLANKS
     C     AY1(X)        IFNE      *BLANKS
     C                   MOVE      AY1(X)        AY2(X)
     C                   ADD       1             X
     C                   END
     C                   END
      *
     C                   MOVEA     AY2           LIBNAM
      *
     CSR   #UQUAL        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CLEAR VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CLEAR        BEGSR
      *
     C                   MOVE      *OFF          CLP
     C                   MOVE      *OFF          RPG
     C                   MOVE      *OFF          PLI
     C                   MOVE      *OFF          SRV
     C                   MOVE      *OFF          HDGPRT
     C                   MOVE      *ZERO         PRTCNT
     C                   MOVE      *BLANKS       PGMNAM
     C                   MOVE      *BLANKS       LIBNAM
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       QLFNAM
     C                   MOVE      *BLANKS       STMTNO
     C                   MOVE      *BLANKS       MSGDTA
     C                   MOVE      *BLANKS       FILSTS
     C                   MOVE      *BLANKS       PGMSTS
     C                   MOVE      *BLANKS       RCVNAM
     C                   MOVE      *BLANKS       MESSAG
     C                   MOVE      *BLANKS       FILUSE
     C                   MOVE      *BLANKS       FILNAM
     C                   MOVE      *BLANKS       FILMID
     C                   MOVE      *BLANKS       FILSTS
      *
     CSR   #CLEAR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *ON           *INOF
     C                   MOVE      *OFF          HDGPRT            1
     C                   TIME                    UTIME             6 0
     C                   MOVE      *ZERO         S                 5 0
     C                   MOVE      *ZERO         PRTCNT            5 0
     C                   MOVE      *BLANKS       LIBNAM           10
     C                   MOVE      *BLANKS       PGMNAM           10
      *
     C     PRTDTL        IFEQ      '*YES'
     C                   OPEN      QSYSPRT
     C                   END
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    HDGTXT          132
     C                   PARM                    PRTDTL            4
     C                   PARM                    QLFNAM           21
     C                   PARM                    MSGID             7
     C                   PARM                    TITLE            80
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   H    OF                     2 06
     O                       UDATE         Y   +  0
     O                       UTIME             +  1 '0 .  .  '
     O                       TITLE             +  9
     O                                          127 'Page'
     O                       PAGE          Z   +  1
      *
     OQSYSPRT   EF           HDG01          1
     O                       HDGTXT            +  0
      *
     OQSYSPRT   EF           DTL01          1
     O                       SPLDTA            +  0
      *
     OQSYSPRT   E            SPC01          1
      *
**    * TYPE - TYPES OF DUMPS
CL Program Du
RPG III
RPG/400
PLIDUMP
AS/400 DUMP
PSSR
**    * CLP  - CL PROGRAMS
Program name
Library
Function check.
CL Program Dump
Job name  . . .
Program name  .
Message
Variables
**    * RPG  - RPG/400
Program Name
Statement in
Message Data
Last File Statu
Program Status .
Message Identifier
Message Type
Last File Used
File . . . . .
**    * PLI  - PL/I
EXTERNAL STORAGE
AUTOMATIC STORAGE
FOR PROGRAM
**    * SRV  - SERVICE
.SENDING PROGRAM
.RECEIVING PROGRAM
.MESSAGE-
.MESSAGE ID-
 Sending Program  . . . . . . . . . . . :
 Receiving Program  . . . . . . . . . . :
 Message Text . . . . . . . . . . . . . :
 Message identifier . . . . . . . . . . :
