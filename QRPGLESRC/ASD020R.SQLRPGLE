      /TITLE Archive Spoolfiles to Domino, send emails
      *PARMS ALWCPYDTA(*OPTIMIZE) COMMIT(*NONE)
      *PARMS RPGPPOPT(*lvl2)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Archive spoolfiles with their RJS log information
      *              to a domino email-based document folder.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  02/27/04  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY qcpysrc,Hspec
      *
     FQSYSPRT   O    F  132        PRINTER OFLIND(*inOF)
     F                                     USROPN
      *
     D bkgma         E DS                  EXTNAME(bkgmaP01) inz
     D usrpf         E DS                  EXTNAME(usrpfP01) inz
     D ERSLOG        E DS                  EXTNAME(ERSLOG00) INZ
      *
     D  ArchiveError   s                   like(StdChr) inz
     D  error          s                   like(StdInd) inz
     D  Count          s                   like(StdCnt) inz
     D  Status         s                   like(Erl001) inz
     D  PageOne        s                   like(StdCnt) inz(1)
     D  PagesSent      s                   like(StdCnt) inz
     D**Subject        s                   like(StdTxt) inz
     D  DominoUser     s                   like(StdTxt) inz
     D  Ident          s                   like(StdInd) inz
      *
     D  EmailAddr      s                   like(StdTxt)    inz
     D  FaxNumber      s                   like(EmailAddr) inz
      *
      /copy qcpysrc,DspecSQL
      /copy qcpysrc,Dspec
      *
     C                   exsr      $WrtPfrat
      *
     C                   exsr      $ReadRecords
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Read records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ReadRecords  BEGSR
      * ---------------------------------------------------------
      *
      *   Determine records to be processed.
      *
     C/EXEC SQL
     C+     declare DBcurERSLOG cursor for
     C+      select * from ERSLOG00
     C+       where substr(erl002,length(erl002),1) = ' '
     C+         for update of erl002
     C/END-EXEC
      *
     C/EXEC SQL  open DBcurERSLOG
     C/END-EXEC
      * ---------------------------------------------------------
      *
      *   Fetch and process records.
      *
š1b€ C                   dou       sqlcod <> *zero
     C/EXEC SQL  fetch DBcurERSLOG into :ERSLOG
     C/END-EXEC
š2b€ C                   if        sqlcod  = *zero
     C                   exsr      $ParErsLog
     C                   if        Ident
     C                   exsr      $PrtSndInf
     C                   endif
      *
      *   Update log record with success or failure.
      *
     C/EXEC SQL
     C+      update ERSLOG00
     C+         set erl002 =
     C+             substr(erl002,1,length(erl002)-1) || :ArchiveError
     C+       where current of DBcurERSLOG
     C/END-EXEC
      *
      *   Escape after 100 (testing).
      *
š2b€ C                   eval      count += 1
š2b€ C                   if        count > 100
š2e€ C                   leave
š2b€ C                   endif
      *
      *   Escape if past the standard run time.
      *
