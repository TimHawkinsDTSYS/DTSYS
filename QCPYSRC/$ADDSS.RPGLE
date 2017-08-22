0002 F* * * * * * * * * * * * * * * * * * * * * * * * * * *
0003 F*  ADD X SECONDS TO A GIVEN DATE/TIME.
0004 F* * * * * * * * * * * * * * * * * * * * * * * * * * *
0005 CSR   $ADDSS        BEGSR
0006 C*
0007 C                   CALL      'UTL102R'
0008 C                   PARM                    @TBTIM            6
0009 C                   PARM                    @TBDAT            6
0010 C                   PARM                    @TBFMT           10
0011 C                   PARM                    @TSECS            5 0
0012 C                   PARM                    @TETIM            6
0013 C                   PARM                    @TEDAT            6
0014 C                   PARM                    @TEFMT           10
0015 C*
0016 CSR   #ADDSS        ENDSR
