      /TITLE Spell-Check Text
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
      *
      *
     FSCT000D   CF   E             WORKSTN SFILE(WDWSFL:RN)
      *
     D RTN             S              1    DIM(256)
      *
     D CHKVAR          DS           512
     D  CHKAVL                13     16B 0
     D  CHKOFF                17     20B 0
     D  CHKLEN                21     24B 0
      *
     D AIDVAR          DS           512
     D  AIDAVL                13     16B 0
     D  AIDOFF                29     32B 0
     D  AIDLEN                33     36B 0
      *
     D INPDCT          DS           172    INZ
     D  DCTOFF                 1      4B 0 INZ(12)
     D  DCTNUM                 5      8B 0 INZ(1)
     D  DCTRSV                 9     12B 0 INZ(0)
     D  INPDC1                13     32
     D  INPDC2                33     52
      *
     D WKFLDS          DS                  INZ
     D  RCVLEN                 1      4B 0 INZ(512)
     D  INPLEN                 5      8B 0 INZ(172)
     D  WRDLEN                 9     12B 0
     D  OUTDCT                13     16B 0
     D  OUTLEN                17     20B 0
     D  OFFBIN                21     24B 0
     D  OFFCHR                21     24
     D  LENBIN                25     28B 0
     D  LENCHR                25     28
      *
     D ERROR           DS                  INZ
     D  BYTPRV                 1      4B 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    TEXT            256
     C                   PARM                    RTNVAR          256
     C                   PARM                    LNGDCT           20
     C                   PARM                    USRDCT           20
      *
      * Load input dictionary data structure
     C                   MOVEL     LNGDCT        INPDC1
     C     USRDCT        IFNE      *BLANKS
     C                   MOVEL     USRDCT        INPDC2
     C                   Z-ADD     2             DCTNUM
     C                   ENDIF
      *
      * Check spelling of input string
     C                   EXSR      CHKSPL
      *
     C                   MOVE      *ON           *INLR
      *****************************************************************
     C     CHKSPL        BEGSR
      *
     C                   MOVEL     TEXT          RTNVAR
     C     ' '           CHECKR    TEXT          WRDLEN
     C                   Z-ADD     0             COUNT             3 0
     C                   Z-ADD     1             ST                3 0
      *
      * Call "Check Spelling" API to retrieve misspelled words
     C                   CALL      'QTWCHKSP'
     C                   PARM                    CHKVAR
     C                   PARM                    RCVLEN
     C                   PARM      'CHKW0100'    FMTNAM            8
     C                   PARM                    TEXT
     C                   PARM                    WRDLEN
     C                   PARM                    INPDCT
     C                   PARM                    INPLEN
     C                   PARM                    OUTDCT
     C                   PARM                    OUTLEN
     C                   PARM                    ERROR
      *
      * Process misspelled words until no more or user cancels
     C     COUNT         DOWLT     CHKAVL
     C     *IN03         ANDEQ     *OFF
     C     CHKOFF        ADD       1             X                 4 0
     C     4             SUBST     CHKVAR:X      OFFCHR
     C                   ADD       4             X
     C     4             SUBST     CHKVAR:X      LENCHR
     C                   ADD       CHKLEN        CHKOFF
     C     OFFBIN        ADD       1             X
     C     LENBIN        SUBST(P)  CHKVAR:X      WRD              25
     C                   Z-ADD     LENBIN        LENWRD            3 0
     C                   EXSR      AIDSPL
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C     AIDSPL        BEGSR
      *
      * Clear subfile
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *ON           *IN91
     C                   WRITE     WDWCTL
     C                   MOVE      *OFF          *IN91
     C                   Z-ADD     0             RN                4 0
      *
     C     ' '           CHECKR    WRD           WRDLEN
     C                   Z-ADD     WRDLEN        WL                3 0
     C     WRD:WL        SCAN      RTNVAR:ST     ST
      *
      * Call "Aid Spelling" API to retrieve suggested spellings
     C                   CALL      'QTWAIDSP'
     C                   PARM                    AIDVAR
     C                   PARM                    RCVLEN
     C                   PARM      'AIDW0100'    FMTNAM
     C                   PARM                    WRD
     C                   PARM                    WRDLEN
     C                   PARM                    INPDCT
     C                   PARM                    INPLEN
     C                   PARM                    OUTDCT
     C                   PARM                    OUTLEN
     C                   PARM                    ERROR
      *
      * Load suggested spellings into subfile
     C     AIDAVL        IFGT      0
     C                   DO        AIDAVL
     C     AIDOFF        ADD       1             X                 4 0
     C     4             SUBST     AIDVAR:X      OFFCHR
     C                   ADD       4             X
     C     4             SUBST     AIDVAR:X      LENCHR
     C                   ADD       AIDLEN        AIDOFF
     C     OFFBIN        ADD       1             X
     C                   MOVE      *BLANKS       SFOPTN
     C     LENBIN        SUBST(P)  AIDVAR:X      SFWORD
     C                   MOVE      *ON           *IN90
     C                   ADD       1             RN
     C                   WRITE     WDWSFL
     C                   END
     C                   END
      *
      * Display window containing suggested spellings
     C                   ADD       1             COUNT
     C                   MOVEL     WRD           CTWORD
     C                   WRITE     WDWFTR
     C                   EXFMT     WDWCTL
     C                   MOVE      'N'           REPLCD            1
      *
      * Check to see if user changed the word
     C     WRD           IFNE      CTWORD
     C                   MOVEL     CTWORD        RPWORD           25
     C                   EXSR      RPLWRD
     C                   ENDIF
      *
      * Check to see if a selection was made
     C     *IN90         IFEQ      *ON
     C                   READC     WDWSFL                                 99
     C     *IN99         DOWEQ     *OFF
     C     SFOPTN        IFEQ      '1'
     C                   MOVEL     SFWORD        RPWORD
     C                   EXSR      RPLWRD
     C                   MOVE      *ON           *IN99
     C                   ELSE
     C                   READC     WDWSFL                                 99
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C     REPLCD        IFEQ      'N'
     C                   ADD       WL            ST
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C     RPLWRD        BEGSR
      *
     C                   MOVE      'Y'           REPLCD
     C                   MOVE      *BLANKS       LEFT            256
     C                   MOVE      *BLANKS       RIGHT           256
     C     ST            SUB       1             X
      *
     C     X             IFGT      0
     C     X             SUBST     RTNVAR        LEFT
     C                   ENDIF
      *
     C     257           SUB       ST            Y                 3 0
     C                   SUB       WRDLEN        Y
     C     WRDLEN        ADD       ST            X
      *
     C     Y             IFGT      0
     C     Y             SUBST     RTNVAR:X      RIGHT
     C                   ENDIF
      *
     C                   MOVEA     LEFT          RTN
     C                   MOVEA     RPWORD        RTN(ST)
     C     ' '           CHECKR    RPWORD        RPWDLN            3 0
     C     ST            ADD       RPWDLN        X
     C                   MOVEA     RIGHT         RTN(X)
     C                   MOVEA     RTN           RTNVAR
     C                   ADD       RPWDLN        ST
      *
     C                   ENDSR
