<?
include_once("./db.php");


function getSellerPushIDFromZenID($seller_zen_id)
{
	

	$retVal = "";

	$query = "select * from sellers where id = '$seller_zen_id'";

	echo "get seller query: ". $query ."\n";
	$result = mysql_query($query);
		
	if ($row = mysql_fetch_assoc($result)) {
		print_r($row);
		$retVal = $row["push_id"];
	}


	return $retVal;



}



function pushSoldMessageWithProductInfo($products_id, $products_name, $products_price, $purchaser_id, $seller_zen_id, $purchaser_username, $postmaster_order_id)
{	
	$deviceToken = trim(getSellerPushIDFromZenID($seller_zen_id));
	
	$deviceToken = "260675532cab6914f203d23d55d386e5235d1777b01f221f41d89a1077bfd192";

	echo "\npush message to device token: " . $deviceToken ."\n";
	// Put your private key's passphrase here:
	$passphrase = 'Instashop22';
	
	// Put your alert message here:
	$message = 'My first push notification!';
	$message = $purchaser_username .' bought '. $products_name .' for $' . $products_price;
	////////////////////////////////////////////////////////////////////////////////
	
	$ctx = stream_context_create();
	stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
	stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
	
	// Open a connection to the APNS server
	$fp = stream_socket_client(
		'ssl://gateway.sandbox.push.apple.com:2195', $err,
		$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
	
	if (!$fp)
		exit("Failed to connect: $err $errstr" . PHP_EOL);
	
	echo 'Connected to APNS' . PHP_EOL;
	
	// Create the payload body
	$body['aps'] = array(
		'alert' => $message,
		'sound' => 'default'
		);
	
	// Encode the payload as JSON
	$payload = json_encode($body);
	
	// Build the binary notification
	$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;
	
	// Send it to the server
	$result = fwrite($fp, $msg, strlen($msg));
	
	if (!$result)
		echo 'Message not delivered' . PHP_EOL;
	else
		echo 'Message successfully delivered' . PHP_EOL;
	
	// Close the connection to the server
	fclose($fp);

}





function pushSoldMessage2WithProductInfo($products_id, $products_name, $products_price, $purchaser_id, $seller_zen_id, $purchaser_username, $postmaster_order_id)
{

	$seller_device_token = trim(getSellerPushIDFromZenID($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $seller_zen_id));

	$seller_device_token ="260675532cab6914f203d23d55d386e5235d1777b01f221f41d89a1077bfd192";

	//echo "----------------------------- post master url: ".$postmaster_label_url;
	echo "seller device token!!: ".$seller_device_token;
	$message = $purchaser_username .' bought '. $products_name .' for $' . $products_price;
	$badge = 3;
	$sound = 'default';
	$development = true;
 
	$payload = array();
	$payload['aps'] = array('alert' => $message, 'order_id' => $postmaster_order_id, 'badge' => intval($badge), 'sound' => $sound);
	$payload = json_encode($payload);
 
	$apns_url = NULL;
	$apns_cert = NULL;
	$apns_port = 2195;
 
	if($development)
	{
		$apns_url = 'gateway.sandbox.push.apple.com';
//		$apns_cert = './cert-dev.pem';
		$apns_cert = './ck.pem';
	}
	else
	{
		$apns_url = 'gateway.push.apple.com';
		$apns_cert = '/path/to/cert/cert-prod.pem';
	}
 
	$stream_context = stream_context_create();
	stream_context_set_option($stream_context, 'ssl', 'local_cert', $apns_cert);
 
	$apns = stream_socket_client('ssl://' . $apns_url . ':' . $apns_port, $error, $error_string, 2, STREAM_CLIENT_CONNECT, $stream_context);
 
	//	You will need to put your device tokens into the $device_tokens array yourself
	$device_tokens = array();
	array_push($device_tokens, $seller_device_token);


	foreach($device_tokens as $device_token)
	{
		$apns_message = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $device_token)) . chr(0) . chr(strlen($payload)) . $payload;
		fwrite($apns, $apns_message);
	}
	

 
	@socket_close($apns);
	@fclose($apns);
}
?>