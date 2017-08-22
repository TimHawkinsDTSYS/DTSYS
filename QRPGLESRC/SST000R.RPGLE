      /TITLE Set Source Title
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
      /copy qcpysrc,Hspec
      *
     Fsrcmbr    up   f  112        disk
      *
     D pos             s                   like(StdInt) inz
     D srctxt          s                   like(StdTxt)
      *
      /copy qcpysrc,Dspec
      *
     Isrcmbr    ns  01
     I                                  1    6  srcseq
     I                                  7   12  srcdte
     I                                 13  112  srcdta
      *
     C                   eval      pos = %scan('TITLE':srcdta)
     C                   if        pos > *zero
     C                   eval      %subst(srcdta:pos+6:50) = srctxt
š1e€ C                   except    #update
š1e€ C                   eval      *inLR = *on
š1e€ C                   endif
      *
     C                   eval      pos = %scan('/*T*':srcdta)
     C                   if        pos > *zero
     C                   eval      %subst(srcdta:pos+5:50) = srctxt
š1e€ C                   except    #update
š1e€ C                   eval      *inLR = *on
š1e€ C                   endif
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES/PARMS/KLIST.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $defn         begsr
      *
     C     *entry        plist
     C                   parm                    srctxt
      *
     CSR   #defn         endsr
      *
     Osrcmbr    e            #update
     O                       srcseq            +  0
     O                       srcdte            +  0
     O                       srcdta            +  0
