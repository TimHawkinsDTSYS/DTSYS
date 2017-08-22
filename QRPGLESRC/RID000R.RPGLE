      /TITLE Retrieve IFS Directory
      *PARMS DFTACTGRP(*NO) ACTGRP(*NEW) OPTION(*NOXREF) USRPRF(*OWNER)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves directory information from the
      *              specified directory.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  10/10/98  TimH        New program to retrieve record format
      *                         information for the specified file.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     Fsplf132   uf   E             disk
      *
     D objdta          s                   like(spldta)
     D strpos          s              5  0 inz
     D DirLen          s              5  0 inz
     D StrObj          s              5  0 inz
      * ---------------------------------------------------------
      *
      *    Clear workfields.                                                  */
      *
     C                   clear                   WkDir
     C                   clear                   WkObj
     C                   clear                   WkObjType
      * ---------------------------------------------------------
      *
      *    Read file looking for 'Display Attributes'.                        */
      *
     C                   if        rel = '*FIRST' or
     C                             rel = '*NEXT'
     C                   dou       %scan('Display Attr':spldta) > *zero
     C                   read      splf132r
     C                   exsr      $ChkEOF
     C                   delete    splf132r
     C                   enddo
     C                   endif
      * ---------------------------------------------------------
      *
      *    Read file looking for 'Object . . . .'.                            */
      *
     C                   dou       %scan('Object . . .':spldta) > *zero
     C                   read      splf132r
     C                   eval      objdta = spldta
     C                   exsr      $ChkEOF
     C                   delete    splf132r
     C                   enddo
      * ---------------------------------------------------------
      *
      *    Read file looking for 'Type . . . .'.                              */
      *
     C                   dou       %scan('Type . . .':spldta) > *zero
     C                   read      splf132r
     C                   exsr      $ChkEOF
     C                   delete    splf132r
     C                   enddo
      *
/*    *    Extract object type.                                               */
      *
     C                   eval      WkObjType = '*' + %subst(spldta:45)
      * ---------------------------------------------------------
      *
      *    If object name has '>', read until 'truncated lines' + 1.          */
      *
     C                   if        %scan('>':objdta) > *zero
     C                   dou       %scan('truncated lines':spldta) > *zero
     C                   read      splf132r
     C                   exsr      $ChkEOF
     C                   delete    splf132r
     C                   enddo
      *
     C                   read      splf132r
     C                   eval      objdta = spldta
     C                   exsr      $ChkEOF
     C                   delete    splf132r
     C                   endif
      * ---------------------------------------------------------
      *
/*    *    Extract directory.                                                 */
      *
     C                   eval      DirLen = %len(%trim(dir))
     C                   eval      strpos = %scan(%trim(dir):objdta)
     C                   eval      WkDir  = %subst(objdta:strpos:DirLen)
      *
/*    *    Extract object.                                                    */
      *
     C                   eval      StrObj = strpos + dirlen + 1
     C                   eval      WkObj  = %subst(objdta:StrObj)
      * ---------------------------------------------------------
      *
      *    Read file looking for 'Hard links' to assure end of object.        */
      *
     C                   dou       %scan('Hard Links':spldta) > *zero
     C                   read      splf132r
     C                   exsr      $ChkEOF
     C                   delete    splf132r
     C                   enddo
      *
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check EOF.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChkEOF       BEGSR
      *
     C                   if        %eof
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      *
     C                   if        %scan('Hard Links':spldta) > *zero
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      *
     CSR   #ChkEOF       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *ENTRY        PLIST
     C                   parm                    dir            5000
     C                   parm                    rel              10
     C                   parm                    WkDir          5000
     C                   parm                    WkObj           256
     C                   parm                    WkObjType        10
      *
     CSR   #Define       ENDSR
