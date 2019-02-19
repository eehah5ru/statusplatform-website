#!/bin/bash

ask() {
    # https://gist.github.com/davejamesmiller/1965569
    local prompt default reply

    if [ "${2:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

L_PLUGINS_DIR='/srv/www/statusproject/public_html/wp-content/plugins/'
R_PLUGINS_DIR='/public_html/wp-content/plugins/'

L_SRP_THEME_DIR='/srv/www/statusproject/public_html/wp-content/themes/statusproject/'
R_SRP_THEME_DIR='/public_html/wp-content/themes/statusproject/'

L_UPLOADS_DIR='/srv/statusproject-uploads'
R_UPLOADS_DIR='/public_html/wp-content/uploads/'

USER='103157_haz38_do'
HOST='ftp01.binero.se'
read -s -p "Enter password for $USER@$HOST: " PASSWORD

echo " "
echo "starting..."


cd $L_SRP_THEME_DIR \
    && echo "building theme" \
    && npm run build \
    && echo "done" \
    && echo "uploading SRP theme from $L_SRP_THEME_DIR to $R_SRP_THEME_DIR .." \
    && lftp -e "mirror -R --exclude .git/ --exclude node_modules/ --exclude tmp/ $L_SRP_THEME_DIR $R_SRP_THEME_DIR; bye;" -u $USER,"$PASSWORD" $HOST \
    && echo "done"

# if ask "upload plugins?"; then
#     echo "uploading plugins from $L_PLUGINS_DIR to $R_PLUGINS_DIR ..."

#     lftp -e "mirror -R --exclude logs/ --exclude tmp/ --exclude-glob .git $L_PLUGINS_DIR $R_PLUGINS_DIR; bye;" -u $USER,"$PASSWORD" $HOST

#     echo "done"
# fi

# if ask "upload uploads dir?"; then
#     echo "uploading uploads from $L_UPLOADS_DIR to $R_UPLOADS_DIR ..."

#     lftp -e "mirror -R -O $R_UPLOADS_DIR --exclude logs/ --exclude tmp/ --exclude-glob .git -F $L_UPLOADS_DIR/*; bye;" -u $USER,"$PASSWORD" $HOST

#     echo "done"
# fi
