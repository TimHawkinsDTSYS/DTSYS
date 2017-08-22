     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('2003 Craig Rutledge < www.jcrcmds.com > ')
      //----------------------------------------------------
      // XMLPREVIER - Preview XML upload before install.
      // This program is free software, you can redistribute it and/or modify it
      // under the terms of the GNU General Public License as published by
      // the Free Software Foundation.  See GNU General Public License for details
      //
      // This is a 'for your protection' program.  It is recommended you run
      // this program over any uploaded XMLGEN generated source before you commit to install.
      // This subfile program will list the
      // 1. source members about to installed.
      // 2. source files that may be created.
      // 3. any commands that will be executed during installation.
      //
      // It is your responsibility to verify these operations performed during the
      // install are not inimical to your environment.
      //
      // If you are satisfied with the upload, press F10 to auto install.
      //----------------------------------------------------
     Fxmlinput  if   f  112        disk
     Fxmlpreviedcf   e             workstn sfile(data1:rrn1) infds(dsinf)
     F                                                       indds(ind)
     D dsinf           ds
     D fkey                           1    overlay(dsinf:369)
     D  f03            c                   const(X'33')
     D  f10            c                   const(X'3A')
     D  f12            c                   const(X'3C')
      // Name screen indicators
     D ind             ds                  qualified
     D  sfldsp                         n   overlay(ind:1)
     D  sfldspctl                      n   overlay(ind:2)
     D  EnableInst                     n   overlay(ind:40)
      //
     D String          s            500    varying
     D aa              s              5u 0 inz(0)
     D ll              s              5u 0 inz(0)
     D rrn1            s              5u 0
     D SequenceNum     s              3p 0
      //----------------------------------------------------
     D xmlprevier      PR                                                       Input Parms
     D                               10A   const
     D                               10A   const
     D                               10A   const
     D                               10A   const
     D                                4A
      //   -------------------------------------------------------------
     D xmlprevier      PI                                                       Input Parms
     D  i_smbr                       10A   const
     D  i_sfil                       10A   const
     D  i_slib                       10A   const
     D  i_usrsfil                    10A   const
     D  i_action                      4A
      //-------------------------------------------------------------------
     Ixmlinput  ns
     I                                 13   21  xmltag1
     I                                 13   29  xmlinstallpgm
     I                                 18   27  xmltag2
     I                                 13  112  xmlcode
      //-------------------------------------------------------------------
      /free
       i_action='N';

       read  xmlinput;
 1b    dow  not %eof;

          // determine if install_program source is included in text
 2b       if
             xmlinstallpgm ='<install_program>';
             ind.EnableInst=*on;     //enable install

             // Extract values based on xml tags and load to subfile record(s)
 2x       elseif
             xmltag1 = 'mbrname =';
             SequenceNum=SequenceNum+1;
             xdata=%trimr(%editc(SequenceNum:'4'));
             %subst(xdata:5:3)='mbr';
             %subst(xdata:9:10) =
             %subst(xmlcode:13:10);

 2x       elseif
             xmltag1 = 'mbrtype =';
             %subst(xdata:20:10) =
             %subst(xmlcode:13:10);

 2x       elseif
             xmltag1 = 'mbrtext =';
             %subst(xdata:43) =
             %subst(xmlcode:13:50);

 2x       elseif
             xmltag1 = 'srcfile =';
 3b          if  i_usrsfil='*DEFAULTS ';
                %subst(xdata:31:10) = %subst(xmlcode:13:10);
 3x          else;
                %subst(xdata:31:10) = i_usrsfil;
 3e          endif;

 2x       elseif
             xmltag1 = 'srccssid=';
             rrn1=rrn1+1;
             write  data1;

             // ---------------------------------------------
             // qcmdexc statement. Build statement from record between start
             // and stop tags.  When stop tag, process into subfile records
             // ---------------------------------------------
 2x       elseif
             xmltag1 = '<qcmdexc>';
             clear   string;
             aa=1;
             read  xmlinput;
 3b          dow  xmltag2<>'</qcmdexc>';
                %len(string)=%len(string)+100;
                %subst(string:aa:100)=xmlcode;
                aa=aa+100;
                read  xmlinput;
 3e          enddo;
             exsr  srTolibToken;
             exsr  srParseCmd;
 2e       endif;

          read  xmlinput;
 1e    enddo;

       // ---------------------------------------------
       // Show subfile.  F3/F12 = Exit   F10=Run Install
       // ---------------------------------------------
       ind.sfldsp = (rrn1>0);
       ind.sfldspctl = *on;
 1b    dow  fkey<>f03;
          write  keys;
          exfmt  contrl1;

 2b       if
             fkey=f03 or fkey=f12;
 1v          leave;
 2x       elseif
             fkey=f10  and ind.EnableInst;
             i_action='Y';
 1v          leave;
 2e       endif;
 1e    enddo;
       *inlr=*on;
       return;

       // ---------------------------------------------
       // Replace &tolib (no matter how many times in string)
       // with whatever library  user has selected at run time.
       // Must replace create-from source files if user has selected override.
       // ---------------------------------------------
       begsr  srTolibToken;
       aa=%scan('&tolib':string);
 1b    dow  aa>0;
          string=%replace(%trimr(i_slib):string:
          aa:6);
          aa=%scan('&tolib':string);
 1e    enddo;

 1b    if  i_usrsfil<>'*DEFAULTS ';
          aa=%scan('SRCFILE(':string);
 2b       if  aa>0;
             aa=%scan('/':string:aa);
 3b          if  aa>0;
                ll=%scan(')':string:aa);
                string=%replace(%trimr(i_usrsfil):string:
                aa+1:ll-(aa+1));
 3e          endif;
 2e       endif;
 1e    endif;

       endsr;

       // ---------------------------------------------
       // write commands to subfile.
       // ---------------------------------------------
       begsr  srParseCmd;
       clear   xdata;
       rrn1=rrn1+1;
       write  data1;
       SequenceNum=SequenceNum+1;
       xdata=%trimr(%editc(SequenceNum:'4'));
       %subst(xdata:5:3)='cmd';

       aa=1;
       ll = %len(string);

       // see if one line command
 1b    if  ll - aa < 69;
          %subst(xdata:9) =
          %subst(string:aa:(ll - aa)+1);
          rrn1=rrn1+1;
          write  data1;

          // multiline command
 1x    else;
 2b       dou  aa>ll;
             %subst(xdata:9) =  %subst(string:aa);
             rrn1=rrn1+1;
             write  data1;
             clear   xdata;
             aa=aa+69;
 2e       enddo;
 1e    endif;
       clear   xdata;
       rrn1=rrn1+1;
       write  data1;
       endsr;
       /end-free
