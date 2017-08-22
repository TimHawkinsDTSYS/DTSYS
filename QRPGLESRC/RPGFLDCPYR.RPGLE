     H DFTACTGRP(*NO) ACTGRP(*CALLER) BNDDIR('QC2LE') EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('01/03/2000 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * rpgfldcpyr - read through selected source code.  For each /copy
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      * Summary:
      *   1.  extract the source member name, file, library.
      *   2.  override file to selected member.
      *   3.  call RPGFLDGETR to get field definitions from copy sources.
      *----------------------------------------------------------------
     Fqrpgxxsrc ip   f  112        disk    extfile(i_extfile) extmbr(i_extmbr)
     D vb              s              5u 0 inz(0)                               found ' ' (Blank)
     D vc              s              5u 0 inz(0)                               found ,
     D vs              s              5u 0 inz(0)                               found /
     D vx              s             10i 0 inz(0)                               system return
     D i_slibfil       s             20a                                        copy source lib/file
     D i_smbr          s             10a                                        copy source member
     D i_sfil          s             10a                                        copy source lib
     D i_slib          s             10a                                        copy source lib
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D memPassPtr      s               *   inz(*null)
      *
      *    -------------------------------------------------------------
     D system          PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)
      *    -------------------------------------------------------------
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                      50a                                        replacement data
      *    -------------------------------------------------------------
     D  rpgfldgetr     PR                  ExtPgm('RPGFLDGETR')
     D   mempointer                    *                                        memory allocation
     D   i_slibfil                   20a                                        copy source lib/file
     D   i_smbr                      10a                                        copy source member
     D   errorcode                   10a
     D   commandname                 10a
      *    -------------------------------------------------------------
     D main            PR                  extpgm('RPGFLDCPYR')
     D  i_pMemPtr                      *                                        memory allocation
     D  i_extfile                    20A
     D  i_extmbr                     10A
     D  i_pcallingcmd                10A
     D  i_perror                     10A
      *    -------------------------------------------------------------
     D main            PI
     D  i_pMemPtr                      *
     D  i_extfile                    20A
     D  i_extmbr                     10A
     D  i_pcallingcmd                10A
     D  i_perror                     10A
      *
      *----------------------------------------------------------------
      *   read only the /COPY statements
      *----------------------------------------------------------------
     Iqrpgxxsrc ns  01   19 c/   20 cC                                          copy statement
     I         or        19 c/   20 cc
     I                                 25   60  srcdta
     I          ns  02
      *----------------------------------------------------------------
      *  1.  c/copy  mbr
      *  2.  c/copy  srcfil,mbr
      *  3.  c/copy  srclib/srcfil,mbr
      *----------------------------------------------------------------
      *  The first step is to determine what information is present in the copy statement.
      *  1.  If the statement contains a '/', then all 3 pieces of information are given.
      *  2.  If 1 is not true,  but it contains a ',' then srcfil, mbr are present.
      *  3.  If 1 and 2 are not true,  then member name only is given.
      *----------------------------------------------------------------
      /free
 1b    if  *in01;
          eval srcdta = %xlate(lo:up:srcdta);

          eval  vs = %scan('/':srcdta:1);
 2b       if  vs > 0;
             exsr  glibfilmbr;
 2x       else;
             eval  vc = %scan(',':srcdta:1);

 3b          if  vc > 0;
                eval  i_slib = '*LIBL';
                exsr  gfilmbr;
 3x          else;
                eval  i_slib = '*LIBL';
                eval  i_sfil = 'QRPGLESRC ';
                eval  vb = %scan(' ':srcdta:1);
                exsr  gmbr;
 3e          endif;
 2e       endif;

          eval  i_slibfil = %trimr(i_slib)+'/'+i_sfil;
          exsr  srCallPgm;
 1e    endif;
       // no way in free to detect end of input primary file
      /end-free
     Clr                 exsr      lrsub
      /free

       // ----------------------------------------------------
       // After all copy books,  process user selected member.
       // ----------------------------------------------------
       begsr  lrsub;
       eval  i_slibfil = i_extfile;
       eval  i_smbr = i_extmbr;
       exsr  srCallPgm;
       endsr;

       // ----------------------------------------------------
       // Make sure object is found before call.
       // Call program to load attributes.
       // ----------------------------------------------------
       begsr  srCallPgm;
       eval  vx=system('CHKOBJ OBJ('+ %trimr(i_slibfil) +') ' +
       'OBJTYPE(*FILE) MBR(' + %trimr(i_smbr) + ')');
 1b    if  vx=0;
          callp  RPGFLDGETR(i_pMemPtr:
                 i_slibfil:
                 i_smbr:
                 i_pError:
                 i_pCallingCmd);
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // Get srclib/srcfil,srcmbr.
       // Extract source library name..
       // Execute get file,mbr subroutine.
       // ----------------------------------------------------
       begsr  glibfilmbr;
       eval  i_slib = %subst(srcdta:1:vs-1);
       eval  srcdta = %subst(srcdta:vs+1);
       eval  vc = %scan(',':srcdta:1);
       exsr  gfilmbr;
       endsr;

       // ----------------------------------------------------
       // Get srcfil,srcmbr.
       // Extract source file name.
       // Trimr srcdata over to where srcmbr starts then execute
       // the get mbr subroutine.
       // ----------------------------------------------------
       begsr  gfilmbr;
       eval  i_sfil = %subst(srcdta:1:vc-1);
       eval  srcdta = %subst(srcdta:vc+1);
       eval  vb = %scan(' ':srcdta:1);
       exsr  gmbr;
       endsr;

       // ----------------------------------------------------
       // Get srcmbr.
       // Extract source member name
       // ----------------------------------------------------
       begsr  gmbr;
       eval  i_smbr = %subst(srcdta:1:vb-1);
       endsr;
      /end-free
