      /TITLE Summarize Disk Information
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      * S* PROCESS DISK UTILIZATION INFORMATION PRODUCED BY THE
      * S*  RTVDSKINF COMMAND TO REDUCE THE SIZE OF THE DATABASE
      * S*  TO A MANAGEABLE LEVEL (140KB).
      *
      * C* T.HAWKINS    05/24/93
      *
      * M* ============================================================
      * M* MODIFICATIONS:
      * M* ------------------------------------------------------------
      * M* MM/DD/YY   PROGRAMMER
      * M*            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M*             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M*             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M*             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
     FQAEZDISK  UP A E           K DISK
      *
     D SUMTXT          C                   CONST('Summarized objects')
      *
     IQEZDISKI
     I                                          DIOBLI        L1
     I                                          DIOBTP        L1
      *
     C     DIOBSZ        IFLT      MAXSIZ
     C                   ADD       DIOBSZ        LBSIZE           15 0
     C                   DELETE    QEZDISKI
     C                   ENDIF
      *
     CL1                 EXSR      $WRITE
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * LIBRARY NAME CHANGED, WRITE RECORD FOR OBJECTS LT MAXSIZE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WRITE        BEGSR
      *
     C                   MOVEL(P)  '*OBJSUM'     DIOBNM
     C     DIOBLI        IFEQ      *BLANKS
     C                   CAT       SUMTXT:1      DIOBTX
     C                   ELSE
     C                   MOVEL(P)  SUMTXT        DIOBTX
     C                   ENDIF
     C                   MOVE      *BLANKS       DIOBAT
     C                   MOVE      LBSIZE        DIOBSZ
     C                   WRITE     QEZDISKI
      *
     C                   MOVE      *ZERO         LBSIZE
      *
     CSR   #WRITE        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MAXSIZ           15 0
      *
     CSR   #DEFN         ENDSR
