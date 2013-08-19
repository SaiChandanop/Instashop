<?

$client_id = "acb5a39edfff4e4999747f679d2157b2";
$client_secret = "604d5c86809a45979d365ac6b647d8ef";

$client_redirect = "http://www.instashop.com/seller.php";
$location = "https://api.instagram.com/oauth/authorize/?client_id=$client_id&client_secret=$client_secret&redirect_uri=$client_redirect&response_type=code";
header("Location: $location");
?>