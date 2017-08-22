      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Job Streamfile prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *
      *  DltJobsf() -- Delete job streamfile records
      *
     D DltJobsf        PR
     D   JobName                           like(StdNam)    const
     D   UserName                          like(StdNam)    const
     D   JobNumber                         like(StdJobNbr) const
      * ---------------------------------------------------------
      *
      *  WrtJobsf() -- Write job streamfile
      *
     D WrtJobsf        PR
     D   JobName                           like(StdNam)    const
     D   UserName                          like(StdNam)    const
     D   JobNumber                         like(StdJobNbr) const
     D   Stmf                              like(StdStr)    const
      * ---------------------------------------------------------
      *
      *  getJobsf() -- Get & delete job streamfile record.
      *
     D GetJobsf        PR                  like(StdStr)
     D   JobName                           like(StdNam)    const
     D   UserName                          like(StdNam)    const
     D   JobNumber                         like(StdJobNbr) const
