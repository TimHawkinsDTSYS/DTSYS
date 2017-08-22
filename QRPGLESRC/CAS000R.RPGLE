      /TITLE Change Application Status
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  01/08/97  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *
     FAPP010P   UF   E           K DISK
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      *
     C                   EXSR      $ChgAppSts
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Change application status.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChgAppSts    BEGSR
      *
     C     ADAPCD        CHAIN     APP010R                            LR
     C     *INLR         IFEQ      *OFF
     C     STATUS        IFEQ      '*AVAIL'
     C                   CLEAR                   ADLOCK
     C                   CLEAR                   ADLCKTXT
     C                   ELSE
     C                   MOVE      'Y'           ADLOCK
     C                   MOVE      LCKTXT        ADLCKTXT
     C                   ENDIF
     C                   UPDATE    APP010R
     C                   ENDIF
      *
     CSR   #ChgAppSts    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ADAPCD
     C                   PARM                    STATUS           10
     C                   PARM                    LCKTXT
      *
     C     *LIKE         DEFINE    ADLCKTXT      LCKTXT
      *
     CSR   #DEFN         ENDSR
