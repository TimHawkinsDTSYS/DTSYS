      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Postal code prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *
      *  MskPstCde() -- Mask postal code.
      *
     D MskPstCde       PR                  like(dfnPApscd)
     D  PstCde                             like(dfnPApscd)   value
     D  Cntry                              like(dfnPActry)   value
      * ---------------------------------------------------------
      *
      *  ChkPstCde() -- Check postal code.
      *
     D ChkPstCde       PR                  like(msgid)
     D  PstCde                             like(dfnPApscd)   value
     D  Cntry                              like(dfnPActry)   value
