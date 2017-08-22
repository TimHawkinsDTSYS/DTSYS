      /TITLE Utility, Booking DB (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      * *********************************************************
      *  RtvNxtIseq() -- Retrieve next itinerary sequence.
      * *********************************************************
     P RtvNxtIseq      B                   Export
      *
     Fbkgafp01  if   e           k disk    static
     Fbkgajp01  if   e           k disk    static
     Fbkglsp01  if   e           k disk    static
      *
     D RtvNxtIseq      PI                  like(DFNbmlisq)
     D  RtvNxtIseqBkgm...
     D                                     like(DFNbkgma)
      *
     D bkgma         e ds                  extname(bkgmap01)
      *
     D bkgaf           ds                  likerec(bkgaf01r) inz
     D bkgaj           ds                  likerec(bkgaj01r) inz
     D bkgls           ds                  likerec(bkgls01r) inz
      *
     D RtnIseq         s                   like(DFNbmlisq)
      *---------------------------------------------------------
      *
      *   Set itinerary sequence number.
      *
š1b€ C                   eval      bkgma = RtvNxtIseqBkgm
š1b€ C                   exsr      $SetItnSeq
      *
š1b€ C                   return    BMlisq
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Set itinerary sequence number.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SetItnSeq    begsr
      *
š1b€ C                   dou       not %equal
     C                   eval      BMlisq += 1
     C     KYkey2        setll     bkgls01r
      *
š2b€ C                   if        not %equal
     C     KYkey2        setll     bkgaf01r
š2e€ C                   endif
      *
š2b€ C                   if        not %equal
     C     KYkey2        setll     bkgaj01r
š2e€ C                   endif
š1e€ C                   enddo
      *
     CSR   #SetItnSeq    endsr
      *
     C     KYkey2        klist
     C                   kfld                    BMbkgn
     C                   kfld                    BMlisq
      *
     P RtvNxtIseq      E
      ***********************************************************
      * RstHisbmBkgma() -- Restore history to booking master.
      ***********************************************************
     P RstHisbmBkgma   B                   Export
      *
     D RstHisbmBkgma   PI                  like(DFNbkgma)
     D  i_hisbm                            like(DFNhisbm) value
      *
     D  hisbm        e ds                  extname(hisbmp01) inz
     D  bkgma        e ds                  extname(bkgmap01) inz
      * ---------------------------------------------------------
      *
      * Restore history to booking master.
      *
      /free

       hisbm      = i_hisbm;
       clear        bkgma;

       BMbkgn     = HBbkgn;
       BMdepd     = HBdepd;
       BMbkgd     = HBbkgd;
       BMbsts     = HBbsts;
       //BMpxfn   = HBpxfn;
       BMpxln     = HBpxln;
       BMbkgtyp   = HBbkgtyp;
       BMbksdte   = HBbksdte;
       BMcxsdte   = HBcxsdte;
       BMagyn     = HBagyn;
       BMtaid     = HBtaid;
       BMtafn     = HBtafn;
       BMtaln     = HBtaln;
       BMtvla     = HBtvla;
       BMofcc     = HBofcc;
       BMdest     = HBdest;
       BMoper     = HBoper;
       BMgrpn     = HBgrpn;
       BMpcnt     = HBpcnt;
       BMctyp     = HBctyp;
       BMdlvs     = HBdlvs;
       BMmkgsrc   = HBmkgsrc;
       BMmkgtxt   = HBmkgtxt;
       BMnonrev   = HBnonrev;

       BMairprc = HBairprc;
       BMairtax = HBairtax;
       BMaircom = HBaircom;
       BMairttl = HBairttl;

       BMlndprc = HBlndprc;
       BMlndtax = HBlndtax;
       BMlndcom = HBlndcom;
       BMlndttl = HBlndttl;

       BMadjprc = HBadjprc;
       BMadjtax = HBadjtax;
       BMadjcom = HBadjcom;
       BMadjttl = HBadjttl;

       BMprcttl = HBprcttl;
       BMtaxttl = HBtaxttl;
       BMcomttl = HBcomttl;
       BMsubttl = HBsubttl;
       BMduettl = HBduettl;

       BMnairprc = HBnairprc;
       BMnairtax = HBnairtax;
       BMnairttl = HBnairttl;

       BMnlndprc = HBnlndprc;
       BMnlndtax = HBnlndtax;
       BMnlndttl = HBnlndttl;

       BMnadjprc = HBnadjprc;
       BMnadjtax = HBnadjtax;
       BMnadjttl = HBnadjttl;

       BMnsubttl = HBnsubttl;

       BMnrfttl  = HBnrfttl;
       BMcpdttl  = HBcpdttl;
       BMshpttl  = HBshpttl;
       BMccdttl  = HBccdttl;

       BMitnnet   = HBitnnet;
       BMtfhnet   = HBtfhnet;
       BMoutpay   = HBoutpay;

       BMpftamt   = HBpftamt;
       BMpftpct   = HBpftpct;

       BMbktmin   = HBbktmin;
       BMbktcst   = HBbktcst;

       BMresbns   = HBresbns;
       BMsupbns   = HBsupbns;
       BMslsbns   = HBslsbns;
       BMmgrbns   = HBmgrbns;

       return bkgma;

      /end-free
     P RstHisbmBkgma   E
      ***********************************************************
      * ClrBkgmaCostSummary() -- Clear booking master cost summary.
      ***********************************************************
     P ClrBkgmaCostSummary...
     P                 B                   Export
      *
     D ClrBkgmaCostSummary...
     D                 PI                  like(DFNbkgma)
     D  i_bkgma                            like(DFNbkgma) value
      *
     D  bkgma        e ds                  extname(bkgmap01) inz
      * ---------------------------------------------------------
      *
      * Clear booking master cost summary.
      *
      /free

       bkgma    = i_bkgma;

       BMairprc = *zero;
       BMairtax = *zero;
       BMaircom = *zero;
       BMairttl = *zero;

       BMlndprc = *zero;
       BMlndtax = *zero;
       BMlndcom = *zero;
       BMlndttl = *zero;

       BMadjprc = *zero;
       BMadjtax = *zero;
       BMadjcom = *zero;
       BMadjttl = *zero;

       BMprcttl = *zero;
       BMtaxttl = *zero;
       BMcomttl = *zero;
       BMsubttl = *zero;
       BMduettl = *zero;

       BMnairprc = *zero;
       BMnairtax = *zero;
       BMnairttl = *zero;

       BMnlndprc = *zero;
       BMnlndtax = *zero;
       BMnlndttl = *zero;

       BMnadjprc = *zero;
       BMnadjtax = *zero;
       BMnadjttl = *zero;

       BMnsubttl = *zero;

       return bkgma;

      /end-free
     P ClrBkgmaCostSummary...
     P                 E
      ***********************************************************
      * RtvNamAdrOfBkg() -- Retrieve name and address of booking.
      ***********************************************************
     P RtvNamAdrOfBkg  B                   Export
      *
     D RtvNamAdrOfBkg  PI                  like(t_RtvNamAdrOfBkg)
     D  P_bkgn                             like(dfnBMbkgn)
     D  P_options                          like(StdStr) const
     D                                     options(*nopass)
      *
     D DSparm        e ds                  extname(DSparm)   inz
     D d_NA            ds                  likeds(t_RtvNamAdrOfBkg)
      *
     D WKoptions       s                   like(p_options)
      * ---------------------------------------------------------
      *
      *    If there is no data then get out.
      *
     C                   if        p_bkgn = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Execute program to do the retrieve.
      *
     C                   eval      PLbkgn    = p_bkgn
     C                   eval      WKoptions = p_options
      *
     C                   call      'PR0508R'
     C                   parm                    DSparm
     C                   parm                    WKoptions
     C                   parm                    d_NA
      *
     C                   return    d_NA
      *
     P RtvNamAdrOfBkg  E
      * *********************************************************
      * AcmPndPay() - Accumulate pending payments.
      * *********************************************************
     P AcmPndPay       B                   Export
      *
     Fbkgpip01  if   e           k disk    static
      *
     D AcmPndPay       PI                  like(DFNBMrcvttl)
     D  i_bkgma                            like(DFNbkgma) value
      *
     D bkgpi           ds                  likerec(bkgpi01r)
     D bkgma         e ds                  extname(bkgmap01)
      *
     D WKrcvttl        s                   like(dfnBMrcvttl)
      * ---------------------------------------------------------
      *
      *    Bring in parameters.
      *
     C                   eval      bkgma    = i_bkgma
      *
      *    Include payments posted.
      *
     C                   eval      WKrcvttl = BMrcvttl
      * ---------------------------------------------------------
      *
      *    Accumulate pending paid.
      *
     C     BMbkgn        setll     bkgpi01r
     C     BMbkgn        reade     bkgpi01r      bkgpi
      *
     C                   dow       not %eof
     C                   select
     C                   when      bkgpi.BPstat = 'SND'   or
     C                             bkgpi.BPstat = 'APR'   or
     C                             bkgpi.BPstat = 'ERR'   or
     C                             bkgpi.BPstat = 'MAN'   or
     C                             bkgpi.BPstat = 'PUB'
     C                   eval      WKrcvttl += bkgpi.BPpamt
      *
     C                   when      bkgpi.BPstat = 'OPN'       and
     C                             %subst(bkgpi.BPbpty:1:2) = 'CK'
     C                   eval      WKrcvttl += bkgpi.BPpamt
     C                   endsl
      *
     C     BMbkgn        reade     bkgpi01r      bkgpi
     C                   enddo
      *
     c                   return    WKrcvttl
      *
     P AcmPndPay       E
      ***********************************************************
      * ChkSegErr() - Check for segment errors.
      ***********************************************************
     P ChkSegErr       B                   Export
      *
     D ChkSegErr       PI                  like(StdInd)
     D  BMbkgn_p                           like(dfnBMbkgn) const
      *
     D BMbkgn          s                   like(dfnBMbkgn)
      *
     D RtnErr          s                   like(StdInd)
      * ---------------------------------------------------------
      *
      *    Check for segment errors.
      *
     C                   call      'PR0555R'
     C                   parm      BMbkgn_p      BMbkgn
     C                   parm                    RtnErr
      *
š1b€ C                   return    RtnErr
      *
     P ChkSegErr       E
      * **********************************************************
      * FmtFltDes() - Format flight description.
      * **********************************************************
     P FmtFltDes       B                   Export
      *
     D FmtFltDes       PI                  like(StdTxt)
     D  i_bkgaf                            like(DFNbkgaf) const
     D  i_fmtcde                           like(StdChr)   const
      *
     D bkgaf         e ds                  extname(bkgafp01) inz
      *
     D o_FltDes        s                   like(StdTxt)   inz
      /free

       bkgaf    = i_bkgaf;
       o_FltDes = *blanks;

       // -----------------------------------------------------
       // 123456789.123456789.123456789.12345
       // UA 123   Y  HX0954A   SFO/HNL

       if i_fmtcde = '1';
          o_FltDes = BAcarr + ' ' + BAflit + ' ' +
                     BAclas + ' ' + BAadlfbas;

š1b€      if BAdcty <> *blanks;
             o_FltDes = %trim(o_FltDes) + ' ' +
                        BAdcty + '/' + BAacty;
š1e€      endif;
š1e€   endif;

       // -----------------------------------------------------
       // 123456789.123456789.123456789.12345
       // UA 123   Y  HX0954A   12:05p 13:20p

       if i_fmtcde = '2';
          o_FltDes = BAcarr + ' ' + BAflit    + ' ' +
                     BAclas + ' ' + BAadlfbas + ' ' +
                     EdtHMmed(BAdtim:BAdtap)  + ' ' +
                     EdtHMmed(BAatim:BAatap);
š1e€   endif;

       // -----------------------------------------------------
       // 123456789.123456789.123456789.12345
       // UA 123  12/01/06 SFO/HNL

       if i_fmtcde = '3';
          o_FltDes = BAcarr + ' ' + BAflit + ' ' +
                     EdtMDYfromISO(BAused);

š1b€      if BAdcty <> *blanks;
             o_FltDes = %trim(o_FltDes) + ' ' +
                        BAdcty + '/' + BAacty;
š1e€      endif;
š1e€   endif;

       // -----------------------------------------------------
       // 123456789.123456789.123456789.12345
       // SFO/HNL UA 1234 Y

       if i_fmtcde = '4';
          o_FltDes = BAdcty + '/' + BAacty + ' ' +
                     BAcarr + ' ' + BAflit + ' ' +
                     BAclas;
š1e€   endif;

       // -----------------------------------------------------
       // 123456789.123456789.123456789.12345
       // UA 1234 SFO/HNL 12:05p 13:20p

       if i_fmtcde = '5';
          o_FltDes = BAcarr + ' ' + BAflit   + ' ' +
                     BAdcty + '/' + BAacty   + ' ' +
                     EdtHMmed(BAdtim:BAdtap) + ' ' +
                     EdtHMmed(BAatim:BAatap);
š1e€   endif;

       return o_FltDes;

      /End-Free
     P FmtFltDes       E
      * *********************************************************
      * RtvBkgEmail() -- Retrieve main booking email address.
      * -- Options = *AGYINV=Agency invoice
      * --           *CUSINV=Customer invoice
      * *********************************************************
     P RtvBkgEmail     B                   Export

     Fbkgmap01  if   e           k disk    static
     Fagymap01  if   e           k disk    static
     Fagtmap01  if   e           k disk    static
     Fpaxadp01  if   e           k disk    static

     D RtvBkgEmail     PI                  like(dfnAMemail)
     D  P_bkgn                             like(dfnBMbkgn)
     D  Options                            like(StdStr) const
     D                                     options(*nopass)

     D agyma           ds                  likerec(agyma01r) inz
     D agtma           ds                  likerec(agtma01r) inz
     D bkgma           ds                  likerec(bkgma01r) inz
     D paxad           ds                  likerec(paxad01r) inz

     D WKoptions       s                   like(StdStr)         inz
     D WKtyp           s                   like(StdNam)         inz
     D WKinv           s                   like(bkgma.BMagyinv) inz
     D WKemail         s                   like(agyma.AMemail)  inz
      /free

       // ------------------------------------------------------
       //Retrieve booking master.

       chain (P_bkgn) bkgma01r bkgma;
š1b€   if not %found;
šGO€      return *blanks;
š1e€   endif;

       // ------------------------------------------------------
       //Check options.

       if %parms >= 2;
          WKoptions = options;
š1x€   else;
          WKoptions = '*AGYINV';
š1x€   endif;

       select;
       when %scan('*AGYINV':WKoptions) > *zero;
š1x€        WKtyp = '*AGYINV';
š1x€        WKinv = bkgma.BMagyinv;

       when %scan('*CUSINV':WKoptions) > *zero;
š1x€        WKtyp = '*CUSINV';
š1x€        WKinv = bkgma.BMcusinv;
š1e€   endsl;

       // ------------------------------------------------------
       //Retrieve agency.

       if  WKinv  = '1'    or
           WKinv  = '2'    or
           WKinv  = '11'   or
           WKinv  = '12';

           chain (bkgma.BMagyn) agyma01r agyma;
           if not %found;
              return *blanks;
           endif;

           if (WKinv  = '11'   or
               WKinv  = '12')  and
               agyma.AMmstnbr <> *zero;

               chain (agyma.AMmstnbr) agyma01r agyma;
               if not %found;
                 return *blanks;
               endif;
           endif;
       endif;

       // ------------------------------------------------------
       //Retrieve agent.

       if  WKinv  = '3'   or
           WKinv  = '4'   or
           WKinv  = '5'   or
           WKinv  = '6';

           chain (bkgma.BMagyn:bkgma.BMtaid) agtma01r agtma;
           if not %found;
              clear agtma;
           endif;
       endif;

       // ------------------------------------------------------
       //Retrieve passenger address.

       if  WKinv  = '7'    or
           WKinv  = '8'    or
           WKinv  = '9'    or
           WKinv  = '10';

           chain (bkgma.BMbkgn) paxad01r paxad;
           if not %found;
              clear paxad;
           endif;
       endif;

       // ------------------------------------------------------
       //Determine where to send documents.

       //    1=Agency email
       select;
       when  WKinv   = '1';
             WKemail = agyma.AMemail;

       //    2=Agency fax
       when  WKinv   = '2';
             WKemail = agyma.AMfaxp;

       //    3=Agents office email
       when  WKinv   = '3';
             WKemail = agtma.ANoemail;

       //    4=Agents office fax
       when  WKinv   = '4';
             WKemail = agtma.ANofaxp;

       //    5=Agents home email
       when  WKinv   = '5';
             WKemail = agtma.ANhemail;

       //    6=Agents home fax
       when  WKinv   = '6';
             WKemail = agtma.ANhfaxp;

       //    7=Passenger email
       when  WKinv   = '7';
             WKemail = paxad.PAemail;

       //    8=Passenger fax
       when  WKinv   = '8';
             WKemail = paxad.PAfaxp;

       //    9=Other email
       when  WKinv   = '9'            and
             WKtyp   = '*AGYINV';
             WKemail = paxad.PAagyinve;

       //    9=Other email
       when  WKinv   = '9'            and
             WKtyp   = '*CUSINV';
             WKemail = paxad.PAcusinve;

       //    10=Other fax
       when  WKinv   = '10'           and
             WKtyp   = '*AGYINV';
             WKemail = paxad.PAagyinvf;

       //    10=Other fax
       when  WKinv   = '10'           and
             WKtyp   = '*CUSINV';
             WKemail = paxad.PAcusinvf;

       //    11=Master email
       when  WKinv   = '11';
             WKemail = agyma.AMemail;

       //    12=Master fax
       when  WKinv   = '12';
             WKemail = agyma.AMfaxp;
       other;

             WKemail = *blanks;
       endsl;

       return WKemail;

      /end-free
     P RtvBkgEmail     E
