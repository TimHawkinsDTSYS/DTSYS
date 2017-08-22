      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Delete User Space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DltUsrSpc    BEGSR
      *
      *    Default to library list.
      *
     C     USspclib      ifeq      *blanks                                      AIR
     C                   eval      USspclib = '*LIBL'
     C                   endif
      *
      *    Define space name and library.
      *
     C                   move      USspcnam      USspcnam         10
     C                   move      USspclib      USspclib         10
      *
      *    Setup qualified name.
      *
     C                   movel     USspcnam      USspcnam20
     C                   move      USspclib      USspcnam20
      *
      *    Delete user space.
      *
     C                   call      'QUSDLTUS'                                   ADJUSTMENTS
     C                   parm                    USspcnam20       20
     C                   parm      x'00000000'   USerrcde          4
      *
     CSR   #DltUsrSpc    ENDSR
