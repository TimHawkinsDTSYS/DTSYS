     H DFTACTGRP(*NO) ACTGRP(*CALLER) BNDDIR('QC2LE') EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('06/20/1991 Craig Rutledge < www.jcrcmds.com > ')
      //---------------------------------------------------------------
      // JCRSPLFR - List spool files with Options
      // This program is free software, you can redistribute it and/or modify it under the terms
      // of the GNU General Public License as published by the Free Software Foundation.
      // 1/18/2002 - v5r1 /free conversion.
      //---------------------------------------------------------------
      // program summary:
      // callp api to load selected spooled files to user space
      // display subfile of selected spooled files
      // process options selected from subfile.
      //---------------------------------------------------------------
      // quscrtus  create user space
      // qusptrus  retrieve pointer to user space
      // quslspl   list spool file internal identifiers
      // qusrspla  retrieve spooled file attributes
      //---------------------------------------------------------------
     FJCRSPLFD  cf   e             workstn sfile(view1:rrn) infds(dsinf)
     F                                     sfile(view2:rrn) indds(dsind)
     F                                     sfile(view3:rrn)
     D dsinf           ds
     D  fkey                          1    overlay(dsinf:369)
     D  vbgrrn               378    379b 0
     D  f03            c                   const(X'33')
     D  f05            c                   const(X'35')
     D  f11            c                   const(X'3B')
     D  f12            c                   const(X'3C')

      // name screen indicators
     D dsind           ds
     D in_sfldsp                       n   overlay(dsind:1)
     D in_sfldspctl                    n   overlay(dsind:2)
     D in_NoDisplay                    n   overlay(dsind:10)
      //
     D View1Flg        s               n
     D View2Flg        s               n
     D View3Flg        s               n

      //---------------------------------------------------------------
      // Get user space list info from header section.
      //---------------------------------------------------------------
     D                 ds                  based(uHeadPtr)
     D uOffSetToList         125    128i 0                                      offset to list
     D uNumOfEntrys          133    136i 0                                      number list entries
     D uSizeOfEntry          137    140i 0                                      list entry size
     D forcnt          s                   like(uNumOfEntrys)

      //---------------------------------------------------------------
      // DS to move through user space by pointer.
      //---------------------------------------------------------------
     D uListEntry      ds                  Based(uListPtr)
     D   vijoba                      16    overlay(uListEntry:51)               INTERNAL NAME
     D   vispla                      16    overlay(uListEntry:67)               INT SPOOL NAME

      //---------------------------------------------------------------
      // DS of the spooled file attributes return variable.
      //---------------------------------------------------------------
     D vsplat          ds          1480    inz                                  spooled file attrib
     D  jobnm                 41     50
     D  usrid                 51     60
     D  jobno                 61     66
     D  splnm                 67     76
     D  vfil_b                77     80b 0
     D  frmtyp                81     90
     D  usrdta                91    100
     D  vstat                101    110
     D  vpag_b               141    144b 0
     D  vpag_c               145    148b 0
     D  vcop_b               165    168b 0
     D  vlpi                 173    176b 0
     D  vcpi                 177    180b 0
     D  priort               181    182
     D  queue                183    192
     D  quelib               193    202
     D  vsplyy               204    205
     D  vsplmm               206    207
     D  vspldd               208    209
     D  vsplhr               210    211
     D  vsplmn               212    213
     D  vsplsc               214    215
      //
     D vnextvsav       s              1  0                                      refresh
     D rrn             s              5u 0
     D vsyncSav        s                   like(vsync)
     D RefreshFlg      s               n   inz(*off)
     D ExitPgmFlg      s               n   inz(*off)
     D                 ds                  inz
     D splno                          4s 0
     D spool_                  1      4
      //---------------------------------------------------------------
      // Error return code parm for APIs.
      //---------------------------------------------------------------
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                      50a                                        replacement data
     D uSpaceName      s             20a   inz('JCRCMDS   QTEMP     ')
      //---------------------------------------------------------------
      // Create Prototypes for calls
      //---------------------------------------------------------------
     D quscrtus        PR                  ExtPgm('QUSCRTUS')                   create user space
     D                               20                                         Space Name
     D                               10    const                                Extended Attrb
     D                               10i 0 const                                length of space
     D                                1    const                                Hex0Init
     D                               10    const                                Use Authority
     D                               50    const                                text
     D                               10    const                                replace object
     Db                                    like(vApiErrDS)                      error parm
      //   -------------------------------------------------------------
     D qusptrus        PR                  ExtPgm('QUSPTRUS')                   retrieve pointer
     D                               20                                         Space Name
     D                                 *                                        pointer
     Db                                    like(vApiErrDS)                      error parm
      //   -------------------------------------------------------------
     D quslspl         PR                  ExtPgm('QUSLSPL ')                   LIST SPOOLED FILES
     D                               20                                         Space Name
     D                                8    const                                TYPE FORMAT
     D                               10                                         WHICH USER
     D                               20                                         OUTQ LIB  20
     D                               10                                         FORM TYPE
     D                               10                                         USER DATA
     Db                                    like(vApiErrDS)                      error parm
      //   -------------------------------------------------------------
     D qusrspla        PR                  ExtPgm('QUSRSPLA')                   GET ATTRIBUTES
     Db                                    like(vsplat)                         RETURN VARIABLE
     D                               10i 0 const                                RETURN LENGTH
     D                                8    const                                TYPE FORMAT
     D                               26    const                                QUALIFIED JOB
     D                               16                                         INTERNAL JOB ID
     D                               16                                         INTERNAL SPOOL#
     D                               10    const                                SPOOL FILE NAME
     D                               10i 0 const                                SPOOLED FILE #
     Db                                    like(vApiErrDS)                      error parm
      //   -------------------------------------------------------------
     D ExecuteOptions  PR                                                       options processor
     D                                2  0                                      OPTION SELECTED
     D                               10a                                        SPOOLED FILE NAME
     D                                4a                                        SPOOLED FILE NUMBER
     D                               10a                                        JOB NAME
     D                               10a                                        USER NAME
     D                                6a                                        JOB NUMBER
      //   -------------------------------------------------------------
     D main            PR                  extpgm('JCRSPLFR')                   Input Parms
     D                               20A                                        OUTQ LIB 20
     D                               10A                                        USER PROFILE
     D                               10A                                        FORM TYPE
     D                               10A                                        USER DATA
      //   -------------------------------------------------------------
     D main            PI
     D  i_outqlib                    20A
     D  i_usrprf                     10A
     D  i_formtyp                    10A
     D  i_usrdta                     10A
      //-------------------------------------------------------------
      /free

 1b    if %subst(i_outqlib:1:4)='*ALL';
          i_outqlib='*ALL ';
 1e    endif;

       // create user space.
       callp   QUSCRTUS(
               uSpaceName:
               'TEST':
               4000000:
               x'00':
               '*ALL':
               'User Space JCR ':
               '*NO':
               vApiErrDs);

       callp   QUSPTRUS(
               uSpaceName:
               uHeadPtr:
               vApiErrDs);

       // -----------------------------------------------------------
       // Set looping subroutine so user can refresh screen
       // -----------------------------------------------------------
 1b    dou  ExitPgmFlg=*on;
          exsr  srRefreshScreen;
 1e    enddo;
       *inlr = *on;
       return;

       // -----------------------------------------------------------
       // call api to load user space with spooled file internal numbers.
       // -----------------------------------------------------------
       begsr  srRefreshScreen;
       callp  QUSLSPL(           //LOAD SPOOLED
              uSpaceName:        //SPACE    LIB
              'SPLF0100':        //TYPE FORMAT
              i_usrprf:          //WHICH USER
              i_outqlib:         //OUTQ LIB  20
              i_formtyp:         //FORM TYPE
              i_usrdta:          //USER DATA
              vApiErrDs);

       // ---------------------------------------------------------
       // Move through user space to get internal identifier number fields.
       // These identifiers are used to retrieve spooled file attributes.
       // ---------------------------------------------------------
       uListPtr = uHeadPtr + uOffSetToList;
 1b    for  forcnt = 1 to uNumOfEntrys;

          callp  QUSRSPLA(        //GET ATTRIBUTES
                 vsplat:          //RETURN VARIABLE
                 %size(vsplat):   //RETURN LENGTH
                 'SPLA0100':      //TYPE FORMAT
                 '*INT    ':      //QUALIFIED JOB
                 vijoba:          //INTERNAL JOB ID
                 vispla:          //INTERNAL SPOOL#
                 '*INT    ':      //SPOOL FILE NAME
                 0:
                 vApiErrDs);

          // -----------------------------------------
          // compress the status to 3 characters.
          // -----------------------------------------
 2b       if
             vstat = '*READY  ';
             status = 'RDY';
 2x       elseif
             vstat = '*OPEN   ';
             status = 'OPN';
 2x       elseif
             vstat = '*CLOSED ';
             status = 'CLO';
 2x       elseif
             vstat = '*HELD   ';
             status = 'HLD';
 2x       elseif
             vstat = '*SAVED  ';
             status = 'SAV';
 2x       elseif
             vstat = '*WRITING';
             status = 'WTR';
 2x       elseif
             vstat = '*PENDING';
             status = 'PND';
 2x       elseif
             vstat = '*PRINTER';
             status = 'PRT';
 2x       else;
             clear   status;
 2e       endif;

          // ---------------------------------------------------------
          // load subfile with spooled file names and attributes.
          // ---------------------------------------------------------
          pagnbr = vpag_b;
          curnbr = vpag_c;
          copies = vcop_b;
          splno  = vfil_b;
          spldat=vsplmm+'/'+vspldd+'/'+vsplyy;
          spltim=vsplhr+':'+vsplmn+':'+vsplsc;

          rrn=rrn+1;
          write  view1;
          write  view2;
          write  view3;
          uListPtr  = uListPtr  + uSizeOfEntry;
 1e    endfor;

       // -------------------------------------------------------
       // allow the user to make a selection from subfile.
       // -------------------------------------------------------
       vnextv = 2;
       vsync = 1;
       in_sfldsp = (rrn > 0);
       in_sfldspctl = *on;

       // ------------------------
 1b    if  RefreshFlg=*on and in_sfldsp;
 2b       if  vsyncSav > rrn;
             vsync=rrn;
 2x       else;
             vsync=vsyncSav;
 2e       endif;
          vnextv=vnextvsav;
          RefreshFlg=*off;
 1e    endif;
       // ------------------------
 1b    dow  not (fkey=f03);
 2b       if  fkey=f11;         //CHANGE VIEW
             vnextv =      vnextv +1;
 3b          if  vnextv > 3;
                vnextv = 1;
 3e          endif;
 2e       endif;

          write  keys;

          // ------------------------------
          // display the various views 1-3.
          // ------------------------------
          View1flg=*off;
          View2flg=*off;
          View3flg=*off;

 2b       if
             vnextv = 2;
             exfmt  contrl1;
             View1flg = *on;
 2x       elseif
             vnextv = 3;
             exfmt  contrl2;
             View2flg = *on;
 2x       elseif
             vnextv = 1;
             exfmt  contrl3;
             View3flg = *on;
 2e       endif;
          // user exit
 2b       if fkey=f03
             or fkey=f12;
             ExitPgmFlg=*on;
 LV          leavesr;
 2e       endif;

          vsync  = vbgrrn;
          // refresh
 2b       if  fkey=f05;
             RefreshFlg=*on;
             vsyncSav = vsync;
             vnextvsav=vnextv;
             in_sfldsp=*off;
             in_sfldspctl=*off;
             in_nodisplay=*off;
             write  contrl1;
             write  contrl2;
             write  contrl3;
             clear   rrn;
 LV          leavesr;
 2e       endif;
          // no records
 2b       if  in_sfldsp=*off;
 1i          iter;
 2e       endif;

          // -------------------------
          // process user requests
          // -------------------------
 2b       if
             View1flg;
             readc  view1;
 2x       elseif
             View2flg;
             readc  view2;
 2x       elseif
             View3flg;
             readc  view3;
 2e       endif;
 2b       dow  not %eof;

 3b          if  Options > 0;
                callp  ExecuteOptions(
                       Options:
                       splnm :
                       spool_:
                       jobnm :
                       usrid :
                       jobno);

                // ------------------------------------------
                // update subfile to reflect selected change.
                // ------------------------------------------
                in_nodisplay=*off;

 4b             if
                   Options = 3;
                   status = 'HLD';

 4x             elseif
                   Options = 4;
                   splnm  = 'DELETED';
                   clear   pagnbr;
                   clear   copies;
                   in_nodisplay = *on;

 4x             elseif
                   Options = 6;
                   status = 'RLS';
 4e             endif;

                clear   Options;

 4b             if
                   View1flg;
                   update  view1;
 4x             elseif
                   View2flg;
                   update  view2;
 4x             elseif
                   View3flg;
                   update  view3;
 4e             endif;
 3e          endif;

 3b          if
                View1flg;
                readc  view1;
 3x          elseif
                View2flg;
                readc  view2;
 3x          elseif
                View3flg;
                readc  view3;
 3e          endif;
 2e       enddo;
 1e    enddo;
       endsr;
      /end-free

       // -----------------------------------------------------------
       // Execute system command depending of option selected.
       // -----------------------------------------------------------
     PExecuteOptions   B
     D                 pi
     D i_Options                      2  0
     D i_snam                        10a
     D i_snum                         4a
     D i_jnam                        10a
     D i_unam                        10a
     D i_jnum                         6a
     D system          PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)
     D x               s             10I 0
     D SpoolString     s            100    varying
      /free
       SpoolString = 'FILE(' +
       %trimr(i_snam) + ') JOB('+
       i_jnum + '/' +
       %trimr(i_unam) + '/' +
       %trimr(i_jnam)  + ') SPLNBR(00' +
       i_snum + ')';

 1b    if
          i_Options=01;
          x=system('?SNDNETSPLF ' + SpoolString +
          ' ??TOUSRID(( ))');
 1x    elseif
          i_Options=02;
          x=system('?CHGSPLFA ' + SpoolString);
 1x    elseif
          i_Options=03;
          x=system('HLDSPLF '   + SpoolString);
 1x    elseif
          i_Options=04;
          x=system('DLTSPLF '   + SpoolString);
 1x    elseif
          i_Options=05;
          x=system('DSPSPLF '   + SpoolString);
 1x    elseif
          i_Options=06;
          x=system('RLSSPLF '   + SpoolString);
 1x    elseif
          i_Options=08;
          x=system('WRKSPLFA '  + SpoolString);
 1x    elseif
          i_Options=09;
          x=system('?CPYSPLF '  + SpoolString +
          ' ??TOFILE(  )');
 1e    endif;
       return;
      /end-free
     PExecuteOptions   E
