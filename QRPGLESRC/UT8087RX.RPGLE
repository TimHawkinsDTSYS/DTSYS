      /TITLE Utility, Email (test)
      *PARMS
      *
      /copy qcpysrc,Hspec
      /copy qcpysrc,Dspec

     D Subject         s                   like(StdStg) inz
     D Body            s                   like(StdBuf) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       Subject = 'Test of HTML email.';


       Body =
       '<html xmlns:v="urn:schemas-microsoft-com:vml" ' +
            ' xmlns:o="urn:schemas-microsoft-com:office:office" ' +
            ' xmlns:w="urn:schemas-microsoft-com:office:word" ' +
            ' xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
            ' xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" ' +
            ' xmlns="http://www.w3.org/TR/REC-html40"> ';

       Body = %trim(body) + ' ' +
              '<head> ';

       Body = %trim(body) + ' ' +
              ' <META HTTP-EQUIV="Content-Type" ' +
              '  CONTENT="text/html; charset=us-ascii"> ' +
              '  <meta name=Generator content="Microsoft Word 14 +
                       (filtered medium)"> ';

       Body = %trim(body) + ' ' +
              ' <style> ';


       Body = %trim(body) + ' ' +
              ' <!-- ';

       Body = %trim(body) + ' ' +
              ' /* Font Definitions */ +
                @font-face +
                 {font-family:Calibri; +
                 panose-1:2 15 5 2 2 2 4 3 2 4;} +
                @font-face +
                 {font-family:Tahoma; +
                 panose-1:2 11 6 4 3 5 4 4 2 4;} +
                @font-face +
                 {font-family:Verdana; +
                 panose-1:2 11 6 4 3 5 4 4 2 4;} +
                /* Style Definitions */ +
                p.MsoNormal, li.MsoNormal, div.MsoNormal +
                 margin-bottom:.0001pt; +
                 font-size:11.0pt; +
                 font-family:"Calibri","sans-serif";} +
                a:link, span.MsoHyperlink +
                 {mso-style-priority:99; +
                 color:blue; +
                 text-decoration:underline;} +
                a:visited, span.MsoHyperlinkFollowed +
                 {mso-style-priority:99; +
                 color:purple; +
                 text-decoration:underline;} +
                span.EmailStyle17 +
                 {mso-style-type:personal; +
                 font-family:"Arial","sans-serif"; +
                 font-variant:normal !important; +
                 color:#17365D; +
                 text-transform:none;} +
                span.EmailStyle18 +
                 {mso-style-type:personal-reply; +
                 font-family:"Verdana","sans-serif"; +
                 color:#1F497D;} +
                .MsoChpDefault +
                 {mso-style-type:export-only; +
                 font-size:10.0pt;} +
                @page WordSection1 +
                 {size:8.5in 11.0in; +
                 margin:1.0in 1.0in 1.0in 1.0in;} +
                div.WordSection1 +
                 {page:WordSection1;} ';

       Body = %trim(body) + ' ' +
              ' --> ';

       Body = %trim(body) + ' ' +
              '</style>';

       Body = %trim(body) + ' ' +
              ' <!--[if gte mso 9]> ';

       Body = %trim(body) + ' ' +
              ' <xml> +
                <o:shapedefaults +
                 v:ext="edit" +
                   spidmax="1026" /> +
                </xml> ';

       Body = %trim(body) + ' ' +
             ' <![endif]--><!--[if gte mso 9]><xml> ';

       Body = %trim(body) + ' ' +
              ' <o:shapelayout v:ext="edit"> ' +
              ' <o:idmap v:ext="edit" data="1" /> ' +
              ' </o:shapelayout></xml><![endif]--> ';

       Body = %trim(body) + ' ' +
              ' </head> ';

       Body = %trim(body) + ' ' +
       ' <body lang=EN-US link=blue vlink=purple><div +
        class=WordSection1><p class=MsoNormal> ';

       Body = %trim(body) + ' ' +
        ' <span style=''font-family:"Verdana","sans-serif";color:#1F497D''> ' +
        ' Yup, have done.<o:p></o:p></span></p><p class=MsoNormal><span ' +
        ' style=''font-family:"Verdana", ' +
        ' "sans-serif";color:#1F497D''><o:p>&nbsp; ' +
        ' </o:p></span></p><p ' +
        ' class=MsoNormal><span style=''font-family: ' +
        ' "Verdana","sans-serif";color:#1F497D''>Encouraged a ' +
        ' reply based on our experience, ' +
        ' sent to all for quick consensus.&nbsp; We&#8217;ll ' +
        ' We&#8217;ll see. ' +
          ' <o:p></o:p></span></p> ' +
          ' <p class=MsoNormal> ';

       Body = %trim(body) + ' ' +
              ' <span style=''font-family:"Verdana","sans-serif"; ' +
              ' color:#1F497D''><o:p>&nbsp;</o:p></span></p> ' +
              ' <p class=MsoNormal><span style=''font-family:"Verdana", ' +
              ' "sans-serif";color:#1F497D''> ';

       Body = %trim(body) + ' ' +
              ' If they don&#8217;t reply by tonight, ' +
              '   we&#8217;ll try to ping them again.' +
              ' <o:p></o:p></span></p> ';

       Body = %trim(body) + ' ' +
              '<o:p></o:p></span></p></div></body></html> ';

       joblog('Subject=' + %trim(Subject));
       joblog('Body='    + %trim(Body));

       SndEmlInd(*omit: 'timh@cruzio.com':
                 Subject: Body: *omit: '*HTML');

       *inLR = *on;

      /end-free
