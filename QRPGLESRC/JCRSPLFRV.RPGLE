     H DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
     H DATFMT(*ISO)   TIMFMT(*ISO)    OPTION(*NODEBUGIO)
     H COPYRIGHT('06/20/1991 Craig Rutledge < www.jcrcmds.com > ')
      //---------------------------------------------------------------
      // JCRSPLFRV- Validity checking program
      // This program is free software, you can redistribute it and/or modify it under the terms
      // of the GNU General Public License as published by the Free Software Foundation.
      //---------------------------------------------------------------
      // program summary:
      // execute api to retrieve object description.
      // if error returned by api,
      //   retrieve message with replacement values
      //   send message back to command.
      //---------------------------------------------------------------
      // api (application program interfaces) used:
      // qusrobjd  get object description
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
     D qusrobjd        PR                  ExtPgm('QUSROBJD')                   object descriptions
     Db                               8
     D                               10i 0 const
     D                                8    const                                TYPE FORMAT
     D                               20    const                                OBJ  LIB
     D                               10    const                                OBJ TYPE
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
      //-------------------------------------------------------------------
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
     D main            PR                  extpgm('JCRSPLFRV')                  entry parms
     D                               20A   const
     D                               10A   const
     D                               10A   const
     D                               10A   const
      //   ----------------------------------------------------------
     D main            PI
     D  i_obj_olib                   20A   const
     D  i_usrid                      10A   const
     D  i_formtyp                    10A   const
     D  i_usrdta                     10A   const
      //
     D  i_otyp         s             10A   inz('*OUTQ  ')
      //-------------------------------------------------------------
      /free
 1b    if  not(%subst(i_obj_olib:1:10) = '*ALL  ' or
          %subst(i_obj_olib:1:10) = *blanks);

          // check to see if object exists.
          callp  QUSROBJD(
                 alpha8:
                 8:
                 'OBJD0100':
                 i_obj_olib:
                 i_otyp:
                 vapierrds);
 2b       if  vbytav>0;

             // call retrieve message API to pull in the subsitution var
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
 3b          if  mMsgRtvLen > %size(mMsgMessage);
                mMsgRtvLen = %size(mMsgMessage);
 3e          endif;
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
 2e       endif;
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
