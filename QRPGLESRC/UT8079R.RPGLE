      /TITLE Utility, Journaling (SrvPgm)
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
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8079S
      * *********************************************************
      * SndJrnEnt() -- Send journal entry.
      * *********************************************************
     P SndJrnEnt       B                   Export
      *
     D SndJrnEnt       pi
     D  JrnNam                             like(StdNam) const
     D  JrnNamLib                          like(StdNam) const
     D  JrnEntInf                  4096a   options(*varsize) const
     D  JrnEntDta                 32766a   options(*varsize) const
      *
     D  JrnNam20       s                   like(StdNamLib)
      * --------------------------------------------------------
      *
      *   Send journal entry.
      *
      /free

       // Journal name and library.
       JrnNam20 = JrnNam + JrnNamLib;

       // Journal entry type is U.

       // Journal entry code.
       SjJrnEntInf.SjInfDta = JrnEntInf;

       // Send journal entry.
       SndJrnE(JrnNam20:
               SjJrnEntInf:
                     JrnEntDta:
               %size(JrnEntDta):
               dsEC);

       return;

      /end-free
      *
     P SndJrnEnt       E
