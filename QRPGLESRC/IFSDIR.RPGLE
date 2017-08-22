      */TITLE Read IFS directory
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Scott Klement 05/24/2007
      *
      * Sample use:
      * ---------------------------------------------------------
      * D Filename        s             50a
      *
      *  /free
      *   EXEC SQL  Set option naming=*SYS;
      *
      *   EXEC SQL  declare DBcursor cursor for
      *              select Filename from TABLE(IFSDIR('/tmp')) as t
      *               where ACCESS_TIME < CURRENT TIMESTAMP - 7 days;
      *
      *   EXEC SQL  open C1;
      *   EXEC SQL  fetch next from DBcursor into :filename;
      *
      *      dow sqlstt = '00000';
      *          dsply filename;
      *          EXEC SQL  fetch next from DBcursor into :filename;
      *      enddo;
      *
      *   EXEC SQL  close DBcursor;
      *   *inLR = *on;
      *  /end-free
      * ---------------------------------------------------------
      *
      * Create function:
      * ---------------------------------------------------------
      * CREATE FUNCTION IFSDIR(dirname VARCHAR(500))
      *                                RETURNS TABLE
      *                                 (filename    varchar(640),
      *                                  size        decimal(20,0)
      *                                  type        varchar(10),
      *                                  access_time timestamp,
      *                                  modify_time timestamp,
      *                                  change_time timestamp,
      *                                  ccsid       decimal(5,0),
      *                                  owner       char(10),
      *                                  group       char(10))
      *                          EXTERNAL NAME lib/IFSDIR(IFSDIR)
      *                          LANGUAGE RPGLE
      *                          PARAMETER STYLE DB2SQL
      *                          NO SQL
      *                          NOT DETERMINISTIC
      *                          NO EXTERNAL ACTION
      *                          NOT FENCED
      *                          NO SCRATCHPAD
      *                          NO FINAL CALL
      *                          DISALLOW PARALLEL
      *                          CARDINALITY 1
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     H THREAD(*SERIALIZE) BNDDIR('QC2LE') DFTACTGRP(*NO)

     D ifsdir          pr                  extpgm('IFSDIR')
     D    dirname                   500A   varying const
     D    filename                  640A   varying
     D    size                       20p 0
     D    type                       10a   varying
     D    atime                        Z
     D    mtime                        Z
     D    ctime                        Z
     D    ccsid                       5p 0
     D    owner                      10a
     D    groupx                     10a
     D    n_dirname                   5i 0
     D    n_filename                  5i 0
     D    n_size                      5i 0
     D    n_type                      5i 0
     D    n_atime                     5i 0
     D    n_mtime                     5i 0
     D    n_ctime                     5i 0
     D    n_ccsid                     5i 0
     D    n_owner                     5i 0
     D    n_group                     5i 0
     D    Sql_State                   5a
     D    Function                  139a   varying const
     D    Specific                  128a   varying const
     D    MsgText                    70a   varying
     D    CallType                    5i 0 const
      *
     D ifsdir          pi
     D    dirname                   500A   varying const
     D    filename                  640A   varying
     D    size                       20p 0
     D    type                       10a   varying
     D    atime                        Z
     D    mtime                        Z
     D    ctime                        Z
     D    ccsid                       5p 0
     D    owner                      10a
     D    groupx                     10a
     D    n_dirname                   5i 0
     D    n_filename                  5i 0
     D    n_size                      5i 0
     D    n_type                      5i 0
     D    n_atime                     5i 0
     D    n_mtime                     5i 0
     D    n_ctime                     5i 0
     D    n_ccsid                     5i 0
     D    n_owner                     5i 0
     D    n_group                     5i 0
     D    Sql_State                   5a
     D    Function                  139a   varying const
     D    Specific                  128a   varying const
     D    MsgText                    70a   varying
     D    CallType                    5i 0 const

      /copy ifsio_h

     D Open_Event      PR
     D Fetch_Event     PR
     D Close_Event     PR

     D sys_errno       PR              *   ExtProc('__errno')
     D errno           s             10i 0 based(p_errno)
      *
     D strerror        PR              *   ExtProc('strerror')
     D    errnum                     10I 0 value

     D CALL_STARTUP    C                   CONST(-2)
     D CALL_OPEN       C                   CONST(-1)
     D CALL_FETCH      C                   CONST(0)
     D CALL_CLOSE      C                   CONST(1)
     D CALL_FINAL      C                   CONST(2)

     D PARM_NULL       C                   CONST(-1)
     D PARM_NOTNULL    C                   CONST(0)

     D Epoch           s               z
     D dirh            s               *

      /free

          // -----------------------------------------
          // Verify that we received a directory name.
          // without that, there's nothing to be done.
          // -----------------------------------------

          if (n_dirname = PARM_NULL);
              SQL_State = '38999';
              MsgText = 'Directory name is required';
              return;
          endif;

          // -----------------------------------------
          //   Start all fields at NULL.
          // -----------------------------------------

          n_filename = PARM_NULL;
          n_size     = PARM_NULL;
          n_atime    = PARM_NULL;
          n_mtime    = PARM_NULL;
          n_ctime    = PARM_NULL;
          n_type     = PARM_NULL;
          n_ccsid    = PARM_NULL;
          n_owner    = PARM_NULL;
          n_group    = PARM_NULL;

          // -----------------------------------------
          //  Open, Fetch & Close IFS directory stuff
          // -----------------------------------------

          select;
          when  CallType = CALL_OPEN;
            Open_Event();
          when  CallType = CALL_FETCH;
            Fetch_Event();
          when  CallType = CALL_CLOSE;
            Close_Event();
          endsl;

          return;
      /end-free


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Open_Event(): This is called when SQL tells us to "open"
      *               the "table" that we're going to return.
      *               We use it for opening the directory.
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P Open_Event      B
     D Open_Event      PI

     D CEEUTCO         PR                  opdesc
     D   Hours                       10I 0
     D   Minutes                     10I 0
     D   Seconds                      8F
     D   fc                          12A   options(*omit)

     D junk1           s             10i 0
     D junk2           s             10i 0
     D secs            s              8f

      /free

       // ----------------------------------------------
       // All Unix API timestamps are supplied as a count
       // of the number of seconds since the "epoch"
       // (which is defined as midnight, Jan 1, 1970 UTC)
       //
       // Since the epoch is in the UTC time zone, we
       // will need to adjust it for the local computer's
       // time...  To get the adjustment, use CEEUTCO.
       // ----------------------------------------------

          CEEUTCO(junk1: junk2: secs: *omit);
          Epoch = z'1970-01-01-00.00.00.000000'
                + %seconds(%int(secs));


       // ----------------------------------------------
       //  Open the IFS directory
       // ----------------------------------------------

          dirh = opendir(%trim(dirname));
          if (dirh = *null);
             p_errno = sys_errno();
             MsgText = 'opendir: ' + %str(strerror(errno));
             SQL_State = '38998';
          endif;

          begsr *pssr;
            return;
          endsr;

      /end-free
     P                 E

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Fetch_Event(): This is called when SQL tells us to "fetch"
      *                a record from the "table".  We'll use it to
      *                read each file from the directory.
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P Fetch_Event     B
     D Fetch_Event     PI

     D Entry           ds                  likeds(dirent)
     D                                     based(p_entry)
     D info            ds                  likeds(statds64)
     D path            s          16384a   varying
     D own             ds                  likeds(passwd)
     D                                     based(p_own)
     D grp             ds                  likeds(group)
     D                                     based(p_grp)
      /free

              dou (filename<>'.' and filename<>'..');
                 p_entry = readdir(dirh);
                 if (p_entry = *null);
                    SQL_State = '02000';
                    return;
                 endif;
                 filename = %subst(entry.d_name:1:entry.d_namelen);
              enddo;

              n_filename = PARM_NOTNULL;

              path = %trim(dirname) + '/' + filename;
              if (lstat64(path: info) = -1);
                 p_errno = sys_errno();
                 MsgText = filename + ': ' + %str(strerror(errno));
                 SQL_State = '38997';
                 return;
              endif;

              size = info.st_size;
              n_size = PARM_NOTNULL;

              type  = %trim(info.st_objtype);
              n_type = PARM_NOTNULL;

              atime = epoch + %seconds(info.st_atime);
              n_atime = PARM_NOTNULL;

              mtime = epoch + %seconds(info.st_mtime);
              n_mtime = PARM_NOTNULL;

              ctime = epoch + %seconds(info.st_ctime);
              n_ctime = PARM_NOTNULL;

              ccsid = info.st_ccsid;
              n_ccsid = PARM_NOTNULL;

              p_own = getpwuid(info.st_uid);
              if (p_own = *null);
                 owner = %char(info.st_uid);
                 n_owner = PARM_NOTNULL;
              else;
                 owner = %str(own.pw_name);
                 n_owner = PARM_NOTNULL;
              endif;

              p_grp  = getgrgid(info.st_gid);
              if (p_grp = *null);
                 groupx = %char(info.st_gid);
                 n_group = PARM_NOTNULL;
              else;
                 groupx = %str(grp.gr_name);
                 n_group = PARM_NOTNULL;
              endif;

              begsr *pssr;
                return;
              endsr;

      /end-free
     P                 E

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Close_Event(): This is called when SQL tells us to "close"
      *                our "table".  We'll use it to close the dir
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P Close_Event     B
     D Close_Event     PI
      /free
          callp closedir(dirh);

          begsr *pssr;
             return;
          endsr;
      /end-free
     P                 E
