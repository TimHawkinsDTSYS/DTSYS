     H DFTACTGRP(*NO) ACTGRP(*CALLER)  EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('03/06/1996 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * rpgfldgetr - load alloc memory with fld attrs from rpg4 program source
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      *----------------------------------------------------------------
      * program summary:
      * read rpg/iv source code
      * accept file names and External DS files from RPGRECGETR.
      * load arrays with all defined field lengths
      * sort arrays and load to allocated memory
      * matching record and lookahead is used to retrieve all
      * like and overlay keywords before loading a field
      *----------------------------------------------------------------
      * api (application program interfaces) used:
      * quscrtus  create user space
      * qusptrus  retrieve pointer to user space
      * quslfld   list fields within a file
      *----------------------------------------------------------------
     Flookaheadrip   f  112        disk    extfile(i_extfile) extmbr(i_extmbr)
     Fqrpgsc    is   f  112        disk    extfile(i_extfile) extmbr(i_extmbr)
      *----------------------------------------------------------------
     D memFields       ds                  based(i_pMemPtr)
     D  memNumEntries                 5u 0
     D  memEntryLen                   5u 0
     D alpha57         s             57     based(memptr2)
     D                 ds
     D arrsort                       57    dim(4000)                            SORTED NAMES& DTA
     D arrfldnam                     14    overlay(arrsort:1)                   FIELD NAMES
     D arrflddta                     43    overlay(arrsort:15)                  FIELD ATTRIBUTES
      *
     D arrdsstruc      s                   dim(4000) like(dtastrucds)           DS names
     D arrlikfld       s                   dim(4000) like(likefldds)             LIKE DEFINED DATA
     D fileflds        s             24    dim(22767)                            Fields from files
     D filefldstg      s             43    dim(%elem(fileflds))                  Data for file flds
     D filelib         s             20
     D                 ds                  inz
     D vwrk5                   1      5
     D vwrk5NUM                1      5s 0
     D a               s             10i 0
     D b               s              5u 0
     D c               s              5u 0
     D                 ds                  inz
     D conlength               1      5s 0                                      constant length
     D conLengthA              1      5
     D vc1             s              5u 0
     D vc2             s                   like(vc1)
     D vcstart         s                   like(vc1)
     D vcend           s                   like(vc1)
     D vcdec           s                   like(vc1)
     D insideds        s               n   inz(*off)
     D alldefflag      s               n   inz(*off)                            All DS flds defined?
     D firstcalc       s               n   inz(*on)
     D dimflag         s               n   inz(*off)
     D bifflag         s               n   inz(*off)                            Built In Function
     D likflag         s               n   inz(*off)
     D ovrlayflag      s               n   inz(*off)
     D PRflg           s               n   inz(*off)                            Prototype flag
     D PIflg           s               n   inz(*off)                            Procedure Interface
     D dimvalue        s                   like(a)
     D dimdescrip      s                   like(defkeyword)
     D BifType         s              5
     D workdim         s                   like(defkeyword)
     D workdimfld      s                   like(field)
     D likvalue        s                   like(field)
     D likdescrip      s                   like(defkeyword)
     D compressout     s                   like(defkeyword)
     D field           s             14                                         LOAD FOR LOOKUP
     D fpos            s                   like(a)
     D formatname      s             10
     D formatkey       s             24
     D fmtrename       s             10
     D fldprefix       s             10
     D h_datefmt       s              4    inz('*ISO')
     D defdatefmt      s                   like(h_datefmt)
     D ii              s              5u 0 inz(0)
     D ff              s              5u 0 inz(0)
     D nn              s              5u 0 inz(0)
     D dummy           s              5u 0 inz(0)
     D l               s                   like(a)
     D len             s                   like(a)
     D lencount        s              5u 0 inz                                  external DS length
     D tpos            s                   like(a)
     D x               s                   like(a)
     D vy              s              5u 0
     D wrkfactor2      s                   like(srcfactor2)
     D wrkresult       s                   like(srcresult)
     D wrklength       s                   like(srclength)
     D ffmt            s                   like(inffmt)
     D s               s                   like(a)                              DS counter
     D prvdsname       s             14
     D highto          s                   like(a)                              DS counter
      *
     D                 ds
     D from                    1      5
     D fromNUM                 1      5s 0 inz
     D                 ds
     D to                      1      5
     D toNUM                   1      5s 0 inz
     D                 ds
     D vcdecposA               1      2
     D vcdecpos                1      2s 0 inz
      *
     D dpos            s                   like(indpos)
     D fldn            s                   like(infldn)
     D quote           s              1    inz('''')
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
      *----------------------------------------------------------------
      *  Data structure out fields from FilesParm.
      *----------------------------------------------------------------
     D arryelemds      ds
     D   afilename             1     10
     D   aformatname          11     20
     D   arenamedfmt          21     30
     D   abasedonpf           31     40
     D   ausage               41     41
     D   adesc                42     70
     D   afileords            71     71
     D   aprefix              72     81
     D   aprefix_chr          82     82s 0
     D   adsname              83     97
      *
      *----------------------------------------------------------------
      * define all pertinent fields from the different spec types.
      *----------------------------------------------------------------
     D  srcdta         ds                  inz
     D  xspec                 18     18
     D  filenm                19     28
      * define specs
     D    deffldn             19     33
     D    defdsext            34     34
     D    defds               36     37
     D    defstdalon          36     36                                         stand alone field
     D    defPI_PR            35     38                                         check PR or PI
     D    defdtatype          52     52                                         field Format
     D    deffrom             40     44
     D    deffromNUM          40     44s 0
     D    defstatus           38     45
     D    defto               47     51
     D    deftoN              47     51s 0
     D    defdpos             53     54
     D**  defkeyword          56     92
     D    defkeyword          56    112
      * input specs
     D    inffmt              48     48
     D    infrom              49     53
     D    into                54     58
     D    indpos              59     60
     D    extfld              33     42
     D    infldn              61     74
      * calc specs
     D    srcfactor1          24     37
     D    srcopcode           38     47
     D    srcfactor2          48     61
     D    srcresult           62     75
     D    srclength           76     80
     D    srclengthN          76     80s 0
     D    srcdecimal          81     82
      *
      *----------------------------------------------------------------
      * Get user space list info from header section.
      *----------------------------------------------------------------
     D                 ds                  based(uHeadPtr)
     D uOffSetToList         125    128i 0                                      offset to list
     D uNumOfEntrys          133    136i 0                                      number list entries
     D uSizeOfEntry          137    140i 0                                      list entry size
     D uListPtr        s               *   inz(*null)                           next entry offset
      *
      *----------------------------------------------------------------
      * extract field definitions from the api.
      * vfdnam - field name
      * vfdtyp - field type  a,p,b, etc.
      * vfdaln - length of an alpha field
      * vfdnln - length of a numeric field
      * vfddec - number of decimal positions.
      * vfdtxt - text associated with field.
      *----------------------------------------------------------------
     D                 ds                  Based(uListPtr)
     D  vfdnam                 1     10
     D  vfdtyp                11     11
     D  vfdaln                21     24b 0
     D  vfdnln                25     28b 0
     D  vfddec                29     32b 0
     D  vfdtxt                33     57
      *
      *----------------------------------------------------------------
      * map field description data into and from
      * the field storage array ArrFldDta.
      *----------------------------------------------------------------
     D mapflddta       ds                  inz
     D  fldlen                        5  0
     D  decpos                        2
     D  dtatyp                        1
     D  fldsrc                       10
     D  fldtxt                       25
      *
      *----------------------------------------------------------------
      * map *like defn field data to and from the
      * like defined storage array ArrLikFld
      *----------------------------------------------------------------
     D likefldds       ds                  inz
     D  basedonfld             1     14
     D    basedon_in                  3    overlay(basedonfld:1)
     D  flddefined            15     28
     D  adjustflag            29     29
     D  adjustlen             30     34  0
     D  savekeywrd                   25                                         save key word
      *
     D likeflddsx      s                   like(likefldds)
     D flddesave       s                   like(flddefined)
     D basedwork       s                   like(basedonfld)
      *
      *----------------------------------------------------------------
      * Save Data Structure fields for later resolution of DS size.
      *----------------------------------------------------------------
     D dtastrucds      ds                  inz
     D  stdsname               1     14                                         data structure name
     D  stdssubfld            15     28
     D  stfrompos                     5s 0
     D  sttopos                       5s 0
     D  stdefkeyw                          like(savekeywrd)
      *
      *----------------------------------------------------------------
      * Error return code parm for APIs.
      *----------------------------------------------------------------
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                      50a                                        replacement data
     D uSpaceName      s             20a   inz('JCRCMDS   QTEMP     ')
      *----------------------------------------------------------------
      * Create Prototypes for calls
      *----------------------------------------------------------------
     D quscrtus        PR                  ExtPgm('QUSCRTUS')                   create user space
     D                               20                                         Space Name
     D                               10    const                                Extended Attrb
     D                               10i 0 const                                length of space
     D                                1    const                                Hex0Init
     D                               10    const                                Use Authority
     D                               50    const                                text
     D                               10    const                                replace object
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
     D qusptrus        PR                  ExtPgm('QUSPTRUS')                   retrieve pointer
     D                               20                                         Space Name
     D                                 *                                        pointer
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
     D FilesParm       s          30000
     D rpgrecgetr      PR                  ExtPgm('RPGRECGETR')                 get files
     D  i_extfile                    20a                                        open at runtime
     D  i_extmbr                     10a                                        open at runtime
     D                               10                                         CALLING CMD
     D                                4    const                                MEMBER TYPE
     Dd                                    like(FilesParm)                      RETURNED FILES
      *    -------------------------------------------------------------
     D quslfld         PR                  ExtPgm('QUSLFLD')                    FIELD DESCRIPTIONS
     D                               20                                         Space Name
     D                                8    const                                TYPE FORMAT
     D                               20                                         FILE LIB  20
     D                               10                                         RECORD FORMAT
     D                                1    const                                NO OVERRIDES
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
     D main            PR                  extpgm('RPGFLDGETR')
     D  i_pMemPtr                      *                                        memory pointer
     D  i_extfile                    20a                                        open at runtime
     D  i_extmbr                     10a                                        open at runtime
     D  i_badfile                    10a                                        for queue jobs
     D  i_cmdswitch                  10a                                        which command
      *    -------------------------------------------------------------
     D main            PI
     D  i_pMemPtr                      *
     D  i_extfile                    20a
     D  i_extmbr                     10a
     D  i_badfile                    10a
     D  i_cmdswitch                  10a
      *----------------------------------------------------------------
     Iqrpgsc    ns  lr   13 c*   14 c*   15 c
     I         or        13 c*   14 c*   15 cc                                  named array
     I         or        13 c*   14 c*   15 cC                                  named array
      *
     I          ns  02   19nc*   19nc/   19nc+
     I                                  1    6  match_seqn      m1
     I**                                1   92  srcdta
     I                                  1  112  srcdta
     I          ns  05
     I                                  1    6  match_seqn      m1
      *
     Ilookaheadrns  lr   13 c*   14 c*   15 c
     I         or        13 c*   14 c*   15 cc                                  named array
     I         or        13 c*   14 c*   15 cC                                  named array
      *
     I          ns  03   18 cD   19nc*   19nc/
     I         or        18 cd   19nc*   19nc/
     I                                  1    6  look_seqn       m1
     I**                                1   92  srcdta
     I                                  1  112  srcdta
     I          ns  05
     I                                  1    6  match_seqn      m1
     I          ns  **
     I                                 18   18  aheadtype
     I                                 19   19  aheadcomt
     I                                 19   28  aheadfname
     I                                 56   92  aheadkeywd
      *
      *----------------------------------------------------------------
      * LOOKAHEAD. This section is used to get the DIM(x) value and calc the
      * length of each element. LIKE( are also captured.
      * The subfields of each internal DS (with no length defined) are also
      * loaded for later DS length resolution
      *----------------------------------------------------------------
      /free
 1b    select;
 1x    when  *in03;      //DSPEC LOOKAHEAD
          likflag=*off;
          defkeyword=%xlate(lo:up:defkeyword);
          exsr  srGetDimSize;

          // ----------------------------------------------------
          // If LIKE, extract field name.
          // ----------------------------------------------------
          a=%scan('LIKE(':defkeyword);
 2b       if  a>0;
             b=%scan(')':defkeyword:a);
             likflag = *on;
             likvalue = %subst(defkeyword:a+5:b-(a+5));
             likdescrip  = %subst(defkeyword:a:b-a+1);
 2e       endif;

          // ----------------------------------------------------
          // If OVERLAY, set flag for no load into DS arrays
          // ----------------------------------------------------
          a=%scan('OVERLAY':defkeyword);
 2b       if  a>0;
             ovrlayflag=*on;
 2e       endif;

          //(a or b) and c and d
 2b       if  (aheadtype = 'd' or aheadtype = 'D') and
             aheadfname = *blanks and aheadkeywd <> *blanks;
             force  lookaheadr;
 2e       endif;

          // ----------------------------------------------------
          // route to appropriate subroutine depending on record type.
          // ----------------------------------------------------
 1x    when  *in02;              //NOT EJECT& CMNT
          srcdta=%xlate(lo:up:srcdta);
 2b       select;
 2x       when  xspec = 'C';
             exsr  srCalcSpec;
 2x       when  xspec = 'I';
             exsr  srInputSpec;
 2x       when  xspec = 'D';
             exsr  srDefineSpec;
 2x       when  xspec = 'H';
             exsr  srHeaderSpec;
 2e       endsl;
 1e    endsl;

      /end-free
     Clr                 exsr      lrsub
      /free

       // ----------------------------------------------------
       // If DIM.
       // Treat it similar to a LIKE defn as the field being %size
       // or %elem may not be defined at this point.
       // ----------------------------------------------------
       begsr  srGetDimSize;
       a=%scan('DIM(':defkeyword);
 1b    if  a>0;
          // compress out all spaces on line
          b=0;
          compressout=*blanks;
 2b       for  vy = 1 to 37;
 3b          if  %subst(defkeyword:vy:1)>' ';
                b=b+1;
                %subst(compressout:b:1)=%subst(defkeyword:vy:1);
 3e          endif;
 2e       endfor;
          defkeyword=compressout;

          a=%scan('DIM(':defkeyword);
          b=%scan(')':defkeyword:a);
          dimflag = *on;

          exsr srGetBifType;

          // ----------------------------------------------------
          // Thanks to Chris Faber for finding this bit of  subtlety.
          // An array could be dimensioned by a constant value.
          // ----------------------------------------------------
 2b       if  BifType = *blanks;   // not a bif
             workdimfld = %subst(defkeyword:a+4:(b-a)-4);
             // make sure not numeric
 3b          if  %subst(workdimfld:1:1)<'0' or
                %subst(workdimfld:1:1)>'9';
                // check definitions file
                nn=%lookup(workdimfld:arrfldnam:1:ii);
 4b             if  nn>0;
                   mapflddta = arrflddta(nn);

                   // extract the constant value from the fld text
                   a=%scan('Const':fldtxt);
                   dimdescrip =  'DIM(' +
                   %trimr(%subst(fldtxt:a+6)) + ')';
 LV                leavesr;
 4e             endif;
 3e          endif;
 2e       endif;

          // ----------------------------------------------------
          // Get the DIM size here.
          // Extract the field name from the bif and try to find
          // its attributes on the field name array.   Good luck...
          // ----------------------------------------------------
 2b       if  BifType <> *blanks; //bif
             c = %scan('(':defkeyword:c);
             workdim = %trimr(%subst(defkeyword:c+1));
             c = %scan(')':workdim:1);
             workdimfld = %subst(workdim:1:c-1);

             nn=%lookup(workdimfld:arrfldnam:1:ii);
 3b          if  nn>0;
                mapflddta = arrflddta(nn);

 4b             select;
 4x             when  BifType = '%ELEM';
                   dimdescrip = fldtxt;

 4x             when  BifType = '%SIZE' or
                   BifType = '%LEN ';
                   vwrk5num=fldlen;
                   dimvalue=vwrk5num;
                   dimdescrip = 'DIM(' + vwrk5 + ')';
 4e             endsl;
 3e          endif;
             // ** JCR                 BifFlag = *on
 2x       else;
             // ----------------------------------------------------
             vwrk5 = %subst('00000':1:5 -((b-a)-4)) +
             %subst(defkeyword:a+4:(b-a)-4);
             dimvalue=vwrk5num;
             dimdescrip  = %subst(defkeyword:a:b-a+1);
 2e       endif;
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // If DIM or constant value, it could be
       // either %size, %elem or %len.
       // ----------------------------------------------------
       begsr srGetBifType;
       clear BifType;
       c=%scan('%SIZE':defkeyword);
 1b    if c > 0;
          BifType = '%SIZE';
 1x    else;

          c=%scan('%ELEM':defkeyword);
 2b       if c > 0;
             BifType = '%ELEM';
 2x       else;

             c=%scan('%LEN':defkeyword);
 3b          if c > 0;
                BifType = '%LEN ';
 3e          endif;
 2e       endif;
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // load the fields from the calc specs.
       // ----------------------------------------------------
       begsr  srCalcSpec;

       // ----------------------------------------------------
       // Now all the F, D, and I specs have been processed.
       // Load the file and defined fields into the ultimate field array.
       // ----------------------------------------------------
 1b    if firstcalc = *on;
          firstcalc = *off;

 2b       for  a = 1 to ff;     //PROCESS ARRAY
             field=%subst(fileflds(a):1:14);

             // ----------------------------------------------------
             // If file source is blank, update from file fields array.
             // ----------------------------------------------------
             nn=%lookup(field:arrfldnam:1:ii);
 3b          if  nn>0;
                mapflddta = arrflddta(nn);
 4b             if  fldsrc=*blank;
                   arrflddta(nn) = filefldstg(a);                             //overlay program defn
 4e             endif;
                // ----------------------------------------------------
                // If field is not yet in file, load it.
                // ----------------------------------------------------
 3x          else;
                ii=ii+1;                                                            //NEXT OPEN SLOT
                arrfldnam(ii) = field;                                             //LOAD FIELD NAME
                arrflddta(ii) = filefldstg(a);                                     //LOAD FIELD DATA
 3e          endif;
 2e       endfor;
 1e    endif;

       // ----------------------------------------------------
       // this section is used to load all *like defn values into a
       // separate array.  this is required as the referenced field may
       // not have been defined yet.  this array will be processed at
       // either at lr or the first o spec.
       // ----------------------------------------------------
 1b    select;
 1x    when  srcfactor1 = '*LIKE ';
          wrkfactor2 = srcfactor2;                                                  //REFERENCED FLD
          wrkresult = srcresult;                                                     //DEFINED FIELD
          wrklength = srclength;
          exsr  srLikeDefine;

          // ----------------------------------------------------
          // load fields that are defined within calc lines.
          // ----------------------------------------------------
 1x    when  srcopcode <> *blanks  and
          srcresult <> *blanks  and
          srclength <> *blanks  and
          %subst(srcresult:1:3) <> '*IN'  and
          %subst(srcopcode:1:4) <> 'WHEN' and
          %subst(srcopcode:1:3) <> 'DOU'  and
          %subst(srcopcode:1:3) <> 'FOR'  and
          %subst(srcopcode:1:3) <> 'DOW'   and
          %subst(srcopcode:1:2) <> 'IF'    and
          %subst(srcopcode:1:4) <> 'CALL'  and
          %subst(srcopcode:1:6) <> 'RETURN'  and
          %subst(srcopcode:1:5) <> 'CALLP'  and
          %subst(srcopcode:1:4) <> 'EVAL';

          // ----------------------------------------------------
          // Caution:  Some result fields could have :(date type) extender.
          // example   a    subdur    b     c:*D     3  0
          // We only want to load up to the ':'
          // ----------------------------------------------------
          a = %scan(':':srcresult:1);
 2b       if  a <> 0;           //found one
             srcresult = %subst(srcresult:1:a-1);
 2e       endif;

          field = srcresult;
 2b       if  srcdecimal > '  ';
             dtatyp = 'P';
             decpos = srcdecimal;
 2x       else;
             dtatyp = 'A';
 2e       endif;

 2b       if  srcLength=*blanks;
             fldlen=0;
 2x       else;
             fldlen = srclengthN;
 2e       endif;
          clear   fldsrc;
          clear   fldtxt;
          exsr  srAddFldNam;
 1e    endsl;
       endsr;

       // ----------------------------------------------------
       // add fields in the storage arrays if not found.
       // ----------------------------------------------------
       begsr  srAddFldNam;
 1b    if  ii=0  or
          %lookup(field:arrfldnam:1:ii)=0;
          ii=ii+1;

 2b       select;
 2x       when  dtatyp = 'A';
             decpos = *blanks;
 2x       when  %subst(decpos:1:1) = '0';
             %subst(decpos:1:1) = ' ';
 2e       endsl;

          arrfldnam(ii)  = field;                                             //     LOAD FIELD NAME
          arrflddta(ii) = mapflddta;                                          //     LOAD FIELD DATA
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // process the D specs for fields defined in data structures and
       // stand alone fields.
       // ----------------------------------------------------
       begsr  srDefineSpec;

       // -----------------------------------------------
       // Conditions that set PR prototype flag
       // or the PI procedure interface flag = *OFF
       // Note:  The longer field names can span across other fields.
       // Ignore lines that end in ...
       // -----------------------------------------------
 1b    if %scan('...':srcdta)=0 and
          defPI_PR<> '    ';
          PRflg= *off;
          PIflg= *off;
 1e    endif;

       // -----------------------------------------------
       // Conditions that set PR prototype flag
       // or the PI procedure interface flag = *ON
       // -----------------------------------------------
 1b    If defPI_PR= ' PR ';
          PRflg= *on;
 1x    elseif defPI_PR = ' PI ';
          PIflg= *on;
 LV       leavesr;
 1e    endif;

 1b    if PRflg=*on;
 LV       leavesr;
 1e    endif;

       // -----------------------------------------------
       // If a DS is internal and not explicitly defined,
       // save the structure for processing later.
       //  Overlay fields are not loaded as they do not
       // effect the length of the structure.
       // -----------------------------------------------
 1b    if  defds <> *blanks;
          insideds=*off;     //reset
 1e    endif;

 1b    if  insideds=*on  and   //load 'em up
          ovrlayflag = *off and
          deffldn <> *blanks;
          stdssubfld = %triml(deffldn);
 2b       if  deffrom=*blanks or
             %subst(defstatus:1:1)  = '*';
             deffromNUM=0;
 2e       endif;
          stfrompos=deffromNUM;
 2b       if  %scan('+':defto)>0  OR
             %scan('-':defto)>0;
             clear   sttopos;
 2x       else;
 3b          if  defto=*blanks;
                deftoN=0;
 3e          endif;
             sttopos = deftoN;
 2e       endif;

          stdefkeyw = defkeyword;
          s=s+1;
          arrdsstruc(s)=dtastrucds;
 1e    endif;

 1b    if  defds = 'DS'  and    // DATA STRUCTURE
          defdsext <> 'E'  and   // EXTERNAL DS
          deffldn <> *blanks and // named ds
          defto = *blanks;       // not directly defn
          insideds=*on;         // reset
          stdsname = %triml(deffldn);
 1e    endif;

 1b    select;
          // -----------
 1x    when  defstdalon = 'C'; //  constant
          exsr srGetBifType; // see if defined by bif
 2b       if BifType = *blanks;
             exsr  srConstantSize;    //load constant sizes
             fldn = %triml(deffldn);
             ffmt =  'C';
             from = '00001';
             to=conLengthA;

             // ----------------------------------------------------
             // Chris Faber
             // When a constant is used as a DIM statement, we
             //  need to drop the word 'const' from the string
             // and left justify the value
             // ----------------------------------------------------
             defkeyword=%triml(defkeyword);
 3b          if  %subst(defkeyword:1:6)='CONST(';
                defkeyword=%subst(defkeyword:7);
                // find last ')' and remove it.
                vc1 = %checkr(' ':defkeyword);
 4b             if  %subst(defkeyword:vc1:1)=')';
                   %subst(defkeyword:vc1:1)=' ';
 4e             endif;
 3e          endif;

             fldtxt = 'Const ' + defkeyword;
             exsr  srDefineAdd;
 2x       else;
             exsr srBifDefinedConstant;
 2e       endif;

          // -----------
 1x    when  deffldn <> *blanks  and  //*STATUS FIELDS
          %subst(defstatus:1:1) = '*';

          fldn = %triml(deffldn);
          from = '00001';
 2b       select;
 2x       when  defstatus = '*STATUS ';
             ffmt =  'S';
             to =  '00005';
             dpos = '00';
             fldtxt = defstatus;
             exsr  srDefineAdd;

 2x       when  defstatus = '*FILE   '  or
             defstatus = '*RECORD '  or
             defstatus = '*ROUTINE';
             ffmt =  'A';
             to =  '00008';
             dpos = '  ';
             fldtxt = defstatus;
             exsr  srDefineAdd;

 2x       when  defstatus = '*OPCODE ';
             ffmt =  'A';
             to =  '00006';
             dpos = '  ';
             fldtxt = defstatus;
             exsr  srDefineAdd;

 2x       when  defstatus = '*PARMS  ';
             ffmt =  'S';
             to =  '00003';
             dpos = '00';
             fldtxt = defstatus;
             exsr  srDefineAdd;

 2x       when  defstatus = '*PROC   ';
             ffmt =  'A';
             to =  '00010';
             dpos = '  ';
             fldtxt = defstatus;
             exsr  srDefineAdd;
 2e       endsl;
          // -----------
 1x    when  deffldn <> *blanks   and
          likflag  = *off     and
          (defto <> *blanks or
          defdtatype = '*' or
          defdtatype = 'D' or
          defdtatype = 'T' or
          defdtatype = 'Z');

 2b       select;
 2x       when  defdtatype = '*';
             deffrom = '00001';
             defto = '00016';

 2x       when  defdtatype = 'T';
             deffrom = '00001';
             defto = '00008';

 2x       when  defdtatype = 'Z';
             deffrom = '00001';
             defto = '00026';

             // ----------------------------------------------------
             // Date format lengths depend on the DATFMT field.
             // ----------------------------------------------------
 2x       when  defdtatype = 'D';
             a=%scan('DATFMT(':defkeyword);
 3b          if  a>0;
                defdatefmt = %subst(defkeyword:a+7:4);
 3x          else;
                defdatefmt = h_datefmt;
 3e          endif;

 3b          select;
 3x          when  defdatefmt = '*MDY' or
                defdatefmt = '*YMD' or
                defdatefmt = '*DMY';
                defto = '00008';
 3x          when  defdatefmt = '*JUL';
                defto = '00008';
 3x          other;
                defto = '00010';
 3e          endsl;

             deffrom = '00001';
 2e       endsl;
          // --------------
          fldn = %triml(deffldn);

 2b       if  deffrom = *blanks or deffrom='00000';
             from = '00001';
 2x       else;
             from =  deffrom;
 2e       endif;

          ffmt =  defdtatype;
          to =  defto;
          dpos = defdpos;
          // ----------------------------------------------------
          // If a field is defined as stand alone
          // and the format type is blank and there
          // is a decimal point value, the field is packed.
          // ----------------------------------------------------
 2b       if  ffmt =  *blanks   and
             dpos > '  '       and
             defstdalon = 'S';
             ffmt =  'P';
 2e       endif;

          // ----------------------------------------------------
          // Special processing is required if the array is
          // defined as a subfield of a data structure
          // The end result looks like a standalone definition.
          // ----------------------------------------------------
 2b       if  dimflag = *on and  // array definition
             (deffrom <> *blanks and deffrom <> '00000');
             fpos=fromNUM;
             tpos=toNUM;
             tpos = (tpos - fpos + 1) / dimvalue;
             fromNUM=1;
             toNUM = tpos;
 2e       endif;

          clear   fldtxt;
          exsr  srDefineAdd;

          // ----------------------------------------------------
          // LIKE DEFINE DEFINITIONS.
          // ----------------------------------------------------
 1x    when  deffldn <> *blanks  and
          likflag = *on;

          wrkfactor2 = likvalue;
          wrkresult = %triml(deffldn);
          wrklength = defto;

          // ----------------------------------------------------
          // Load the DIM description in first.  If blank, + in elems.
          // If DIM & LIK put a space between them.
          // ----------------------------------------------------
 2b       if  dimdescrip <> *blanks;
             savekeywrd = %trim(dimdescrip) + ' ' +
             %trim(likdescrip);
 2x       else;
             savekeywrd = %trim(likdescrip);
 2e       endif;
          exsr  srLikeDefine;
 1e    endsl;

       dimflag=*off;
       bifflag=*off;
       likflag=*off;
       ovrlayflag=*off;
       clear   dimvalue;
       clear   dimdescrip;
       clear   likvalue;
       clear   likdescrip;
       clear   fldprefix;
       endsr;

       // ----------------------------------------------------
       // Thanks to Tim Hawkins for suggesting this bit of water torture.
       // The deal here is a constant could be defined by a bif.
       // D Constant   C   %size(field)
       // D Constant   C   %len(field)
       // D Constant   C   %elem(array)
       //
       // You can't define the length of the constant until the field
       // within the bif is resolved.
       // The trick here is going to dummy these up as if they are
       // like() defined fields then let the subroutine
       // srResolveDefn worry about defining the constants.
       // ----------------------------------------------------
       begsr srBifDefinedConstant;
       wrkresult = %triml(deffldn);
       wrklength = 'BIFCO';
       savekeywrd=%triml(defkeyword);
       a=%scan('(':defkeyword);
 1b    if  a>0;
          b=%scan(')':defkeyword:a);
          wrkfactor2 = %subst(defkeyword:a+1:b-(a+1));
          exsr srLikeDefine;
 1e    endif;
       endsr;

       // ----------------------------------------------------
       begsr  srDefineAdd;
       field = fldn;
       clear   fldsrc;
       // Array definition
 1b    select;
 1x    when  dimflag=*on;
          fldtxt=dimdescrip;
          dimflag=*off;

 1x    when  defdtatype = 'D';
          fldtxt=defdatefmt;
 1x    other;
          // clear                   fldtxt
 1e    endsl;

       fpos=fromNUM;
       tpos=toNUM;
 1b    if(m)  (tpos - fpos + 1)>0;
          len = tpos - fpos + 1;
 1e    endif;
       // alphanumeric
 1b    select;
 1x    when  dpos = '  ';
 2b       if  defdtatype = '*' or                                                          //POINTER
             defdtatype = 'D' or                                                              //DATE
             defdtatype = 'T' or                                                              //TIME
             defdtatype = 'Z';                                                           //TIMESTAMP
             dtatyp = defdtatype;
 2x       else;
             dtatyp = 'A';
 2e       endif;
          fldlen = len;
          // packed decimal
 1x    when  ffmt = 'P';
 2b       if  defstdalon = 'S'   //  stand alone field
             or PIflg=*on;     //  Procedure Interface
             fldlen = len;
 2x       else;
 3b          if  %scan('PACKEVEN':defkeyword)>0;
                fldlen = 2*(len-1);                                   //PACKEVEN
 3x          else;
                fldlen =(2*len)-1;                                    //NORMAL
 3e          endif;
 2e       endif;
          dtatyp = ffmt;
          decpos = dpos;
          // binary
 1x    when  ffmt = 'B';
          dtatyp = ffmt;
          decpos = dpos;
 2b       if  len = 4;
             fldlen  = 9;
 2x       else;
             fldlen = 4;
 2e       endif;
          // Integer (signed or unsigned)
 1x    when  ffmt = 'I' or
          ffmt = 'U';
          dtatyp = ffmt;
          decpos = dpos;
          fldlen = len;
          // zoned decimal
 1x    other;
          dtatyp = 'S';
          decpos = dpos;
          fldlen = len;
 1e    endsl;
       exsr  srAddFldNam;
       clear   fldtxt;
       endsr;

       // ----------------------------------------------------
       // subroutine to load all like defines into holding array
       // ----------------------------------------------------
       begsr  srLikeDefine;
       l=l+1;
       clear   adjustlen;
       clear   adjustflag;
       basedonfld = wrkfactor2;                                                     //REFERENCED FLD
       flddefined = wrkresult;                                                       //DEFINED FIELD
 1b    if wrklength='BIFCO'; // bif defined constants
          adjustflag = 'C';
          adjustlen = *zeros;                                                         //MAKE DECIMAL
 1x    else;
          a=%scan('+':wrklength);
 2b       if  a=0;
             a=%scan('-':wrklength);
 2e       endif;
 2b       if  a>0;
             adjustflag = %subst(wrklength:a:1);   // + or -
             vwrk5 = '00000';
             %subst(vwrk5:a+1:5-a) = %subst(wrklength:a+1:5-a);
             adjustlen = vwrk5num;                                                    //MAKE DECIMAL
 2e       endif;
 1e    endif;
       arrlikfld(l) = likefldds;                                                   //LOAD SAVE ARRAY
       clear   savekeywrd;
       endsr;

       // ----------------------------------------------------
       // process the i specs for input fields.
       // ----------------------------------------------------
       begsr  srInputSpec;
 1b    if  filenm <> *blanks;
          formatname=filenm;
 1e    endif;

 1b    select;
 1x    when  infldn <> *blanks  and
          infrom <> *blanks  and
          into <> *blanks;
          fldn = infldn;
          from =  infrom;
          ffmt =  inffmt;
          to =  into;
          dpos = indpos;
          clear   fldtxt;
          exsr  srDefineAdd;

          // ----------------------------------------------------
          // change field names for renames.
          // ----------------------------------------------------
 1x    when  infldn <> *blanks  and
          extfld <> *blanks;
          formatkey = extfld + '    ' + formatname;
          nn=%lookup(formatkey:fileflds:1:ff);
 2b       if  nn>0;
             %subst(fileflds(nn):1:14) = infldn;                                   // RENAME ELEMENT
 2e       endif;
 1e    endsl;
       endsr;

       // ----------------------------------------------------
       // Get DATFMT( if any from H specs
       // ----------------------------------------------------
       begsr  srHeaderSpec;                                                            //HEADER SPEC
       a=%scan('DATFMT(':srcdta:19);
 1b    if  a>0;
          h_datefmt = %subst(srcdta:a+7:4);                                        // LOAD FILE NAME
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // Define all DS's that can be.
       // This should increase the 'HIT' rate of the srResolveDefn SR.
       // the array will be processed like a coded Full procedural L1.
       // ----------------------------------------------------
       begsr  srPreResolveDS;
       prvdsname=arrdsstruc(1);
       clear   highto;
       alldefflag = *on;
 1b    if  prvdsname <> *blanks;                                                      //at least one

 2b       for  x = 1 to s;
             dtastrucds = arrdsstruc(x);                             //re map

             // ----------------------------------------------------
             // First 'record' of a new group.
             // ----------------------------------------------------
 3b          if  prvdsname <> stdsname;
                exsr  srSizePrvDS;                        //process last of prv
                prvdsname =  stdsname;
                clear   highto;
                alldefflag = *on;
 3e          endif;

             // ----------------------------------------------------
             // Detail Processing.  OK here's the deal on DS length
             // FROM TO
             // 00   00  get field definition| Add len to HIGHTO
             // 00   99                      | Add defined len to HIGHTO
             // 11   99 is TO *GT HIGHTO?    | if yes, TO becomes new HIGHTO
             // The only blow is a subfield could be a
             // *LIKE DEFN that has not been done 1st time
             // This is why the resolve subroutines are done twice!
             // ----------------------------------------------------
 3b          select;
 3x          when  stfrompos > 0;                                                         //explicit
 4b             if  sttopos > highto;
                   highto = sttopos;
 4e             endif;

 3x          when  sttopos > 0;                                               //implicit but defined

 4b             if  %scan('DIM(':stdefkeyw)>0;
                   defkeyword =  stdefkeyw;
                   bifflag = *off;
                   exsr  srGetDimSize;
 5b                if  bifflag=*on;
                      alldefflag=*off;                                              // not yet coded
 5x                else;
                      dimvalue=vwrk5num;
                      sttopos = sttopos*dimvalue;
 5e                endif;
 4e             endif;
                highto = highto + sttopos;

 3x          other;                                                              //just a field name
                nn=%lookup(stdssubfld:arrfldnam:1:ii);
 4b             if  nn=0;                                                                //not found
                   alldefflag = *off;
 4x             else;
                   mapflddta = arrflddta(nn);                                 //         LOAD FIELDS
                   // if        dtatyp = 'P'                                 PACKED
                   // eval(h)   Fldlen=(fldlen+1)/2                          packed length
                   // endif

                   // ----------------------------------------------------
                   // could be dimensioned
 5b                if  %scan('DIM(':fldtxt)>0;
                      defkeyword =  fldtxt;
                      bifflag = *off;
                      exsr  srGetDimSize;                                          //extract DIM(xx)
 6b                   if  bifflag=*on;
                         alldefflag=*off;                                           // not yet coded
 6x                   else;
                         dimvalue=vwrk5num;
                         fldlen = fldlen*dimvalue;
 6e                   endif;
 5e                endif;

                   highto = highto + fldlen;                                     //signed zoned etc.
 4e             endif;
 3e          endsl;

 2e       endfor;
          exsr  srSizePrvDS;
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // If all subfields in the DS are programmed
       // described and explictly positioned
       // ----------------------------------------------------
       begsr  srSizePrvDS;
 1b    if  alldefflag= *on;
          fldlen = highto;
          clear   decpos;
          dtatyp = 'A';
          clear   fldsrc;
          fldtxt='DS ';
          field = prvdsname;                                                       //LOAD FIELD NAME
          exsr  srAddFldNam;
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // go back and resolve all *like defn fields now that all other
       // fields have been defined.
       // Special code takes care of BasedOnFld = *IN
       // ----------------------------------------------------
       begsr  srResolveDefn;
 1b    for  x = 1 to L;
          likefldds = arrlikfld(x);

 2b       if  basedon_in = '*IN';
             fldlen = 1;
             decpos = *blanks;
             dtatyp = 'A';
             nn=1;
 2x       else;
             nn=%lookup(basedonfld:arrfldnam:1:ii);
 3b          if  nn>0;
                mapflddta = arrflddta(nn);
 3x          else;

                // ----------------------------------------------------
                // This deals with what I call runaway DEFN.
                // A   LIKE(B)
                // B   LIKE(C)
                // C s 10
                // When the A field comes through here,
                // B has not been resolved yet, so there is no defn for A.
                // If the BasedOnFld does not get a hit,
                // this section runs up the tree until a hit is found.
                // ----------------------------------------------------
                flddesave =  flddefined;
                basedwork =  basedonfld;
                likeflddsx = likefldds;                                               //save current

 4b             for  dummy=1 to 40;
 5b                for  b = 1 to L;
                      likefldds = arrlikfld(b);                                    //LOAD SAVE ARRAY
 6b                   if  flddefined = basedwork;                                         //Found it

                         nn=%lookup(basedonfld:arrfldnam:1:ii);
 7b                      if  nn>0;
                            flddefined = flddesave;
 5v                         leave;                                                   //FOUND IT HERE
 7x                      else;
                            basedwork =  basedonfld;
 7e                      endif;
 6e                   endif;
 5e                endfor;

 5b                if  nn>0;
                      mapflddta = arrflddta(nn);
 4v                   leave;                                                         //FOUND IT HERE
 5e                endif;
 4e             endfor;
 3e          endif;
 2e       endif;

 2b       if  nn>0;
 3b          select;
 3x          when  adjustflag = '+';
                fldlen=fldlen+adjustlen;
 3x          when  adjustflag = '-';
                fldlen = fldlen - adjustlen;
 3e          endsl;

             // last bit of the Tim Hawkins suggestion.
             // calc the length of an %elem defined bif function
             // by determining the size of the %elems.
             // If the array is dim(1) then length of constant =1
             // if dim(10), length=2, etc...
 3b          if AdjustFlag='C';
                decpos='00';
 4b             if %subst(savekeywrd:1:5)='%ELEM'
                   and %subst(fldtxt:1:4)='DIM(';
                   a=%scan(')':fldtxt);
 5b                if a<>0;
                      b=%checkr('0':fldtxt:a-1);
 6b                   if b<>0;
                         fldlen=a-b;
                         dtatyp='S';
 6e                   endif;
 5e                endif;
 4e             endif;
                eval savekeywrd = 'Const '+savekeywrd;
 3e          endif;

             clear   fldsrc;
             fldtxt = savekeywrd;
             field = flddefined;                                                   //LOAD FIELD NAME
             exsr  srAddFldNam;
 2e       endif;
 1e    endfor;
       clear   l;
       endsr;

       // ----------------------------------------------------
       // Now resolve all like defines and DS lengths
       // execute twice to get defines on defines
       // ----------------------------------------------------
       begsr  lrsub;
       exsr  srPreResolveDS;
       exsr  srResolveDefn;
       exsr  srPreResolveDS;
       exsr  srResolveDefn;

       // for certain utilities, load UDATE and PAGE1-8
 1b    if i_cmdswitch = 'ANZOSPEC  '  or
          i_cmdswitch = 'GENPRTF   '  or
          i_cmdswitch = 'RPG4MAX   ';

          // Load PAGE and UDATE reserved word values.
 2b       for  a = 1 to 8;
             ii = ii + 1;
 3b          if  a = 8;
                arrfldnam(ii) = 'PAGE';                                           // LOAD FIELD NAME
 3x          else;
                arrfldnam(ii) = 'PAGE' +                                         // PAGE 1 through 7
                %triml(%editc(a:'3'));
 3e          endif;
             fldlen = 4;
             decpos = '00';
             dtatyp =  'P';
             fldsrc =  *blanks;
             fldtxt =  'Page Number            ';
             arrflddta(ii) = mapflddta;                                           // LOAD FIELD DATA
 2e       endfor;
          ii = ii + 1;
          arrfldnam(ii) = 'UDATE ';
          fldlen = 6;
          decpos = '00';
          dtatyp =  'P';
          fldsrc =  *blanks;
          fldtxt =  'Udate            ';
          arrflddta(ii) = mapflddta;
 1e    endif;

       // If ii = 0,  then no fields were found in target source
       // and no need to load anything into memory.
       // Thanks to Tim Hawkins in Scotts Valley, CA
 1b    if ii>0;

          // load field data into allocated heap memory
          sorta  arrsort;                                                             //SORT BY NAME
 2b       for  nn = %elem(arrsort)-(ii-1) to %elem(arrsort);                        // PROCESS ARRAY
             eval memptr2=i_pMemPtr + ((memNumEntries * memEntryLen)+5);
             eval memNumEntries = memNumEntries + 1;
             eval alpha57=arrsort(nn);
 2e       endfor;
 1e    endif;
       *inlr=*on;
       return;
       endsr;

       // ----------------------------------------------------
       // Here is were we determine constant type and length.
       // The fun comes in determining if the constant has
       // been extended across multiple lines of sources.
       // D confield      c     '11111-
       // 22222'
       // A ' mark will always mean this is an alpha constant.

       // The numeric constants can be defined as
       // D numcon        c     const(123)
       // D numcon        c     123
       // Also included in this mess are hexadecimal
       // constants that require dividing the length
       // of the constant by 2 to get actual length.
       // ----------------------------------------------------
       begsr  srConstantSize;
       vc1=  %scan(quote:defkeyword:1);
 1b    if  vc1<> 0;                                                                  //found a quote
          vc2=  %scan(quote:defkeyword:vc1+2);
          // - cheap shot for constants split over lines
 2b       if  vc2=0;
             vc2=25;
 2e       endif;
          // - end cheap shot for constants split over lines
 2b       if  vc2<> 0;                                                          //found second quote
             conlength = vc2 - (vc1 +1);                                           //constant length

 3b          if  vc1 > 1 and
                %subst(defkeyword:vc1-1:1) = 'X';                                        //hex value
                conlength=conlength/2;
 3e          endif;
             dpos = '  ';
 2e       endif;

          // ----------------------------------------------------
          // No pretty way to extract the length of the numeric
          // constant or the number of decimal positions...
          // That being said, we do it a real ugly way..
          // Spin through the entire defkeyword..
          // 1st number becomes the start,  last number is
          // end and the position of the decimal is saved.
          // use these values to calc len and  decimals.
          // ----------------------------------------------------
 1x    else;                                                           //numeric
          dpos = '00';
          clear   vcstart;
          clear   vcend;
          clear   vcdec;
 2b       for  vc1= 1 to 37;
 3b          if  vcstart > 0 and
                %subst(defkeyword:vc1:1) = ' ';
 2v             leave;
 3e          endif;

 3b          if  %subst(defkeyword:vc1:1) >= '0' and
                %subst(defkeyword:vc1:1) <= '9';
 4b             if  vcstart > 0;
                   vcend = vc1;
 4x             else;
                   vcstart = vc1;
 4e             endif;
 3e          endif;

 3b          if  %subst(defkeyword:vc1:1) = '.';
                vcdec   = vc1;
 3e          endif;
 2e       endfor;

 2b       if  vcend = 0;                                                              //1 digit long
             vcend = vcstart;
 2e       endif;

          conlength = vcend - (vcstart - 1);                                       //constant length
 2b       if  vcdec <> 0;
 3b          if  vcdec < vcend;                                               //decimal places found
 4b             if  vcdec > vcstart;
                   conlength = conlength - 1;
 4e             endif;
                vcdecpos  = vcend - vcdec;
                dpos=vcdecposA;
 3e          endif;
 2e       endif;
 1e    endif;
       endsr;

       // ----------------------------------------------------
       // Create user space.  Unload file array from RPGRECGETR
       // and load all file fields and DS fields into work arrays.
       // ----------------------------------------------------
       begsr  *inzsr;
       clear   i_badfile;
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

       // ----------------------------------------------------
       // Call program to load the fields from either
       //  externally described files or  e ds.
       // ----------------------------------------------------
       callp   RPGRECGETR(
               i_extfile:
               i_extmbr:
               i_cmdswitch:
               'RPG4':
               FilesParm);

       // ----------------------------------------------------
       // Spin through FileParms and load into work array.
       // ----------------------------------------------------
       vy=1;
 1b    for  dummy=1 to 300;
          arryelemds = %subst(filesparm:vy:100);
          vy=vy+100;
 2b       if  afilename=*blanks;
 1v          leave;
 2e       endif;
          filenm     = afilename;                                                   //LOAD FILE NAME
          formatname = aformatname;                                           //LOAD RECORD FMT NAME
          fmtrename  = arenamedfmt;                                             //renamed record fmt
          fldprefix = aprefix;

          // ----------------------------------------------------
          // Error (FILE NOT FOUND) this is a hard error.
          // Load return parm and exit program
          // ----------------------------------------------------
 2b       if  adesc = '*FILE NOT FOUND ';                                           //error occurred
             i_badfile = afilename;                                                 //for queue jobs
             *inlr = *on;
             return;
 2e       endif;

          // ----------------------------------------------------
          // Load field descriptions to the user space.
          // ----------------------------------------------------
          filelib = filenm + '*LIBL ';
          callp   QUSLFLD(
                  uSpaceName:
                  'FLDL0100':
                  filelib:
                  formatname:
                  '1':
                  vApiErrDs);
          clear   lencount;

          // ----------------------------------------------------
          // Process elements in user space
          // ----------------------------------------------------
          uListPtr = uHeadPtr + uOffSetToList;
 2b       for  dummy = 1 to uNumOfEntrys;

             // map data out in to fields
 3b          if  %subst(vfdnam:1:3) <> '*IN';                                       //FROM DSP FILES

                // Prefix, depending on whether or not number
                // of replacement characters was specificed.
 4b             if  fldprefix <> *blanks;
 5b                if  aprefix_chr = 0;
                      vfdnam = %trim(fldprefix) + vfdnam;
 5x                else;
                      vfdnam = %trimr(fldprefix) +
                      %subst(vfdnam:aprefix_chr+1);
 5e                endif;
 4e             endif;

 4b             if vfdtyp = 'A' or                             //ALPHA
                   vfdtyp = 'Z' or                             //TIMESTAMP
                   vfdtyp = 'T' or                             //TIME
                   vfdtyp = 'L';                               //DATE
                   fldlen        = vfdaln;                     //FIELD LENGTH
                   decpos = *blanks;
 4x             else;
                   fldlen        = vfdnln;                             //NUMERIC
                   decpos = %subst(%editc(vfddec:'3'):8:2);
 5b                if  %subst(decpos:1:1) = '0';
                      %subst(decpos:1:1) = ' ';                                       //zero supress
 5e                endif;
 4e             endif;

                lencount = lencount+vfdaln;                                        //for external DS
                dtatyp = vfdtyp;                                                         //DATA TYPE
                fldtxt = vfdtxt;                                                         //DATA TYPE
                fldsrc = filenm;

                ff=ff+1;                                                            //NEXT OPEN SLOT
 4b             if  fmtrename = *blanks;
                   fileflds(ff) = vfdnam + '    '  + formatname;              //LOAD 14 long fld nam
 4x             else;
                   fileflds(ff) = vfdnam +'    '+ fmtrename;                   //renamed Format name
 4e             endif;

                fldsrc=filenm;
                filefldstg(ff)= mapflddta;                                         //LOAD FIELD DATA
 3e          endif;
             uListPtr  = uListPtr  + uSizeOfEntry;                                      //NEXT ENTRY
 2e       endfor;
          clear   fldprefix;
          clear   fmtrename;

          // Use use endpos of last field in file for length of E DS.
 2b       if  afileords='D';                                                             //E DS ONLY
             fldn = adsname;
             from = '00001';
             ffmt =  'A';
             tonum = lencount;
             dpos = '  ';
             fldtxt = 'External DS ' + filenm;
             exsr  srDefineAdd;
 2e       endif;
 1e    endfor;
       endsr;
      /end-free
