#!/bin/bash

L_PLUGINS_DIR='www/statusproject/public_html/'
R_PLUGINS_DIR='/public_html/'

L_SRP_THEME_DIR='www/statusproject/public_html/'
R_SRP_THEME_DIR='/public_html/'

echo "uploading plugins from $L_PLUGINS_DIR to $R_PLUGINS_DIR ..."

lftp <<EOF
set ftp:list-options -a
set cmd:fail-exit true
open 103157_haz38_do@ftp01.binero.se
cd $R_PLUGINS_DIR
lcd $L_PLUGINS_DIR
mirror --delete --exclude logs/ --exclude tmp/ --exclude-glob .git
quit
EOF

echo "done"

echo "uploading SRP theme from $L_SRP_THEME_DIR to $R_SRP_THEME_DIR .."

lftp <<EOF
set ftp:list-options -a
set cmd:fail-exit true
open 103157_haz38_do@ftp01.binero.se
cd $R_SRP_THEME_DIR
lcd $L_SRP_THEME_DIR
mirror --delete --exclude logs/ --exclude tmp/ --exclude-glob .git
quit
EOF

echo "done"
