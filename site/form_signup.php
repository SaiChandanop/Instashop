<?


include_once("db.php");


$dataArray = $_POST;


$query = "insert into sellers_addresses values ('".$dataArray["instagram_user_id"]."','".$dataArray["instagram_username"]."', '".$dataArray["name"]."', '".$dataArray["address"]."','".$dataArray["city"]."','".$dataArray["state"]."','".$dataArray["zip"]."','".$dataArray["phone"]."','".$dataArray["email"]."','". $dataArray["web"]."','".$dataArray["category"]."', '')";

$result = mysql_query($query);



require_once 'inc/MCAPI.class.php';
require_once 'inc/config.inc.php'; //contains apikey

//$listId = "7931f76d71";
$listId =  "20fb0addab";
$apikey = "4db2d424bc3fd546c8ab671d9c105f00-us6";
$api = new MCAPI($apikey);

$merge_vars = array();


$retval = $api->listSubscribe( $listId, $dataArray["email"], $merge_vars );

if ($api->errorCode){
//	echo "Unable to load listSubscribe()!\n";
//	echo "\tCode=".$api->errorCode."\n";
//	echo "\tMsg=".$api->errorMessage."\n";
} else {
//    echo "Subscribed - look for the confirmation email!\n";
}





?>