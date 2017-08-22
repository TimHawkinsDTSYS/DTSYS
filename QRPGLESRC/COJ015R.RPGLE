      /TITLE Create Object, Replace non-%keyword entries.                     */
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *         */
      *PARMS OPTION(*NOXREF)
      *                                                                       */
      * Synopsis: Scans thru the source record, replacing %keyword            */
      *            entries like %objlib with the proper value.                */
      *                                                                       */
      * Created: TimH  07/07/93                                               */
      *                                                                       */
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *         */
      * M: Modifications --                                                   */
      *                                                                       */
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
      *                                                                       */
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *         */
      *
      *copy qcpysrc,Hspec
      *
     H datfmt(*ISO)
      *
     D coj000        e ds                  extname(coj000p)
      *
     D objnam          s                   like(Stdnam)
     D srcfile         s                   like(Stdnam)
     D srclib          s                   like(Stdnam)
     D srcmbr          s                   like(Stdnam)
     D srctxt          s                   like(Stdtxt)
     D objlib          s                   like(Stdnam)
     D objlibovr       s                   like(Stdnam)
      *
     D DteISO          S                   like(StdDat) inz
     D NumISO          S              8  0              inz
     D Found           s                   like(StdInd) inz
      *
      /copy qcpysrc,StdTypD
      *
     C                   dou       not Found
     C                   exsr      $NonKeyword
     C                   enddo
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Non-keyword.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $NonKeyword   BEGSR
      *
     C                   eval      found  = *off
      *
      *    Scan for source file.
      *
š2b€ C                   if        %scan('%SRCFILE':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(srcfile):srcdta:
     C                                      %scan('%SRCFILE':srcdta):8)
š2e€ C                   endif
      *
      *    Scan for source library.
      *
š2b€ C                   if        %scan('%SRCLIB':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(srclib):srcdta:
     C                                      %scan('%SRCLIB':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for source member.
      *
š2b€ C                   if        %scan('%SRCMBR':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(srcmbr):srcdta:
     C                                      %scan('%SRCMBR':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for object library.
      *
š2b€ C                   if        %scan('%OBJLIB':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(objlib):srcdta:
     C                                      %scan('%OBJLIB':srcdta):7)
š2e€ C                   endif
      *
š2b€ C                   if        %scan('*DFT':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(objlib):srcdta:
     C                                      %scan('*DFT':srcdta):4)
š2e€ C                   endif
      *
      *    Scan for program library.
      *
š2b€ C                   if        %scan('%PGMLIB':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(CLpgmlib):srcdta:
     C                                      %scan('%PGMLIB':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for data library.
      *
š2b€ C                   if        %scan('%DTALIB':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(CLdtalib):srcdta:
     C                                      %scan('%DTALIB':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for operations library.
      *
š2b€ C                   if        %scan('%OPSLIB':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(CLopslib):srcdta:
     C                                      %scan('%OPSLIB':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for system library.
      *
š2b€ C                   if        %scan('%SYSLIB':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(CLsyslib):srcdta:
     C                                      %scan('%SYSLIB':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for object name.
      *
š2b€ C                   if        %scan('%OBJNAM':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(objnam):srcdta:
     C                                      %scan('%OBJNAM':srcdta):7)
š2e€ C                   endif
      *
      *    Scan for text.
      *
š2b€ C                   if        %scan('%TEXT':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta = %replace(%trim(srctxt):srcdta:
     C                                      %scan('%TEXT':srcdta):5)
š2e€ C                   endif
      *
      *    Scan for current_date.
      *
š2b€ C                   if        %scan('%CURRENT_DATE':srcdta) > *zero
     C                   eval      found  = *on
     C                   eval      srcdta =
     C                             %replace(%editc(NumISO:'Z'):
     C                             srcdta:
     C                             %scan('%CURRENT_DATE':srcdta):13)
š2e€ C                   endif
      *
     CSR   #NonKeyword   ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C     *usa          move      *date         DteISO
     C                   movel     DteISO        NumISO
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    OBJNAM
     C                   PARM                    SRCFILE
     C                   PARM                    SRCLIB
     C                   PARM                    SRCMBR
     C                   PARM                    srctxt
     C                   PARM                    OBJLIB
     C                   PARM                    coj000
     C                   PARM                    SRCDTA           80
     C                   PARM                    OBJLIBOVR
      *
     CSR   #DEFN         ENDSR
