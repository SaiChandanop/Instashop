<?php

include_once("../db.php");
function getDeviceTokenFromInstagramID($instagramID)
{
	$query = "select * from sellers where instagram_id = '$instagramID'";
	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) {	
		$deviceToken = $row["push_id"];
		$deviceToken = trim($deviceToken);
	}
	
	return $deviceToken;
}
function pushWithMessage($message, $payloadArray, $instagramID)
{
	print "\n\ninstagram id: $instagramID \n\n";

	$deviceToken = getDeviceTokenFromInstagramID($instagramID);

	$ctx = stream_context_create();
	stream_context_set_option($ctx, 'ssl', 'local_cert', './apns-dev.pem');


	// Open a connection to the APNS server
	$fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

	if (!$fp)
		exit("Failed to connect: $err $errstr" . PHP_EOL);

		echo 'Connected to APNS' . PHP_EOL;

		// Create the payload body
		$body['aps'] = array(
			'alert' => $message,
			'sound' => 'default'
		);

		$serverId = "the serverId";
		$name = "the name";
		$body['payload'] = $payloadArray;
		
		$payload = json_encode($body);

		// Build the binary notification
		$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;


		$result = fwrite($fp, $msg, strlen($msg));

		if (!$result)
			echo 'Message not delivered' . PHP_EOL;
		else
			echo 'Message successfully delivered' . PHP_EOL;


		fclose($fp);
}

//pushWithMessage("hi");

?>

