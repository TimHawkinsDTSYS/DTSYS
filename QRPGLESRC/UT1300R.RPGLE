      /TITLE Binary Search Processor
      *
      * P: PARMS USRPRF(*OWNER) OPTION(*NOXREF)
      *
      * S:
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
     D KEY             S             55    DIM(32767) ASCEND                    KEYS
     D DTA             S            256    DIM(32767)                           DATA
      *
     D LKP             S              5  0 DIM(50)                              MID POINTS
      *
      /EJECT
      *
     C     BSMODE        CASEQ     'FIND'        $FIND                           FIND ENTRY
     C     BSMODE        CASEQ     'LOAD'        $LOAD                           LOAD ENTRY
     C     BSMODE        CASEQ     'CLEAR'       $CLEAR                          CLEAR ALL
     C                   ENDCS
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * BINARY SEARCH FOR KEY.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FIND         BEGSR
      *
     C     LODENT        CASEQ     *ON           $MIDPT                         LOAD
     C                   ENDCS                                                   MID-POINTS.
      *
     C                   Z-ADD     LKPMID        LX
     C                   CLEAR                   LY
     C                   Z-ADD     2             LKPINC
     C                   MOVEL     BSKFLD        LKPSRC
      *
     C     LKPSRC        DOUEQ     LKPWRK
      *
     C     LX            IFLE      *ZERO                                        COULD NOT
     C     LX            ORGT      32767                                         FIND ENTRY.
     C                   MOVE      *OFF          BSFIND
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVE      KEY(LX)       WK055A                         LOAD UP
     C                   MOVEL     WK055A        LKPWRK                          "KEY".
      *
     C     LKPINC        IFEQ      1                                            COULD NOT
     C     LKPSRC        ANDNE     LKPWRK                                        FIND ENTRY.
     C                   MOVE      *OFF          BSFIND
     C                   RETURN
     C                   ENDIF
      *
     C                   ADD       1             LY
     C                   MOVE      LKP(LY)       LKPINC
      *
     C     LKPSRC        IFGT      LKPWRK                                       IF SEARCH ARG
     C                   ADD       LKPINC        LX                              IS *GT,
     C     LX            IFGT      LKPMAX                                        INCREMENT.
     C                   Z-ADD     LKPMAX        LX
     C                   ENDIF
     C                   ELSE
      *
     C     LKPSRC        IFLT      LKPWRK                                       IF SEARCH ARG
     C                   SUB       LKPINC        LX                              IS *LT,
     C     LX            IFLT      1                                             DECREMENT.
     C                   Z-ADD     1             LX
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      *ON           BSFIND
      *
     C     BSFIND        IFEQ      *ON                                          FOUND
     C                   MOVEA     KEY(LX)       WK055A                          ENTRY.
     C                   MOVE      WK055A        IX
     C                   MOVEA     DTA(IX)       BSDATA
     C                   ENDIF
      *
     CSR   #FIND         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  LOAD MID-POINTS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $MIDPT        BEGSR
      *
     C                   SORTA     KEY
     C                   MOVE      *OFF          LODENT
     C                   Z-ADD     .5            DEC31
     C                   CLEAR                   LKP
     C                   CLEAR                   LY
      *
     C     ARYIDX        IFLE      1                                            DEFAULT TO
     C                   Z-ADD     32767         LKPMAX                          MAXIMUM.
     C                   ELSE
     C                   Z-ADD     ARYIDX        LKPMAX                         USE WHATS
     C                   ENDIF                                                   BEEN LOADED.
      *
     C     LKPMAX        MULT      DEC31         LKPINC
     C                   Z-ADD     LKPINC        LKPMID
      *
     C     LKPINC        DOULE     1                                            BUILD ARRAY
     C                   MULT(H)   DEC31         LKPINC                          OF HALVES.
     C                   ADD       1             LY
     C                   MOVE      LKPINC        LKP(LY)
     C                   ENDDO
      *
     CSR   #MIDPT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * LOAD ENTRY.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LOAD         BEGSR
      *
     C                   ADD       1             ARYIDX                         ADD
     C                   MOVE      ARYIDX        IX                              ENTRY.
     C                   MOVEL     BSKFLD        WK055A
     C                   MOVE      ARYIDX        WK055A
     C                   MOVEA     WK055A        KEY(IX)
     C                   MOVEA     BSDATA        DTA(IX)
      *
     C                   MOVE      *ON           LODENT                         LOADED ENTRY.
      *
     CSR   #LOAD         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CLEAR ALL ENTRIES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CLEAR        BEGSR
      *
     C                   CLEAR                   ARYIDX
     C                   MOVE      *HIVAL        KEY
     C                   CLEAR                   DTA
     C                   MOVE      *OFF          LODENT
      *
     CSR   #CLEAR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          LODENT            1            LOAD DEFAULTS
     C                   MOVE      *HIVAL        KEY
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    BSMODE            8            FIND/LOAD/CLEAR
     C                   PARM                    BSFIND            1            1=FOUND,0=LOADED
     C                   PARM                    BSKFLD           50
     C                   PARM                    BSDATA          256
      *
     C                   CLEAR                   LKPMAX            5 0
     C                   CLEAR                   DEC31             3 1
     C                   CLEAR                   LKPINC            5 0
     C                   CLEAR                   LKPMID            5 0
     C                   CLEAR                   LX                5 0
     C                   CLEAR                   LY                5 0
     C                   CLEAR                   IX                5 0
     C                   CLEAR                   ARYIDX            5 0
     C                   CLEAR                   WK055A           55
      *
     C     *LIKE         DEFINE    BSKFLD        LKPSRC
     C     *LIKE         DEFINE    LKPSRC        LKPWRK
      *
     CSR   #DEFN         ENDSR
