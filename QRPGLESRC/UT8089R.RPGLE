      /TITLE Utility, User (SrvPgm)
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
      *
      */define DSpgm
      /copy qcpysrc,Dspec
      * *********************************************************
      * RtvUsrNam() - Retrieve users name
      * *********************************************************
     P RtvUsrNam       B                   Export

     D RtvUsrNam       PI                  like(StdStg)
     D  p_UserID                           like(StdNam)  const
     D                                     options(*omit:*nopass)

     D i_UserID        s                   like(StdNam)  inz
     D o_UserNam       s                   like(StdStg)  inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if %parms       >= 1;
          CEETSTA(ParmPassed:1:*omit);
          if ParmPassed = 1;
             i_UserID = p_UserID;
          endif;
       endif;

       if i_UserID = *blanks;
          i_UserID = ZZusr;
       endif;

       // -------------------------------------------------------
       // Retrieve user name.
      /end-free
     C**                 call      'UT8089RA'
     C**                 parm                    i_UserID
     C**                 parm                    o_UserNam
      *
     C**                 return    o_UserNam
     C                   return    'Tim Hawkins'
      *
     P RtvUsrNam       E
      * *********************************************************
      * RtvUsrEmlAdr() -- Retrieve users email address.
      * *********************************************************
     P RtvUsrEmlAdr    B                   Export

     D RtvUsrEmlAdr    PI                  like(StdStg)
     D  p_UserID                           like(StdNam)  const
     D                                     options(*omit:*nopass)

     D i_UserID        s                   like(StdNam)  inz
     D o_EmlAdr        s                   like(StdStg)  inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if %parms       >= 1;
          CEETSTA(ParmPassed:1:*omit);
          if ParmPassed = 1;
             i_UserID = p_UserID;
          endif;
       endif;

       if i_UserID = *blanks;
          i_UserID = ZZusr;
       endif;

       // -------------------------------------------------------
       // Retrieve email address
      /end-free
     C**                 call      'UT8089RB'
     C**                 parm                    i_UserID
     C**                 parm                    o_EmlAdr
      *
     C**                 return    o_EmlAdr
     C                   return    'TimH@cruzio.com'
      *
     P RtvUsrEmlAdr    E
      * *********************************************************
      * RtvUsrCls() -- Retrieve user class.
      * *********************************************************
     P RtvUsrCls       B                   Export

     F**usrpfp01  if   e           k disk    static

     D RtvUsrCls       PI                  like(StdNam)
     D  UserID_p                           like(StdNam)  const
     D                                     options(*omit:*nopass)

     D*DSusrpf         ds                  likerec(usrpf01r:*input) inz

     D UserID          s                   like(StdNam)  inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if %parms       >= 1;
          CEETSTA(ParmPassed:1:*omit);
          if ParmPassed = 1;
             UserID     = UserID_p;
          endif;
       endif;

       if UserID = *blanks;
          UserID = ZZusr;
       endif;
       // -------------------------------------------------------
       // Retrieve user class.

       //chain (UserID) usrpf01r DSusrpf;
       //if %found;
       //   return DSusrpf.UPusrcls;
       //else;
          return *blanks;
       //endif;

      /end-free
     P RtvUsrCls       E
      * *********************************************************
      * RtvAdmUsrID() -- Retrieve administrators UserID
      * *********************************************************
     P RtvAdmUsrID     B                   Export

     D RtvAdmUsrID     PI                  like(StdNam)
      /free
       // -------------------------------------------------------
       // Return system administrators User ID.

       //return RtvDWprcopt(ZZpgm: 'JM0001': 1);
       return 'THAWKINS';

      /end-free
     P RtvAdmUsrID     E
      * *********************************************************
      * RtvAdmNam() -- Retrieve administrators name.
      * *********************************************************
     P RtvAdmNam       B                   Export

     D RtvAdmNam       PI                  like(StdStg)
      /free
       // -------------------------------------------------------
       // Return system administrators name.

       // return RtvUsrNam(RtvAdmUsrID());
       return 'Tim Hawkins';

      /end-free
     P RtvAdmNam       E
      * *********************************************************
      * RtvUsrEmlName() -- Retrieve users email name.
      * *********************************************************
     P RtvUsrEmlName   B                   Export

     Fusrpfp01  if   e           k disk    static

     D RtvUsrEmlName   PI                  like(StdStr)
     D  UserID                             like(StdNam)  const

     D i_usrpf         ds                  likerec(usrpf01r:*input) inz
      /free
       // -------------------------------------------------------
       // Retrieve user profile user name.

       chain (UserID) usrpf01r i_usrpf ;
       if %found;
          return i_usrpf.UPemail;
       else;
          return *blanks;
       endif;

      /end-free
     P RtvUsrEmlName   E
      * *********************************************************
      * RtvUsrEmlAddr() -- Retrieve users email address.
      * *********************************************************
     P RtvUsrEmlAddr   B                   Export

     Fusrpfp01  if   e           k disk    static

     D RtvUsrEmlAddr   PI                  like(StdStr)
     D  UserID                             like(StdNam)  const

     D i_usrpf         ds                  likerec(usrpf01r:*input) inz
      /free
       // -------------------------------------------------------
       // Retrieve user profile user name.

       chain (UserID) usrpf01r i_usrpf ;
       if %found;
          return %trim(i_usrpf.UPusrfnm) + ' ' + i_usrpf.UPusrlnm;
       else;
          return *blanks;
       endif;

      /end-free
     P RtvUsrEmlAddr   E
