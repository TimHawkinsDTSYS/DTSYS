      /TITLE Sort DDS Member
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * T: Sort DDS Member
      *
      * P: PARMS
      *
      * S: Sorts the specified DDS source member in alphabetical
      * S:  order to assist in locating database elements.
      * S:  The source member would generally be a reference
      * S:  file PF source.
      *
      * C: THAWKINS  07/07/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
     H dftactgrp(*NO)
     H enbpfrcol(*FULL)
     H alwnull(*USRCTL)
     H*bnddir('TTBNDDIR')
     H option(*NOXREF:*SRCSTMT:*NODEBUGIO)
      *
     FQDDSSRC   IF   E             DISK    rename(qddssrc:qddssrcr)
     FSDM010P   O    E             DISK
      *
     D x               s             10i 0                inz
     D PVfieldnam      s                   like(fieldnam) inz
      *
      *    Write out all of the top comment lines including the record name.
      *
     C                   read      qddssrcR
     C                   dow       %eof = *off
     C                   eval      fieldseq += 1
     C                   write     SDM010R
      *
     C                   if        %subst(srcdta:17:1) = 'R'
     C                   leave
     C                   endif
      *
     C                   read      qddssrcR
     C                   enddo
      *
      *    Write out the rest of the file.
      *
     C                   read      qddssrcR
     C                   dow       %eof = *off
     C                   if        %subst(srcdta:7:1) <> '*'
     C                   exsr      $write
     C                   endif
      *
     C                   read      qddssrcR
     C                   enddo
      *
     C                   eval      *inLR = *on
      * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Write into workfile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Write        BEGSR
      *
     C                   if        %subst(srcdta:19:10) <> *blanks
     C                   eval      fieldnam = %subst(srcdta:19:10)
      *
     C                   for       x = 1 to 10
     C                   if        %subst(fieldnam:x) >= 'A' and
     C                             %subst(fieldnam:x) <= 'Z' or
     C                             %subst(fieldnam:x) >= '0' and
     C                             %subst(fieldnam:x) <= '9'
     C                   eval      fieldnam1 = %subst(fieldnam:x)
     C                   leave
     C                   endif
      *
     C                   endfor
     C                   endif
      *
     C                   if        fieldnam <> pvfieldnam
     C                   move      fieldnam      pvfieldnam
     C                   eval      fieldseq = *zero
     C                   endif
      *
     C                   eval      fieldseq += 1
     C                   write     SDM010R
      *
     CSR   #Write        ENDSR
