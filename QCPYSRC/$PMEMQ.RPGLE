      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Empty a Message Queue.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMEMQ        BEGSR
      *
     C     *like         define    StdNam        msgq
     C     *like         define    StdNam        msgqlb
      *
     C                   eval      p_msgq = msgq + msgqlb
      *
     C                   CALL(e)   'QMHRMVM'
     C                   PARM                    p_msgq           20
     C                   PARM      *BLANKS       MSGKEY            4
     C                   PARM      '*ALL'        RMVOPT           10
     C                   PARM      *LOVAL        RTNCDE            4
      *
     CSR   #PMEMQ        ENDSR
