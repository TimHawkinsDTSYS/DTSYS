      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Standard RPG "D" Specifications for SQL.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     D SQLnumISO       s              8  0 inz
     D SQLnumHMS       s              6  0 inz
     D SQLtimstp       s               z   inz
     D SQLstmt         s           1024    inz
     D SQLuser         s             10    inz
     D SQLpwd          s             10    inz
      *
     D SQLtoday        s                   like(SQLnumISO) inz
     D SQLtime         s                   like(SQLnumHMS) inz
