<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Serverwide reCAPTCHA VALIDATION FOR WordPress Login page by Poralix $ v.0.10-Free //-->
    <title>|LANG_TITLE|</title>
    <!-- Core CSS -->
    |LOAD_BOOTSTRAP_CSS|
    |LOAD_CORE_CSS|
</head>
<body>
    <div class="container h-100">
        <div class="h-100 justify-content-center align-items-center">
            <div class="row">
                <div class="">
                    <noscript><div class="alert alert-danger"><p>|LANG_NO_JS|</p></div></noscript>
                </div>
            </div>
            <div class="row justify-content-center align-items-center p-4">
                <div class="card" style="width: 40rem;">
                    <div class="card-header">
                        <div class="font-weight-normal">|LANG_TITLE|</div>
                    </div>
                    <div class="card-body">
                        <form id="validate" action="" method="post">
                            <div id="lang-main-text" class="font-weight-normal">|LANG_MAIN_TEXT|</div>
                            <div id="lang-warning" class="font-weight-normal warning">|LANG_WARNING|</div>
                            <div class="p-4">
                                <center id="captcha">
                                    <div id="container"></div>
                                    <script type="text/javascript"></script>
                                    <input type="hidden" name="ref" value="|REF|" />
                                    <input type="hidden" name="uri" value="|URI|" />
                                </center>
                            </div>
                            <div class="text-center"><button type="submit" class="btn btn-primary" style="">Confirm</button></div>
                        </form>
                    </div>
                    <div class="card-footer">
                        <div class="text-center">|LANG_HOSTED_BY|</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Core JS -->
    |LOAD_JQUERY_JS|
    |LOAD_BOOTSTRAP_JS|
    <script type="text/javascript">
    <!--
        var notloaded = true;
        var onloadCallback = function()
        {
            if (!notloaded) {
                grecaptcha.reset();
                console.log('Reset reCaptcha');
            } else {
                notloaded = grecaptcha.render('container',{
                      'sitekey' : '|SITEKEY|'
                });
                console.log('Render reCaptcha');
            }
        };
        $(document).ready(function(){
            var lang="|LANG|";
            $('#captcha').find('script').html('');
            $('#captcha').find('script').replaceWith($('<script>').attr('type', 'text/javascript').attr('async', '').attr('defer', '').attr('src', 'https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit&hl=' + lang));
        });
    //-->
    </script>
</body>
</html>
