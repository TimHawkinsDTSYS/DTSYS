      /TITLE Retrieve Message
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves a message (generally text and sev)
      *              using API's rather than use a CL program for
      *              performance.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  03/30/96  TimH        New program to retrieve message text
      *                         for performance.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     D MSGINF          DS          4000
     D  MSLRTN                 1      4B 0
     D  MSLAVL                 5      8B 0
     D  MSGSEV                 9     12B 0
     D  ALRIDX                13     16B 0
     D  ALROPT                17     25
     D  LOGIND                26     26
     D  RESV01                27     28
     D  MSRRTN                29     32B 0
     D  MSRAVL                33     36B 0
     D  MSMRTN                37     40B 0
     D  MSMAVL                41     44B 0
     D  MSHRTN                45     48B 0
     D  MSHAVL                49     52B 0
      *
     D INZDS           DS
     D  MSGLEN                 1      4B 0 INZ(4000)
     D  MSDLEN                 5      8B 0 INZ(256)
      *
      /EJECT
     C                   EXSR      $PMRTV
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * RETRIEVE MESSAGE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMRTV        BEGSR
      *
     C     MSGF          IFEQ      *BLANKS                                      RETRIEVE
     C     *DTAARA       DEFINE    USRMSGF       WK010A           10             MESSAGE
     C                   IN        WK010A                                        FILE NAME.
     C                   MOVE      WK010A        MSGF
     C                   ENDIF
      *
     C                   MOVEL     MSGF          MSGFLI
     C     MSGFLB        IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       MSGFLB
     C                   ENDIF
     C                   MOVE      MSGFLB        MSGFLI
      *
     C                   CALL      'QMHRTVM'                            98
     C                   PARM                    MSGINF
     C                   PARM                    MSGLEN
     C                   PARM      'RTVM0200'    FMTNAM            8
     C                   PARM                    MSGID
     C                   PARM                    MSGFLI           20
     C                   PARM                    MSGDTA
     C                   PARM                    MSDLEN
     C                   PARM      '*YES'        RPLSUB           10
     C                   PARM      '*NO'         RTNFMT           10
     C                   PARM      *LOVAL        ERRCDE            4
      *
     C     *IN98         IFEQ      *ON
     C     MSLAVL        OREQ      *ZERO
     C                   CLEAR                   MSGID
     C                   CLEAR                   MSG
     C                   RETURN
     C                   ENDIF
      *
     C                   Z-ADD     53            STR               5 0          DFT VAL
     C                   Z-ADD     30            LEN               5 0
     C     MSRRTN        IFLT      LEN
     C                   Z-ADD     MSRRTN        LEN
     C                   ENDIF
     C     STR           IFGT      *ZERO
     C     LEN           ANDGT     *ZERO
     C     LEN           SUBST(P)  MSGINF:STR    MSGDFT           30
     C                   ENDIF
      *
     C                   ADD       MSRRTN        STR                            MSG
     C                   Z-ADD     100           LEN
     C     MSMRTN        IFLT      LEN
     C                   Z-ADD     MSMRTN        LEN
     C                   ENDIF
     C     STR           IFGT      *ZERO
     C     LEN           ANDGT     *ZERO
     C     LEN           SUBST(P)  MSGINF:STR    MSG
     C                   ENDIF
      *
     C                   ADD       MSMRTN        STR                            SECLVL
     C                   Z-ADD     250           LEN
     C     MSHRTN        IFLT      LEN
     C                   Z-ADD     MSHRTN        LEN
     C                   Z-ADD     MSHRTN        SECLEN
     C                   ENDIF
     C     STR           IFGT      *ZERO
     C     LEN           ANDGT     *ZERO
     C     LEN           SUBST(P)  MSGINF:STR    SECLVL
     C                   ENDIF
      *
     C                   Z-ADD     MSGSEV        SEV
      *
     CSR   #PMRTV        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE PROGRAM VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   Y                 5 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          256
     C                   PARM                    MSG             100
     C                   PARM                    SECLVL          250
     C                   PARM                    SECLEN            5 0
     C                   PARM                    SEV               2 0
     C                   PARM                    MSGF             10
     C                   PARM                    MSGFLB           10
      *
     CSR   #INZSR        ENDSR
