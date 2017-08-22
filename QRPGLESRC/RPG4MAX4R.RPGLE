     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('02/28/1996 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * RPG4MAX4R  - Generate D specs for program defined fields  (except parms)
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      *----------------------------------------------------------------
     Fmodifysrc up a f  112        disk
     D defined         s             14    dim(32767)
     D d               s              5u 0
     D x               s                   like(d)
     D a               s                   like(d)
     D fldstorage      s                   dim(%elem(defined)) like(storageds)
     D f               s                   like(d)
     D upperlimit      s                   like(d) inz(%elem(defined))
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D likedefine      s             20
     D storageds       ds
     D  dsuppercas                   14
     D  dsfactor1                    14
     D  dsfactor2                    14
     D  dsresult                     14
     D  dslength                      5
     D  dsdecimals                    2
     D  dstext                       20
      *----------------------------------------------------------------
      * All lines that are comment or have the eject character are
      * ignored, also the first compile time table or array that is
      * found sets on LR.  The record type indicators are used to
      * determine which section of code will be executed.
      *----------------------------------------------------------------
     Imodifysrc ns  lr   13 c*   14 c*   15 c
     I         or        13 c*   14 c*   15 cc                                  named array
     I         or        13 c*   14 c*   15 cC                                  named array
     I          ns  02   19nc*   19nc/   19nc+
     I                                  1    6 2srcseqno
     I                                 18   18  spectype
     I                                 19   33  srcdspecs
     I                                 24   37  srcfactor1
     I                                 38   47  srcopcode
     I                                 48   61  srcfactor2
     I                                 62   75  srcresult
     I                                 76   80  srclength
     I                                 81   82  srcdecimal
     I                                 93  112  srctext
     I          ns  05
      *----------------------------------------------------------------
      * If a calc record spec and it was not forced.
      *----------------------------------------------------------------
      /free
 1b    if  *in02;
 2b       select;
 2x       when  (spectype = 'D' or spectype = 'd') and
             srcdspecs > *blanks;
             eval  srcdspecs = %xlate(lo:up:srcdspecs);
             eval  d = d + 1;
             eval  defined(d) = %triml(srcdspecs);

             // ----------------------------------------
 2x       when  (spectype = 'C' or spectype = 'c') and
             srcopcode <> *blanks;
             eval  srcopcode = %xlate(lo:up:srcopcode);
 3b          if  (srcopcode <> 'IF   ' and
                srcopcode <> 'WHEN ' and
                srcopcode <> 'FOR  ' and
                srcopcode <> 'AND  ' and
                srcopcode <> 'OR   ' and
                srcopcode <> 'DOU  ' and
                srcopcode <> 'DOW  ' and
                %subst(srcopcode:1:4) <> 'EVAL' and
                srclength <> *blanks) or
                srcopcode = 'DEFINE ';

                eval  *in10=*off;
 4b             if  srcopcode = 'DEFINE ';
                   eval  srcfactor1 = %xlate(lo:up:srcfactor1);
                   eval  *in10 = (srcfactor1 <> '*LIKE   ');
 5b                if  *in10=*off;
 6b                   if  %scan('(':srcfactor2)>0;
                         eval  *in10=*on;
 6e                   endif;
 5e                endif;
 4e             endif;

 4b             if  not *in10;
                   eval  dsuppercas = %xlate(lo:up:srcresult);
                   eval  x = %lookup(dsuppercas:defined:1:d);
                   eval  *in10=(x>0);
 5b                if  not *in10;
                      eval  d=d+1;
                      eval  defined(d) = dsuppercas; //Set as defined

 6b                   if  srcopcode <> 'PARM ';
                         eval  dsfactor1 = srcfactor1;
                         eval  dsfactor2 = srcfactor2;

                         // ---------------------------------------------
                         // Caution: Some result fields could have the
                         //  :(date type) extender.
                         // example  a  subdur  b  c:*D     3  0
                         // We only want to load up to the ':'
                         // ---------------------------------------------
                         eval  a = %scan(':':srcresult:1);
 7b                      if  a > 0;
                            eval  srcresult = %subst(srcresult:1:a-1);
 7e                      endif;

                         eval  dsresult = srcresult;
                         eval  dslength = srclength;
                         eval  dsdecimals = srcdecimal;
                         eval  dstext  = srctext;
                         eval  f=f+1;
                         eval  fldstorage(f) = storageds;
 6e                   endif;
 5e                endif;

 5b                select;
 5x                when  srcopcode = 'PARM ' and not *in10; //leave defined

 5x                when  srcopcode = 'DEFINE ';
                      except  deleterec;
 5x                other;
                      except  removelen;
 5e                endsl;
 4e             endif;
 3e          endif;
 2e       endsl;
 1e    endif;
      /end-free
     Clr                 exsr      lrsubrout
      /free
       // --------------------------------------------------
       // Process back through array and write D specs.
       // --------------------------------------------------
       begsr  lrsubrout;
       sorta  fldstorage;
       eval  x = upperlimit - f + 1;
 1b    for  f = x to upperlimit;
          eval  srcseqno =  srcseqno+.01;
          eval  storageds=fldstorage(f);
          eval  *in11 = (dsfactor1 = '*LIKE   ');
 2b       if  *in11;
             eval  likedefine='like(' + %trimr(dsfactor2) +')';
 2e       endif;
          except  gendefine;
 1e    endfor;
       endsr;
      /end-free
     Omodifysrc eadd         gendefine
     O                       srcseqno             6
     O                                           12 '000000'
     O                                           18 'D'
     O                       dsresult            33
     O                                           36 's'
     O                       dslength            51
     O                       dsdecimals          54
     O               11      likedefine          75
     O                       dstext             112
      *
     O          e            removelen
     O                                           82 '       '
      *
     O          edel         deleterec
