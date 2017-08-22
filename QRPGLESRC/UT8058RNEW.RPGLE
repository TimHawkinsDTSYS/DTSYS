      /TITLE Utility, IFS (SrvPgm)
      *CMDBFR dltsrvpgm srvpgm(%OBJNAM)
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
      /copy qcpysrc,Dspec

     D seterror        PR
     D   errnum                            like(StdInt) value
     D   errmsg                      80A   const

     D save_errnum     s                   like(StdInt)
     D save_errmsg     s             80A

     D MAXOPEN         C                   10

     D opn             ds                  qualified
     D   work                              dim(MAXOPEN)
     D   dirh                              like(StdPtr)
     D                                     overlay(work)
     D   reg                               like(regex_t)
     D                                     overlay(work:*NEXT)
     D   useRE                             like(StdInd)
     D                                     overlay(work:*NEXT)
      * *********************************************************
     ‚* ChkIFSobj() - Check IFS object.
      * *********************************************************
     P ChkIfsObj       B                   Export
      *
     D ChkIfsObj       PI                  like(StdInd)
     D  InpFile                            like(StdStr) const
      /free
    ‚  // -------------------------------------------------------
    ‚  // Check IFS object.

š1b€   if access(%trim(InpFile)+ifsNull:F_OK) = *zero;
          return *on;
š1x€   else;
          DiagErrno(errno());
          return *off;
š1e€   endif;

      /end-free

     P ChkIfsObj       E
      * *********************************************************
     ‚* ExtDirPth() - Extract directory from a path
      * *********************************************************
     P ExtDirPth       B                   Export
      *
     D ExtDirPth       PI                  like(t_ExtDirPth)
     D  InpPath                            like(StdStr) const
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D Dirs            ds                  likeds(t_ExtWords)
     D                                     based(pDirs)
      *
     D WrkPath         s                   like(StdStr) inz
     D x               s                   like(StdInt) inz
     ‚* ---------------------------------------------------------
     ‚* Return if nothing passed.
      *
š1b€ c                   if        InpPath = *blanks
     c                   return    PthDS   = *blanks
