      /TITLE Extract Source Changes
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
     Fsrcmbr    ip   f  112        disk
     Foutmbr    o  a f  112        disk
      *
     D wrtrec          s                   like(StdInd) inz
     D result          s                   like(StdCnt) inz
     D SVtitle         s                   like(srcdta) inz
     D SVsource        s                   like(srcdta) inz
      *
      /copy qcpysrc,Dspec
      *
     Isrcmbr    ns  01
     I                                  1    6  srcseq
     I                                  7   12  srcdte
     I                                 18   18  srctyp
     I                                 13  112  srcdta
      *
     C                   if         comonl = '*YES'  and
     C                             (srctyp = 'f'     or
     C                              srctyp = 'F'     or
     C                              srctyp = 'd'     or
     C                              srctyp = 'D'     or
     C                              srctyp = 'i'     or
     C                              srctyp = 'i'     or
     C                              srctyp = 'c'     or
     C                              srctyp = 'C')
     C                   eval      *inLR   = *on
š1e€ C                   else
      *
     C                   if        %scan('/TITLE':srcdta) > *zero
     C                   eval      SVtitle = srcdta
š1e€ C                   endif
      *
š1b€ C                   if        srcdte >= frmdat  and
     C                             srcdte <= todat
      *
     C                   if        SVtitle <> *blanks
     C                   eval      SVsource = srcdta
     C                   eval      srcdta   = SVtitle
     C                   eval      SVtitle  = *blanks
     C                   except    #outrc
     C                   eval      srcdta   = SVsource
š1e€ C                   endif
      *
     C                   eval      wrtrec = *on
     C                   except    #outrc
š1e€ C                   endif
š1e€ C                   endif
      *
š1b€ CLR                 if        wrtrec
     CLR                 eval      srcseq = *zero
     CLR                 eval      srcdte = *zero
     CLR                 eval      srcdta = *blanks
     CLR                 except    #outrc
     CLR                 except    #outrc
š1e€ CLR                 endif
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
     C                   parm                    frmdat            6
     C                   parm                    todat             6
     C                   parm                    comonl            4
      *
     CSR   #defn         endsr
      *
     Ooutmbr    eadd         #outrc
     O                       srcseq            +  0
     O                       srcdte            +  0
     O                       srcdta            +  0
