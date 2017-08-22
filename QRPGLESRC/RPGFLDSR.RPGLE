     H DFTACTGRP(*NO) ACTGRP(*CALLER) BNDDIR('QC2LE') EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('03/06/1996 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * rpgfldsr  - lengths of fields used in rpg4
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      * 12/12/1999 - created load engine RPGFLDGETR to
      *              load field attributes.
      * 12/04/2001 - use alloc memory instead of data queue method
      *----------------------------------------------------------------
      * program summary:
      * allocate memory for fields names array
      * call program to process fields in /copy books
      *      call program to load field names & attributes into memory
      * unload memory to subfile.
      *----------------------------------------------------------------
     Frpgfldsd  cf   e             workstn sfile(data:rrn) usropn infds(dsinf)
     F                                                            indds(dsind)
     Frpgfldsp  o    e             printer oflind(in_overflow) usropn
     Frpgfldspf o    e             disk    usropn
     D dsinf           ds
     D fkey                           1    overlay(dsinf:369)
     D  f03            c                   const(X'33')
     D  f06            c                   const(X'36')
     D  f12            c                   const(X'3C')
      *----------------------------------------------------------------
      * Name screen indicators
     D dsind           ds
     D in_sfldsp                       n   overlay(dsind:1)
     D in_sfldspctl                    n   overlay(dsind:2)
     D in_overflow     s               n   inz(*off)
      *
     D vsetll          s             14a
     D vx              s             10i 0 inz(0)                               system return
     D vy              s              5u 0
     D rrn             s              5u 0
     D DoNumb          s              5u 0
     D FilErr          s             10a                                        rpgfldgetr error
     D alpha135        s            135
     D Decimals        ds
     D  flddec                        2  0
     D memFields       ds                  based(memptr1)
     D  memNumEntries                 5u 0
     D  memEntryLen                   5u 0
     D memPassPtr      s               *   inz(*null)
      *
      *----------------------------------------------------------------
      * map field description data from memory
      *----------------------------------------------------------------
     D MapFldDta       ds                  based(memptr2)
     D  field                        14
     D  fldlen                        5  0
     D  decpos                        2
     D  dtatyp                        1
     D  fldsrc                       10
     D  fldtxt                       25
      *----------------------------------------------------------------
      * Create Prototypes for calls
      *----------------------------------------------------------------
     D rpgfldcpyr      PR                  ExtPgm('RPGFLDCPYR')                 process fields
     D                                 *                                        memory allocation
     D  i_extfile                    20A
     D  i_smbr                       10A
     D  i_pcallingcmd                10A   const
     D  i_perror                     10A
      *    -------------------------------------------------------------
     D qmhrmvpm        PR                  ExtPgm('QMHRMVPM')                   remove messages
     D                               10    const                                MSG QUEUE
     D                               10i 0 const                                STACK ENTRY
     D                                4    const                                MSG KEY
     D                               10    const                                REMOVE OPTION
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
     D qmhsndpm        PR                  ExtPgm('QMHSNDPM')                   SEND MESSAGES
     D                                7a   const                                ID
     D                               20a   const                                FILE
     D                               65a   const                                TEXT
     D                               10i 0 const                                LENGTH
     D                               10a   const                                TYPE
     D                               10a   const                                QUEUE
     D                               10i 0 const                                STACK ENTRY
     D                                4a   const                                KEY
     Db                                    like(vApiErrDS)
      *    -------------------------------------------------------------
     D system          PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)
      *    -------------------------------------------------------------
     D qusrmbrd        PR                  ExtPgm('QUSRMBRD')                   RETRIEVE MBR DESC
     D                              135a                                        RECEIVER
     D                               10i 0 const                                LENGTH OF RECVR
     D                                8a   const                                UPLOAD TYPE
     D                               20a   const                                FILE   LIB
     D                               10a   const                                MEMBER NAME
     D                                1a   const                                PROCESS OVERIDE
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
      * error data structure for apis
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                      50a                                        replacement data
      *    -------------------------------------------------------------
     D main            PR                  extpgm('RPGFLDSR ')                  Input Parms
     D  i_smbr                       10A
     D  i_sfil_slib                  20A
     D  i_output                     10A
     D  i_outfile_p                  20A
     D  i_outmbr_p                   20A
      *    -------------------------------------------------------------
     D main            PI                                                       Input Parms
     D  i_smbr                       10A
     D  i_sfil_slib                  20A
     D  i_output                     10A
     D  i_outfile_p                  20A
     D  i_outmbr_p                   20A
      *
     D  i_sfil         s             10A
     D  i_slib         s             10A
     D  i_extfile      s             20A
     D  i_outfile      s             10A
     D  i_outfilelib   s             10A
     D  i_outmbr       s             10A
     D  i_mbropt       s              8A
      *----------------------------------------------------------------
      /free

       exsr ChkMbrType;
       exsr AllocMem;
       exsr ProcSource;

       select;
         when i_output = '*';
           exsr LoadSubfile;
           exsr DisplaySubfile;

         when i_output = '*PRINT';
           exsr Print;

         when i_output = '*OUTFILE';
           exsr CrtOutfile;
           exsr WrtOutfile;
       endsl;
 1e
       exsr CompletionMessage;
 1e
       eval  *inlr=*on;
       return;

       // ----------------------------------------------------
       // Check member type.
       // ----------------------------------------------------
       begsr  ChkMbrType;

       callp  QUSRMBRD(
              alpha135:                                                           //RECEIVER
              135:                                                                //LENGTH OF RECVR
              'MBRD0100':                                                         //UPLOAD TYPE
              i_sfil_slib:                                                        // FILE   LIB
              i_smbr:                                                             //MEMBER NAME
              '0':                                                                //PROCESS OVERIDE
              vapierrds);

       // If not valid type bail.

 1b    if  %subst(alpha135:49:10) <> 'RPGLE    ' and                              //CONTINUE
           %subst(alpha135:49:10) <> 'SQLRPGLE ';
         eval  *inlr=*on;
         return;
 1e    endif;

       // Extract source file and library.

       eval  i_sfil = %subst(alpha135:9:10);
       eval  i_slib = %subst(alpha135:19:10);
       eval  i_extfile=%trimr(i_slib) + '/' + i_sfil;   // external file    name

       endsr;

       // ----------------------------------------------------
       // Allocate memory.
       // ----------------------------------------------------
       begsr AllocMem;

          // Allocate memory for field attribute loader to use
          // and initialize the entry counter and size fields
          eval  memptr1=%alloc(228004);
          eval  memNumEntries=0;
          eval  memEntryLen=57;
          eval  memPassPtr=memPtr1;

       endsr;

       // ----------------------------------------------------
       // Process source.
       // ----------------------------------------------------
       begsr ProcSource;

       // process copy books and selected source
       callp  rpgfldcpyr(memPassPtr:
              i_extfile:
              i_smbr:
              'RPGFLDS   ':
              FilErr);

       // if file-not-found error, send message
