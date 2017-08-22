      /TITLE Work with Service Program References
     ** PARMS DFTACTGRP(*no)
     **
     **  Program . . : CBX196E
     **  Description : Work with service program references - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : September 25, 2008
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX196E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX196E )
     **               Module( CBX576E )
     **               ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a

     **-- Global constants:
     D NULL            c                   ''
     D NO_ENT          c                   x'00000000'
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
     **-- UIM constants:
     D RES_OK          c                   0
     D RES_ERR         c                   1

     **-- UIM API return structures:
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  LstPos                       30a
     D  ObjNam                       10a
     D  LibNam                       10a
     D  PgmTyp                       10a
     D  PgmTyp2                      10a
     D  ObjAtr                       10a
     D  ObjTxt                       50a
     D  CrtPrf                       10a
     D  RefLib                       10a
     D  RefSig                       16a
     D  SigHex                       32a
     D  SigStt                        1a

     **-- UIM exit program interfaces:
     **-- Parm interface:
     D UimExit         Ds            70    Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     **-- Function key - call:
     D Type1           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  FncKey                       10i 0
     **-- Action list option/Pull-down field choice:
     D Type5           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  LstNam                       10a
     D  LstEntHdl                     4a
     D  OptNbr                       10i 0
     D  FncQlf                       10i 0
     D  ActRes                       10i 0
     D  PdwFldNam                    10a

     **-- Remove list entry:
     D RmvLstEnt       Pr                  ExtPgm( 'QUIRMVLE' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )

     **-- Entry parameters:
     D CBX196E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX196E         Pi
     D  PxUimExit                          LikeDs( UimExit )

      /Free

          If  PxUimExit.TypCall = 5;
            Type5 = PxUimExit;

            If  Type5.ActRes = RES_OK;

              If  Type5.OptNbr = 4;
                ExSr  DltLstEnt;
              EndIf;
            EndIf;
          EndIf;

        Return;


        BegSr  DltLstEnt;

          RmvLstEnt( Type5.AppHdl
                   : 'DTLLST'
                   : 'Y'
                   : Type5.LstEntHdl
                   : ERRC0100
                   );

        EndSr;

      /End-Free
