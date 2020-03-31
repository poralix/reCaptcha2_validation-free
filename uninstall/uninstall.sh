#!/bin/sh
# set -x
##############################################################################
#
#    Serverwide reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.7-Free
#
#    Copyright (C) 2016-2020 Alex S Grebenschikov
#    Written by Alex S Grebenschikov
#            web-site:  www.poralix.com
#            emails to: support@poralix.com
#
#    Last modified: Wed Apr  1 02:24:29 +07 2020
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

RUN_DIR="$(dirname "$(readlink -fm "$0")")"; #"

echo
echo "Detecting Control Panel on your server!";
echo

if [ -e "/usr/local/directadmin/directadmin" ]; then
    echo "Running reCAPTCHA VALIDATION DirectAdmin uninstaller";
    echo;
    sh "${RUN_DIR}/uninstall.directadmin.sh";
elif [ -e "/usr/local/cpanel/version" ]; then
    echo "Running reCAPTCHA VALIDATION cPanel uninstaller";
    echo;
    sh "${RUN_DIR}/uninstall.cpanel.sh";
else
    echo "Running reCAPTCHA VALIDATION generic uninstaller";
    echo;
    sh "${RUN_DIR}/uninstall.generic.sh";
fi
