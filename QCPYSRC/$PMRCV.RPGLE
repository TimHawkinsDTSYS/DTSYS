      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Receive message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMRCV        BEGSR
      *
     C                   if        FMpgm = *blanks
     C                   eval      FMpgm = ZZpgm
     C                   endif
      *
     C                   CALL(e)   'UT0160C'
     C                   PARM                    fmpgm            10
     C                   PARM                    fmrel            10
     C                   PARM                    MsgTyp           10
     C                   PARM                    RmvMsg           10
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA
     C                   PARM                    MSG
     C                   PARM                    SECLVL
     C                   PARM                    SEV               2 0
     C                   PARM                    MSGF             10
     C                   PARM                    MSGFLIB          10
      *
     C                   eval      FMrel = *blanks
      *
     CSR   #PMRCV        ENDSR
