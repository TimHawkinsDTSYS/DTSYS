      /TITLE Utility, Job Streamfile (SrvPgm)
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
      ***********************************************************
      * DltJobsf -- Delete job streamfile records.
      ***********************************************************
     P DltJobsf        B                   Export

     F**jobsfp01  uf   e           k disk    static

     D DltJobsf        PI
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const

      /free
       // ---------------------------------------------------------
       // Delete job streamfile records.

       // dou not %found;
       //     delete (JobNam:JobUsr:JobNbr) jobsf01r;
       // enddo;

      /end-free
     P DltJobsf        E
      ***********************************************************
      * WrtJobsf -- Write job streamfile record.
      ***********************************************************
     P WrtJobsf        B                   Export

     F**jobsfp01  o    e             disk    static block(*no)

     D WrtJobsf        PI
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const
     D  Stmf                               like(StdStr)    const

     D** jobsf           ds                  likerec(jobsf01r:*output) inz
      /free
       // ---------------------------------------------------------
       // Write job streamfile record.

       // jobsf.JSjbna = JobNam;
       // jobsf.JSjbus = JobUsr;
       // jobsf.JSjbnb = JobNbr;
       // jobsf.JSstmf = Stmf;
       //
       // write jobsf01r jobsf;

       return;

      /end-free
     P WrtJobsf        E
      ***********************************************************
      * GetJobsf -- Get & delete job streamfile record.
      ***********************************************************
     P GetJobsf        B                   Export

     F**jobsfp01  uf   e           k disk    static

     D GetJobsf        PI                  like(StdStr)
     D  JobNam                             like(StdNam)    const
     D  JobUsr                             like(StdNam)    const
     D  JobNbr                             like(StdJobNbr) const

     D** jobsf           ds                  likerec(jobsf01r) inz
      /free
       // ---------------------------------------------------------
       // Get & delete job streamfile record.

       // chain (JobNam:JobUsr:JobNbr) jobsf01r jobsf;
       // if %found;
       //    delete jobsf01r;
       //    return jobsf.JSstmf;
       // else;
             return *blanks;
       // endif;

      /end-free
     P GetJobsf        E
