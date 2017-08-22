      */TITLE Replace Page X of Y
      *CMDBFR dltpgm    qrplobj/%OBJNAM
      *CMDBFR movobj    %OBJLIB/%OBJNAM *pgm qrplobj
      *PARMS  USRPRF(*owner)
      *CMDAFT chgobjown %OBJLIB/%OBJNAM *pgm SISallobj
      *CMDAFT chgpgm    %OBJLIB/%OBJNAM useadpaut(*YES) usrprf(*owner)
      *
      * S:
      *
      * C: Scott Klement  12/18/03
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
     H DFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('QC2LE')
     H USRPRF(*OWNER)
      **
      ** Create spooled file API
      **
     D QSPCRTSP        PR                  ExtPgm('QSPCRTSP')
     D   Handle                      10I 0
     D   Attributes               32766A   options(*varsize)
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Open spooled file API
      **
     D QSPOPNSP        PR                  ExtPgm('QSPOPNSP')
     D   Handle                      10I 0
     D   Job                         26A   const
     D   IntJob                      16A   const
     D   IntSpl                      16A   const
     D   SpoolName                   10A   const
     D   SpoolNbr                    10I 0 const
     D   NbrBuf                      10I 0 const
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Get spooled file data API
      **
     D QSPGETSP        PR                  ExtPgm('QSPGETSP')
     D   Handle                      10I 0 const
     D   Space                       20A   const
     D   Format                       8A   const
     D   BufNo                       10I 0 const
     D   WaitFor                     10A   const
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Put spooled file data API
      **
     D QSPPUTSP        PR                  ExtPgm('QSPPUTSP')
     D   Handle                      10I 0 const
     D   Space                       20A   const
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Close spooled file API
      **
     D QSPCLOSP        PR                  ExtPgm('QSPCLOSP')
     D   handle                      10I 0 const
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Create user space API
      **
     D QUSCRTUS        PR                  ExtPgm('QUSCRTUS')
     D   peUsrSpc                    20A   CONST
     D   peExtAtr                    10A   CONST
     D   peInitSiz                   10I 0 CONST
     D   peInitVal                    1A   CONST
     D   pePubAuth                   10A   CONST
     D   peText                      50A   CONST
     D   peReplace                   10A   CONST
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Retrieve pointer to user space API
      **
     D QUSPTRUS        PR                  ExtPgm('QUSPTRUS')
     D   peUsrSpc                    20A   CONST
     D   pePointer                     *

      **
      ** Delete user space API
      **
     D QUSDLTUS        PR                  ExtPgm('QUSDLTUS')
     D   peUsrSpc                    20A   CONST
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Retrieve spooled file attributes API
      **
     D QUSRSPLA        PR                  ExtPgm('QUSRSPLA')
     D   RcvVar                   32766A   options(*VARSIZE)
     D   RcvVarLen                   10I 0 const
     D   Format                       8A   const
     D   QualJob                     26A   const
     D   IntJob                      16A   const
     D   IntSpool                    16A   const
     D   SplfName                    10A   const
     D   SplfNbr                     10I 0 const
     D   ErrorCode                32766A   options(*varsize)

      **
      ** Re-send program message API
      **
     D QMHRSNEM        PR                  ExtPgm('QMHRSNEM')
     D   MsgKey                       4A   const
     D   ErrorCode                32766A   options(*varsize)
     D   ToStkEntry               32766A   options(*varsize: *nopass)
     d   ToStkEntryLn                10I 0 const options(*nopass)
     D   Format                       8A   const options(*nopass)
     D   FromEntry                     *   const options(*nopass)
     D   FromCounter                 10I 0 const options(*nopass)

      **
      ** Structure for QMHRSNEM API in RSNM0100 format
      **
     D dsRS            ds
     d   dsRS_StkCnt                 10I 0 inz(2)
     D   dsRS_StkQual                20A   inz('*NONE     *NONE')
     D   dsRS_IDLen                  10I 0 inz(7)
     D   dsRS_StkID                   7A   inz('*')

      **
      ** Structure for QUSRSPLA API...   contains the
      **   retrieved spooled file attributes.
      **   (I'm lazy and only specify the fields that I use)
      **
     D dsSA            DS          3841
     D  dsSA_SplNbr           85     88I 0
     D  dsSA_TotPages        149    152I 0
     D  dsSA_BufSiz          861    864I 0
     D  dsSA_NbrBuf          997   1000I 0

      **
      **  Structure for QSPGETSP API...  contains the
      **   general spooled file header info...
      **
     D p_UsrSpc        s               *   inz(*NULL)
     D dsGSH           DS                  based(p_UsrSpc)
     D  dsGSH_UsrAra                 64A
     D  dsGSH_HdrSize                10I 0
     D  dsGSH_StrLvl                  4A
     D  dsGSH_SplfLvl                 6A
     D  dsGSH_Format                  8A
     D  dsGSH_CompInd                 1A
     D  dsGSH_Reserv1                 1A
     D  dsGSH_SpcUsed                10I 0
     D  dsGSH_OffBuf1                10I 0
     D  dsGSH_ReqBufs                10I 0
     D  dsGSH_RtnBufs                10I 0
     D  dsGSH_PDSize                 10I 0
     D  dsGSH_NPages                 10I 0
     D  dsGSH_NFPage                 10I 0
     D  dsGSH_OFPage                 10I 0
     D  dsGSH_Reserv2                 8A

      **
      ** Generic API error structure:
      **   when dsECBytesP = 0, the API will send it's error
      **   as an escape message.
      **
     D dsEC            DS
     D  dsECBytesP                   10I 0 INZ(0)
     D  dsECBytesA                   10I 0 INZ(0)

      **
      ** convert alphanumeric to integer
      **
     D atoi            PR            10I 0 extproc('atoi')
     D  alpha                          *   value options(*string)

      **
      **  Program Status Data Structure...
      **
     D psds           SDS
     D   dsPgmName           334    343A

      **
      **  Prototypes for local procedures
      **
     D ReplaceString   PR            10I 0
     D    peBuf                        *   value
     D    peSize                     10I 0 value
     d    peString                   32A   value varying
     D    peToString                 32A   value varying

     D usage           PR

     D DltSplf         PR            10I 0
     D    peJob                      26A   const
     D    peSplf                     10A   const
     D    peSplNbr                   10I 0 value

      **
      ** Local variables & constants
      **
     D USRSPC          C                   'PAGESSPC  QTEMP'
     D p_Data          s               *
     D wkFile          s             10I 0
     D wkSpcSize       s             10I 0
     D wkDataSize      s             10I 0
     D wkNewFile       s             10I 0
     D wkRepWith       s              4A
     D wkSplfNbr       s             10I 0
     D peSplfNbr       s             10I 0

     c                   eval      *inlr = *on

      ********************************************************************
      * Parameters:
      *     peSplf = name of spooled file
      *  peReplace = text to replace with total page information
      *      peJob = Job ID.  Can contain the special value '*' for
      *                'current job', otherwise it has 3 parts:
      *                   1-10 = job name
      *                  11-20 = user name
      *                  21-26 = job number
      *  peSplfNbr = number of spooled file
      ********************************************************************
     c     *entry        plist
     c                   parm                    peSplf           10
     c                   parm                    peReplace         4
     c                   parm                    peJob            26
     c                   parm                    peSplfNbr

     c                   if        %parms <> 4
     c                   callp     usage
     c                   return
     c                   endif

     c**                 if        peSplfNbr = '*LAST'
     c**                 eval      wkSplfNbr = -1
     c**                 else
     c**                 eval      wkSplfNbr = atoi(peSplfNbr)
     c**                 endif

     c                   eval      wkSplfNbr = peSplfNbr

     c                   if        wkSplfNbr <> -1 and
     c                             (wkSplfNbr<1 or wkSplfNbr>9999)
     c                   callp     usage
     c                   return
     c                   endif

      ********************************************************************
      * get spooled file attributes:
      *       we need information about the buffer size & total pages
      ********************************************************************
     c                   callp(e)  QUSRSPLA(dsSA: %size(dsSA):
     c                              'SPLA0200': peJob: *blanks: *blanks:
     c                               peSplf: wkSplfNbr: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

      ********************************************************************
      ** Load the spooled file into a user space.
      ********************************************************************
     c                   callp(e)  QSPOPNSP(wkFile: peJob: *blanks: *blanks:
     c                                peSplf: wkSplfNbr: -1: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   eval      wkSpcSize = (dsSA_BufSiz * dsSA_NbrBuf)
     c                                   + %size(dsGSH) + 500
     c                   callp(e)  QUSCRTUS(USRSPC: 'PAGESR4':
     c                               wkSpcSize: x'00': '*ALL': *blanks:
     c                               '*YES': dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   callp(e)  QSPGETSP(wkFile: USRSPC: 'SPFR0200':
     c                                -1: '*WAIT': dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   callp(e)  QSPCLOSP(wkFile: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

      ********************************************************************
      ** Scan through the user space, and replace the requested string
      **  with the total number of pages
      ********************************************************************
     c                   callp(e)  QUSPTRUS(USRSPC: p_UsrSpc)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   eval      p_Data = p_UsrSpc + dsGSH_OffBuf1
     c                   eval      wkDataSize= dsGSH_SpcUsed - dsGSH_OffBuf1

     c                   eval      wkRepWith=%trim(%editc(dsSA_TotPages:'Z'))

     c                   callp     ReplaceString(p_Data: wkDataSize:
     c                                     peReplace: wkRepWith)

      ********************************************************************
      ** Create a new spooled file to copy our changed data into.
      **   Note: QSPCRTSP has it's authority restricted by default!
      ********************************************************************
     c                   callp(e)  QSPCRTSP(wkFile: dsSA: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   callp(e)  QSPPUTSP(wkFile: USRSPC: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   callp(e)  QSPCLOSP(wkFile: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

      ********************************************************************
      ** Get rid of the user space
      ********************************************************************
     c                   callp(e)  QUSDLTUS(USRSPC: dsEC)
     c                   if        %error
     c                   callp     QMHRSNEM(*blanks: dsEC: dsRS: %size(dsRS):
     c                                   'RSNM0100': *NULL: 0)
     c                   endif

     c                   callp     DltSplf(peJob: peSplf: dsSA_SplNbr)

     c                   return


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  Display a synopsis of this program's parameters
      *   This is sent back to the caller as an escape message.
      *   THIS ROUTINE DOES NOT RETURN TO THE MAINLINE UNLESS IT FAILS!
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P usage           B
     D usage           PI

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                    256A   Const
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                    1A

     D dsEC            DS
     D  dsECBytesP             1      4I 0 inz(0)
     D  dsECBytesA             5      8I 0 inz(0)

     D wwTheKey        S              4A

     c                   callp     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
     c                               'Usage: CALL ' + %trimr(dsPgmName) +
     c                               ' PARM(SPLF TEXT JOBID SPLNBR)': 256:
     c                               '*ESCAPE': '*': 3: wwTheKey: dsEC)
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  Search a buffer for a string & replace with another string
      *
      *     Note: We can't use the RPG %scan & %replace BIFs because
      *           there's no way to specify a pointer & size to search,
      *           they work strictly on RPG variables.
      *
      *       peBuf = buffer to search
      *      peSize = size of buffer to search
      *    peString = string to search buffer for
      *  peToString = string to insert when peString is found.
      *
      *  Returns the number of times the string was replaced
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P ReplaceString   b
     D ReplaceString   PI            10I 0
     D    peBuf                        *   value
     D    peSize                     10I 0 value
     d    peString                   32A   value varying
     D    peToString                 32A   value varying

     D memchr          PR              *   extproc('memchr')
     D   buf                           *   value
     D   chartofind                  10I 0 value
     D   bufsize                     10I 0 value

     D memcmp          PR            10I 0 extproc('memcmp')
     D   buf1                          *   value
     D   buf2                          *   value
     D   size                        10I 0 value

     D memcpy          PR              *   extproc('memcpy')
     D   dest                          *   value
     D   src                           *   value
     D   size                        10I 0 value

     D dsCh            DS
     D   dsCh1                        1A
     D   dsCh2                        3U 0 overlay(dsCh1)

     D p_found         s               *
     D wwAdvance       s             10I 0
     D wwReps          s             10I 0

     c                   eval      wwReps = 0
     c                   eval      dsCh1 = %subst(peString:1:1)

     c                   dow       1 = 1

     c                   eval      p_found = memchr(peBuf: dsCh2: peSize)
     c                   if        p_found = *NULL
     c                   leave
     c                   endif

     c                   if        memcmp(p_found: %addr(peString)+2:
     c                                       %len(peString)) = 0
     c                   callp     memcpy(p_found: %addr(peToString)+2:
     c                                       %len(peToString))
     c                   eval      wwReps = wwReps + 1
     c                   eval      wwAdvance = (p_found - peBuf) +
     c                                  %len(peToString)
     c                   else
     c                   eval      wwAdvance = (p_found - peBuf) + 1
     c                   endif

     c                   eval      peBuf = peBuf + wwAdvance
     c                   eval      peSize = peSize - wwAdvance
     c                   enddo

     c                   return    wwReps
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  Delete spooled file
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P DltSplf         b
     D DltSplf         PI            10I 0
     D    peJob                      26A   const
     D    peSplf                     10A   const
     D    peSplNbr                   10I 0 value

     D wwCmd           s            200A
     D wwSplf          s             10A   varying
     D wwJob           s             28A   varying
     D wwSplNbr        s              5A   varying

     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D   command                    200A   const
     D   length                      15P 5 const

     c                   eval      wwSplf = %trim(peSplf)

     c                   if        peJob = '*'
     c                   eval      wwJob = '*'
     c                   else
     c                   eval      wwJob = %subst(peJob:21:6)   +  '/' +
     c                              %trimr(%subst(peJob:11:10)) +  '/' +
     c                              %trimr(%subst(peJob:1:10))
     c                   endif

     c                   select
     c                   when      peSplNbr = 0
     c                   eval      wwSplNbr = '*ONLY'
     c                   when      peSplNbr = -1
     c                   eval      wwSplNbr = '*LAST'
     c                   other
     c                   eval      wwSplNbr = %trim(%editc(peSplNbr:'Z'))
     c                   endsl

     c                   eval      wwCmd = 'DLTSPLF FILE(' + wwSplf + ') ' +
     c                                              'JOB(' + wwJob  + ') ' +
     c                                           'SPLNBR(' + wwSplNbr + ')'

     c                   callp(e)  QCMDEXC(wwCmd: %size(wwCmd))
     c                   if        %error
     c                   return    -1
     c                   else
     c                   return    0
     c                   endif
     P                 E
