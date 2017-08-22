     H DFTACTGRP(*NO) ACTGRP(*CALLER) BNDDIR('QC2LE') EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO) debug
     H COPYRIGHT('02/24/1986 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * ifnumbr    - rpg4 source structure numbering - update source code
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      * 1/14/99  - add code to generate end matching in the same text case as the end opcode
      *               ex:  END  will become ENDIF
      *                    End  will become Endif
      *                    end  will become endif
      * 2/9/01   - added support for FOR/ENDFOR opcodes
      *             marked LEAVESR opcodes
      * 9/17/01  - added check source type so only RPGLE and SQLRPGLE code would be updated
      * 1/04/02  - support for /free source.
      * 1/20/2002 - /free source code reformat based on logic structures
      *----------------------------------------------------------------
     Fqrpgmbr   uf   f  112        disk    extfile(exfile) extmbr(i_smbr) usropn
     D ado             s              5i 0 dim(100) inz(0)                      DO DEPTH ARRAY
     D op              s              3    dim(100)                             OPCODE FOR ENDS
     D SelectDepth     s               n   dim(100) inz(*off)                   Flag for select
     D aa              s              3u 0 inz(0)
     D bb              s              3u 0 inz(0)
     D cc              s              3u 0 inz(0)
     D dd              s              5i 0 inz(0)
     D ee              s              3u 0 inz(0)
     D pp              s              3u 0 inz(0)
     D ww              s              3u 0 inz(0)
     D q1              s              3u 0 inz(0)
     D q2              s              3u 0 inz(0)
     D EndOfCode       s              3u 0 inz(0)
     D StartOfComment  s              3u 0 inz(0)
     D alpha135        s            135a
     D i_sfil          s             10a
     D i_slib          s             10a
     D StructNumb      s              5a                                        structure marker
     D exfile          s             20a
     D WrkA            s                   like(opcode_src)
     D WBlanks         s             94a   varying
     D WrkB            s            188a
     D WrkB2           s            188a
     D FreeFlg         s               n   inz(*off)
     D CompileTimeFlg  s               n   inz(*off)
     D CalcSpecFlg     s               n   inz(*off)
     D CommentFlg      s               n   inz(*off)
     D PastInlComment  s               n   inz(*off)
     D CasFlg          s               n   inz(*off)
     D CallpFlg        s               n   inz(*off)
     D EndCheatFlg     s               n   inz(*off)
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D FirstDigitOpc   s              1a                                        opcode case
     D SecondDigitOpc  s              1a
     D UpperSrc        s                   like(all_src)
     D WCode           s                   like(all_src)
     D WComm           s                   like(all_src)
     D YellowHex       c                   const(x'32')
     D WhiteHex        c                   const(x'22')
     D BlueHex         s              1a   inz(x'3A')
     D GreenHex        s              1a   inz(x'20')
     D QS              c                   const('''')
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
     D main            PR                  extpgm('IFNUMBR')
     D  i_smbr                       10A   const                                SOURCE MBR
     D  i_sfil_slib                  20A   const                                SOURCE FILE LIB
     D  i_hilitec                     4A   const                                HIGH LIGHT CMNT
     D  i_markcolor                   4A   const                                COLORED MARKERS
     D  i_endlabel                    4A   const                                LABEL END OPCOD
     D  i_indentfree                  4A   const                                REFORMAT INDENT
     D  i_indentspace                 1p 0 const                                INDENT SPACES
      *    -------------------------------------------------------------
     D main            PI
     D  i_smbr                       10A   const
     D  i_sfil_slib                  20A   const
     D  i_hilitec                     4A   const
     D  i_markcolor                   4A   const
     D  i_endlabel                    4A   const
     D  i_indentfree                  4A   const
     D  i_indentspace                 1p 0 const
      *----------------------------------------------------------------
     D   opcode_src    ds
     D   opcode                      10a   overlay(opcode_src:1)
     D   opcode1                      1a   overlay(opcode_src:1)
     D   opcode2                      2a   overlay(opcode_src:1)
     D   opcode3                      3a   overlay(opcode_src:1)
     D   opcode4                      4a   overlay(opcode_src:1)
     D   opcode5                      5a   overlay(opcode_src:1)
     D   opcode6                      6a   overlay(opcode_src:1)
      *----------------------------------------------------------------
     Iqrpgmbr   ns
     I                             a    1    4  seqno
     I                             a   13   14  CompileTimeA
     I                             a   13   17  ProjectID
     I                             a   18   18  line_type
     I                             a   19   19  comment
     I                             a   20   20  comment2
     I                             a   19   27  FreeForm
     I                             a   19   20  SubRoutine
     I                             a   38   47  opcode_src
     I                             a   19  112  all_src
     I                             a   20  112  all_src2
      *----------------------------------------------------------------
      * set based on parm values
      /free
 1b    if   i_markcolor='*NO ';
          eval  BlueHex=*blanks;
          eval  GreenHex=*blanks;
 1e    endif;
       eval  *in11 = (i_endlabel = '*YES');
       eval  *in50 = (i_hilitec = '*YES');

       // determine member type.
       callp  QUSRMBRD(
              alpha135:
              135:
              'MBRD0100':
              i_sfil_slib:
              i_smbr:
              '0':
              vapierrds);
 1b    if  %subst(alpha135:49:10) = 'RPGLE    ' or
          %subst(alpha135:49:10) = 'SQLRPGLE ';

          eval  i_sfil = %subst(alpha135:9:10);
          eval  i_slib = %subst(alpha135:19:10);
          eval  exfile=%trimr(i_slib)+'/'+i_sfil;
          // -------------------------------------------------
          open  qrpgmbr;
          read  qrpgmbr;
 2b       dow  not %eof;

             // do not process compile time arrays
 3b          if  CompileTimeA='**';
 2v             leave;
 3e          endif;

             // If project ID is set, don't clear it.
             if (%subst(ProjectID:1:1) >= '0'  and
                 %subst(ProjectID:1:1) <= '9') or
                 %scan('|':ProjectID)  <> *zero;
 2v             *in41 = *on;
             else;
 2v             *in41 = *off;
             endif;

             // spin through until we get into the C specs proper.
             // if C or c or /free,  we are in C specs.

             line_type = %xlate(lo:up:line_type);

 3b          if       line_type = 'F' or
 3b                   line_type = 'D' or
 3b                   line_type = 'C' or
 3b                   line_type = 'O' or
 4b                   %scan('/copy':%xlate(up:lo:all_src)) <> *zero;
                eval  PastInlComment=*on;
 3e          endif;

 3b          if       line_type = 'C';
                eval  CalcSpecFlg=*on;
 3e          endif;

 3b          if  (line_type = 'O') or
                 (line_type = 'D') or
                 (line_type = 'F');
                eval  CalcSpecFlg=*off;
 3e          endif;

             // see if inside /free section
 3b          if       comment = '/';
                eval FreeForm = %xlate(lo:up:FreeForm);
 4b             select;
 4x             when  FreeForm='/FREE';
                   eval  FreeFlg=*on;
                   eval  CalcSpecFlg=*on;
 4x             when  FreeForm='/END-FREE';
                   eval  FreeFlg=*off;
 4e             endsl;
 3e          endif;

             // see if // free comment line
             eval  CommentFlg=*off;
 3b          if  FreeFlg=*on;
 4b             if  %len(%triml(all_src))>1              and
                    %subst((%triml(all_src)):1:2)='//'   and
 4b                 %scan('*****':all_src) = *zero       and
 4b                 %scan('* * *':all_src) = *zero;
                   eval  CommentFlg=*on;
                   exsr srIndentFree;
                   except  u_commntf;
 4e             endif;
 3x          else;
 4b             if          comment  = '*'     and                                  //skip SQL stuff
 4b                         comment2 = *blanks and                                  //skip SQL stuff
                            PastInlComment;
                   eval  CommentFlg=*on;
 4b                if  %scan('*****':all_src) = *zero  and
 4b                    %scan('* * *':all_src) = *zero  and
 4b                    %scan(' -- ':all_src ) = *zero  and
 4b                    comment2  = *blanks and
 4b                    all_src2 <> *blanks and
 4b                    PastInlComment;                                              //skip SQL stuff
 4e                // eval *in51 = *on;
                      except  u_commnt;
 4e                else;
 4e                // eval *in51 = *off;
                      except  u_comrmv;
 4e                endif;
                // except  u_commnt;
 4e             endif;
 3e          endif;
             // -------------------------------------------------

 3b          if  CalcSpecFlg=*on
                and CommentFlg=*off;
                eval  *in30=*off;                                                     //SR remove
                eval  *in40=*on;                                                      //Inside calcs

 4b             if          comment = '/'                                           //skip SQL stuff
                   or comment = '+';
                   except  u_clear;
 4x             else;
                   // -------------------------------------------------
                   // For v5r1 /free code,  do a little work to get the opcode
                   // into opcode_src field.
                   // Look for first ';' and first ';'  , which ever not
                   // zero and lowest value is end of opcode
                   // -------------------------------------------------
 5b                if  FreeFlg=*on
                      and all_src <> *blanks;
                      eval  WrkA=%triml(all_src);
                      eval  aa=%scan(' ':WrkA:1);
                      eval  bb=%scan(';':WrkA:1);
                      clear   opcode_src;
 6b                   select;
 6x                   when  aa>0 and (aa<bb or bb=0);
                         eval  opcode_src=%subst(WrkA:1:aa-1);
 6x                   when  bb>0 and (bb<aa or aa=0);
                         eval  opcode_src=%subst(WrkA:1:bb-1);
 6e                   endsl;
 5e                endif;

                   // save case of opcode for matching ends
                   eval  FirstDigitOpc = %subst(opcode_src:1:1);
                   eval  SecondDigitOpc = %subst(opcode_src:2:1);
                   eval opcode_src = %xlate(lo:up:opcode_src);

 5b                if  FreeFlg=*off;
                      eval SubRoutine = %xlate(lo:up:SubRoutine);
                      eval  *in30 = (SubRoutine = 'SR');
 5e                endif;

                   // Load xB for IF and SELECT opcodes.
 5b                select;
 5x                when     (opcode2='IF' and FreeFlg=*off)
                      or (opcode_src ='IF  ' and FreeFlg=*on)
                      or (opcode3 ='IF(' and FreeFlg=*on);
                      exsr  srLoadBeginB;

 5x                when  (opcode_src = 'SELECT ');
                      exsr  srLoadBeginB;
                      eval  SelectDepth(cc) = *on;

                      // -------------------------------------------------
                      // save the most recent 'DO'/FOR number for use as indent nt
                      // on iter and leave operations. the number is saved into array
                      // whose element position is how many dos and element
                      // value represents the number of that do.
                      // -------------------------------------------------
 5x                when     (opcode2='DO' and FreeFlg=*off)
                      or (opcode='DO  ' and FreeFlg=*on)
                      or (opcode='DOU ' and FreeFlg=*on)
                      or (opcode='DOW ' and FreeFlg=*on)
                      or opcode = 'FOR    '
                      or opcode4 = 'FOR(';
                      exsr  srLoadBeginB;
                      eval  dd = dd + 1;
                      eval  ado(dd) = cc;

                      // -------------------------------------------------
                      // CASxx opcodes.  the trick is there could be several
                      // cas opcodes in a row and only first each group is
                      // used to trigger record update.
                      // CasFlg is setof when an end is found.
                      // -------------------------------------------------
 5x                when      opcode3 = 'CAS'
                      and CasFlg=*off
                      and FreeFlg=*off;
                      exsr  srLoadBeginB;
                      eval  CasFlg=*on;

                      // -------------------------------------------------
                      // process else, wh, & other op codes.  Update record
                      // and count remains the same.
                      // -------------------------------------------------
 5x                when  opcode_src = 'GOTO  '  //EVIL GOTO STATEMENTS
                      and FreeFlg=*off;
                      eval  StructNumb = BlueHex+'GO'+GreenHex;
                      except  u_ifnum;

                      // -------------------------------------------------
                      // flag LEAVESR for easy viewing
                      // -------------------------------------------------
 5x                when  opcode_src = 'LEAVESR ';
                      eval  StructNumb = BlueHex+'LV'+GreenHex;
 6b                   if i_indentfree='*YES' and FreeFlg=*on;
                         exsr srIndentFree;
 6e                   endif;
                      except  u_ifnum;

                      // -------------------------------------------------
                      // process the else, wh, & other op codes.  Update
                      //  record and count remains the same.
                      // -------------------------------------------------
 5x                when     (opcode2='WH' and FreeFlg=*off)
                      or opcode= 'OTHER '
                      or opcode= 'ELSE  '
                      or opcode= 'ELSEIF '
                      or opcode= 'WHEN  ';
                      eval  StructNumb = BlueHex+%char(cc)+'x'+GreenHex;
 6b                   if i_indentfree='*YES' and FreeFlg=*on;
                         eval EndCheatFlg =*on;
                         exsr srIndentFree;
                         eval EndCheatFlg =*OFF;
 6e                   endif;
                      except  u_ifnum;

                      // -------------------------------------------------
                      // process the iter opcode.  i is moved into the code
                      //  and therecord is updated using the innermost
                      // do count depth save array.
                      // -------------------------------------------------
 5x                when  opcode_src =  'ITER ';
                      eval  StructNumb=BlueHex+%char(ado(dd))+'i'+GreenHex;
 6b                   if i_indentfree='*YES' and FreeFlg=*on;
                         exsr srIndentFree;
 6e                   endif;
                      except  u_ifnum;

                      // -------------------------------------------------
                      // process the leave opcode.  Load V into code and the
                      // record is updated using innermost do count from do
                      // depth save array.
                      // -------------------------------------------------
 5x                when  opcode_src = 'LEAVE  ';
                      eval  StructNumb=BlueHex+%char(ado(dd))+'v'+GreenHex;
 6b                   if i_indentfree='*YES' and FreeFlg=*on;
                         exsr srIndentFree;
 6e                   endif;
                      except  u_ifnum;

                      // -------------------------------------------------
                      // process endxx .  E is moved into code and record
                      // is updated. depth has 1 subtracted after update.
                      // -------------------------------------------------
 5x                when  opcode <> 'ENDSR'
                      and (  (opcode3 = 'END' and FreeFlg=*off)
                      or opcode='END   '
                      or opcode='ENDSL '
                      or opcode='ENDIF '
                      or opcode='ENDDO '
                      or opcode='ENDFOR ');
                      eval   CasFlg = *off;
                      eval  StructNumb = BlueHex+%char(cc)+'e'+GreenHex;

                      // -------------------------------------------------
                      // if cc = 0 then there are too many END opcodes.
                      // Send message with statement number where error
                      // occurred.
                      // -------------------------------------------------
 6b                   if  cc<=0;
                         close  qrpgmbr;
                         callp  QMHSNDPM(
                                '       ':'                    ':
                                'WARNING: Unmatched ENDxx opcode at ' +
                                seqno + ' - IFNUMB canceled!':
                                65:'*INFO  ':'*CTLBDY ': 1:'    ':
                                vApiErrDS);
                         eval  *inlr=*on;
                         return;
 6e                   endif;

                      // -------------------------------------------------
                      // match the proper endxx to opcode that started the
                      // structure.  ie. if/endif , do/enddo
                      // If the END is free format, is required to have the
                      // proper endXX suffix
                      // -------------------------------------------------
 6b                   If i_endlabel = '*YES';
 7b                      select;
 7x                      when  op(cc) = 'SE';
                            eval  opcode_src = 'endsl';
 7x                      when  op(cc) = 'CA';
                            eval  opcode_src = 'endcs';
 7x                      other;
                            eval  opcode_src = 'end' + op(cc);
 7e                      endsl;

                         // -------------------------------------------------
                         // Determine text case of the end opcode.  Write out
                         // matching ENDxx in same case as it was before.
                         // -------------------------------------------------
 7b                      select;
 7x                      when  %scan(FirstDigitOpc:up)=0;
                            eval opcode_src = %xlate(up:lo:opcode_src);

 7x                      when  %scan(SecondDigitOpc:up)>0;
                            eval opcode_src = %xlate(lo:up:opcode_src);

 7x                      other;
                            eval opcode_src = %xlate(up:lo:opcode_src);
                            eval opcode1 = %xlate(lo:up:opcode1);
 7e                      endsl;

 7b                      if FreeFlg=*off;
                            except  u_endxx;
 7x                      else;
                            // ----------------------------------------------
                            // determine size of existing end statement,
                            // then use %replace
                            // ----------------------------------------------
                            eval uppersrc = %xlate(lo:up:all_src);
                            eval aa=%scan('END':uppersrc);
                            eval bb=%scan(';':all_src:aa);
                            eval all_src=%replace(%trimr(opcode_src)+';':
                            all_src:aa:(bb-aa)+1);
 8b                         if i_indentfree='*YES';
                               eval EndCheatFlg =*on;
                               exsr srIndentFree;
                               eval EndCheatFlg =*off;
 8e                         endif;
                            except  u_freeend;
 7e                      endif;
 6e                   endif;

                      // -------------------------------------------------
                      // if END is for innermost do, then clear that
                      // element of the do number array.
                      // -------------------------------------------------
 6b                   if  (dd > 0) and (ado(dd) = cc);
                         eval  ado(dd) = 0;
                         eval  dd = dd - 1;
 6e                   endif;
                      eval  cc = cc - 1;
                      eval  ee = ee - 1;
 6b                   if cc>0;
                         eval  SelectDepth(cc)=*off;
 6e                   endif;

                      // -------------------------------------------------------------
                      // if none of above conditions are met, the excpt is used
                      // to clear record from whatever may have been there before.
                      // -------------------------------------------------------------
 5x                other;
 6b                   if i_indentfree='*YES' and FreeFlg=*on;
                         exsr srIndentFree;
 6e                   endif;
                      except  u_clear;
 5e                endsl;

 4e             endif;
 3e          endif;

             read  qrpgmbr;
 2e       enddo;

          // -----------------------------------------------------------
          // load the indent count into the return parm if there are not
          // enough endxx statements for the code.
          // -----------------------------------------------------------
 2b       if  cc > 0;
             close  qrpgmbr;
             callp  QMHSNDPM(
                    '       ':'                    ':
                    'WARNING: '+%trimr(%editc(cc:'4')) +
                    ' ENDxx opcodes are missing. ' +
                    '- IFNUMB canceled!':
                    65:'*INFO  ':'*CTLBDY ': 1:'    ':
                    vApiErrDS);
             eval  *inlr=*on;
             return;
 2e       endif;

          // Send completion message
          close  qrpgmbr;
          callp  QMHSNDPM(
                 '       ':'                    ':
                 'Update of ' +
                 %trimr(i_smbr) + ' in ' +
                 %trimr(i_slib) + '/' +
                 %trimr(i_sfil)  + ' - completed':
                 65:'*INFO  ':'*CTLBDY ': 1:'    ':
                 vApiErrDS);
 1e    endif;
       eval  *inlr=*on;
       return;

       // ------------------------------------------------
       // load the number of the begin and the opcode name
       // for use when flagging ends.
       // ------------------------------------------------
       begsr  srLoadBeginB;
 1b    if i_indentfree='*YES' and FreeFlg=*on;
          exsr srIndentFree;
 1e    endif;
       eval  cc = cc + 1;
       eval  ee = ee + 1;
       eval  StructNumb = BlueHex+%char(cc)+'b'+GreenHex;
       except  u_ifnum;
 1b    if opcode2 = 'FO';
          eval  op(cc) = 'FOR';
 1x    else;
          eval  op(cc) = opcode2;
 1e    endif;
       endsr;

       // -----------------------------------------------------------
       // reformat indentions for /free code.
       // if indention would make calc line go past 74
       // then indent line as much as possible but do not go past 74.
       // -----------------------------------------------------------
       begsr  srIndentFree;
 1b    if all_src <> *blanks;

 2b       if EndCheatFlg =*on;
             eval  ee=ee-1;
 2e       endif;

          // parms under the callp are synced to begininng (
 2b       if callpflg=*on;
             clear  wrkb;
             eval  %subst(wrkb:pp)=%triml(all_src);
 2x       else;
             eval %len(wblanks)=i_indentspace * ee;
             eval wrkb=' ' + Wblanks + %triml(all_src);
 2e       endif;
          exsr IndentOrNot;

 2b       if EndCheatFlg =*on;
             eval  ee=ee+1;
 2e       endif;

          // set CALLPARM flag if with in callp
          // first ; outside a comment resets to off
 2b       if opcode6='CALLP ' or opcode6='CALLP(';
             eval CallpFlg=*on;

             // now to get where the program name starts
             // callp(e) pgm(   we waht to line up with pgm.
             eval pp=%scan('(':all_src);
 3b          if opcode6='CALLP(';
                eval pp=%scan('(':all_src:pp+1);
 3e          endif;
 3b          for  aa=pp downto 1 by 1;
 4b             if        %subst(all_src:aa:1)=' ';
 3v                leave;
 4e             endif;
 3e          endfor;
             eval pp=aa+1;
 2e       endif;

          // now to turn the callp flag off.  The trigger will be first
          // ; that is not behind a comment line.
          eval aa=%scan(';':all_src);
 2b       if aa>0;
             eval bb=%scan('//':all_src);
 3b          if bb=0 or bb>aa;
                eval CallpFlg=*off;
 3e          endif;
 2e       endif;

 1e    endif;
       endsr;
       //-------------------------------------------------------
       // Ok,  two pieces distinct pieces of information on a /free line.
       // with different rules for where they can be placed in the code.
       // 1. code   2.comment
       // 1. code is defined as everything before a // (if // is not inside
       // quotations)
       // eval x='  // this is not a comment'    // this is a comment
       // 2. comment is anything after an unquoted // including the //.
       // This 'code can only go to 92 but comments can go to 112' adds
       // whole new level of complexity to the whole thing!
       // After indentation,
       // 1. If code will not fit at position 92.  Cannot Indent.
       // 2. If code will fit at 92 and comment will fit at 112.  Indent OK
       // 3. If code will fit at 92 and comment will NOT fit at 112:
       // Is there enough space between the end of the code and
       // the start of the comment to compress out spaces?
       //  eval x=a                   // qweqweqwe
       // eval x=a //qweqweqwe
       // If after compression,  (see #2),  else if it still will not fit,
       // do not indent.
       //-------------------------------------------------------
       begsr IndentOrNot;
 1b    if   %len(%trimr(wrkb)) <=74  // all good it will fit
          or (CommentFlg=*on
          and %len(%trimr(wrkb))<=94);
          eval  all_src = wrkb;
 1x    else;
          //--------------------------------------------------------
          //  determine length of code,
          //  if will not fit in 74,  cannot indent
          //  find starting postion of last // in code
          //--------------------------------------------------------
          clear StartOfComment;
          clear ww;
 2b       dou ww=0;
             eval ww=%scan('//':wrkb:ww+1);
 3b          if ww>0;
                eval StartOfComment=ww;
 3e          endif;
 2e       enddo;

 2b       if StartOfComment=0; // source code will not fit in 74
 LV          leavesr;
 2e       endif;

          //--------------------------------------------------------
          // determine if // is between two quotes
          // Note this could get tripped up if there are
          // quotes in the comment and code. Oh well, I tried!
          // Sure bet would be not to put quotes after //.
          // If no quotes after //, then we have a legit comment.
          //--------------------------------------------------------
          eval q2=%scan(qs:wrkb:StartOfComment);
 2b       if q2>0;
             clear q1;
 3b          for ww=StartOfComment downto 1 by 1; //look for preceding qoute
 4b             if %subst(wrkb:ww:1)=qs;
                   eval q1=ww;
 3v                leave;
 4e             endif;
 3e          endfor;
 3b          if q1>0 and (q1<StartOfComment and q2>StartOfComment);
 LV             leavesr; //  the comment marker is with in quotes
 3e          endif;
 2e       endif;

          //--------------------------------------------------------
          // If we get here, we have a source that will fit
          // but the comments will not.
          // see if there are any spaces between the end of the code
          // and the start of the comment that can be compressed
          // out. If so,  compress and see if indented line will
          // fit.
          //--------------------------------------------------------
          eval EndOfCode=%checkr(' ':wrkb:StartOfComment-1);
          eval %len(wblanks)=StartOfComment - EndofCode;
 2b       dou %len(wblanks)=1;
             eval wrkb2=%subst(wrkb:1:EndOfCode) +
             wblanks + %subst(wrkb:StartOfComment);
 3b          if %len(%trimr(wrkb2))<=94;
                eval  all_src = wrkb2;
 LV             leavesr;
 3e          endif;
             eval %len(wblanks)=%len(wblanks)-1;
 2e       enddo;
 1e    endif;
       endsr;
      /end-free

     Oqrpgmbr   e            u_clear
     O              N41                          17 '     '
     O                       all_src            112
      *--free comment    -------------
     O          e   N41      u_commntf
     O                                           18 '      '
     O               50      WhiteHex            17
     O                       all_src            112
      *--columnar comment-------------
     O          e            u_commnt
     O              N41                          18 '      '
     O                                           19 ' *'
     O               50      WhiteHex            18
      *--columnar comment-------------
     O          e            u_comrmv
     O              N41                          18 '      '
      *-------------------------------
     O          e            u_ifnum
     O              N41      StructNumb          17
     O               30                          18 '  '
     O                       all_src            112
      *-------------------------------
     O          e            u_freeend
     O              N41      StructNumb          17
     O               30                          20 '  '
     O                       all_src            112
      *-------------------------------
     O          e            u_endxx
     O              N41      StructNumb          17
     O               30                          20 '  '
     O               11      opcode_src          47
      *---------------------------------------------
