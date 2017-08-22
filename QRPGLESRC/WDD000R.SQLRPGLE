      /TITLE Work with DASD
      *PARMS ALWCPYDTA(*OPTIMIZE) COMMIT(*NONE)
      *PARMS RPGPPOPT(*lvl2)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Lists all system jobs and temporary storage used.
      *
      *
      *  Notes   :  none
      *
      *
      *  Job Type
      *  --------
      *  A     Job is an autostart job.
      *  B     Job is a batch job.
      *  I     Job is an interactive job.
      *  M     Job is a subsystem monitor job.
      *  R     Job is a spooled reader job.
      *  S     Job is a system job.
      *  W     Job is a spooled writer job.
      *  X     Job is the start-control program-function (SCPF) system job.
      *
      *  Job Sub-Type
      *  ------------
      *  D     Job is a batch immediate job.
      *  E     Job started with a procedure start request.
      *  J     Job is a prestart job.
      *  P     Job is a print driver job.
      *  U     Job is an alternate spool user.
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  01/13/10  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
     Fwdd000d   cf   e             workstn sfile(#sflrcd1:CurSflRcd)
     F                                     sfile(#sflrcd2:CurSflRcd)
     F                                     infds(DSdsp)
     Fwdd000p   o  a e             disk    usropn
      *
     D wd000         e ds                  extname(wdd000p) inz
      * ---------------------------------------------------------
      * Structure for OLJB0200 format (Receiver Variable)
      *
     DOLJB0200         DS                               inz
     D JBjob                               like(StdNam)
     D JBusr                               like(StdNam)
     D JBjno                               like(StdJobNbr)
     D JBjobid                             like(StdIntID)
     D JBstat                              like(StdNam)
     D JBtype                              like(StdChr)
     D JBsubtyp                            like(StdChr)
     D JBres1                         2
     D JBjobinfsts                         like(StdChr)
     D JBres2                         3
     D JBpgmn                              like(StdNam)
     D JBres3                         2
     D JBdata2                             like(StdChr)
     D JBres4                         3
     D JBauxio                             like(StdInt)
     D JBsbs                               like(StdNam)
     D JBsbslib                            like(StdNam)
     D JBtmpstg                            like(StdInt)
      * ---------------------------------------------------------
      * Structure for sort information format
      *
     DSortDS1          DS
     D KFnum                               like(StdInt)    inz(1)
     D KFstr                               like(StdInt)    inz(24)
     D KFlen                               like(StdInt)    inz(4)
     D KFtyp                               like(StdIntSml) inz(9)
     D KFord                               like(StdChr)    inz('2')
     D KFres                               like(StdChr)    inz(x'00')
      * ---------------------------------------------------------
      * Structure for job selection information format
      *
     DOLJS0100         DS
     D JSjob                               like(StdNam)    inz('*ALL')
     D JSusr                               like(StdNam)    inz('*ALL')
     D JSjno                               like(StdJobNbr) inz('*ALL')
     D JSjobtyp                            like(StdChr)    inz('*')
     D JSres                               like(StdChr)    inz(x'00')
     D JSpoff                              like(StdInt)    inz(60)
     D JSpnum                              like(StdInt)    inz(1)
     D JSaoff                              like(StdInt)    inz(70)
     D JSanum                              like(StdInt)    inz(0)
     D JSqoff                              like(StdInt)    inz(74)
     D JSqnum                              like(StdInt)    inz(0)
     D JSqnoff                             like(StdInt)    inz(84)
     D JSqnnum                             like(StdInt)    inz(0)
     D JSpjs                               like(StdNam)    inz('*ACTIVE')
     D JSajs                          4                    inz('RUN')
     D JSjqs                               like(StdNam)    inz
     D JSjqn                         20                    inz
      * ---------------------------------------------------------
      * Structure for receiver variable definition format
      *
     DVARDEF           DS                               inz
     D Vnum                                like(StdInt)
     D V1flen                              like(StdInt)
     D V1key                               like(StdInt)
     D V1type                              like(StdChr)
     D V1res                          3
     D V1dlen                              like(StdInt)
     D V1disp                              like(StdInt)
     D V2flen                              like(StdInt)
     D V2key                               like(StdInt)
     D V2type                              like(StdChr)
     D V2res                          3
     D V2dlen                              like(StdInt)
     D V2disp                              like(StdInt)
     D V3flen                              like(StdInt)
     D V3key                               like(StdInt)
     D V3type                              like(StdChr)
     D V3res                          3
     D V3dlen                              like(StdInt)
     D V3disp                              like(StdInt)
     D V4flen                              like(StdInt)
     D V4key                               like(StdInt)
     D V4type                              like(StdChr)
     D V4res                          3
     D V4dlen                              like(StdInt)
     D V4disp                              like(StdInt)
     D V5flen                              like(StdInt)
     D V5key                               like(StdInt)
     D V5type                              like(StdChr)
     D V5res                          3
     D V5dlen                              like(StdInt)
     D V5disp                              like(StdInt)
      * ---------------------------------------------------------
      * Structure for error code format
      *
     DQUSBN            DS
     D QUSbnb                              like(StdInt) inz(100)
     D QUSbnc                              like(StdInt) inz
     D QUSbnd                         7                 inz
     D QUSbnf                              like(StdChr) inz
     D QUSbng                        84                 inz
      * ---------------------------------------------------------
      * Structure for keys format
      *
     DKeysDS           DS
     D Key1                                like(StdInt) inz(0601)
     D Key2                                like(StdInt) inz(0602)
     D Key3                                like(StdInt) inz(1401)
     D Key4                                like(StdInt) inz(1906)
     D Key5                                like(StdInt) inz(2009)
      * ---------------------------------------------------------
      * Structure for List Information format
      *
     DLSTINF           DS                               inz
     D Ltotal                              like(StdInt)
     D Lretnd                              like(StdInt)
     D Lrhand                         4
     D Lrlen                               like(StdInt)
     D Lcomp                               like(StdChr)
     D Ldate                         13
     D Lstat                               like(StdChr)
     D Lres1                               like(StdChr)
     D Lilen                               like(StdInt)
     D Lfirst                              like(StdInt)
     D Lres2                         40
      * ---------------------------------------------------------
      * Stand-alone field definitions
      *
     D reclen          s                   like(StdInt) inz(104)
     D numrec          s                   like(StdInt) inz(-1)
     D selsiz          s                   like(StdInt) inz(104)
     D numfld          s                   like(StdInt) inz(5)
     D varlen          s                   like(StdInt) inz(104)
     D getnum          s                   like(StdInt) inz(1)
     D getsta          s                   like(StdInt) inz(1)
     D APIfmt          s                   like(StdFmt) inz
     D rcvvar          s                   like(StdBuf) inz
      *
     D USnam           s                   like(StdNam) inz('WDD000R')
     D USlib           s                   like(StdNam) inz('QTEMP')
      *
     D addent          s                   like(stdind)    inz
     D clrsflopt       s                   like(stdind)    inz
     D confirmexit     s                   like(stdind)    inz
     D confirmf14      s                   like(stdind)    inz
     D curkeys         s                   like(StdInt)    inz
     D curopts         s                   like(StdInt)    inz
     D CurPnl          s                   like(StdNam)    inz
     D cursflrcd       s                   like(StdInt)    inz
     D error           s                   like(stdind)    inz
     D opterr          s                   like(stdind)    inz
     D SQLstm          s                   like(StdSQL)    inz
     D orderby         s                   like(StdSQL)    inz
     D orderbyDft      s                   like(StdSQL)    inz
     D redsflrcdend    s                   like(stdind)    inz
     D sflload         s                   like(stdind)    inz
     D sflrecs         s                   like(stdint)    inz
     D sltrcd          s                   like(stdind)    inz
     D SSsbs           s                   like(StdNam)
     D PVsqst          s                   like(StdSQL)    inz
     D strsflrcd       s                   like(StdInt)    inz
     D totsflrcd       s                   like(StdInt)    inz
     D x               s                   like(StdInt)    inz
      *
      /COPY QCPYSRC,Dspec
      *
     C                   exsr      $SetScreen
     C                   exsr      $Main
      *
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Setup screen.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $setscreen    BEGSR
      *
      *    Show the options/PF keys available for the mode.
      *
     C                   eval      curopts = *zero
     C                   exsr      $MoreOpts
     C                   eval      curkeys = *zero
     C                   exsr      $Morekeys
     C                   eval      putovr  = *off
     C                   eval      z2aid   = *loval
     C                   eval      sflload = *on
     C                   eval      error   = *off
      *
      *    Refresh.
      *
     C                   exsr      $Refresh
      *
      *    Set current screen.
      *
     C                   exsr      $SetCurPnl
      *
      *    Reset the positioning variables.
      *
     C                   eval      SQLstm   = *blanks
     C                   eval      PVsqst   = *blanks
      *
     Csr   #setscreen    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Main routine.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $main         BEGSR
      *
      *    Display the screen until exit.
      *
     C                   dou       z2aid = exit  or
     C                             z2aid = Cancel
      *
      *    Position to DB records.
      *
     C                   exsr      $PosDBrcd
      *
      *    Load the subfile with DB records.
      *
     C                   if        SflLoad
     C                   exsr      $LodDBrcd
     C                   endif
      *
      *    Display the screen.
      *
     C                   exsr      $DspScreen
      *
      *    Edit and process user selections.
      *
     C                   if        z2aid = enter  and
     C                             totsflrcd <> *zero
     C                   exsr      $EdtUsrSlt
      *
     C                   if        not error
     C                   exsr      $PrcUsrSlt
     C                   endif
     C                   endif
      *
      *    Process user PF keys.
      *
     C                   exsr      $PrcUsrKey
     C                   enddo
      *
     Csr   #main         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Display the screen.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $dspscreen    BEGSR
      *
      *    Set subfile record number if its not correct.
      *
     C                   if        sflrcdnbr <= *zero  or
     C                             sflrcdnbr > TotSflRcd
     C                   eval      SflRcdNbr = 1
     C                   endif
      *
      *    Set SFLDSP keyword if subfile records.
      *
     C                   if        totsflrcd <> *zero
     C                   eval      sfldsp = *on
     C                   else
     C                   eval      sfldsp = *off
     C                   endif
      *
      *    Clear panel and write program messages.
      *
     C                   write(e)  #CLRPNL
     C                   exsr      $ChkPnlErr
     C                   write(e)  #MSGCTL
     C                   exsr      $ChkPnlErr
      *
      *    Show subfile.
      *
     C                   eval      sfldspctl = *on
     C                   select
     C                   when      CurPnl = '#SFLRCD1'
     C                   write(e)  #PFKEYS1
     C                   exfmt(e)  #SFLCTL1
     C                   when      CurPnl = '#SFLRCD2'
     C                   write(e)  #PFKEYS2
     C                   exfmt(e)  #SFLCTL2
     C                   endsl
     C                   exsr      $ChkPnlErr
      *
      *    Capture current subfile record number.
      *
     C                   eval      sflrcdnbr = CsrRrn
      *
      *    Reset indicators, clear messages.
      *
     C                   eval      putovr    = *on
     C                   eval      sfldspctl = *on
     C                   eval      sfldsp    = *off
     C                   exsr      $PMCLR
      *
     Csr   #dspscreen    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Position to DB records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $posdbrcd     BEGSR
      *
      *    If the position changed, set the DB at it.
      *
     C                   if        sflload            or
     C                             z2aid   = refresh  or
     C                             SQLstm <> PVsqst
      *
      *    Build SQL statement.
      *
     C                   exsr      $BldSQLstm
      *
      *    Set the positioning values.
      *
     C                   eval      PVsqst = SQLstm
      *
      *    Clear the subfile and reset.
      *
     C                   exsr      $ClrSfl
     C                   endif
      *
     Csr   #posdbrcd     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Load DB records into subfile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $loddbrcd     BEGSR
      *
     C                   eval      sflend    = *off
     C                   eval      sflload   = *off
     C                   eval      sflrcdnbr = TotSflRcd + 1
     C                   eval      setcsrpos = *on
      *
      *    Read entries until EOF.
      *
     C                   dou       sflend
     C                   exsr      $FetSQLrcd
      *
      *    If selected; load into subfile.
      *
     C                   if        not sflend
     C                   eval      sflnxtchg  = *on
     C                   eval      totsflrcd += 1
     C                   eval      cursflrcd  = TotSflRcd
     C                   exsr      $WrtSflRcd
     C                   endif
     C                   enddo
      *
     Csr   #loddbrcd     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Check user selections.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $edtusrslt    BEGSR
      *
     C                   eval      error   = *off
      *
      *    Read all user changed records.
      *
     C                   exsr      $RedSflRcd
      *
     C                   dow       redsflrcdend = *off
     C                   eval      opterr  = *off
     C                   eval      SFoptn = %trim(SFoptn)
      *
      *    Option must be valid when in change mode.
      *
     C                   if        SFoptn <> *blanks
     C                   if        SFoptn = '5'
     C                   else
     C                   eval      opterr  = *on
     C                   eval      msgid   = 'GNL0020'
     C                   exsr      $PMsnd
     C                   endif
     C                   endif
      *
     C                   eval      sflnxtchg = *on
     C                   exsr      $UpdSflRcd
      *
     C                   exsr      $RedSflRcd
     C                   enddo
      *
     Csr   #edtusrslt    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Process user selections (subfile records).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $prcusrslt    BEGSR
      *
      *    Read all user changed records.
      *
     C                   exsr      $RedSflRcd
      *
     C                   dow       redsflrcdend = *off
      *
      *    Update subfile record if no option keyed.
      *
     C                   if        SFoptn   <> *blanks
     C                   eval      clrsflopt = *on
     C                   eval      error     = *off
     C                   eval      SFoptn = %trim(SFoptn)
      *
      *    5=Work with open files
      *
     C                   select
     C                   when      SFoptn = '5'
     C                   exsr      $SflOpt05
     C                   endsl
      *
      *    Reset values after each process.
      *
     C                   eval      putovr    = *off
     C                   endif
      *
      *    Clear selected option.
      *
     C                   if        clrsflopt = *on
     C                   eval      SFoptn    = *blanks
     C                   exsr      $UpdSflRcd
     C                   endif
      *
     C                   exsr      $RedSflRcd
     C                   enddo
      *
     Csr   #prcusrslt    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  5=Work with job.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $SflOpt05     BEGSR
      /free

        ExecCmd('wrkjob job(' + %trim(WDjno) + '/' +
                                %trim(WDUSR) + '/' +
                                %trim(WDJOB) + ')');

      /end-free
     Csr   #SflOpt05     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Get a subfile record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $getsflrcd    BEGSR
      *
     C                   select
     C                   when      CurPnl = '#SFLRCD1'
     C     cursflrcd     chain(e)  #SFLRCD1
     C                   when      CurPnl = '#SFLRCD2'
     C     cursflrcd     chain(e)  #SFLRCD2
     C                   endsl
      *
     C                   exsr      $ChkPnlErr
      *
     Csr   #getsflrcd    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Read subfile record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $redsflrcd    BEGSR
      *
     C                   select
     C                   when      CurPnl = '#SFLRCD1'
     C                   readc(e)  #SFLRCD1
     C                   when      CurPnl = '#SFLRCD2'
     C                   readc(e)  #SFLRCD2
     C                   endsl
      *
     C                   eval      redsflrcdend = %eof
     C                   exsr      $ChkPnlErr
      *
     Csr   #redsflrcd    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Write subfile record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $wrtsflrcd    BEGSR
      *
      *    Dont allow rolldown if near end-of-subfile.
      *
     C                   if        TotSflRcd >= 9980
     C                   eval      sflend  = *on
     C                   endif
      *
      *    Insert additional subfile information.
      *
     C                   exsr      $InsSflInf
     C                   eval      @doptn = DspAtr_UL
      *
      *    Write subfile record.
      *
     C                   select
     C                   when      ud_fulscn = 'Y'
     C                   write(e)  #SFLRCD1
     C                   when      ud_fulscn <>'Y'
     C                   write(e)  #SFLRCD2
     C                   endsl
      *
      *    Reset subfile functions and check for errors.
      *
     C                   eval      setcsrpos = *off
     C                   eval      sflnxtchg = *off
     C                   exsr      $ChkPnlErr
      *
     C                   eval      SflRecs -= 1
      *
     Csr   #wrtsflrcd    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Update subfile record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $updsflrcd    BEGSR
      *
      *    Force subfile record to be read.
      *
     C                   eval      sflnxtchg = *on
      *
      *    Update additional subfile information.
      *
     C                   exsr      $InsSflInf
      *
     C                   select
     C                   when      CurPnl = '#SFLRCD1'
     C                   update(e) #SFLRCD1
     C                   when      CurPnl = '#SFLRCD2'
     C                   update(e) #SFLRCD2
     C                   endsl
      *
      *    Reset subfile functions and check for errors.
      *
     C                   eval      setcsrpos = *off
     C                   eval      sflnxtchg = *off
     C                   exsr      $ChkPnlErr
      *
     Csr   #updsflrcd    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Clear subfile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $ClrSfl       BEGSR
      *
      *    Clear the subfile and reset.
      *
     C                   eval      sflclr = *on
     C                   select
     C                   when      ud_fulscn = 'Y'
     C                   write(e)  #SFLCTL1
     C                   when      ud_fulscn <> 'Y'
     C                   write(e)  #SFLCTL2
     C                   endsl
     C                   exsr      $ChkPnlErr
     C                   eval      sflclr = *off
      *
      *    Clear the subfile and record counters.
      *
     C                   clear                   CurSflRcd
     C                   clear                   TotSflRcd
     C                   clear                   SflRcdNbr
      *
     Csr   #ClrSfl       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Clear subfile record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $clrsflrcd    BEGSR
      *
     C                   reset                   #SFLRCD1
     C                   reset                   #SFLRCD2
      *
     Csr   #clrsflrcd    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Write blank subfile record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $wrtblanksfl  BEGSR
      *
     C                   exsr      $ClrSflRcd
      *
      *    Write subfile record for an add.
      *
     C                   eval      TotSflRcd += 1
     C                   eval      cursflrcd  = TotSflRcd
     C                   eval      addent     = *on
     C                   exsr      $WrtSflRcd
      *
     C                   eval      addent    = *off
     C                   eval      sflend    = *on
     C                   eval      CurSflRcd = 1
      *
     Csr   #wrtblanksfl  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Insert additional subfile information.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $inssflinf    BEGSR
      *
     Csr   #inssflinf    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Build SQL statement.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $BldSQLstm    begsr
      /free

        // ------------------------------------------------------
        // Build SQL statement.
        // ------------------------------------------------------

        SQLstm = 'select * from wdd000p';

        // set where clause.

        // set order by.

        SQLstm = %trim(SQLstm) + ' order by ' + OrderBy;

        // optimization.

        SQLstm = %trim(SQLstm) +
                  ' for fetch only optimize for 500 rows';

        // ------------------------------------------------------
        // Prepare, declare and open.
        // ------------------------------------------------------

        EXEC SQL prepare SQLstm from :SQLstm;
        if sqlcod = -519;
           EXEC SQL close   SQLcsr;
           EXEC SQL prepare SQLstm from :SQLstm;
        endif;

        EXEC SQL declare SQLcsr cursor for SQLstm;
        EXEC SQL open    SQLcsr;

      /end-free
     Csr   #BldSQLstm    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Fetch SQL record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FetSQLrcd    begsr
      /free

       EXEC SQL FETCH SQLcsr INTO :wd000;

       if sqlcod <> *zero;
          SflEnd  = *on;
       else;
          SflEnd  = *off;
       endif;

      /end-free
     CSR   #FetSQLrcd    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Close SQL cursor.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CloSQLcsr    begsr
      /free

        EXEC SQL close SQLcsr;

      /end-free
     CSR   #CloSQLcsr    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Set current panel.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $SetCurPnl    BEGSR
      * ---------------------------------------------------------
      *
      *   Set current panel name.
      *
     C                   select
     C                   when      UD_fulscn  = 'Y'
     C                   eval      CurPnl     = '#SFLRCD1'
      *
     C                   when      UD_fulscn <> 'Y'
     C                   eval      CurPnl     = '#SFLRCD2'
     C                   endsl
      *
     Csr   #SetCurPnl    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Process user PF keys.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $prcusrkey    BEGSR
      *
      *    Reset confirmation of exit.
      *
     C                   if        z2aid <> exit  and
     C                             z2aid <> Cancel
     C                   eval      confirmexit = *off
     C                   endif
      *
      *    Reset confirmation of print.
      *
     C                   if        z2aid <> PrintList
     C                   eval      confirmf14  = *off
     C                   endif
      *
      *    Process F3=Exit.
      *
     C                   select
     C                   when      z2aid = Exit
     C                   exsr      $ConfirmExit
      *
      *    Process F4=List.
      *
     C                   when      z2aid = List
     C                   exsr      $List
      *
      *    Process F5=Refresh
      *
     C                   when      z2aid = Refresh
     C                   exsr      $Refresh
      *
      *    Process F12=Cancel.
      *
     C                   when      z2aid = Cancel
     C                   exsr      $ConfirmExit
      *
      *    Process F14=Print.
      *
     C                   when      z2aid = PrintList
     C                   exsr      $Print
      *
      *    Process F16=Sort.
      *
     C                   when      z2aid = Sort
     C                   exsr      $Sort
      *
      *    Process F18=Change defaults.
      *
     C                   when      z2aid = ChgDfts
     C                   exsr      $ChgDfts
      *
      *    Process F23=More options.
      *
     C                   when      z2aid = MoreOpts
     C                   exsr      $MoreOpts
      *
      *    Process F24=More keys.
      *
     C                   when      z2aid = MoreKeys
     C                   exsr      $MoreKeys
     C                   endsl
      *
     Csr   #prcusrkey    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  F3=Exit and F12=Cancel.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $confirmexit  BEGSR
      *
      *    Verify no errors before allowing exit.
      *
     C**                 if        totsflrcd <> *zero
     C**                 exsr      $EdtUsrSlt
     C**                 if        error
     C**                 leavesr
     C**                 endif
     C**                 endif
      *
      *    Confirmation received or not required; exit.
      *
     C                   if        confirmexit = *on
     C                   exsr      $Exit
     C                   endif
      *
      *    Send confirmation message if required.
      *
     C                   select
     C                   when      z2aid       = Exit
     C                   eval      z2aid       = *blanks
     C                   eval      confirmexit = *on
     C                   eval      msgid       = 'GNL0176'
     C                   exsr      $PMsnd
      *
     C                   when      z2aid       = Cancel
     C                   eval      z2aid       = *blanks
     C                   eval      confirmexit = *on
     C                   eval      msgid       = 'GNL0177'
     C                   exsr      $PMsnd
     C                   endsl
      *
     Csr   #confirmexit  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Exit program.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $exit         BEGSR
      /free
        EXEC SQL close SQLcsr;
      /end-free
      *
     C                   if        z2aid = Exit
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      *
     C                   if        z2aid = Cancel
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      *
     Csr   #exit         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  F4=List.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $list         BEGSR
      *
     C                   select
      *
     C                   when      csrfld = 'WDxxxxxx'
     C**                 eval      sysct  = SltSC('ITINERARY':
     C**                                          'COST CODES')
     C**                 if        scdta <> *blanks
     C**                 eval      LPmanclc = sccd1
     C**                 eval      sflnxtchg   = *on
     C**                 exsr      $UpdSflRcd
     C**                 endif
      *
     C                   other
     C                   eval      error  = *on
     C                   eval      torel  = '*PRV'
     C                   eval      msgid  = 'GNL0040'
     C                   exsr      $PMsnd
     C                   endsl
      *
     C                   eval      putovr = *off
      *
     Csr   #list         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Refresh.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $Refresh      BEGSR
      /free

        SflLoad  = *on;
        TLauxio  = *zero;
        TLdbio   = *zero;
        TLtmpstg = *zero;

       // Get active job information and put in user space.
      /end-free
     C                   call      'QGYOLJOB'
     C                   parm                    OLJB0200
     C                   parm                    RECLEN
     C                   parm      'OLJB0200'    APIfmt
     C                   parm                    VARDEF
     C                   parm                    VARLEN
     C                   parm                    LSTINF
     C                   parm                    NUMREC
     C                   parm                    SortDS1
     C                   parm                    OLJS0100
     C                   parm                    SELSIZ
     C                   parm                    NUMFLD
     C                   parm                    KeysDS
     C                   parm                    QUSBN
      /free
        EXEC SQL close   SQLcsr;

        ExecCmd('CLRPFM FILE(wdd000p)');

        OPEN wdd000p;
        GetSta = *zero;

        for GetSta = 1 to Ltotal;

        // Get list entry.
      /end-free
     C                   call      'QGYGTLE'
     C                   parm                    OLJB0200
     C                   parm                    RECLEN
     C                   parm                    LRHAND
     C                   parm                    LSTINF
     C                   parm                    GETNUM
     C                   parm                    GETSTA
     C                   parm                    QUSBN
      /free

           if SSsbs    = '*ALL'  or
              SSsbs    = JBsbs;
              clear wdd000r;

              WDjob    = JBjob;
              WDusr    = JBusr;
              WDjno    = JBjno;
              WDstat   = JBstat;
              WDtype   = JBtype;
              WDsubtyp = JBsubtyp;
              if JBpgmn <> *all'x00';
                 WDpgmn   = JBpgmn;
              endif;
              WDauxio  = JBauxio;
              WDsbs    = JBsbs;
              WDtmpstg = JBtmpstg;

              TLauxio  += JBauxio;
              TLtmpstg += JBtmpstg;

              write wdd000r;
           endif;
        endfor;

        close wdd000p;

       // Close list.
      /end-free
     C                   call      'QGYCLST'
     C                   parm                    Lrhand
     C                   parm                    QUSBN
      /free

      /end-free
     Csr   #Refresh      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  F14=Print the selected records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $print        BEGSR
      *
      *    Confirm.
      *
     C                   if        confirmf14 = *off
     C                   eval      confirmf14 = *on
     C                   eval      msgid      = 'GNL0093'
     C                   exsr      $PMsnd
     C                   leavesr
     C                   endif
      *
      *    Printing.
      *
     C                   exsr      $PrtDBrcds
     C                   eval      msgid      = 'GNL0174'
     C                   exsr      $PMsnd
      *
     Csr   #print        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  F16=Sort by column specified by cursor.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $sort         BEGSR
      *
     C                   eval      sflload = *on
      *
     C                   select
     C                   when      csrfld = 'WDJOB   '  or
     C                             csrfld = 'WDUSR   '  or
     C                             csrfld = 'WDJNO   '  or
     C                             csrfld = 'WDPGMN  '  or
     C                             csrfld = 'WDSBS   '
     C                   eval      orderby = lower(csrfld)
      *
     C                   when      csrfld = 'WDAUXIO '  or
     C                             csrfld = 'WDDBIO  '  or
     C                             csrfld = 'WDTMPSTG'
     C                   eval      orderby =
     C                             %trim(lower(csrfld)) + ' desc'
      *
     C                   other
     C                   eval      error = *on
     C                   eval      msgid = 'GNL0168'
     C                   exsr      $PMsnd
     C                   eval      orderby = OrderbyDft
     C                   endsl
      *
     Csr   #sort         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  F18=Change defaults.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $chgdfts      BEGSR
      *
     C                   eval      putovr  = *off
     C                   eval      SflLoad = *on
     C                   exsr      $RtvUsrDft
      *
      *   Prompt for change defaults.
      *
     C                   do        *hival
     C                   write(e)  #ClrPnl
     C                   write(e)  #MsgCtl
     C                   exfmt(e)  #ChgDft
     C                   exsr      $ChkPnlErr
     C                   exsr      $PMclr
     C                   eval      error = *off
      *
      *    Escape on Enter.
      *
     C                   if        not error        and
     C                             Z2aid = Enter
     C                   leave
     C                   endif
      *
      *    Escape on F3=Exit or F12=Cancel.
      *
     C                   if        not error         and
     C                             (Z2aid = Exit     or
     C                              Z2aid = Cancel)
     C                   leavesr
     C                   endif
     C                   enddo
      *
     C                   exsr      $UpdUsrDft
     C                   eval      Z2aid  = Enter
      * ---------------------------------------------------------
      *
      *   Set current panel name.
      *
     C                   exsr      $SetCurPnl
      *
     Csr   #chgdfts      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Retrieve user defaults.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvUsrDft    BEGSR
      *
     C                   eval      UD_fulscn = RtvAppCtlDta('USER DEFAULTS':
     C                                                      'FULL SCREEN':
     C                                                       ZZusr:ZZpgm)
      *
     CSR   #RtvUsrDft    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Update user defaults.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UpdUsrDft    BEGSR
      *
     C                   callp     UpdAppCtl('USER DEFAULTS':
     C                                       'FULL SCREEN':
     C                                        ZZusr:ZZpgm:
     C                                        UD_fulscn)
      *
     CSR   #UpdUsrDft    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  More options.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $moreopts     BEGSR
      *
     C                   eval      curopts += 1
      * ---------------------------------------------------------
      *
      *    Change mode.
      *
     C                   select
     C                   when      CurOpts = 1
     C                   eval      curopts = *zero
     C                   eval      opttx1  = '5=Work with job'
     C                   eval      opttx2  = *blanks
     C                   endsl
      *
     Csr   #moreopts     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  More keys.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $morekeys     BEGSR
      *
     C                   eval      curkeys += 1
      *
     C                   select
     C                   when      CurKeys = 1
     C                   eval      curkeys = *zero
     C                   eval      keytx1  = 'F3=Exit    +
     C                                        F5=Refresh  +
     C                                        F12=Cancel'
     C                   eval      keytx2  = 'F14=Print  +
     C                                        F16=Sort    +
     C                                        F18=Change defaults'
     C                   endsl
      *
     Csr   #morekeys     ENDSR
      /SPACE 3
      /COPY QCPYSRC,$ChkPnlErr
      /SPACE 3
      /COPY QCPYSRC,$PMRTV
      /SPACE 3
      /COPY QCPYSRC,$PMsnd
      /SPACE 3
      /COPY QCPYSRC,$PMCLR
      /SPACE 3
      /COPY QCPYSRC,$PrtDBrcd
      /SPACE 3
      /COPY QCPYSRC,$PrtDBrcds
      /SPACE 3
      /COPY QCPYSRC,$PSSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   *inzsr        BEGSR
      *
      *    Retriever user defaults.
      *
     C                   exsr      $RtvUsrDft
      *
      *    Set the order by default.
      *
     C                   eval      orderbydft = 'WDjob'
     C                   eval      orderby = OrderbyDft
      *
     Csr   #inzsr        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $define       BEGSR
      *
     C     *entry        plist
     C                   parm                    SSsbs
      *
     Csr   #define       ENDSR
