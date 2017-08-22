      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SQL prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  SbmDynSQLstm() -- Submit dynamic SQL statement
      *
     D SbmDynSQLstm    PR
     D   JobNam                            like(StdNam) value
     D   SQLstmt                           like(StdSQL) value
      * ---------------------------------------------------------
      *
      *  RunDynSQLstm() -- Run dynamic SQL statement
      *
     D RunDynSQLstm    PR
     D   SQLstmt                           like(StdSQL) value
      * ---------------------------------------------------------
      *
      *  Quote() -- Quote string for SQL statement.
      *
     D Quote           pr          1026a   varying
     D  string                     1024a   const varying
      * ---------------------------------------------------------
      *
      *  SwapAscDesc() -- Swap ascending/descending in an SQL string.
      *
     D SwapAscDesc     PR                  like(StdSQL)
     D  ChrString                          like(StdSQL)
