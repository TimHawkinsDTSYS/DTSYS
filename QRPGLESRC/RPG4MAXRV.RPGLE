     H DFTACTGRP(*NO) ACTGRP(*CALLER) BNDDIR('QC2LE') EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('02/27/1996 Craig Rutledge <craigru@alltel.net>')
      *----------------------------------------------------------------
      * RPG4MAXRV  -  Validity checking program
      * This program is free software, you can redistribute it and/or modify it under the terms
      * of the GNU General Public License as published by the Free Software Foundation.
      * 09/10/2001 - converted from CL to use APIs
      *----------------------------------------------------------------
      * program summary:
      * execute api to retrieve member description.
      * if error returned by api,
      *    retrieve message with replacement values
      *    send message back to command.
      * verify output source member can be allocated for update
      *----------------------------------------------------------------
      * api (application program interfaces) used:
      * system    C function to execute ALCOBJ / DLCOBJ
      * qusrmbrd  get member description
      * qmhrtvm   retrieve messages
      * qmhsndpm  send messages
      *----------------------------------------------------------------
     D mMsgRtv         ds                  inz
     D mMsgRtvLen              9     12i 0                                      length msg retrieved
     D mMsgMessage            25    256                                         message retrieved
     D mMsgLen         s             10i 0 inz(%len(mMsgRtv))                   length of message
     D qm_msgid        s              7
     D qm_msgtxt       s            128
     D qm_msgtyp       s             10
     D alpha8          s              8
     D  xx             s             10i 0                                      return value
      *--------------------------------------------------------------------
      * create parm prototypes
     D qusrmbrd        PR                  ExtPgm('QUSRMBRD')                   RETRIEVE MBR DESC
     D                                8                                         RECEIVER
     D                               10i 0 const                                LENGTH OF RECVR
     D                                8    const                                UPLOAD TYPE
     D                               20    const                                FILE   LIB
     D                               10    const                                MEMBER NAME
     D                                1    const                                PROCESS OVERIDE
     Db                                    like(vApiErrDS)                      error parm
      *    -------------------------------------------------------------
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
      *    -------------------------------------------------------------
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
      *    -------------------------------------------------------------
     D system          PR            10I 0 extproc('system')
     D  i_cmd                          *   value options(*string)
      *    -------------------------------------------------------------
      * Error return code parm for APIs.
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                     128a                                        replacement data
      *    -------------------------------------------------------------
     D  main           PR                  extpgm('RPG4MAXRV ')                 entry plist
     D  i_smbr                       10A   const                                output source mbr
     D  i_sfil_slib                  20A   const                                output src file / lb
     D  i_style                      12A   const
      *    -------------------------------------------------------------
     D  main           PI
     D  i_smbr                       10A   const                                output source mbr
     D  i_sfil_slib                  20A   const                                output src file / lb
     D  i_style                      12A   const
      *-----------------------------------------------------------------
      * check data file, then source file existence.
      * check to see if object exists.
      /free
       callp  QUSRMBRD(
              alpha8:
              8:
              'MBRD0100':
              i_sfil_slib:
              i_smbr:
              '0':
              vapierrds);
 1b    if  vbytav>0;

          // call retrieve message API to pull in the subsitution variables
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
             eval  mMsgRtvLen = %size(mMsgMessage);
 2e       endif;
          eval  QM_msgtxt = '0000 ' + %trimr(vmsgid) +': ' +
          %subst(mMsgMessage:1:mMsgRtvLen);
          eval  QM_msgid = 'CPD0006';
          eval  QM_msgtyp = '*DIAG';
          exsr  srSndErrMsg;

          eval  qm_msgtxt  = *blanks;
          eval  qm_msgid   = 'CPF0002';
          eval  qm_msgtyp  = '*ESCAPE';
          exsr  srSndErrMsg;
          eval  *inlr=*on;
          return;
 1e    endif;

       // ---------------------------------------
       // see if source mbr can be allocated, if not send err msg
       eval  xx=system('ALCOBJ OBJ((' +
       %trimr(%subst(i_sfil_slib:11:10)) + '/' +
       %trimr(%subst(i_sfil_slib:1:10)) +
       ' *FILE *EXCLRD ' + %trimr(i_smbr)+ ')) WAIT(1)');
 1b    if  xx>0;
          eval  QM_msgtxt = '0000 Can not allocate member ' +
          %trimr(i_smbr) + ' in source file '+
          %trimr(%subst(i_sfil_slib:11:10)) + '/' +
          %trimr(%subst(i_sfil_slib:1:10)) + '.';
          eval  QM_msgid = 'CPD0006';
          eval  QM_msgtyp = '*DIAG';
          exsr  srSndErrMsg;
          eval  qm_msgtxt  = *blanks;
          eval  qm_msgid   = 'CPF0002';
          eval  qm_msgtyp  = '*ESCAPE';
          exsr  srSndErrMsg;
 1e    endif;
       eval  xx=system('DLCOBJ OBJ((' +
       %trimr(%subst(i_sfil_slib:11:10)) + '/' +
       %trimr(%subst(i_sfil_slib:1:10)) +
       ' *FILE *EXCLRD ' + %trimr(i_smbr) +'))');
       eval  *inlr=*on;
       return;

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
