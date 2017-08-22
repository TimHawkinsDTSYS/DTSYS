      /TITLE Create Object, Retrieve environment library                      */
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
     Fcoj000l1  if   e           k disk
      *
     D coj000        e ds                  extname(coj000p)
      *
     D PLenvnam        s                   like(CLenvnam)
     D PLpgmlib        s                   like(CLpgmlib)
     D PLdtalib        s                   like(CLdtalib)
     D PLwrklib        s                   like(CLwrklib)
     D PLsrclib        s                   like(CLsrclib)
     D PLtext          s                   like(CLtext)
      *
      /copy qcpysrc,StdTypD
      *
     C                   exsr      $RtvRec
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvRec       BEGSR
      *
      *    Retrieve record.
      *
š2b€ C     PLenvnam      chain     coj000r
     C                   if        not %found      or
     C                             CLenvnam = *blanks
     C                   clear                   coj000
š2e€ C                   endif
      *
     C                   eval      PLenvnam = CLenvnam
     C                   eval      PLpgmlib = CLpgmlib
     C                   eval      PLdtalib = CLdtalib
     C                   eval      PLwrklib = CLwrklib
     C                   eval      PLsrclib = CLsrclib
     C                   eval      PLtext   = CLtext
      *
     CSR   #RtvRec       ENDSR
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
     C                   PARM                    PLenvnam
     C                   PARM                    PLpgmlib
     C                   PARM                    PLdtalib
     C                   PARM                    PLwrklib
     C                   PARM                    PLsrclib
     C                   PARM                    PLtext
      *
     CSR   #DEFN         ENDSR
