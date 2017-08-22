      /TITLE Clear IFS file
      *
      * P: PARMS
      *
      * S:
      *
      * C: Scott Klement, April 8, 2004
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      /copy qcpysrc,Hspec
     H BNDDIR('QC2LE')

      *********************************************************
      *  Prototypes & constants for the UNIX-type APIs
      *********************************************************
     D open            PR            10I 0 extproc('open')
     D   path                          *   value options(*string)
     D   oflag                       10I 0 value
     D   mode                        10U 0 value options(*nopass)
     D   codepage                    10U 0 value options(*nopass)

     D close           PR            10I 0 extproc('close')
     D   fildes                      10I 0 value

     D O_WRONLY        C                   2
     D O_TRUNC         C                   64

      *********************************************************
      * Local definitions
      *********************************************************
     D ReportError     PR

     D CIF000R         PR                  ExtPgm('CIF000R')
     D   stream_file               5000A   varying
     D CIF000R         PI
     D   stream_file               5000A   varying

     D fd              s             10i 0 inz

     c                   eval      fd = open( stream_file
     c                                      : O_WRONLY + O_TRUNC )
     c                   if        fd < 0
     c                   callp     ReportError
     c                   endif

     c                   if        close(fd) < 0
     c                   callp     ReportError
     c                   endif

     c                   eval      *inlr = *on

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * ReportError():  Send an escape message explaining any errors
      *                 that occurred.
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P ReportError     B
     D ReportError     PI

     D sys_errno       PR              *   ExtProc('__errno')
     D p_errno         s               *
     D errno           s             10I 0 based(p_errno)

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                      1A   Const
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                 8192A   options(*varsize)

     D dsEC            DS
     D  BytesProv              1      4I 0 inz(0)
     D  BytesAvail             5      8I 0 inz(0)

     D MsgKey          S              4A
     D MsgNo           s              4P 0

     c                   eval      p_errno = sys_errno
     c                   eval      msgno = errno

     c                   callp     QMHSNDPM( 'CPE' + %editc(msgno:'X')
     c                                     : 'QCPFMSG   *LIBL'
     c                                     : ' ': 0: '*ESCAPE': '*': 3
     c                                     : MsgKey: dsEC)
     P ReportError     E
