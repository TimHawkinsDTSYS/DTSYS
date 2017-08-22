      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Move messages from one program queue to another.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMMOV        BEGSR
      *
     C     *like         define    FMrel         savFMrel
     C     *like         define    TOrel         savTOrel
     C     *like         define    msgtyp        PVmsgtyp
      *
     C                   move      FMrel         savFMrel
     C                   move      TOrel         savTOrel
      *
     C                   eval      MsgKey   = *blanks
     C                   eval      PVmsgtyp = msgtyp
     C                   eval      msgtyp   = '*ANY'
     C                   exsr      $PMrcv
     C                   eval      msgtyp   = PVmsgtyp
      *
     C                   dow       msgid <> *blanks
     C                   exsr      $PMsnd
     C                   eval      MsgKey = *blanks
     C                   eval      FMrel  = savFMrel
     C                   eval      TOrel  = savTOrel
     C                   exsr      $PMRCV
      *
     C                   if        msgid = 'CPF2479'
     C                   leave
     C                   endif
     C                   enddo
      *
     C                   eval      FMrel  = *blanks
     C                   eval      TOrel  = *blanks
      *
     CSR   #PMMOV        ENDSR
