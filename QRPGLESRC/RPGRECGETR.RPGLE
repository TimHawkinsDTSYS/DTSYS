     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('03/06/1998 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * rpgrecgetr - Get file info for files used in RPG source
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      * 04/25/2000 - allow for multiple-record format environment IGNORE / INCLUDE
      * 05/01/2000 - made this into called program for use by various commands.
      *              merged support for Prefix and External Data Structures to
      *              accomodate RPGFLDS command.
      * 01/14/2002 - /free format
      *----------------------------------------------------------------
      * program summary:
      * read rpg fspecs
      * call apis to extract record format names.
      * call api to extract based on physical file name
      *----------------------------------------------------------------
      * api (application program interfaces) used:
      * qdbrtvfd  retrieve data base relations
      * qusptrus  retrieve pointer to user space
      * quslrcd   list record formats
      * _TSTBTS   MI test bits function
      *----------------------------------------------------------------
     Fqrpgsc    ip   f  112        disk    extfile(i_extfile) extmbr(i_extmbr)
     F                                     infds(infds)
      *
      *----------------------------------------------------------------
      * define array and element of that array to process record formats
      *----------------------------------------------------------------
     D arrsort         s            100    dim(300) ascend                       SORTED NAMES& DTA
     D arryelemds      ds
     D   afilename             1     10
     D   aformatname          11     20
     D   arenamedfmt          21     30
     D   abasedonpf           31     40
     D   ausage               41     41
     D   adesc                42     70
     D   afileords            71     71
     D   aprefix              72     81
     D   aprefix_chr          82     82
     D   adsname              83     97
     D savprefix       s                   like(aprefix)
     D savprefix_      s                   like(aprefix_chr)
     D savkeyword4     s                   like(keyword4)
      *
      *----------------------------------------------------------------
      * Include logic is kinda tough..
      * an Include is really an explicit IGNORE.
      * 1. need to know if a file has an INCLUDE statement.
      * 2. need to know what record formats to include.
      * 3. need to figure out what formats to IGNORE.
      *
      * Will have to wait till ALL formats are loaded into previous
      * array then then spin back through and remove the ones for
      * files that have an include and are not included.
      * Ughh..
      * Build an array of all INCLUDE file/record formats
      *
      * 1.  an array of just file names to select files with includes
      * 2.  an array of file||recordformat names for look up to see they are in the include array.
      *----------------------------------------------------------------
     D ifilfmt         s             35    dim(300)
     D ifil            s             25    dim(300)
     D ff              s              5u 0                                      include indexes
     D fff             s              5u 0                                      include indexes
     D dummy           s              5u 0
      *
      *----------------------------------------------------------------
     D filetext        s             50
     D vbasedonpf      s             10
     D savedsname      s             15
     D firstrecfmt     s              1
     D typeflag        s              1
     D filelib         s             20
     D fmtfile         s             35
     D filedsname      s             25
     D a               s              5u 0
     D b               s                   like(a)
     D is              s                   like(a)                              ignore start
     D ie              s                   like(a)                              ignore end
     D c               s                   like(a)
     D vy              s                   like(a)
     D donumb          s                   like(a)                              SAVE RRN
     D vl              s                   like(a)
     D vi              s                   like(a)
     D vt              s                   like(a)                              CALC ARRAY OFF
     D bit_offset      s             10u 0 inz(2)
     D includeflg      s              1    inz(*off)
     D allignored      s              1    inz(*off)
     D allincluded     s              1    inz(*off)
     D fldprefix       s             10
     D                 ds
     D replacea                1      1                                         prefix replace
     D replacec                1      1s 0                                      replace prefix
     D renamedfmt      s             10
     D beingrenamed    s             10
     D beingignored    s             10
     D beingincluded   s             10
     D filnamsave      s             10
     D firsttime       s              1    inz(*on)
     D opt             s              1
     D vfillb          s             20
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
      *----------------------------------------------------------------
      * Get user space list info from header section.
      *----------------------------------------------------------------
     D                 ds                  based(uHeadPtr)
     D uOffSetToHeadr        117    120i 0                                      offset to list
     D uOffSetToList         125    128i 0                                      offset to list
     D uNumOfEntrys          133    136i 0                                      number list entries
     D uSizeOfEntry          137    140i 0                                      list entry size
     D uListPtr        s               *   inz(*null)                           next entry offset
     D uNextEntry      ds                  Based(uListPtr)
     D   uFormatName                 10
     D   uDesc                       29    overlay(uNextEntry:33)
      *
      *----------------------------------------------------------------
     D headerds        ds                  based(headerptr)
     D    vflnam                     10                                         file name
     D    vfllib                     10                                         actual library
     D    vfltyp                     10                                         file type
     D    vfltxt_rnm                 50                                         file text
      *----------------------------------------------------------------
      * Error return code parm for APIs.
      *----------------------------------------------------------------
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                      50a                                        replacement data
      *----------------------------------------------------------------
      * THIS WAS EXTRACTED FROM CMD(EXPDBRR) TO GET BASED ON PHYSICAL
      * this value is used as an offset to the file scope array section
      * fhflg  =  rd bit is used to determine if original file is
      *          physical or logical file.
      * fscope = offset
      *----------------------------------------------------------------
     D vrcvar          ds         18000
     D  lenreturnd             1      4b 0
     D  lenallowed             5      8b 0
     D  fhflg                  9      9
     D  fscope               317    320b 0
      *----------------------------------------------------------------
      * this ds is used to decode the file scope array. it will contain
      * the offsets for the select/omit and keys arrays.
      *
      * bfbf -  based on physical file
      * bfbfl-  based on physical file library
      * bgky -  number of keys
      * soon -  number of select/omit statements
      * soof -  offset to select/omit specification array
      * ksof -  offset to key specification array.
      *----------------------------------------------------------------
     D qdbfb           ds
     D    bfbf                49     58
     D    bfbfl               59     68
     D    bgky               116    117b 0
     D    soon               129    130b 0
     D    soof               131    134b 0
     D    ksof               135    138b 0
      *-----------------------------------------------------
     D infds           ds
     D  vsourcefil            83     92
     D  vsourcelib            93    102
     D  vsourcembr           129    138
     D uSpaceName      s             20    inz('JCRCMDS   QTEMP     ')
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
     D vrtnfl          s             20                                         returned file lib
     D qdbrtvfd        PR                  ExtPgm('QDBRTVFD')                   retrieve file desc
     D                            18000    options(*varsize)                    RECEIVER VARIAB
     D                               10i 0 const                                RECEIVERfLENGTH
     D                               20                                         RETRN FILE/LIB
     D                                8    const                                TYPE FORMAT
     D                               20                                         FILE LIB  20
     D                               10    const                                ALL FORMATS
     D                                1    const                                NO OVERRIDES
     D                               10    const                                WHICH SYSTEM
     D                               10    const                                FORMAT TYPE?
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
     D quslrcd         PR                  ExtPgm('QUSLRCD')                    create user space
     D                               20                                         Space Name
     D                                8    const                                format
     D                               20                                         file lib
     D                                1    const                                override
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
     D tstbts          PR            10I 0 extproc('_TSTBTS')                   MI TEST BITS
     D  i_bit_string                   *   value options(*string)
     D  i_bit_offset                 10u 0 value
      *    -------------------------------------------------------------
     D main            PR                  extpgm('RPGRECGETR')                 Input Parms
     D  i_extfile                    20A                                        open at runtime
     D  i_extmbr                     10A                                        open at runtime
     D  i_cmdswitch                  10A                                        which command
     D  i_mbrtyp                      4A                                        rpg3 or rpg4
     D  i_files                   30000A                                        returned file array
      *    -------------------------------------------------------------
     D main            PI
     D  i_extfile                    20A
     D  i_extmbr                     10A
     D  i_cmdswitch                  10A
     D  i_mbrtyp                      4A
     D  i_files                   30000A
      *----------------------------------------------------------------
      *
     Iqrpgsc    ns  lr   13 c*   14 c*   15 c
     I         or        13 c*   14 c*   15 cc                                  named array
     I         or        13 c*   14 c*   15 cC                                  named array
     I         or        18 cc   19nc*   19nc/
     I         or        18 cC   19nc*   19nc/
     I         or        18 co   19nc*   19nc/
     I         or        18 cO   19nc*   19nc/
      *
     I          ns  01   18 cF   19nc*   19nc/                                  F Specs
     I         or        18 cf   19nc*   19nc/
      *
     I         or   02   18 cd   19nc*   19nc/                                  D Specs for E DS
     I         or        18 cD   19nc*   19nc/
      *
      * rpg 4 locations
     I                                 19   28  filenm
     I                                 19   33  deffldn
     I                                 29   29  usage                           I U O
     I                                 34   34  eorf                            E or F
     I                                 36   37  defds                           Data structure defn
     I                                 48   55  device                          DISK, PRINTER, etc
     I                                 56   92  keyword4                        rename(a:b)
      * rpg 3 locations
     I                                 19   26  filenm3
     I                                 27   27  usage3                          I U O
     I                                 31   31  eorf3                           E or F
     I                                 52   58  device3                         DISK, PRINTER, etc
     I                                 31   40  beingrenamed3                   KRENAME
     I                                 65   71  keyword3                        KRENAME
     I                                 72   81  renamed3                        KRENAME
     I          ns  05
      *
      *----------------------------------------------------------------
      * route logic to appropriate subroutine depending on record type.
      * The RPGREC command doesn't care about Data Structures.
      *----------------------------------------------------------------
      /free
 1b    if  *in01;
          exsr  filespec;
 1e    endif;

 1b    if  *in02;          //D specs
 2b       if  i_cmdswitch = 'RPGREC   ';
             eval  *inlr=*on;
 2x       else;
             exsr  datadefn;
 2e       endif;
 1e    endif;

      /end-free
     Clr                 exsr      lrsub
      /free

       // ------------------------------------------------------------
       // load the fields from the f spec externally described fields.
       // ------------------------------------------------------------
       begsr  filespec;
       clear   renamedfmt;
       clear   savedsname;
 1b    if  i_mbrtyp = 'RPG4';
          eval  filenm=%xlate(lo:up:filenm);
          eval  eorf  =%xlate(lo:up:eorf);
          eval  device=%xlate(lo:up:device);
          eval  usage =%xlate(lo:up:usage);
 1x    else;
          eval  filenm = filenm3;
          eval  eorf = eorf3;
          eval  device = device3;
          eval  usage = usage3;
 1e    endif;
       // - - - - -
 1b    if  filenm <> *blanks  and
          eorf = 'E' and
          (device = 'DISK   ' or
          (i_cmdswitch<>'RPGREC  ' and
          (device = 'PRINTER  '  or
          device = 'WORKSTN ')));
          eval  filnamsave = filenm;
          eval  typeflag = 'F';
          exsr  fileload;                                                         //  LOAD FILES
 1e    endif;
       // - - - - -
 1b    if  i_mbrtyp = 'RPG4'  and                                                //check for renames
          keyword4>*blanks;
          eval  keyword4=%xlate(lo:up:keyword4);
          exsr  chkrename4;                                                       //test for rename
          exsr  chkignore4;                                                       //test for Ignore
          exsr  chkinclude4;                                                      //test for Include
 2b       if  i_cmdswitch <> 'RPGREC  ';
             exsr  chkprefix4;                                                     //test for Prefix
 2e       endif;
 1e    endif;
       // - - - - -
 1b    if  i_mbrtyp = 'RPG3';                                                    //check for renames
 2b       select;
 2x       when  keyword3='KRENAME';
             eval  beingrenamed = beingrenamed3;
             eval  renamedfmt = renamed3;
             exsr  loadrenamed;                                                  //apply rename
 2x       when  keyword3='KIGNORE';
             eval  beingignored = beingrenamed3;
             exsr  nukeignored;                                                  //remove Ignored
 2e       endsl;
 1e    endif;
       endsr;

       // -----------------------------------------------------------
       // Load externally described Data Structures file information
       // This gets  complex as  File name could either be  DS name
       // or an EXTNAME( defined either on the same line as the DS or
       // on one of the subsequent lines.
       // -----------------------------------------------------------
       begsr  datadefn;
       eval  eorf    =%xlate(lo:up:eorf);
       eval  defds   =%xlate(lo:up:defds);
       eval  deffldn =%xlate(lo:up:deffldn);
       eval  keyword4=%xlate(lo:up:keyword4);

       // -----------------------------------------------------------
       // First pass,  assume no EXTNAME( exists.   Go to file load
       // subroutine with the data structure name as the file.
       // -----------------------------------------------------------
 1b    if  eorf = 'E'  and                                                     //EXTERNAL DS
          defds = 'DS';                                                         //DATA STRUCTURE
          eval  savedsname  = %triml(deffldn);
          eval  filenm = savedsname;                                            //LOAD FILE NAME
          eval  filnamsave = savedsname;                                        //LOAD FILE NAME
          eval  firstrecfmt = *on;
          eval  typeflag = 'D';
          exsr  fileload;                                                       //  EXTRACT FIELDS
          eval  firstrecfmt = *off;
 1e    endif;

       // -----------------------------------------------------------
       // If there is a EXTNAME(,  then things get a little messy again.
       // It can have the format of extname(xxx) which means use the
       // first record format of this file or extname(xxxx:recfmt)
       // which means to use selected record format.
       // On top of this, we have already written an array element
       // when we tried using only DS name in previous section.
       // On top of this, we MAY have updated the array element
       // with the PREFIX so we gotta save it and reload it.
       // -----------------------------------------------------------
       eval  a = %scan('EXTNAME(':keyword4);
 1b    if  a > 0;
          eval  arryelemds = arrsort(vl);
          eval  savprefix = aprefix;
          eval  savprefix_ = aprefix_chr;
          clear   arrsort(vl);
          eval  vl = vl - 1;

          eval  c=%scan(':':keyword4:a);
          eval  b=%scan(')':keyword4:a);
 2b       if  c=0  or c>b;                                                    //use *first recordfmt
             eval  firstrecfmt = *on;
             eval  filenm = %subst(keyword4:a+8:(b-a)-8);                        //LOAD FILE NAME
             eval  filnamsave = filenm;                                          //LOAD FILE NAME
 2x       else;

             // -----------------------------------------------------------
             // extname(xxx:recfmt).  This is as messy as it gets.
             // If a record format is selected, that is an implicit
             // INCLUDE.  We are going to dummy up an INCLUDE
             // statement, so the file processor can
             // automatically only load this record format.
             // First, extract filename and record format name.
             // -----------------------------------------------------------
             eval  filenm = %subst(keyword4:a+8:(c-a)-8);
             eval  beingincluded= %subst(keyword4:c+1:(b-c)-1);                  //record format
             eval  savkeyword4 = keyword4;
             eval  keyword4 = 'INCLUDE('+ %trimr(beingincluded)+ ')';
             eval  filnamsave = filenm;
             exsr  chkinclude4;
             eval  keyword4=savkeyword4;
 2e       endif;
          exsr  fileload;
          clear   savprefix;
          clear   savprefix_;
          eval  firstrecfmt = *off;
 1e    endif;
       // - - - - -
 1b    if  keyword4>*blanks;
          eval  keyword4=%xlate(lo:up:keyword4);
          exsr  chkprefix4;    //test for Prefix
 1e    endif;
       endsr;

       // -------------------------------------------
       // load fields from either e DS or regular DS.
       // -------------------------------------------
       begsr  fileload;        //  LOAD EXTERNAL
       eval  filelib = filenm + '*LIBL ';

       // --------------------------------------------------
       // load the user space with information similar to
       // *basatr option on dspfd command.  Pointers are used
       // to load the data structures.
       // --------------------------------------------------
       callp  QUSLRCD(
              uSpaceName  :
              'RCDL0200'  :
              filelib     :
              '1'         :
              vApiErrDs);

 1b    if  vbytav = 0;         //found it!
          exsr  expdbrr;        //get based on files

          // -------------------------------------------------------
          // Process data from user space.
          // uNumOfEntrys contains the number of data blocks to get.
          // Move pointer to user space to 'retrieve' each entry.
          // Note: some processes only want the first record format.
          // so only do the 1 record format for those.
          // -------------------------------------------------------
 2b       if  firstrecfmt = *on;
             eval  uNumOfEntrys =1;
 2e       endif;

          eval  uListPtr  = uHeadPtr  + uOffSetToList;
 2b       for dummy = 1 to uNumOfEntrys;

             // Load array
             eval  vl=vl+1;
             eval  afilename = filenm;
             eval  aformatname =  uformatname;
             eval  arenamedfmt = *blanks;
             eval  abasedonpf = vbasedonpf;
             eval  ausage = usage;

 3b          if  udesc <> *blanks;
                eval  adesc = udesc;
 3x          else;
                eval  adesc = filetext;
 3e          endif;
             eval  afileords = typeflag;
             eval  adsname = savedsname;
             eval  aprefix = savprefix;
             eval  aprefix_chr = savprefix_;
             eval  arrsort(vl) = arryelemds;

             eval  uListPtr  = uListPtr  + uSizeOfEntry;
 2e       endfor;
          // ***ERROR OCCURRED************************
 1x    else;
          eval  vl=vl+1;
          clear   arryelemds;
          eval  afilename = filenm;
          eval  arenamedfmt = renamedfmt;
          eval  abasedonpf = '*NOT FOUND';
          eval  adesc = '*FILE NOT FOUND';
          eval  afileords = typeflag;
          eval  adsname = savedsname;
          eval  arrsort(vl) = arryelemds;
 1e    endif;
       endsr;

       // -------------------------------------------
       // extract the RENAME values from RPG4 code.
       // -------------------------------------------
       begsr  chkrename4;
       eval  b=%scan('RENAME(':keyword4);
 1b    if  b>0;
          eval  a = %scan(':':keyword4:b);
          eval  beingrenamed = %subst(keyword4:b+7:a-(b+7));
          eval  b = %scan(')':keyword4:a);
          eval  renamedfmt = %subst(keyword4:a+1:(b-a)-1);
          exsr  loadrenamed;
 1e    endif;
       endsr;

       // -----------------------------------------------------------
       // Check if record formats should be IGNORED from this file.
       // Note:multiple formats could be in one statement separated by :  .
       // The element in the save file will be cleared for this record format.
       // -----------------------------------------------------------
       begsr  chkignore4;
       eval  b=%scan('IGNORE(':keyword4);
 1b    if  b>0;
          eval  a = %scan(':':keyword4);
          // -----------------------------------------------
          // If A = 0 then this a single IGNORE(xxx),
          // not a IGNORE(xxx:yyy:zzz)
          // -----------------------------------------------
 2b       if  a = 0;
             eval  a = %scan(')':keyword4);
             eval  beingignored = %subst(keyword4:b+7:a-(b+7));
             exsr  nukeignored;                                                  //remove Ignored
 2x       else;
             // -----------------------------------------------------------
             // Multiple record format on a single ignore.
             // -----------------------------------------------------------
             eval  allignored=*off;
             eval  is=b+7;                                                       //start of recfmt
 3b          dou  allignored=*on;                                                //all processed
                eval  ie = %scan(':':keyword4:is);                                //end of recfmt
 4b             if  ie=0;
                   eval  ie = %scan(')':keyword4:is);                              //) end of recfmt
                   eval  allignored = *on;
 4e             endif;
                eval  beingignored= %subst(keyword4:is:(ie-is));
                exsr  nukeignored;                                                //remove Ignored
                eval  is=ie+1;                                                    //next start
 3e          enddo;

 2e       endif;
 1e    endif;
       endsr;

       // -----------------------------------------------------------
       // Several commands are concerned with file  Prefix statements.
       // This subroutine extracts the Prefix value and any
       // number-char-to-replace values.
       // -----------------------------------------------------------
       begsr  chkprefix4;
       eval  a=%scan('PREFIX(':keyword4);
 1b    if  a>0;
          eval  c=%scan(':':keyword4:a);
          eval  b=%scan(')':keyword4:a);
 2b       if  c=0 or c>b;  //: not found   OR 0 (other:func)
             eval  fldprefix = %subst(keyword4:a+7:(b-a)-7);
             clear   replacec;
 2x       else;
             eval  fldprefix = %subst(keyword4:a+7:(c-a)-7);
             eval  replacea = %subst(keyword4:c+1:1);
 3b          if  replacea=' ';
                eval  replacec=0;
 3e          endif;
 3b          if  replacec<%len(%trimr(fldprefix));
                eval  replacec=%len(%trimr(fldprefix));
 3e          endif;
 2e       endif;

          // ------------------------------------------------
          // If  match is found, load PREFIX data.
          // ------------------------------------------------
 2b       for a = 1 to vl;
             eval  arryelemds = arrsort(a);
 3b          if  afilename = filnamsave and
                adsname   = savedsname;
                eval  aprefix = fldprefix;
                eval  aprefix_chr = replacea;
                eval  arrsort(a) = arryelemds;
 3e          endif;
 2e       endfor;
 1e    endif;
       endsr;

       // -----------------------------------------------------------
       // remove IGNORE record formats from array.
       // If a match is found on an Ignored record format,
       // clear the array element.
       // -----------------------------------------------------------
       begsr  nukeignored;
 1b    for a = 1 to vl;
          eval  arryelemds = arrsort(a);
 2b       if  aformatname = beingignored  and
             afilename = filnamsave;
             clear   arrsort(a);
 1v          leave;
 2e       endif;
 1e    endfor;
       endsr;

       // -----------------------------------------------------------
       // Check to see what record formats are INCLUDED for this file.
       // Note:multiple formats could be in one statement separated by :  .
       // -----------------------------------------------------------
       begsr  chkinclude4;
       eval  b=%scan('INCLUDE(':keyword4);
 1b    if  b>0;
          eval  a = %scan(':':keyword4:b);
          // -----------------------------------------------
          // If A = 0 then this a single Include(xxx)
          // -----------------------------------------------
 2b       if  a = 0;
             eval  a = %scan(')':keyword4);
             eval  beingincluded = %subst(keyword4:b+8:a-(b+8));
             exsr  saveincluded;                                                 // save file/fmt
 2x       else;
             // -----------------------------------------------
             // Multiple record formats on a single Include.
             // Include(xxx:yyy:zzz)
             // -----------------------------------------------
             eval  allincluded=*off;
             eval  is=b+8;                                                       //start of recfmt
 3b          dou  allincluded=*on;
                eval  ie = %scan(':':keyword4:is);                                //end of recfmt
 4b             if  ie=0;
                   eval  ie = %scan(')':keyword4:is);                              //) end of recfmt
                   eval  allincluded = *on;
 4e             endif;
                eval  beingincluded= %subst(keyword4:is:(ie-is));
                exsr  saveincluded;                                               // save file/fmt
                eval  is=ie+1;
 3e          enddo;

 2e       endif;
 1e    endif;
       endsr;

       // -----------------------------------------------------------
       // This is kinda hard to follow.  The idea is, after all
       // records  have been processed, spin through iFil array to
       // get all the files that have includes.  Then if file
       // does have an include,  lookup from the ArrSort
       // into the iFilFmt array.
       // if the entry is not found,  then remove the arrsort entry.
       // Here we are only loading the file and file format arrays.
       // -----------------------------------------------------------
       begsr  saveincluded;
       eval  filedsname = filnamsave + savedsname;
 1b    if  %lookup(filedsname:ifil:a)=0;
          eval  ff=ff+1;
          eval  ifil(ff)  = filnamsave + savedsname;
 1e    endif;
       eval  fff=fff+1;
       eval  ifilfmt(fff)=beingincluded+filnamsave+savedsname;
       endsr;

       // -----------------------------------------------------------
       // Load RENAME  record formats into ARRAY.
       // Spin back though array looking for match with original
       // recfmt name.  When found, update array with renamed fmt name.
       // -----------------------------------------------------------
       begsr  loadrenamed;
 1b    for a = 1 to vl;
          eval  arryelemds = arrsort(a);
 2b       if  aformatname = beingrenamed  and
             afilename = filnamsave;
             eval  arenamedfmt = renamedfmt;
             eval  arrsort(a) = arryelemds;
 1v          leave;
 2e       endif;
 1e    endfor;
       endsr;

       // ----------------------------------------------------------------
       // if the selected file is a logical,  the based-on-physical name
       // is extracted and processing continues as if a physical had
       // been selected.
       // -----------------------
       begsr  expdbrr;
       clear   vbasedonpf;
 1b    if  device = 'DISK ';
          eval  vfillb = filenm + '*LIBL  ';

          callp  QDBRTVFD(
                 vrcvar      :
                 %size(vrcvar):
                 vrtnfl      :
                 'FILD0100'  :
                 vfillb      :
                 '*ALL      ':
                 '0'         :
                 '*LCL      ':
                 '*EXT      ':
                 vApiErrDs);

 2b       if  vbytav > 0;             //ERROR OCCURRED
             eval  vbasedonpf = 'NOT FOUND ';
 2x       else;
             eval  vt=fscope+1;
             eval  qdbfb = %subst(vrcvar:vt:140);
 3b          if  tstbts(fhflg:bit_offset)=1;
                eval  vbasedonpf = bfbf;
 3e          endif;
             eval  headerptr = uHeadPtr +  uOffSetToHeadr;
             eval  filetext= vfltxt_rnm;
 2e       endif;
 1e    endif;
 1b    if  device<>'DISK ';
          eval  filetext = device;
 1e    endif;
       endsr;

       // --------------------------------------
       // load the output parm from the array.
       // --------------------------------------
       begsr  lrsub;
       eval  c=1;

       sorta  arrsort;
       eval  donumb = %elem(arrsort);
       eval  vi=donumb-vl+1;

 1b    for a = vi to donumb;

 2b       if  arrsort(a) <> *blanks;
             eval  arryelemds = arrsort(a);
             // -------------------------------------------------------
             // This nasty little section is used to filter rcdfmts
             // that are not INCLUDED.  Use file name to look up array
             // of file names that had an include. If file name is
             // found,  use file record format name to lookup
             // file/included recfmt array.  If NOT found, EXCLUDE.
             // -------------------------------------------------------
             eval  includeflg=*on;
             eval  filedsname = afilename + adsname;
 3b          if  %lookup(filedsname:ifil)>0;
                eval  fmtfile = aformatname + afilename + adsname;
 4b             if  %lookup(fmtfile:ifilfmt)=0;
                   eval  includeflg=*off;
 4e             endif;
 3e          endif;

 3b          if  includeflg=*on;
                eval  %subst(i_files:c:100)=arryelemds;                           //load out parm
                eval  c=c+100;
 3e          endif;
 2e       endif;
 1e    endfor;
       endsr;

       // -------------------------------------
       // create the user space for the apis.
       // -------------------------------------
       begsr  *inzsr;
       clear   i_files;
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
       endsr;
      /end-free
