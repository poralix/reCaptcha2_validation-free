<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Serverwide reCAPTCHA VALIDATION FOR WordPress Login page by Poralix $ v.0.7-Free //-->

        <title>reCaptcha Validation for WordPress Login Page</title>

        <!-- Core CSS -->
        |LOAD_BOOTSTRAP_CSS|
        |LOAD_CORE_CSS|

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries. -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
            <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
        <div class="container centered">
            <div class="row">
                <noscript>
                    <div class="col-sm-6 col-sm-offset-3">
                        <div class="alert alert-danger">
                            <div class="lang-en">
                                <p>
                                    JavaScript is turned off. In order to access your website, JavaScript has to be enabled.
                                </p>
                            </div>
                            <div class="lang-nl">
                                <p>
                                    JavaScript staat uitgeschakelt. Om toegang te krijgen tot je website moet JavaScript ingeschakelt zijn.
                                </p>
                            </div>
                            <div class="lang-ru">
                                <p>
                                    Поддержка JavaScript в вашем браузере отключена. Для того, чтобы получить доступ к сайту, поддержка JavaScript должна быть включена.
                                </p>
                            </div>
                            <div class="lang-tr">
                                <p>
                                    JavaScript devre dışı. Website'ye erişebilmek için Javascript'i aktifleştirmeniz gerekli.
                                </p>
                            </div>
                        </div>
                    </div>
                </noscript>
                <div class="col-sm-6 col-sm-offset-3">
                    <ol class="breadcrumb">
                        <li><span class="change-lang" data-lang="en">EN</span></li>
                        <li><span class="change-lang" data-lang="nl">NL</span></li>
                        <li><span class="change-lang" data-lang="ru">RU</span></li>
                        <li><span class="change-lang" data-lang="tr">TR</span></li>
                    </ol>
                    <div class="panel panel-default">
                        <form id="validate" action="" method="post">
                            <div class="panel-body">

                                <div class="lang-en" style="dispay: none;">
                                    <p>
                                        This page is an extra security measure for websites which use WordPress.
                                        Before you can login into WordPress, you have confirm that you are a
                                        human being. You can do this by confirming the reCAPTCHA below.
                                    </p>
                                    <div class="warning">|WARNING_EN|</div>
                                </div>
                                <!-- /.lang-en -->

                                <div class="lang-nl" style="display: none;">
                                    <p>
                                        Deze pagina is een extra beveiliging voor onze klanten die gebruik maken 
                                        van Wordpress. Voordat je kunt inloggen is het belangrijk om aan te tonen 
                                        dat je een mens bent. Dit doe je door onderstaande reCAPTCHA te bevestigen.
                                    </p>
                                    <div class="warning">|WARNING_NL|</div>
                                </div>
                                <!-- /.lang-nl -->

                                <div class="lang-ru" style="display: none;">
                                    <p>
                                        Эта страница является дополнительной мерой безопасности для веб-сайтов, которые 
                                        используют WordPress. Перед тем как вы сможете продолжить и войти в WordPress,
                                        вам необходимо подтвердить, что вы являетесь человеком. Вы можете сделать это, 
                                        пройдя тест reCaptcha ниже.
                                    </p>
                                    <div class="warning">|WARNING_RU|</div>
                                </div>
                                <!-- /.lang-ru -->
                                <div class="lang-tr" style="dispay: none;">
                                    <p>
                                        Bu sayfa WordPress kullanan siteler için ekstra güvenlik amacıyla otomatik 
                                        olarak oluşturulmuştur.
                                        WordPress kullanıcı girişi yapmadan önce insan olduğunuzu doğrulamamız gerekmektedir.
                                        Aşağıda yer alan reCaptcha doğrulamasını geçerek giriş paneline erişebilirsiniz.
                                    </p>
                                    <div class="warning">|WARNING_TR|</div>
                                </div>
                                <!-- /.lang-tr -->
                                <center id="captcha">
                                    <div id="container"></div>
                                    <script type="text/javascript"></script>
                                    <input type="hidden" name="ref" value="|REF|" />
                                    <input type="hidden" name="uri" value="|URI|" />
                                </center>
                                <br>
                                <button type="submit" class="btn btn-primary">Confirm</button>
                            </div>
                        </form>
                    </div>
                    <div class="footer">
                        <div class="lang-en" style="dispay: none;">
                            Hosted by |COMPANY_HTML|.
                        </div>
                        <div class="lang-nl" style="dispay: none;">
                            Deze pagina wordt gehost door |COMPANY_HTML|.
                        </div>
                        <div class="lang-ru" style="dispay: none;">
                            Размещается на хостинге |COMPANY_HTML|.
                        </div>
                        <div class="lang-tr" style="dispay: none;">
                            Barındırıcı |COMPANY_HTML|.
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
            var changeLanguage = function(lang) {
                // Hide everything.
                $('[class^=lang-]').hide();
                // Switch to the chosen language.
                $('.lang-' + lang).show();
                if (lang == 'nl') {
                    console.log("Changed language to NL");
                    $('button[type="submit"]').html('Bevestig');
                } else if (lang == 'ru') {
                    console.log("Changed language to RU");
                    $('button[type="submit"]').html('Продолжить');
                } else if (lang == 'tr') {
                    console.log("Changed language to TR");
                    $('button[type="submit"]').html('Devam Et');
                } else {
                    console.log("Changed language to EN");
                    $('button[type="submit"]').html('Confirm');
                }
                // Set reCAPTCHA language.
                $('#captcha').find('script').html('');
                $('#captcha').find('script').replaceWith($('<script>').attr('type', 'text/javascript').attr('async', '').attr('defer', '').attr('src', 'https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit&hl=' + lang));
            }
            var notloaded = true;
            var onloadCallback = function() {
                if (!notloaded) {
                    grecaptcha.reset();
                    console.log('Reset reCaptcha');
                } else {
                    notloaded = grecaptcha.render('container', {
                          'sitekey' : '|SITEKEY|'
                    });
                    console.log('Render reCaptcha');
                }
            };
            $('.change-lang').click(function(e) {
                e.preventDefault();
                var lang = $(this).attr('data-lang');
                changeLanguage(lang);
            });
            $(window).load(function() {
                var lang="|LANG|";
                changeLanguage(lang);
            });
        //-->
        </script>
    </body>
</html>
