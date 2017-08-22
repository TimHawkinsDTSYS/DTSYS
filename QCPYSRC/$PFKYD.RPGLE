      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  PROGRAM FUNCTION KEYS DISPLAYED.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PFKYD        BEGSR
      *
     C     *INKY         IFEQ      *ON                                          CHECK FOR
     C                   ADD       1             PFKYSQ            3 0           PFKY-24
     C                   END                                                     PRESSED.
      *
     C     PLMODE        IFEQ      'DISPLAY'                                    DEFAULT.
     C   LR              MOVE      *BLANKS       PLMODE            8
     C                   MOVE      *ON           INQIRY            1
     C                   END
      *
     C     PLMODE        IFNE      'DISPLAY'                                    DEFAULT.
     C                   MOVE      *OFF          INQIRY
     C                   END
      *
     C     PFKYSQ        IFEQ      2                                            IF NO PF KEYS
     C     INQIRY        IFEQ      *OFF                                          IN 2RD SET,
     C     PFKY(4)       ANDEQ     *BLANKS                                       RESET TO
     C     INQIRY        OREQ      *ON                                           1ST SET.
     C     PFKY(13)      ANDEQ     *BLANKS
     C                   Z-ADD     1             PFKYSQ
     C                   END
     C                   END
      *
     C     PFKYSQ        IFEQ      3                                            IF NO PF KEYS
     C     INQIRY        IFEQ      *OFF                                          IN 3RD SET,
     C     PFKY(7)       ANDEQ     *BLANKS                                       RESET TO
     C     INQIRY        OREQ      *ON                                           1ST SET.
     C     PFKY(16)      ANDEQ     *BLANKS
     C                   Z-ADD     1             PFKYSQ
     C                   END
     C                   END
      *
     C     PFKYSQ        IFLT      1                                            CHECK FOR
     C     PFKYSQ        ORGT      3                                             OUT OF BOUNDS.
     C                   Z-ADD     1             PFKYSQ
     C                   END
      *
     C     PFKYSQ        IFEQ      1                                            DESCRIPTION
     C                   Z-ADD     1             PFKY1             3 0           COUNT = 1.
     C                   Z-ADD     2             PFKY2             3 0
     C                   ELSE
     C     PFKYSQ        IFEQ      2                                            DESCRIPTION
     C                   Z-ADD     4             PFKY1                           COUNT = 2.
     C                   Z-ADD     5             PFKY2
     C                   ELSE
     C     PFKYSQ        IFEQ      3                                            DESCRIPTION
     C                   Z-ADD     7             PFKY1                           COUNT = 3.
     C                   Z-ADD     8             PFKY2
     C                   END
     C                   END
     C                   END
      *
     C     INQIRY        IFEQ      *ON                                          INQUIRY.
      *
     C     PFKYSQ        IFEQ      1                                            DESCRIPTION
     C                   Z-ADD     10            PFKY1                           COUNT = 1.
     C                   Z-ADD     11            PFKY2
     C                   ELSE
     C     PFKYSQ        IFEQ      2                                            DESCRIPTION
     C                   Z-ADD     13            PFKY1                           COUNT = 2.
     C                   Z-ADD     14            PFKY2
     C                   ELSE
     C     PFKYSQ        IFEQ      3                                            DESCRIPTION
     C                   Z-ADD     16            PFKY1                           COUNT = 3.
     C                   Z-ADD     17            PFKY2
     C                   END
     C                   END
     C                   END
      *
     C                   END
      *
     C                   MOVE      PFKY(PFKY1)   PFKY01
     C                   MOVE      PFKY(PFKY2)   PFKY02
      *
     CSR   #PFKYD        ENDSR
