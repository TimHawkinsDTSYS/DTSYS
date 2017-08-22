     H DFTACTGRP(*NO) ACTGRP(*CALLER) BNDDIR('QC2LE') EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('06/01/2001 Craig Rutledge < www.jcrcmds.com > ')
      //---------------------------------------------------------------
      // JCR5FREEV  -  Validity checking program
      // This program is free software, you can redistribute it and/or modify it under the terms
      // of the GNU General Public License as published by the Free Software Foundation.
      //---------------------------------------------------------------
      // program summary:
      // execute api to retrieve member description.
      // if error returned by api,
      //   retrieve message with replacement values
      //   send message back to command.
      // verify output source member can be created/or cleared.
      //---------------------------------------------------------------
      // api (application program interfaces) used:
      // system    C function to execute ADDPFM / CLRPFM
      // qusrmbrd  get member description
      // qmhrtvm   retrieve messages
      // qmhsndpm  send messages
      //---------------------------------------------------------------
     D mMsgRtv         ds                  inz
     D mMsgRtvLen              9     12i 0                                      length msg retrieved
     D mMsgMessage            25    256                                         message retrieved
     D mMsgLen         s             10i 0 inz(%len(mMsgRtv))                   length of message
     D qm_msgid        s              7
     D qm_msgtxt       s            128
     D qm_msgtyp       s             10
     D alpha8          s              8
     D  wrkmbr         s             10A                                        work member
     D  wrkfil_lib     s             20A                                        work file / lib
     D  xx             s             10i 0                                      return value
      //---------------------------------------------------------------
      // create parm prototypes
     D qusrmbrd        PR                  ExtPgm('QUSRMBRD')                   RETRIEVE MBR DESC
     D                                8                                         RECEIVER
     D                               10i 0 const                                LENGTH OF RECVR
     D                                8    const                                UPLOAD TYPE
     D                               20    const                                FILE   LIB
     D                               10    const                                MEMBER NAME
     D                                1    const                                PROCESS OVERIDE
     Db                                    like(vApiErrDS)                      error parm
      //   -------------------------------------------------------------
     D qmhrtvm         PR                  ExtPgm('QMHRTVM')                    RETRIEVE MESSAGE
     D                              256                                         message retrieved
     D                               10i 0                                      length of message
     D                                8    const                                requested format
     D                                7                                         msg identifier
     D                               20    const                                qualified msgf name
     D                              128                                         replacement data
     D                               10i 0 const                                len of replace data
     D                               10    const                                substitution char
     D                               10    const                                format control char
     Db                                    like(vApiErrDs)
      //   -------------------------------------------------------------
     D qmhsndpm        PR                  ExtPgm('QMHSNDPM')                   SEND MESSAGES
     D                                7                                         ID
     D                               20    const                                FILE
     Db                                    like(qm_msgtxt)                      TEXT
     D                               10i 0 const                                LENGTH
     D                               10    const                                TYPE
     D                               10    const                                QUEUE
     D                               10i 0 const                                STACK ENTRY
     D                                4    const                                KEY
     Db                                    like(vApiErrDS)
      //   -------------------------------------------------------------
     D system          PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)
      //   -------------------------------------------------------------
      // Error return code parm for APIs.
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                     128a                                        replacement data
      //   -------------------------------------------------------------
     D  JCR5Freev      PR                                                       entry plist
     D                               10A   const                                input RPG src mbr
     D                               20A   const                                RPG source file/lib
     D                               10A   const                                output source mbr
     D                               20A   const                                output src file / lb
      //   -------------------------------------------------------------
     D  JCR5Freev      PI
     D  i_rmbr                       10A   const
     D  i_rfil_rlib                  20A   const
     D  i_smbr                       10A   const
     D  i_sfil_slib                  20A   const
      //---------------------------------------------------------------
      /free
       // check data file, then source file existence.
       wrkfil_lib = i_rfil_rlib;                                                //validate data file
       wrkmbr=i_rmbr;
       exsr  srValidate;
       wrkfil_lib = i_sfil_slib;                                              //validate source file
       wrkmbr='*FIRST ';
       exsr  srValidate;

       // ------------------------------------
       // see if source member can be added,
       // if not see if it can be cleared.
       xx=system('ADDPFM FILE(' +
       %trimr(%subst(i_sfil_slib:11:10)) + '/' +
       %trimr(%subst(i_sfil_slib:1:10)) +
       ') MBR(' + %trimr(i_smbr) + ')');
 1b    if  xx>0;
          xx=system('CLRPFM FILE(' +
          %trimr(%subst(i_sfil_slib:11:10)) + '/' +
          %trimr(%subst(i_sfil_slib:1:10)) +
          ') MBR(' + %trimr(i_smbr) + ')');
 2b       if  xx>0;
             QM_msgtxt = '0000 Source member ' +
             %trimr(i_smbr) + ' cannot be added/used.';
             QM_msgid = 'CPD0006';
             QM_msgtyp = '*DIAG';
             exsr  srSndErrMsg;
             qm_msgtxt  = *blanks;
             qm_msgid   = 'CPF0002';
             qm_msgtyp  = '*ESCAPE';
             exsr  srSndErrMsg;
 2e       endif;
 1e    endif;
       *inlr=*on;
       return;

       // ---------------------------------------------------
       // check to see if object exists.
       begsr  srValidate;
       callp  QUSRMBRD(
              alpha8:
              8:
              'MBRD0100':
              wrkfil_lib:
              wrkmbr:
              '0':
              vapierrds);
 1b    if  vbytav>0;

          // call retrieve message API to pull in subsitution var
          callp  QMHRTVM(
                 mMsgRtv :
                 mMsgLen :
                 'RTVM0100':
                 vmsgid:
                 'QCPFMSG   *LIBL':
                 vrpldta:
                 %size(vrpldta):
                 '*YES      ':
                 '*NO       ':
                 vApiErrDs);

          // set values to send messages, make message size not too big
 2b       if  mMsgRtvLen > %size(mMsgMessage);
             mMsgRtvLen = %size(mMsgMessage);
 2e       endif;
          QM_msgtxt =
          '0000 ' + %trimr(vmsgid) +': ' +
          %subst(mMsgMessage:1:mMsgRtvLen);
          QM_msgid = 'CPD0006';
          QM_msgtyp = '*DIAG';
          exsr  srSndErrMsg;

          qm_msgtxt  = *blanks;
          qm_msgid   = 'CPF0002';
          qm_msgtyp  = '*ESCAPE';
          exsr  srSndErrMsg;
          *inlr=*on;
          return;
 1e    endif;
       endsr;

       // call send program message api
       begsr  srSndErrMsg;
       callp  qmHSNDPM(
              qm_msgid:
              'QCPFMSG   *LIBL     ':
              qm_msgtxt:
              %size(qm_msgtxt):
              qm_msgtyp:
              '*CTLBDY':
              1:
              '    ':
              vApiErrDS);
       endsr;
      /end-free
