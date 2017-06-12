# Version

reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.2-Free

# Copyright notice

Copyright (C) 2016  Alex S Grebenschikov.
Written by Alex S Grebenschikov.

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
- cPanel.
- With No control panel servers.

# Requirements

- Apache is required either as a front-end or a back-end behind NGINX as a reverse proxy.
- PHP.
- Pair of keys from https://www.google.com/recaptcha/admin registered for your hostname

# Installation

- After installation is completed you should visit https://www.google.com/recaptcha/admin and register your hostname
- You will get <Site key> and <Secret key> which you should add into the config file: config.inc.php
- Open ${DIR_INSTALL}/config.inc.php and update:
```
$publickey  = "<Site Key>";';
$privatekey = "<Secret Key>";';
```
with your actual keys!