2b       if  FilErr <> *blanks;
           dealloc  memptr1;
           callp  qmhsndpm('CPD0006':'QCPFMSG   *LIBL     ':
                  '0000 *ERROR*  External file ' +
                  %trimr(FilErr) + ' not found in *libl.':
                  70:'*DIAG':'*CTLBDY':1:'    ':vApiErrDS);

           callp  qmhsndpm('CPD0002':'QCPFMSG   *LIBL     ':
                  '                                       ':
                  30:'*ESCAPE':'*CTLBDY':1:'    ':vApiErrDS);
           eval  *inlr=*on;
           return;
2e       endif;

       endsr;

       // ----------------------------------------------------
       // Load subfile.
       // ----------------------------------------------------
       begsr LoadSubfile;

       // Open display file and clear message queue.

       open  rpgfldsd;
       exsr ClrPgmMsgq;

       // Write to subfile.

       for  donumb = 1 to memNumEntries;
         eval  memptr2 = memPtr1 + (rrn * memEntryLen)+5;
         eval  rrn     = rrn + 1;
         write data;
       endfor;

       dealloc  memptr1;

       // Send message if no fields are found.

       eval  in_sfldsp = (rrn > 0);

       if  in_sfldsp = *off;
         callp  QMHSNDPM(
                'CPF9897':'QCPFMSG   *LIBL     ':
                'No Fields defined in program ':
                40:
                '*INFO'  :
                '*    ':
                0        :
                '    '   :
                vApiErrDS);
       endif;

       endsr;

       // ----------------------------------------------------
       // Display subfile.
       // ----------------------------------------------------
       begsr DisplaySubfile;

       eval  DoNumb = rrn;
       eval  vsync = 1;
       eval  in_sfldspctl = *on;

       dow  not (fkey=f03);
          write  msgsflc;
          write  keys;
          exfmt  contrl;
          if  in_sfldsp=*off
             or fkey=f03
             or fkey=f12;
             leave;
          endif;

          if  fkey=f06;
            exsr Print;
          endif;

          if  fkey<>f06;
            eval  vy=%checkr(' ':vscrky);
            if  vy = 0;
              eval  vsync = 1;
              iter;
            endif;
          endif;

       enddo;

       endsr;

       // ----------------------------------------------------
       // Print subfile.
       // ----------------------------------------------------
       begsr Print;

       open  rpgfldsp;
       write  head1;

       for  donumb = 1 to memNumEntries;
         eval  memptr2 = memPtr1 + (rrn * memEntryLen)+5;
         eval  rrn     = rrn + 1;
         write detail;

         if in_OverFlow;
           write  head1;
           clear  in_OverFlow;
         endif;
       endfor;

       dealloc  memptr1;

       endsr;

       // ----------------------------------------------------
       // Position the subfile.
       // ----------------------------------------------------
       begsr PositionSubfile;

       for  rrn = 1 to DoNumb;
          chain  rrn data;

          eval  vsetll = %subst(field:1:vy);
          if  vscrky <= vsetll  or
             DoNumb = rrn;
             eval  vsync = rrn;
             leave;
          endif;
       endfor;

       endsr;

       // ----------------------------------------------------
       // Create outfile and outmember (should be in a called pgm).
       // ----------------------------------------------------
       begsr CrtOutfile;

       // Break down parameters.

       eval i_outfile    = %subst(i_outfile_p:01:10);
       eval i_outfilelib = %subst(i_outfile_p:11:10);

       eval i_outmbr     = %subst(i_outmbr_p :03:10);
       eval i_mbropt     = %subst(i_outmbr_p :13:08);

       // Set output member name if *FIRST is used.

 1b    if  i_outmbr = '*FIRST';
         eval i_outmbr = i_outfile;
       endif;

       // Create outfile and remove the members.

       eval  vx=system('CHKOBJ OBJ('+ %trimr(i_outfilelib) + '/' +
                                      %trimr(i_outfile   ) + ') +
                               OBJTYPE(*FILE)');
 1b    if  vx<>0;
         eval  vx=system('CRTDUPOBJ OBJ(RPGFLDSPF) FROMLIB(*LIBL) +
                                    OBJTYPE(*FILE) +
                                    TOLIB('  + %trimr(i_outfilelib) + ') +
                                    NEWOBJ(' + %trimr(i_outfile   ) +')');

         eval  vx=system('RMVM FILE('+ %trimr(i_outfilelib) + '/' +
                                       %trimr(i_outfile   ) + ') +
                               MBR(*ALL)');
 1b    endif;

       // Change maximum members.

       eval  vx=system('CHGPF FILE('+ %trimr(i_outfilelib) + '/' +
                                      %trimr(i_outfile   ) + ') +
                              MAXMBRS(*NOMAX) ');

       // Add outfile member.

       eval  vx=system('CHKOBJ OBJ('+ %trimr(i_outfilelib) + '/' +
                                      %trimr(i_outfile   ) + ') +
                               OBJTYPE(*FILE) +
                               MBR(' + %trimr(i_outmbr    ) + ')');
 1b    if  vx<>0;
         eval  vx=system('ADDPFM FILE('+ %trimr(i_outfilelib) + '/' +
                                         %trimr(i_outfile   ) + ') +
                                 MBR(' + %trimr(i_outmbr    ) + ') +
                                 TEXT(''Length of Fields Used in RPG'') ');
 1b    endif;

       // Override to outfile.

       eval  vx=system('OVRDBF FILE(RPGFLDSPF) +
                               TOFILE('+ %trimr(i_outfilelib) + '/' +
                                         %trimr(i_outfile   ) + ') +
                                 MBR(' + %trimr(i_outmbr    ) + ')');

       // Clear member.

 1b    if  i_mbropt = '*REPLACE';
         eval  vx=system('CLRPFM FILE('+ %trimr(i_outfilelib) + '/' +
                                         %trimr(i_outfile   ) + ') +
                                 MBR(' + %trimr(i_outmbr    ) + ')');
 1b    endif;

       // Clear message queue.

       exsr ClrPgmMsgq;

       endsr;

       // ----------------------------------------------------
       // Write to outfile.
       // ----------------------------------------------------
       begsr WrtOutfile;

       // Open physical file and clear message queue.

       open  rpgfldspf;
       exsr  ClrPgmMsgq;

       // Write to outfile.

       for  donumb = 1 to memNumEntries;
         eval  memptr2    = memPtr1 + (rrn * memEntryLen)+5;
         eval  rrn        = rrn + 1;
         eval  srcfilelib = i_slib;
         eval  srcfile    = i_sfil;
         eval  srcmbr     = i_smbr;
         eval  fldnam     = field ;
         eval  fldtyp     = dtatyp;
         eval  fldlen     = fldlen;
         eval  fldsrc     = fldsrc;
         eval  fldtxt     = fldtxt;
         eval  flddec     = *zero;

         if    fldtyp = 'P' or
               fldtyp = 'Z' or
               fldtyp = 'B';
           select;
             when %subst(decpos:1:1)  = *blanks and
                  %subst(decpos:2:1) <> *blanks;
               eval %subst(decimals:2:1) = %subst(decpos:2:1);

             when %subst(decpos:1:1) <> *blanks and
                  %subst(decpos:2:1) <> *blanks;
               eval decimals = decpos;
           endsl;
         endif;

         write  rpgfldsr;
       endfor;

       dealloc  memptr1;

       endsr;

       // ----------------------------------------------------
       // Clear program message queue.
       // ----------------------------------------------------
       begsr ClrPgmMsgq;

       eval  qm_msgq='*';
       callp  QMHRMVPM(
              '*    ':
              0:
              '   ':
              '*ALL':
              vApiErrDs);

       endsr;

       // ----------------------------------------------------
       // Send completion message.
       // ----------------------------------------------------
       begsr CompletionMessage;

          close  rpgfldsd;
          callp  QMHSNDPM(
                 '       ':'                    ':
                 'Field display for ' +
                 %trimr(i_smbr) + ' in ' +
                 %trimr(i_slib) + '/' +
                 %trimr(i_sfil)  + ' completed.':
                 65:'*INFO  ':'*CTLBDY ': 1:'    ':
                 vApiErrDS);

       endsr;
      /end-free
