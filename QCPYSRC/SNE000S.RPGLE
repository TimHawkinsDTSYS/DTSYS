

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

