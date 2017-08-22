      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Email prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * EmlMsg() -- Email message
      *
     D EmlMsg          PR
     D  Subject                            like(StdTxt) const
     D  Body                               like(StdSQL) const
     D  FromName                           like(StdTxt) const
     D  FromAddr                           like(StdTxt) const
     D  ToName                             like(StdTxt) const
     D  ToAddr                             like(StdTxt) const
     D  Options                            like(StdTxt) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * EmlStmf() -- Email streamfile
      *
     D EmlStmf         PR
     D  Subject                            like(StdTxt) const
     D  Body                               like(StdSQL) const
     D  FromName                           like(StdTxt) const
     D  FromAddr                           like(StdTxt) const
     D  ToName                             like(StdTxt) const
     D  ToAddr                             like(StdTxt) const
     D  StmfList                           like(StdStr) const dim(30)
     D  Options                            like(StdTxt) const
     D                                     options(*nopass)
      *
      /if defined(dfnEmlStmf)
     D  Subject        s                   like(StdTxt) inz
     D  Body           s                   like(StdSQL) inz
     D  FromName       s                   like(StdTxt) inz
     D  FromAddr       s                   like(StdTxt) inz
     D  ToName         s                   like(StdTxt) inz
     D  ToAddr         s                   like(StdTxt) inz
     D  StmfList       s                   like(StdStr) inz dim(30)
      /endif
      * ---------------------------------------------------------
      * WrtEmlBdy -- Write Email body to message member
      *
     D WrtEmlBdy       PR
     D  FileName                           like(StdNam) const
     D  LibName                            like(StdNam) const
     D  MbrName                            like(StdNam) const
     D  Body                               like(StdSQL) const
      * ============================================================
      * RtvSMTPEmail() Retrieve SMTP email.
      *
     D RtvSMTPEmail    PR            80A
     D   pUSER                       10A   Const
      * ============================================================
      *
      * RPGmail() -- Send email from RPG (RPGmail)
      *
     D RPGMail         c                   'com.mowyourlawn.rpgmail.RPGMail'

     D RPGMail_init    pr

     D RPGMail_new     pr              o   class(*java: RPGMail)

     D RPGMail_addAddress...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pType                        10a   value
     D  pAddress                    256a   value
     D  pName                       256a   value

     D RPGMail_setSubject...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pText                       256a   value

     D RPGMail_setBodyText...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pText                     32767a   value
     D  pContentType                256a   value

     D RPGMail_setBodyFile...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pFile                       256a   value
     D  pContentType                256a   value

     D RPGMail_addFileAttachment...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pLocation                   256a   value
     D  pName                       256a   value
     D  pContentType                256a   value

     D RPGMail_setSMTPHost...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pHost                       256a   value

     D RPGMail_setSMTPPort...
     D                 pr
     D  pEmail                         o   class(*java: RPGMail)
     D  pPort                       256a   value

     D RPGMail_send    pr
     D  pEmail                         o   class(*java: RPGMail)

      //-------------------------------------------------------------
      // RPGmail_simple() -- RPGmail simple interface

     D RPGmail_simple  pr                  like(StdInd)
     D  FromName                           like(StdStg) const
     D  FromAddr                           like(StdStg) const
     D  ToName                             like(StdStg) const
     D  ToAddr                             like(StdStg) const
     D  Subject                            like(StdStg) const
     D  Body                               like(StdBuf) const
     D                                     options(*omit:*nopass)
     D  Attachments                        like(StdStg) const dim(50)
     D                                     options(*omit:*nopass)
     D  Options                            like(StdStg) const
     D                                     options(*omit:*nopass)
      //---------------------------------------------------------
      // SndEmlInd() - Send email to an individual.

     D SndEmlInd       pr                  like(StdInd)
     D  FromID                             like(StdStg) const
     D                                     options(*omit:*nopass)
     D  ToID                               like(StdStg) const
     D                                     options(*omit:*nopass)
     D  Subject                            like(StdStg) const
     D                                     options(*omit:*nopass)
     D  Body                               like(StdBuf) const
     D                                     options(*omit:*nopass)
     D  Attachments                        like(StdStg) const dim(50)
     D                                     options(*omit:*nopass)
     D  Options                            like(StdStg) const
     D                                     options(*omit:*nopass)
      //---------------------------------------------------------
      // SndEmlGrp() - Send email to a group

     D SndEmlGrp       pr                  like(StdInd)
     D  FromID                             like(StdStg) const
     D                                     options(*omit:*nopass)
     D  ToGroupListID                      like(StdTxt) const
     D                                     options(*omit:*nopass)
     D  Subject                            like(StdStg) const
     D                                     options(*omit:*nopass)
     D  Body                               like(StdBuf) const
     D                                     options(*omit:*nopass)
     D  Attachments                        like(StdStg) const dim(50)
     D                                     options(*omit:*nopass)
     D  Options                            like(StdStg) const
     D                                     options(*omit:*nopass)

     D UT8087RA        pr                  extpgm('UT8087RA')
     D  in_FromID                          like(StdStg)
     D  in_ToGroupListID...
     D                                     like(StdTxt)
     D  in_Subject                         like(StdStg)
     D  in_Body                            like(StdBuf)
     D  in_Attachments...
     D                                     like(StdStg) dim(50)
     D  in_Options                         like(StdStg)
     D  out_EmailSent                      like(StdInd)

      /if defined(UT8087RA)
     D UT8087RA        pi
     D  in_FromID                          like(StdStg)
     D  in_ToGroupListID...
     D                                     like(StdTxt)
     D  in_Subject                         like(StdStg)
     D  in_Body                            like(StdBuf)
     D  in_Attachments...
     D                                     like(StdStg) dim(50)
     D  in_Options                         like(StdStg)
     D  out_EmailSent                      like(StdInd)
      /endif
