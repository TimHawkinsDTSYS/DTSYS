      /TITLE Create object, Retrieve environment libraries                    */
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *         */
      *PARMS OPTION(*NOXREF)
      *                                                                       */
      * Synopsis:                                                             */
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
     D PLoption        s                   like(StdNam)
     D PLenvnam        s                   like(CLenvnam)
     D PLdtalib        s                   like(CLdtalib)
     D PLpgmlib        s                   like(CLpgmlib)
      *
      /copy qcpysrc,StdTypD
      *
     C                   exsr      $RtvRec
      *
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvRec       BEGSR
      *
      *    Position to first record.
      *
     C                   if        PLoption = '*FIRST'
š2b€ C     *loval        setll     coj000r
š2e€ C                   endif
      *
      *    Retrieve next record.
      *
š2b€ C                   read      coj000r
     C                   if        %eof            or
     C                             CLenvnam = *blanks
     C                   clear                   coj000
š2e€ C                   endif
      *
     C                   eval      PLenvnam = CLenvnam
     C                   eval      PLdtalib = CLdtalib
     C                   eval      PLpgmlib = CLpgmlib
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
     C                   PARM                    PLoption
     C                   PARM                    PLenvnam
     C                   PARM                    PLdtalib
     C                   PARM                    PLpgmlib
      *
     CSR   #DEFN         ENDSR
