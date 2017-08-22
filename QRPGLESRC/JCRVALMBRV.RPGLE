     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('2003 Craig Rutledge < www.jcrcmds.com > ')
      //---------------------------------------------------------------
      // JCRVALMBRV- Validity checking program
      //---------------------------------------------------------------
      // program summary:
      // execute api to retrieve member description.
      // if error returned by api,
      //   retrieve message with replacement values
      //   send message back to command.
      //---------------------------------------------------------------
      // api (application program interfaces) used:
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
      //---------------------------------------------------------------
      // create parm prototypes
      //---------------------------------------------------------------
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
      //
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
      // Error return code parm for APIs.
     D vApiErrDs       ds
     D  vbytpv                       10i 0 inz(%size(vApiErrDs))                bytes provided
     D  vbytav                       10i 0 inz(0)                               bytes returned
     D  vmsgid                        7a                                        error msgid
     D  vresvd                        1a                                        reserved
     D  vrpldta                     128a                                        replacement data
      //   -------------------------------------------------------------
     D  main           PR                  extpgm('JCRVALMBRV')
     D                               10A   const
     D                               20A   const
      //   -------------------------------------------------------------
     D  main           PI
     D  i_smbr                       10A   const
     D  i_sfil_slib                  20A   const
      //----------------------------------------------------------------
      /free
       // check to see if member exists.
       callp  QUSRMBRD(
              alpha8:              //RECEIVER
              8:                   //LENGTH OF RECVR
              'MBRD0100':          //FORMAT NAME
              i_sfil_slib:         // FILE   LIB
              i_smbr:              //MEMBER NAME
              '0':                 //PROCESS OVERIDE
              vapierrds);

 1b    if  vbytav>0;               //error occurred
          // call retrieve message API to pull in the subsitution variables
          callp  QMHRTVM(           //rtvmsgd
                 mMsgRtv :          //message retrieved
                 mMsgLen :          //length of message
                 'RTVM0100':        //requested format
                 vmsgid:            //msg identifier
                 'QCPFMSG   *LIBL': //qualified msg file
                 vrpldta:           //replacement data
                 %size(vrpldta):    //len of replace data
                 '*YES      ':      //substitution char
                 '*NO       ':      //format control char
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
 1e    endif;
       *inlr=*on;
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
