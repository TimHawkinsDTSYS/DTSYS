     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('02/28/1996 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * RPG4MAX5R  - Insert D specs before I or C specs                     rms)
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      *----------------------------------------------------------------
     Fqrpglesrc uf a f  112        disk
      *----------------------------------------------------------------
     D spectype        s              1               inz
     D srcseq          s              6  2            inz
     D comment         s            112               inz
      *
     D Csource         s            112    dim(32767) inz
     D Cspecs          s              1n              inz
     D Cmaxsrc         s              5  0            inz
     D Csrcrec         s              5  0            inz
     D Clstsrcrec      s              5  0            inz
      *
     D Dsource         s            112    dim(32767) inz
     D Dspecs          s              1n              inz
     D Dmaxsrc         s              5  0            inz
     D Dsrcrec         s              5  0            inz
     D Dlstsrcrec      s              5  0            inz
      *----------------------------------------------------------------
     Iqrpglesrc ns
     I                                  1  112  srctext
      *----------------------------------------------------------------
      * Run process to insert D specs.
      *----------------------------------------------------------------
      /free
 2x
2x      exsr Store;
        exsr FindICspec;
        exsr InsertUpto;
        exsr InsertDspecs;
        exsr InsertToEnd;
2x
        eval *inLR = *on;
        return;

        // ----------------------------------------
        // Store current version of the member.
        // ----------------------------------------
        begsr Store;

2x      read   qrpglesrc;

2x      dow  not %eof;
2x        eval spectype = %subst(srctext:18);

2x        if   spectype = 'C' or spectype = 'c';
2x          eval Cspecs = *on;
          endif;

2x        if   Cspecs   and
2x             spectype = 'D' or spectype = 'd';
2x          eval Dspecs = *on;
          endif;

2x        if not Dspecs;
2x          eval Cmaxsrc += 1;
2x          eval Csource(Cmaxsrc) = srctext;
          endif;

2x        if     Dspecs;
2x          eval Dmaxsrc += 1;
2x          eval Dsource(Dmaxsrc) = srctext;
          endif;

2x        if  %subst(srctext:19:80) = '*';
2x          eval comment = srctext;
          endif;

2x        delete qrpglesrc;

2x        read   qrpglesrc;
        enddo;

        endsr;

        // ----------------------------------------
        // Find I or C specs.
        // ----------------------------------------
        begsr FindICspec;

2x      for Csrcrec = 1 to Cmaxsrc;
2x        eval spectype = %subst(Csource(Csrcrec):18);

2x        if   spectype = 'I' or spectype = 'i'  or
2x             spectype = 'C' or spectype = 'c';
2x          leave;
          endif;
        endfor;

2x      for Csrcrec = Csrcrec-1 downto 1 by -1;

2x        if %subst(Csource(Csrcrec):18) <> ' ' or
2x           %subst(Csource(Csrcrec):19) <> '*';
2x          eval  Clstsrcrec = Csrcrec;
2x          leave;
          endif;
        endfor;

        endsr;

        // ----------------------------------------
        // Insert source up to I or C specs.
        // ----------------------------------------
        begsr InsertUpto;

2x      for Csrcrec = 1 to Clstsrcrec;
2x        eval   srctext   = Csource(Csrcrec);
2x        eval   srcseq   += 1;
2x        except wrtrec;
        endfor;

        endsr;

        // ----------------------------------------
        // Insert D specs.
        // ----------------------------------------
        begsr InsertDspecs;

2x      if  Dmaxsrc <> *zero;
2x        eval   srctext   = comment;
2x        eval   srcseq   += 1;
2x        except wrtrec;
        endif;

2x      for Dsrcrec = 1 to Dmaxsrc;
2x        eval spectype  = %subst(Dsource(Dsrcrec):18);

2x        if   spectype = 'I' or spectype = 'i'  or
2x             spectype = 'C' or spectype = 'c';
2x          leavesr;
          endif;

2x        eval  Dlstsrcrec = Dsrcrec + 1;

2x        eval   srctext   = Dsource(Dsrcrec);
2x        eval   srcseq   += 1;
2x        except wrtrec;
        endfor;

        endsr;

        // ----------------------------------------
        // Insert source up to the end.
        // ----------------------------------------
        begsr InsertToEnd;

2x      if     Clstsrcrec = *zero;
2x        eval Clstsrcrec = 1;
        endif;

2x      for Csrcrec = Clstsrcrec to Cmaxsrc;
2x        eval spectype  = %subst(Csource(Csrcrec):18);

2x        if   spectype = 'D' or spectype = 'd';
2x          leavesr;
          endif;

2x        eval   srctext   = Csource(Csrcrec);
2x        eval   srcseq   += 1;
2x        except wrtrec;
        endfor;

        endsr;

      /end-free

     Oqrpglesrc eadd         wrtrec
     O                       srctext            112
     O                       srcseq               6
