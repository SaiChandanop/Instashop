<?


function getSellerPushIDFromZenID($host, $user, $pass, $db, $seller_zen_id)
{
	$con = mysql_connect($host, $user, $pass);
	if (!$con) {
	    echo "Could not connect to server\n";
	    trigger_error(mysql_error(), E_USER_ERROR);
	} 
	
	$r2 = mysql_select_db($db);
	if (!$r2) {
	    echo "Cannot select database\n";
	    trigger_error(mysql_error(), E_USER_ERROR); 
	} 
	

	$retVal = "";

	$query = "select * from sellers where id = '$seller_zen_id'";

	$result = mysql_query($query);
		
	if ($row = mysql_fetch_assoc($result)) {
		$retVal = $row["push_id"];
	}


	return $retVal;



}


function pushSoldMessageWithProductInfo($products_id, $products_name, $products_price, $purchaser_id, $seller_zen_id, $purchaser_username, $postmaster_order_id)
{

	$sellers_host = "mysql51-033.wc1.ord1.stabletransit.com"; 
	$sellers_user = "690403_instashop"; 
	$sellers_pass = "2Fpz7qm4"; 
	$sellers_db   = "690403_instashop_sellers";

	$seller_device_token = getSellerPushIDFromZenID($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $seller_zen_id);

	//echo "----------------------------- post master url: ".$postmaster_label_url;
	echo "seller device token: ".$seller_device_token;
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
		$apns_cert = './cert-dev.pem';
//		$apns_cert = './ck.pem';
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