#!/bin/bash
#set -x
##############################################################################
#
#    Serverwide reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.10-Free
#
#    Copyright (C) 2016-2024 Alex S Grebenschikov
#    Written by Alex S Grebenschikov
#            web-site:  www.poralix.com
#            emails to: support@poralix.com
#
#    Last modified: Mon Oct  7 23:09:36 +07 2024
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#############################################################################
#
#    Copyright (c) 2007 reCAPTCHA -- http://recaptcha.net
#    AUTHORS:
#          Mike Crawford
#          Ben Maurer
#
#############################################################################

V="v.0.10-Free";

copyright()
{
    echo "##############################################################################";
    echo "#                                                                            #";
    echo "#    reCAPTCHA VALIDATION FOR WordPress Login page $ ${V}              #";
    echo "#                                                                            #";
    echo "#    Copyright (C) 2016-2024  Alex S Grebenschikov                           #";
    echo "#    Written by Alex S Grebenschikov                                         #";
    echo "#            web-site:  www.poralix.com                                      #";
    echo "#            emails to: support@poralix.com                                  #";
    echo "#                                                                            #";
    echo "##############################################################################";
    echo "";
}

if [ ! -e "/usr/local/cpanel/version" ]; then
    echo "[ERROR] cPanel was not found on the server! Terminating...";
    exit 1;
fi;

copyright;

TMP_FILE="/var/www/html/reCaptcha2_validation-free.tar.gz";
TMP_DIR=$(mktemp -d /var/www/html/tmp_reCaptcha2_validation.XXXXX);

DIR_INSTALL="/var/www/html/__captcha_validation_free-$(hostname -f | openssl md5 | sed 's/^.* //')";
CRON_FILE="/etc/cron.daily/clear_recaptcha_ips.cron";

URL="https://github.com/poralix/reCaptcha2_validation-free/archive/master.tar.gz";
wget -q --no-check-certificate ${URL} -O ${TMP_FILE};

if [ ! -s "${TMP_FILE}" ]; then
    echo "[ERROR] Failed to download file! Terminating...";
    exit 2;
fi;

echo "Going to install into ${DIR_INSTALL}";

[ -d "${DIR_INSTALL}" ] || mkdir -p "${DIR_INSTALL}";

# Backuping config file
if [ -f "${DIR_INSTALL}/config.inc.php" ]; then
    TF1="${DIR_INSTALL}/config.inc.php~$(date +%Y%m%d%H%M%S)";
    cp -pf "${DIR_INSTALL}/config.inc.php" ${TF1};
fi;

# Backuping template file
if [ -f "${DIR_INSTALL}/_template/captcha.tpl" ]; then
    TF2="${DIR_INSTALL}/_template/captcha.tpl~$(date +%Y%m%d%H%M%S)";
    cp -pf "${DIR_INSTALL}/_template/captcha.tpl" ${TF2};
fi;

# Unpacking files
tar -zxf "${TMP_FILE}" -C ${TMP_DIR} --strip-components=1;
cp -rf ${TMP_DIR}/* "${DIR_INSTALL}";
rm -rf "${TMP_DIR}";
[ -d "${DIR_INSTALL}/_data/ips/" ] || mkdir -p "${DIR_INSTALL}/_data/ips/";
chown -R nobody:nobody ${DIR_INSTALL};

# Restoring config file
if [ -f "${TF1}" ]; then
    cp -pf "${DIR_INSTALL}/config.inc.php" "${DIR_INSTALL}/config.inc.php~new";
    cp -pf "${TF1}" "${DIR_INSTALL}/config.inc.php";
    rm -f "${TF1}";
fi;

# Restoring template file
if [ -f "${TF2}" ]; then
    cp -pf "${DIR_INSTALL}/_template/captcha.tpl" "${DIR_INSTALL}/_template/captcha.tpl~new";
    cp -pf "${TF2}" "${DIR_INSTALL}/_template/captcha.tpl";
    rm -f "${TF2}";
fi;

echo "Installing cron job ${CRON_FILE}";

[ -e "${CRON_FILE}" ] || ln -s ${DIR_INSTALL}/cron/run_with_cron ${CRON_FILE};
perl -pi -e "s#\|DIR_INSTALL\|#${DIR_INSTALL}#" ${DIR_INSTALL}/cron/run_with_cron;
chmod 755 ${DIR_INSTALL}/cron/run_with_cron;

echo "Updating Apache configs";

HIC_FILE="/usr/local/apache/conf/includes/pre_virtualhost_global.conf";
HPRC_FILE="/usr/local/apache/conf/includes/poralix-recaptcha.conf";

if [ ! -f "${HIC_FILE}" ]; then
    touch "${HIC_FILE}";
    chmod 600 "${HIC_FILE}";
fi;

touch ${HPRC_FILE};
copyright > ${HPRC_FILE};
echo "" >> ${HPRC_FILE};
echo 'Alias "/__captcha_validation/" "'${DIR_INSTALL}'/"' >> ${HPRC_FILE};
echo "" >> ${HPRC_FILE};
echo '<LocationMatch "wp-login.php">' >> ${HPRC_FILE};
echo '        RewriteCond %{DOCUMENT_ROOT}/.disable_recaptcha !-f' >> ${HPRC_FILE};
echo '        RewriteCond '${DIR_INSTALL}'/_data/ips/_%{REMOTE_ADDR}.dat !-f' >> ${HPRC_FILE};
echo '        RewriteCond '${DIR_INSTALL}'/_data/ips/_%{HTTP:X-Forwarded-For}.dat !-f' >> ${HPRC_FILE};
echo '        RewriteCond '${DIR_INSTALL}'/_data/ips/_%{HTTP:CF-Connecting-IP}.dat !-f' >> ${HPRC_FILE};
echo '        RewriteRule ^ http://'$(hostname -f)'/__captcha_validation/?ref=%{REQUEST_SCHEME}://%{SERVER_NAME}&uri=%{REQUEST_URI}&c=%{REMOTE_ADDR} [L]' >> ${HPRC_FILE};
echo '</LocationMatch>' >> ${HPRC_FILE};
echo "" >> ${HPRC_FILE};

c=`grep -c ${HPRC_FILE} ${HIC_FILE}`;
if [ "$c" == "0" ]; then
    echo "##-- Poralix reCaptcha Validation for WordPress --##" >> ${HIC_FILE};
    echo "Include ${HPRC_FILE}" >> ${HIC_FILE};
    echo "##-- Poralix reCaptcha Validation for WordPress --##" >> ${HIC_FILE};
fi;

[ -d "${DIR_INSTALL}/install" ] && rm -rf "${DIR_INSTALL}/install";

service httpd restart;

echo "Installation completed";
echo "";
echo "IMPORTANT!";
echo "  Go to https://www.google.com/recaptcha/admin#list and register your $(hostname -f) there";
echo "  You will get <Site key> and <Secret key> which you should add into the config file: config.inc.php";
echo "  Open ${DIR_INSTALL}/config.inc.php and update:"
echo "";
echo '    $publickey  = "<Site Key>";';
echo '    $privatekey = "<Secret Key>";';
echo "";
echo "  with your actual keys!";

exit 0;
