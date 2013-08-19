<?

require_once 'inc/MCAPI.class.php';
require_once 'inc/config.inc.php'; //contains apikey

$listId = "7931f76d71";
$apikey = "4db2d424bc3fd546c8ab671d9c105f00-us6";
$api = new MCAPI($apikey);

$merge_vars = array();

// By default this sends a confirmation email - you will not see new members
// until the link contained in it is clicked!
$retval = $api->listSubscribe( $listId, $_POST["email"], $merge_vars );

if ($api->errorCode){
	echo "Unable to load listSubscribe()!\n";
	echo "\tCode=".$api->errorCode."\n";
	echo "\tMsg=".$api->errorMessage."\n";
} else {
    echo "Subscribed - look for the confirmation email!\n";
}




?>

