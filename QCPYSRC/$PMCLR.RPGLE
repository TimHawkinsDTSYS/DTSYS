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
     C                   CALL(e)   'QMHRMVPM'
     C                   PARM                    TOPGM            10
     C                   PARM                    PGMSTK            4
     C                   PARM      *BLANKS       MSGKEY            4
     C                   PARM      '*ALL'        RMVOPT           10
     C                   PARM      *LOVAL        RTNCDE            4
      *
     C                   MOVE      *BLANKS       TOREL            10
      *
      *    Check for record locks.
      *
     C                   eval      msgid = ExecCmd('chkrcdlck')
     C                   if        msgid <> *blanks
     C                   eval      msgid = 'GNL0004'
     C                   exsr      $PMsnd
     C                   eval      msgid =
     C                             ExecCmd('DSPJOB OUTPUT(*PRINT) +
     C                                             OPTION(*PGMSTK)')
     C                   eval      msgid =
     C                             ExecCmd('DSPJOB OUTPUT(*PRINT) +
     C                                             OPTION(*JOBLCK)')
     C                   endif
      *
     CSR   #PMCLR        ENDSR
