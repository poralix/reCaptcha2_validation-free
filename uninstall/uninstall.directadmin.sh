#!/bin/bash
# set -x
##############################################################################
#
#    Serverwide reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.9-Free
#
#    Copyright (C) 2016-2024 Alex S Grebenschikov
#    Written by Alex S Grebenschikov
#            web-site:  www.poralix.com
#            emails to: support@poralix.com
#
#    Last modified: Wed May 22 15:30:46 +07 2024
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

V="v.0.9-Free";

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

if [ ! -d "/usr/local/directadmin" ] || [ ! -e "/usr/local/directadmin/directadmin" ]; then
    echo "[ERROR] Directadmin was not found on the server! Terminating...";
    exit 1;
fi;

copyright;

CRON_FILE="/etc/cron.daily/clear_recaptcha_ips.cron";
echo "Uninstalling cron job ${CRON_FILE}";
[ -e "${CRON_FILE}" ] && rm -fv "${CRON_FILE}";

echo "Updating Apache configs";
HIC_FILE="/etc/httpd/conf/extra/httpd-includes.conf";
HPRC_FILE="/etc/httpd/conf/extra/httpd-poralix-recaptcha.conf";

if [ -f "${HIC_FILE}" ]; then
    cp -p "${HIC_FILE}" "${HIC_FILE}.old";
    cat "${HIC_FILE}" | grep -Ev "(Poralix reCaptcha|Include ${HPRC_FILE})" >> "${HIC_FILE}.new";
    cat "${HIC_FILE}.new" > "${HIC_FILE}";
    rm -f "${HIC_FILE}.new";
fi;

test -f "${HPRC_FILE}" && rm -fv "${HPRC_FILE}";

if [ -x "/bin/systemctl" ]; then
    /bin/systemctl restart httpd;
elif [ -x "/sbin/service" ]; then
    /sbin/service httpd restart;
else
    echo "You need to restart Apache manually...";
fi;

echo "Uninstallation completed";

exit 0;
