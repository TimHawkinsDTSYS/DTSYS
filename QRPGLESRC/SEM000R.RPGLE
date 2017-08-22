      /TITLE Send Email
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Send email.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  02/13/08  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /copy qcpysrc,Hspec
      /copy qcpysrc,Dspec
      /free
       // -------------------------------------------------------
       // Set defaults.

       if  FromName = *blanks;
           FromName = 'Information Services';
       endif;

       if  FromAddr = *blanks;
           FromAddr = 'HostMonster.com';
       endif;

       // -------------------------------------------------------
       // Send email.

       RPGmail_simple(FromName: FromAddr:
                      ToName:   ToAddr:
                      Subject:  Body);

       return;

      /end-free
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $define       begsr
      *
     C     *entry        plist
     C                   parm                    FromName        256
     C                   parm                    FromAddr        256
     C                   parm                    ToName          256
     C                   parm                    ToAddr          256
     C                   parm                    Subject         256
     C                   parm                    Body           5000
      *
     CSR   #define       endsr
