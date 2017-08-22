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
     FSDM010P   IP   E           K DISK
     FQDDSSRC   O    E             DISK    rename(qddssrc:qddssrcr)
      *
     D SVsrcdta        s                   like(srcdta) inz
      *
     ISDM010R
     I                                          FIELDNAM1     L1
      *
     C                   if        *inL1        and
     C                             fieldnam1 <> *blanks
     C                   eval      SVsrcdta = srcdta
     C                   eval      srcdta = '     A*' + fieldnam1
     C                   write     qddssrcr
     C                   eval      srcdta = SVsrcdta
     C                   endif
      *
     C                   write     qddssrcr
