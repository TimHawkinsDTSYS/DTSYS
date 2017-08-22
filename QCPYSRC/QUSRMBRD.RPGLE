     D*begin_generated_IBM_copyright_prolog
     D*This is an automatically generated copyright prolog.
     D*After initializing,  DO NOT MODIFY OR MOVE
     D*-----------------------------------------------------------------
     D*
     D*Product(s):
     D*5769-SS1
     D*5722-XE1
     D*5722-SS1
     D*5761-SS1
     D*
     D*(C)Copyright IBM Corp.  1994, 2007
     D*
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*---------------------------------------------------------------
     D*
     D*end_generated_IBM_copyright_prolog
     D*** START HEADER FILE SPECIFICATIONS ****************************
     D*
     D*Header File Name: H/QUSRMBRD
     D*
     D*Descriptive Name: Retrieve Member Description API
     D*
     D*Description: The Retrieve Member Description API retrieves  n
     D*          specific information about a single database file
     D*          member and returns the information to the calling
     D*          program in a receiver variable.
     D*
     D*Header Files Included: None.
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qdb_Mbrd0100_t
     D*             Qdb_Mbrd0200_t
     D*             Qdb_Mbrd0300_t
     D*             Qdb_Mbrd0400_t
     D*             Qdb_File_List_t
     D*             Qdb_Cst_Indexs_t
     D*             Qdb_Dsas_t
     D*             Qdb_Dsias_t
     D*             Qdb_Mbrd0200a_t
     D*             Qdb_DS_Index_List_t
     D*             Qdb_MQT_List_t
     D*             Qdb_Mbrd0500_t
     D*
     D*Function Prototype List: QUSRMBRD
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ----------------------
     D*$A0= D2862000     3D10  940102 ROCH:     New Include
     D*$A1= D9197100     3D60  941104 ROCH:     Add data space
     D*                                       activity statistics
     D*                                       support.
     D*$A2= D9491500     4D30  971215 45HDMK:   Add evi support.
     D*$A3= D9772500     4D50  990401 ROCH:     Double record capacity
     D*$A4= D9781600     4D50  990516 ROCH:     Additional info for
     D*                                      DS and DSI statistics.
     D*$A5=D98212.1  v5r1m0 991107 gchaney: Teraspace stage 2
     D*$A6=D9920700      5D30  030124 45HRLN:   Ragged Save While
     D*                                      Active, SWA, support.
     D*$A7=P9A44247      5D30  031024 ISAMJA:   New Index structures
     D*$A8=D9311301      5D40  041113 VPZMJA:   New MQT structures
     D*$A9=P9A93025      5D40  050406 VPZMJA:   Add Last use info for
     D*                                      indexes and MQTs
     D*$AA=D9995800      5D50  061020 45HMWT:   SQL Idx Where Clause.
     D*$AB=P9B46405      5D50  070303 VPZMJA:   Add owner, short
     D*                                      name, text, and attr
     D*                                      for DECFLOAT
     D*$AC=P9C04002      5D50  070908 GEYMJA    Add short library name
     D*$AD=P9C42250      7D10  090627 GEYMJA    Add additional index
     D*                                         statistics
     D*$AE=FW482528      7D10  090917 GEYMJA:  Add media preference,
     D*                                        random and sequential
     D*                                        statistics, and
     D*                                        variable-len overflow
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*****************************************************************
     D********************************************************************
     D*Prototypes for calling Retrieve Member Description API QUSRMBRD
     D********************************************************************
     D QUSRMBRD        C                   'QUSRMBRD'
     D******************************************************************
     D*Record structure for QUSRMBRD MBRD0100 format
     D******************************************************************
     DQUSM0100         DS
     D*                                             Qdb Mbrd0100
     D QUSBRTN02               1      4B 0
     D*                                             Bytes Returned
     D QUSBAVL03               5      8B 0
     D*                                             Bytes Available
     D QUSDFILN                9     18
     D*                                             Db File Name
     D QUSDFILL               19     28
     D*                                             Db File Lib
     D QUSMN02                29     38
     D*                                             Member Name
     D QUSFILA00              39     48
     D*                                             File Attr
     D QUSST00                49     58
     D*                                             Src Type
     D QUSCD01                59     71
     D*                                             Crt Date
     D QUSCD02                72     84
     D*                                             Change Date
     D QUSTD03                85    134
     D*                                             Text Desc
     D QUSSFIL00             135    135
     D*                                             Src File
     D******************************************************************
     D*Record structure for QUSRMBRD MBRD0200 format
     D******************************************************************
     DQUSM0200         DS
     D*                                             Qdb Mbrd0200
     D QUSBRTN03               1      4B 0
     D*                                             Bytes Returned
     D QUSBAVL04               5      8B 0
     D*                                             Bytes Available
     D QUSDFILN00              9     18
     D*                                             Db File Name
     D QUSDFILL00             19     28
     D*                                             Db File Lib
     D QUSMN03                29     38
     D*                                             Member Name
     D QUSFILA01              39     48
     D*                                             File Attr
     D QUSST01                49     58
     D*                                             Src Type
     D QUSCD03                59     71
     D*                                             Crt Date
     D QUSSCD                 72     84
     D*                                             Src Change Date
     D QUSTD04                85    134
     D*                                             Text Desc
     D QUSSFIL01             135    135
     D*                                             Src File
     D QUSEFIL               136    136
     D*                                             Ext File
     D QUSLFIL               137    137
     D*                                             Log File
     D QUSOS                 138    138
     D*                                             Odp Share
     D QUSERVED12            139    140
     D*                                             Reserved
     D QUSNBRCR              141    144B 0
     D*                                             Num Cur Rec
     D QUSNBRDR              145    148B 0
     D*                                             Num Dlt Rec
     D QUSDSS                149    152B 0
     D*                                             Dat Spc Size
     D QUSAPS                153    156B 0
     D*                                             Acc Pth Size
     D QUSNBRDM              157    160B 0
     D*                                             Num Dat Mbr
     D QUSCD04               161    173
     D*                                             Change Date
     D QUSSD                 174    186
     D*                                             Save Date
     D QUSRD                 187    199
     D*                                             Rest Date
     D QUSED                 200    210
     D*                                             Exp Date
     D QUSMP                 211    212B 0
     D*                                             Media Preference
     D QUSNDU                213    216B 0
     D*                                             Nbr Days Used
     D QUSDLU                217    223
     D*                                             Date Lst Used
     D QUSURD                224    230
     D*                                             Use Reset Date
     D QUSRSV101             231    232
     D*                                             Reserved1
     D QUSDSSM               233    236B 0
     D*                                             Data Spc Sz Mlt
     D QUSAPSM               237    240B 0
     D*                                             Acc Pth Sz Mlt
     D QUSMTC                241    244B 0
     D*                                             Member Text Ccsid
     D QUSOAI                245    248B 0
     D*                                             Offset Add Info
     D QUSLAI                249    252B 0
     D*                                             Length Add Info
     D QUSNCRU               253    256U 0
     D*                                             Num Cur Rec U
     D QUSNDRU               257    260U 0
     D*                                             Num Dlt Rec U
     D QUSRSV203             261    266
     D*                                             Reserved2
     D******************************************************************
     D*Structure for record format and based-on file
     D******************************************************************
     DQUSQFILL         DS
     D*                                             Qdb File List
     D QUSFILN02               1     10
     D*                                             File Name
     D QUSFILL                11     20
     D*                                             File Lib
     D QUSMN05                21     30
     D*                                             Member Name
     D QUSFN14                31     40
     D*                                             Format Name
     D QUSLFRFN               41     44B 0
     D*                                             Lgl File Rcd Frmt Num
     D QUSCNBRR               45     48B 0
     D*                                             Cur Num Rcds
     D QUSNBRDR01             49     52B 0
     D*                                             Num Dlt Rcds
     D QUSAPS01               53     56B 0
     D*                                             Acc Pth Sz
     D QUSAPSM01              57     60B 0
     D*                                             Acc Pth Sz Mlt
     D QUSAPS02               61     61
     D*                                             Acc Pth Shrd
     D QUSAPV                 62     62
     D*                                             Acc Pth Vld
     D QUSAPH                 63     63
     D*                                             Acc Pth Hld
     D QUSAPOF                64     73
     D*                                             Acc Pth Owner File
     D QUSAPOL                74     83
     D*                                             Acc Pth Owner Lib
     D QUSAPOM                84     93
     D*                                             Acc Pth Owner Mbr
     D QUSAPJ                 94     94
     D*                                             Acc Pth Jrn
     D QUSRSV113              95     96
     D*                                             Reserved1
     D QUSCNRU                97    100U 0
     D*                                             Cur Num Rcds U
     D QUSNDRU00             101    104U 0
     D*                                             Num Dlt Rcds U
     D QUSRSV216             105    112
     D*                                             Reserved2
     D******************************************************************
     D*Structure for constraint index information
     D******************************************************************
     DQUSQCI           DS
     D*                                             Qdb Cst Indexs
     D QUSCLN                  1     10
     D*                                             Cst Lib Name
     D QUSCNL                 11     12B 0
     D*                                             Cst Name Length
     D QUSCN                  13    270
     D*                                             Cst Name
     D QUSCAPS               271    274B 0
     D*                                             Cst Acc Pth Sz
     D QUSCAPSM              275    278B 0
     D*                                             Cst Acc Pth Sz Mlt
     D QUSCPS                279    279
     D*                                             Cst Pth Shrd
     D QUSCPV                280    280
     D*                                             Cst Pth Vld
     D QUSCPH                281    281
     D*                                             Cst Pth Hld
     D QUSCNBRL              282    289
     D*                                             Cst Num Lrd
     D QUSCNBRP              290    297
     D*                                             Cst Num Prd
     D QUSRSV105             298    321
     D*                                             Reserved1
     D******************************************************************
     D*Record structure for QUSRMBRD MBRD0300 format
     D******************************************************************
     DQUSM0300         DS
     D*                                             Qdb Mbrd0300
     D QUSBRTN04               1      4B 0
     D*                                             Bytes Returned
     D QUSBAVL05               5      8B 0
     D*                                             Bytes Available
     D QUSDFILN01              9     18
     D*                                             Db File Name
     D QUSDFILL01             19     28
     D*                                             Db File Lib
     D QUSMN04                29     38
     D*                                             Member Name
     D QUSFILA02              39     48
     D*                                             File Attr
     D QUSST02                49     58
     D*                                             Src Type
     D QUSCD05                59     71
     D*                                             Crt Date
     D QUSSCD00               72     84
     D*                                             Src Change Date
     D QUSTD05                85    134
     D*                                             Text desc
     D QUSSFIL02             135    135
     D*                                             Src File
     D QUSEFIL00             136    136
     D*                                             Ext File
     D QUSLFIL00             137    137
     D*                                             Log File
     D QUSOS00               138    138
     D*                                             Odp Share
     D QUSERVED13            139    140
     D*                                             Reserved
     D QUSNBRCR00            141    144B 0
     D*                                             Num Cur Rec
     D QUSNBRDR00            145    148B 0
     D*                                             Num Dlt Rec
     D QUSDSS00              149    152B 0
     D*                                             Dat Spc Size
     D QUSAPS00              153    156B 0
     D*                                             Acc Pth Size
     D QUSNBRDM00            157    160B 0
     D*                                             Num Dat Mbr
     D QUSCD06               161    173
     D*                                             Change Date
     D QUSSD00               174    186
     D*                                             Save Date
     D QUSRD00               187    199
     D*                                             Rest Date
     D QUSED00               200    212
     D*                                             Exp Date
     D QUSNDU00              213    216B 0
     D*                                             Nbr Days Used
     D QUSDLU00              217    223
     D*                                             Date Lst Used
     D QUSURD00              224    230
     D*                                             Use Reset Date
     D QUSRSV102             231    232
     D*                                             Reserved1
     D QUSDSSM00             233    236B 0
     D*                                             Data Spc Sz Mlt
     D QUSAPSM00             237    240B 0
     D*                                             Acc Pth Sz Mlt
     D QUSMTC00              241    244B 0
     D*                                             Member Text Ccsid
     D QUSOAI00              245    248B 0
     D*                                             Offset Add Info
     D QUSLAI00              249    252B 0
     D*                                             Length Add Info
     D QUSNCRU00             253    256U 0
     D*                                             Num Cur Rec U
     D QUSNDRU01             257    260U 0
     D*                                             Num Dlt Rec U
     D QUSRSV204             261    266
     D*                                             Reserved2
     D QUSJM                 267    267
     D*                                             Join Member
     D QUSAPM                268    268
     D*                                             Acc Pth Maint
     D QUSSQLFT              269    278
     D*                                             SQL File Type
     D QUSRSV3               279    279
     D*                                             Reserved3
     D QUSAR                 280    280
     D*                                             Allow Read
     D QUSAW                 281    281
     D*                                             Allow Write
     D QUSAU01               282    282
     D*                                             Allow Update
     D QUSAD01               283    283
     D*                                             Allow Delete
     D QUSRSV4               284    284
     D*                                             Reserved4
     D QUSRFW                285    288B 0
     D*                                             Rcds Force Write
     D QUSMPDR               289    292B 0
     D*                                             Max Prct Dlt Rcd
     D QUSINBRR              293    296B 0
     D*                                             Init Num Rcd
     D QUSINBRR00            297    300B 0
     D*                                             Incr Num Rcd
     D QUSMNBRI              301    304B 0
     D*                                             Max Num Incr
     D QUSCNBRI              305    308U 0
     D*                                             Cur Num Incr
     D QUSRC                 309    312U 0
     D*                                             Rcd Capacity
     D QUSRFSN               313    322
     D*                                             Rcd Format Slct Name
     D QUSRFSL               323    332
     D*                                             Rcd Format Slct Lib
     D QUSNBRCI              333    334B 0
     D*                                             Num Cst Indexs
     D QUSOCI                335    338B 0
     D*                                             Offset Cst Indexs
     D QUSRSV5               339    384
     D*                                             Reserved5
     D*QUSBO                        112    DIM(00001)
     D* QUSFILN03                    10    OVERLAY(QUSBO:00001)
     D* QUSFILL02                    10    OVERLAY(QUSBO:00011)
     D* QUSMN07                      10    OVERLAY(QUSBO:00021)
     D* QUSFN20                      10    OVERLAY(QUSBO:00031)
     D* QUSLFRFN00                    9B 0 OVERLAY(QUSBO:00041)
     D* QUSCNBRR00                    9B 0 OVERLAY(QUSBO:00045)
     D* QUSNBRDR02                    9B 0 OVERLAY(QUSBO:00049)
     D* QUSAPS03                      9B 0 OVERLAY(QUSBO:00053)
     D* QUSAPSM02                     9B 0 OVERLAY(QUSBO:00057)
     D* QUSAPS04                      1    OVERLAY(QUSBO:00061)
     D* QUSAPV00                      1    OVERLAY(QUSBO:00062)
     D* QUSAPH00                      1    OVERLAY(QUSBO:00063)
     D* QUSAPOF00                    10    OVERLAY(QUSBO:00064)
     D* QUSAPOL00                    10    OVERLAY(QUSBO:00074)
     D* QUSAPOM00                    10    OVERLAY(QUSBO:00084)
     D* QUSAPJ00                      1    OVERLAY(QUSBO:00094)
     D* QUSRSV114                     2    OVERLAY(QUSBO:00095)
     D* QUSCNRU00                    10U 0 OVERLAY(QUSBO:00097)
     D* QUSNDRU02                    10U 0 OVERLAY(QUSBO:00101)
     D* QUSRSV217                     8    OVERLAY(QUSBO:00105)
     D*
     D*                              Varying length
     D*QUSCI                        321    DIM(00001)
     D* QUSCLN00                     10    OVERLAY(QUSCI:00001)
     D* QUSCNL00                      4B 0 OVERLAY(QUSCI:00011)
     D* QUSCN00                     258    OVERLAY(QUSCI:00013)
     D* QUSCAPS00                     9B 0 OVERLAY(QUSCI:00271)
     D* QUSCAPSM00                    9B 0 OVERLAY(QUSCI:00275)
     D* QUSCPS00                      1    OVERLAY(QUSCI:00279)
     D* QUSCPV00                      1    OVERLAY(QUSCI:00280)
     D* QUSCPH00                      1    OVERLAY(QUSCI:00281)
     D* QUSCNBRL00                    8    OVERLAY(QUSCI:00282)
     D* QUSCNBRP00                    8    OVERLAY(QUSCI:00290)
     D* QUSRSV106                    24    OVERLAY(QUSCI:00298)
     D*
     D*                                      Varying length
     D******************************************************************
     D*Record structure for data space activity statistics
     D******************************************************************
     DQUSQD            DS
     D*                                             Qdb Dsas
     D QUSNBRAO                1      8
     D*                                             Num Act Ops
     D QUSNBRDO                9     16
     D*                                             Num Deact Ops
     D QUSNBRIO               17     24
     D*                                             Num Ins Ops
     D QUSNBRUO               25     32
     D*                                             Num Upd Ops
     D QUSNBRDO00             33     40
     D*                                             Num Del Ops
     D QUSNBRRO00             41     48
     D*                                             Num Reset Ops
     D QUSNBRCO               49     56
     D*                                             Num Cpy Ops
     D QUSNBRRO01             57     64
     D*                                             Num Reorg Ops
     D QUSNAPBO               65     72
     D*                                             Num APBld Ops
     D QUSNBRLO               73     80
     D*                                             Num Lrd Ops
     D QUSNBRPO               81     88
     D*                                             Num Prd Ops
     D QUSNBRRK               89     96
     D*                                             Num Rej Ksel
     D QUSNRNK                97    104
     D*                                             Num Rej NKsel
     D QUSNRGB               105    112
     D*                                             Num Rej Grp By
     D QUSNBRIV              113    116U 0
     D*                                             Num Index Val
     D QUSNBRII              117    120U 0
     D*                                             Num Index Ival
     D QUSVDS                121    124U 0
     D*                                             Var Data Size
     D QUSRES                125    125
     D*                                             Roll Ended State
     D QUSRPTS               126    126
     D*                                             Rstd Part Trns State
     D QUSJRN                127    136
     D*                                             Jrnl Rcvr Name
     D QUSJRLIB              137    146
     D*                                             Jrnl Rcvr Library
     D QUSSPDDN              147    156
     D*                                             Jrnl Rcvr ASP DDName
     D QUSVOVER              157    160U 0
     D*                                             Varlen Overflow
     D QUSNBRSR              161    168U 0
     D*                                             Num Sequential Reads
     D QUSNBRRR              169    176U 0
     D*                                             Num Random Reads
     D QUSRSV107             177    192
     D*                                             Reserved 1


     D******************************************************************
     D*Record structure for data space index activity statistics
     D******************************************************************
     DQUSQD00          DS
     D*                                             Qdb Dsias
     D QUSNAPL                 1      8
     D*                                             Num Acc Pth Lrd
     D QUSNAPP                 9     16
     D*                                             Num Acc Pth Prd
     D QUSNUKO                17     24
     D*                                             Num Unq Keyf One
     D QUSNUKT                25     32
     D*                                             Num Unq Keyf Two
     D QUSNUKT00              33     40
     D*                                             Num Unq Keyf Three
     D QUSNUKF                41     48
     D*                                             Num Unq Keyf Four
     D QUSNBROV               49     52U 0
     D*                                             Num Ovflow Val
     D QUSNBRDK               53     56U 0
     D*                                             Num Delay Keys
     D QUSLPS                 57     60U 0
     D*                                             Log Page Size
     D QUSER                  61     64B 0
     D*                                             Est Rebuild
     D QUSCS01                65     66U 0
     D*                                             Code Size
     D QUSLR                  67     79
     D*                                             Last Rebuild
     D QUSRSV108              80     92
     D*                                             Reserved 1
     D******************************************************************
     D*Record structure for Additional Mbrd0200 format Information
     D******************************************************************
     DQUSM020000       DS
     D*                                             Qdb Mbrd0200a
     D*QUSQD01                      192
     D*                                             Qdb Dsas
     D  QUSNBRAO00             1      8
     D*                                             Num Act Ops
     D  QUSNBRDO01             9     16
     D*                                             Num Deact Ops
     D  QUSNBRIO00            17     24
     D*                                             Num Ins Ops
     D  QUSNBRUO00            25     32
     D*                                             Num Upd Ops
     D  QUSNBRDO02            33     40
     D*                                             Num Del Ops
     D  QUSNBRRO02            41     48
     D*                                             Num Reset Ops
     D  QUSNBRCO00            49     56
     D*                                             Num Cpy Ops
     D  QUSNBRRO03            57     64
     D*                                             Num Reorg Ops
     D  QUSNAPBO00            65     72
     D*                                             Num APBld Ops
     D  QUSNBRLO00            73     80
     D*                                             Num Lrd Ops
     D  QUSNBRPO00            81     88
     D*                                             Num Prd Ops
     D  QUSNBRRK00            89     96
     D*                                             Num Rej Ksel
     D  QUSNRNK00             97    104
     D*                                             Num Rej NKsel
     D  QUSNRGB00            105    112
     D*                                             Num Rej Grp By
     D  QUSNBRIV00           113    116U 0
     D*                                             Num Index Val
     D  QUSNBRII00           117    120U 0
     D*                                             Num Index Ival
     D  QUSVDS00             121    124U 0
     D*                                             Var Data Size
     D  QUSRES00             125    125
     D*                                             Roll Ended State
     D  QUSRPTS00            126    126
     D*                                             Rstd Part Trns State
     D  QUSJRN00             127    136
     D*                                             Jrnl Rcvr Name
     D  QUSJRLIB00           137    146
     D*                                             Jrnl Rcvr Library
     D  QUSSPDDN00           147    156
     D*                                             Jrnl Rcvr ASP DDName
     D  QUSRSV109            157    192
     D*                                             Reserved 1
     D*QUSQD02                       92
     D*                                             Qdb Dsias
     D  QUSNAPL00            193    200
     D*                                             Num Acc Pth Lrd
     D  QUSNAPP00            201    208
     D*                                             Num Acc Pth Prd
     D  QUSNUKO00            209    216
     D*                                             Num Unq Keyf One
     D  QUSNUKT01            217    224
     D*                                             Num Unq Keyf Two
     D  QUSNUKT02            225    232
     D*                                             Num Unq Keyf Three
     D  QUSNUKF00            233    240
     D*                                             Num Unq Keyf Four
     D  QUSNBROV00           241    244U 0
     D*                                             Num Ovflow Val
     D  QUSNBRDK00           245    248U 0
     D*                                             Num Delay Keys
     D  QUSLPS00             249    252U 0
     D*                                             Log Page Size
     D  QUSER00              253    256B 0
     D*                                             Est Rebuild
     D  QUSCS02              257    258U 0
     D*                                             Code Size
     D  QUSLR00              259    271
     D*                                             Last Rebuild
     D  QUSRSV110            272    284
     D*                                             Reserved 1
     D******************************************************************
     D*Data Space Index List Entry                            @A9C @A7A
     D******************************************************************
     DQUSQDSIL         DS
     D*                                             Qdb DS Index List
     D  QUSFCLL                1      2B 0
     D*                                             File Cst Lib Len
     D  QUSFCLN                3    260
     D*                                             File Cst Lib Name
     D  QUSFILCL00           261    262B 0
     D*                                             File Cst Len
     D  QUSFILCN             263    520
     D*                                             File Cst Name
     D  QUSFILML             521    522B 0
     D*                                             File Mbr Len
     D  QUSFILMN             523    780
     D*                                             File Mbr Name
     D QUSFILCT              781    791
     D*                                             File Cst Type
     D QUSRSV115             792    800
     D*                                             Reserved1
     D QUSDSIV               801    801
     D*                                             DS Index Valid
     D QUSDSIH               802    802
     D*                                             DS Index Held
     D QUSRSV220             803    808
     D*                                             Reserved2
     D QUSDSICD              809    822
     D*                                             DS Index Crt Datetime
     D QUSSILRD              823    836
     D*                                             DS Index Last Rbd Datetime
     D QUSSILQD              837    850
     D*                                             DS Index Last Qry Datetime
     D QUSSILSD              851    864
     D*                                             DS Index Last Stats Datetime
     D QUSSILQC              865    872I 0
     D*                                             DS Index Last Qry Count
     D QUSSILSC              873    880I 0
     D*                                             DS Index Last Stats Count
     D QUSILS2C              881    888I 0
     D*                                             DS Index Last Stats2 Count
     D QUSNDSIK              889    896I 0
     D*                                             Num DS Index Keys
     D QUSDSIS               897    904I 0
     D*                                             DS Index Size
     D QUSNUKO02             905    912I 0
     D*                                             Num Unq Keyf One
     D QUSNUKT05             913    920I 0
     D*                                             Num Unq Keyf Two
     D QUSNUKT06             921    928I 0
     D*                                             Num Unq Keyf Three
     D QUSNUKF02             929    936I 0
     D*                                             Num Unq Keyf Four
     D QUSER01               937    940B 0
     D*                                             Est Rebuild
     D QUSNBRDK01            941    944B 0
     D*                                             Num Delay Keys
     D QUSNBROV01            945    948B 0
     D*                                             Num Ovflow Val
     D QUSCS03               949    952B 0
     D*                                             Code Size
     D QUSNAPL01             953    960I 0
     D*                                             Num Acc Pth Lrd
     D QUSNAPP01             961    968I 0
     D*                                             Num Acc Pth Prd
     D QUSFNDU               969    972B 0
     D*                                             File Num Days Used
     D QUSFLUD               973    986
     D*                                             File Last Use Datetime
     D QUSFILRD              987    994
     D*                                             File Reset Datetime
     D QUSDSRRD              995   1002I 0
     D*                                             Num DS Index Random Reads
     D*                                                        @ADA
     D QUSDSILKY            1003   1010I 0
     D*                                             Num DS Index Last Rbd Keys
     D*                                                        @ADA
     D QUSDSILTM            1011   1014I 0
     D*                                             Num DS Index Last Rbd Time
     D*                                                        @ADA
     D QUSDSILTSK           1015   1016B 0
     D*                                             Num DS Index Last Rbd Tasks
     D*                                                        @ADA
     D QUSDSILDEG           1017   1018B 0
     D*                                             Num DS Index Last Rbd Degree
     D*                                                        @ADA
     D QUSRSV305            1019   1024
     D*                                             Reserved3
     D*                                                        @ADC
     D QUSDSIS00            1025   1025
     D*                                             DS Index Sparse
     D QUSDSID              1026   1026
     D*                                             DS Index Derived
     D QUSDSIP              1027   1027
     D*                                             DS Index Partitioned
     D QUSDSIM              1028   1028
     D*                                             DS Index Maint
     D QUSDSIR              1029   1029
     D*                                             DS Index Recover
     D QUSDSIT              1030   1030
     D*                                             DS Index Type
     D QUSDSIU              1031   1031
     D*                                             DS Index Unique
     D QUSDSIS01            1032   1032
     D*                                             DS Index Srtseq
     D QUSDSISL             1033   1042
     D*                                             DS Index Srtseq Lib
     D QUSDSIST             1043   1052
     D*                                             DS Index Srtseq Table
     D QUSISLID             1053   1055
     D*                                             DS Index Srtseq LangID
     D QUSDSISW             1056   1056
     D*                                             DS Index Srtseq Weight
     D QUSLPS01             1057   1060B 0
     D*                                             Log Page Size
     D QUSDSIKL             1061   1064B 0
     D*                                             DS Index Key Len
     D QUSDSIKF             1065   1068B 0
     D*                                             DS Index Key Flds
     D QUSLOATR             1069   1069
     D*                                             DS Index DECFLOAT Rounding
     D*                                                        @ABA
     D QUSLOATW             1070   1070
     D*                                             DS Index DECFLOAT Warning
     D*                                                        @ABA
     D QUSIHUDF             1071   1071
     D*                                             DS Index Has UDF
     D*                                                        @ABA
     D QUSDSIKIM            1072   1072
     D*                                             Num DS Index Keep in Memory
     D*                                                        @ADA
     D QUSDSIMPR            1073   1074B 0
     D*                                             Num DS Index Media Pref
     D*                                                        @ADA
     D QUSRSV406            1074   1150
     D*                                             Reserved4
     D*                                                        @ADC
     D  QUSSIKFL            1151   1152B 0
     D*                                             DS Index Key Fld Len
     D  QUSSIKFN            1153   2176
     D*                                             DS Index Key Fld Names
     D QUSCCSID18           2177   2180B 0
     D*                                             DS Index WHERE CCSID
     D*                                                        @AAC
     D  QUSSIWCL            2181   2182B 0
     D*                                             DS Index Where Cls Len
     D  QUSDSIWC            2183   3206
     D*                                             DS Index Where Cls
     D QUSCCSID19           3207   3210B 0
     D*                                             DS Index TEXT CCSID
     D*                                                        @ABA
     D  QUSDSITL            3211   3212B 0
     D*                                             DS Index Text Len
     D  QUSDSIT01           3213   3262
     D*                                             DS Index Text
     D QUSDSIO              3263   3272
     D*                                             DS Index Owner
     D*                                                        @ABA
     D QUSDSSIN             3273   3282
     D*                                             DS System Index Name
     D*                                                        @ABA
     D QUSSSISN             3283   3292
     D*                                             DS System Index Schema Name
     D*                                                        @ACA
     D******************************************************************
     D*Record structure for QUSRMBRD MBRD0400 format               @A7A
     D******************************************************************
     DQUSM0400         DS
     D*                                             Qdb Mbrd0400
     D QUSBRTN13               1      4B 0
     D*                                             Bytes Returned
     D QUSBAVL15               5      8B 0
     D*                                             Bytes Available
     D QUSNDSI                 9     12B 0
     D*                                             Num DS Indexes
     D QUSODSI                13     16B 0
     D*                                             Offset DS Indexes
     D*QUSBO00                     3292    DIM(00001)
     D* QUSFILCL01                  260
     D*  QUSFCLL00                    4B 0 OVERLAY(QUSBO00:00001)
     D*  QUSFCLN00                  258    OVERLAY(QUSBO00:00003)
     D* QUSFILC00                   260
     D*  QUSFILCL02                   4B 0 OVERLAY(QUSBO00:00001)
     D*  QUSFILCN00                 258    OVERLAY(QUSBO00:00003)
     D* QUSFILM00                   260
     D*  QUSFILML00                   4B 0 OVERLAY(QUSBO00:00001)
     D*  QUSFILMN00                 258    OVERLAY(QUSBO00:00003)
     D* QUSFILCT00                   11    OVERLAY(QUSBO00:00261)
     D* QUSRSV116                     9    OVERLAY(QUSBO00:00272)
     D* QUSDSIV00                     1    OVERLAY(QUSBO00:00281)
     D* QUSDSIH00                     1    OVERLAY(QUSBO00:00282)
     D* QUSRSV221                     6    OVERLAY(QUSBO00:00283)
     D* QUSDSICD00                   14    OVERLAY(QUSBO00:00289)
     D* QUSSILRD00                   14    OVERLAY(QUSBO00:00303)
     D* QUSSILQD00                   14    OVERLAY(QUSBO00:00317)
     D* QUSSILSD00                   14    OVERLAY(QUSBO00:00331)
     D* QUSSILQC00                   20I 0 OVERLAY(QUSBO00:00345)
     D* QUSSILSC00                   20I 0 OVERLAY(QUSBO00:00353)
     D* QUSILS2C00                   20I 0 OVERLAY(QUSBO00:00361)
     D* QUSNDSIK00                   20I 0 OVERLAY(QUSBO00:00369)
     D* QUSDSIS02                    20I 0 OVERLAY(QUSBO00:00377)
     D* QUSNUKO03                    20I 0 OVERLAY(QUSBO00:00385)
     D* QUSNUKT07                    20I 0 OVERLAY(QUSBO00:00393)
     D* QUSNUKT08                    20I 0 OVERLAY(QUSBO00:00401)
     D* QUSNUKF03                    20I 0 OVERLAY(QUSBO00:00409)
     D* QUSER02                       9B 0 OVERLAY(QUSBO00:00417)
     D* QUSNBRDK02                    9B 0 OVERLAY(QUSBO00:00421)
     D* QUSNBROV02                    9B 0 OVERLAY(QUSBO00:00425)
     D* QUSCS04                       9B 0 OVERLAY(QUSBO00:00429)
     D* QUSNAPL02                    20I 0 OVERLAY(QUSBO00:00433)
     D* QUSNAPP02                    20I 0 OVERLAY(QUSBO00:00441)
     D* QUSFNDU00                     9B 0 OVERLAY(QUSBO00:00449)
     D* QUSFLUD00                    14    OVERLAY(QUSBO00:00453)
     D* QUSFILRD00                    8    OVERLAY(QUSBO00:00467)
     D* QUSDSRRD                     20I 0 OVERLAY(QUSBO00:00475)
     D*                                                        @ADA
     D* QUSDSILKY                    20I 0 OVERLAY(QUSBO00:00483)
     D*                                                        @ADA
     D* QUSDSILTM                    10I 0 OVERLAY(QUSBO00:00491)
     D*                                                        @ADA
     D* QUSDSILTSK                    4B 0 OVERLAY(QUSBO00:00495)
     D*                                                        @ADA
     D* QUSDSILDEG                    4B 0 OVERLAY(QUSBO00:00497)
     D*                                                        @ADA
     D* QUSRSV306                     6    OVERLAY(QUSBO00:00499)
     D*                                                        @ADA
     D* QUSDSIS03                     1    OVERLAY(QUSBO00:00505)
     D* QUSDSID00                     1    OVERLAY(QUSBO00:00506)
     D* QUSDSIP00                     1    OVERLAY(QUSBO00:00507)
     D* QUSDSIM00                     1    OVERLAY(QUSBO00:00508)
     D* QUSDSIR00                     1    OVERLAY(QUSBO00:00509)
     D* QUSDSIT00                     1    OVERLAY(QUSBO00:00510)
     D* QUSDSIU00                     1    OVERLAY(QUSBO00:00511)
     D* QUSDSIS04                     1    OVERLAY(QUSBO00:00512)
     D* QUSDSISL00                   10    OVERLAY(QUSBO00:00513)
     D* QUSDSIST00                   10    OVERLAY(QUSBO00:00523)
     D* QUSISLID00                    3    OVERLAY(QUSBO00:00533)
     D* QUSDSISW00                    1    OVERLAY(QUSBO00:00536)
     D* QUSLPS02                      9B 0 OVERLAY(QUSBO00:00537)
     D* QUSDSIKL00                    9B 0 OVERLAY(QUSBO00:00541)
     D* QUSDSIKF01                    9B 0 OVERLAY(QUSBO00:00545)
     D* QUSLOATR00                    1    OVERLAY(QUSBO00:00549)
     D* QUSLOATW00                    1    OVERLAY(QUSBO00:00550)
     D* QUSIHUDF00                    1    OVERLAY(QUSBO00:00551)
     D* QUSDSIKIM                     1    OVERLAY(QUSBO00:00552)
     D*                                                        @ADA
     D* QUSDSIMPR                     4B 0 OVERLAY(QUSBO00:00553)
     D*                                                        @ADA
     D* QUSRSV407                    76    OVERLAY(QUSBO00:00555)
     D*                                                        @ADA
     D* QUSDSIKF02                 1026
     D*  QUSSIKFL00                   4B 0 OVERLAY(QUSBO00:00001)
     D*  QUSSIKFN00                1024    OVERLAY(QUSBO00:00003)
     D* QUSCCSID20                    9B 0 OVERLAY(QUSBO00:01027)
     D* QUSDSIWF00                 1026
     D*  QUSSIWCL00                   4B 0 OVERLAY(QUSBO00:00001)
     D*  QUSDSIWC00                1024    OVERLAY(QUSBO00:00003)
     D* QUSCCSID21                    9B 0 OVERLAY(QUSBO00:01027)
     D* QUSDSITF00                   52
     D*  QUSDSITL00                   4B 0 OVERLAY(QUSBO00:00001)
     D*  QUSDSIT02                   50    OVERLAY(QUSBO00:00003)
     D* QUSDSIO00                    10    OVERLAY(QUSBO00:00053)
     D* QUSDSSIN00                   10    OVERLAY(QUSBO00:00063)
     D* QUSSSISN00                   10    OVERLAY(QUSBO00:00073)
     D*
     D*                                  Varying length
     D******************************************************************
     D*Materialized Query Table List Entry                    @A9C @A8A
     D******************************************************************
     DQUSQMQTL         DS
     D*                                             Qdb MQT List
     D  QUSFILLL               1      2B 0
     D*                                             File Lib Len
     D  QUSFILLN02             3    260
     D*                                             File Lib Name
     D  QUSFILL04            261    262B 0
     D*                                             File Len
     D  QUSFILN04            263    520
     D*                                             File Name
     D  QUSFILML01           521    522B 0
     D*                                             File Mbr Len
     D  QUSFILMN01           523    780
     D*                                             File Mbr Name
     D QUSRSV118             781    800
     D*                                             Reserved1
     D QUSABLED              801    801
     D*                                             Enabled
     D QUSRSV222             802    808
     D*                                             Reserved2
     D QUSMQTCD              809    822
     D*                                             MQT Crt Datetime
     D QUSQTLRD              823    836
     D*                                             MQT Last Refresh Datetime
     D QUSQTLQD              837    850
     D*                                             MQT Last Qry Datetime
     D QUSQTLSD              851    864
     D*                                             MQT Last Stats Datetime
     D QUSQTLQC              865    872I 0
     D*                                             MQT Last Qry Count
     D QUSQTLSC              873    880I 0
     D*                                             MQT Last Stats Count
     D QUSNMQTR              881    888I 0
     D*                                             Num MQT Rows
     D QUSMQTS               889    896I 0
     D*                                             MQT Size
     D QUSQTLCD              897    910
     D*                                             MQT Last Change Datetime
     D QUSQTLUD              911    924
     D*                                             MQT Last Use Datetime
     D QUSQTNDU              925    928B 0
     D*                                             MQT Num Days Used
     D QUSMQTRD              929    936
     D*                                             MQT Reset Datetime
     D QUSRSV307             937    976
     D*                                             Reserved3
     D QUSMQTM               977    977
     D*                                             MQT Maintenance
     D QUSMQTI               978    978
     D*                                             MQT Initial
     D QUSMQTRM              979    979
     D*                                             MQT Refresh Mode
     D QUSMQTIL              980    981
     D*                                             MQT Isolation Level
     D QUSMQTST              982    982
     D*                                             MQT Srtseq Type
     D QUSMQTSL              983    992
     D*                                             MQT Srtseq Lib
     D QUSMQTST00            993   1002
     D*                                             MQT Srtseq Table
     D QUSTSLID             1003   1005
     D*                                             MQT Srtseq LangID
     D QUSMQTSW             1006   1006
     D*                                             MQT Srtseq Weight
     D QUSLOATR01           1007   1007
     D*                                             MQT DECFLOAT Rounding
     D*                                                        @ABA
     D QUSLOATW01           1008   1008
     D*                                             MQT DECFLOAT Warning
     D*                                                        @ABA
     D QUSMQTRD01           1009   1009
     D*                                             MQT Restore Deferred
     D*                                                        @ABA
     D QUSRSV408            1010   1054
     D*                                             Reserved4
     D*                                                        @ABC
     D QUSCCSID16           1055   1058B 0
     D*                                             MQT SELECT CCSID
     D  QUSLECTL            1059   1060B 0
     D*                                             MQT SELECT Len
     D  QUSLECTT            1061   6060
     D*                                             MQT SELECT Text
     D QUSCCSID22           6061   6064B 0
     D*                                             MQT TEXT CCSID
     D*                                                        @ABA
     D  QUSMQTTL            6065   6066B 0
     D*                                             MQT Text Len
     D  QUSMQTT             6067   6116
     D*                                             MQT Text
     D QUSMQTO              6117   6126
     D*                                             MQT Owner
     D*                                                        @ABA
     D QUSSMQTN             6127   6136
     D*                                             MQT System MQT Name
     D*                                                        @ABA
     D QUSMQTSN             6137   6146
     D*                                             MQT System MQT Schema Name
     D*                                                        @ACA
     D******************************************************************
     D*Record structure for QUSRMBRD MBRD0500 format               @A8A
     D******************************************************************
     DQUSM0500         DS
     D*                                             Qdb Mbrd0500
     D QUSBRTN14               1      4B 0
     D*                                             Bytes Returned
     D QUSBAVL16               5      8B 0
     D*                                             Bytes Available
     D QUSNMQT                 9     12B 0
     D*                                             Num MQTs
     D QUSOMQT                13     16B 0
     D*                                             Offset MQTs
     D*QUSBO01                     6146    DIM(00001)
     D* QUSFILL05                   260
     D*  QUSFILLL00                   4B 0 OVERLAY(QUSBO01:00001)
     D*  QUSFILLN03                 258    OVERLAY(QUSBO01:00003)
     D* QUSFILE00                   260
     D*  QUSFILL06                    4B 0 OVERLAY(QUSBO01:00001)
     D*  QUSFILN05                  258    OVERLAY(QUSBO01:00003)
     D* QUSFILM02                   260
     D*  QUSFILML02                   4B 0 OVERLAY(QUSBO01:00001)
     D*  QUSFILMN02                 258    OVERLAY(QUSBO01:00003)
     D* QUSRSV119                    20    OVERLAY(QUSBO01:00261)
     D* QUSABLED00                    1    OVERLAY(QUSBO01:00281)
     D* QUSRSV223                     7    OVERLAY(QUSBO01:00282)
     D* QUSMQTCD00                   14    OVERLAY(QUSBO01:00289)
     D* QUSQTLRD00                   14    OVERLAY(QUSBO01:00303)
     D* QUSQTLQD00                   14    OVERLAY(QUSBO01:00317)
     D* QUSQTLSD00                   14    OVERLAY(QUSBO01:00331)
     D* QUSQTLQC00                   20I 0 OVERLAY(QUSBO01:00345)
     D* QUSQTLSC00                   20I 0 OVERLAY(QUSBO01:00353)
     D* QUSNMQTR00                   20I 0 OVERLAY(QUSBO01:00361)
     D* QUSMQTS00                    20I 0 OVERLAY(QUSBO01:00369)
     D* QUSQTLCD00                   14    OVERLAY(QUSBO01:00377)
     D* QUSQTLUD00                   14    OVERLAY(QUSBO01:00391)
     D* QUSQTNDU00                    9B 0 OVERLAY(QUSBO01:00405)
     D* QUSMQTRD00                    8    OVERLAY(QUSBO01:00409)
     D* QUSRSV308                    40    OVERLAY(QUSBO01:00417)
     D* QUSMQTM00                     1    OVERLAY(QUSBO01:00457)
     D* QUSMQTI00                     1    OVERLAY(QUSBO01:00458)
     D* QUSMQTRM00                    1    OVERLAY(QUSBO01:00459)
     D* QUSMQTIL00                    2    OVERLAY(QUSBO01:00460)
     D* QUSMQTST01                    1    OVERLAY(QUSBO01:00462)
     D* QUSMQTSL00                   10    OVERLAY(QUSBO01:00463)
     D* QUSMQTST02                   10    OVERLAY(QUSBO01:00473)
     D* QUSTSLID00                    3    OVERLAY(QUSBO01:00483)
     D* QUSMQTSW00                    1    OVERLAY(QUSBO01:00486)
     D* QUSLOATR02                    1    OVERLAY(QUSBO01:00487)
     D* QUSLOATW02                    1    OVERLAY(QUSBO01:00488)
     D* QUSMQTRD02                    1    OVERLAY(QUSBO01:00489)
     D* QUSRSV409                    45    OVERLAY(QUSBO01:00490)
     D* QUSCCSID17                    9B 0 OVERLAY(QUSBO01:00535)
     D* QUSELECT00                 5002
     D*  QUSLECTL00                   4B 0 OVERLAY(QUSBO01:00001)
     D*  QUSLECTT00                5000    OVERLAY(QUSBO01:00003)
     D* QUSCCSID23                    9B 0 OVERLAY(QUSBO01:05003)
     D* QUSMQTTF00                   52
     D*  QUSMQTTL00                   4B 0 OVERLAY(QUSBO01:00001)
     D*  QUSMQTT00                   50    OVERLAY(QUSBO01:00003)
     D* QUSMQTO00                    10    OVERLAY(QUSBO01:00053)
     D* QUSSMQTN00                   10    OVERLAY(QUSBO01:00063)
     D* QUSMQTSN00                   10    OVERLAY(QUSBO01:00073)
     D*
     D*                             Varying length
