      /TITLE Application Driver, Application Selection
      *
      * P: PARMS dftactgrp(*no) actgrp(app200r)
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  09/05/06  TimH        Corrected to check for display file errors
      *                         and reformat RPG.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      /COPY QCPYSRC,Hspec
      *
     Fapp200d   cf   e             workstn usropn
     F                                     infds(dsdsp)
     F                                     sfile(#appsltsfl:rrn1)
     Fapp010p   if   e           k disk    usropn
     Fapp100p   uf   e           k disk    usropn
     Fapp100l1  if   e           k disk    usropn
     F                                     rename(app100r:app1001l)
     Fapp110p   if   e           k disk    usropn
      *
     D*Today           s                   like(NumISO)  inz
     D chgseq          s                   like(StdInd)  inz
     D curgrpn         s                   like(StdInt)  inz
     D WrkDteISO       s                   like(DteISO)  inz
     D error           s                   like(StdInd)  inz
     D prvgrpn         s                   like(curgrpn) inz
     D rrn1            s                   like(RRn1rn)  inz
     D rrn1ad          s                   like(RRn1rn)  inz
     D rrn1pv          s                   like(RRn1rn)  inz
     D svapcd          s                   like(adapcd)  inz
     D svlock          s                   like(adlock)  inz
     D svseqn          s                   like(auseqn)  inz
     D svtext          s                   like(adtext)  inz
     D torel           s                   like(StdNam)  inz
      *
      /COPY QCPYSRC,Dspec
      *
     C                   exsr      $rtvusrinf
      *
š1b€ C                   if        AIapcd <> '*NONE'  and
     C                             AIapcd <> *blanks
     C                   exsr      $default
š1x€ C                   else
     C                   exsr      $dspenvslt
š1e€ C                   endif
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *APPLICATION DefaultED.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $default      begsr
      *
     C                   open      app010p
     C     AIapcd        chain     app010r
     C                   close     app010p
š1b€ C                   if        %found
     C                   exsr      $strenv
š1e€ C                   endif
      *
     CSR   #default      endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *DISPLAY APPLICATION SELECTION SUBFILE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $dspenvslt    begsr
      *
     C                   exsr      $loadsfl
      *
š1b€ C                   dou       Z2aid = exit  or
     C                             Z2aid = cancel
     C                   eval      *in91 = putovr
     C                   write(e)  #clrscn
š2b€ C                   if        rrn1ad <> *zero
     C                   eval      *in80 = *on
š2e€ C                   endif
     C                   eval      *in81 = *on
     C                   write(e)  #msgctl
     C                   write(e)  #appsltrcd
     C                   exfmt(e)  #appsltctl
     C                   exsr      $chkpnlerr
     C                   exsr      $PMclr
     C                   eval      *in80 = *off
     C                   eval      *in81 = *off
     C                   eval      error = *off
     C                   exsr      $pfkeys
      *
š2b€ C                   if        not *in90
     C                   exsr      $readchged
     C                   eval      Z2aid = *blanks
š2e€ C                   endif
š1e€ C                   enddo
      *
     CSR   #dspenvslt    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *CLEAR SUBFILE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $clrsfl       begsr
      *
      *
     C                   eval      rrn1 = *zero
     C                   eval      rrn1ad = *zero
     C                   eval      RRn1rn = *zero
     C                   eval      rrn1pv = *zero
     C                   eval      *in83 = *on
     C                   write(e)  #appsltctl
     C                   exsr      $chkpnlerr
     C                   eval      *in83 = *off
     C     ZZusr         setll     app1001l
      *
     CSR   #clrsfl       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *LOAD SUBFILE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $loadsfl      begsr
      *
     C                   open      app100l1
     C                   open      app010p
     C                   exsr      $clrsfl
      *
     C                   eval      rrn1pv = rrn1ad
     C                   clear                   prvgrpn
     C     ZZusr         setll     app1001l
     C     ZZusr         reade     app1001l
      *
š1b€ C                   dow       not %eof
     C     auapcd        chain     app010r
š3b€ C                   if        not %found
     C                   eval      ADtext = 'Application ' +
     C                                      %trim(AUapcd) +
     C                                      ' not found'
š3e€ C                   endif
      *
      *   If group has changed to next series of 100, write blank line.
      *
š3b€ C                   if        rrn1ad <> *zero
     C     auseqn        div       100           curgrpn
š4b€ C                   if        curgrpn <> prvgrpn
     C                   eval      prvgrpn = curgrpn
     C                   exsr      $wrtblank
š4e€ C                   endif
š3e€ C                   endif
      *
š3b€ C                   if        ADlock = 'Y'
     C                   eval      locked = 'Unavailable'
š3e€ C                   else
     C                   eval      locked = *blanks
š3e€ C                   endif
      *
     C                   eval      rrn1ad += 1
     C                   eval      rrn1 = rrn1ad
     C                   exsr      $setsflind
     C                   write(e)  #appsltsfl
     C                   exsr      $chkpnlerr
      *
     C     ZZusr         reade     app1001l
š1e€ C                   enddo
      *
š1b€ C                   if        RRn1rn = *zero  or
     C                             rrn1ad <> rrn1pv
     C                   eval      rrn1rn += 1
š1e€ C                   endif
      *
     C                   close     app100l1
     C                   close     app010p
      *
     CSR   #loadsfl      endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Write a blank line.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $wrtblank     begsr
      *
     C                   eval      svapcd = adapcd
     C                   eval      svtext = adtext
     C                   eval      svseqn = auseqn
     C                   eval      svlock = adlock
      *
     C                   clear                   adapcd
     C                   clear                   adtext
     C                   clear                   auseqn
     C                   clear                   adlock
     C                   clear                   locked
      *
     C                   eval      *in40 = *on
     C                   eval      *in41 = *on
     C                   eval      rrn1ad += 1
     C                   eval      rrn1 = rrn1ad
     C                   write(e)  #appsltsfl
     C                   exsr      $chkpnlerr
      *
     C                   eval      adapcd = svapcd
     C                   eval      adtext = svtext
     C                   eval      auseqn = svseqn
     C                   eval      adlock = svlock
      *
     CSR   #wrtblank     endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *READ CHANGED SUBFILE RECORDS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $readchged    begsr
      *
     C                   eval      rrn1rn = Z2sfrc
     C                   readc(e)  #appsltsfl
      *
š1b€ C                   dow       not %eof
     C                   exsr      $chkpnlerr
      *
      *   Update sequence number.
      *
š3b€ C                   if        chgseq = *on
     C                   eval      svseqn = auseqn
     C                   open      app100p
     C     AUkey2        chain     app100r
š4b€ C                   if        %found
     C                   eval      auseqn = svseqn
     C                   update    app100r
š4e€ C                   endif
     C                   close     app100p
š3e€ C                   endif
      *
      *   Start selected environment.
      *
š3b€ C                   if        option = '1'
     C                   exsr      $strenv
š1v€ C                   leave
š3e€ C                   endif
      *
     C                   readc(e)  #appsltsfl
š1e€ C                   enddo
      *
      *   Refresh subfile.
      *
     C                   exsr      $loadsfl
      *
     CSR   #readchged    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *START ENVIRONMENT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $strenv       begsr
      *
     C                   open      app010p
     C     adapcd        chain     app010r
     C                   close     app010p
š1b€ C                   if        not %found    or
     C                             ADlock = 'Y'
     C                   write(e)  #clrscn
     C                   write(e)  #msgctl
     C                   exfmt(e)  #applck
     C                   exsr      $chkpnlerr
     C                   eval      Z2aid = *blanks
     C                   eval      error = *on
šGO€ C                   goto      #strenv
š1e€ C                   endif
      *
š1b€ C                   if        error = *off  and
     C                             adgrpu <> *blank
     C                   exsr      $setgrpprf
š1e€ C                   endif
      *
š1b€ C                   if        not %error and
     C                             error = *off
     C                   close     app200d
     C                   call(e)   'APP200C'
     C                   parm                    adapcd
     C                   parm                    adseqn
     C                   parm                    adtext
     C                   parm                    adcmd
     C                   parm                    adlibl
     C                   parm                    error
     C                   open      app200d
š1e€ C                   endif
      *
š1b€ C                   if        %error  or
     C                             error = *on
     C                   write(e)  #clrscn
     C                   write(e)  #msgctl
     C                   exfmt(e)  #apperr
     C                   exsr      $chkpnlerr
š2b€ C                   if        AIapcd <> '*NONE'
     C                   exsr      $signoff
š2e€ C                   endif
š1e€ C                   endif
      *
     CSR   #strenv       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Set group profile on the current user.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $setgrpprf    begsr
      *
     C                   eval      cmdstg = 'TAATOOL/CHGGRPPRF ' +
     C                             'GRPPRF(' + %TRIM(ADGRPU) + ')'
      *
     C                   call(e)   'QCMDEXC'
     C                   parm                    cmdstg
     C                   parm                    cmdlen
      *
     C                   exsr      $cmdexcerr
      *
     CSR   #setgrpprf    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *RETRIEVE USER INFORMATION.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $rtvusrinf    begsr
      *
     C                   open      app110p
     C     ZZusr         chain     app110r
     C                   close     app110p
      *
š1b€ C                   if        not %found
     C                   eval      *inLR = *on
     C                   write(e)  #clrscn
     C                   write(e)  #msgctl
     C                   eval      errtxt = 'User record not found.'
     C                   exfmt(e)  #usrsetup
     C                   exsr      $chkpnlerr
     C                   exsr      $signoff
š1e€ C                   endif
      *
š1b€ C                   if        AIapcd = '*NONE'
     C                   open      app100p
     C     ZZusr         chain     app100r
     C                   close     app100p
      *
š2b€ C                   if        not %found
     C                   eval      *inLR = *on
     C                   write(e)  #clrscn
     C                   write(e)  #msgctl
     C                   eval      errtxt = 'No default and no apps.'
     C                   exfmt(e)  #usrsetup
     C                   exsr      $chkpnlerr
     C                   exsr      $signoff
š2e€ C                   endif
š1e€ C                   endif
      *---------------------------------------------------------
      *
      *   Have user update their information once every 90 days.
      *
     C                   leavesr
      *
     C     *usa          move      *date         WrkDteISO
     C                   movel     WrkDteISO     Today
      *
š1b€ C                   if        AIupdd = *zero
     C                   eval      AIupdd = today
š1e€ C                   endif
      *
     C                   eval      @dfdte = AIupdd
     C                   eval      @ddays = 90
     C                   exsr      $adddt
      *
š1b€ C                   if        @dtdte < today
     C                   call(e)   'APP210R'
š1e€ C                   endif
      *
     CSR   #rtvusrinf    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Set subfile indicators.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $setsflind    begsr
      *
š1b€ C                   if        chgseq
     C                   eval      *in40 = *on
     C                   eval      *in41 = *off
š1x€ C                   else
     C                   eval      *in40 = *off
     C                   eval      *in41 = *on
š1e€ C                   endif
      *
     C                   eval      option = *blanks
      *
     CSR   #setsflind    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *PF keys.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $pfkeys       begsr
      *
      *   F6=Display  bulletin boards.
      *
š1b€ C                   if        Z2aid = f6
     C                   call(e)   'QCMDEXC'
     C                   parm      'DSPUSRBBD'   cmdstg
     C                   parm                    cmdlen
      *
     C                   exsr      $cmdexcerr
š1e€ C                   endif
      *
      *   F10=Change sequence
      *   -- *in40=on  DSPATR(ND PR) option
      *   -- *in41=on  DSPATR(ND PR) auseqn
      *
š1b€ C                   if        Z2aid = f10
š2b€ C                   if        chgseq
     C                   eval      chgseq = *off
     C                   eval      *in40 = *off
     C                   eval      *in41 = *on
š2x€ C                   else
     C                   eval      chgseq = *on
     C                   eval      *in40 = *on
     C                   eval      *in41 = *off
š2e€ C                   endif
     C                   exsr      $loadsfl
šLV€ C                   leavesr
š1e€ C                   endif
      *
      *   F3=Exit.
      *
š1b€ C                   if        Z2aid = exit
     C                   eval      *inLR = *on
     C                   return
š1e€ C                   endif
      *
     CSR   #pfkeys       endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Sign off.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $signoff      begsr
      *
     C                   eval      cmdstg = 'SIGNOFF LOG(*LIST)'
      *
     C                   call(e)   'QCMDEXC'
     C                   parm                    cmdstg
     C                   parm                    cmdlen
      *
     C                   exsr      $cmdexcerr
     C                   eval      *inLR = *on
     C                   return
      *
     CSR   #signoff      endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *QCMDEXC Error handing.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $cmdexcerr    begsr
      *
š1b€ C                   if        %error
     C                   eval      error  = *on
     C                   eval      msgid  = 'DTD0290'
     C                   eval      msgdta = cmdstg
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
š1x€ C                   else
     C                   exsr      $PMclr
š1e€ C                   endif
      *
     CSR   #cmdexcerr    endsr
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      /COPY QCPYSRC,$ChkPnlErr
      /SPACE 3
      /COPY QCPYSRC,$ADDDT
      /SPACE 3
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Clear program message queue.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMclr        begsr
      *
š1b€ C                   if        topgm = *blanks
     C                   eval      topgm = '*'
š1e€ C                   endif
      *
š1b€ C                   if        torel  = '*PRV'
     C                   eval      pgmstk = x'00000001'
š1x€ C                   else
     C                   eval      pgmstk = *loval
š1e€ C                   endif
      *
     C                   call(e)   'QMHRMVPM'
     C                   parm                    topgm            10
     C                   parm                    pgmstk            4
     C                   parm      *blanks       msgkey            4
     C                   parm      '*ALL'        rmvopt           10
     C                   parm      *loval        rtncde            4
      *
     C                   eval      torel = *blanks
      *
     CSR   #pmclr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     C                   open      app200d
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $defn         begsr
      *
     C     AUkey2        klist
     C                   kfld                    ZZusr
     C                   kfld                    ADapcd
      *
     CSR   #defn         endsr
