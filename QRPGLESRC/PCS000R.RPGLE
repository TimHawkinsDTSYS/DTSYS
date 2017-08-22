      /TITLE Print Character Sets
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      *
      * S: Prints the character sets (FNTCHRSET) in the specified
      * S:  library.
      *
      * C: TimH  07/07/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: Modifications --
      * M:
      * M: mm/dd/yy  programmer  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      * M:                        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      * M:                        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /copy qcpysrc,Hspec
      *
     FQADSPOBJ  ip   E             DISK
     FPCS000P   O    E             PRINTER infds(DSprt)
      *
      /copy qcpysrc,Dspec
      * ---------------------------------------------------------
      * Write headings.
      *
     C                   if        *inOF      or
     C                             Z3cln > Z3ofl
     C                   eval      *inOF = *off
     C                   write     #heading
     C                   endif
      * ---------------------------------------------------------
      * Write detail for each font.
      *
     C                   if        ODobat  = 'FNTCHRSET'
     C                   eval      FntChr  = ODobnm
     C                   eval      FntChrL = ODlbnm
     C                   write     #detail                              of
     C                   endif
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   eval      *inOF = *on
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    FntChrSet         8
     C                   PARM                    FntChrSetL       10
     C                   PARM                    CdePag            8
     C                   PARM                    CdePagLib        10
      *
     CSR   #Define       ENDSR
