      /TITLE Utility, Miscellaneous (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * ValidName() - Validate name.
      ***********************************************************
     P ValidName       B                   Export
      *
     D ValidName       PI                  like(StdInd)
     D  ObjNam                             like(StdNam) const
      *
     D numb            c                   const('0123456789')
     D x               s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *    Return if object name is blank.
      *
     C                   if        ObjNam = *blanks
     C                   return    *off
     C                   endif
      *
      *    Check first character.
      *     for:  $, #, @, or A through Z.
      *
     C                   if        %subst(ObjNam:1:1) <> '$' and
     C                             %subst(ObjNam:1:1) <> '#' and
     C                             %subst(ObjNam:1:1) <> '@' and
     C                             %scan(%subst(ObjNam:1:1):uppr) = *zero
     C                   return    *off
     C                   endif
      *
      *    Check remaining characters.
      *     for:  $, #, @, or A through Z,
      *     0 through 9, or underscore (_).
      *
     C                   do        9             x
     C                   if        %subst(ObjNam:x:1) <> ' ' and
     C                             %subst(ObjNam:x:1) <> '$' and
     C                             %subst(ObjNam:x:1) <> '#' and
     C                             %subst(ObjNam:x:1) <> '@' and
     C                             %subst(ObjNam:x:1) <> '_' and
     C                             %scan(%subst(ObjNam:x:1):numb) = *zero and
     C                             %scan(%subst(ObjNam:x:1):uppr) = *zero
     C                   return    *off
     C                   endif
     C                   enddo
      *
      *    Check for imbeded blanks.
      *
     C                   if        %len(%trim(ObjNam)) <>
     C                             %len(%trim(CompressString(ObjNam)))
     C                   return    *off
     C                   endif
      *
     C                   return    *on
      *
     P ValidName       E
      ***********************************************************
      * ChkHKfld() - Check for housekeeping field.
      ***********************************************************
     P ChkHKfld        B                   Export
      *
     D ChkHKfld        PI                  like(StdInd)
     D  FilNam                             like(StdNam) const
     D  FldNam                             like(StdNam) const
      *
     D  RtnInd         s                   like(StdInd) inz
     D  PLfilnam       s                   like(StdNam) inz
     D  PLfldnam       s                   like(StdNam) inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
š1b€ C                   if        FilNam = *blanks or
š1b€ C                             FldNam = *blanks
     C                   return    *off
š1e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Check for housekeeping field.
      *
     C                   call      'FH0800R'
     C                   parm      FilNam        PLfilnam
     C                   parm      FldNam        PLfldnam
     C                   parm      *off          RtnInd
      *
     C                   return    RtnInd
      *
     P ChkHKfld        E
