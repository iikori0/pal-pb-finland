A tool to generate the Personal Best Scores of Pal Tetris at the wordpress page tetrissuomi.wordpress.com/tuloksia/pb-lista
Lynx is required for dumping the page for further regex parsing.

Usage:
Step1:
./step1-leivo-tetrissuomi-wordpress.com-pal-pb-lista.sh

Step2:
compare the received data to pb-list-2025-12-07.example, fe: vimdiff pb-list-2025-12-07.example pb-list-2025-12-08
if the data seems intact and valid, proceed to generate the html page:

Step3:
./step3-wordpressify-ascii-pbs-to-html-table.sh pb-list-2025-12-08 > pb-page.html

Step4: 
open pb-page.html with firefox and hit CTRL+u, copy everything between the tags:
<!-- *** SNIP YOUR COPYING STARTS HERE *** // --> and <!-- *** SNIP YOUR COPYING ENDS HERE *** -->

Step5: Click the table in tetrissuomi.wordpress.com/tuloksia/pb-lista in edit mode and click the option dots and select 'Edit as HTML'
paste the text you copied, save the page. 

