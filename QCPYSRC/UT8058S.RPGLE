      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  IFS prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *   File Access Modes for open()
      *
     D O_RDONLY        S                   like(StdInt) inz(1)
     D O_WRONLY        S                   like(StdInt) inz(2)
     D O_RDWR          S                   like(StdInt) inz(4)
      * ---------------------------------------------------------
      *   oflag values for open()
      *
     D O_CREAT         S                   like(StdInt) inz(8)
     D O_EXCL          S                   like(StdInt) inz(16)
     D O_TRUNC         S                   like(StdInt) inz(64)
      * ---------------------------------------------------------
      *   File Status Flags for open() and fcntl()
      *
      /if not defined(O_NONBLOCK_PROTOTYPE)
     D O_NONBLOCK      S                   like(StdInt) inz(128)
      /define O_NONBLOCK_PROTOTYPE
      /endif
      *
     D O_APPEND        S                   like(StdInt) inz(256)
      * ---------------------------------------------------------
      *   oflag Share Mode values for open()
      *
     D O_SHARE_NONE    S                   like(StdInt) inz(2000000)
     D O_SHARE_RDONLY  S                   like(StdInt) inz(0200000)
     D O_SHARE_RDWR    S                   like(StdInt) inz(1000000)
     D O_SHARE_WRONLY  S                   like(StdInt) inz(0400000)
      * ---------------------------------------------------------
      *   file permissions
      *
     D S_IRUSR         S                   like(StdInt) inz(256)
     D S_IWUSR         S                   like(StdInt) inz(128)
     D S_IXUSR         S                   like(StdInt) inz(64)
     D S_IRWXU         S                   like(StdInt) inz(448)
     D S_IRGRP         S                   like(StdInt) inz(32)
     D S_IWGRP         S                   like(StdInt) inz(16)
     D S_IXGRP         S                   like(StdInt) inz(8)
     D S_IRWXG         S                   like(StdInt) inz(56)
     D S_IROTH         S                   like(StdInt) inz(4)
     D S_IWOTH         S                   like(StdInt) inz(2)
     D S_IXOTH         S                   like(StdInt) inz(1)
     D S_IRWXO         S                   like(StdInt) inz(7)
     D S_ISGID         S                   like(StdInt) inz(1024)
      * ---------------------------------------------------------
      *   Access mode flags for access()
      *   F_OK = File Exists
      *   R_OK = Read Access
      *   W_OK = Write Access
      *   X_OK = Execute or Search
      *
     D F_OK            C                   0
     D R_OK            C                   4
     D W_OK            C                   2
     D X_OK            C                   1
      * ---------------------------------------------------------
      *   Code pages & CCSID.
      *
     D O_TEXTDATA      S                   like(StdInt) inz(16777216)
     D O_CODEPAGE      S                   like(StdInt) inz(8388608)
     D O_MS_DOS        S                   like(StdInt) inz(437)
     D O_PC_ASCII      S                   like(StdInt) inz(819)
      *
     D ifsAsciiCdePag  S                   like(StdInt) inz(437)
      *
      * Including O_CCSID in the openflags tells the API that you
      * are specifying the fourth parameter as a CCSID value and
      * not a CODEPAGE value.
      *
     D O_CCSID         S                   like(StdInt) inz(32)
     D CCSID_UTF8      S                   like(StdInt) inz(1208)
      * ---------------------------------------------------------
      *   Miscellaneous
      *
     D ifsFullName     S            512    inz
     D ifsFileName     S            255    inz
     D ifsFileNameP    S                   like(StdPtr)
     D                                     inz(%addr(ifsFileName))
     D ifsFileLen      S                   like(StdBin) inz
     D ifsFileDesc     S                   like(StdInt) inz
     D ifsFD           S                   like(StdInt) inz
     D ifsBytesRead    S                   like(StdInt) inz
     D ifsBytesWrt     S                   like(StdInt) inz
     D ifsReturnInt    S                   like(StdInt) inz
     D ifsRC           S                   like(StdInt) inz
     D ifsData         S           9999    inz
     D ifsDataP        S                   like(StdPtr) inz(%addr(ifsData))
     D ifsDataRead     S           9899    inz
     D ifsDataReadP    S                   like(StdPtr)
     D                                     inz(%addr(ifsDataRead))
     D ifsTAB          S              1    inz(X'05')
     D ifsCR           S              1    inz(X'0D')
     D ifsLF           S              1    inz(X'25')
     D ifsEOR          S              2    inz(X'0D25')
     D ifsCRLF         S              2    inz(X'0D25')
     D ifsNull         S              1    inz(X'00')
     D ifsTrue         S                   like(StdInt) inz(*zero)
     D ifsFalse        S                   like(StdInt) inz(-1)
      *                                                                     *
     D CRLF_ebcdic     s              2    inz(x'0D25')
     D CRLF_ascii      s              2    inz(x'0D0A')
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  IFS prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  open() -- open file
      *
     D open            PR                  like(StdInt) EXTPROC('open')
     D  filename                           like(StdPtr) value
     D  openflags                          like(StdInt) value
     D  mode                               like(StdUns) value options(*NOPASS)
     D  codepage                           like(StdUns) value options(*NOPASS)
      * ---------------------------------------------------------
      *  read() -- read file
      *
     D read            PR                  like(StdInt) EXTPROC('read')
     D  filehandle                         like(StdInt) value
     D  datareceived                       like(StdPtr) value
     D  nbytes                             like(StdUns) value
      * ---------------------------------------------------------
      *  readline() -- read line by line
      *
     D readline        PR                  like(StdInt)
     D  filehandle                         like(StdInt) value
     D  datareceived                       like(StdPtr) value
     D  maxlen                             like(StdInt) value
      * ---------------------------------------------------------
      *  write() -- write data
      *
     D write           PR                  like(StdInt) EXTPROC('write')
     D  filehandle                         like(StdInt) value
     D  datatowrite                        like(StdPtr) value
     D  nbytes                             like(StdUns) value
      * ---------------------------------------------------------
      *  unlink() -- delete file
      *
      *  if ChkIfsObj(%trim(stmfname));
      *     if unlink(%trim(stmfname)) = ifsFalse;
      *        DiagErrno(errno());
      *        *inLR = *on;
      *        return;
      *     endif;
      *  endif;
      *
     D unlink          PR                  like(StdInt) ExtProc('unlink')
     D   path                              like(StdPtr) value
     D                                     options(*string)
      * ---------------------------------------------------------
      * IFSclose() -- close file
      *
      /if not defined(CLOSE_PROTOTYPE)
     D IFSclose        PR                  like(StdInt) EXTPROC('close')
     D  filehandle                         like(StdInt) value
      /define CLOSE_PROTOTYPE
      /endif
      * ---------------------------------------------------------
      *  mkdir() -- make directory
      *  -- returns -1 on failure, or 0=Sucess
      *
     D mkdir           PR                  ExtProc('mkdir')
     D                                     like(StdInt)
     D  path                               like(StdPtr)
     D                                     options(*string) value
     D  mode                               like(StdInt)
     D                                     value
      * ---------------------------------------------------------
      *  rmdir() -- remove directory
      *
     D rmdir           PR                  ExtProc('rmdir')
     D                                     like(StdInt)
     D  path                               like(StdPtr)
     D                                     options(*string) value
      * ---------------------------------------------------------
      *  TempIFSfile() -- create temporary IFS file.
      *  -- filename = %str(TempIFSfile(*OMIT));
      *     create and load the file here
      *     callp close(fd);
      *     callp unlink(filename);
      *
     D TempIFSfile     PR              *   extproc('_C_IFS_tmpnam')
     D   string                      39A   options(*omit)
      *----------------------------------------------------------
      *  access() - Check file accessibility
      *
      *  int access(const char *path, int amode)
      *
     D access          PR                  ExtProc('access')
     D                                     like(StdInt)
     D   Path                              value Options(*string)
     D                                     like(StdPtr)
     D   amode                             like(StdInt) value
      * ---------------------------------------------------------
      * ReportError()
      *
     D ReportError     PR
      * ---------------------------------------------------------
      *   stat() -- Retrieve stream file statistics
      *
     D stat            PR                  ExtProc('stat')
     D                                     like(StdInt)
     D  path                               like(StdPtr) value
     D                                     options(*string)
     D  p_statDS                           like(StdPtr) value
      * ---------------------------------------------------------
      *   Status DS.
      *
     D t_StatDS        DS                  based(StdNulPtr)
     D  st_mode                            like(StdUns)
     D  st_ino                             like(StdUns)
     D  st_nlink                           like(StdUnsSml)
     D  st_pad                        2A
     D  st_uid                             like(StdUns)
     D  st_gid                             like(StdUns)
     D  st_size                            like(StdInt)
     D  st_atime                           like(StdInt)
     D  st_mtime                           like(StdInt)
     D  st_ctime                           like(StdInt)
     D  st_dev                             like(StdUns)
     D  st_blksize                         like(StdUns)
     D  st_allocsize                       like(StdUns)
     D  st_objtype                   12A
     D  st_codepage                        like(StdUnsSml)
     D  st_reserved1                 62A
     D  st_ino_gen_id                      like(StdUns)
      *----------------------------------------------------------
      *  ChOwn() -- Change owner
      *
     D ChOwn           PR                  ExtProc('chown')
     D                                     like(StdInt)
     D   path                              like(StdPtr) value
     D                                     options(*string)
     D   owner                             like(StdUns) value
     D   group                             like(StdUns) value
      * ---------------------------------------------------------
      * RnmObj() -- Rename object.
      *
     D RnmObj          PR                  ExtProc('Qp0lRenameKeep')
     D                                     like(StdInt)
     D  oldobj                             like(StdPtr)   value
     D                                     options(*string)
     D  newobj                             like(StdPtr)   value
     D                                     options(*string)
      *----------------------------------------------------------
      *  ChkIFSobj() -- Check IFS object
      *
     D ChkIfsObj       PR                  like(StdInd)
     D  InpPath                            like(StdStr) const
      *----------------------------------------------------------
      *  ClrIFSobj() -- Clear IFS object
      *
     D ClrIfsObj       PR
     D  InpPath                            like(StdStr) const
      *----------------------------------------------------------
      *  ExtDirPth() -- Extract directories from a path
      *
     D ExtDirPth       PR                  like(t_ExtDirPth)
     D  InpPath                            like(StdStr) const
      *
     D t_ExtDirPth     DS                  qualified template
     D  IFSfile                            like(StdStr)
     D  IFSdircnt                          like(StdInt)
     D  IFSdirlist                         like(StdStr) dim(20)
      *----------------------------------------------------------
      *  ExtDir() -- Extract directories from a path
      *
     D ExtDir          PR                  like(StdStr)
     D  InpPath                            like(StdStr) const
      *----------------------------------------------------------
      *  ExtFile() -- Extract file name from a path
      *
     D ExtFile         PR                  like(StdStr)
     D  InpPath                            like(StdStr) const
      *----------------------------------------------------------
      *  CrtDirPth() -- Create directories for a path
      *
     D CrtDirPth       PR                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  ClnIFSnam() -- Cleanup IFS filename
      *
     D ClnIFSnam       PR                  like(StdStr)
     D  InpIFSnam                          like(StdStr) const
      *----------------------------------------------------------
      * ChgIFSown() -- Change IFS ownership.
      * -- option can be *ALL, *DIR, or *FILE.
      *
     D ChgIFSown       PR                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpUser                            like(StdNam) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdStr) const
     D                                     options(*nopass)
      *----------------------------------------------------------
      * ChgIFSaut() -- Change IFS authority.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      *
     D ChgIFSaut       PR                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpUser                            like(StdNam) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdStr) const
     D                                     options(*nopass)
      *----------------------------------------------------------
      * ChgIFSautl() -- Change IFS authority list.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      *
     D ChgIFSautl      PR                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpAutl                            like(StdNam) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdStr) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * Copy DB file to streamfile.
      *
     D CpyDBtoStmf     PR                  like(StdInd)
     D  InFile                             like(StdNam) const
     D  InStreamfile                       like(StdStr) const
      * ---------------------------------------------------------
      * Delete IFS directories.
      *
     D DltIFSdir       PR
     D  InPath                             like(StdStr) const
      * ---------------------------------------------------------
      * CvtSplNbrtoAlpha() -- Convert spoolfile number to alpha

     D CvtSplNbrtoAlpha...
     D                 pr                  like(StdJobNbr)
     D  i_SplNbr                           like(StdSplNbr) const
      * ---------------------------------------------------------
      * Change ownership.
      *
     D UT8058C         PR                  extpgm('UT8058C')
     D  in_path                            like(StdStr)
     D  in_user                            like(StdNam)

