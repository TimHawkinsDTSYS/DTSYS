      /TITLE Extract Source for a String
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
     D comment         s                   like(srcdta) inz('      *')
      *
      /copy qcpysrc,Dspec
      *
     Isrcmbr    ns  01
     I                                  1    6  srcseq
     I                                  7   12  srcdte
     I                                 13  112  srcdta
      *
     C                   if        %scan('/TITLE':srcdta) > *zero
     C                   eval      SVtitle = srcdta
š1e€ C                   endif
      *
     C                   if        wrtrec   and
     C                             srcdta = comment
     C                   eval      *inLR  = *on
š1e€ C                   else
      *
     C                   if        wrtrec     or
š1b€ C                             %scan(%trim(string):srcdta) > *zero
      *
     C                   if        SVtitle <> *blanks
     C                   eval      SVsource = srcdta
     C                   eval      srcdta   = SVtitle
     C                   eval      SVtitle  = *blanks
     C                   except    #outrc
     C                   eval      srcseq = *zero
     C                   eval      srcdte = *zero
     C                   eval      srcdta = comment
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
     C                   parm                    string           50
      *
     CSR   #defn         endsr
      *
     Ooutmbr    eadd         #outrc
     O                       srcseq            +  0
     O                       srcdte            +  0
     O                       srcdta            +  0
