# Version

Serverwide reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.9-Free (beta)

# Copyright notice

Copyright (C) 2016-2024 Alex S Grebenschikov.
Written by Alex S Grebenschikov.

Turkish translation made by Evrim Altay Koluaçık (@altayevrim)
Spanish translation made by Roberto Alvarado (@ralvaradof)

Copyright (c) 2007 reCAPTCHA -- http://recaptcha.net
AUTHORS: Mike Crawford, Ben Maurer


# Contacts

- web-site:  https://www.poralix.com/

# About

- With this you will have a Google's reCaptcha 2 installed server-wide.
- No need to install reCaptcha individually per user or per site.
- The addon will remember user's IP for 7 days (default, can be changed).
- English/Dutch/Russian languages shipped by default.
- IP detections works for sites behind CloudFlare proxy.

# How it works

- A visitor or an admin accesses http://domain.com/wp-login.php.
- Web-server checks whether or not a visitor's IP is already validated.
- If the IP is not validated yet the visitor gets redirected to a page with Google's reCaptcha 2 (page is located on server's hostname).
- As soon as reCaptcha is solved the visitor will be returned to a login page and the IP will be stored as trusted for the next 7 days.

# Supported Control Panels

- Directadmin (with CustomBuild 2.x).
- cPanel (not much tested yet).
- With No control panel servers.

# Requirements

- Apache is required either as a front-end or a back-end behind NGINX as a reverse proxy.
- PHP.
- Pair of keys from https://www.google.com/recaptcha/admin registered for your hostname.

# IPv6 

**IMPORTANT** Since users are redirected to http://hostname/ you should make sure that your hostname has a valid IPv6 record in order to validation 
for IPv6 to work properly!

# Installation

```
cd /usr/local/src
wget -O reCaptcha2_validation-free.tar.gz https://github.com/poralix/reCaptcha2_validation-free/archive/master.tar.gz
tar -zxvf reCaptcha2_validation-free.tar.gz
cd reCaptcha2_validation-free-master/install/
./install.sh
```
and clean files:
```
cd /usr/local/src
rm -rf reCaptcha2_validation*
rm -rf /var/www/html/reCaptcha2_validation-free.tar.gz
```

- After installation is completed you should visit https://www.google.com/recaptcha/admin and register your hostname.
- You will get _Site key_ and _Secret key_ which you should add into the config file: config.inc.php.
- Open ${DIR_INSTALL}/config.inc.php and update:
```
$publickey  = "<Site Key>";';
$privatekey = "<Secret Key>";';
```
with your actual keys!

# Uninstallation

In case you want to remove the reCaptcha run the script:

```
cd $(ls -1d /var/www/html/__captcha_validation_free-*)
./uninstall/uninstall.sh
```

After the script cleans cron and Apache config you can remove the directory `/var/www/html/__captcha_validation_free-*`

# Exclude a domain from reCaptcha protection

Since version 0.6 you can disable reCaptcha for one or several domains by following the guide:

- Go to a document root of your domain (for directadmin servers it's under public_html/ or pritvate_html/ directories)
- Create an empty file .disable_recaptcha

# Enable reCaptcha for a domain

If you previously disabled reCaptcha for a domain follow the guide to enable it back:

- Go to a domain's document root
- Remove a file .disable_recaptcha

# History of changes

- version 0.9: Spanish translation added. Switched to jQuery v3.7.1 and Bootstrap v4.6.2. Code optimization added.
- version 0.8: Turkish translation added. Switched to jQuery 2.2.4.
- version 0.7: Uninstall scripts added
- version 0.6: New feature: excluding domains from reCaptcha protection 
- version 0.5: Fixed issues with connecting custom templates
- version 0.4: Updated template with a new model of reCaptcha render, added usage of grecaptcha.reset().

# LICENSE

```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```