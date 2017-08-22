     D/if defined(ErrorCp)
     D/define ErrorCp
     D/eof
     D/endif


     D Error_throw     pr
     D  pCode                              value Like(Error_Info.code)
     D  pSeverity                          value Like(Error_Info.severity)
     D  pPgm                               value Like(Error_Info.pgm)
     D  pText                              value Like(Error_Info.text)

     D Error_catch     pr                  likeds(Error_Info)

     D Error_globalErrNoTxt...
     D                 pr           128a   varying

     D Error_globalErrNo...
     D                 pr            10i 0

     D Error_MsgType   s             10

     D Error_ESCAPE    s                   inz('*ESCAPE') like(Error_MsgType)
     D Error_COMP      s                   inz('*COMP')   like(Error_MsgType)
     D Error_DIAG      s                   inz('*DIAG')   like(Error_MsgType)
     D Error_INFORM    s                   inz('*INFO')   like(Error_MsgType)
     D Error_INQ       s                   inz('*INQ')    like(Error_MsgType)
     D Error_NOTIFY    s                   inz('*NOTIFY') like(Error_MsgType)
     D Error_RQS       s                   inz('*RQS')    like(Error_MsgType)
     D Error_STATUS    s                   inz('*STATUS') like(Error_MsgType)


     D Error_Info      DS                  qualified inz
     D  code                         10
     D  severity                     10i 0
     D  pgm                          30a   varying
     D  text                      32000a   varying