š1e€ c                   endif
      *
     ‚* Remove 'null'.
      *
     c                   eval      WrkPath = %xlate(ifsNULL:' ':InpPath)
      *
     ‚* Remove quotes.
      *
     c                   eval      WrkPath = %xlate('''':'':InpPath)
     ‚* ---------------------------------------------------------
     ‚* Extract file name.
      *
š1b€ c                   if        %scan('.':WrkPath) > *zero
      *
š2b€ c                   for       x = %len(%trim(WrkPath)) downto 1
š3b€ c                   if        %subst(WrkPath:x:1) = '/'
š2v€ c                   leave
š3e€ c                   endif
š2e€ c                   endfor
      *
š2b€ c                   if        x > 2
     c                   eval      PthDS.IFSfile = %subst(WrkPath:x+1)
     c                   eval      %subst(WrkPath:x) = *blanks
š2e€ c                   endif
š1e€ c                   endif
     ‚* ---------------------------------------------------------
     ‚* Extract directory names.
      *
     C                   eval      pDirs = ExtWords(WrkPath:'/\')
     c
š1b€ c                   for       x = 1 to Dirs.WordsMax
     c                   eval      PthDS.IFSdircnt     = x
     c                   eval      PthDS.IFSdirlist(x) = Dirs.words(x)
š1e€ c                   endfor
      *
     c                   return    PthDS
      *
     P ExtDirPth       E
      * *********************************************************
     ‚* CrtDirPth() - Create directories in a path
      * *********************************************************
     P CrtDirPth       B                   Export
      *
     D CrtDirPth       PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
     D statDS          ds                  likeds(t_statDS)
      *
     D WrkBgnDir       s                   like(StdStr) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D ModeSet         s                   like(StdInd) inz
     D mode            s                   like(StdUns) inz
     D x               s                   like(StdInt) inz
      /free
    ‚  // --------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks;
         return *off;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Handle optional parameters.

š1b€   if %parms >= 2;
         callp   CEETSTA(ParmPassed:2:*omit);
š2b€     if ParmPassed = 1;
            WrkBgnDir = InpBgnDir;
š2e€     endif;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Extract directories.

       PthDS = ExtDirPth(InpPath);

š1b€   if PthDS.IFSdircnt = *zero;
          return *off;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Set begin directory.

š1b€   if WrkBgnDir <> *blanks  and
          WrkBgnDir <> '*NONE';

š2b€      for BgnDir = 1 to PthDS.IFSdircnt;
š3b€          if WrkBgnDir = PthDS.IFSdirlist(BgnDir);
š2v€             leave;
š3e€          endif;

              path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);

    ‚        // Get mode of the parent directory,
    ‚        // then turn off non-permission bits.

š3b€          if not ModeSet;
š4b€             if stat(%trim(path):%addr(statDS)) = ifsFalse;
                    EscErrno(errno());
š4e€             endif;

                 ModeSet = *on;
                 mode = %bitand(statDS.st_mode: x'000003FF');
š3e€          endif;
š2e€      endfor;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Mode might not have been set, default to /home.

š1b€   if not ModeSet;
š2b€      if stat('/home':%addr(statDS)) = ifsFalse;
             EscErrno(errno());
š2e€      endif;

          ModeSet = *on;
          mode = %bitand(statDS.st_mode: x'000003FF');
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Make directories.

š1b€   for x = BgnDir to PthDS.IFSdircnt;
         path = %trim(path) + '/' + PthDS.IFSdirlist(x);

    ‚     // Make directory.

š2b€     if not ChkIfsObj(%trim(path));

    ‚        // create directory.

š3b€        if mkdir(%trim(path):mode) = ifsFalse;
               EscErrno(errno());
š3e€        endif;

    ‚        // set the owner of the directory to match parent.

š3b€        if chown(%trim(path):statDS.st_uid:statDS.st_gid) = ifsFalse;
               EscErrno(errno());
š3e€        endif;
š2e€     endif;
š1e€   endfor;

       return *on;

      /end-free
      *
     P CrtDirPth       E
      * *********************************************************
     ‚* ClnIFSnam() - Cleanup IFS filename.
      * *********************************************************
     P ClnIFSnam       B                   Export
      *
     D ClnIFSnam       PI                  like(StdStr)
     D  InpIFSnam                          like(StdStr) const
      *
     D RtnIFSnam       s                   like(StdStr) inz
     ‚* ---------------------------------------------------------
     ‚* Remove offending characters.
      *
     C                   eval      RtnIFSnam = InpIFSnam
     C                   eval      RtnIFSnam = %xlate('"' :' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('''':' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('.' :' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('/' :' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('\' :' ':RtnIFSnam)
      *
     c                   return    RtnIFSnam
      *
     P ClnIFSnam       E
      * *********************************************************
     ‚* ChgIFSown() - Change IFS ownership.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      * *********************************************************
     P ChgIFSown       B                   Export
      *
     D ChgIFSown       PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpUser                            like(StdNam) const
     D                                     options(*omit:*nopass)
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D WrkPath         s                   like(StdStr) inz
     D WrkBgnDir       s                   like(StdStr) inz
     D WrkUser         s                   like(StdNam) inz
     D WrkOption       s                   like(StdNam) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D error           s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
    ‚  // -------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks;
         return *off;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Strip-off null characters.
    ‚  // -- NULL is a C end-of-string delimiter.

       WrkPath = %xlate(ifsNull:' ':InpPath);

    ‚  // -------------------------------------------------------
    ‚  // Handle optional parameters.

š1b€   if %parms        >= 2;
         callp CEETSTA(ParmPassed:2:*omit);
š2b€     if ParmPassed = 1;
            WrkUser = InpUser;
š2e€     endif;
š1e€   endif;

š1b€   if %parms        >= 3;
         callp CEETSTA(ParmPassed:3:*omit);
š2b€     if ParmPassed = 1;
            WrkBgnDir = InpBgnDir;
š2e€     endif;
š1e€   endif;

š1b€   if %parms        >= 4;
         callp CEETSTA(ParmPassed:4:*omit);
š2b€     if ParmPassed = 1;
            WrkOption = InpOption;
š2e€     endif;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Set defaults.

š1b€   if WrkUser = *blanks;
          WrkUser = RtvObjOwn(ZZpgm:'*SRVPGM');
š1e€   endif;

š1b€   if WrkOption = *blanks;
          WrkOption = '*ALL';
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Extract directories and file.

       PthDS = ExtDirPth(WrkPath);

    ‚  // -------------------------------------------------------
    ‚  // Set begin directory.

š1b€   if  WrkBgnDir <> *blanks  and
           WrkBgnDir <> '*NONE';
š2b€     for BgnDir = 1 to PthDS.IFSdircnt;
š3b€       if  WrkBgnDir = PthDS.IFSdirlist(BgnDir);
š2v€         leave;
š3e€       endif;

           path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);
š2e€     endfor;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Process directories.

š1b€   if  WrkOption = '*ALL'   or
           WrkOption = '*ALLDIR';
š2b€     for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
           exsr ChgOwn;
š2e€     endfor;
š1e€   endif;

š1b€   if  WrkOption = '*LASTDIR';
š2b€     for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
š2e€     endfor;

         exsr ChgOwn;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Process files.

š1b€   if  (WrkOption      = '*ALL'   or
            WrkOption      = '*FILE') and
            PthDS.IFSfile <> *blanks;
         path = %trim(WrkPath);
         exsr ChgOwn;
š1e€   endif;

š1b€   if error;
         return *off;
š1x€   else;
         return *on;
š1e€   endif;

    ‚  // =======================================================
    ‚  // Change ownership.

       begsr ChgOwn;

       leavesr;  // *** disabled **

         CmdStg = 'chgown obj(''' + %trim(path) + ''') +
                          newown(' + %trim(WrkUser) + ')';
š1b€     if not ExecCmd(CmdStg);
            error = *on;
š1e€     endif;

       endsr;

      /end-free
      *
     P ChgIFSown       E
      * *********************************************************
     ‚* ChgIFSaut() - Change IFS authority.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      * *********************************************************
     P ChgIFSaut       B                   Export
      *
     D ChgIFSaut       PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpUser                            like(StdNam) const
     D                                     options(*omit:*nopass)
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D WrkPath         s                   like(StdStr) inz
     D WrkBgnDir       s                   like(StdStr) inz
     D WrkUser         s                   like(StdNam) inz
     D WrkOption       s                   like(StdNam) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D error           s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
    ‚  // --------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks;
         return *off;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Strip-off null characters.
    ‚  // -- NULL is a C end-of-string delimiter.

       WrkPath = %xlate(ifsNull:' ':InpPath);

    ‚  // --------------------------------------------------------
    ‚  // Handle optional parameters.

š1b€   if %parms        >= 2;
         callp     CEETSTA(ParmPassed:2:*omit);
š2b€     if ParmPassed = 1;
            WrkUser    = InpUser;
š2e€     endif;
š1e€   endif;

š1b€   if %parms        >= 3;
         callp     CEETSTA(ParmPassed:3:*omit);
š2b€     if ParmPassed = 1;
            WrkBgnDir  = InpBgnDir;
š2e€     endif;
š1e€   endif;

š1b€   if %parms        >= 4;
         callp     CEETSTA(ParmPassed:4:*omit);
š2b€     if ParmPassed = 1;
            WrkOption  = InpOption;
š2e€     endif;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Set defaults.

š1b€   if WrkUser = *blanks;
          WrkUser = RtvObjOwn(ZZpgm:'*SRVPGM');
š1e€   endif;

š1b€   if WrkOption = *blanks;
          WrkOption = '*ALL';
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Extract directories and file.

       PthDS = ExtDirPth(WrkPath);

    ‚  // -------------------------------------------------------
    ‚  // Set begin directory.

š1b€   if  WrkBgnDir <> *blanks  and
           WrkBgnDir <> '*NONE';
š2b€     for BgnDir = 1 to PthDS.IFSdircnt;
š3b€       if  WrkBgnDir = PthDS.IFSdirlist(BgnDir);
š2v€         leave;
š3e€       endif;

           path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);
š2e€     endfor;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Process directories.

š1b€   if  WrkOption = '*ALL'   or
           WrkOption = '*ALLDIR';
š2b€     for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
           exsr ChgAut;
š2e€     endfor;
š1e€   endif;

š1b€   if  WrkOption = '*LASTDIR';
š2b€     for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
š2e€     endfor;

         exsr ChgAut;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Process files.

š1b€   if  (WrkOption      = '*ALL'   or
            WrkOption      = '*FILE') and
            PthDS.IFSfile <> *blanks;
         path = %trim(WrkPath);
         exsr ChgAut;
š1e€   endif;

š1b€   if error;
         return *off;
š1x€   else;
         return *on;
š1e€   endif;

    ‚  // ========================================================
    ‚  // Change authority.

       begsr ChgAut;

         CmdStg = 'chgaut obj(''' + %trim(path) + ''') +
                          user(' + %trim(InpUser) + ') +
                          dtaaut(*RWX) +
                          objaut(*ALL)';
š1b€     if not ExecCmd(CmdStg);
            error  = *on;
š1e€     endif;

       endsr;

      /end-free
     P ChgIFSaut       E
      * *********************************************************
     ‚* ChgIFSautl() - Change IFS authority list.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      * *********************************************************
     P ChgIFSautl      B                   Export
      *
     D ChgIFSautl      PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpAutl                            like(StdNam) const
     D                                     options(*omit:*nopass)
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D WrkPath         s                   like(StdStr) inz
     D WrkBgnDir       s                   like(StdStr) inz
     D WrkAutl         s                   like(StdNam) inz
     D WrkOption       s                   like(StdNam) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D error           s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
    ‚  // --------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks  or
          InpAutl = *blanks;
         return *off;
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Strip-off null characters.
    ‚  // -- NULL is a C end-of-string delimiter.

       WrkPath = %xlate(ifsNull:' ':InpPath);

    ‚  // --------------------------------------------------------
    ‚  // Handle optional parameters.

š1b€   if %parms      >= 3;
         callp CEETSTA(ParmPassed:3:*omit);
š2b€     if ParmPassed = 1;
            WrkBgnDir = InpBgnDir;
š2e€     endif;
š1e€   endif;

š1b€   if %parms      >= 4;
         callp CEETSTA(ParmPassed:4:*omit);
š2b€     if ParmPassed = 1;
            WrkOption = InpOption;
š2e€     endif;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Set defaults.

š1b€   if WrkOption = *blanks;
          WrkOption = '*ALL';
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Determine if authorization list exits.

š1b€   if not ChkObj(InpAutl:'*AUTL');
          return *off;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Extract directories and file.

       PthDS = ExtDirPth(WrkPath);

    ‚  // -------------------------------------------------------
    ‚  // Set begin directory.

š1b€   if  WrkBgnDir <> *blanks  and
           WrkBgnDir <> '*NONE';
š2b€     for BgnDir = 1 to PthDS.IFSdircnt;
š3b€       if  WrkBgnDir = PthDS.IFSdirlist(BgnDir);
š2v€         leave;
š3e€       endif;

           path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);
š2e€     endfor;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Process directories.

š1b€   if  WrkOption = '*ALL'   or
           WrkOption = '*ALLDIR';
š2b€     for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
           exsr ChgAutl;
š2e€     endfor;
š1e€   endif;

š1b€   if  WrkOption = '*LASTDIR';
š2b€     for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
š2e€     endfor;

         exsr ChgAutl;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Process files.

š1b€   if  (WrkOption      = '*ALL'   or
            WrkOption      = '*FILE') and
            PthDS.IFSfile <> *blanks;
         path = %trim(WrkPath);
         exsr ChgAutl;
š1e€   endif;

š1b€   if error;
          return *off;
š1x€   else;
          return *on;
š1e€   endif;

    ‚  // ========================================================
    ‚  // Change authority list.

       begsr ChgAutl;

         CmdStg = 'chgaut obj(''' + %trim(path) + ''') +
                          Autl(' + %trim(InpAutl) + ')';
š1b€     if not ExecCmd(CmdStg);
            error = *on;
š1e€     endif;

       endsr;

      /end-free
      *
     P ChgIFSautl      E
      * **********************************************************
     ‚* CpyDBtoStmf() - Copy DB file to streamfile.
      * **********************************************************
     P CpyDBtoStmf     B                   Export

     D CpyDBtoStmf     PI                  like(StdInd)
     D  InFile                             like(StdNam) const
     D  InStreamFile                       like(StdStr) const
     D  InOption                           like(StdStr) const
     D                                     options(*omit:*nopass)

     D colhdg          s                   like(StdStr) inz
     D WrkOption       s                   like(StdStr) inz
      /free
    ‚  // --------------------------------------------------------
    ‚  // Handle optional parameters.

š1b€   if %parms      >= 3;
         callp CEETSTA(ParmPassed:3:*omit);
š2b€     if ParmPassed = 1;
            WrkOption = upper(InOption);
š2e€     endif;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Set defaults.

š1b€   select;
š1b€   when %scan('*SEPERATED':WrkOption) <> *zero;
            colhdg = '*SEPERATED';
š1e€
š1b€   when %scan('*COMBINED':WrkOption) <> *zero;
            colhdg = '*COMBINED';
š1e€
š1b€   when %scan('*NONE':WrkOption) <> *zero;
            colhdg = '*NONE';
š1e€   endsl;

š1b€   if colhdg = *blanks;
          colhdg = '*SEPERATED';
š1e€   endif;

    ‚  // -------------------------------------------------------
    ‚  // Remove link.

       CmdStg = 'rmvlnk objlnk(''' + %trim(InStreamFile) + ''')';

       ExecCmd(CmdStg);

    ‚  // --------------------------------------------------------
    ‚  // Write CSV database file.

       CmdStg = 'wrtcsvdbf fromfile(' + %trim(InFile) + ') +
                 tostmf(''' + %trim(InStreamFile) + ''')' +
               ' colhdg('   + %trim(colhdg)       +   ')';

š1b€   if not ExecCmd(CmdStg);
          return *off;
š1x€   else;
          return *on;
š1e€   endif;

      /end-free

     P CpyDBtoStmf     E
      * *********************************************************
     ‚* DltIFSdir() - Delete IFS directories.
      * *********************************************************
     P DltIFSdir       B                   Export
      *
     D DltIFSdir       PI
     D  InPath                             like(StdStr) const
      *
     D WKpath          s                   like(StdStr)
     ‚* ---------------------------------------------------------
     ‚* Return if nothing passed.
      *
š1b€ c                   if        InPath  = *blanks
     c                   return
š1e€ c                   endif
     ‚* ---------------------------------------------------------
     ‚* Delete the IFS directory.
      *
     c                   call      'UT1340C'
     c                   parm      InPath        WKpath
      *
     P DltIFSdir       E
      * *********************************************************
     ‚* ClrIFSobj() - Clear IFS object.
      * *********************************************************
     P ClrIFSobj       B                   Export
      *
     D ClrIfsObj       PI
     D  InpFile                            like(StdStr) const
      *
     D QSHcmd          s                   like(StdStr) inz
     ‚* ---------------------------------------------------------
     ‚* Clear IFS object.
      *
     c                   eval      QSHcmd = ':>' + %trim(InpFile)
      *
     c                   call(e)   'UT0010C'
     c                   parm                    QSHcmd
      *
     P ClrIfsObj       E
      * *********************************************************
      * readline() -- Read text from an IFS file line by line.
      * *********************************************************
     P readline        B                   export

     D readline        PI                  like(StdInt)
     D   fd                                like(StdInt) value
     D   text                              like(StdPtr) value
     D   maxlen                            like(StdInt) value

     D rdbuf           S           1024A   static
     D rdpos           S                   like(StdInt) static
     D rdlen           S                   like(StdInt) static

     D p_retstr        S                   like(StdPtr)
     D RetStr          S          32766A   based(p_retstr)
     D len             S                   like(StdInt)
     ‚* ---------------------------------------------------------
     ‚*    Read text from the IFS file.
      *
     c                   eval      len = *zero
     c                   eval      p_retstr = text
     c                   eval      %subst(RetStr:1:MaxLen) = *blanks

š1b€ c                   dow       1 = 1

     ‚* Load the buffer
š2b€ c                   if        rdpos >= rdlen
     c                   eval      rdpos  = *zero
     c                   eval      rdlen  =
     c                             read(fd:%addr(rdbuf):%size(rdbuf))

š3b€ c                   if        rdlen < 1
     c                   return    -1
š3e€ c                   endif
š2e€ c                   endif

     ‚* Is this the end of the line?
     c                   eval      rdpos += 1
š2b€ c                   if        %subst(rdbuf:rdpos:1) = x'25'
     c                   return    len
š2e€ c                   endif

     ‚* Otherwise, add it to the text string.
š2b€ c                   if        %subst(rdbuf:rdpos:1) <> x'0d'
     c                               and len <> maxlen
     c                   eval      len += 1
     c                   eval      %subst(retstr:len:1) =
     c                             %subst(rdbuf:rdpos:1)
š2e€ c                   endif
š1e€ c                   enddo

     c                   return    len

     P readline        E
      * *********************************************************
      * ExtDir() -- Extract directories from path.
      * *********************************************************
     P ExtDir          B                   Export
      *
     D ExtDir          PI                  like(StdStr)
     D  InpPath                            like(StdStr) const
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D RtnDir          s                   like(StdStr) inz
     D x               s                   like(StdInt) inz
      *
      /free
    ‚  // --------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks;
         return *blanks;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Extract directories.

       PthDS = ExtDirPth(InpPath);

    ‚  // -------------------------------------------------------
    ‚  // Set return directory.

       RtnDir = PthDS.IFSdirlist(1);

š1b€   for x = 2 to PthDS.IFSdircnt;
           RtnDir = %trim(RtnDir) + '/' + PthDS.IFSdirlist(x);
š1e€   endfor;

       return RtnDir;

      /end-free
      *
     P ExtDir          E
      * *********************************************************
      * ExtFile() -- Extract file name from path.
      * *********************************************************
     P ExtFile         B                   Export
      *
     D ExtFile         PI                  like(StdStr)
     D  InpPath                            like(StdStr) const
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
      /free
    ‚  // --------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks;
         return *blanks;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Extract file name.

       PthDS = ExtDirPth(InpPath);

       return PthDS.IFSfile;

      /end-free
     P ExtFile         E
      * *********************************************************
      * ExtExt() -- Extract file extension from path.
      * *********************************************************
     P ExtExt          B                   Export
      *
     D ExtExt          PI                  like(StdNam)
     D  InpPath                            like(StdStr) const
      *
     D x               s                   like(StdInt) inz
     D RtnExt          s                   like(StdNam) inz
      /free
    ‚  // --------------------------------------------------------
    ‚  // Return if nothing passed.

š1b€   if InpPath = *blanks;
         return *blanks;
š1e€   endif;

    ‚  // --------------------------------------------------------
    ‚  // Extract file extension.

š1b€   for x = %len(%trim(InpPath)) to 1 by -1;
š2b€       if x < %len(InpPath)          and
              %subst(InpPath:x:1) = '.';
              RtnExt = %subst(InpPath:x+1);
š2e€       endif;
š1e€   endfor;

       return RtnExt;

      /end-free
     P ExtExt          E
      * *********************************************************
     ‚* CrtIFSfile() - Create IFS file.
      * *********************************************************
     P CrtIFSfile      B                   Export
      *
     D CrtIFSfile      PI                  like(StdInt)
     D  InpPath                            like(StdStr) const
     D  InpFile                            like(StdStr) const
      *
     D path            s                   like(StdStr) inz
     D file            s                   like(StdStr) inz
     D stmfname        s                   like(StdStr) inz
     D pStmfName       s                   like(StdPtr) inz(%addr(stmfname))
     D envnam          s                   like(StdNam) inz
     D owner           s                   like(StdNam) inz
     D autl            s                   like(StdNam) inz
     D fd              s                   like(StdInt) inz
     D rc              s                   like(StdInt) inz
      *
      /free
    ‚  // -------------------------------------------------------
    ‚  //‚Retrieve environment.
    ‚  // -- environment name is likely to be customized.

       envnam   = RtvCurEnv();
       autl     = envnam;
       owner    = RtvObjOwn(ZZpgm:'*SRVPGM');

       path     = InpPath;
       stmfname = %trim(path) + '/' + %trim(InpFile) + ifsNULL;

    ‚  // -------------------------------------------------------
    ‚  //‚Create directory.

       CrtDirPth(path);

    ‚  // -------------------------------------------------------
    ‚  //‚Create file.

       fd = open(pStmfName:O_WRONLY+O_TRUNC+O_CREAT+O_CODEPAGE:
                           511: ifsAsciiCdePag);
       rc = IFSclose(fd);

    ‚  // -------------------------------------------------------
    ‚  //‚Set authorities.

       ChgIFSautl(stmfname:autl:envnam);
       ChgIFSown(stmfname:owner:envnam);

    ‚  // -------------------------------------------------------
    ‚  //‚Re-open file.

       fd = open(pStmfName:O_WRONLY+O_TEXTDATA);

       return fd;

      /end-free
     P CrtIFSfile      E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  IFS_opendir():  Open an IFS directory for reading
      *
      *      pePath = (input) Path to IFS directory.
      *   pePattern = (input) regular expresssion of files to include
      *
      * returns a handle that you can use to call subsequent routines
      *       or -1 if an error occurs.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P IFS_opendir     B                   export

     D IFS_opendir     PI                  like(StdInt)
     D   pePath                   32767A   varying const options(*varsize)
     D   pePattern                  256A   varying const

     D reg             ds                  likeds(regex_t)

     D rc              s                   like(StdInt)
     D buf             s            256A
     D dirh            s                   like(StdPtr)
     D useRE           s                   like(StdInd)
     D found           s                   like(StdInt)
     D x               s                   like(StdInt)

      /free
       // -------------------------------------------------------
       // Compile regular expression (if passed)

       useRE = *off;
       if (pePattern <> '');
           rc = regcomp( reg
                       : pePattern
                       : REG_BASIC + REG_ICASE + REG_NOSUB );
           if (rc <> 0);
               regerror(rc: reg: %addr(buf): %size(buf));
               seterror(IFSERR_REGCMP: %str(%addr(buf)));
               return -1;
           endif;

           useRE = *on;
       endif;
       // -------------------------------------------------------
       //  Open directory

       dirh = opendir(pePath);
       if (dirh = *NULL);
           seterror(IFSERR_OPNDIR: %str(strerror(errno)));
           regfree(reg);
           return -1;
       endif;
       // -------------------------------------------------------
       //  Search for an open space in array

       found = *zero;
       for x = 1 to MAXOPEN;
           if (opn.dirh(x) = *NULL);
              found = x;
              leave;
           endif;
       endfor;

       if found = *zero;
          seterror(IFSERR_TOOMNY: 'You have too many '
                                + 'directories open.');
          closedir(dirh);
          regfree(reg);
          return -1;
       endif;
       // -------------------------------------------------------
       //  Save results into array and return array index
       //  so that these values can be referenced from
       //  the other routines.

       opn.dirh(found)  = dirh;
       opn.reg(found)   = reg;
       opn.useRE(found) = useRE;
       return found;

      /end-free

     P IFS_opendir     E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * IFS_readdir(): Read the next entry from an open directory
      *
      *    peHandle = (input) handle returned by IFS_opendir()
      *  peFilename = (output) filename found in directory
      *
      * returns the length of the filename
      *         or -1 when the end of the file list is reached
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P IFS_readdir     B                   export

     D IFS_readdir     PI                  like(StdInt)
     D   peHandle                          like(StdInt) const
     D   peFilename                 640A

     D x               s                   like(StdInt)
     D rc              s                   like(StdInt)
     D p_de            s                   like(StdPtr)
     D de              ds                  likeds(dirent)
     D                                     based(p_de)
     D found           s                   like(StdInd)

     D name            s            640A   varying
     D match           ds                  likeds(regmatch_t)

      /free
       // -------------------------------------------------------
       // Read next directory entry.

       x = peHandle;
       found = *off;

       dou found;
           p_de = readdir( opn.dirh(x) );
           if (p_de = *NULL);
               return -1;
           endif;

           name = %subst(de.d_name : 1 : de.d_namelen);

           if (name='.' or name='..');
              iter;
           endif;

           if ( opn.useRE(x) = *off );
                 found = *on;

           else;
                rc = regexec(opn.reg(x): name: 0: match: 0);
                if (rc = *zero);
                   found = *on;
                endif;
           endif;

       enddo;

       peFilename = name;
       return de.d_namelen;

      /end-free
     P IFS_readdir     E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * IFS_rewinddir(): Move back to the start of the directory list
      *                  so that you can re-retrieve the list of
      *                  files.
      *
      *    peHandle = (input) handle returned by IFS_opendir()
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P IFS_rewinddir   B                   export

     D IFS_rewinddir   PI
     D   peHandle                          like(StdInt) const
      /free
       // -------------------------------------------------------
       // Set to top of directory.

       rewinddir(opn.dirh(peHandle));

      /end-free
     P IFS_rewinddir   E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * IFS_closedir(): Close an open directory (and free up resources
      *                  associated with having it open)
      *
      *    peHandle = (input) handle returned by IFS_opendir()
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P IFS_closedir    B                   export

     D IFS_closedir    PI
     D   peHandle                          like(StdInt) const
      /free
       // -------------------------------------------------------
       // Close directory.

          closedir(opn.dirh(peHandle));
          regfree(opn.reg(peHandle));
          opn.dirh(peHandle) = *NULL;

      /end-free

     P IFS_closedir    E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * IFS_error(): Retrieve the last error that occurred in this
      *              service program.
      *
      *     errnum (output/optional) = error number that occurred
      *
      *  Returns the human-readable error message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P IFS_error       B                   export

     D IFS_error       PI            80A
     D   errnum                            like(StdInt)
     D                                     options(*nopass)
      /free

         if %parms >= 1;
            errnum = save_errnum;
         endif;

         return save_errmsg;

      /end-free
     P                 E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * (internal) used to set the last error number/message
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P seterror        B

     D seterror        PI
     D   errnum                            like(StdInt) value
     D   errmsg                      80A   const
      /free

         save_errnum = errnum;
         save_errmsg = errmsg;

      /end-free
     P seterror        E
      /eof
       // =======================================================
       // Below is sample on how to use the directory code
       // -------------------------------------------------------
     D rc              s                   like(StdInt) inz
     D Path            s                   like(StdStr) inz
     D DEFprefix       s                   like(StdStr) inz
     D DEFfile         s                   like(StdStr) inz
     D CompNumb        s                   like(StdNam) inz
     D DirH            s                   like(StdInt) inz
     D FileName        s            640                 inz

      /free
       // -------------------------------------------------------
       // Retrieve DEF path.

       Path =
       RtvAppCtlDta('WRIGHT EXPRESS':'DAILY EXTRACT IFS PATH':RtvEnvTyp());
       Path = %trim(Path) + IFSnull;

       // -------------------------------------------------------
       // Retrieve DEF file prefix.

       DEFprefix = RtvAppCtlDta('WRIGHT EXPRESS':'DEF PREFIX');

       // -------------------------------------------------------
       // Retrieve company number.

       CompNumb =
       RtvAppCtlDta('WRIGHT EXPRESS':'WEB SERVICE COMP NUMBER':RtvCurEnv());

       // -------------------------------------------------------
       // Expected file name 'DailyTransaction_99999.*'

       DEFfile = %trim(DEFprefix) + '_' + %trim(CompNumb) + '.*';

       // -------------------------------------------------------
       // Open IFS directory.

       DirH = IFS_opendir(Path:%trim(DEFfile));
       if DirH < *zero;
          joblog('Unable to open directory');
          *inLR = *on;
          return;
       endif;

       // -------------------------------------------------------
       // Read the next entry.

       rc = IFS_readdir(DirH:Filename);

       dow rc > *zero;
           joblog(%trim(Filename));

           rc = IFS_readdir(DirH:Filename);
       enddo;

       // -------------------------------------------------------
       // Close directory.

       IFS_closedir(DirH);

       *inLR = *on;
      /end-free
