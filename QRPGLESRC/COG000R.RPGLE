      /TITLE Collect Object Growth
      *
      * P: PARMS OPTION(*NOXREF)
      *
      * S:
      *
      * C: 91/12/03  RCTHAWK
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      *
     FDSPOBJDL2 UF   E           K DISK    RENAME(QLIDOBJD:DSPOBJD02L)
     FDSPOBJDL3 IF   E           K DISK    RENAME(QLIDOBJD:DSPOBJD03L)
     FDSPFDL3   IF   E           K DISK    RENAME(QWHFDMBR:DSPFD03L)
     FCOG000P   UF A E           K DISK
     FCOG000L1  UF   E           K DISK    RENAME(COG000R:COG000R01L)
     FCOG010P   UF A E           K DISK
     FCOG010L1  UF   E           K DISK    RENAME(COG010R:COG010R01L)
     FCOG020P   UF A E           K DISK
     FCOG020L1  UF   E           K DISK    RENAME(COG020R:COG020R01L)
     FCOG030P   UF A E           K DISK
     FCOG030L1  UF   E           K DISK    RENAME(COG030R:COG030R01L)
      *
     D DSPOBJD       E DS                  EXTNAME(QADSPOBJ)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
     D SIZE            S                   DIM(52) LIKE(ODOBSZ)                 C0035 Sel Desc
     D RECS            S                   DIM(52) LIKE(MBNRCD)                 C0035 Sel Desc
     D MBRS            S                   DIM(52) LIKE(MBNOMB)                 C0035 Sel Desc
      *
     ICOG020R01L
     I              OGSIZE01                    SIZE(01)
     I              OGSIZE02                    SIZE(02)
     I              OGSIZE03                    SIZE(03)
     I              OGSIZE04                    SIZE(04)
     I              OGSIZE05                    SIZE(05)
     I              OGSIZE06                    SIZE(06)
     I              OGSIZE07                    SIZE(07)
     I              OGSIZE08                    SIZE(08)
     I              OGSIZE09                    SIZE(09)
     I              OGSIZE10                    SIZE(10)
     I              OGSIZE11                    SIZE(11)
     I              OGSIZE12                    SIZE(12)
     I              OGRECS01                    RECS(01)
     I              OGRECS02                    RECS(02)
     I              OGRECS03                    RECS(03)
     I              OGRECS04                    RECS(04)
     I              OGRECS05                    RECS(05)
     I              OGRECS06                    RECS(06)
     I              OGRECS07                    RECS(07)
     I              OGRECS08                    RECS(08)
     I              OGRECS09                    RECS(09)
     I              OGRECS10                    RECS(10)
     I              OGRECS11                    RECS(11)
     I              OGRECS12                    RECS(12)
     I              OGMBRS01                    MBRS(01)
     I              OGMBRS02                    MBRS(02)
     I              OGMBRS03                    MBRS(03)
     I              OGMBRS04                    MBRS(04)
     I              OGMBRS05                    MBRS(05)
     I              OGMBRS06                    MBRS(06)
     I              OGMBRS07                    MBRS(07)
     I              OGMBRS08                    MBRS(08)
     I              OGMBRS09                    MBRS(09)
     I              OGMBRS10                    MBRS(10)
     I              OGMBRS11                    MBRS(11)
     I              OGMBRS12                    MBRS(12)
      *
     ICOG030R01L
     I              OGSIZE01                    SIZE(01)
     I              OGSIZE02                    SIZE(02)
     I              OGSIZE03                    SIZE(03)
     I              OGSIZE04                    SIZE(04)
     I              OGSIZE05                    SIZE(05)
     I              OGSIZE06                    SIZE(06)
     I              OGSIZE07                    SIZE(07)
     I              OGSIZE08                    SIZE(08)
     I              OGSIZE09                    SIZE(09)
     I              OGSIZE10                    SIZE(10)
     I              OGSIZE11                    SIZE(11)
     I              OGSIZE12                    SIZE(12)
     I              OGSIZE13                    SIZE(13)
     I              OGSIZE14                    SIZE(14)
     I              OGSIZE15                    SIZE(15)
     I              OGSIZE16                    SIZE(16)
     I              OGSIZE17                    SIZE(17)
     I              OGSIZE18                    SIZE(18)
     I              OGSIZE19                    SIZE(19)
     I              OGSIZE20                    SIZE(20)
     I              OGSIZE21                    SIZE(21)
     I              OGSIZE22                    SIZE(22)
     I              OGSIZE23                    SIZE(23)
     I              OGSIZE24                    SIZE(24)
     I              OGSIZE25                    SIZE(25)
     I              OGSIZE26                    SIZE(26)
     I              OGSIZE27                    SIZE(27)
     I              OGSIZE28                    SIZE(28)
     I              OGSIZE29                    SIZE(29)
     I              OGSIZE30                    SIZE(30)
     I              OGSIZE31                    SIZE(31)
     I              OGSIZE32                    SIZE(32)
     I              OGSIZE33                    SIZE(33)
     I              OGSIZE34                    SIZE(34)
     I              OGSIZE35                    SIZE(35)
     I              OGSIZE36                    SIZE(36)
     I              OGSIZE37                    SIZE(37)
     I              OGSIZE38                    SIZE(38)
     I              OGSIZE39                    SIZE(39)
     I              OGSIZE40                    SIZE(40)
     I              OGSIZE41                    SIZE(41)
     I              OGSIZE42                    SIZE(42)
     I              OGSIZE43                    SIZE(43)
     I              OGSIZE44                    SIZE(44)
     I              OGSIZE45                    SIZE(45)
     I              OGSIZE46                    SIZE(46)
     I              OGSIZE47                    SIZE(47)
     I              OGSIZE48                    SIZE(48)
     I              OGSIZE49                    SIZE(49)
     I              OGSIZE50                    SIZE(50)
     I              OGSIZE51                    SIZE(51)
     I              OGSIZE52                    SIZE(52)
     I              OGRECS01                    RECS(01)
     I              OGRECS02                    RECS(02)
     I              OGRECS03                    RECS(03)
     I              OGRECS04                    RECS(04)
     I              OGRECS05                    RECS(05)
     I              OGRECS06                    RECS(06)
     I              OGRECS07                    RECS(07)
     I              OGRECS08                    RECS(08)
     I              OGRECS09                    RECS(09)
     I              OGRECS10                    RECS(10)
     I              OGRECS11                    RECS(11)
     I              OGRECS12                    RECS(12)
     I              OGRECS13                    RECS(13)
     I              OGRECS14                    RECS(14)
     I              OGRECS15                    RECS(15)
     I              OGRECS16                    RECS(16)
     I              OGRECS17                    RECS(17)
     I              OGRECS18                    RECS(18)
     I              OGRECS19                    RECS(19)
     I              OGRECS20                    RECS(20)
     I              OGRECS21                    RECS(21)
     I              OGRECS22                    RECS(22)
     I              OGRECS23                    RECS(23)
     I              OGRECS24                    RECS(24)
     I              OGRECS25                    RECS(25)
     I              OGRECS26                    RECS(26)
     I              OGRECS27                    RECS(27)
     I              OGRECS28                    RECS(28)
     I              OGRECS29                    RECS(29)
     I              OGRECS30                    RECS(30)
     I              OGRECS31                    RECS(31)
     I              OGRECS32                    RECS(32)
     I              OGRECS33                    RECS(33)
     I              OGRECS34                    RECS(34)
     I              OGRECS35                    RECS(35)
     I              OGRECS36                    RECS(36)
     I              OGRECS37                    RECS(37)
     I              OGRECS38                    RECS(38)
     I              OGRECS39                    RECS(39)
     I              OGRECS40                    RECS(40)
     I              OGRECS41                    RECS(41)
     I              OGRECS42                    RECS(42)
     I              OGRECS43                    RECS(43)
     I              OGRECS44                    RECS(44)
     I              OGRECS45                    RECS(45)
     I              OGRECS46                    RECS(46)
     I              OGRECS47                    RECS(47)
     I              OGRECS48                    RECS(48)
     I              OGRECS49                    RECS(49)
     I              OGRECS50                    RECS(50)
     I              OGRECS51                    RECS(51)
     I              OGRECS52                    RECS(52)
     I              OGMBRS01                    MBRS(01)
     I              OGMBRS02                    MBRS(02)
     I              OGMBRS03                    MBRS(03)
     I              OGMBRS04                    MBRS(04)
     I              OGMBRS05                    MBRS(05)
     I              OGMBRS06                    MBRS(06)
     I              OGMBRS07                    MBRS(07)
     I              OGMBRS08                    MBRS(08)
     I              OGMBRS09                    MBRS(09)
     I              OGMBRS10                    MBRS(10)
     I              OGMBRS11                    MBRS(11)
     I              OGMBRS12                    MBRS(12)
     I              OGMBRS13                    MBRS(13)
     I              OGMBRS14                    MBRS(14)
     I              OGMBRS15                    MBRS(15)
     I              OGMBRS16                    MBRS(16)
     I              OGMBRS17                    MBRS(17)
     I              OGMBRS18                    MBRS(18)
     I              OGMBRS19                    MBRS(19)
     I              OGMBRS20                    MBRS(20)
     I              OGMBRS21                    MBRS(21)
     I              OGMBRS22                    MBRS(22)
     I              OGMBRS23                    MBRS(23)
     I              OGMBRS24                    MBRS(24)
     I              OGMBRS25                    MBRS(25)
     I              OGMBRS26                    MBRS(26)
     I              OGMBRS27                    MBRS(27)
     I              OGMBRS28                    MBRS(28)
     I              OGMBRS29                    MBRS(29)
     I              OGMBRS30                    MBRS(30)
     I              OGMBRS31                    MBRS(31)
     I              OGMBRS32                    MBRS(32)
     I              OGMBRS33                    MBRS(33)
     I              OGMBRS34                    MBRS(34)
     I              OGMBRS35                    MBRS(35)
     I              OGMBRS36                    MBRS(36)
     I              OGMBRS37                    MBRS(37)
     I              OGMBRS38                    MBRS(38)
     I              OGMBRS39                    MBRS(39)
     I              OGMBRS40                    MBRS(40)
     I              OGMBRS41                    MBRS(41)
     I              OGMBRS42                    MBRS(42)
     I              OGMBRS43                    MBRS(43)
     I              OGMBRS44                    MBRS(44)
     I              OGMBRS45                    MBRS(45)
     I              OGMBRS46                    MBRS(46)
     I              OGMBRS47                    MBRS(47)
     I              OGMBRS48                    MBRS(48)
     I              OGMBRS49                    MBRS(49)
     I              OGMBRS50                    MBRS(50)
     I              OGMBRS51                    MBRS(51)
     I              OGMBRS52                    MBRS(52)
      *
     ICOG020R
     I              OGSIZE01                    SIZE(01)
     I              OGSIZE02                    SIZE(02)
     I              OGSIZE03                    SIZE(03)
     I              OGSIZE04                    SIZE(04)
     I              OGSIZE05                    SIZE(05)
     I              OGSIZE06                    SIZE(06)
     I              OGSIZE07                    SIZE(07)
     I              OGSIZE08                    SIZE(08)
     I              OGSIZE09                    SIZE(09)
     I              OGSIZE10                    SIZE(10)
     I              OGSIZE11                    SIZE(11)
     I              OGSIZE12                    SIZE(12)
     I              OGRECS01                    RECS(01)
     I              OGRECS02                    RECS(02)
     I              OGRECS03                    RECS(03)
     I              OGRECS04                    RECS(04)
     I              OGRECS05                    RECS(05)
     I              OGRECS06                    RECS(06)
     I              OGRECS07                    RECS(07)
     I              OGRECS08                    RECS(08)
     I              OGRECS09                    RECS(09)
     I              OGRECS10                    RECS(10)
     I              OGRECS11                    RECS(11)
     I              OGRECS12                    RECS(12)
     I              OGMBRS01                    MBRS(01)
     I              OGMBRS02                    MBRS(02)
     I              OGMBRS03                    MBRS(03)
     I              OGMBRS04                    MBRS(04)
     I              OGMBRS05                    MBRS(05)
     I              OGMBRS06                    MBRS(06)
     I              OGMBRS07                    MBRS(07)
     I              OGMBRS08                    MBRS(08)
     I              OGMBRS09                    MBRS(09)
     I              OGMBRS10                    MBRS(10)
     I              OGMBRS11                    MBRS(11)
     I              OGMBRS12                    MBRS(12)
      *
     ICOG030R
     I              OGSIZE01                    SIZE(01)
     I              OGSIZE02                    SIZE(02)
     I              OGSIZE03                    SIZE(03)
     I              OGSIZE04                    SIZE(04)
     I              OGSIZE05                    SIZE(05)
     I              OGSIZE06                    SIZE(06)
     I              OGSIZE07                    SIZE(07)
     I              OGSIZE08                    SIZE(08)
     I              OGSIZE09                    SIZE(09)
     I              OGSIZE10                    SIZE(10)
     I              OGSIZE11                    SIZE(11)
     I              OGSIZE12                    SIZE(12)
     I              OGSIZE13                    SIZE(13)
     I              OGSIZE14                    SIZE(14)
     I              OGSIZE15                    SIZE(15)
     I              OGSIZE16                    SIZE(16)
     I              OGSIZE17                    SIZE(17)
     I              OGSIZE18                    SIZE(18)
     I              OGSIZE19                    SIZE(19)
     I              OGSIZE20                    SIZE(20)
     I              OGSIZE21                    SIZE(21)
     I              OGSIZE22                    SIZE(22)
     I              OGSIZE23                    SIZE(23)
     I              OGSIZE24                    SIZE(24)
     I              OGSIZE25                    SIZE(25)
     I              OGSIZE26                    SIZE(26)
     I              OGSIZE27                    SIZE(27)
     I              OGSIZE28                    SIZE(28)
     I              OGSIZE29                    SIZE(29)
     I              OGSIZE30                    SIZE(30)
     I              OGSIZE31                    SIZE(31)
     I              OGSIZE32                    SIZE(32)
     I              OGSIZE33                    SIZE(33)
     I              OGSIZE34                    SIZE(34)
     I              OGSIZE35                    SIZE(35)
     I              OGSIZE36                    SIZE(36)
     I              OGSIZE37                    SIZE(37)
     I              OGSIZE38                    SIZE(38)
     I              OGSIZE39                    SIZE(39)
     I              OGSIZE40                    SIZE(40)
     I              OGSIZE41                    SIZE(41)
     I              OGSIZE42                    SIZE(42)
     I              OGSIZE43                    SIZE(43)
     I              OGSIZE44                    SIZE(44)
     I              OGSIZE45                    SIZE(45)
     I              OGSIZE46                    SIZE(46)
     I              OGSIZE47                    SIZE(47)
     I              OGSIZE48                    SIZE(48)
     I              OGSIZE49                    SIZE(49)
     I              OGSIZE50                    SIZE(50)
     I              OGSIZE51                    SIZE(51)
     I              OGSIZE52                    SIZE(52)
     I              OGRECS01                    RECS(01)
     I              OGRECS02                    RECS(02)
     I              OGRECS03                    RECS(03)
     I              OGRECS04                    RECS(04)
     I              OGRECS05                    RECS(05)
     I              OGRECS06                    RECS(06)
     I              OGRECS07                    RECS(07)
     I              OGRECS08                    RECS(08)
     I              OGRECS09                    RECS(09)
     I              OGRECS10                    RECS(10)
     I              OGRECS11                    RECS(11)
     I              OGRECS12                    RECS(12)
     I              OGRECS13                    RECS(13)
     I              OGRECS14                    RECS(14)
     I              OGRECS15                    RECS(15)
     I              OGRECS16                    RECS(16)
     I              OGRECS17                    RECS(17)
     I              OGRECS18                    RECS(18)
     I              OGRECS19                    RECS(19)
     I              OGRECS20                    RECS(20)
     I              OGRECS21                    RECS(21)
     I              OGRECS22                    RECS(22)
     I              OGRECS23                    RECS(23)
     I              OGRECS24                    RECS(24)
     I              OGRECS25                    RECS(25)
     I              OGRECS26                    RECS(26)
     I              OGRECS27                    RECS(27)
     I              OGRECS28                    RECS(28)
     I              OGRECS29                    RECS(29)
     I              OGRECS30                    RECS(30)
     I              OGRECS31                    RECS(31)
     I              OGRECS32                    RECS(32)
     I              OGRECS33                    RECS(33)
     I              OGRECS34                    RECS(34)
     I              OGRECS35                    RECS(35)
     I              OGRECS36                    RECS(36)
     I              OGRECS37                    RECS(37)
     I              OGRECS38                    RECS(38)
     I              OGRECS39                    RECS(39)
     I              OGRECS40                    RECS(40)
     I              OGRECS41                    RECS(41)
     I              OGRECS42                    RECS(42)
     I              OGRECS43                    RECS(43)
     I              OGRECS44                    RECS(44)
     I              OGRECS45                    RECS(45)
     I              OGRECS46                    RECS(46)
     I              OGRECS47                    RECS(47)
     I              OGRECS48                    RECS(48)
     I              OGRECS49                    RECS(49)
     I              OGRECS50                    RECS(50)
     I              OGRECS51                    RECS(51)
     I              OGRECS52                    RECS(52)
     I              OGMBRS01                    MBRS(01)
     I              OGMBRS02                    MBRS(02)
     I              OGMBRS03                    MBRS(03)
     I              OGMBRS04                    MBRS(04)
     I              OGMBRS05                    MBRS(05)
     I              OGMBRS06                    MBRS(06)
     I              OGMBRS07                    MBRS(07)
     I              OGMBRS08                    MBRS(08)
     I              OGMBRS09                    MBRS(09)
     I              OGMBRS10                    MBRS(10)
     I              OGMBRS11                    MBRS(11)
     I              OGMBRS12                    MBRS(12)
     I              OGMBRS13                    MBRS(13)
     I              OGMBRS14                    MBRS(14)
     I              OGMBRS15                    MBRS(15)
     I              OGMBRS16                    MBRS(16)
     I              OGMBRS17                    MBRS(17)
     I              OGMBRS18                    MBRS(18)
     I              OGMBRS19                    MBRS(19)
     I              OGMBRS20                    MBRS(20)
     I              OGMBRS21                    MBRS(21)
     I              OGMBRS22                    MBRS(22)
     I              OGMBRS23                    MBRS(23)
     I              OGMBRS24                    MBRS(24)
     I              OGMBRS25                    MBRS(25)
     I              OGMBRS26                    MBRS(26)
     I              OGMBRS27                    MBRS(27)
     I              OGMBRS28                    MBRS(28)
     I              OGMBRS29                    MBRS(29)
     I              OGMBRS30                    MBRS(30)
     I              OGMBRS31                    MBRS(31)
     I              OGMBRS32                    MBRS(32)
     I              OGMBRS33                    MBRS(33)
     I              OGMBRS34                    MBRS(34)
     I              OGMBRS35                    MBRS(35)
     I              OGMBRS36                    MBRS(36)
     I              OGMBRS37                    MBRS(37)
     I              OGMBRS38                    MBRS(38)
     I              OGMBRS39                    MBRS(39)
     I              OGMBRS40                    MBRS(40)
     I              OGMBRS41                    MBRS(41)
     I              OGMBRS42                    MBRS(42)
     I              OGMBRS43                    MBRS(43)
     I              OGMBRS44                    MBRS(44)
     I              OGMBRS45                    MBRS(45)
     I              OGMBRS46                    MBRS(46)
     I              OGMBRS47                    MBRS(47)
     I              OGMBRS48                    MBRS(48)
     I              OGMBRS49                    MBRS(49)
     I              OGMBRS50                    MBRS(50)
     I              OGMBRS51                    MBRS(51)
     I              OGMBRS52                    MBRS(52)
      *
     C                   EXSR      $DetCurPer
     C                   EXSR      $ClrLibSiz
     C                   EXSR      $AddLibSiz
      *
     C                   EXSR      $ClrCurTtl
     C                   EXSR      $SetCurTtl
      *
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Determine current week/month (52 and 12)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DetCurPer    BEGSR
      *
     C     *LOVAL        SETLL     DSPOBJD03L
     C                   READ      DSPOBJD03L                             99
      *
     C     *IN99         IFEQ      *OFF
     C                   MOVE      ODDDAT        CvtFrmDat
     C                   MOVEL(P)  '*JOB'        CvtFrmFmt
     C                   MOVEL(P)  '*JUL'        CvtToFmt
     C                   EXSR      $CVTDT
     C                   MOVE      CvtToDteWK    CurWeek
      *
     C                   MOVE      ODDDAT        CvtFrmDat
     C                   MOVEL(P)  '*JOB'        CvtFrmFmt
     C                   MOVEL(P)  '*MDYY'       CvtToFmt
     C                   EXSR      $CVTDT
     C                   MOVE      CvtToDteMM    CurMonth
     C                   MOVE      CvtToDteYYYY  CurYear
     C                   ENDIF
      *
     CSR   #DetCurPer    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Clear library size.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ClrLibSiz    BEGSR
      *
     C                   MOVEL(P)  '*LIB'        OGTYPE
     C     OGTYPE        SETLL     DSPOBJD02L
     C     OGTYPE        READE     DSPOBJD02L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   CLEAR                   ODOBSZ
     C                   UPDATE    DSPOBJD02L
     C     OGTYPE        READE     DSPOBJD02L                             99
     C                   ENDDO
      *
     CSR   #ClrLibSiz    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Add up library size in MB.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $AddLibSiz    BEGSR
      *
     C                   MOVEL(P)  '*LIB'        OGTYPE
     C     OGTYPE        SETLL     DSPOBJD02L
     C     OGTYPE        READE     DSPOBJD02L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      DSPOBJD       LIB_DSPOBJ
     C                   MOVE      ODOBNM        LIB_ODOBNM
     C                   CLEAR                   LIB_ODOBSZ
     C     LIB_ODOBNM    SETLL     DSPOBJD03L
     C     LIB_ODOBNM    READE     DSPOBJD03L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   ADD       ODOBSZ        LIB_ODOBSZ
     C     LIB_ODOBNM    READE     DSPOBJD03L                             99
     C                   ENDDO
      *
     C                   MOVE      LIB_DSPOBJ    DSPOBJD
     C     LIB_ODOBSZ    DIV       1000000       ODOBSZ
     C                   UPDATE    DSPOBJD02L
     C     OGTYPE        READE     DSPOBJD02L                             99
     C                   ENDDO
      *
     CSR   #AddLibSiz    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Clear current totals (might be a rerun).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ClrCurTtl    BEGSR
      *
     C     YearMonth     SETLL     COG000R01L
     C     YearMonth     READE     COG000R01L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   CLEAR                   OGSIZE
     C                   CLEAR                   OGRECS
     C                   CLEAR                   OGMBRS
     C                   UPDATE    COG000R01L
     C     YearMonth     READE     COG000R01L                             99
     C                   ENDDO
      *
     C     YearWeek      SETLL     COG010R01L
     C     YearWeek      READE     COG010R01L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   CLEAR                   OGSIZE
     C                   CLEAR                   OGRECS
     C                   CLEAR                   OGMBRS
     C                   UPDATE    COG010R01L
     C     YearWeek      READE     COG010R01L                             99
     C                   ENDDO
      *
     C     CurYear       SETLL     COG020R01L
     C     CurYear       READE     COG020R01L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   CLEAR                   SIZE(CurMonth)
     C                   CLEAR                   RECS(CurMonth)
     C                   CLEAR                   MBRS(CurMonth)
     C                   UPDATE    COG020R01L
     C     CurYear       READE     COG020R01L                             99
     C                   ENDDO
      *
     C     CurYear       SETLL     COG030R01L
     C     CurYear       READE     COG030R01L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C                   CLEAR                   SIZE(CurWeek)
     C                   CLEAR                   RECS(CurWeek)
     C                   CLEAR                   MBRS(CurWeek)
     C                   UPDATE    COG030R01L
     C     CurYear       READE     COG030R01L                             99
     C                   ENDDO
      *
     CSR   #ClrCurTtl    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Set current totals.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SetCurTtl    BEGSR
      *
     C     *LOVAL        SETLL     DSPOBJD03L
     C                   READ      DSPOBJD03L                             99
      *
     C     *IN99         DOWEQ     *OFF
     C     ODOBTP        IFNE      '*LIB'
     C     ODOBSZ        ANDGT     MinSize
     C     ODOBTP        OREQ      '*LIB'
     C     ODOBSZ        ANDGT     MinSizeMB
     C                   EXSR      $SumObj
     C                   EXSR      $UpdSngMon
     C                   EXSR      $UpdSngWek
     C                   EXSR      $UpdMltMon
     C                   EXSR      $UpdMltWek
     C                   ENDIF
     C                   READ      DSPOBJD03L                             99
     C                   ENDDO
      *
     CSR   #SetCurTtl    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Summarize object
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SumObj       BEGSR
      *
     C                   CLEAR                   CurSize
     C                   CLEAR                   CurRecs
     C                   CLEAR                   CurMbrs
      *
      *    Libraries have already summarized into MB.
      *
     C     ODOBTP        IFNE      '*LIB'
     C                   DIV       1000000       ODOBSZ
     C                   ENDIF
      *
     C                   ADD       ODOBSZ        CurSize
      *
     C     FDKY02        SETLL     DSPFD03L
     C     FDKY02        READE     DSPFD03L                               99
     C     *IN99         IFEQ      *OFF
     C                   ADD       MBNOMB        CurMbrs
     C                   ENDIF
      *
     C     *IN99         DOWEQ     *OFF
     C                   ADD       MBNRCD        CurRecs
     C     FDKY02        READE     DSPFD03L                               99
     C                   ENDDO
      *
     CSR   #SumObj       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Update single record month totals.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UpdSngMon    BEGSR
      *
     C     COGKY05m      CHAIN     COG000R                            99
     C     *IN99         IFEQ      *ON
     C                   CLEAR                   COG000R
     C                   MOVE      ODLBNM        OGLIB
     C                   MOVE      ODOBNM        OGOBJ
     C                   MOVE      ODOBTP        OGTYPE
     C                   MOVE      CurYear       OGYEAR
     C                   MOVE      CurMonth      OGMONTH
     C                   MOVE      ODOBAT        OGATTR
     C                   MOVE      ODOBOW        OGOWNR
     C                   MOVE      ODOBTX        OGTEXT
     C                   MOVE      *ON           WRITE
     C                   ELSE
     C                   MOVE      *OFF          WRITE
     C                   ENDIF
      *
     C                   ADD       CurSize       OGSIZE
     C                   ADD       CurMbrs       OGMBRS
     C                   ADD       CurRecs       OGRECS
      *
     C     WRITE         IFEQ      *ON
     C                   WRITE     COG000R
     C                   ELSE
     C                   UPDATE    COG000R
     C                   ENDIF
      *
     CSR   #UpdSngMon    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Update single record week totals.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UpdSngWek    BEGSR
      *
     C     COGKY05w      CHAIN     COG010R                            99
     C     *IN99         IFEQ      *ON
     C                   CLEAR                   COG010R
     C                   MOVE      ODLBNM        OGLIB
     C                   MOVE      ODOBNM        OGOBJ
     C                   MOVE      ODOBTP        OGTYPE
     C                   MOVE      CurYear       OGYEAR
     C                   MOVE      CurWeek       OGWEEK
     C                   MOVE      ODOBAT        OGATTR
     C                   MOVE      ODOBOW        OGOWNR
     C                   MOVE      ODOBTX        OGTEXT
     C                   MOVE      *ON           WRITE
     C                   ELSE
     C                   MOVE      *OFF          WRITE
     C                   ENDIF
      *
     C                   ADD       CurSize       OGSIZE
     C                   ADD       CurMbrs       OGMBRS
     C                   ADD       CurRecs       OGRECS
      *
     C     WRITE         IFEQ      *ON
     C                   WRITE     COG010R
     C                   ELSE
     C                   UPDATE    COG010R
     C                   ENDIF
      *
     CSR   #UpdSngWek    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Update multiple record month totals.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UpdMltMon    BEGSR
      *
     C     COGKY04       CHAIN     COG020R                            99
     C     *IN99         IFEQ      *ON
     C                   CLEAR                   COG020R
     C                   MOVE      ODLBNM        OGLIB
     C                   MOVE      ODOBNM        OGOBJ
     C                   MOVE      ODOBTP        OGTYPE
     C                   MOVE      CurYear       OGYEAR
     C                   MOVE      ODOBAT        OGATTR
     C                   MOVE      ODOBOW        OGOWNR
     C                   MOVE      ODOBTX        OGTEXT
     C                   MOVE      *ON           WRITE
     C                   ELSE
     C                   MOVE      *OFF          WRITE
     C                   ENDIF
      *
     C                   ADD       CurSize       SIZE(CurMonth)
     C                   ADD       CurMbrs       MBRS(CurMonth)
     C                   ADD       CurRecs       RECS(CurMonth)
      *
     C     WRITE         IFEQ      *ON
     C                   WRITE     COG020R
     C                   ELSE
     C                   UPDATE    COG020R
     C                   ENDIF
      *
     CSR   #UpdMltMon    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Update multiple record week totals.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UpdMltWek    BEGSR
      *
     C     COGKY04       CHAIN     COG030R                            99
     C     *IN99         IFEQ      *ON
     C                   CLEAR                   COG030R
     C                   MOVE      ODLBNM        OGLIB
     C                   MOVE      ODOBNM        OGOBJ
     C                   MOVE      ODOBTP        OGTYPE
     C                   MOVE      CurYear       OGYEAR
     C                   MOVE      ODOBAT        OGATTR
     C                   MOVE      ODOBOW        OGOWNR
     C                   MOVE      ODOBTX        OGTEXT
     C                   MOVE      *ON           WRITE
     C                   ELSE
     C                   MOVE      *OFF          WRITE
     C                   ENDIF
      *
     C                   ADD       CurSize       SIZE(CurWeek)
     C                   ADD       CurMbrs       MBRS(CurWeek)
     C                   ADD       CurRecs       RECS(CurWeek)
      *
     C     WRITE         IFEQ      *ON
     C                   WRITE     COG030R
     C                   ELSE
     C                   UPDATE    COG030R
     C                   ENDIF
      *
     CSR   #UpdMltWek    ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          ERROR             1
     C                   MOVE      *OFF          WRITE             1
      *
     C     MinSizeMB     MULT      1000000       MinSize          15 0
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MinSizeMB         7 0
      *
     C     FDKY02        KLIST
     C                   KFLD                    ODLBNM
     C                   KFLD                    ODOBNM
      *
     C     COGKY04       KLIST
     C                   KFLD                    ODLBNM
     C                   KFLD                    ODOBNM
     C                   KFLD                    ODOBTP
     C                   KFLD                    CurYear
      *
     C     COGKY05m      KLIST
     C                   KFLD                    ODLBNM
     C                   KFLD                    ODOBNM
     C                   KFLD                    ODOBTP
     C                   KFLD                    CurYear
     C                   KFLD                    CurMonth
      *
     C     COGKY05w      KLIST
     C                   KFLD                    ODLBNM
     C                   KFLD                    ODOBNM
     C                   KFLD                    ODOBTP
     C                   KFLD                    CurYear
     C                   KFLD                    CurWeek
      *
     C     YearMonth     KLIST
     C                   KFLD                    CurYear
     C                   KFLD                    CurMonth
      *
     C     YearWeek      KLIST
     C                   KFLD                    CurYear
     C                   KFLD                    CurWeek
      *
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   MM                2
     C                   CLEAR                   CurWeek           2 0
     C                   CLEAR                   CurMonth          2 0
     C                   CLEAR                   CurYear           4 0
     C     *LIKE         DEFINE    ODOBNM        LIB_ODOBNM
     C     *LIKE         DEFINE    ODOBSZ        LIB_ODOBSZ
     C     *LIKE         DEFINE    DSPOBJD       LIB_DSPOBJ
     C     *LIKE         DEFINE    ODOBSZ        CurSize
     C     *LIKE         DEFINE    MBNRCD        CurRecs
     C     *LIKE         DEFINE    MBNOMB        CurMbrs
      *
     CSR   #DEFN         ENDSR
