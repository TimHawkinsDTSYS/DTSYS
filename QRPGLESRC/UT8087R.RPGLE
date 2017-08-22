      /TITLE Utility, Email (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
     H thread(*serialize)

      // Local prototypes

     D newString       pr              O   class(*java: jStrConst)
     D  pString                   32767a   const

     D Exec_Command    pr
     D pCmd                         256    value

      // Constants to make the below Java prototypes easier on the eyes

     D jStrConst       c                   'java.lang.String'

      // Prototype Java com.mowyourlawn.rpgmail.RPGMail methods

     D RPGMailconstructor...
     D                 pr              o   extproc(*java: RPGMail:*constructor)
     D                                     class(*java: RPGMail)

     D addAddress      pr                  extproc(*java: RPGMail:'addAddress')
     D  type                           o   class(*java: jStrConst) const
     D  internetAddress...
     D                                 o   class(*java: jStrConst) const
     D  name                           o   class(*java: jStrConst) const

     D setSubject      pr                  extproc(*java:RPGMail:'setSubject')
     D  text                           o   class(*java: jStrConst) const

     D setBodyText     pr                  extproc(*java:RPGMail:'setBodyText')
     D  text                           o   class(*java: jStrConst) const
     D  contentType                    o   class(*java: jStrConst) const

     D setBodyFile     pr                  extproc(*java:RPGMail:'setBodyFile')
     D  file                           o   class(*java: jStrConst) const
     D  contentType                    o   class(*java: jStrConst) const

     D addFileAttachment...
     D                 pr                  extproc(*java: RPGMail:
     D                                             'addFileAttachment')
     D  location                       o   class(*java: jStrConst) const
     D  name                           o   class(*java: jStrConst) const
     D  contentType                    o   class(*java: jStrConst) const

     D setSMTPHost     pr                  extproc(*java:RPGMail:'setSmtpHost')
     D  SMTPHost                       o   class(*java: jStrConst) const

     D setSMTPPort     pr                  extproc(*java:RPGMail:'setSmtpPort')
     D  SMTPPort                       o   class(*java: jStrConst) const

     D send            pr              o   extproc(*java: RPGMail:'send')
     D                                     CLASS(*java: jStrConst)

     D getBytes        pr         65535a   varying
     D                                     extproc(*java:'java.lang.String':
     D                                     'getBytes')
      *
      /define DSpgm
      /copy qcpysrc,UT8301S
      /copy qcpysrc,Dspec
      * *********************************************************
      * EmlMsg() -- Email message.
      * *********************************************************
     P EmlMsg          B                   Export

     D EmlMsg          PI
     D  Subject                            like(StdTxt) const
     D  Body                               like(StdSQL) const
     D  FromName                           like(StdTxt) const
     D  FromAddr                           like(StdTxt) const
     D  ToName                             like(StdTxt) const
     D  ToAddr                             like(StdTxt) const
     D  Options                            like(StdTxt) const
     D                                     options(*nopass)

     D ZZpgm           s                   like(StdNam) inz
     D SystemCMD       s                   like(CmdStg) inz
     D WKtoaddr        s                   like(ToAddr) inz
     D x               s                   like(StdInt) inz

      /free

       // -------------------------------------------------------
       // Setup for faxing if required.

       WKtoaddr = ToAddr;

       if WKtoaddr = *blanks;
          joblog('No to-address passed to EMLMSG.');
          return;
       endif;

       // -------------------------------------------------------
       // Write Email body to message member

       WrtEmlBdy('QTXTSRC':'MMAIL':'Q' + RtvJobNbr():Body);

       // -------------------------------------------------------
       // Email message.

       SystemCMD='MMAIL/EMLMSG +
                  subject('''   + %trim(Subject)  + ''') ' +
                 'fromname('''  + %trim(FromName) + ''') ' +
                 'fromaddr('''  + %trim(FromAddr) + ''') ' +
                 'to('''        + %trim(WKtoaddr) + '''/'  +
                     ''''       + %trim(ToName)   + '''/*TO)';

       SystemCMD = %trim(SystemCMD) +
                   ' MSGM(MMAIL/QTXTSRC/Q' + RtvJobNbr() + ')';

       joblog(%trim(SystemCMD));
       System(SystemCMD);

      /end-free

     P EmlMsg          E
      * *********************************************************
      * EmlStmf() -- Email streamfile
      * *********************************************************
     P EmlStmf         B                   Export

     D EmlStmf         PI
     D  Subject                            like(StdTxt) const
     D  Body                               like(StdSQL) const
     D  FromName                           like(StdTxt) const
     D  FromAddr                           like(StdTxt) const
     D  ToName                             like(StdTxt) const
     D  ToAddr                             like(StdTxt) const
     D  StmfList                           like(StdStr) const dim(30)
     D  Options                            like(StdTxt) const
     D                                     options(*nopass)

     D ZZpgm           s                   like(StdNam) inz
     D SystemCMD       s                   like(CmdStg) inz
     D WKtoaddr        s                   like(ToAddr) inz
     D x               s                   like(StdInt) inz

      /free
       // -------------------------------------------------------
       // Setup for faxing if required.

       WKtoaddr = ToAddr;

       if WKtoaddr = *blanks;
          joblog('No to-address passed to EMLSTMF.');
          return;
       endif;

       if %scan('@':ToAddr) = *zero;
          WKtoaddr = %trim(%char(num(WKtoaddr))) + '@efaxsend.com';
       endif;

       // -------------------------------------------------------
       // Email simple.

       RPGmail_simple(FromName: FromAddr:
                      ToName:   ToAddr:
                      Subject:  Body:
                      StmfList);

       return;

       // =======================================================
       // =======================================================
       // =======================================================
       // Write Email body to message member

       WrtEmlBdy('QTXTSRC':'MMAIL':'Q' + RtvJobNbr():Body);

       // -------------------------------------------------------
       // Email streamfile.

       SystemCMD='MMAIL/EMLSTMF +
                  subject('''   + %trim(Subject)  + ''') ' +
                 'fromname('''  + %trim(FromName) + ''') ' +
                 'fromaddr('''  + %trim(FromAddr) + ''') ' +
                 'to('''        + %trim(WKtoaddr) + '''/'  +
                     ''''       + %trim(ToName)   + '''/*TO)';

       if StmfList(1) <> *blanks;
          SystemCMD = %trim(SystemCMD) + ' stmf(';

          for x = 1 to %elem(StmfList);
              if StmfList(x) <> *blanks;
                 SystemCMD = %trim(SystemCMD) +
                             ' '''  + %trim(StmfList(x)) + '''';
              endif;
          endfor;

          SystemCMD = %trim(SystemCMD) + ')';
       endif;

       SystemCMD = %trim(SystemCMD) +
                   ' MSGM(MMAIL/QTXTSRC/Q' + RtvJobNbr() + ')';

       joblog(%trim(SystemCMD));
       System(SystemCMD);

       // ---------------------------------------------------
       // Delete streamfiles.

       if %parms >= 8           and
          %scan('*DLTSTMF':Options) <> *zero;

          for x = 1 to %elem(StmfList);
              if StmfList(x) <> *blanks;
                 UnLink('''' + %trim(StmfList(x)) + '''');
              endif;
          endfor;
       endif;

      /end-free

     P EmlStmf         E
      * *********************************************************
      * WrtEmlBdy -- Write Email body to message member
      * *********************************************************
     P WrtEmlBdy       B                   Export

     Fqtxtsrc   o    e             disk    rename(qtxtsrc:qtxtsrcr)
     F                                     EXTFILE(LibFileName)
     F                                     EXTMBR(MbrName)
     F                                     static usropn
     F                                     block(*no)

     D WrtEmlBdy       PI
     D  FileName                           like(StdNam) const
     D  LibName                            like(StdNam) const
     D  MbrName                            like(StdNam) const
     D  Body                               like(StdSQL) const

     D txtsrcDS        ds                  likerec(qtxtsrcr:*output) inz
     D LibFileName     s             21                              inz
     D x               s                   like(StdInt)              inz

      /free
       // -------------------------------------------------------
       // Add workmember, clear it.

       d_ChkObj = ChkObj(FileName:LibName:'*FILE':MbrName);
       if ChkObj_msgid = 'CPF9815';
          System('addpfm file(' + %trim(LibName)  + '/' +
                                  %trim(FileName) + ') +
                         mbr('  + %trim(MbrName)  + ')');
       endif;

       System('clrpfm file(' + %trim(LibName)  + '/' +
                               %trim(FileName) + ') +
                      mbr('  + %trim(MbrName)  + ')');

       LibFileName = %trim(LibName) + '/' + FileName;
       open qtxtsrc;

       // -------------------------------------------------------
       // Format remarks and write to text member.

       d_ChrSetPrtLin = ChrSetPrtLin(Body:RMchrset:70:'*NOFMT');

       for x = 1 to AYrmklin;
           txtsrcDS.srcseq = x;
           txtsrcDS.srcdta = %xlate(x'20':x'40':AYrmktxt(x));
           write qtxtsrcr txtsrcDS;
       endfor;

       close qtxtsrc;

      /end-free

     P WrtEmlBdy       E
      * ------------------------------------------------------------
      * RtvSMTPEmail() -- Retrieve SMTP email.
      * ------------------------------------------------------------
     P RtvSMTPEmail    B                   EXPORT

     D RtvSMTPEmail    PI            80A
     D   pUSER                       10A   Const

     D UsrPrf          S             10A
     D RtnEmail        S             80A

      * --- Search System Directory API ---
     D QOKSCHD         pr                  Extpgm('QOKSCHD')
     D   Recvr                     4096a   Options(*varsize)
     D   RecvrL                      10i 0 Const
     D   RecvrFmt                     8a   Const
     D   Function                    10a   Const
     D   KeepRsc                      1a   Const
     D   Rqst                      4096a   Const options(*varsize)
     D   RqstL                       10i 0 Const
     D   RqstFmt                      8a   Const
     D   Err                        256a   options(*varsize)

     D SRCV0100        DS

     D   deRETRN                     10i 0
     D   deFLDSoff                   10i 0
     D   deUSRSoff                   10i 0
     D   deNBRRTN                    10i 0
     D   deCNTHDL                     1A
     D   deRSRCHDL                   17A
     D   deBUFFER              1   4096A
     D SRCV0100L       S             10i 0 INZ(%size(SRCV0100))

     D deUSERS         DS          4096
     D   deCCSID                     10i 0
     D   deCODEPG                    10i 0
     D   deLen                       10i 0
     D   deVal                      128A
     D SRCV0200        DS          1024
     D   NbrRtnd                     10i 0
     D   NbrFlds                     10i 0
     D   AryOffs                     10i 0
     D   ContHndl                    17a

     D SRCV0200L       S             10i 0 INZ(%size(SRCV0200))

     D SREQ0100        DS

     D  rqCCSID                      10i 0 INZ(0)
     D  rqCHARSET                    10i 0 INZ(0)
     D  rqCODEPG                     10i 0 INZ(0)
     D  rqWILDCARD                    4A   INZ(*blanks)
     D  rqCVTRCVR                     1A   INZ('0')
     D  rqDATA2SRCH                   1A   INZ('0')
     D  rqRUNVFY                      1A   INZ('1')
     D  rqCNTHDL                      1A   INZ('0')
     D  rqRSRCHDL                    16A   INZ(*blanks)
     D  rqSRCHFMT                     8A   INZ('SREQ0101')
     D  rqSRCHoff                    10i 0 INZ(336)
     D  rqSRCHnbr                    10i 0 INZ(1)
     D  rqRTNFMT                      8A
     D  rqFLDoff                     10i 0
     D  rqNBRflds                    10i 0
     D  rqUSRfmt                      8A   INZ('SRCV0101')
     D  rqUSRnbr                     10i 0 INZ(1)
     D  rqFLDfmt                      8A   INZ('SRCV0112')
     D  rqFLDordr                     8A   INZ('        ')
     D  rqRSRVD                       3A
     D  SREQ0102             257    308A
     D    rq2FLD1                    10A   INZ('SMTPAUSRID')
     D                                     OVERLAY(SREQ0102)

     D    rq2PRD1                     7A   INZ('SMTP')
     D                                     OVERLAY(SREQ0102:*NEXT)
     D    rq2FLD2                    10A   INZ('SMTPDMN   ')
     D                                     OVERLAY(SREQ0102:*NEXT)
     D    rq2PRD2                     7A   INZ('SMTP')
     D                                     OVERLAY(SREQ0102:*NEXT)
     D    rq2FLD3                    10A   INZ('SMTPRTE   ')
     D                                     OVERLAY(SREQ0102:*NEXT)
     D    rq2PRD3                     7A   INZ('SMTP')
     D                                     OVERLAY(SREQ0102:*NEXT)
     D  SREQ0103             321    330A
     D    rq3FIELD                   10A
     D                                     OVERLAY(SREQ0103)
     D  SREQ0101             337    512A
     D    rq1LEN                     10i 0 INZ(%size(SREQ0101))
     D                                     OVERLAY(SREQ0101)
     D    rq1COMP                     1A   INZ('1')
     D                                     OVERLAY(SREQ0101:*NEXT)
     D    rq1FIELD                   10A   INZ('USER      ')
     D                                     OVERLAY(SREQ0101:*NEXT)
     D    rq1PROD                     7A   INZ('*IBM   ')
     D                                     OVERLAY(SREQ0101:*NEXT)
     D    rq1CASE                     1A   INZ('0')

     D                                     OVERLAY(SREQ0101:*NEXT)
     D    rq1RSRVD                    1A
     D                                     OVERLAY(SREQ0101:*NEXT)
     D    rq1VLEN                    10i 0 INZ(%size(rq1VALUE))
     D                                     OVERLAY(SREQ0101:*NEXT)
     D    rq1VALUE                   10A
     D                                     OVERLAY(SREQ0101:*NEXT)

     D SREQ0100L       s             10i 0 INZ(%size(SREQ0100))
     D SREQ0103L       s             10i 0 INZ(%size(SREQ0103))

     D SREQ0200        DS                  Qualified
     D  rqTYPE                        1A   INZ('0')
     D  rqCNTHDL                      1A   INZ(' ')
     D  rqRSRCHDL                    17A   INZ(*blanks)

     D SREQ0200L       S             10i 0 INZ(%size(SREQ0200))

      * --- API Return ERROR Structure ---
     D APIERROR        DS           145
     D  aePROV                 1      4B 0 Inz(%size(APIERROR))
     D  aeAVAI                 5      8B 0 Inz(%size(APIERROR))
     D  aeMID                  9     15

     D  aeRSVD                16     16
     D  aeXDTA                17    145

     D CHAR4           DS             4
     D  BIN4                         10i 0
      /free
         UsrPrf = pUSER;

         // Retrieve SMTP address
         rq1Value = UsrPrf;
         rqRTNFMT = 'SREQ0102';
         rqFLDoff = 256;
         rqNBRflds = 3;
         QOKSCHD(SRCV0100 : SRCV0100L : 'SRCV0100' : '*SEARCH' : '0' :
                 SREQ0100 : SREQ0100L : 'SREQ0100' : APIERROR);
         // If SMTPAUSRID is not a valid field, try the other way...
         if aeMID='CPF9A8C';
            reset APIERROR;
            SREQ0103 = *blanks;
            rq3FIELD = '*SMTP';
            rqRTNFMT = 'SREQ0103';
            rqFLDoff = 320;
            rq1Value = UsrPrf;

            rqNBRflds = 1;
            QOKSCHD(SRCV0100 : SRCV0100L : 'SRCV0100' : '*SEARCH' : '0' :
                    SREQ0100 : SREQ0100L : 'SREQ0100' : APIERROR);
         endif;

         RtnEmail=*blanks;
         if aeMID=*blanks;
            if deNBRRTN=1;
               CHAR4   = %subst(deBUFFER:deUSRSoff+1:4);
               deUSERS = %subst(deBUFFER:deUSRSoff+8+1:BIN4-8);
               if deLen>0;
                  RtnEmail = %subst(deVal:1:deLen);
                  deUSERS  = %subst(deBUFFER:deUSRSoff+8+12+deLen+1:
                                BIN4-8-12-deLen);
                  RtnEmail = %trim(RtnEmail) + '@' +
                             %subst(deVal:1:deLen);
               endif;
            endif;
         endif;

         return RtnEmail;

      /end-free

     P RtvSMTPEmail    E

      //--------------------------------------------------------------------------------------------
      //  Program.......: RPGMail
      //  Creation Date.: 07/22/2002
      //  Author........: Aaron Bartell
      //  Description...: RPG call Java method to send email.
      //  Compile: CRTRPGMOD MODULE(RPGMAIL/RPGMAILFN) SRCFILE(RPGMAIL/QSOURCE) SRCMBR(RPGMAILFN)
      //             REPLACE(*YES) TGTRLS(V5R1M0)
      //           CRTSRVPGM SRVPGM(RPGMAIL/RPGMAILSV) MODULE(RPGMAIL/RPGMAILFN)
      //             SRCFILE(RPGMAIL/QSOURCE) OPTION(*DUPPROC)
      //--------------------------------------------------------------------------------------------

      //--------------------------------------------------------------------------------------------
      // @Author - Aaron Bartell
      // @Created: 07/07/2003
      // @Descr: Prepare the environment for sending emails. Set the CLASSPATH variable
      //         for the Java portions of RPGMail. If the JVM has already been started
      //         elseware in this job this CLASSPATH change will be of no effect. This is an
      //         OS/400 implementation limitation.
      //         If you aren't using java.version=1.4 then you will need to change the below code
      //         and recompile using the BUILD.CLLE program.
      // @Usage - RPGMail_init();
      //--------------------------------------------------------------------------------------------
     P RPGMail_init    b                   export
     D RPGMail_init    pi

     D q               s              1a   inz('''')
      /free

       Exec_Command('CHGCURDIR  DIR(' + q + '/java/' + q + ')');

       Exec_Command('ADDENVVAR ENVVAR(CLASSPATH) REPLACE(*YES) ' +
         'VALUE(' +
          q +
          '.:/java/activation.jar:/java/mail.jar:/java/rpgmail.jar:/java/' +
          q +
          ')');

       Exec_Command('ADDENVVAR ENVVAR(QIBM_RPG_JAVA_PROPERTIES) ' +
         'REPLACE(*YES) VALUE(' + q + '-Djava.version=1.4;' + q + ')');

       return;

      /end-free

     P RPGMail_init    e


      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Created: 07/07/2003
      // @Descr: This will create a new RPGMail Java object by calling the RPGMail
      //         constructor.
      // @Usage: RPGMail_new()
      //--------------------------------------------------------------------------------------------
     P RPGMail_new     b                   export
     D RPGMail_new     pi              o   class(*java: RPGMail)

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         return RPGMailConstructor();
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL101': 100: 'RPGMail_new': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_new     e


      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Created: 07/07/2003
      // @Descr: Add an address to the specified RPGMail object
      // @Usage: RPGMail_addAddress(RPGMail Object: EmailType: Address: Name)
      // @Notes: EmailType can be 'FROM', 'TO', 'CC', 'BCC', or 'REPLYTO'
      //--------------------------------------------------------------------------------------------
     P RPGMail_addAddress...
     P                 b                   export
     D RPGMail_addAddress...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pType                        10a   value
     D  pAddress                    256a   value
     D  pName                       256a   value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         addAddress(
           pEmail: newString(pType): newString(pAddress): newString(pName));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL102':
           100: 'RPGMail_addAddress': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_addAddress...
     P                 e


      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Set the subject of this email.
      // @Created: 07/07/2003
      // @Usage: RPGMail_setSubject(RPGMailObject: SubjectText)
      //--------------------------------------------------------------------------------------------
     P RPGMail_setSubject...
     P                 b                   export
     D RPGMail_setSubject...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pText                       256a   value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         setSubject(pEmail: newString(pText));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL103':
           100: 'RPGMail_setSubject': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_setSubject...
     P                 e


      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Set the text that is to be displayed in the body of the email. The
      //         setBodyText and setBodyFile subprocs can be used together - the file will be
      //         appended to the body after the text.
      // @Created: 07/07/2003
      // @Usage: RPGMail_setBodyText(RPGMailObject: text: ContentType)
      // @Notes: Common ContentType values are: 'text/plain', 'text/html'
      //--------------------------------------------------------------------------------------------
     P RPGMail_setBodyText...
     P                 b                   export
     D RPGMail_setBodyText...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pText                     32767a   value
     D  pContentType                256a   value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         setBodyText(pEmail: newString(pText): newString(pContentType));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL104':
           100: 'RPGMail_setBodyText': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_setBodyText...
     P                 e




      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Set the file that is to be used as the body of the email
      // @Created: 07/07/2003
      // @Usage: RPGMail_setBodyFile(RPGMailObject: IFSLocation: ContentType)
      //--------------------------------------------------------------------------------------------
     P RPGMail_setBodyFile...
     P                 b                   export
     D RPGMail_setBodyFile...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pFile                       256a   value
     D  pContentType                256a   value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         setBodyFile(pEmail: newString(pFile): newString(pContentType));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL105':
           100: 'RPGMail_setBodyFile': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_setBodyFile...
     P                 e



      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Add an IFS file as an attachment to this email.
      // @Created: 07/07/2003
      // @Usage: RPGMail_addFileAttachment(RPGMailObject: IFSLocation: Name: ContentType)
      // @Notes: Common ContentType values are: 'text/plain','text/html','application/pdf'
      //--------------------------------------------------------------------------------------------
     P RPGMail_addFileAttachment...
     P                 b                   export
     D RPGMail_addFileAttachment...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pLocation                   256a   value
     D  pName                       256a   value
     D  pContentType                256a   value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         addFileAttachment(
           pEmail:
           newString(pLocation): newString(pName): newString(pContentType));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL106':
           100: 'RPGMail_addFileAttachment': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_addFileAttachment...
     P                 e



      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Set the SMTP host that this email is to be routed through.
      // @Created: 07/07/2003
      // @Usage: RPGMail_setSMTPHost(RPGMailObject: 'smtp.mycompany.com')
      //--------------------------------------------------------------------------------------------
     P RPGMail_setSMTPHost...
     P                 b                   export
     D RPGMail_setSMTPHost...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pHost                       256a   Value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         setSMTPHost(pEmail: newString(pHost));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL107':
           100: 'RPGMail_setSMTPHost': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_setSMTPHost...
     P                 e


      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Set the SMTP port that emails are to be routed through relating to the above
      //         SMTP host.
      // @Created: 07/07/2003
      // @Usage: RPGMail_setSMTPHost(RPGMailObject: HostURI)
      //--------------------------------------------------------------------------------------------
     P RPGMail_setSMTPPort...
     P                 b                   export
     D RPGMail_setSMTPPort...
     D                 pi
     D  pEmail                         o   class(*java: RPGMail)
     D  pPort                       256a   Value

     D error           ds                  likeds(Error_Info) inz
      /free

       monitor;
         setSMTPPort(pEmail: newString(pPort));
         return;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL108':
           100: 'RPGMail_setSMTPPort': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_setSMTPPort...
     P                 e



      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Send the email.
      // @Created: 07/07/2003
      // @Usage: RPGMail_send(RPGMailObject)
      //--------------------------------------------------------------------------------------------
     P RPGMail_send    b                   export
     D RPGMail_send    pi
     D  pEmail                         o   class(*java: RPGMail)

     D error           ds                  likeds(Error_Info) inz
     D resultJO        s               o   CLASS(*JAVA:'java.lang.String')
     D result          s          65535a   varying
      /free

       monitor;
         resultJO = send(pEmail);
         result = getBytes(resultJO);
         if result <> *blanks;
           Error_throw(
             'RPGMAIL111': 100: 'RPGMail_send': %trim(result));
         endif;
       on-error *All;
         error = Error_catch();
         Error_throw(
           'RPGMAIL109': 100: 'RPGMail_send': error.code + ': ' + error.text);
       endmon;

      /end-free

     P RPGMail_send    e



      //--------------------------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Descr: Misc function that will create a Java String object from the passed in chars
      // @Created: 07/07/2003
      // @Usage: Internal use
      //--------------------------------------------------------------------------------------------
     P newString       b
     D newString       pi              o   class(*java: jStrConst)
     D  pString                   32767a   const

     D string          s               o   class(*java: jStrConst)

     D error           ds                  likeds(Error_Info) inz

     D newJavaString   pr              o   extproc(*java: jStrConst:
     D                                     *constructor)
     D                                     class(*java: jStrConst)
     D parm                       32767a   const

     D trimString      pr              o   extproc(*java: jStrConst: 'trim')
     D                                     class(*java: jStrConst)
      /free

       monitor;
         string = newJavaString(%Trim(pString));
         return trimString(string);
       on-error;
         error = Error_catch();
         Error_throw(
           'RPGMAIL110': 100: 'RPGMail_send': error.code + ': ' + error.text);
       endmon;

      /end-free

     P newString       e


      //------------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Created: 07/07/2003
      // @Descr: Misc function to execute a CL command.
      // @Usage:
      //------------------------------------------------------------------------
     P Exec_Command    b
     D Exec_Command    pi
     D pCmd                         256a   value

     D length          s             15  5

     D QCMDEXC         pr                  extpgm('QCMDEXC')
     D  pCmd                               const like(pCmd)
     D  pLength                            const like(length)
      /free

       length = %Len(%Trim(pCmd));
       QCMDEXC(pCmd:length);
       return;

      /end-free

     P Exec_Command    e
      //-------------------------------------------------------------
      // RPGmail_simple() -- RPGmail simple interface
      //-------------------------------------------------------------

     P RPGmail_simple  b                   export

     D RPGmail_simple  pi                  like(StdInd)
     D  FromName                           like(StdStg) const
     D  FromAddr                           like(StdStg) const
     D  ToName                             like(StdStg) const
     D  ToAddr                             like(StdStg) const
     D  Subject                            like(StdStg) const
     D  p_Body                             like(StdBuf) const
     D                                     options(*omit:*nopass)
     D  p_Attachments                      like(StdStg) const dim(50)
     D                                     options(*omit:*nopass)
     D  p_Options                          like(StdStg) const
     D                                     options(*omit:*nopass)

     D i_Body          s                   like(StdBuf) inz
     D i_Attachments   s                   like(StdStg) inz dim(50)
     D i_Options       s                   like(StdStg) inz
     D email           s               o   class(*java: RPGMail)
     D IFSpath         s                   like(StdStg) inz
     D IFSfile         s                   like(StdStg) inz
     D IFSext          s                   like(StdNam) inz
     D ContentType     s                   like(StdStg) inz
     D error           ds                  likeds(Error_Info)
     D x               s                   like(StdInt) inz

      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if %parms       >= 6;
          CEETSTA(ParmPassed:6:*omit);
          if ParmPassed = 1;
             i_Body     = p_Body;
          endif;
       endif;

       if %parms       >= 7;
          CEETSTA(ParmPassed:7:*omit);
          if ParmPassed = 1;
             i_Attachments = p_Attachments;
          endif;
       endif;

       if %parms       >= 8;
          CEETSTA(ParmPassed:8:*omit);
          if ParmPassed = 1;
             i_Options  = upper(p_Options);
          endif;
       endif;

       // -------------------------------------------------------
       // Initialize environment.

       monitor;
         RPGMail_init();
       on-error;
         error = Error_catch();
         return *on;
       endmon;

       // -------------------------------------------------------
       // Bail if no address.

       if  FromAddr = *blanks   or
           ToAddr   = *blanks;
           return *off;
       endif;

       //----------------------------------------------------------
       // Determine content type.

       select;
       when %scan('*HTML': i_Options) <> *zero;
            ContentType = 'text/html';

       other;
            ContentType = 'text/plain';
       endsl;

       // -------------------------------------------------------
       // Set components.

       monitor;
         email = RPGMail_new();
         RPGMail_addAddress(email: 'FROM':FromAddr:FromName);
         RPGMail_addAddress(email: 'TO':ToAddr:ToName);
         RPGMail_setSubject(email: Subject);

         if %parms >= 6          and
            i_Body <> *blanks    and
            i_Body <> '*NONE';
            RPGMail_setBodyText(email: i_Body: ContentType);
         endif;

         if %parms >= 7;
            for x = 1 to %elem(i_Attachments);
                if  i_Attachments(x) <> *blanks   and
                    i_Attachments(x) <> '*NONE';
                    exsr $FileAttachment;
                else;
                    leave;
                endif;
            endfor;
         endif;

         // -----------------------------------------------------
         // Send email.

         RPGMail_setSMTPHost(email: %subst(RtvCtlmaDta('INTERFACES':
                                                       'EMAIL SERVER'):01:50));
         RPGMail_setSMTPPort(email: %subst(RtvCtlmaDta('INTERFACES':
                                                       'EMAIL SERVER'):51:05));

         RPGMail_send(email);
       on-error;
         error = Error_catch();

       //WrtErrLog(DSpgm: 'Sent email in RPGMail_simple() ' +
       //                 ' error.code='     + %trim(error.code) +
       //                 ' error.severity=' + %char(error.severity) +
       //                 ' error.pgm='      + %trim(error.pgm) +
       //                 ' error.text='     + %trim(error.text));
         return *off;
       endmon;

       return *on;

       // * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // File Attachments.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       begsr $FileAttachment;

       //----------------------------------------------------------
       // Extract directory & file name from path.

       IFSpath = ExtDir(i_Attachments(x));
       IFSfile = ExtFile(i_Attachments(x));

       //----------------------------------------------------------
       // Determine content type.

       //IFSext  = ExtExt(i_Attachments(x));
         IFSext  = 'PDF';

       select;
       when IFSext = 'TXT';
            ContentType = 'text/plain';

       when IFSext = 'HTM'  or
            IFSext = 'HTML';
            ContentType = 'text/html';

       when IFSext = 'PDF';
            ContentType = 'application/pdf';
       other  ;
            ContentType = 'text/plain';
       endsl;

       //----------------------------------------------------------
       // Add file attachment.

       RPGMail_addFileAttachment(email:
               %trim(i_Attachments(x)): %trim(IFSfile):
                %trim(ContentType));

       endsr;

      /end-free
     P RPGmail_simple  e


      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SndEmlInd() - Send email to an individual
      * -- Synopsis: Sends an email to one email address, and may
      *              include up to 32k in the body and up to 50
      *              attached files.
      * -- Options : none
      * -- Returns : *on=Success, *off=Failed
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P SndEmlInd       b                   export

     D SndEmlInd       pi                  like(StdInd)
     D  p_FromID                           like(StdStg) const
     D                                     options(*omit:*nopass)
     D  p_ToID                             like(StdStg) const
     D                                     options(*omit:*nopass)
     D  p_Subject                          like(StdStg) const
     D                                     options(*omit:*nopass)
     D  p_Body                             like(StdBuf) const
     D                                     options(*omit:*nopass)
     D  p_Attachments                      like(StdStg) const dim(50)
     D                                     options(*omit:*nopass)
     D  p_Options                          like(StdStg) const
     D                                     options(*omit:*nopass)

     D i_FromID        s                   like(StdStg) inz
     D i_ToID          s                   like(StdStg) inz
     D i_Subject       s                   like(StdStg) inz
     D i_Body          s                   like(StdBuf) inz
     D i_Attachments   s                   like(StdStg) inz dim(50)
     D i_Options       s                   like(StdStg) inz

     D out_EmailSent   s                   like(StdInd) inz

     D FromName        s                   like(StdStg) inz
     D FromAddr        s                   like(StdStg) inz
     D FromUser        s                   like(StdStg) inz
     D FromDomain      s                   like(StdStg) inz

     D ToName          s                   like(StdStg) inz
     D ToAddr          s                   like(StdStg) inz
     D ToUser          s                   like(StdStg) inz
     D ToDomain        s                   like(StdStg) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if  %parms       >= 1;
           CEETSTA(ParmPassed:1:*omit);
           if  ParmPassed = 1;
               i_FromID   = p_FromID;
           endif;
       endif;

       if  %parms       >= 2;
           CEETSTA(ParmPassed:2:*omit);
           if  ParmPassed = 1;
               i_ToID     = p_ToID;
           endif;
       endif;

       if  %parms       >= 3;
           CEETSTA(ParmPassed:3:*omit);
           if  ParmPassed = 1;
               i_Subject  = p_Subject;
           endif;
       endif;

       if  %parms       >= 4;
           CEETSTA(ParmPassed:4:*omit);
           if  ParmPassed = 1;
               i_Body     = p_Body;
           endif;
       endif;

       if  %parms       >= 5;
           CEETSTA(ParmPassed:5:*omit);
           if  ParmPassed = 1;
               i_Attachments = p_Attachments;
           endif;
       endif;

       if  %parms       >= 6;
           CEETSTA(ParmPassed:6:*omit);
           if  ParmPassed = 1;
               i_Options  = upper(p_Options);
           endif;
       endif;

       // -------------------------------------------------------
       // Parse name and domaim from full email address.

       if  %scan('@':i_FromID) <> *zero   and
           ParseEmailAddr(i_FromID: FromName: FromUser: FromDomain);

           FromAddr = %trim(FromUser) + '@' + FromDomain;
       endif;

       if  %scan('@':i_ToID) <> *zero     and
           ParseEmailAddr(i_ToID: ToName: ToUser: ToDomain);

           ToAddr = %trim(ToUser) + '@' + ToDomain;
       endif;

       // -------------------------------------------------------
       // Set default FROM name and address.

       if  FromName = *blanks   or
           i_FromID = '*DFT';
           FromName = RtvUsrNam(RtvJobUsr());
       endif;

       if  FromAddr = *blanks;
           FromAddr = RtvUsrEmlAdr(RtvJobUsr());
       endif;

       if  FromName = *blanks;
       //  FromName = RtvAdmNam();
           FromName = 'Tim Hawkins';
       endif;

       if  FromAddr = *blanks;
       //  FromAddr = RtvAdmEmlAdr();
           FromAddr = 'TimH@cruzio.com';
       endif;

       // -------------------------------------------------------
       // Set default TO name and address.

       if  ToName = *blanks;
           ToName = RtvUsrNam(RtvJobUsr());
       endif;

       if  ToAddr = *blanks;
           ToAddr = RtvUsrEmlAdr(RtvJobUsr());
       endif;

       if  ToName = *blanks;
       //  ToName = RtvAdmNam();
           ToName = 'Tim Hawkins';
       endif;

       if  ToAddr = *blanks;
       //  ToAddr = RtvAdmEmlAdr();
           ToAddr = 'TimH@cruzio.com';
       endif;

       // -------------------------------------------------------
       // Send email.

       out_EmailSent = RPGmail_simple(FromName:  FromAddr:
                                      ToName:    ToAddr:
                                      i_Subject: i_Body:
                                      i_Attachments:
                                      i_Options);

       //WrtErrLog(DSpgm: 'Sent email in SndEmlInd() for ' +
       //                 ' EmailSent=' + %trim(out_EmailSent) +
       //                 ' FromName='  + %trim(FromName) +
       //                 ' FromAddr='  + %trim(FromAddr) +
       //                 ' ToName='    + %trim(ToName) +
       //                 ' Toaddr='    + %trim(ToAddr) +
       //                 ' Subject='   + %trim(i_Subject) +
       //                 ' Body='      + %trim(i_Body) +
       //                 ' Option='    + %trim(i_Options));

       return out_EmailSent;

      /end-free
     P SndEmlInd       e

      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SndEmlGrp() - Send email to a group
      * -- Synopsis: Sends an email to one or many email addresses,
      *              and may include up to 32k in the body and up to
      *              50 attached files.
      *              The email addresses are stored in the Application
      *              Control file under the category NOTIFICATIONS,
      *              with the To Group List ID specifying the
      *              sub-category.  The record layout must include
      *              the recipient name in positions 01-50, and the
      *              recipient email address in positions 51-100.
      * -- Options : none
      * -- Returns : *on=Success, *off=Failed
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P SndEmlGrp       b                   export

     D SndEmlGrp       pi                  like(StdInd)
     D  p_FromID                           like(StdStg) const
     D                                     options(*omit:*nopass)
     D  p_ToGroupListID...
     D                                     like(StdTxt) const
     D                                     options(*omit:*nopass)
     D  p_Subject                          like(StdStg) const
     D                                     options(*omit:*nopass)
     D  p_Body                             like(StdBuf) const
     D                                     options(*omit:*nopass)
     D  p_Attachments                      like(StdStg) const dim(50)
     D                                     options(*omit:*nopass)
     D  p_Options                          like(StdStg) const
     D                                     options(*omit:*nopass)

     D in_FromID       s                   like(StdStg) inz
     D in_ToGroupListID...
     D                 s                   like(StdTxt) inz
     D in_Subject      s                   like(StdStg) inz
     D in_Body         s                   like(StdBuf) inz
     D in_Attachments  s                   like(StdStg) inz dim(50)
     D in_Options      s                   like(StdStg) inz

     D out_EmailSent   s                   like(StdInd) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if %parms       >= 1;
          CEETSTA(ParmPassed:1:*omit);
          if ParmPassed = 1;
             in_FromID  = p_FromID;
          endif;
       endif;

       if %parms       >= 2;
          CEETSTA(ParmPassed:2:*omit);
          if ParmPassed = 1;
             in_ToGroupListID = p_ToGroupListID;
          endif;
       endif;

       if %parms       >= 3;
          CEETSTA(ParmPassed:3:*omit);
          if ParmPassed = 1;
             in_Subject = p_Subject;
          endif;
       endif;

       if %parms       >= 4;
          CEETSTA(ParmPassed:4:*omit);
          if ParmPassed = 1;
             in_Body    = p_Body;
          endif;
       endif;

       if %parms       >= 5;
          CEETSTA(ParmPassed:5:*omit);
          if ParmPassed = 1;
             in_Attachments = p_Attachments;
          endif;
       endif;

       if %parms       >= 6;
          CEETSTA(ParmPassed:6:*omit);
          if ParmPassed = 1;
             in_Options = upper(p_Options);
          endif;
       endif;
       // -------------------------------------------------------
       // Send email to group.

       UT8087RA(in_FromID:  in_ToGroupListID:
                in_Subject: in_Body: in_Attachments:
                in_Options:
                out_EmailSent);

       return out_EmailSent;

      /end-free

     P SndEmlGrp       e
