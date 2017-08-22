      /TITLE Create Object, Replace %keyword entries.                         */
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
     D coj000        e ds                  extname(coj000p)
      *
     D objnam          s                   like(Stdnam)
     D srcfile         s                   like(Stdnam)
     D srclib          s                   like(Stdnam)
     D srcmbr          s                   like(Stdnam)
     D srctxt          s                   like(Stdtxt)
     D objlib          s                   like(Stdnam)
     D objlibovr       s                   like(Stdnam)
     D Found           s                   like(StdInd) inz
      *
      /copy qcpysrc,StdTypD
      *
     C                   dou       not Found
     C                   exsr      $Keyword
     C                   enddo
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Keyword.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Keyword      BEGSR
      *
     C                   eval      found     = *off
      *
      *    Scan for program library.
      *
š2b€ C                   if        %scan('OBJLIB(%PGMLIB)':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:
     C                             %scan('OBJLIB(%PGMLIB)':srcdta):15)
     C                   eval      objlibovr = CLpgmlib
     C                   eval      found     = *on
     C                   leavesr
š2e€ C                   endif
      *
      *    Scan for data library.
      *
š2b€ C                   if        %scan('OBJLIB(%DTALIB)':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:
     C                             %scan('OBJLIB(%DTALIB)':srcdta):15)
     C                   eval      objlibovr = CLdtalib
     C                   eval      found     = *on
     C                   leavesr
š2e€ C                   endif
      *
      *    Scan for operations library.
      *
š2b€ C                   if        %scan('OBJLIB(%OPSLIB)':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:
     C                             %scan('OBJLIB(%OPSLIB)':srcdta):15)
     C                   eval      objlibovr = CLopslib
     C                   eval      found     = *on
     C                   leavesr
š2e€ C                   endif
      *
      *    Scan for system library.
      *
š2b€ C                   if        %scan('OBJLIB(%SYSLIB)':srcdta) > *zero
     C                   eval      srcdta = %replace('':srcdta:
     C                             %scan('OBJLIB(%SYSLIB)':srcdta):15)
     C                   eval      objlibovr = CLsyslib
     C                   eval      found     = *on
     C                   leavesr
š2e€ C                   endif
      *
      *    Scan for text.
      *
š2b€ C                   if        %scan('TEXT(%TEXT)':srcdta) > *zero
     C                   eval      srcdta = %replace(%trim(SrcTxt):srcdta:
     C                             %scan('TEXT(%TEXT)':srcdta):11)
     C                   eval      found     = *on
     C                   leavesr
š2e€ C                   endif
      *
     CSR   #Keyword      ENDSR
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
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    OBJNAM
     C                   PARM                    SRCFILE
     C                   PARM                    SRCLIB
     C                   PARM                    SRCMBR
     C                   PARM                    SrcTxt
     C                   PARM                    OBJLIB
     C                   PARM                    coj000
     C                   PARM                    SRCDTA           80
     C                   PARM                    OBJLIBOVR
      *
     CSR   #DEFN         ENDSR
