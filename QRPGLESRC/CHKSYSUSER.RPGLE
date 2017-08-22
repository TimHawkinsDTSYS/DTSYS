      /TITLE Scan source
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      * Synopsis:
      *
      * Created: TimH  07/07/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: Modifications --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,Hspec
      *
     Fsysctp01  ip   e             disk
     Fqclsrc    if   f  112        disk    usropn
     Fqcmdsrc   if   f  112        disk    usropn
     Fqcpysrc   if   f  112        disk    usropn
     Fqddssrc   if   f  112        disk    usropn
     Fqrpglesrc if   f  112        disk    usropn
     Fquimsrc   if   f  112        disk    usropn
      *
     D count           s                   like(StdInt) inz
      *
      /copy qcpysrc,Dspec
      *
     Iqclsrc    ns
     I                                  1  112  srcdta
      *
     Iqcmdsrc   ns
     I                                  1  112  srcdta
      *
     Iqcpysrc   ns
     I                                  1  112  srcdta
      *
     Iqddssrc   ns
     I                                  1  112  srcdta
      *
     Iqrpglesrc ns
     I                                  1  112  srcdta
      *
     Iquimsrc   ns
     I                                  1  112  srcdta
      *
š1b€ C                   eval      count = *zero
      *
     C                   exsr      $CntCLP
     C                   exsr      $CntCMD
     C                   exsr      $CntCPY
     C                   exsr      $CntDDS
     C                   exsr      $CntRPG
     C                   exsr      $CntUIM
      *
š1b€ C                   if        count <= 1
     C                   eval      msgid  = 'ITN0029'
     C                   eval      msgdta = SCcat + SCsub
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   endif
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Count CLP source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CntCLP       begsr
      *
     C                   open      qclsrc
     C                   read      qclsrc
      *
š1b€ C                   dow       not %eof
š1b€ C                   if        %scan(%trim(SCcat):srcdta) > *zero
     C                   eval      count += 1
     C                   endif
     C                   read      qclsrc
     C                   enddo
      *
     C                   close     qclsrc
      *
     Csr   #CntCLP       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Count CMD source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CntCMD       begsr
      *
     C                   open      qcmdsrc
     C                   read      qcmdsrc
      *
š1b€ C                   dow       not %eof
š1b€ C                   if        %scan(%trim(SCcat):srcdta) > *zero
     C                   eval      count += 1
     C                   endif
     C                   read      qcmdsrc
     C                   enddo
      *
     C                   close     qcmdsrc
      *
     Csr   #CntCMD       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Count CPY source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CntCPY       begsr
      *
     C                   open      qcpysrc
     C                   read      qcpysrc
      *
š1b€ C                   dow       not %eof
š1b€ C                   if        %scan(%trim(SCcat):srcdta) > *zero
     C                   eval      count += 1
     C                   endif
     C                   read      qcpysrc
     C                   enddo
      *
     C                   close     qcpysrc
      *
     Csr   #CntCPY       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Count DDS source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CntDDS       begsr
      *
     C                   open      qddssrc
     C                   read      qddssrc
      *
š1b€ C                   dow       not %eof
š1b€ C                   if        %scan(%trim(SCcat):srcdta) > *zero
     C                   eval      count += 1
     C                   endif
     C                   read      qddssrc
     C                   enddo
      *
     C                   close     qddssrc
      *
     Csr   #CntDDS       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Count RPG source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CntRPG       begsr
      *
     C                   open      qrpglesrc
     C                   read      qrpglesrc
      *
š1b€ C                   dow       not %eof
š1b€ C                   if        %scan(%trim(SCcat):srcdta) > *zero
     C                   eval      count += 1
     C                   endif
     C                   read      qrpglesrc
     C                   enddo
      *
     C                   close     qrpglesrc
      *
     Csr   #CntRPG       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Count UIM source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CntUIM       begsr
      *
     C                   open      quimsrc
     C                   read      quimsrc
      *
š1b€ C                   dow       not %eof
š1b€ C                   if        %scan(%trim(SCcat):srcdta) > *zero
     C                   eval      count += 1
     C                   endif
     C                   read      quimsrc
     C                   enddo
      *
     C                   close     quimsrc
      *
     Csr   #CntUIM       endsr
      *
      /copy qcpysrc,$PMsnd
