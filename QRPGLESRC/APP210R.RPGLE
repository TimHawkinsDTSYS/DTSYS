      /TITLE Application Driver, Update User Information
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
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
      /COPY QCPYSRC,Hspec
      *
     FAPP210D   CF   E             WORKSTN
     F                                     INFDS(DSdsp)
     FAPP110P   UF   E           K DISK
      *
     D APP110        E DS                  EXTNAME(APP110P)
      *
      /COPY QCPYSRC,Dspec
      *
     C                   EXSR      $DSPLY
      *
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DISPLAY PANEL.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DSPLY        BEGSR
      *
     C     ZZUSR         CHAIN(N)  APP110R                            99
      *
     C                   MOVE      PUTOVR        *IN91
     C     PUTOVR        IFEQ      *OFF
     C                   WRITE     #RECORD0
     C                   ENDIF
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     #RECORD1
     C                   EXSR      $PMCLR
      *
     C     *INKC         IFEQ      *OFF
     C     *INKL         ANDEQ     *OFF
     C                   EXSR      $UPDAT
     C                   ENDIF
      *
     CSR   #DSPLY        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * UPDATE INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UPDAT        BEGSR
      *
     C     *LIKE         DEFINE    APP110        SAV110
      *
     C                   MOVE      APP110        SAV110
     C     ZZUSR         CHAIN     APP110R                            99
     C                   MOVE      SAV110        APP110
      *
     C                   MOVE      UDATE         @CFDAT
     C                   MOVEL(P)  '*MDY'        @CFFMT
     C                   MOVEL(P)  '*YMD'        @CTFMT
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        AIUPDD
     C                   DUMP(a)
      *
     C                   UPDATE    APP110R
      *
     CSR   #UPDAT        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Clear program message queue.
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
      *
     CSR   #PMCLR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      ZZPGM         TOPGM
     C                   MOVE      *OFF          PUTOVR            1
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     CSR   #DEFN         ENDSR
