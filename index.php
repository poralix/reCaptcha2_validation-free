<?php
##############################################################################
#
#    Serverwide reCAPTCHA VALIDATION FOR WordPress Login page $ v.0.7-Free
#
#    Copyright (C) 2016-2018 Alex S Grebenschikov
#    Written by Alex S Grebenschikov
#            web-site:  www.poralix.com
#            emails to: support@poralix.com
#
#    Last modified: Thu Nov  1 13:42:11 +07 2018
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

$_tpl_file="_template/".preg_replace("/[^a-z0-9\.\-\_]/", "", strtolower($template_file));
if (!is_file($_tpl_file)) {
    $_tpl_file="_template/captcha.tpl";
}
$_css_file="_css/".preg_replace("/[^a-z0-9\.\-\_]/", "", strtolower($css_file));
if (!is_file($_css_file)) {
    $_css_file="_css/core.css";
}
$ERROR="";

$REF=(isset($_POST["ref"]) && $_POST["ref"]) ? $_POST["ref"] : ((isset($_GET["ref"]) && $_GET["ref"]) ? $_GET["ref"] : false);
$URI=(isset($_POST["uri"]) && $_POST["uri"]) ? $_POST["uri"] : ((isset($_GET["uri"]) && $_GET["uri"]) ? $_GET["uri"] : false);
$REDIRECTED_IP=(isset($_POST["c"]) && $_POST["c"]) ? $_POST["c"] : ((isset($_GET["c"]) && $_GET["c"]) ? $_GET["c"] : false);
$CLIENT_IP=(isset($_SERVER["REMOTE_ADDR"]) && $_SERVER["REMOTE_ADDR"]) ? $_SERVER["REMOTE_ADDR"] : false;
$LANG=(isset($_SERVER["HTTP_ACCEPT_LANGUAGE"]) && $_SERVER["HTTP_ACCEPT_LANGUAGE"]) ? strtolower(substr($_SERVER["HTTP_ACCEPT_LANGUAGE"], 0, 2)): "en";

$publickey = htmlspecialchars(strip_tags($publickey));
$company_site = htmlspecialchars(strip_tags($company_site));
$company_name = htmlspecialchars(strip_tags($company_name));

if ($company_site && $company_name) {
    $COMPANY_HTML = "<a href='".$company_site."' target='_blank'>".$company_name."</a>";
} else {
    $COMPANY_HTML = '';
}

$recaptcha_response=(isset($_POST["g-recaptcha-response"]) && $_POST["g-recaptcha-response"]) ? $_POST["g-recaptcha-response"] : false;
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
                $IPF=$datadir."_".$CLIENT_IP.".dat";
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
            $location=urldecode($REF."".$URI);
            header("Location: ".$location."\n");
        }
    }
}

$CAPTCHA='<div class="g-recaptcha" data-sitekey="'.$publickey.'"></div>';

if (is_file($_tpl_file) && ($TPL=file_get_contents($_tpl_file)))
{
    if (isset($use_local_css) && $use_local_css == false)
    {
        $LOAD_BOOTSTRAP_CSS = '<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">';
        $LOAD_CORE_CSS = "\n<style type='text/css'>\n".(is_file($_css_file) ? file_get_contents($_css_file) : "" )."\n</style>\n";
    }
    else
    {
        $LOAD_BOOTSTRAP_CSS = '<link href="/__captcha_validation/_css/bootstrap.min.css" rel="stylesheet">';
        $LOAD_CORE_CSS = '<link href="/__captcha_validation/_css/core.css" rel="stylesheet">';
    }
    if (isset($use_local_js) && $use_local_js == false)
    {
        $LOAD_JQUERY_JS = '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>';
        $LOAD_BOOTSTRAP_JS = '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>';
    }
    else
    {
        $LOAD_JQUERY_JS = '<script src="/__captcha_validation/_js/jquery-2.2.2.min.js"></script>';
        $LOAD_BOOTSTRAP_JS = '<script src="/__captcha_validation/_js/bootstrap.min.js"></script>';
    }

    if ($REDIRECTED_IP && ($REDIRECTED_IP !== $CLIENT_IP))
    {
        $WARNING_EN = 'We detected that IP address from which you connected to <a href="'.htmlspecialchars($REF).'" target="_blank">the target site</a> differs from the current IP <b>'.$CLIENT_IP.'</b>, and it might bring to issues with IP validation.';
        $WARNING_NL = 'We hebben vastgesteld dat het IP-adres waarmee u verbinding hebt gemaakt met <a href="'.htmlspecialchars($REF).'" target="_blank">de doelsite</a> anders is dan het huidige IP-adres <b>'.$CLIENT_IP.'</b>, en dit kan problemen met IP-validatie veroorzaken.';
        $WARNING_RU = 'IP адрес, с которого вы подключились <a href="'.htmlspecialchars($REF).'" target="_blank">к сайту</a> не соответствует текущему <b>'.$CLIENT_IP.'</b>, что в свою очередь может привести к зацикливанию авторизации IP.';
        $WARNING_TR = 'Sistemlerimiz <a href="'.htmlspecialchars($REF).'" target="_blank">hedef siteye</a> bağlanmak için kullandığınız IP adresinin, şu an kullandığınızdan <b>'.$CLIENT_IP.'</b> farklı olduğunu tespit etti, bu IP doğrulaması sırasında sorunlar oluşturabilir.';
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
        "WARNING_EN"         => $WARNING_EN,
        "WARNING_NL"         => $WARNING_NL,
        "WARNING_RU"         => $WARNING_RU,
        "WARNING_TR"         => $WARNING_TR,        
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
