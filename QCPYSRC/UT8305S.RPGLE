      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Seat assignment prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      * SetSeatAssign() -- Set seat assignments.
      *
     D SetSeatAssign   PR                  like(dfnBAseat)
     D  i_seat                             like(dfnAYseat) dim(20) const
      *
     D dfnAYseat       s              5    based(StdNulPtr)
      * ---------------------------------------------------------
      *
      * ExtSeatAssign() -- Extract seat assignments.
      *
     D ExtSeatAssign   PR                  like(dfnAYseat) dim(20)
     D  i_seat                             like(dfnBAseat) const
     D  i_options                          like(StdStr) const
     D                                     options(*nopass)
