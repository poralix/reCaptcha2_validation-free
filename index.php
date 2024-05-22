<?php
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

error_reporting(0);

require_once('config.inc.php');

header("Expires: Mon, 29 Jun 1981 05:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

$_tpl_file = "_template/".preg_replace("/[^a-z0-9\.\-\_]/", "", strtolower($template_file));
if (!is_file($_tpl_file)) {
    $_tpl_file = "_template/captcha.tpl";
}
$_css_file = "_css/".preg_replace("/[^a-z0-9\.\-\_]/", "", strtolower($css_file));
if (!is_file($_css_file)) {
    $_css_file = "_css/core.css";
}
$ERROR = "";

$REF = (isset($_POST["ref"]) && $_POST["ref"]) ? $_POST["ref"] : ((isset($_GET["ref"]) && $_GET["ref"]) ? $_GET["ref"] : false);
$URI = (isset($_POST["uri"]) && $_POST["uri"]) ? $_POST["uri"] : ((isset($_GET["uri"]) && $_GET["uri"]) ? $_GET["uri"] : false);
$REDIRECTED_IP = (isset($_POST["c"]) && $_POST["c"]) ? $_POST["c"] : ((isset($_GET["c"]) && $_GET["c"]) ? $_GET["c"] : false);
$CLIENT_IP = (isset($_SERVER["REMOTE_ADDR"]) && $_SERVER["REMOTE_ADDR"]) ? $_SERVER["REMOTE_ADDR"] : false;

# DETECT USER's LANGUAGE
$_lang_dir = "_lang/";
$LANG = (isset($_SERVER["HTTP_ACCEPT_LANGUAGE"]) && $_SERVER["HTTP_ACCEPT_LANGUAGE"]) ? strtoupper(substr($_SERVER["HTTP_ACCEPT_LANGUAGE"], 0, 2)): "EN";
if (!preg_match('/^[A-Za-z]*$/', $LANG)){$LANG = "EN";}
$_lang_default_file = (is_file($_lang_dir."lang_".$LANG.".php")) ? $_lang_dir."lang_".$LANG.".php" : $_lang_dir."lang_EN.php";
$_LANG['default'] = parse_ini_file($_lang_default_file, false);

$publickey = htmlspecialchars(strip_tags($publickey));
$company_site = htmlspecialchars(strip_tags($company_site));
$company_name = htmlspecialchars(strip_tags($company_name));

if ($company_site && $company_name) {
    $HOSTED_BY = sprintf($_LANG['default']['HOSTED_BY'], "<a href='".$company_site."' target='_blank'>".$company_name."</a>");
} else {
    $HOSTED_BY = '';
}

$recaptcha_response = (isset($_POST["g-recaptcha-response"]) && $_POST["g-recaptcha-response"]) ? $_POST["g-recaptcha-response"] : false;
$api_response = false;

if ($recaptcha_response)
{
    $ERRORS = [
        'missing-input-secret' => 'The secret parameter is missing.',
        'invalid-input-secret' => 'The secret parameter is invalid or malformed.',
        'missing-input-response' => 'The response parameter is missing.',
        'invalid-input-response' => 'The response parameter is invalid or malformed.',
    ];

    if($curl = curl_init())
    {
        curl_setopt($curl, CURLOPT_URL, 'https://www.google.com/recaptcha/api/siteverify');
        curl_setopt($curl, CURLOPT_RETURNTRANSFER,true);
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, "secret=".$privatekey."&remoteip=".$CLIENT_IP."&response=".$recaptcha_response);
        if ($api_response = curl_exec($curl))
        {
            $api_response = json_decode($api_response);
        }
        curl_close($curl);

        if (is_object($api_response) && ($api_response->success === true))
        {
            // successful verification
            if ($CLIENT_IP)
            {
                $IPF = $datadir."_".$CLIENT_IP.".dat";
                if (is_dir($datadir))
                {
                    if ($handle = fopen($IPF, 'w'))
                    {
                        fclose($handle);
                    }
                }
            }
            // redirect back
            if (strpos($URI,"?")!==false)
            {
                $URI.="&validated=".md5(uniqid(time()));
            }
            else
            {
                $URI.="?validated=".md5(uniqid(time()));
            }
            $location = urldecode($REF."".$URI);
            header("Location: ".$location."\n");
        }
    }
}

$CAPTCHA = '<div class="g-recaptcha" data-sitekey="'.$publickey.'"></div>';



if (is_file($_tpl_file) && ($TPL = file_get_contents($_tpl_file)))
{
    if (isset($use_local_css) && $use_local_css == false)
    {
        $LOAD_BOOTSTRAP_CSS = '<link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">';
        $LOAD_CORE_CSS = "\n<style type='text/css'>\n".(is_file($_css_file) ? file_get_contents($_css_file) : "" )."\n</style>\n";
    }
    else
    {
        $LOAD_BOOTSTRAP_CSS = '<link href="/__captcha_validation/_css/bootstrap.min.css" rel="stylesheet">';
        $LOAD_CORE_CSS = '<link href="/__captcha_validation/_css/core.css" rel="stylesheet">';
    }
    if (isset($use_local_js) && $use_local_js == false)
    {
        $LOAD_JQUERY_JS = '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>';
        $LOAD_BOOTSTRAP_JS = '<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"></script>';
    }
    else
    {
        $LOAD_JQUERY_JS = '<script src="/__captcha_validation/_js/jquery-3.7.1.min.js"></script>';
        $LOAD_BOOTSTRAP_JS = '<script src="/__captcha_validation/_js/bootstrap.min.js"></script>';
    }

    $LANG_WARNING = "";
    if ($REDIRECTED_IP && ($REDIRECTED_IP !== $CLIENT_IP))
    {
        $LANG_WARNING = sprintf($_LANG['default']['WARNING'],htmlspecialchars($REF),$CLIENT_IP);
    }

    $HTML = $TPL;
    $REPLACES = [
        "LANG"               => $LANG,
        "CAPTCHA"            => $CAPTCHA,
        "SITEKEY"            => $publickey,
        "ERROR"              => $ERROR,
        "REF"                => addslashes(htmlspecialchars($REF)),
        "URI"                => addslashes(htmlspecialchars($URI)),
        "LOAD_JQUERY_JS"     => $LOAD_JQUERY_JS,
        "LOAD_BOOTSTRAP_JS"  => $LOAD_BOOTSTRAP_JS,
        "LOAD_BOOTSTRAP_CSS" => $LOAD_BOOTSTRAP_CSS,
        "LOAD_CORE_CSS"      => $LOAD_CORE_CSS,
        "COMPANY_HTML"       => $COMPANY_HTML,
        "LANG_TITLE"         => $_LANG['default']['TITLE'],
        "LANG_NO_JS"         => $_LANG['default']['NO_JS'],
        "LANG_MAIN_TEXT"     => $_LANG['default']['MAIN_TEXT'],
        "LANG_HOSTED_BY"     => $HOSTED_BY,
        "LANG_WARNING"       => $LANG_WARNING,
    ];
    foreach ($REPLACES as $TOKEN => $VAL)
    {
        $HTML = str_replace("|".$TOKEN."|",$VAL,$HTML);
    }
}
else
{
    $HTML = $CAPTCHA;
}

print $HTML;
exit;