š2b€ C                   if        CurrentTime > 235000
š2e€ C                   leave
š2b€ C                   endif
š2e€ C                   endif
š1e€ C                   enddo
      * ---------------------------------------------------------
      *
      *   Close the DB.
      *
     C/EXEC SQL  close DBcurERSLOG
     C/END-EXEC
      *
     CSR   #ReadRecords  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Parse the log.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ParErsLog    BEGSR
      *
      /free
        eval    ArchiveError    = *blanks;

        eval    EmailAddr       = ExtRsp('Report mailed to:':erl002);

        if      EmailAddr       = *blanks;
          eval  EmailAddr       = ExtRsp('Report faxed to:':erl002);
        endif;

        if      EmailAddr       = *blanks;
          eval  EmailAddr       = ExtRsp('Errors mailing to:':erl002);
        endif;

        if      EmailAddr       = *blanks;
          eval  EmailAddr       = ExtRsp('Errors faxing to:':erl002);
        endif;

        if      %scan('@' + FaxDomNam:EmailAddr) <> *zero;
          eval  FaxNumber       = %replace('':EmailAddr:
                                  %scan(%trim('@' + FaxDomNam):EmailAddr):
                                  %len(%trim('@' + FaxDomNam)));
          eval  EmailAddr       = *blanks;
        endif;

        eval    PagesSent       = Erl004;

       // -------------------------------------------------------
       // Determine email address.

        eval ToAddress = 'SpoolArchive.' + %trim(SysNam) + '.';
        eval Ident     = *off;

        select;
        when   LGspool   = 'AM0551P   ';
          eval ToAddress = %trim(ToAddress) + ' PerkStatement';
          eval Ident     = *on;

        when   LGspool   = 'CR0310P1  ' or
               LGspool   = 'CR0310P2  ';
          eval ToAddress = %trim(ToAddress) + ' LandServiceChanges';
          eval Ident     = *on;

        when   LGspool   = 'DP0300P2  ' or
               LGspool   = 'DP0300P3  ';
          eval ToAddress = %trim(ToAddress) + ' Invoices';
          eval Ident     = *on;

        when   LGspool   = 'DP0320P1  ';
          eval ToAddress = %trim(ToAddress) + ' Vouchers';
          eval Ident     = *on;

        when   LGspool   = 'DP0340P   ' or
               LGspool   = 'DP0340P1  ';
          eval ToAddress = %trim(ToAddress) + ' E-tickets';
          eval Ident     = *on;

        when   LGspool   = 'IM0504P   ';
          eval ToAddress = %trim(ToAddress) + ' Stop-sell';
          eval Ident     = *on;

        when   LGspool   = 'INVOICE   ';
          eval ToAddress = %trim(ToAddress) + ' Invoices';
          eval Ident     = *on;

        when   LGspool   = 'PP0350P   ';
          eval ToAddress = %trim(ToAddress) + ' DeclinedPayments';
          eval Ident     = *on;

        when   LGspool   = 'PR0706P   ';
          eval ToAddress = %trim(ToAddress) + ' BookingAlerts';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'AIRMANIF  ';
          eval ToAddress = %trim(ToAddress) + ' AirManifest';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'ARC_REPORT';
          eval ToAddress = %trim(ToAddress) + ' ARCreport';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'RB0330R   ';
          eval ToAddress = %trim(ToAddress) + ' SalesAnalysis';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'RB0332R   ';
          eval ToAddress = %trim(ToAddress) + ' BookingItinerary';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'RB0334R   ';
          eval ToAddress = %trim(ToAddress) + ' TFH';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'VNDPREPAY ';
          eval ToAddress = %trim(ToAddress) + ' VendorPrepay';
          eval Ident     = *on;

        when   LGspool   = 'QSYSPRT   ' and
               LGusrdta  = 'WKLYSALES ';
          eval ToAddress = %trim(ToAddress) + ' WeeklySales';
          eval Ident     = *on;

        when   LGspool   = 'QUEUE     ';

        when   LGspool   = 'RB0344P   ' or
               LGspool   = 'RB0344P1  ';
          eval ToAddress = %trim(ToAddress) + ' LandManifests';
          eval Ident     = *on;

        when   LGspool   = 'RB0354P   ' or
               LGspool   = 'RB0354P1  ';
          eval ToAddress = %trim(ToAddress) + ' ArrivalsItinerary';
          eval Ident     = *on;
        endsl;

       // -------------------------------------------------------
       // Send an email if not identified.

        if   not Ident;
          eval msgid  = 'TXT0192';
          eval msgdta = erl002;
          exsr $PMrtv;
          eval seclvl = %trim(msg) + ' ' + %trim(seclvl);

          eval msgid  = ExecCmd('SNDPGRMSG +
                                 TOPGR(timh@cruzio.com) +
                                 MSG(''' + %trim(seclvl) + ''')');
        endif;

        endsr;

       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Print the send information.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        begsr    $PrtSndInf;

        eval     error = *off;

       // -------------------------------------------------------
       // Move spoolfile to work output queue.

        eval   msgid  = ExecCmd('CHGSPLFA +
                        FILE(' + %trim(LGspool)     + ') +
                        JOB(' + %trim(LGjobnbr)     + '/' +
                                %trim(LGuserid)     + '/' +
                                %trim(LGjob)        + ') +
                        SPLNBR(' + %trim(LGspnum)   + ') +
                        OUTQ(RJSWRK)');

        exsr   $ChkCmdFail;
        if     error;
          leavesr;
        endif;

       // -------------------------------------------------------
       // Transmission page, print.

        open      QSYSPRT;
        except    #HDG01;
        except    #DTL01;
        close     QSYSPRT;

       // -------------------------------------------------------
       // Mail output queue.

        eval   Subject  = '''Archived spoolfile ' + %trim(LGusrdta) + '''';

        eval   msgid  = ExecCmd('MAILOUTQ +
                        OUTQ(RJSWRK) +
                        TOADDRESS(' + %trim(ToAddress)  + ') +
                        SUBJECT(' + %trim(Subject)      + ') +
                        CONVTYPE(PDF) +
                        SMTPHOST(' + %trim(SMTPhost)    + ') +
                        SPLFOPT(*NONE)');

        exsr   $ChkCmdFail;
        if     error;
          eval *inLR = *on;
          return;
        endif;

       // -------------------------------------------------------
       // Delete transmission page.

        eval   msgid  = ExecCmd('DLTSPLF FILE(QSYSPRT) SPLNBR(*last)');

       // -------------------------------------------------------
       // Move spoolfile to sent output queue.

        eval   msgid  = ExecCmd('CHGSPLFA +
                        FILE(' + %trim(LGspool)     + ') +
                        JOB(' + %trim(LGjobnbr)     + '/' +
                                %trim(LGuserid)     + '/' +
                                %trim(LGjob)        + ') +
                        SPLNBR(' + %trim(LGspnum)   + ') +
                        OUTQ(RJSARC)');

        endsr;

       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Initialize variables.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        begsr  *INZSR;

        eval   *inOF   = *on;
        eval   today   = TodaysDate;
        eval   CurTime = CurrentTime;

       // -------------------------------------------------------
       //  Change job to work output queue.

        eval  msgid  = ExecCmd('CHGJOB OUTQ(RJSWRK)');

       // -------------------------------------------------------
       // Retrieve system name.

        exsr   $NetA;

       // -------------------------------------------------------
       // Retrieve production data library.

        exsr   $RtvPrdDta;

       // -------------------------------------------------------
       // Set spoolfile constants.

        exsr   $SndSplfC;

       // -------------------------------------------------------
       // Retrieve company name.

        exsr   $RtvConam;
        eval   COname = Center(COname);

        endsr;

       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Check for command failures.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        begsr  $ChkCmdFail;

        if     msgid       <> *blanks;
          eval ArchiveError = 'E';
          eval error        = *on;
        else;
          eval ArchiveError = 'A';
          eval error        = *off;
        endif;

        endsr;

      /end-free
      *
      /copy qcpysrc,$NetA
      /copy qcpysrc,$WrtPfrat
      /copy qcpysrc,$SndSplf
      /copy qcpysrc,$RtvConam
      /copy qcpysrc,$RtvPrdDta
      /copy qcpysrc,$PMsnd
      /copy qcpysrc,$PMrtv
      *
     OQSYSPRT   E            #HDG01         1 03
     O                       ZZUSR             +  0
     O                       COname              84
     O                                          126 'Page'
     O                       PAGE          Z    132
      *
     OQSYSPRT   E            #HDG01         1
     O                       UDATE         Y   +  0
     O                       ZZJOB              132
      *
     OQSYSPRT   E            #HDG01         2
     O                       CurTime           +  0 '0 .  .  '
     O                                           78 'Archived Spoolfile'
     O                       ZZPGM              132
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Job name . . . . . . . . .'
     O                       LGjob             +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Job user . . . . . . . . .'
     O                       LGuserid          +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Job number . . . . . . . .'
     O                       LGjobnbr          +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Spoolfile name . . . . . .'
     O                       LGspool           +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Spoolfile number . . . . .'
     O                       LGspnum           +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'User data  . . . . . . . .'
     O                       LGusrdta          +  1
      *
     OQSYSPRT   E            #DTL01         2
     O                                         +  0 'Form type  . . . . . . . .'
     O                       LGform            +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Email address  . . . . . .'
     O                       EmailAddr         +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Fax number . . . . . . . .'
     O                       FaxNumber         +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'From page number . . . . .'
     O                       PageOne       Z   +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'To page number . . . . . .'
     O                       PagesSent     Z   +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Pages including cover  . .'
     O                       PagesSent     Z   +  1
      *
     OQSYSPRT   E            #DTL01         2
     O                                         +  0 'Pages captured . . . . . .'
     O                       PagesSent     Z   +  1
      *
     OQSYSPRT   E            #DTL01         2
     O                                         +  0 'Status . . . . . . . . . .'
     O                       LGstatus          +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Date transmitted . . . . .'
     O                       LGddate           +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Time transmitted . . . . .'
     O                       LGdtime           +  1
      *
     OQSYSPRT   E            #DTL01         1
     O                                         +  0 'Pages transmitted  . . . .'
     O                       PagesSent     Z   +  1
