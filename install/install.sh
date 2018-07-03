#!/bin/sh
# set -x
##############################################################################
#
#    Serverwide reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.5-Free
#
#    Copyright (C) 2016-2018 Alex S Grebenschikov
#    Written by Alex S Grebenschikov
#            web-site:  www.poralix.com
#            emails to: support@poralix.com
#
#    Last modified: Tue Jul  3 14:03:43 +07 2018
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

echo
echo "Detecting Control Panel on your server!";
echo

if [ -e "/usr/local/directadmin/directadmin" ]; then
	echo "Running reCAPTCHA VALIDATION DirectAdmin installer"
	echo
	sh install.directadmin.sh
elif [ -e "/usr/local/cpanel/version" ]; then
	echo "Running reCAPTCHA VALIDATION cPanel installer"
	echo
	sh install.cpanel.sh
else
	echo "Running reCAPTCHA VALIDATION generic installer"
	echo
	sh install.generic.sh
fi
