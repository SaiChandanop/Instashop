<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="description" content="Instashop is the marketplace for products discovered on Instagram" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Instashop</title>
	<link rel="stylesheet" media="all" href="css/all.css" type="text/css"/>
	<link rel="stylesheet" media="all" href="css/responsive.css" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="fonts/fontawesome.css" />
	<link rel="image_src" href="http://www.instashop.com/images/icon.jpg" / >
	
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
				<nav>
					<ul id="nav">
						<li><a href="http://instashopblog.tumblr.com">Blog</a></li>
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
			<div class="slideshow">
				<div class="smask">
					<div class="slideset">

						<div class="slide sellform">
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
								<form action="form_signup.php" class="connect-form" method="POST">
									<fieldset>
										<?
											$showInstagramButton = 1;
											if (strlen($_GET["code"]) > 0)
											{


												$ch = curl_init();


												$client_id = "acb5a39edfff4e4999747f679d2157b2";
												$client_secret = "604d5c86809a45979d365ac6b647d8ef";
												$client_redirect = "http://www.instashop.com/seller.php";
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
//												print_r($response);
												if (strlen($response["user"]["username"]) > 0)
												{

													echo "<div class='instagram_username'>Welcome, ";
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
											
										<h3 class="bodycopy mobilesubhead">Please tell us a bit more about your store or brand:</h3>

										<div class="validate-row"><input type="text" value="Name of Store/Brand" class="required-text storename" name="name" /></div>
										<div class="validate-row"><input type="text" value="Email" name="email" class="required-email email" /></div>
										<div class="validate-row">
											<select class="required-select" name="category" value="Select a category">
												<option selected value="">Select a Category</option>
												<option value="Art">Art</option>
												<option value="Health & Beauty">Health & Beauty</option>
												<option value="Home">Home</option>
												<option value="Fashion">Fashion</option>
												<option value="Sports & Outdoors">Sports & Outdoors</option>
												<option value="Technology">Technology</option>																																				
											</select>
										</div>

										<div class="validate-row">
											<input type="text" value="Website (Optional)" name="web" class="optional-text website" />
											<input type="text" value="Phone (Optional)" name="phone" class="optional-number phone" />
										</div>

										<button type="submit" value="submit" >SIGN UP</button>
										<div class="spamfoot">We will never spam or sell you out.</div>
									</fieldset>
								</form>
							</div>
							<div class="sign-holder grow-holder seller">
								<h2 class="title">Awesome!</h2>
								<h3 class="bodycopy success">We'll be in touch soon.</h3>
								<h3 class="bodycopy success gap">Help spread the word about Instashop!</h3>
								<ul class="socials-btn">
											<li><a href="#" class="facebook" onclick="window.open('https://www.facebook.com/sharer/sharer.php?u='+encodeURIComponent(location.href), 'facebook-share-dialog', 'width=626,height=436'); return false;">													<i class="icon-facebook"></i>Share</a></li>
										<li><a class="twitter" href="http://twitter.com/share?url=http%3A%2F%2Finstashop.com&text=I%20just%20signed%20up%20for%20%40Instashop%2C%20the%20marketplace%20for%20products%20discovered%20on%20Instagram%2E" target="_blank"><i class="icon-twitter"></i>Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script></li>

										</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="mobilecontent smartphone-hide">
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
									$client_redirect = "http://www.instashop.com/seller.php";
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
//												print_r($response);
									if (strlen($response["user"]["username"]) > 0)
									{

										echo "<div class='instagram_username'>Welcome, ";
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
								
							<h3 class="bodycopy">Please tell us a bit more about your store or brand:</h3>
	
							<div class="validate-row"><input type="text" value="Name of Store/Brand" class="required-text connectinput" name="name" /></div>
							<div class="validate-row"><input type="text" value="Website" name="web" class="required-text connectinput" /></div>
							<div class="validate-row">
								<select class="required-select" name="category" value="Select a category">
									<option selected value="">Select a Category</option>
									<option value="Art">Art</option>
									<option value="Health & Beauty">Health & Beauty</option>
									<option value="Home">Home</option>
									<option value="Fashion">Fashion</option>
									<option value="Sports & Outdoors">Sports & Outdoors</option>
									<option value="Technology">Technology</option>																																				
								</select>
							</div>
	
							<div class="validate-row"><input type="text" value="Email" name="email" class="required-email connectinput" /></div>
							<div class="validate-row"><input type="text" value="Phone (Optional)" name="phone" class="optional-number connectinput" /></div>
							<button type="submit" value="submit" >SIGN UP</button>
							<div class="spamfoot">We will never spam or sell you out.</div>
						</fieldset>
					</form>
				
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