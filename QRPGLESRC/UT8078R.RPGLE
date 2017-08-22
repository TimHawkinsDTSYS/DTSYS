      /TITLE Utility, Performance tracking (SrvPgm)
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
      * WrtJobTrk() -- Write job tracking.
      * -- this routine should replace the previous WrtJobTrk
      *    procedure because it allows for *NOPASS, which makes
      *    it behave more like the command interface.
      * *********************************************************
     P WrtJobTrk2      B                   Export
      *
     D WrtJobTrk2      PI
     D  p_bgnend                           like(StdNam) const
     D                                     options(*nopass)
     D  p_job                              like(StdNam) const
     D                                     options(*nopass)
     D  p_step                             like(StdNam) const
     D                                     options(*nopass)
     D  p_text                             like(StdTxt) const
     D                                     options(*nopass)
     D  p_dattyp                           like(StdNam) const
     D                                     options(*nopass)
      *
     D  bgnend         s                   like(StdNam)
     D  job            s                   like(StdNam)
     D  step           s                   like(StdNam)
     D  text           s                   like(StdTxt)
     D  dattyp         s                   like(Stdnam)
      * --------------------------------------------------------
      *
      *   Send parameters used.
      *
     C                   if        %parms >= 1
     C                   eval      bgnend  = p_bgnend
     C                   endif
      *
     C                   if        %parms >= 2
     C                   eval      job     = p_job
     C                   endif
      *
     C                   if        %parms >= 3
     C                   eval      step    = p_step
     C                   endif
      *
     C                   if        %parms >= 4
     C                   eval      text    = p_text
     C                   endif
      *
     C                   if        %parms >= 5
     C                   eval      dattyp  = p_dattyp
     C                   endif
      * --------------------------------------------------------
      *
      *   Write job tracking.
      *
     C                   call      'UT0800R'
     C                   parm                    bgnend
     C                   parm                    job
     C                   parm                    step
     C                   parm                    text
     C                   parm                    dattyp
     C
     C                   return
      *
     P WrtJobTrk2      E
      * *********************************************************
      * StrSrvJobTrn() -- Start service job transaction.
      * *********************************************************
     P StrSrvJobTrn    B                   Export
      *
     D StrSrvJobTrn    PI
     D  P_jbna                             like(StdNam) const
     D                                     options(*omit:*nopass)
     D  P_strd                             like(NumISO) const
     D                                     options(*omit:*nopass)
     D  P_strt                             like(NumHMS) const
     D                                     options(*nopass)
      *
     D  SJjbna         s                   like(StdNam) inz
     D  SJstrd         s                   like(NumISO) inz
     D  SJstrt         s                   like(NumHMS) inz
     D  option         s                   like(StdNam) inz
      * --------------------------------------------------------
      *
      *   Inbound parameters.
      *
     C                   if        %parms >= 1
     C                   eval      SJjbna = P_jbna
     C                   else
     C                   eval      SJjbna = *blanks
     C                   endif
      *
     C                   if        %parms >= 2
     C                   eval      SJstrd = P_strd
     C                   else
     C                   eval      SJstrd = *zero
     C                   endif
      *
     C                   if        %parms >= 3
     C                   eval      SJstrt = P_strt
     C                   else
     C                   eval      SJstrt = *zero
     C                   endif
      * --------------------------------------------------------
      *
      *   Update service job transaction.
      *
     C                   call      'SJ0500R'
     C                   parm                    SJjbna
     C                   parm                    SJstrd
     C                   parm                    SJstrt
     C                   parm      '*START'      option
     C
     C                   return
      *
     P StrSrvJobTrn    E
      * *********************************************************
      * EndSrvJobTrn() -- End service job transaction.
      * *********************************************************
     P EndSrvJobTrn    B                   Export
      *
     D EndSrvJobTrn    PI
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      *
     D  SJjbna         s                   like(StdNam) inz
     D  SJstrd         s                   like(NumISO) inz
     D  SJstrt         s                   like(NumHMS) inz
     D  option         s                   like(StdNam) inz
      * --------------------------------------------------------
      *
      *   Inbound parameters.
      *
     C                   if        %parms >= 1
     C                   eval      SJjbna = P_jbna
     C                   else
     C                   eval      SJjbna = *blanks
     C                   endif
      * --------------------------------------------------------
      *
      *   Update service job transaction.
      *
     C                   call      'SJ0500R'
     C                   parm                    SJjbna
     C                   parm                    SJstrd
     C                   parm                    SJstrt
     C                   parm      '*END'        option
     C
     C                   return
      *
     P EndSrvJobTrn    E
      * *********************************************************
      * StrSrvJob() -- Start service job.
      * *********************************************************
     P StrSrvJob       B                   Export
      *
     D StrSrvJob       PI
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      *
     D  SJjbna         s                   like(StdNam)
     D  option         s                   like(StdNam)
      * --------------------------------------------------------
      *
      *   Inbound parameters.
      *
     C                   if        %parms < 1
     C                   eval      SJjbna = *blanks
     C                   else
     C                   eval      SJjbna = P_jbna
     C                   endif
      * --------------------------------------------------------
      *
      *   Update service job.
      *
     C                   call      'SJ0501R'
     C                   parm                    SJjbna
     C                   parm      '*START'      option
     C
     C                   return
      *
     P StrSrvJob       E
      * *********************************************************
      * EndSrvJob() -- End service job
      * *********************************************************
     P EndSrvJob       B                   Export
      *
     D EndSrvJob       PI
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      *
     D  SJjbna         s                   like(StdNam)
     D  option         s                   like(StdNam)
      * --------------------------------------------------------
      *
      *   Inbound parameters.
      *
     C                   if        %parms < 1
     C                   eval      SJjbna = *blanks
     C                   else
     C                   eval      SJjbna = P_jbna
     C                   endif
      * --------------------------------------------------------
      *
      *   Update service job
      *
     C                   call      'SJ0501R'
     C                   parm                    SJjbna
     C                   parm      '*END'        option
     C
     C                   return
      *
     P EndSrvJob       E
      ***********************************************************
      * DstSrvJobReq() -- Distribute service job request.
      ***********************************************************
     P DstSrvJobReq    B                   Export
      *
     Fctlsjl02  uf   e           k disk    rename(ctlsj01r:ctlsj02L)
     F                                     static
      *
     D DstSrvJobReq    PI                  like(StdNam)
     D  P_jbna                             like(StdNam) const
     D                                     options(*nopass)
      *
     D ctlsj           ds                  likerec(ctlsj02l) inz
      *
     D DstJobNam       s                   like(StdNam) inz

      /free
       // --------------------------------------------------------
       // Distribute request.

       chain (P_jbna) ctlsj02l ctlsj;
       if %found;
          DstJobNam = ctlsj.SJjbna;
          ctlsj.SJlustsp = %char(TimeStamp());
          update ctlsj02l ctlsj;
       else;
          DstJobNam = %trim(P_jbna) + '01';
       endif;

       return DstJobNam;

      /end-free
     P DstSrvJobReq    E
      /eof
      * *********************************************************
      * StrTrnPfrTrk() -- Start transaction performance tracking.
      * -- options: number of entries when the record is written
      *    *MSGQ:queuename
      *    *DTAQ:queuename
      * *********************************************************
     P StrTrnPfrTrk    B                   Export
      *
     FESpfrtrk1 o  a e             disk    block(*no) static
     F                                     rename(pfrtrkr:pfrtrkr1)
      *
     D StrTrnPfrTrk    PI                  like(StdInt)
     D  TrnTyp_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  StrTsp_p                           like(StdTsp) const
     D                                     options(*nopass:*omit)
     D  option_p                           like(StdStr) const
     D                                     options(*nopass:*omit)
      *
     D DSpfrtrk_O      ds                  likerec(pfrtrkr1:*output) inz
      *
     D ChkTrkEna       s                   like(StdInd) inz static
     D PfrTrkEna       s                   like(StdInd) inz static
     D TrnTyp          s                   like(StdNam) inz
     D StrTsp          s                   like(StdTsp) inz
     D option          s                   like(StdStr) inz
     D QueNam          s                   like(StdNam) inz
      /free
       // -------------------------------------------------------
       // Extract incomming parms.

       if %parms >= 1;
         CEETSTA(ParmPassed:1:*omit);
         if ParmPassed = 1;
            TrnTyp = TrnTyp_p;
         endif;
       endif;

       if %parms >= 2;
         CEETSTA(ParmPassed:1:*omit);
         if ParmPassed = 2;
            StrTsp = StrTsp_p;
         endif;
       endif;

       if %parms >= 3;
         CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            Option = Option_p;
         endif;
       endif;
       // -------------------------------------------------------
       // Check if performance tracking is enabled.

       if not ChkTrkEna;
          ChkTrkEna = *on;

          if RtvAppCtlDta('SYSTEM VALUES':'PERFORMANCE TRACKING') = '*YES';
             PfrTrkEna = *on;
          endif;
       endif;

       if not PfrTrkEna;
          return *zero;
       endif;

       // -------------------------------------------------------
       // Set queue name.

       select;
       when %scan('*MSGQ':Option) <> *zero;
            QueNam = %subst(Option:%scan('*MSGQ':Option)+6);

       when %scan('*DTAQ':Option) <> *zero;
            QueNam = %subst(Option:%scan('*DTAQ':Option)+6);
       endsl;

       // -------------------------------------------------------
       // Set key values.

       DSpfrtrk_O.PTjobnam = RtvJobNam();
       DSpfrtrk_O.PTjobusr = RtvJobUsr();
       DSpfrtrk_O.PTjobnbr = RtvJobNbr();
       DSpfrtrk_O.PTtrntyp = TrnTyp;
       DSpfrtrk_O.PTtrnid  = RtvRecID('ESPFRTRK');

       // -------------------------------------------------------
       // Set the performance tracking start timestamp.

       if StrTsp = NullTSP;
          DSpfrtrk_O.PTStrTsp = %char(TimeStamp());
       else;
          DSpfrtrk_O.PTStrTsp = %char(StrTsp);
       endif;

       DSpfrtrk_O.PTendtsp = %char(NullTSP);
       DSpfrtrk_O.PTelpsec = *zero;

       // -------------------------------------------------------
       // Set the number of transactions awaiting procesing.

       select;
       when %scan('*MSGQ':Option) <> *zero;
            DSpfrtrk_O.PTtrnwat = RtvMsgqEnt(QueNam);

       when %scan('*DTAQ':Option) <> *zero;
            DSpfrtrk_O.PTtrnwat = RtvDtaqEnt(QueNam);
       endsl;

       // -------------------------------------------------------
       // Write the performance tracking record.

       write pfrtrkr1 DSpfrtrk_O;

       // -------------------------------------------------------
       // Return transaction ID for the EndTrnPfrTrk().

       return DSpfrtrk_O.PTtrnid;

      /end-free
     P StrTrnPfrTrk    E
      * *********************************************************
      * EndTrnPfrTrk() -- End transaction performance tracking.
      * *********************************************************
     P EndTrnPfrTrk    B                   Export
      *
     FESpfrtrk1 uf   e           k disk    static
     F                                     rename(pfrtrkr:pfrtrkr1)
      *
     D EndTrnPfrTrk    PI
     D  TrnID_p                            like(StdInt) const
     D  option_p                           like(StdStr) const
     D                                     options(*nopass:*omit)
      *
     D DSpfrtrk_I      ds                  likerec(pfrtrkr1:*input)  inz
     D DSpfrtrk_O      ds                  likerec(pfrtrkr1:*output) inz
      *
     D TrnID           s                   like(StdInt) inz
     D option          s                   like(StdStr) inz
     D QueNam          s                   like(StdNam) inz
      /free
       // -------------------------------------------------------
       // Extract incomming parms.

       TrnID = TrnID_p;

       if %parms >= 2;
         CEETSTA(ParmPassed:2:*omit);
         if ParmPassed = 1;
            Option = Option_p;
         endif;
       endif;
       // -------------------------------------------------------
       // If no transaction ID, escape.

       if TrnID = *zero;
          return;
       endif;

       // -------------------------------------------------------
       // Retrieve the performance tracking record.

       chain (TrnID) pfrtrkr1 DSpfrtrk_I;
       if not %found;
          return;
       endif;

       DSpfrtrk_O = DSpfrtrk_I;

       // -------------------------------------------------------
       // Elapsed time for this transaction.

       DSpfrtrk_O.PTendtsp = %char(TimeStamp());

       monitor;
         DSpfrtrk_O.PTelpsec = %diff(%timestamp(DSpfrtrk_O.PTendtsp):
                                     %timestamp(DSpfrtrk_O.PTStrTsp):
                                     *mSeconds) / 1000000;
       on-error;
         DSpfrtrk_O.PTelpsec = *zero;
       endmon;

       // -------------------------------------------------------
       // Update the performance tracking record.

       if %found;
          update pfrtrkr1 DSpfrtrk_O;
       endif;

      /end-free
     P EndTrnPfrTrk    E
