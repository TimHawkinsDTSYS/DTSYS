      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Hex prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  CvtChrToHex() -- Convert Character to Hex.
      *
     D CvtChrToHex     pr         32767
     D  input                     16384    options(*varsize) const
      *
     D cvthc           pr                  extproc('cvthc')
     D  output                    32767    options(*varsize)
     D  input                     16384    options(*varsize) const
     D  outputlen                          like(StdInt)      value
      * ---------------------------------------------------------
      *  CvtHexToChr() -- Convert Hex to Character.
      *
     D CvtHexToChr     pr         16384
     D  input                     32767    options(*varsize) const
      *
     D cvtch           pr                  extproc('cvtch')
     D  output                    16384    options(*varsize)
     D  input                     32767    options(*varsize) const
     D  outputlen                          like(StdInt)      value
