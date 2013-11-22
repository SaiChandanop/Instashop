<?

echo "pushSoldMessageWithProductInfo!!";
$message = 'Hello';
$badge = 3;
$sound = 'default';
$development = true;
 
$payload = array();
$payload['aps'] = array('alert' => $message, 'badge' => intval($badge), 'sound' => $sound);
$payload = json_encode($payload);
 
$apns_url = NULL;
$apns_cert = NULL;
$apns_port = 2195;
 

$apns_url = 'gateway.sandbox.push.apple.com';
$apns_cert = './ck.pem';

 
$stream_context = stream_context_create();
stream_context_set_option($stream_context, 'ssl', 'local_cert', $apns_cert);
 
$apns = stream_socket_client('ssl://' . $apns_url . ':' . $apns_port, $error, $error_string, 2, STREAM_CLIENT_CONNECT, $stream_context);
 
//	You will need to put your device tokens into the $device_tokens array yourself
$device_tokens = array();
array_push($device_tokens, "260675532cab6914f203d23d55d386e5235d1777b01f221f41d89a1077bfd192");

print_r($device_tokens); 
foreach($device_tokens as $device_token)
{
	$apns_message = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $device_token)) . chr(0) . chr(strlen($payload)) . $payload;
	fwrite($apns, $apns_message);
}
 
@socket_close($apns);
@fclose($apns);
?>