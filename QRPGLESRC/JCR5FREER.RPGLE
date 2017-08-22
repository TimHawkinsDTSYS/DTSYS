     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('06/01/2001 Craig Rutledge < www.jcrcmds.com > ')
      //---------------------------------------------------------------
      // JCR5Freer - v4 format to v5 /free format conversion
      // This program is free software, you can redistribute it and/or modify it under the terms
      // of the GNU General Public License as published by the Free Software Foundation.
      //---------------------------------------------------------------
      // WARNING::  There is NO such thing as a 100% conversion program from
      // V4 columnar to V5 free!!   Way too many total incompatibilities
      // between the two.
      //
      // This program will take v4 source that has been PURPOSELY written
      // to convert into v5, then convert it into that format.
      //
      // I would strongly recommend getting the RPG5PRT utility
      // and print out a listing/fix everything
      // that CAN NOT be converted, before using this utiity.
      //
      // I recommend getting the JCRNUMB utility from
      // my website to format the v5 /free properly.
      // In fact,  it is required to sync the FOR upcodes
      // up with ENDFOR statements.
      //------------
      // Areas that will need manual modification after convert:
      // lookup opcodes.   These will need to be scrutinized
      // and tested.  %found and %equal bif not set by lookup operation
      // It is good bet you will have to rewrite some code here.
      //
      // for every dummyxx FOR counter that is created, you will have to define
      // it.  It is suggested you use like the field name to define counters.
      //
      // Be aware, Multiple line IF, WHEN, etc  statements that
      // do not end with AND or OR, will be incorrectly flagged as a
      // stand alone statements. No big deal to edit code after conversion
      // and remove unneeded ;.
      // example
      //       C    if      a=b
      //       C             or c=d
      // will convert to
      //            if a=b;
      //                 or c=d;
      // which is incorrect.
      //
      //---------------------------------------------------------------
      // END opcodes will not match the newly generated FOR,
      // with out the JCRNUMB utility.
      //---------------------------------------------------------------
      // program summary:
      // Write /free source code
      //---------------------------------------------------------------
     Fv4src     if   f  112        disk
     Fv5src     o    f  112        disk
      //---------------------------------------------------------------
     D aa              s                   inz(0)  like(LvlCnt)
     D bb              s                   inz(0)  like(LvlCnt)
     D yy              s                   inz(0)  like(LvlCnt)
     D xx              s                   inz(0)  like(LvlCnt)
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D wrk             s                   like(src)
     D UpperWRK        s                   like(src)
     D linea           s            112
     D IsCalcSpec      s               n   inz(*off)
     D IsCallp         s               n   inz(*off)
     D IsOutputSpec    s               n   inz(*off)
     D IsComment       s               n   inz(*off)
     D IsCasxx         s               n   inz(*off)
     D IsArray         s               n   inz(*off)
     D WhenIndent      s               n   inz(*off)
     D UpOneLvl        s               n   inz(*off)
     D DownOneLvl      s               n   inz(*off)
     D IsFirstTime     s               n   inz(*off)
     D IsLastTime      s               n   inz(*on)
     D LvlCnt          s              5u 0 inz(0)
     D LIndex          s             14a
     D LF2             s             14a
     D srccspec        s            100a
     Dopupsave         s             10
     D F2upper         s                   like(f2)
     D RFupper         s                   like(rf)
     D OPup            ds            10
     D   doifwh                1      2
     D   endopcode             1      3

      //   -------------------------------------------------------------
     D main            PR                  extpgm('JCR5FREER')                  Input Parms
     D                               10A   const
     D                               20A
      //   -------------------------------------------------------------
     D main            PI
     D  i_smbr                       10A   const
     D  i_sfil_slib                  20A
      //   -------------------------------------------------------------
      //
     D  i_sfil         s             10A
     D  i_slib         s             10A
     D  srcseq         s              6s 2 inz
     D  srcout         s                   inz  like(src)
      //----------------------------------------------------------------
     Iv4src     ns
      //                                1    6 0seqno
     I                                  7   12  modmark
     I                                 13  112  Src
     I                                 18   18  line_type
     I                                 19   27  free_endfree
     I                                 19   19  comment
     I                                 19   20  LevlInd
     I                                 22   23  CondInd
     I                                 38   47  OP
     i                                 24   37  F1
     i                                 48   61  F2
     i                                 48   92  ExtF2
     i                                 62   75  RF
     i                                 83   84  HIind
     i                                 85   86  LOind
     i                                 87   88  EQind
     i                                 83   88  ResultingInd
     i                                 93  112  srccomment
      //----------------------------------------------------------------
      /free
       read  v4src;
 1b    dow  not %eof;
          // ---------

 2b       if  free_endfree = '/free';
              read  v4src;                     // don't write /free

              dou  free_endfree = '/end-free';
                   srcout = src;
                   except writenonC;

                   read  v4src;
 2e           enddo;
 2e       endif;

 2b       if  %subst(src:1:2)='**';  //compile time array
              IsArray=*on;
 2e       endif;

 2b       if  (line_type = 'C') or
              (line_type = 'c');

             IsCalcSpec=*on;

 3b          if not IsFirstTime;
                srcCspec= '      /free';
                srcseq=srcseq+.01;
                IsFirstTime=*on;
                except  CSPEC;
 3e          endif;
 2e       endif;

 2b       if (line_type = 'D') or
             (line_type = 'd') or
             (line_type = 'F') or
             (line_type = 'f');
             IsCalcSpec=*off;
 2e       endif;

 2b       if (line_type = 'P') or
             (line_type = 'p');
             IsLastTime=*off;
             IsFirstTime=*off;
             IsCalcSpec=*off;
             srcCspec= '      /end-free';
             srcseq=srcseq+.01;
             except  CSPEC;
             IsFirstTime=*off;
             clear srcCspec;
 2e       endif;

          // end-free after 1st o spec only

 2b       if  (line_type ='O') or
             (line_type = 'o');
             IsLastTime=*off;
             IsFirstTime=*off;
             IsCalcSpec=*off;
 3b          if not IsOutputSpec;
                srcCspec= '      /end-free';
                srcseq=srcseq+.01;
                except  CSPEC;
                IsOutputSpec=*on;
 3e          endif;

             IsFirstTime=*off;
             clear srcCspec;
 2e       endif;

          // ---------

 2b       if  IsArray          or
 2b           not IsCalcSpec   or
              LevlInd  = '/C'  or    // COPY
              LevlInd  = '/c';
              srcseq=srcseq+.01;
              srcout=src;
              except  writenonC;

 2x       else;
             DownOneLvl= *off;
             UpOneLvl  = *off;

 3b          if  not  (comment = '+' or     //no sql
                       comment = '/');      //no copy statements

 4b             if  op > *blanks;
                    IsCallp=*off;
 4e             endif;

                OPup = %xlate(lo:up:OP);

                if  comment = '*';

 4x             elseif
                   endopcode = 'CAS';
                   IsCasxx=*on;

 4x             elseif
                   OPup = 'SELECT ';
                   reset WhenIndent;

 4x             elseif
                   doifwh = 'DO'   or
                   doifwh = 'IF'   or
                   OPup = 'FOR    ' or
                   OPup = 'MONITOR ' or
                   %subst(OPup:1:4) = 'FOR(';
                   DownOneLvl=*on;

                   // -------------------------------------------
                   // Set Flag if END is found
                   // -------------------------------------------
 4x             elseif
                   EndOpcode = 'END';
 5b                if not IsCasxx;
                      UpOneLvl=*on;
 5e                endif;
                   IsCasxx=*off;
 4e             endif;
 3e          endif;

             // -------------------------------------------
             // Convert EVERYTHING to free format..
             // -------------------------------------------
             clear   wrk;
             clear   linea;
             IsComment=*off;

             if comment = '*';
 4b             if  %subst(src:8)=*blanks;
                   wrk=*blanks;
 4x             else;
                   wrk='// ' + %triml(%subst(src:8));
                   IsComment=*on;
 4e             endif;

 3x          elseif
                LevlInd  = '/E' or     // EJECT
                LevlInd  = '/e' or
                LevlInd  = '/S' or     // SPACE
                LevlInd  = '/s';
                wrk=*blanks;

                // there is no /free equalivant for these opcodes.  List as is.
                // -------------------------------------------
                // All DO statements must be converted to FOR opcodes
                // There are 5 variations of on DO
                // DO               =  DOU '1'
                // DO  xx           =  FOR dummy = 1 to xx
                // DO  xx   yy      =  FOR yy = 1 to xx
                // aa   DO  xx           =  FOR dummy = aa to xx
                // aa   DO  xx   yy      =  FOR yy = aa to xx
                // -------------------------------------------
 3x          elseif
                OPup = 'DO ';

 4b             if
                   F1>*blanks  and                                                     //aa DO xx yy
                   F2>*blanks  and
                   RF >*blanks;
                   Wrk='for ' + %trimr(RF) + ' = ' +
                   %trimr(F1) + ' to ' + F2;

 4x             elseif
                   F1>*blanks  and                                                        //aa DO xx
                   F2>*blanks  and
                   RF =*blanks;
                   Wrk='for dummy' + %char(lvlcnt) + ' = ' +
                   %trimr(F1) + ' to ' + F2;

 4x             elseif
                   F1=*blanks  and                                                       //DO xx  yy
                   F2>*blanks  and
                   RF >*blanks;
                   Wrk='for ' + %trimr(RF) + ' = 1 to ' + F2;

 4x             elseif
                   F1=*blanks  and                                                           //DO xx
                   F2>*blanks  and
                   RF =*blanks;
                   Wrk='for dummy' +%char(lvlcnt) + ' = 1 to ' + F2;

 4x             elseif
                   F1=*blanks  and                                                              //DO
                   F2=*blanks  and
                   RF =*blanks;
                   Wrk='dou ''''1''''';
 4e             endif;

                // -------------------------------------------
                // Go play in the date street and BIF alley.
                // -------------------------------------------
 3x          elseif
                %subst(OPup:1:6) ='ADDDUR' or
                %subst(OPup:1:6) ='SUBDUR';
                exsr  srADDDUR;

 3x          elseif
                %subst(OPup:1:6) ='EXTRCT';
                Wrk= %trimr(RF) +
                ' = %subdt(' + %trimr(F2) + ')';

                // -------------------------------------------
                // More BIFFS.
                // -------------------------------------------
 3x          elseif
                %subst(OPup:1:5) ='CHECK';
                Wrk= %trimr(RF) +
                ' = %' + %trimr(OP) + '(' +
                %trimr(F1) +':'+%trimr(F2) +')';

 3x          elseif
                %subst(OPup:1:5) ='XLATE';
                Wrk= %trimr(RF) +
                ' = %' + %trimr(OP) + '(' +
                %trimr(F1) +':'+%trimr(F2) +')';

 3x          elseif
                %subst(OPup:1:6) ='LOOKUP';
                exsr  srLOOKUP;

 3x          elseif
                %subst(OPup:1:5) ='XFOOT';
                exsr  srXFOOT;

 3x          elseif
                %subst(OPup:1:5) ='OCCUR';
                exsr  srOCCUR;

                // -------------------------------------------
                // FACTOR1  OP  FACTOR2  RESULT conversions.
                // FACTOR1  OP  FACTOR2
                // FACTOR1  OP
                // end result is opcode factor1  factor2  Result
                // -------------------------------------------
 3x          elseif
                %subst(OPup:1:3) = 'ACQ'     or
                OPup=              'BEGSR '  or
                OPup=              'MONITOR ' or
                OPup=              'ON-ERROR ' or
                %subst(OPup:1:5) = 'CHAIN'   or
                %subst(OPup:1:6) = 'COMMIT'  or
                %subst(OPup:1:6) = 'DELETE'  or
                %subst(OPup:1:5) = 'DSPLY'   or
                %subst(OPup:1:4) = 'DUMP'    or
                %subst(OPup:1:4) = 'POST'    or
                %subst(OPup:1:3) = 'END'
                OR
                (%subst(OPup:1:3) = 'IN '   or
                %subst(OPup:1:3) = 'IN(')
                OR
                %subst(OPup:1:4) = 'NEXT' or
                %subst(OPup:1:3) = 'OUT'  or
                %subst(OPup:1:4) = 'POST' or
                %subst(OPup:1:5) = 'READE' or
                %subst(OPup:1:6) = 'READPE' or
                %subst(OPup:1:3) = 'REL'  or
                %subst(OPup:1:5) = 'RESET' or
                OPup='CLEAR '  or
                %subst(OPup:1:5) = 'ROLBK' or
                %subst(OPup:1:5) = 'SETGT' or
                %subst(OPup:1:5) = 'SETLL'
                OR
                (%subst(OPup:1:5) = 'TEST ' or
                %subst(OPup:1:5) = 'TEST(')
                OR
                %subst(OPup:1:6) = 'UNLOCK';
 4b             if  F1=*blanks;
                   Wrk=%trimr(OP) + '  ' +  %trimr(F2) +' ' + RF;
 4x             else;
                   Wrk=%trimr(OP) + '  ' +
                   %trimr(F1) + ' ' + %trimr(F2) +' ' + RF;
 4e             endif;
                // resulting ind errors
 4b             if  ResultingInd>*blanks;
                   Wrk=%trimr(Wrk)+'    ??'+%trim(ResultingInd)+
                   '????????????????';
                   opupsave=opup;
                   opup = 'ResultInd';
                   opup=opupsave;
 4e             endif;

                // -------------------------------------------
                // opcode FACTOR2  RESULT conversions.
                // opcode FACTOR2
                // end result is Opcode Factor2  Result
                // -------------------------------------------
 3x          elseif
                OPup=              'EXCEPT ' or
                OPup=              'EXFMT '  or
                OPup=              'EXSR '   or
                OPup=              'ELSE  '  or
                OPup=              'FORCE '  or
                OPup=              'ITER  '  or
                OPup=              'LEAVE '  or
                OPup=              'LEAVESR' or
                OPup=              'OTHER '  or
                %subst(OPup:1:5)=  'CLOSE'  or
                %subst(OPup:1:4)=  'OPEN'
                OR
                (%subst(OPup:1:5) = 'READ ' or
                %subst(OPup:1:5) = 'READ(')
                OR
                %subst(OPup:1:5) = 'READC' or
                %subst(OPup:1:5) = 'READP' or
                OPup=              'SELECT ' or
                OPup=              'SORTA  ' or
                %subst(OPup:1:6) = 'UPDATE'
                OR
                %subst(OPup:1:5) = 'WRITE'   or
                %subst(OPup:1:4) = 'FEOD';
                Wrk=%trimr(OP) + '  ' +
                %trimr(F2) +' ' + RF;

 4b             if  ResultingInd>*blanks;
                   Wrk=%trimr(Wrk)+'    ??'+%trim(ResultingInd)+
                   '????????????????';
                   opupsave = opup;
                   opup     = 'ResultInd';
                   opup     = opupsave;
 4e             endif;

                // -------------------------------------------
                //  Opcode RESULT field simple compressions
                // -------------------------------------------

 3x          elseif
                %subst(OPup:1:7)='DEALLOC';
                Wrk=%trimr(OP) + '  ' + RF;

                // -------------------------------------------
                // opcode Extended Factor2 compressions
                // Will need to revisit this for + signs to line up code.
                // -------------------------------------------
 3x          elseif
                (%subst(OPup:1:4)='DOU ' or
                %subst(OPup:1:4)='DOU(' or
                %subst(OPup:1:4)='DOW ' or
                %subst(OPup:1:4)='DOW('   or
                %subst(OPup:1:5)='CALLP') or
                %subst(OPup:1:4) ='EVAL'  or
                (%subst(OPup:1:4) ='FOR ' or
                %subst(OPup:1:4) ='FOR(')
                OR
                (%subst(OPup:1:3) ='IF ' or
                %subst(OPup:1:3) ='IF(')
                OR
                %subst(OPup:1:6) ='RETURN'
                OR
                (%subst(OPup:1:5) ='WHEN ' or
                %subst(OPup:1:5) ='WHEN(');

                if  %subst(OPup:1:4) ='EVAL'   or
                    %subst(OPup:1:5) ='CALLP';
                    Wrk = ExtF2;
                else;
                    Wrk = %trimr(OP) + '  ' + ExtF2;
                endif;

                // get position for callp parms to line up with factor2

                bb=%scan(ExtF2:Wrk);

 4b             if   %subst(OPup:1:5)='CALLP';
                   IsCallp=*on;
 4e             endif;

                // -------------------------------------------
 3x          else;
 4b             if    OPup=*blanks;
 5b                if  not IsCallp;
                      Wrk=ExtF2;
 5x                else;
                      clear   Wrk;
                      %subst(Wrk:bb)=%trimr(ExtF2);
 5e                endif;
 4x             else;

                   Wrk=%trimr(OP) + ' ?????????????????????????';
                   // -------------------------------------------
 4e             endif;

                // -------------------------------------------
 3e          endif;
             // Build load indent characters and source line for printing.
             // -------------------------------------------
             exsr  srOutput;
 2e       endif;

          read  v4src;
 1e    enddo;

 1b    if IsLastTime;
          srcCspec= '      /end-free';
          srcseq=srcseq+.01;
          except  CSPEC;
 1e    endif;

       *inlr=*on;
       return;

       // -------------------------------------------
       // ADDDUR and SUBDUR processing.  Convert to BIFs.
       // -------------------------------------------
       begsr  srADDDUR;
       f2upper = %xlate(lo:up:f2);
       rfupper = %xlate(lo:up:RF);

       //wrk='eval';
       wrk=*blanks;

 1b    if  OPup='ADDDUR(E)' or
          OPup='SUBDUR(E)';
          wrk='eval(e)';
 1e    endif;
       xx=%scan(':':F2);
 1b    if  xx>0;

          Wrk= %trimr(wrk) + ' ' + %trimr(RF) + ' =';

 2b       if  F1=*blank;
             Wrk= %trimr(wrk) + ' ' + RF;
 2x       else;
             Wrk= %trimr(wrk) + ' ' + F1;
 2e       endif;

 2b       if  %subst(OPup:1:6) ='ADDDUR';
             Wrk= %trimr(wrk) + ' + ';
 2x       else;
             Wrk= %trimr(wrk) + ' - ';
 2e       endif;
          xx=%scan(':':F2);

 2b       if    %subst(F2upper:xx+1)='*MSECONDS' or
             %subst(F2upper:xx+1)='*MS';
             Wrk= %trimr(wrk) + ' %mseconds(';

 2x       elseif
             %subst(F2upper:xx+1)='*SECONDS' or
             %subst(F2upper:xx+1)='*S';
             Wrk= %trimr(wrk) + ' %seconds(';

 2x       elseif
             %subst(F2upper:xx+1)='*MINUTES' or
             %subst(F2upper:xx+1)='*MN';
             Wrk= %trimr(wrk) + ' %minutes(';

 2x       elseif
             %subst(F2upper:xx+1)='*HOURS' or
             %subst(F2upper:xx+1)='*H';
             Wrk= %trimr(wrk) + ' %hours(';

 2x       elseif
             %subst(F2upper:xx+1)='*DAYS' or
             %subst(F2upper:xx+1)='*D';
             Wrk= %trimr(wrk) + ' %days(';

 2x       elseif
             %subst(F2upper:xx+1)='*MONTHS' or
             %subst(F2upper:xx+1)='*M';
             Wrk= %trimr(wrk) + ' %months(';

 2x       elseif
             %subst(F2upper:xx+1)='*YEARS' or
             %subst(F2upper:xx+1)='*Y';
             Wrk= %trimr(wrk) + ' %year(';
 2e       endif;

          Wrk= %trimr(wrk) + %subst(F2:1:xx-1) + ')';
 1x    else;
          // -------------------------------------------
          // Process DIFF statements
          // -------------------------------------------
          // first extract the field from the RF
          // -------------------------------------------
          xx=%scan(':':RF);
          Wrk= %trimr(wrk)+' ' + %subst(RF:1:xx-1) +
          ' = %diff(' + %trimr(F1)+':'+
          %trimr(f2) + ':' +
          %trimr(%subst(rf:xx+1))+')';
 1e    endif;
       endsr;

       // -------------------------------------------
       // LOOKUP and TLOOKUP processing. Convert to BIFs
       // -------------------------------------------
       begsr  srLOOKUP;
       clear   lindex;
       lf2=f2;
       f2upper = %xlate(lo:up:f2);

       // wrk='eval';
       wrk=*blanks;

 1b    if  %subst(F2upper:1:3)='TAB';
          wrk='*in'+
          %trim(ResultingInd) + ' = %tlookup';

 1x    else;
          xx=%scan('(':F2);
 2b       if  xx=0;
 3b          if  (ResultingInd)>*blanks;
                wrk='*in'+
                %trim(ResultingInd) + ' = %lookup';
 3x          else;
                wrk='?????? = %lookup';
 3e          endif;

 2x       else;
             yy=%scan(')':F2:xx);
             lf2= %subst(f2:1:xx-1);
             lindex= %subst(f2:xx+1:yy-(xx+1));
             wrk=%trimr(lindex) + ' = %lookup';
 2e       endif;
 1e    endif;

       // -------------------------------------------
       // Now look at indicators assigned and tack on type lookup.
       // -------------------------------------------
 1b    if
          EQind <> *blanks   and
          HIind = *blanks and
          LOind = *blanks;
          //           wrk=%trimr(wrk)+'EQ('

 1x    elseif
          EQind = *blanks   and
          HIind <> *blanks and
          LOind = *blanks;
          wrk=%trimr(wrk)+'GT(';

 1x    elseif
          EQind = *blanks   and
          HIind = *blanks and
          LOind <> *blanks;
          wrk=%trimr(wrk)+'LT(';

 1x    elseif
          EQind <> *blanks   and
          HIind <> *blanks and
          LOind = *blanks;
          wrk=%trimr(wrk)+'GE(';

 1x    elseif
          EQind <> *blanks   and
          HIind = *blanks and
          LOind <> *blanks;
          wrk=%trimr(wrk)+'LE(';
 1x    else;
          wrk=%trimr(wrk)+'??(';
 1e    endif;

       wrk=%trimr(wrk)+%trimr(f1)+':'+
       %trimr(lf2);

 1b    if  %subst(F2upper:1:3)<>'TAB';
 2b       if  Lindex=*blanks;
             wrk=%trimr(wrk)+')';
 2x       else;
             wrk=%trimr(wrk)+':'+%trimr(lindex)+')';
 2e       endif;
 1x    else;
 2b       if  RF=*blanks;
             wrk=%trimr(wrk)+')';
 2x       else;
             wrk=%trimr(wrk)+':'+%trimr(RF)+')';
 2e       endif;
 1e    endif;
       endsr;

       // -------------------------------------------
       // XFOOT biff
       // -------------------------------------------
       begsr  srXFOOT;

       //wrk='eval';
       wrk=*blanks;

       xx=%scan('(':OP);

 1b    if  xx>0;
          wrk=%trimr(wrk)+ %subst(OP:xx);
 1e    endif;

       wrk=%trimr(wrk) +' '+ %trimr(RF) +
       ' = %xfoot(' + %trimr(F2) + ')';
       endsr;

       // -------------------------------------------
       // OCCUR biff.
       // -------------------------------------------
       begsr  srOCCUR;

       //wrk='eval';
       wrk=*blanks;

       xx=%scan('(':OP);
 1b    if  xx>0;
          wrk=%trimr(wrk)+ %subst(OP:xx);
 1e    endif;

 1b    if  F1>*blanks;
          wrk=%trimr(wrk) +' %occur(' +
          %trimr(F2) + ') = '+ F1;

 1x    else;
          wrk=%trimr(wrk) +' '+ %trimr(RF) +
          ' = %occur(' + %trimr(F2) + ')';
 1e    endif;

       endsr;

       // -------------------------------------------
       // OUTPUT MODIFIED LINE
       // -------------------------------------------
       begsr  srOutput;

 1b    if  UpOneLvl       and
           LvlCnt >= 1;
           LvlCnt -= 1;
 1e    endif;

       // -------------------------------------------
       // come back up level for when and others
       // -------------------------------------------

 1b    if  (opup='WHEN '   or
            opup='OTHER')  and
 1b         UpOneLvl       and
            WhenIndent=*on;

            LvlCnt -= 1;
 1e    endif;

       // -------------------------------------------
       // shift to right for level count

       clear   linea;
       xx = 1;

 1b    for  yy = 1 to LvlCnt;
            %subst(linea: xx: 3) = '  ';
            xx += 4;
 1e    endfor;

       // -------------------------------------------
       // deal with indenting the code under a WHEN, OTHER statement.
       // -------------------------------------------

 1b    if  opup='WHEN '   or
           opup='OTHER'   or
           opup='ELSE';
       //  LvlCnt += 1;

           WhenIndent=*on;
 1e    endif;

       // deal with lines ending in AND / OR / +

       %subst(linea: xx) = Wrk;

       UpperWrk = %xlate(lo:up:wrk);

       aa = %checkr(' ':UpperWrk);

 1b    if  linea <> *blanks  and
          (aa > 3 and
          IsComment=*off and
          not (%subst(UpperWrk: aa:   1) = '+'     or
               %subst(UpperWrk: aa:   1) = ':'     or
               %subst(UpperWrk: aa:   1) = '='     or
               %subst(UpperWrk: aa:   1) = '>'     or
               %subst(UpperWrk: aa:   1) = '<'     or
               %subst(UpperWrk: aa:   1) = '('     or
               %subst(UpperWrk: aa-3: 4) = ' AND'  or
               %subst(UpperWrk: aa-2: 3) = ' OR'));
               linea = %trimr(linea) +';';
 1e    endif;

       // -------------------------------------------
       // Tack on comment field
       // -------------------------------------------

 1b    if  srcComment > *blanks  and
           not IsComment;

  2b       if  %subst(linea: 71:  8) = '       ';
               %subst(linea: 71:  2) = '//';
               %subst(linea: 73: 20) = srcComment;
  2x       else;
              linea = %trimr(linea) +'  // ' + srcComment;
  2e       endif;
 1e    endif;

 1b    if  DownOneLvl;
           LvlCnt += 1;
 1e    endif;

 1b    if  LevlInd >  *blanks and
 1b        LevlInd <> 'sr'    and
 1b        LevlInd <> 'SR'    and not
          (%subst(LevlInd:1:1) = '/' or
           %subst(LevlInd:1:1) = '*');
          linea = '??'+LevlInd+'???????   ' + linea;

          opupsave=opup;
          opup = 'LevelInd';
          opup=opupsave;
 1e    endif;

 1b    if  CondInd > *blanks and not
          (%subst(LevlInd:1:1) = '/' or
           %subst(LevlInd:1:1) = '*');
          linea = '??'+CondInd+'???????   ' + linea;

          opupsave=opup;
          opup = 'ConditInd';
          opup=opupsave;
 1e    endif;

       srcseq=srcseq+.01;

 1b    if  opup = 'KLIST '  or
           opup = 'KFLD ';
           evalR srcCspec = src;
 1x    else;

           srcCspec= '       ' + linea;
 1e    endif;

       except  CSPEC;

       endsr;
      /end-free
     Ov5src     e            writenonC
     O                       srcseq               6
     O                       srcdte              12
     O                       srcout             112
     O                       modmark             16
     Ov5src     e            CSPEC
     O                       srcseq               6
     O                       srcdte              12
     O                       srccspec           112
     O                       modmark             16
