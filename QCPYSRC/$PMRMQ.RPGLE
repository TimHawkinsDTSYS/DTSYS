      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Receive Non-Program Message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMRMQ        BEGSR
      *
     C                   if        MsgTyp  = *blanks
     C                   eval      MsgTyp  = '*ANY'
     C                   endif
      *
     C                   if        RmvMsg  = *blanks
     C                   eval      RmvMsg  = '*YES'
     C                   endif
      *
     C                   CALL(e)   'UT0170C'
     C                   PARM                    MSGQ             10
     C                   PARM                    MSGQLB           10
     C                   PARM                    MSGTYP           10
     C                   PARM                    MSGKEY            4
     C                   PARM                    RMVMSG           10
     C                   PARM                    WAIT             10
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA
     C                   PARM                    MSG
     C                   PARM                    SECLVL
     C                   PARM                    SEV               2 0
     C                   PARM                    MSGF             10
     C                   PARM                    MSGFLIB          10
     C                   PARM                    Sender           10
      *
     CSR   #PMRMQ        ENDSR
