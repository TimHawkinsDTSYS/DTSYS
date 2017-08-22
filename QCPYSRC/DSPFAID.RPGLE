      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Display File AID Translation.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
     D F1              C                   const(X'31')
     D F2              C                   const(X'32')
     D F3              C                   const(X'33')
     D F4              C                   const(X'34')
     D F5              C                   const(X'35')
     D F6              C                   const(X'36')
     D F7              C                   const(X'37')
     D F8              C                   const(X'38')
     D F9              C                   const(X'39')
     D F10             C                   const(X'3A')
     D F11             C                   const(X'3B')
     D F12             C                   const(X'3C')
     D F13             C                   const(X'B1')
     D F14             C                   const(X'B2')
     D F15             C                   const(X'B3')
     D F16             C                   const(X'B4')
     D F17             C                   const(X'B5')
     D F18             C                   const(X'B6')
     D F19             C                   const(X'B7')
     D F20             C                   const(X'B8')
     D F21             C                   const(X'B9')
     D F22             C                   const(X'BA')
     D F23             C                   const(X'BB')
     D F24             C                   const(X'BC')
      *
     D Clear           C                   const(X'BD')
     D Enter           C                   const(X'F1')
     D Help            C                   const(X'F3')
     D Rolldown        C                   const(X'F4')
     D Rollup          C                   const(X'F5')
     D Pagedown        C                   const(X'F5')
     D Pageup          C                   const(X'F4')
     D PrintKey        C                   const(X'F6')
     D BackSpace       C                   const(X'F8')
      *
     D Redisplay       C                   const(X'00')
      *
     D Exit            C                   const(X'33')
     D List            C                   const(X'34')
     D Prompt          C                   const(X'34')
     D Sample          C                   const(X'36')
     D Repeat          C                   const(X'B1')
     D PrintList       C                   const(X'B2')
     D Refresh         C                   const(X'35')
     D Cancel          C                   const(X'3C')
     D Sort            C                   const(X'B4')
     D Subset          C                   const(X'B5')
     D ChgDfts         C                   const(X'B6')
     D ShiftLeft       C                   const(X'B7')
     D ShiftRight      C                   const(X'B8')
     D MoreOpts        C                   const(X'BB')
     D MoreKeys        C                   const(X'BC')
      *
     D DspAtr_ND       C                   const(X'27')
     D DspAtr_PR       C                   const(X'A0')
     D DspAtr_UL       C                   const(X'24')
      *
     D Normal          C                   const(x'20')
     D Protect         C                   const(x'80')
     D Blink           C                   const(x'08')
     D Underline       C                   const(x'04')
     D Hilight         C                   const(x'02')
     D Reverse         C                   const(x'01')
     D NonDisplay      C                   const(x'07')
      * ---------------------------------------------------------
      *
      *  NameAttr = Normal;
      *  If PaymentIsOverdue;
      *      NameAttr = %BitOr(NameAttr:Blink);
      *  EndIf;
      *  If CustomerType = 'A';
      *      NameAttr = %BitOr(NameAttr:Hi);
      *  EndIf;
      *  If Mode = 'INQUIRY';
      *      NameAttr = %BitOr(NameAttr:Protect);
      *  EndIf;
      * ---------------------------------------------------------
      *
      *    Basic colors.
      *
     D Color_GRN...
     D                 C                   const(X'20')
     D Color_WHT...
     D                 C                   const(X'22')
     D Color_RED...
     D                 C                   const(X'28')
     D Color_PNK...
     D                 C                   const(X'38')
     D Color_BLU...
     D                 C                   const(X'3A')
     D Color_TRQ...
     D                 C                   const(X'30')
     D Color_YLW...
     D                 C                   const(X'32')
      * ---------------------------------------------------------
      *
      *    Non-display.
      *
     D DspAtr_NP_ND...
     D                 C                   const(X'27')
     D DspAtr_PR_ND...
     D                 C                   const(X'A7')
      * ---------------------------------------------------------
      *
      *    Not protected colors.
      *
     D DspAtr_NP_GRN...
     D                 C                   const(X'20')
     D DspAtr_NP_GRN_RI...
     D                 C                   const(X'21')
     D DspAtr_NP_GRN_UL...
     D                 C                   const(X'24')
     D DspAtr_NP_GRN_UL_RI...
     D                 C                   const(X'25')
      *
     D DspAtr_NP_WHT...
     D                 C                   const(X'22')
     D DspAtr_NP_WHT_RI...
     D                 C                   const(X'23')
     D DspAtr_NP_WHT_UL...
     D                 C                   const(X'26')
      *
     D DspAtr_NP_RED...
     D                 C                   const(X'28')
     D DspAtr_NP_RED_RI...
     D                 C                   const(X'29')
     D DspAtr_NP_RED_HI...
     D                 C                   const(X'2A')
     D DspAtr_NP_RED_HI_RI...
     D                 C                   const(X'2B')
     D DspAtr_NP_RED_UL...
     D                 C                   const(X'2C')
     D DspAtr_NP_RED_UL_RI...
     D                 C                   const(X'2D')
     D DspAtr_NP_RED_UL_BL...
     D                 C                   const(X'2E')
      *
     D DspAtr_NP_TRQ...
     D                 C                   const(X'30')
     D DspAtr_NP_TRQ_RI...
     D                 C                   const(X'31')
     D DspAtr_NP_TRQ_UL...
     D                 C                   const(X'34')
     D DspAtr_NP_TRQ_UL_RI...
     D                 C                   const(X'35')
      *
     D DspAtr_NP_YLW...
     D                 C                   const(X'32')
     D DspAtr_NP_YLW_RI...
     D                 C                   const(X'33')
     D DspAtr_NP_YLW_UL...
     D                 C                   const(X'36')
      *
     D DspAtr_NP_PNK...
     D                 C                   const(X'38')
     D DspAtr_NP_PNK_RI...
     D                 C                   const(X'39')
     D DspAtr_NP_PNK_UL...
     D                 C                   const(X'3C')
     D DspAtr_NP_PNK_UL_RI...
     D                 C                   const(X'3D')
      *
     D DspAtr_NP_BLU...
     D                 C                   const(X'3A')
     D DspAtr_NP_BLU_RI...
     D                 C                   const(X'3B')
     D DspAtr_NP_BLU_UL...
     D                 C                   const(X'3E')
      * ---------------------------------------------------------
      *
      *    Protected colors.
      *
     D DspAtr_PR_GRN...
     D                 C                   const(X'A0')
     D DspAtr_PR_GRN_RI...
     D                 C                   const(X'A1')
     D DspAtr_PR_GRN_UL...
     D                 C                   const(X'A4')
     D DspAtr_PR_GRN_UL_RI...
     D                 C                   const(X'A5')
      *
     D DspAtr_PR_WHT...
     D                 C                   const(X'A2')
     D DspAtr_PR_WHT_RI...
     D                 C                   const(X'A3')
     D DspAtr_PR_WHT_UL...
     D                 C                   const(X'A6')
      *
     D DspAtr_PR_RED...
     D                 C                   const(X'A8')
     D DspAtr_PR_RED_RI...
     D                 C                   const(X'A9')
     D DspAtr_PR_RED_HI...
     D                 C                   const(X'AA')
     D DspAtr_PR_RED_HI_RI...
     D                 C                   const(X'AB')
     D DspAtr_PR_RED_UL...
     D                 C                   const(X'AC')
     D DspAtr_PR_RED_UL_RI...
     D                 C                   const(X'AD')
     D DspAtr_PR_RED_UL_BL...
     D                 C                   const(X'AE')
      *
     D DspAtr_PR_TRQ...
     D                 C                   const(X'B0')
     D DspAtr_PR_TRQ_RI...
     D                 C                   const(X'B1')
     D DspAtr_PR_TRQ_UL...
     D                 C                   const(X'B4')
     D DspAtr_PR_TRQ_UL_RI...
     D                 C                   const(X'B5')
      *
     D DspAtr_PR_YLW...
     D                 C                   const(X'B2')
     D DspAtr_PR_YLW_RI...
     D                 C                   const(X'33')
     D DspAtr_PR_YLW_UL...
     D                 C                   const(X'B6')
      *
     D DspAtr_PR_PNK...
     D                 C                   const(X'B8')
     D DspAtr_PR_PNK_RI...
     D                 C                   const(X'B9')
     D DspAtr_PR_PNK_UL...
     D                 C                   const(X'BC')
     D DspAtr_PR_PNK_UL_RI...
     D                 C                   const(X'BD')
      *
     D DspAtr_PR_BLU...
     D                 C                   const(X'BA')
     D DspAtr_PR_BLU_RI...
     D                 C                   const(X'BB')
     D DspAtr_PR_BLU_UL...
     D                 C                   const(X'BE')
