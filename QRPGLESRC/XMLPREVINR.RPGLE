     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('2003 Craig Rutledge < www.jcrcmds.com > ')
      //-------------------------------------------------------------------
      // XMLPREVINR -  Extract embedded installer code from text.
      // This program is free software, you can redistribute it and/or modify it
      // under the terms of the GNU General Public License as published by
      // the Free Software Foundation.  See GNU General Public License for details
      //-------------------------------------------------------------------
     Fxmlinput  ip   f  112        disk                                         uploaded text
     Fxmlextracto    f  112        disk                                         parsed out
      //-------------------------------------------------------------------
     D srcSeqno        s              6s 2 inz(0)
     D IsWrite         s               n   inz(*off)
      //-------------------------------------------------------------------
     Ixmlinput  ns
     I                                 13   29  xmltag1
     I                                 18   35  xmltag2
     I                                 13  112  xmlcode
      //-------------------------------------------------------------------
      /free
       // write records to temp installer source if flag is on

 1b    if IsWrite;
 2b       if  xmltag2='</install_program>';
             *inlr=*on;
             return;
 2e       endif;

          srcSeqno=srcSeqno+.01;
          except  write_one;

          // -------------------------------------------------------------
          // Start of data to copy.  Create source files/mbrs as required.
          // -------------------------------------------------------------
 1x    elseif
          xmltag1='<install_program>';
          IsWrite = *on;
 1e    endif;
      /end-free
     Oxmlextracte            write_one
     O                       srcSeqno             6
     O                                           12 '000000'
     O                       xmlcode            112
