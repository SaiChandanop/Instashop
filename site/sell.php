<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="description" content="Instashop is the marketplace for products discovered on Instagram" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Instashop</title>
	<link rel="stylesheet" media="all" href="css/all.css" type="text/css"/>
	<link rel="stylesheet" media="all" href="css/responsive.css" type="text/css"/>
	<link rel="image_src" href="http://www.instashop.com/images/icon.jpg" / >
	<link rel="icon" type="image/png" href="images/favicon.ico" />
	
	<meta property="og:image" content="http://www.instashop.com/images/icon.jpg"/>
	<meta property="og:title" content="Instashop"/>
	<meta property="og:url" content="http://www.instashop.com/index.php"/>
	<meta property="og:site_name" content="Instashop Home"/>

	<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="js/jquery.main.js"></script>
	<!--[if lte IE 8]>
		<script type="text/javascript" src="js/ie.js"></script>
		<link rel="stylesheet" media="all" href="css/ie.css" type="text/css"/>
	<![endif]-->
	<script src="http://connect.facebook.net/en_US/all.js"></script>
</head>
<body>

	<div id="wrapper">
		<div class="w1">
			<header id="header">
				<strong class="logo"><a href="http://www.instashop.com/index.php">Instashop</a></strong>
				<h3 class="headertitle bodycopy">Want to be among the first to Sell on Instashop?</h3>
				<nav>
					<ul id="nav">
						<li><a href="http://instashopapp.tumblr.com">Blog</a></li>
						<li><a href="mailto:hello@instashop.com">Contact</a></li>
					</ul>
				</nav>
				<ul class="socials smartphone-hide">
					<li><a class="facebook" href="https://www.facebook.com/Instashopapp" target=_blank>facebook</a></li>
					<li><a class="twitter" href="https://twitter.com/Instashop" target=_blank>twitter</a></li>
					<li><a class="pinterest" href="http://pinterest.com/instashop/" target=_blank>pinterest</a></li>
					<li><a class="instagram" href="http://instagram.com/instashop" target=_blank>instagram</a></li>
				</ul>
			</header>
			<div class="slideshow smartphone-hide">
				<div class="smask">
					<div class="slideset">
						<div class="slide sellform-alone">
							<div class="carousel">
								<div class="mask">
									<div class="slideset-inner">
										<div class="slide-inner">
											<div class="slide-holder align">
												<img src="images/phone-2.jpg" alt="image description">
											</div>
										</div>
										<div class="slide-inner">
											<div class="slide-holder align">
												<img src="images/phone-3.jpg" alt="image description">
											</div>
										</div>
										<div class="slide-inner">
											<div class="slide-holder align">
												<img src="images/phone-4.jpg" alt="image description">
											</div>
										</div>
										<div class="slide-inner">
											<div class="slide-holder align">
												<img src="images/phone-5.jpg" alt="image description">
											</div>
										</div>
									</div>
								</div>
								<div class="pagination-inner">
								</div>
							</div>
							<div class="text-area">
								<h2 class="title">Want to be among the first to Sell on Instashop?</h2>
								<h2 class="subtitle">Step 1:</h2>
								
								<form action="form_signup.php" class="connect-form" method="POST">
									<fieldset>
										<?
											$showInstagramButton = 1;
											if (strlen($_GET["code"]) > 0)
											{


												$ch = curl_init();


												$client_id = "acb5a39edfff4e4999747f679d2157b2";
												$client_secret = "604d5c86809a45979d365ac6b647d8ef";
												$client_redirect = "http://www.instashop.com/index.php";
												$access_code = $_GET["code"];

												$postFields = "client_id=$client_id&client_secret=$client_secret&grant_type=authorization_code&redirect_uri=$client_redirect&code=$access_code";
												//echo "postFields: $postFields \n";


												$headerArray = array('Content-type: application/json');

												curl_setopt($ch, CURLOPT_URL,"https://api.instagram.com/oauth/access_token");
												curl_setopt($ch, CURLOPT_POST, 1);
												curl_setopt($ch, CURLOPT_POSTFIELDS, "client_id=$client_id&client_secret=$client_secret&grant_type=authorization_code&redirect_uri=$client_redirect&code=$access_code");
												curl_setopt($ch, CURLOPT_HTTPHEADER, $headerArray);//
												curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

												$result = curl_exec ($ch);
												$response = json_decode($result, true);
//												echo "response username!: " . $response["user"]["username"];
												print_r($response);
												if (strlen($response["user"]["username"]) > 0)
												{
													echo "<div class='instagram_username'>";
													echo  $response["user"]["username"];
//													echo ", id: " . $response["user"]["id"];
													echo "</div>";
													$showInstagramButton = 0;
													echo "<input type='hidden' name ='instagram_user_id' id='instagram_user_id' value='".$response["user"]["id"] ."'>";
													echo "<input type='hidden' name ='instagram_username' id='instagram_username' value='".$response["user"]["username"] ."'>";

												}
												
											}

											if ($showInstagramButton)
											{
											?>
												<a class="btn" href="instagram_signup.php">Connect with Instagram </a>
											<?
											}
											?>
											
									</fieldset>
								</form>
								
								<h2 class="subtitle">Step 2:</h2>
								<h3 class="bodycopy">Tell us a bit more about your store or brand.</h3>
								
								<h2 class="subtitle">Step 3:</h2>
								<h3 class="bodycopy">Someone from our team will contact you to get your shop set up before the app launches!</h3>
							</div>
							
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="mobilecontent">
				<h2 class="subtitle bodycopy">Step 1:</h2>
				<div class="form-holder">
					<form action="form_signup.php" class="connect-form" method="POST">
						<fieldset>
							<?
								$showInstagramButton = 1;
								if (strlen($_GET["code"]) > 0)
								{


									$ch = curl_init();


									$client_id = "acb5a39edfff4e4999747f679d2157b2";
									$client_secret = "604d5c86809a45979d365ac6b647d8ef";
									$client_redirect = "http://www.instashop.com/index.php";
									$access_code = $_GET["code"];

									$postFields = "client_id=$client_id&client_secret=$client_secret&grant_type=authorization_code&redirect_uri=$client_redirect&code=$access_code";
									//echo "postFields: $postFields \n";


									$headerArray = array('Content-type: application/json');

									curl_setopt($ch, CURLOPT_URL,"https://api.instagram.com/oauth/access_token");
									curl_setopt($ch, CURLOPT_POST, 1);
									curl_setopt($ch, CURLOPT_POSTFIELDS, "client_id=$client_id&client_secret=$client_secret&grant_type=authorization_code&redirect_uri=$client_redirect&code=$access_code");
									curl_setopt($ch, CURLOPT_HTTPHEADER, $headerArray);//
									curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

									$result = curl_exec ($ch);
									$response = json_decode($result, true);
//												echo "response username!: " . $response["user"]["username"];
									print_r($response);
									if (strlen($response["user"]["username"]) > 0)
									{
										echo "<div class='instagram_username'>";
										echo  $response["user"]["username"];
//													echo ", id: " . $response["user"]["id"];
										echo "</div>";
										$showInstagramButton = 0;
										echo "<input type='hidden' name ='instagram_user_id' id='instagram_user_id' value='".$response["user"]["id"] ."'>";
										echo "<input type='hidden' name ='instagram_username' id='instagram_username' value='".$response["user"]["username"] ."'>";

									}
									
								}

								if ($showInstagramButton)
								{
								?>
									<a class="btn" href="instagram_signup.php">Connect with Instagram </a>
								<?
								}
								?>
								
						</fieldset>
					</form>
				
				<h2 class="subtitle bodycopy">Step 2:</h2>
				<h3 class="bodycopy steps">Tell us a bit more about your store or brand.</h3>
				
				<h2 class="subtitle bodycopy">Step 3:</h2>
				<h3 class="bodycopy steps">Someone from our team will contact you to get your shop set up before the app launches!</h3>

				</div>
				<div class="social-btns-mobile">
					<ul class="socials">
						<li><a class="facebook" href="https://www.facebook.com/Instashopapp" target=_blank>facebook</a></li>
						<li><a class="twitter" href="https://twitter.com/Instashop" target=_blank>twitter</a></li>
						<li><a class="pinterest" href="http://pinterest.com/instashop/" target=_blank>pinterest</a></li>
						<li><a class="instagram" href="http://instagram.com/instashop" target=_blank>instagram</a></li>
					</ul>			
				</div>
			</div>
			
			
			<footer id="footer">
				<div class="phone-holder">
					<img src="images/img-store.png" alt="image description">
				</div>
				<span>Copyright &copy; 2013 Instashop, Inc. All rights reserved.</span>
			</footer>
		</div>
	</div>
	
	
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-38832300-1']);
  _gaq.push(['_setDomainName', 'instashop.com']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
	
	
</body>
</html>