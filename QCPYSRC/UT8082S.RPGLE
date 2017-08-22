      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * HTML/XML prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  rmvWhiteSpace() -- Remove white space.
      *
     D rmvWhiteSpace   pr         65535a   varying
     D   input                    65535a   varying const
      *
      *  rmvNonTypeable() -- Remove non-typeable characters.
      *
     D rmvNonTypeable  pr         65535a   varying
     D   input                    65535a   varying const
      *
      *  RplXMLsplact() -- Replace XML special with actual.
      *
     D RplXMLsplact    pr         65535a   varying
     D  InString                  65535a   varying value
     D  InPrefix                           like(StdChr)
     D                                     const options(*omit:*nopass)
      *
      *  RplXMLactspl() -- Replace XML actual with special.
      *
0019 D RplXMLactspl    PR         65535a   varying
0020 D  InString                  65535a   varying value
     D  InPrefix                           like(StdChr)
     D                                     const options(*omit:*nopass)
      *
      *  RplXMLsplpfx() -- Replace XML special character prefix.
      *
0019 D RplXMLsplpfx    PR         65535a   varying
0020 D  InString                  65535a   varying value
     D  InFmPrefix                         like(StdChr) const
     D  InToPrefix                         like(StdChr) const
