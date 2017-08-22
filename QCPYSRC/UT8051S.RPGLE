      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Environment variable prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * PutEnvVar() -- Put environment variable.
      *
     D PutEnvVar       PR                  extproc('Qp0zPutEnvNoCCSID')
     D                                     like(StdInt)
     D  i_envVar                           like(StdPtr) value
     D                                     options(*trim:*string)
      * ---------------------------------------------------------
      * GetEnvVar() -- Get environment variable wrapper.
      *
     D GetEnvVar       PR         32767    varying
     D  EnvVarNam                    64    varying const
     D                                     options(*trim:*varsize)
      * ---------------------------------------------------------
      * GetEnv() -- Get environment variable.
      *
     D GetEnv          PR                  extproc('Qp0zGetEnvNoCCSID')
     D                                     like(StdPtr)
     D  i_envVar                           like(StdPtr) value
     D                                     options(*trim:*string)
      * ---------------------------------------------------------
      * GetEnvVarInd() -- Get environment variable as indicator.
      *
     D GetEnvVarInd    PR                  like(StdInd)
     D  EnvVarNam                    64    varying const
     D                                     options(*trim:*varsize)
      * ---------------------------------------------------------
      * DltEnvVar() -- Delete environment variable.
      *
     D DltEnvVar       PR
     D  EnvVarNam                    64    varying const
     D                                     options(*trim:*varsize)
      * ---------------------------------------------------------
      * IncEnvVar() -- Increment environment variable.
      *
     D IncEnvVar       PR                  like(StdInt)
     D  EnvVarNam                    64    varying const
      * ---------------------------------------------------------
      *  Global environment variable fields.
      *
     D EnvVarNam       s             64                   inz
     D pEnvVar         s                   like(StdPtr)   inz
     D EnvVar          s          32767    based(pEnvVar)
