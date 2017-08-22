      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PRINT REMARKS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PRTRM        BEGSR
      *
     C                   MOVE      RMMQ          MSGQ
     C                   MOVE      RMMQLB        MSGQLB
     C                   MOVEL(P)  '*NEXT'       MSGTYP
     C                   MOVEL(P)  '*TOP'        MSGKEY
     C                   MOVEL(P)  '*YES'        RMVMSG
     C                   MOVEL(P)  '0'           WAIT
      *
     C     MSGID         DOUEQ     *BLANKS
     C                   EXSR      $CKHDG                                       Check headings
     C                   EXSR      $PMRMQ                                       Receive message
     C     MSGID         IFNE      *BLANKS
     C                   MOVEL     MSG           RWTEXT
     C                   EXCEPT    #RMK01                                       Print message
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #PRTRM        ENDSR
