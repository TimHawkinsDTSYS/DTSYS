      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Standard RPG "H" Specifications for SrvPgm
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
     H nomain
     H datfmt(*USA)
     H enbpfrcol(*FULL)
     H alwnull(*USRCTL)
      *
      /if not defined(Hspec_DATETIME)
     H cvtopt(*DATETIME)
      /endif
      *
     H bnddir('TSBNDDIR':'QC2LE')
     H option(*NOXREF:*SRCSTMT:*NODEBUGIO)
