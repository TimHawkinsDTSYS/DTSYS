      /TITLE Utility, Spoolfile (SrvPgm)
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
      /define dfnEmlStmf
      *copy qcpysrc,UT8301S
      /copy qcpysrc,UT8055S
      /copy qcpysrc,Dspec
      * *********************************************************
      * CrtPDFcnvdir() -- Create PDF conversion directory
      * *********************************************************
     P CrtPDFcnvdir    B                   Export

     D CrtPDFcnvdir    PI                  like(StdStr)

      /free
       // -------------------------------------------------------
       // Retrieve environment.

       owner  = RtvObjOwn();

       // -------------------------------------------------------
       // Create PDF Conversion directory.

       BasePath = '/home/' + %trim(RtvCurEnv()) + '/PDFcnv';
       CrtDirPth(BasePath);
       ChgIFSown(BasePath:owner);
       //ChgIFSaut(BasePath:owner);

       return BasePath;

      /end-free

     P CrtPDFcnvdir    E
      * *********************************************************
      * CvtSplf() -- Convert spoolfile to PDF/TXT/HTM.
      * *********************************************************
     P CvtSplf         B                   Export

     D CvtSplf         PI
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  EmlTyp                             like(StdNam)    const
     D  Options_                           like(StdTxt)    const
     D                                     options(*nopass)

     D  Options        s                   like(StdTxt) inz

      /free
       // -------------------------------------------------------
       // Setup parameters.

       if %parms >= 8;
          Options = Options_;
       endif;

       // -------------------------------------------------------
       // Convert based on email type.

       select;
         when EmlTyp = 'PDF'    or
              EmlTyp = *blanks;
         CvtSplfPDF(JobNam:JobUsr:JobNbr:SplfName:SplfNbr:Stmf:Options);

         when EmlTyp = 'TXT';
         CvtSplfTXT(JobNam:JobUsr:JobNbr:SplfName:SplfNbr:Stmf:Options);

         when EmlTyp = 'HTM';
         CvtSplfHTM(JobNam:JobUsr:JobNbr:SplfName:SplfNbr:Stmf:Options);
       endsl;

      /end-free

     P CvtSplf         E
      * *********************************************************
      * CvtSplfTXT() -- Convert spoolfile to TXT
      * *********************************************************
     P CvtSplfTXT      B                   Export

     D CvtSplfTXT      PI
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)

     D todir           s                   like(StdStr) inz
     D tostmf          s                   like(StdStr) inz

      /free

       // -------------------------------------------------------
       // Remove streamfile if it exists.

       joblog('unlink ' + %trim(stmf));
       UnLink(%trim(stmf));
       ToDir  = ExtDir(stmf);
       ToStmf = ExtFile(stmf);

       // -------------------------------------------------------
       // Convert spoolfile to TXT.

       System('MMAIL/CVTSPLSTMF fromfile('  + %trim(SplfName) + ') ' +
                                'job('      + %trim(JobNbr)   + '/'  +
                                              %trim(JobUsr)   + '/'  +
                                              %trim(JobNam)   + ') ' +
                                'tostmf(''' + %trim(ToStmf)   + ''') ' +
                                'todir('''  + %trim(ToDir)    + ''') ' +
                                'splnbr('   + %char(SplfNbr)  + ') ' +
                                'tofmt(*text) ' +
                                'stmfopt(*replace)');

       // -------------------------------------------------------
       // Delete spoolfile.

       if %parms >= 7           and
          %scan('*DLTSPLF':Options) <> *zero;
          DltSplf(SplfName);
       endif;

      /end-free

     P CvtSplfTXT      E
      * *********************************************************
      * CvtSplfHTM() -- Convert spoolfile to HTM
      * *********************************************************
     P CvtSplfHTM      B                   Export

     D CvtSplfHTM      PI
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  SplfName                           like(StdNam)    const
     D  SplfNbr                            like(StdInt)    const
     D  Stmf                               like(StdStr)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)

     D todir           s                   like(StdStr) inz
     D tostmf          s                   like(StdStr) inz

      /free

       // -------------------------------------------------------
       // Remove streamfile if it exists.

       joblog('unlink ' + %trim(stmf));
       UnLink(%trim(stmf));
       ToDir  = ExtDir(stmf);
       ToStmf = ExtFile(stmf);

       // -------------------------------------------------------
       // Convert spoolfile to TXT.

       System('MMAIL/CVTSPLSTMF fromfile('  + %trim(SplfName) + ') ' +
                                'job('      + %trim(JobNbr)   + '/'  +
                                              %trim(JobUsr)   + '/'  +
                                              %trim(JobNam)   + ') ' +
                                'tostmf(''' + %trim(ToStmf)   + ''') ' +
                                'todir('''  + %trim(ToDir)    + ''') ' +
                                'splnbr('   + %char(SplfNbr)  + ') ' +
                                'tofmt(*html) ' +
                                'stmfopt(*replace)');

       // -------------------------------------------------------
       // Delete spoolfile.

       if %parms >= 7           and
          %scan('*DLTSPLF':Options) <> *zero;
          DltSplf(SplfName);
       endif;

      /end-free

     P CvtSplfHTM      E
      * *********************************************************
      * CvtSplfPDF() -- Convert spoolfile to PDF
      * *********************************************************
     P CvtSplfPDF      B                   Export

     D CvtSplfPDF      PI
     D  p_JobNam                           like(StdNam)    const
     D  p_JobUsr                           like(StdNam)    const
     D  p_JobNbr                           like(StdJobNbr) const
     D  p_SplfName                         like(StdNam)    const
     D  p_SplfNbr                          like(StdInt)    const
     D  p_Stmf                             like(StdStr)    const
     D  Options                            like(StdTxt)    const
     D                                     options(*nopass)

     D JobNam          s                   like(StdNam)    inz
     D JobUsr          s                   like(StdNam)    inz
     D JobNbr          s                   like(StdJobNbr) inz
     D SplfName        s                   like(StdNam)    inz
     D SplfNbr         s                   like(StdInt)    inz
     D Stmf            s                   like(StdStr)    inz

      /free
       // -------------------------------------------------------
       // Remove streamfile if it exists.

       stmf = p_stmf;
       joblog('unlink ' + %trim(stmf));
       if UnLink(%trim(stmf)) <> -1;
          joblog('unlinked ' + %trim(stmf));
       endif;

      /end-free
      * -------------------------------------------------------
      * Use InfoPrint for the conversion.
      * -- needs to be an external program due to conflicts
      * -- in the binding directories and procedure names.
      *
     C                   CALL      'UT8057R'
     C                   parm      p_JobNam      JobNam
     C                   parm      p_JobUsr      JobUsr
     C                   parm      p_JobNbr      JobNbr
     C                   parm      p_SplfName    SplfName
     C                   parm      p_SplfNbr     SplfNbr
     C                   parm                    Stmf

      /free
       // -------------------------------------------------------
       // Delete spoolfile.

       if %parms >= 7                  and
          stmf   <> *blanks            and
          %scan('*DLTSPLF':Options) <> *zero;
          DltSplf(SplfName);
       endif;

      /end-free

     P CvtSplfPDF      E
      * *********************************************************
      * DltSplf() -- Delete spoolfile
      * *********************************************************
     P DltSplf         B                   Export

     D DltSplf         PI
     D  SplfName                           like(StdNam) const

      /free

       System('DLTSPLF file(' + %trim(SplfName) + ') +
                       splnbr(*last)');

      /end-free

     P DltSplf         E
      * *********************************************************
      * GetSplfLst() -- Get spoolfile list
      * *********************************************************
     P GetSplfLst      B                   Export

     Fgetslw01  o    e             disk    extmbr(MbrName)
     F                                     static usropn
     F                                     block(*no)

     D GetSplfLst      PI
     D  p_GetSplfLstJob...
     D                                     like(StdQalJob)  const
     D                                     options(*nopass:*omit)
     D  p_GetSplfLstUsr...
     D                                     like(StdNam)     const
     D                                     options(*nopass:*omit)
     D  p_GetSplfLstOutq...
     D                                     like(StdNam)     const
     D                                     options(*nopass:*omit)
     D  p_GetSplfLstFrmTyp...
     D                                     like(StdNam)     const
     D                                     options(*nopass:*omit)
     D  p_GetSplfLstUsrDta...
     D                                     like(StdNam)     const
     D                                     options(*nopass:*omit)

     D DSgetspl        ds                  likerec(getsl01w:*output) inz

     D GetSplfLstJob...
     D                 s                   like(StdQalJob) inz
     D GetSplfLstUsr...
     D                 s                   like(StdNam)    inz
     D GetSplfLstOutq...
     D                 s                   like(StdNamLib) inz
     D GetSplfLstFrmTyp...
     D                 s                   like(StdNam)    inz
     D GetSplfLstUsrDta...
     D                 s                   like(StdNam)    inz
     D GetSplfLstFldKeys...
     D                 s                   like(StdInt)    inz
     D GetSplfLstNumFlds...
     D                 s                   like(StdInt)    inz

     D FileName        s                   like(StdNam)    inz
     D LibName         s                   like(StdNam)    inz
     D MbrName         s                   like(StdNam)    inz

     D x               s                   like(StdInt)    inz
     D pos             s                   like(StdInt)    inz
     D WKtsp           s                   like(timstp)    inz
     D ZZpgm           s                   like(StdNam)    inz('UT8056R')

      /free
       // -------------------------------------------------------
       // Extract incomming parms.

       if %parms >= 1;
         CEETSTA(ParmPassed:1:*omit);
         if ParmPassed = 1;
            GetSplfLstJob = p_GetSplfLstJob;
         endif;
       endif;

       if %parms >= 2;
         CEETSTA(ParmPassed:2:*omit);
         if ParmPassed = 1;
            GetSplfLstUsr = p_GetSplfLstUsr;
         endif;
       endif;

       if %parms >= 3;
         CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            GetSplfLstOutq = p_GetSplfLstOutq + '*LIBL';
         endif;
       endif;

       if %parms >= 4;
         CEETSTA(ParmPassed:4:*omit);
         if ParmPassed = 1;
            GetSplfLstFrmTyp = p_GetSplfLstFrmTyp;
         endif;
       endif;

       if %parms >= 5;
         CEETSTA(ParmPassed:5:*omit);
         if ParmPassed = 1;
            GetSplfLstUsrDta = p_GetSplfLstUsrDta;
         endif;
       endif;

       // -------------------------------------------------------
       // Set parameter defaults.

       if GetSplfLstJob    = *blanks;

          if GetSplfLstUsr = *blanks;
             GetSplfLstUsr = '*ALL';
          endif;

          if GetSplfLstOutq = *blanks;
             GetSplfLstOutq = '*ALL';
          endif;

          if GetSplfLstFrmTyp = *blanks;
             GetSplfLstFrmTyp = '*ALL';
          endif;

          if GetSplfLstUsrDta = *blanks;
             GetSplfLstUsrDta = '*ALL';
          endif;
       endif;

       // -------------------------------------------------------
       // Add workmember, clear it.

       FileName = 'GETSLW01';
       LibName  = '*LIBL';
       MbrName  = 'Q' + RtvJobNbr();

       d_ChkObj = ChkObj(FileName:LibName:'*FILE':MbrName);
       if ChkObj_msgid = 'CPF9815';
          System('addpfm file(' + %trim(LibName)  + '/' +
                                  %trim(FileName) + ') +
                         mbr('  + %trim(MbrName)  + ')');
       endif;

       System('clrpfm file(' + %trim(LibName)  + '/' +
                               %trim(FileName) + ') +
                      mbr('  + %trim(MbrName)  + ')');

       open GETSLW01;

       // -----------------------------------------
       // Delete user space.

       USspcnam = ZZpgm;
       USspclib = 'QTEMP';

       DltUsrSpc(USspcnam:USspclib);

       // -----------------------------------------
       // Create user space.

       CrtUsrSpc(USspcnam:USspclib:
                 %size(APIheader)     + 256 +
                 %size(GetSplfLstEnt) * 1000:
                 'GetSplfLst':'Get spoolfile list');

       // -----------------------------------------
       // Get spoolfile list.

       GetSplfLstAPI(USspcnam20
                    :'SPLF0300'
                    :GetSplfLstUsr
                    :GetSplfLstOutq
                    :GetSplfLstFrmTyp
                    :GetSplfLstUsrDta
                    :dsEC
                    :GetSplfLstJob
                    :GetSplfLstFldKeys
                    :GetSplfLstNumFlds);

       // -----------------------------------------
       // Process spoolfile entries.

       p_APIheader = GetUsrSpcP(USspcnam:USspclib);

       for x = 1 to APIheader.Count;

          pos = APIheader.Offset + (x-1) * APIheader.Size;
          p_GetSplfLstEnt = p_APIheader + pos;

          DSgetspl.SLjobnam   = GetSplfLstEnt.JobName;
          DSgetspl.SLjobusr   = GetSplfLstEnt.UserName;
          DSgetspl.SLjobnbr   = GetSplfLstEnt.JobNumber;
          DSgetspl.SLsplnam   = GetSplfLstEnt.SplfName;
          DSgetspl.SLsplnbr   = GetSplfLstEnt.SplfNbr;

          select;
          when GetSplfLstEnt.SplfStatus = 1;
               DSgetspl.SLsplsts = 'RDY';

          when GetSplfLstEnt.SplfStatus = 2;
               DSgetspl.SLsplsts = 'OPN';

          when GetSplfLstEnt.SplfStatus = 3;
               DSgetspl.SLsplsts = 'CLO';

          when GetSplfLstEnt.SplfStatus = 4;
               DSgetspl.SLsplsts = 'SAV';

          when GetSplfLstEnt.SplfStatus = 5;
               DSgetspl.SLsplsts = 'WTR';

          when GetSplfLstEnt.SplfStatus = 6;
               DSgetspl.SLsplsts = 'HLD';

          when GetSplfLstEnt.SplfStatus = 7;
               DSgetspl.SLsplsts = 'MSGW';

          when GetSplfLstEnt.SplfStatus = 8;
               DSgetspl.SLsplsts = 'PND';

          when GetSplfLstEnt.SplfStatus = 9;
               DSgetspl.SLsplsts = 'PRT';

          when GetSplfLstEnt.SplfStatus = 10;
               DSgetspl.SLsplsts = 'FIN';

          when GetSplfLstEnt.SplfStatus = 11;
               DSgetspl.SLsplsts = 'SND';

          when GetSplfLstEnt.SplfStatus = 12;
               DSgetspl.SLsplsts = 'DFR';
          endsl;

          DSgetspl.SLopndte   = CvtCYYMMDDtoISO(
                               num(GetSplfLstEnt.OpenDate));
          DSgetspl.SLopntim   = num(GetSplfLstEnt.OpenTime);

          WKtsp = OfsUTCtsp(
                  CvtDteTimtoTSP(DSgetspl.SLopndte:DSgetspl.SLopntim));

          DSgetspl.SLopndte   = CvtTSPtoISO(WKtsp);
          DSgetspl.SLopntim   = CvtTSPtoHMS(WKtsp);

          DSgetspl.SLusrdta   = GetSplfLstEnt.UserData;
          DSgetspl.SLfrmtyp   = GetSplfLstEnt.FormType;
          DSgetspl.SLoutq     = GetSplfLstEnt.OutQueue;
          DSgetspl.SLoutqlib  = GetSplfLstEnt.OutQueueLib;
          DSgetspl.SLsplsiz   = GetSplfLstEnt.SplfSize *
                               GetSplfLstEnt.SizeMult;
          DSgetspl.SLttlpag   = GetSplfLstEnt.TotalPages;
          DSgetspl.SLcpylft   = GetSplfLstEnt.CopiesLeft;
          DSgetspl.SLsplpty   = GetSplfLstEnt.Priority;
          DSgetspl.SLippjobid = GetSplfLstEnt.IppJobId;
          write getsl01w DSgetspl;
       endfor;

       close GETSLW01;

       // -----------------------------------------
       // Delete user space.

       // DltUsrSpc(USspcnam:USspclib);

      /end-free

     P GetSplfLst      E
      * *********************************************************
      * CvtSplNbrtoAlpha() -- Convert spoolfile number to alpha
      * *********************************************************
     P CvtSplNbrtoAlpha...
     P                 B                   Export

     D CvtSplNbrtoAlpha...
     D                 PI                  like(StdJobNbr)
     D  i_SplNbr                           like(StdSplNbr) const

     D wkSplNbr        s                   like(StdTok)    inz
     D o_SplNbr        s                   like(StdJobNbr) inz
      /free
       // -------------------------------------------------------
       // Convert numeric spool number to alpha

       evalR wkSplNbr = '000000' + %char(i_SplNbr);

       // -------------------------------------------------------
       // Take the last 6 bytes and pass back.

       o_SplNbr = %subst(wkSplNbr:
                         %len(wkSplNbr) - %len(o_SplNbr) +1:
                         %len(o_SplNbr));

       return o_SplNbr;

      /end-free
     P CvtSplNbrtoAlpha...
     P                 E
