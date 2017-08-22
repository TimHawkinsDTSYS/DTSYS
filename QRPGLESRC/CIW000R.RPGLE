      /TITLE Change IFS Ownership
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
      *
      * C: T.HAWKINS   07/08/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /copy qcpysrc,Hspec
      *
     D InpFile         s                   like(StdStg)
     D InpBgnDir       s                   like(StdStg)
     D InpUser         s                   like(StdNam)
     D InpOption       s                   like(StdNam)
     D error           s                   like(StdInd) inz
      *
      /copy qcpysrc,Dspec
      *
     C                   eval      error = ChgIFSown(InpFile:
     C                                               InpUser:
     C                                               InpBgnDir:
     C                                               InpOption)
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *entry        plist
     C                   parm                    InpFile
     C                   parm                    InpUser
     C                   parm                    InpBgnDir
     C                   parm                    InpOption
      *
     CSR   #Define       ENDSR
