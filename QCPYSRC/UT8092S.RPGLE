      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Calendar prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  PrvBusDay() -- Fetch previous business day.
      *
     D PrvBusDay       PR                  like(NumISO)
     D  CurBusDay                          like(NumISO) const
      * ---------------------------------------------------------
      *  NxtBusDay() -- Fetch next business day.
      *
     D NxtBusDay       PR                  like(NumISO)
     D  CurBusDay                          like(NumISO) const
      * ---------------------------------------------------------
      * StdBusHrs() - Standard business hours.
      *
     D StdBusHrs       PR                  like(StdInd)
     D  DepNam                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  DteToChk                           like(NumISO) const
     D                                     options(*nopass)
