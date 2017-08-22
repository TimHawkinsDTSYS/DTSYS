     H bnddir('TTBNDDIR')
     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('03/12/1996 Craig Rutledge <craigru@alltel.net>')
      *---------------------------------------------------------------------
      * RPG4MAX3R - convert alpha case of source code.
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      *---------------------------------------------------------------------
     Fqrpglesrc up   f  112        disk
     FdspffdL3  if   e           k disk
      *
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D noactionc       c                   const('*NOACTION   ')
     D upallc          c                   const('*UPALL      ')
     D lowallc         c                   const('*LOWALL     ')
     D upoplowc        c                   const('*UPOP_LOWALL')
     D upoponlyc       c                   const('*UPOP_ONLY  ')
      *
     D                 ds
     D src                     1     94
     D varray                  1     94    dim(94)
      *
     D Plus            s               n   inz
     D UpperCase       s               n   inz
     D LowerCase       s               n   inz
     D ApostropheFound...
     D                 s               n   inz
     D apos            s              1    inz('''')
     D apostrophe      s              5u 0
     D x               s              5u 0
     D y               s              5u 0
     D WrkSrc          s                   like(src)
      *    ----------------------------------------------------------------
      *  Prototype for Extract words
     D ExtWords        PR          1024    dim(50) opdesc
     D  ChrString                  1024    options(*varsize)
      *
     D Words           s           1024    dim(50)
     D WordsApos       s               n   dim(50)
      *    ----------------------------------------------------------------
     D main            PR                  extpgm('RPG4MAX3R')
     D  i_styletype                  12A
      *    ----------------------------------------------------------------
     D main            PI
     D  i_styletype                  12A
      *---------------------------------------------------------------------
     Iqrpglesrc ns  lr   13 c*   14 c*   15 c
     I         or        13 c*   14 c*   15 cc                                  named array
     I         or        13 c*   14 c*   15 cC                                  named array
     I          ns  01   19nc*   19nc/
     I                                 18   18  srcspec
     I                                 18   55  d_extended
     I                                 38   47  srcopcode
     I                                 19  112  src
     I          ns  05
      *---------------------------------------------------------------------
      /free
 1b    if  *in01;
          eval  *in30 = *off;
          eval  srcspec    = %xlate(lo:up:srcspec);

 2b       if  i_styletype <> upoponlyc;
             exsr  CheckWordCase;
             exsr  changeall;
             exsr  chkDBfield;
             exsr  chkDBkeys;
             exsr  chkBegsr;
             exsr  chkInd;
             exsr  ReplaceWord;
 2e       endif;

 2b       if  srcspec = 'C' and
             (i_styletype = upoplowc  or
              i_styletype = upoponlyc);
             eval  *in30 = *on;
             eval  srcopcode = %xlate(lo:up:srcopcode);
 2e       endif;
 1e    endif;

       // --------------------------------------------------
       // Check word case.
       // --------------------------------------------------
       begsr  CheckWordCase;

       eval Words     = *blanks;
       eval WordsApos = *off;

       eval WrkSrc   = src;
       eval WrkSrc   = %xlate(':':' ':WrkSrc);
       eval WrkSrc   = %xlate('(':' ':WrkSrc);
       eval WrkSrc   = %xlate(')':' ':WrkSrc);

       eval Words = ExtWords(WrkSrc);
1b     for x = 1 to %elem(Words);

 2b    if %scan(apos:Words(x)) > *zero;
         eval WordsApos(x) = *on;
 2e    endif;

         if Words(x)       <> *blanks and
            Words(x)       <> '*'     and
            %len(Words(x)) >= 4;
         eval UpperCase  = *off;
         eval LowerCase  = *off;

  b        for y = 1 to 26;
             if not UpperCase and
               %scan(%subst(up:y:1):Words(x)) > *zero;
               eval UpperCase = *on;
    e        endif;

             if not LowerCase and
               %scan(%subst(lo:y:1):Words(x)) > *zero;
               eval LowerCase = *on;
    e        endif;

             if UpperCase and LowerCase;
               leave;
    e        endif;
    e      endfor;

         if not UpperCase and
            not LowerCase;
           eval Words(x) = *blanks;
  e      endif;

e        endif;
e      endfor;

       endsr;
       // --------------------------------------------------
       // Change all to lower case.
       // --------------------------------------------------
       begsr  changeall;
       eval   apostrophe = *zero;

 2b    if  %scan('+           ':src)       > *zero  and
 2b        %scan('eval':%xlate(up:lo:src)) = *zero  or
 2b        %scan(apos:src)                 > *zero;
         eval  plus = *on;
 2e    else;
         eval  plus = *off;
 2e    endif;

 1b    for x = 1 to 74;

 2b       if  varray(x) = apos;
             eval  apostrophe += 1;
 2e       endif;

          // --------------------------------------------------
          // If extended D spec or record id, do not xlate.
          // or if first letter is L, as in L1, do not xlate
          // --------------------------------------------------
 2b       if  (d_extended = 'D           '  or
               d_extended = 'd           ') or
             srcspec    = 'I' and
             (x         = 24  or
              x         = 32  or
              x         = 40) or
              x         = 1   and
              varray(x) = 'L';
 2x       else;

 3b          if  not plus              and
 3b              varray(x) <> *blanks  and
 3b             (apostrophe = 0        or
                 apostrophe = 2        or
                 apostrophe = 4        or
                 apostrophe = 6        or
                 apostrophe = 8);
                select;
 4x             when  i_styletype = upallc;
                   eval  varray(x) = %xlate(lo:up:varray(x));
 4x             other;
                   eval  varray(x) = %xlate(up:lo:varray(x));
 4e             endsl;
 3e          endif;
 2e       endif;
 1e    endfor;
       endsr;

       // --------------------------------------------------
       // Check for database fields.
       // --------------------------------------------------
       begsr  chkDBfield;

 1b    for x = 1 to %elem(Words);

 2b    if     Words(x) = *blanks or
              Words(x) = '*'     or
 2b           WordsApos(x);
         eval Words(x) = *blanks;
 2b      iter;
 2b    endif;

 2b    eval  WHfldi = Words(x);
2b     eval  WHfldi = %xlate(lo:up:%trim(WHfldi));
       //
       // Set copy book members.
       //

 2b    select;
 2b      when   Words(x) = '$PMCLR';
 2b        eval Words(x) = '$PMclr';
 2b        iter;
 2b      when   Words(x) = '$PMCMQ';
 2b        eval Words(x) = '$PMcmq';
 2b        iter;
 2b      when   Words(x) = '$PMCPY';
 2b        eval Words(x) = '$PMcpy';
 2b        iter;
 2b      when   Words(x) = '$PMEMQ';
 2b        eval Words(x) = '$PMemq';
 2b        iter;
 2b      when   Words(x) = '$PMMOV';
 2b        eval Words(x) = '$PMmov';
 2b        iter;
 2b      when   Words(x) = '$PMRCV';
 2b        eval Words(x) = '$PMrcv';
 2b        iter;
 2b      when   Words(x) = '$PMRMQ';
 2b        eval Words(x) = '$PMrmq';
 2b        iter;
 2b      when   Words(x) = '$PMRTV';
 2b        eval Words(x) = '$PMrtv';
 2b        iter;
 2b      when   Words(x) = '$PMSBM';
 2b        eval Words(x) = '$PMsbm';
 2b        iter;
 2b      when   Words(x) = '$PMSMQ';
 2b        eval Words(x) = '$PMsmq';
 2b        iter;
 2b      when   Words(x) = '$PMSND';
 2b        eval Words(x) = '$PMsnd';
 2b        iter;
 2b      when   Words(x) = '$PMTAC';
 2b        eval Words(x) = '$PMtac';
 2b        iter;
 2b      when   Words(x) = '$PMXMQ';
 2b        eval Words(x) = '$PMxmq';
 2b        iter;
 2b    endsl;
       //
       // Ignore specific fields.
       //
 2b    if    WHfldi              = *blanks     or
 2b          WHfldi              = 'PARMS'     or
 2b          WHfldi              = 'OPTN'      or
 2b          WHfldi              = 'OPTN1'     or
 2b          WHfldi              = 'OPTN2'     or
 2b          WHfldi              = 'ADDENT'    or
 2b          WHfldi              = 'DLTCNF'    or
 2b          WHfldi              = 'LIST  '    or
 2b          WHfldi              = 'DSPTXT'    or
 2b          WHfldi              = 'CSRFLD'    or
 2b          WHfldi              = 'CSRREC'    or
 2b          WHfldi              = 'CSRCOL'    or
 2b          WHfldi              = 'CSRROW'    or
 2b          WHfldi              = 'CSRRRN'    or
 2b          WHfldi              = 'SETCSRPOS' or
 2b          WHfldi              = 'SFLNXTCHG' or
 2b          WHfldi              = 'SFLRCDNBR' or
 2b          WHfldi              = 'OPTTX1'    or
 2b          WHfldi              = 'OPTTX2'    or
 2b          WHfldi              = 'KEYTX1'    or
 2b          WHfldi              = 'KEYTX2'    or
 2b          %subst(WHfldi:1:3)  = '*IN'       or
 2b          %len(%trim(WHfldi)) < 5;
         eval Words(x) = *blanks;
 2b      iter;
       endif;
       //
       // Hunt for a database field in the Tour System.
       //
 2b    setll WHfldi QWHdrffd;
 2b    reade WHfldi QWHdrffd;

2b     dow not %eof;
         if WHfile <> 'DSFLD'     and
            WHlib   = 'TSDEVOBJ'  or
            WHlib   = 'TSPRDOBJ'  or
            WHlib   = 'TSDEVDTA'  or
            WHlib   = 'TSPRDDTA'  or
            WHlib   = 'CTIPRDOBJ' or
            WHlib   = 'CTIPRDDTA';
           leave;
         endif;

2b     reade WHfldi QWHdrffd;
       enddo;

 2b    if %eof;
         eval Words(x) = *blanks;
         iter;
       endif;
       //
       // Found a valid DB field, convert to XXyyyyy.
       //
2b     eval %subst(WHfldi:3:8) = %xlate(up:lo:%subst(Whfldi:3:8));

       eval Words(x) = WHfldi;
 1e    endfor;

       endsr;

       // --------------------------------------------------
       // Check for database keys.
       // --------------------------------------------------
       begsr  chkDBkeys;

 2b    eval  WHfldi = %xlate(lo:up:%subst(src:6:10));

 2b    if      WHfldi <> *blanks;
 2b      if      %subst(%xlate(lo:up:srcopcode):1:5) = 'CHAIN'  or
 2b              %subst(%xlate(lo:up:srcopcode):1:5) = 'SETLL'  or
 2b              %subst(%xlate(lo:up:srcopcode):1:5) = 'READE'  or
 2b              %subst(%xlate(lo:up:srcopcode):1:5) = 'READP'  or
 2b              %subst(%xlate(lo:up:srcopcode):1:6) = 'READPE' or
 2b              %subst(%xlate(lo:up:srcopcode):1:5) = 'DELET'  or
 2b              %subst(%xlate(lo:up:srcopcode):1:5) = 'PLIST'  or
 2b              %subst(%xlate(lo:up:srcopcode):1:5) = 'KLIST';

  2b        if     %subst(WHfldi:3:3) = 'KEY' or
  2b               %subst(WHfldi:3:2) = 'KY';
 2b           eval  %subst(src:6:02) = %xlate(lo:up:%subst(src:6:02));
 2e         endif;

 2e      endif;
 2e    endif;

       endsr;

       // --------------------------------------------------
       // Check for begin subroutine.
       // --------------------------------------------------
       begsr  chkBegsr;

 2b    if      %subst(%xlate(lo:up:srcopcode):1:5) = 'BEGSR' or
 2b            %subst(%xlate(lo:up:srcopcode):1:5) = 'ENDSR';

 2b           eval  %subst(src:1:2) = %xlate(lo:up:%subst(src:1:2));
 2e    endif;

       endsr;

       // --------------------------------------------------
       // Check for indicators.
       // --------------------------------------------------
       begsr  chkInd;

 1b    for x = 2 to 74;

 2b      eval  WHfldi = %xlate(lo:up:%subst(src:x:4));

 2b      if      WHfldi = '*IN0' or
 2b              WHfldi = '*IN1' or
 2b              WHfldi = '*IN2' or
 2b              WHfldi = '*IN3' or
 2b              WHfldi = '*IN4' or
 2b              WHfldi = '*IN5' or
 2b              WHfldi = '*IN6' or
 2b              WHfldi = '*IN7' or
 2b              WHfldi = '*IN8' or
 2b              WHfldi = '*IN9' or
 2b              WHfldi = '*INK' or
 2b              WHfldi = '*INL';
 2b        eval  %subst(src:x+1:2) = %xlate(up:lo:%subst(src:x+1:2));
 2b        eval  %subst(src:x+3:2) = %xlate(lo:up:%subst(src:x+3:2));
 2e      endif;

 1e    endfor;
       endsr;

       // --------------------------------------------------
       // Replace words if changed.
       // --------------------------------------------------
       begsr  ReplaceWord;

1b     for x = 1 to %elem(Words);

   2b    if     Words(x) = *blanks or
                Words(x) = '*'     or
                WordsApos(x);
   2b      iter;
   2b    endif;

         if %scan(%trim(%xlate(up:lo:Words(x))):
                  %xlate(up:lo:src)) > *zero;

            eval src = %replace(%trim(Words(x)):src:
                                %scan(%trim(%xlate(up:lo:Words(x))):
                                      %xlate(up:lo:src)):
                                      %len(%trim(Words(x))) );
  1e     endif;
1e     endfor;

       endsr;

       // --------------------------------------------------
       // Initialize initial variables.
       // --------------------------------------------------
       begsr  *inzsr;

 1b    if  i_styletype = noactionc;
          eval  *inLR = *on;
          return;
 1e    endif;

       endsr;

      /end-free

     Oqrpglesrc d    01
     O                       src                112
     O               30      srcopcode           47
     O                       srcspec             18
