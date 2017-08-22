      *===============================================================
      *  Source:   cmdchoice  - Select Administrator Choice Program
      *
      *  Desc:     This module is used as a generic "Choice Program" for
      *             commands.  The command parm should specify:
      *                CHOICE(*PGM) CHOICEPGM(CMDCHOICE)
      *
      *  Compile:  CRTSQLRPGI OBJ(library/CMDCHOICE)
      *                       SRCFILE(library/QRPGLESRC)
      *                       SRCMBR(CMDCHOICE)
      *                       OBJTYPE(*PGM)
      *
      *  Input parms:
      *            21-byte parm
      *             -  1 - 10 Command Name
      *             - 11 - 20 Keyword Name
      *             - 21 - 21 Keyword Name
      *  Output parms:
      *            2000-byte-parm
      *             -  Text (30)
      *            ** OR **
      *             -  1 -  2 Number of Values
      *             -  List of Values
      *                - 1 - 2 Length of Value
      *                - 3 - * Value
      *  Return value:
      *            None
      *
      *===============================================================
     h expropts(*resdecpos) option(*srcstmt:*nodebugio)
      *===============================================================
      *  Program Interface (replaces *ENTRY/PLIST)
      *===============================================================
     d cmdchoice       pr                  extpgm('CMDCHOICE')
     d  p_parm1                            likeds(parm1ds)
     d  p_parm2                    2000a
      *
     d cmdchoice       pi
     d  p_parm1                            likeds(parm1ds)
     d  p_parm2                    2000a
      *===============================================================
      *  Define Named Constants.
      *===============================================================
     d chcnotfound     c                   '** Choices NOT Found **'
      *===============================================================
      *  Miscellaneous Fields.
      *===============================================================
     d sqlstmt         s            200a   inz
     d strpos          s              5i 0 inz(3)
     d value           s             32a   inz varying
      *
     d choiceds        ds                  inz
     d  library                      10a
     d  file                         10a
     d  field                        10a
     d  text                         30a
      *
     d numericds       ds
     d  count                         4b 0 inz
     d  counta                        2a   overlay(count)
     d  length                        4b 0 inz
     d  lengtha                       2a   overlay(length)
      *
     d parm1ds         ds                  inz
     d  command                      10a
     d  keyword                      10a
     d  datatype                      1a
      *===============================================================
      *  Procedure Prototypes
      *===============================================================
      *
      *===============================================================
      /free
         //===========================================================
         //  Mainline
         //===========================================================

         // Initialization
                   parm1ds = p_parm1;
                   clear     p_parm2;

         // Retrieve Command Choice Keyword/Selection Record

       exec sql
          select cklib,
                 ckfile,
                 ckfield,
                 cktext
            into :choiceds
            from ccp000p
           where ckcommand = :command
             and ckkeyword = :keyword;

         // Process Based on Data Type
                   select;

         // Return Choice Text
                     when datatype = 'C';
                       if sqlstt = *zeros;
                         p_parm2 = %trim(text);
                       else;
                         p_parm2 = chcnotfound;
                       endif;

         // Return Choice List
                     when datatype = 'P';

         // Build SQL Statement
                       sqlstmt = 'select '
                               + %trim(field)
                               + ' from '
                               + %trim(library)
                               + '/'
                               + %trim(file);

         // Prepare SQL Statement, Declare Cursor, Open Cursor

       exec sql
        prepare choicestmt from :sqlstmt;

       exec sql
        declare choicecsr cursor for choicestmt;

       exec sql
        open choicecsr;

         // Load Return Field
                       reset strpos;

                       dou sqlstt <> *zeros;

       exec sql
        fetch next
         from choicecsr
         into :value;

         // If Record Found...
                         if sqlstt = *zeros;

         // Determine Length of Value
                           length = %len(%trim(value));
                           %subst(p_parm2:strpos:2) = lengtha;

         // Update Parm2 with Length of Value and Value
                           strpos += 2;
                           %subst(p_parm2:strpos:%len(value)) = %trim(value);

         // Increment Count (Number of Values Returned) and Parm2 Start Position
                           count  += 1;
                           strpos += length;
                         endif;

                       enddo;

         // Update Parm2 with Count (Number of Values Returned)
                       %subst(p_parm2:1:2) = counta;

         // Close Cursor

       exec sql
        close choicecsr;

                   endsl;

         // End Program
                   *inlr = *on;
                   return;


      /end-free
