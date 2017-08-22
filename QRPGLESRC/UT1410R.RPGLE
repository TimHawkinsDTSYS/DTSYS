      /TITLE Receive Program Message
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Receives a program message using the IBM
      *              API's rather than use a CL program for
      *              performance.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  03/30/96  TimH        New program to recieve messages for
      *                         performance (invoicing).
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     H DEBUG
      *
     D MSGINF          DS          6000
     D  MSLRTN                 1      4B 0
     D  MSLAVL                 5      8B 0
     D  MSGSEV                 9     12B 0
     D  MSGID                 13     19
     D  MSGTP                 20     21
     D  MSGKEY                22     25
     D  MSGF                  26     35
     D  MSGFLX                36     45
     D  MSGFLB                46     55
     D  SNDJOB                56     65
     D  SNDUSR                66     75
     D  SNDJNB                76     81
     D  SNDPGM                82     93
     D  SNDPIN                94     97
     D  DATSNT                98    104
     D  TIMSNT               105    110
     D  RCVPGM               111    120
     D  RCVPID               121    124
     D  SNDTYP               125    125
     D  RCVTYP               126    126
     D**                                    127 135 RSRV01
     D  ALROPT               136    144
     D**                                    145 152 RSRV02
     D  MSDRTN               153    156B 0
     D  MSDAVL               157    160B 0
     D  MSMRTN               161    164B 0
     D  MSMAVL               165    168B 0
     D  MSHRTN               169    172B 0
     D  MSHAVL               173    176B 0
      *
     D INZDS           DS
     D  MSGLEN                 1      4B 0 INZ(6000)
     D  MSGWAT                 9     12B 0 INZ(0)
      *
      /EJECT
     C                   EXSR      $PMRCV
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * RETRIEVE NON-PROGRAM MESSAGE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMRCV        BEGSR
      *
     C     *LIKE         DEFINE    MSGTYP        SAVTYP
     C                   MOVE      MSGTYP        SAVTYP
      *
     C     FMPGM         IFEQ      *BLANKS
     C                   MOVEL     '*'           FMPGM
     C                   ENDIF
      *
     C     FMREL         IFEQ      '*PRV'
     C                   MOVE      *LOVAL        FMPSTK
     C                   MOVE      X'01'         FMPSTK
     C                   ELSE
     C                   MOVE      *LOVAL        FMPSTK
     C                   ENDIF
      *
     C     MSGTYP        IFEQ      *BLANKS
     C                   MOVEL     '*ANY'        MSGTYP
     C                   ENDIF
      *
     C     MSGTYP        IFEQ      '*ANY'
     C                   CLEAR                   MSGKEY
     C                   ENDIF
      *
     C                   SELECT
     C     RMVMSG        WHENEQ    '*YES'
     C     RMVMSG        OREQ      *BLANKS
     C                   MOVEL(P)  '*REMOVE'     MSGACT
     C     RMVMSG        WHENEQ    '*NO'
     C                   MOVEL(P)  '*SAME'       MSGACT
     C     RMVMSG        WHENEQ    '*OLD'
     C                   MOVEL(P)  '*OLD'        MSGACT
     C                   ENDSL
      *
     C                   SELECT
     C     WAIT          WHENEQ    *BLANKS
     C                   Z-ADD     *ZERO         MSGWAT
     C     WAIT          WHENEQ    '*MAX'
     C                   Z-SUB     1             MSGWAT
     C                   OTHER
     C                   MOVE      WAIT          UNSSTR
     C                   EXSR      $USNUM
     C                   MOVE      UNSSTR        WK010N           10 0
     C                   Z-ADD     WK010N        MSGWAT
     C                   ENDSL
      *
     C                   CALL      'QMHRCVPM'                           98
     C                   PARM                    MSGINF
     C                   PARM                    MSGLEN
     C                   PARM      'RCVM0200'    FMTNAM            8
     C                   PARM                    FMPGM
     C                   PARM                    FMPSTK            4
     C                   PARM                    MSGTYP
     C                   PARM                    MSGKEY
     C                   PARM                    MSGWAT
     C                   PARM                    MSGACT           10
     C                   PARM      *LOVAL        ERRCDE            4
      *
     C     *IN98         IFEQ      *ON
     C     MSLAVL        OREQ      *ZERO
     C   98DUMP          IFEQ      *BLANKS
     C                   MOVE      *ON           DUMP              1
     C                   DUMP
     C                   ENDIF
     C                   CLEAR                   MSGID
     C                   CLEAR                   MSG
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVE      SAVTYP        MSGTYP
      *
     C                   Z-ADD     177           STR               5 0          MSGDTA
     C                   Z-ADD     256           LEN               5 0
     C     MSDRTN        IFLT      LEN
     C                   Z-ADD     MSDRTN        LEN
     C                   ENDIF
     C     STR           IFGT      *ZERO
     C     LEN           ANDGT     *ZERO
     C     LEN           SUBST(P)  MSGINF:STR    MSGDTA
     C                   ENDIF
      *
     C                   ADD       MSDRTN        STR                            MSG
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
     C                   ENDIF
     C     STR           IFGT      *ZERO
     C     LEN           ANDGT     *ZERO
     C     LEN           SUBST(P)  MSGINF:STR    SECLVL
     C                   ENDIF
      *
     C                   Z-ADD     MSGSEV        SEV
      *
     CSR   #PMRCV        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$USNUM
      /SPACE 3
      /COPY QCPYSRC,$JUSTR
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
     C                   PARM                    FMPGM            10
     C                   PARM                    FMREL            10
     C                   PARM                    MSGTYP           10
     C     MSGKEY        PARM      MSGKEY        PMKEY             4
     C                   PARM                    RMVMSG           10
     C                   PARM                    WAIT             10
     C                   PARM      MSGID         PMID              7
     C                   PARM                    MSGDTA          256
     C                   PARM                    MSG             100
     C                   PARM                    SECLVL          250
     C                   PARM                    SEV               2 0
     C                   PARM      MSGF          PMF              10
     C                   PARM      MSGFLB        PMFLB            10
      *
     CSR   #INZSR        ENDSR
