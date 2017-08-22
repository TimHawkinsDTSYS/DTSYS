      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Miscellaneous prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * ValidName() -- Validate name.
      *
     D ValidName       PR                  like(StdInd)
     D  ObjNam                             like(StdNam) const
      * ---------------------------------------------------------
      * ChkHKfld() -- Check for housekeeping field.
      *
     D ChkHKfld        PR                  like(StdInd)
     D  DbfNam                             like(StdNam) const
     D  FldNam                             like(StdNam) const
