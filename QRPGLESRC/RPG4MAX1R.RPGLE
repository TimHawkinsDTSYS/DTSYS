     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('02/28/1996 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * RPG4MAX1R  - convert RPGIII style logic structures to extended F2.
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      *----------------------------------------------------------------
      * Convert    FACTOR1  IFxx  FACTOR2s  statements to   IF   EXTENDED FACTOR2.
      * Convert   *INxx = *ON  to *INxx           convert *INxx = *OFF to not *INxx
      * Convert   Factor1 *ON  to *INxx           convert *INxx = *OFF to not *INxx
      *----------------------------------------------------------------
      * program logic:   fairly bizarre|
      * Multifile logic was used to enable look ahead.
      * Look ahead was used to determine if the following statement was AND or OR.
      * Matching record logic was used to keep the update and lookahead files in sync.
      * Force logic was used to spin through the lookahead file if required to get the next
      * executable line of source.
      * I thought it real funny to use RPGII methods to update RPGIV code.
      *----------------------------------------------------------------
     Flookaheadrip   f  112        disk
     FModifySrc us   f  112        disk
      *
     D tabrelat        s              2    dim(6) ctdata perrcd(1)              EQ NE GT LT GE LE
     D tabsymbol       s              2    dim(6) alt(tabrelat)                 =  <> >  <  >= <=
      *
     D and_or_flg      s              3
     D forced_flg      s              1    inz(*off)                            nxt record is forced
     D new_opcode      s             10
     D old_opcode      s                   like(new_opcode)
     D relations       s              2
     D extendedf2      s             45
     D x               s              5u 0 inz
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
      *
      *----------------------------------------------------------------
     D                 ds
     Dsource                   1     92
     D  srcFactor1            24     37
     D  srcOpcode             38     47
     D      OpWhen                    4    overlay(srcOpcode:1)
     D      OpWhenRel                 2    overlay(srcOpcode:5)
     D      OpDox                     3    overlay(srcOpcode:1)
     D      OpDoxRel                  2    overlay(srcOpcode:4)
     D      OpIf                      2    overlay(srcOpcode:1)
     D      OpIfRel                   2    overlay(srcOpcode:3)
     D      OpAnd                     3    overlay(srcOpcode:1)
     D      OpAndRel                  2    overlay(srcOpcode:4)
     D      OpOr                      2    overlay(srcOpcode:1)
     D      OpOrRel                   2    overlay(srcOpcode:3)
     D  srcFactor2            48     61
     D  srcResult             62     75
     D  srcLength             80     80
      *
      *----------------------------------------------------------------
      * All lines that are comment or have the eject character are
      * ignored, also the first compile time table or array that is
      * found sets on LR.  The record type indicators are used to
      * determine which section of code will be executed.
      *----------------------------------------------------------------
     Ilookaheadrns  lr   13 c*   14 c*   15 c
     I         or        13 c*   14 c*   15 cc                                  named array
     I         or        13 c*   14 c*   15 cC                                  named array
      *
     I          ns  01
     I                                  1    6  look_seqn       m1
     I          ns  **
     I                                  1   42  look_ahead
     I                                 18   18  look_type
     I                                 19   19  look_comt
      *
     IModifySrc ns  02   18 cC   19nc*   19nc/
     I         or        18 cc   19nc*   19nc/
     I                                  1    6  match_seqn      m1
     I                                  1   92  source
     I                                 24   37  updFactor1
     I                                 38   47  updOpcode
     I                                 48   61  updFactor2
     I                                 62   75  updResult
     I          ns  05
     I                                  1    6  match_seqn      m1
      *----------------------------------------------------------------
      * An AND or OR opcode code may follow so the look-ahead is
      * used to determine which.  If a comment or copy statement
      * is found, the FORCE is used to check the next look ahead.
      *----------------------------------------------------------------
      /free
 1b    if  *in01;
          eval forced_flg = *off;
          eval and_or_flg = *blanks;

 2b       if  (look_type = 'C'  or look_type = 'c') and
             (look_comt <> '*'  and look_comt <> '/');

 3b          select;
 3x          when  (%subst(look_ahead:38:3) = 'AND')  or
                (%subst(look_ahead:38:3) = 'and');
 4b             if  (%subst(look_ahead:38+3:1))  >  ' ';
                   eval and_or_flg = 'and';
 4e             endif;

 3x          when  (%subst(look_ahead:38:2) = 'OR')  or
                (%subst(look_ahead:38:2) = 'or');
 4b             if  (%subst(look_ahead:38+2:1))  >  ' ';
                   eval and_or_flg = 'or ';
 4e             endif;
 3e          endsl;
 2x       else;
             FORCE  lookaheadr;     //read next
             eval forced_flg = *on;
 2e       endif;
 1e    endif;

       // --------------------------------------------
       // If a calc record spec and it was not forced.
       // --------------------------------------------
 1b    if  *in02;
          eval source = %xlate(LO:UP:source);
          clear   new_opcode;
          clear   old_opcode;
          eval *in11=*off;

 2b       select;
             // when      srcOpcode = 'MOVEL(P)' and srcLength = ' '
             // eval     new_opcode= 'eval '
             // eval     extendedf2 = %trimr(updResult)+ ' = ' +
             // (updFactor2)
             // except    UpdateSrc

             // --------------------------------------------
             // Only cat(p) with no padded spaces defined or
             // :0 padded spaces or :1
             // --------------------------------------------
 2x       when  srcOpcode = 'CAT(P)  ' and srcLength = ' ';
             eval new_opcode= 'eval ';

 3b          if  updFactor1 = *blanks;
                eval updFactor1 = updResult;  //load implicit
 3e          endif;

             eval x=%scan(':':updFactor2);
 3b          select;
 3x          when  x=0;                        //append as is
                eval extendedf2=%trim(updResult)+ ' = ' +
                %trim(updFactor1) + ' + ' + %trim(updFactor2);
                except  UpdateSrc;

 3x          when  %subst(updFactor2:x:3) = ':0 ';  // no spaces
                eval extendedf2 = %trimr(updResult)+ ' = %trimr('+
                %trim(updFactor1) + ') + ' + %subst(updFactor2:1:x-1);
                except  UpdateSrc;

 3x          when  %subst(updFactor2:x:3) = ':1 ';  // one space
                eval extendedf2 = %trimr(updResult) +
                ' = %trimr(' + %trim(updFactor1) + ') + ' +
                '''' + ' ' + '''' + ' + ' + %subst(updFactor2:1:x-1);
                except  UpdateSrc;
 3e          endsl;

             // ---------------------------------------------
             // Rest of the structure logic
             // ---------------------------------------------
 2x       when  OpWhen  = 'WHEN'  and OpWhenRel <> *blanks;
             eval new_opcode= %subst(updOpcode:1:4);
             eval relations = OpWhenRel;
             exsr  CalcExtend;

             // ---------------------------------------------
 2x       when  (OpDox  = 'DOW' or OpDox = 'DOU')  and
             OpDoxRel <> *blanks;
             eval new_opcode= %subst(updOpcode:1:3);
             eval relations = OpDoxRel;
             exsr  CalcExtend;

             // ---------------------------------------------
 2x       when  OpIf = 'IF' and OpIfRel <> *blanks;
             eval new_opcode= %subst(updOpcode:1:2);
             eval relations = OpIfRel;
             exsr  CalcExtend;

             // ---------------------------------------------
 2x       when  OpAnd = 'AND' and OpAndRel <> *blanks;
             eval new_opcode = *blanks;
             eval relations = OpAndRel;
             eval *in11 = *on;
             exsr  CalcExtend;

 2x       when  OpOr = 'OR' and OpOrRel <> *blanks;
             eval new_opcode = *blanks;
             eval relations = OpOrRel;
             eval *in11 = *on;
             exsr  CalcExtend;
 2e       endsl;
 1e    endif;

       // ---------------------------------------------
       // *in01 ifeq *on  converted to   if   *in01.
       // ---------------------------------------------
       begsr  CalcExtend;
 1b    if  relations = 'EQ' and
          %subst(srcFactor1:1:3) = '*IN' and
          (srcFactor2 = '*ON  ' or
          srcFactor2 = '*OFF ' or
          srcFactor2 = '''1''' or
          srcFactor2 = '''0''');

 2b       select;
 2x       when  srcFactor2 = '*ON  ' or
             srcFactor2 = '''1''';
             eval extendedf2 = updFactor1;

 2x       when  srcFactor2 = '*OFF ' or
             srcFactor2 = '''0''';
             eval extendedf2 = 'not ' + updFactor1;
 2e       endsl;

          // ---------------------------------------------
          // Update relationship testing code.
          // ---------------------------------------------
 1x    else;
          eval *in10=%tlookup(relations:tabrelat:tabsymbol);
          eval extendedf2 = %trimr(updFactor1) +                              // FACTOR 1
          ' ' + %trim(tabsymbol) + ' ' +                                       //RELATIONSHIP
          updFactor2;                                                          //FACTOR 2
 1e    endif;

       // ---------------------------------------------
       // Tack 'and' or 'or' to the end of factor two.
       // ---------------------------------------------
 1b    if  and_or_flg <> *blanks;
          eval extendedf2 = %trimr(extendedf2) + '  ' +
          and_or_flg;
 1e    endif;

       except  UpdateSrc;
       endsr;
      /end-free
     OModifySrc e            UpdateSrc
     O               11                          20 '  '
     O                                           37 '              '
     O                       new_opcode          47
     O                       extendedf2          92
**
EQ=
NE<>
LE<=
GE>=
LT<
GT>
