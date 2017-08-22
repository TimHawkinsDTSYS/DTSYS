     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)
     H COPYRIGHT('02/28/1996 Craig Rutledge <craigru@alltel.net>')
     H cvtopt(*VARCHAR) alwnull(*USRCTL)
     H option(*NOXREF:*SRCSTMT:*NODEBUGIO)
      *----------------------------------------------------------------
      * RPG4MAX2R  - convert codes to EVAL
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      *----------------------------------------------------------------
      * program summary:
      * Convert character Fields and Constant  moves to EVAL
      * MOVE rules are:        %size(Factor2) = %size(Result)      CONVERT
      *
      * MOVEL rules are:       %size(Factor2) = %size(Result) or   CONVERT
      *                        %size(Factor2) > %size(Result)      CONVERT
      *
      * Z-ADD rules are:       %size(Factor2) = %size(Result) or   CONVERT
      *                        %size(Factor2) > %size(Result)      CONVERT
      *
      * Z-SUB rules are:       same as z-add except no *zeros
      *
      * ADD rule :             %size(Factor1) < %size(Result) and
      *                        %size(Factor2) < %size(Result)
      *
      * MULT rule :            %size(Factor1) < %size(Result) and
      *                        %size(Factor2) < %size(Result)
      *
      * 12/04/2001 - use alloc memory instead of data queue method
      *----------------------------------------------------------------
     Fmodifysrc up   f  112        disk
     D memFields       ds                  based(memptr1)
     D  memNumEntries                 5u 0
     D  memEntryLen                   5u 0
     D memPassPtr      s               *   inz(*null)
     D FilErr          s             10a
     D vMemData        s             57    based(memptr2)
     D fieldnames      s             14    dim(4000)                            FIELD NAMES & DTA
     D fieldattrb      s             43    dim(%elem(fieldnames))
     D dummy           s              5u 0
     D a               s              5u 0
     D ii              s              5u 0 inz(0)
     D nn              s              5u 0 inz(0)
     D b               s              5u 0
     D xx              s              5u 0
     D zeroblank       s              1
     D currenttime     s               n   inz
     D torel           s               n   inz
     D extendedf2      s             45
     D new_opcode      s             10
     D                 ds                  inz
     D vwrk5                   1      5                                         Alpha workfield
     D fact1value              1      5s 0                                      Numeric value of Fc1
     D factor1len      s                   like(mapfldlen)
     D factor1dec      s              2s 0
     D factor1typ      s                   like(mapdtatyp)
     D factor2len      s                   like(mapfldlen)
     D factor2dec      s              2s 0
     D factor2typ      s                   like(mapdtatyp)
     D resultlen       s                   like(mapfldlen)
     D resultdec       s              2s 0
     D resulttyp       s                   like(mapdtatyp)
     D                 ds
     D vworkfactr                          like(srcfactor1)
     D    vworkpos1                   1    overlay(vworkfactr:1)
     D    vworkpos13                  3    overlay(vworkfactr:1)
     D    vworklooku                 14    overlay(vworkfactr:1)
     D vworklen        s                   like(mapfldlen)
     D vworkdec        s              2s 0
     D vworktyp        s                   like(mapdtatyp)
     D vworkind        s              2
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D                 ds
     Dsource                   1     92
     D  srcfactor1            24     37
     D    srcf1p1                     1    overlay(srcfactor1:1)                position 1
     D  srcopcode             38     47
     D      opmove                    4    overlay(srcopcode:1)
     D      opsub                     4    overlay(srcopcode:1)
     D      opwhenrel                 2    overlay(srcopcode:5)
     D      opdox                     3    overlay(srcopcode:1)
     D      opdoxrel                  2    overlay(srcopcode:4)
     D      opif                      2    overlay(srcopcode:1)
     D      opifrel                   2    overlay(srcopcode:3)
     D      opz_                      2    overlay(srcopcode:1)
     D      opsubst                   5    overlay(srcopcode:1)
     D  srcfactor2            48     61
     D  srcresult             62     75
     D      resltlook                14    overlay(srcresult:1)
     D      reslt_in                  3    overlay(srcresult:1)
     D  srclength             80     80
     D  srcrstind             83     88                                         resulting indicators
     D mapflddata      ds                  inz
     D   mapfldlen                    5  0
     D   mapdecpos                    2
     D    mapdecposN                  2s 0 overlay(mapdecpos)
     D   mapdtatyp                    1
     D   mapfldsrc                   10
     D   mapfldtxt                   25
      *----------------------------------------------------------------
      * Create Prototypes for calls
      *----------------------------------------------------------------
     D rpgfldcpyr      PR                  ExtPgm('RPGFLDCPYR')                 process fields
     D                                 *                                        memory allocation
     D  i_extfile                    20A
     D  i_smbr                       10A
     D  i_pcallingcmd                10A   const
     D  i_perror                     10A
     D i_extfile       s             20a
      *    -------------------------------------------------------------
     D main            PR                  extpgm('RPG4MAX2R ')                 Input Parms
     D  i_smbr                       10A
     D  i_sfil                       10A
     D  i_slib                       10A
     D  i_Err_File                   10A
      *    -------------------------------------------------------------
     D main            PI
     D  i_smbr                       10A
     D  i_sfil                       10A
     D  i_slib                       10A
     D  i_Err_File                   10A
      *
      *----------------------------------------------------------------
     Imodifysrc ns  01   18 cC   19nc*   19nc/
     I         or        18 cc   19nc*   19nc/
     I                                  1   92  source
     I                                 24   37  updfactor1
     I                                 48   61  updfactor2
     I                                 62   75  updresult
     I                                 83   84  highind
     I                                 85   86  lowind
     I                                 87   88  equalind
     I          ns  05
      *----------------------------------------------------------------
      * If a calc record spec.
      /free
 1b    if  *in01 and
          srclength = *blanks;
          eval  srcopcode = %xlate(lo:up:srcopcode);

 2b       if srcrstind = *blanks AND
            (srcopcode = 'MOVE      ' or
             srcopcode = 'MOVEL     ' or
             srcopcode = 'MOVEL(P)  ' or
             srcopcode = 'MOVE(P)   ' or
             srcopcode = 'Z-ADD     ' or
             srcopcode = 'Z-SUB     ' or
             srcopcode = 'SUB       ' or
             srcopcode = 'ADD       ' or
             srcopcode = 'MULT      ' or
             srcopcode = 'MULT(H)   ' or
             srcopcode = 'SUBST     ' or
             srcopcode = 'SUBST(P)  ' or
             srcopcode = 'TIME      ');
             exsr  getfldsize;
             exsr  updtoeval;
 2e       endif;

 2b       if  srcopcode = 'SETON     ' or
             srcopcode = 'SETOFF    ';
             exsr  chknuminds;
 2e       endif;
 1e    endif;

       // --------------------------------------------
       // Determine field sizes of factor1, 2, Result Field.
       // --------------------------------------------
       begsr  getfldsize;
       eval  source = %xlate(lo:up:source);
       eval  zeroblank   = *off;
       eval  currenttime = *off;
       eval  torel       = *off;

 1b    if  srcfactor1 <> *blanks;
          clear   factor1len;
          eval  vworkfactr = srcfactor1;
          exsr  fact1fact2;    //Get size of factor 1
          eval  factor1len = vworklen;
          eval  factor1dec = vworkdec;
          eval  factor1typ = vworktyp;
 1e    endif;

 1b    if  srcfactor2 = '*ON ' or srcfactor2 = '*OFF ';
          eval  factor2len = 1;
          eval  factor2dec = 0;
          eval  factor2typ = 'A';
 1x    else;
          eval  vworkfactr = srcfactor2;
          exsr  fact1fact2;    //Get size of factor 2
          eval  factor2len = vworklen;
          eval  factor2dec = vworkdec;
          eval  factor2typ = vworktyp;
 1e    endif;

       // ----------------------------------------------
       // Get attributes of result field
       // ----------------------------------------------
 1b    if  reslt_in = '*IN';
          eval  resultlen = 1;
          clear   resultdec;
          eval  resulttyp  = 'A';
 1x    else;

          eval  nn = %lookup(resltlook:fieldnames:1:ii);
 2b       if  nn=0;
             eval  b=%scan('(':srcresult:1);
 3b          if  b>0;
                eval  resltlook=%subst(srcresult:1:(b-1));
                eval  nn = %lookup(resltlook:fieldnames:1:ii);
 3e          endif;
 2e       endif;

 2b       if  nn>0;
             eval  mapflddata = fieldattrb(nn);
             eval  resultlen = mapfldlen;
 3b          if  mapdecpos = *blanks;
                eval  resultdec=0;
 3x          else;
                eval  resultdec=mapdecposN;
 3e          endif;
             eval  resulttyp  = mapdtatyp;
 2e       endif;
 1e    endif;
       endsr;

       // ----------------------------------------------
       begsr  updtoeval;
 1b    if  factor2typ <> 'B'   and       //weird things
            resulttyp <> 'B';            //with binary
          eval  new_opcode = 'EVAL   ';

          // ----------------------------------------------
          // Convert MOVE BOOLEAN values to eval opcode.
          // Also convert '1' to *on,  '0' to *off
          // ----------------------------------------------
 2b       select;
 2x       when  srcopcode = 'MOVE ' and  srclength= ' ' and
             resulttyp = 'A' and
             resultlen = 1   and
             (srcfactor2 = '*ON  ' or
             srcfactor2 = '*OFF ' or
             srcfactor2 = '''1''' or
             srcfactor2 = '''0''');
 3b          select;
 3x          when  srcfactor2 = '''1''';
                eval  extendedf2 = %trimr(updresult) + ' = *on';
 3x          when  srcfactor2 = '''0''';
                eval  extendedf2 = %trimr(updresult) + ' = *off';
 3x          other;
                eval  extendedf2 = %trimr(updresult) + ' = ' +
                updfactor2;
 3e          endsl;
             except  updatesrc;

             // ----------------------------------------------
 2x       when  zeroblank = *on  and
             (opmove ='MOVE'  or srcopcode = 'Z-ADD');

 3b          select;
 3x          when  resulttyp <> 'A';
                eval  updfactor2 = '*zero    ';

 3x          when  updfactor2 = '*BLANK   ';
                eval  updfactor2 = '*blanks  ';

 3x          when  updfactor2 = '*ZERO    ';
                eval  updfactor2 = '*zero    ';
 3e          endsl;

             exsr  updatecode;

             // ----------------------------------------------
 2x       when  currenttime = *on;
                eval  extendedf2 = %trimr(updresult) +
                                   ' = CurrentTime';
                except  updatesrc;

             // ----------------------------------------------
 2x       when  torel = *on;
                eval  extendedf2 = 'torel = ''*PRV'' ';
                except  updatesrc;

             // ----------------------------------------------
 2x       when  factor2typ = resulttyp and
             resulttyp  = 'A'       and
             factor2len <= resultlen and
             srcopcode = 'MOVEL(P) ' or

             factor2typ = resulttyp and
             factor2dec = resultdec and
             factor2len = resultlen and
             (opmove ='MOVE'  or opz_ = 'Z-') or

             opz_ = 'Z-'  and
             ((factor2len - factor2dec) <=
             (resultlen -resultdec));
             exsr  updatecode;

             // ----------------------------------------------
 2x       when  opsub = 'SUB ';

 3b          select;
 3x          when  srcfactor1 = *blanks and
                ((factor2len - factor2dec) <=
                (resultlen -resultdec));
                eval  extendedf2 = %trimr(updresult) + ' = ' +
                %trimr(updresult) + ' - ' + updfactor2;
                except  updatesrc;

 3x          when  srcfactor1 <> *blanks and
                ((factor1len - factor1dec) <=
                (resultlen -resultdec)) and
                ((factor2len - factor2dec) <=
                (resultlen -resultdec));
                eval  extendedf2 = %trimr(updresult) + ' = ' +
                %trimr(updfactor1) + ' - ' + updfactor2;
                except  updatesrc;
 3e          endsl;

             // ----------------------------------------------
 2x       when  opsub = 'ADD ' and srcfactor1 <> *blanks;

 3b          if  ((factor1len - factor1dec) <
                (resultlen -resultdec)) and
                ((factor2len - factor2dec) <
                (resultlen -resultdec));
                eval  extendedf2 = %trimr(updresult) + ' = ' +
                %trimr(updfactor1) + ' + ' + updfactor2;
                except  updatesrc;
 3e          endif;

 2x       when  opsub = 'MULT' and srcfactor1 <> *blanks;

 3b          if  (((factor1len - factor1dec) +
                (factor2len - factor2dec)) <=
                (resultlen - resultdec));
                eval  extendedf2 = %trimr(updresult) + ' = ' +
                %trimr(updfactor1) + ' * ' + updfactor2;

 4b             if  srcopcode = 'MULT(H)  ';
                   eval  new_opcode = 'EVAL(H)      ';
 4e             endif;

                except  updatesrc;
 3e          endif;

             // ----------------------------------------------
             // Convert substring (padded) opcodes to Eval
             // ----------------------------------------------
 2x       when  opsubst = 'SUBST' and srclength = ' ' and
             srcfactor1 <> *blanks;

 3b          if  srcopcode = 'SUBST(P)';
                eval  new_opcode= 'eval ';

                // per Endrey Tamas.. If factor2 does not
                //  not contain a starting location
                // signified by a :  then make a start pos = 1.
                eval  xx=%scan(':':updfactor2:1);
 4b             if  xx>0;
                   eval  extendedf2 = %trimr(updresult)+ ' = %subst('+
                   %trim(updfactor2) + ':' + %trim(updfactor1) + ')';
 4x             else;
                   eval  extendedf2 = %trimr(updresult)+ ' = %subst('+
                   %trim(updfactor2) + ':1:'+ %trim(updfactor1) + ')';
 4e             endif;
                except  updatesrc;
 3x          else;

 4b             if  srcf1p1  >= '0'  and
                   srcf1p1  <= '9'  and
                   factor1len < 6;

                   eval  vwrk5 = %subst('00000':1:5 - factor1len) +
                   %subst(updfactor1:1:factor1len);

 5b                if  vwrk5=*blanks;
                      eval  fact1value=0;
 5e                endif;
 5b                if  fact1value >= resultlen;
                      eval  extendedf2 = %trimr(updresult)+ ' = %subst('+
                      %trim(updfactor2) + ':' + %trim(updfactor1) + ')';
                      except  updatesrc;
 5e                endif;
 4e             endif;
 3e          endif;
 2e       endsl;
 1e    endif;
       endsr;

       // ----------------------------------------------
       // Build extended factor 2 and update source record.
       // ----------------------------------------------
       begsr  updatecode;
 1b    if  srcopcode <> 'Z-SUB  ';
          eval  extendedf2 = %trimr(updresult)+ ' = ' +
          (updfactor2);
 1x    else;
          eval  extendedf2 = %trimr(updresult) + ' = -(' +
          %trimr(updfactor2) + ')';
 1e    endif;
       except  updatesrc;
       endsr;

       // ----------------------------------------------
       // Determine field sizes of Factor1 and Factor2.
       // ----------------------------------------------
       begsr  fact1fact2;
       clear   vworklen;
       clear   vworktyp;
       clear   vworkdec;

 1b    select;
          // -----
 1b    when  %scan('*PRV' :source) > *zero and
 1b          %scan('TOREL':source) > *zero;
             eval torel = *on;

          // -----
 1x    when  vworkpos1 = '''';   //CONSTANT
 2b       select;
 2x       when  %subst(vworkfactr:14:1) = '''';
             eval  vworklen  = 12;

 2x       when  %subst(vworkfactr:1:2) = '''' and
                %subst(vworkfactr:1:3) = '''' and
                %subst(vworkfactr:1:4) = '''';
             eval  vworklen = 1;
 2x       other;
             eval  b = %checkr(' ':vworkfactr);
             eval  vworklen = (b-2);
 2e       endsl;
          eval  vworktyp = 'A';
          clear   vworkdec;

          // -----
 1b    when  srcopcode  = 'MOVE' and
 1x          vworkfactr = 'TODAY';
             eval  vworklen = 8;
             eval  vworkdec = *zero;
             eval  vworktyp = 'P';

          // -----
 1b    when  srcopcode  = 'TIME';
             eval currenttime = *on;

          // -----
 1x    when  vworkpos1 >= '0'  and    //NUMERIC
          vworkpos1 <= '9'  or
          vworkpos1 = '.';
          eval  a=%scan('.':vworkfactr);
          eval  b=%scan(' ':vworkfactr);
 2b       if  b>0;                     //CALC NUMBER OF DECM
             eval  vworklen = (b)-1;    //ASSUME NO DECIMALS
 2x       else;
             eval  vworklen = 14;
 2e       endif;
          eval  vworkdec  = 0;

          eval  a=%scan('.':vworkfactr);
 2b       if  a>0;                     //CALC NUMBER OF DECM
             eval  vworklen = vworklen - 1;
             eval  vworkdec = (b-a)-1;
 2e       endif;
          eval  vworktyp = 'P';

 1x    when  vworkpos13  = '*BL' or vworkpos13 = '*ZE';
 1x       // vworkpos13  = '*HI' or vworkpos13 = '*LO';
          eval  zeroblank = *on;

 1x    other;         //FIELD NAME
          eval  nn = %lookup(vworklooku:fieldnames:1:ii);
          // ----------------------------------------------
          // if lookup not found, it could be an array or
          // a date field with a : in it.  Try both
          // ----------------------------------------------
 2b       if    nn=0;
             eval  b=%scan('(':vworkfactr:1);     //  try array
 3b          if  b = 0;
                eval  b=%scan(':':vworkfactr:1);   // try date
 3e          endif;

 3b          if  b>0;
                eval  vworklooku = %subst(vworkfactr:1:(b-1));
                eval  nn= %lookup(vworklooku:fieldnames:1:ii);
 3e          endif;
 2e       endif;
          // ----------------------------------------------

 2b       if  nn>0;
             eval  mapflddata = fieldattrb(nn);
             eval  vworklen = mapfldlen;
 3b          if  mapdecpos = *blanks;
                eval  vworkdec =0;
 3x          else;
                eval  vworkdec=mapdecposN;
 3e          endif;
             eval  vworktyp = mapdtatyp;
 2e       endif;
 1e    endsl;
       endsr;

       // ----------------------------------------------
       // Convert the SETON and SETOF opcodes to move *ON or move *OFF
       // for single indicator operations only.
       // ----------------------------------------------
       begsr  chknuminds;
       clear   vworkind;

 1b    select;
 1x    when  highind <> *blanks  and
          lowind = *blanks  and
          equalind = *blanks;
          eval  vworkind = highind;

 1x    when  highind  = *blanks  and
             lowind  <> *blanks  and
             equalind = *blanks;
             eval  vworkind = lowind;

 1x    when  highind   = *blanks  and
             lowind    = *blanks  and
             equalind <> *blanks;
             eval  vworkind = equalind;
 1e    endsl;

       // ----------------------------------------------
       // Match proper constant to type opcode.
       // ----------------------------------------------
 1b    if  vworkind <> *blanks;
          eval  new_opcode = 'EVAL   ';

 2b       if  srcopcode = 'SETON  ';
             eval  extendedf2 = '*in' + vworkind + ' = *on ';
 2x       else;
             eval  extendedf2 = '*in' + vworkind + ' = *off';
 2e       endif;
          except  updatesrc;
 1e    endif;
       endsr;

       // ----------------------------------------------
       // Unload data queue containing field names and sizes.
       // ----------------------------------------------
       begsr  *inzsr;
       // Allocate memory for field attribute loader to use
       // and initialize the entry counter and size fields
       eval  memptr1=%alloc(228004);
       eval  memNumEntries=0;
       eval  memEntryLen=57;
       eval  memPassPtr=memPtr1;

       // process copy books and selected source
       // load field names and attributes to memory
       eval   i_extfile=%trimr(i_slib)+'/'+i_sfil;

       callp  rpgfldcpyr(memPassPtr:
              i_extfile:
              i_smbr:
              'RPG4MAX   ':
              FilErr);

       // if file-not-found error, send message
 1b    if  FilErr <> *blanks;
          dealloc  memptr1;
          eval  i_Err_File=FilErr;
          eval  *inlr=*on;
          return;
 1e    endif;

 1b    for  dummy = 1 to memNumEntries;
          eval  memptr2 = memPtr1 + (ii * memEntryLen)+5;
          eval  ii=ii+1;
          eval  FieldNames(ii)=%subst(vMemData:1:14);
          eval  FieldAttrb(ii)=%subst(vMemdata:15);
 1e    endfor;
       dealloc  memptr1;
       endsr;
      /end-free
     Omodifysrc e            updatesrc
     O                                           37 '              '
     O                       new_opcode          47
     O                       extendedf2          92
