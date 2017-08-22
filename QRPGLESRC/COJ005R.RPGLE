      /TITLE Create Object, Retrieve Library Defaults                         */
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *         */
      *PARMS OPTION(*NOXREF)
      *                                                                       */
      * Synopsis: Retrieves program, data, operations, system library         */
      *            names for the create object (CRTOBJ) command.              */
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
     Fcoj000p   if   e           k disk
      *
     D srclib          s                   like(StdNam)
     D srctyp          s                   like(StdNam)
      *
      /copy qcpysrc,StdTypD
      * ---------------------------------------------------------
      *
      *   Retrieve library names.
      *
     C     srclib        chain     coj000r
š1b€ C                   if        not %found
     C                   eval      CLpgmlib = srclib
     C                   eval      CLdtalib = srclib
     C                   eval      CLopslib = srclib
     C                   eval      CLsyslib = srclib
š1e€ C                   endif
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $defn         begsr
      *
     C     *entry        plist
     C                   parm                    srclib
     C                   parm                    srctyp
     C                   parm                    CLpgmlib
     C                   parm                    CLdtalib
     C                   parm                    CLopslib
     C                   parm                    CLsyslib
      *
     CSR   #defn         endsr
