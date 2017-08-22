      /TITLE Utility, User Profile DB (SrvPgm)
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
      /copy qcpysrc,Dspec
      ***********************************************************
      * RtvQCusr() -- Retrieve quality control user.
      ***********************************************************
     P RtvQCusr        B                   Export
      *
     D RtvQCusr        PI                  like(QMtque)
     D  PLbkgma                            like(bkgma ) value
      *
     D PLtque          S                   like(QMtque)
      *
     D bkgma         e ds                  extname(bkgmap01) template
     D quema         e ds                  extname(quemap01) template
      * ---------------------------------------------------------
      * Retrieve the QC user.
      *
     C                   call      'UP0501R'
     C                   parm                    PLbkgma
     C                   parm                    PLtque
      *
     C                   return    PLtque
      *
     P RtvQCusr        E
      ***********************************************************
      * RtvBOusr() -- Retrieve booking operator user.
      ***********************************************************
     P RtvBOusr        B                   Export
      *
     D RtvBOusr        PI                  like(QMtque)
     D  PLbkgma                            like(bkgma ) value
      *
     D PLtque          S                   like(QMtque)
      *
     D bkgma         e ds                  extname(bkgmap01) template
     D quema         e ds                  extname(quemap01) template
      * ---------------------------------------------------------
      * Retrieve the BO user.
      *
     C                   call      'UP0502R'
     C                   parm                    PLbkgma
     C                   parm                    PLtque
      *
     C                   return    PLtque
      *
     P RtvBOusr        E
