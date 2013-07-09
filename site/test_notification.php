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
$apns_cert = './cert-dev.pem';

 
$stream_context = stream_context_create();
stream_context_set_option($stream_context, 'ssl', 'local_cert', $apns_cert);
 
$apns = stream_socket_client('ssl://' . $apns_url . ':' . $apns_port, $error, $error_string, 2, STREAM_CLIENT_CONNECT, $stream_context);
 
//	You will need to put your device tokens into the $device_tokens array yourself
$device_tokens = array();
array_push($device_tokens, "89e84f0161ee45f3f3d993034a38c0470691b143e08559ea14900f15981ecf5c");

print_r($device_tokens); 
foreach($device_tokens as $device_token)
{
	$apns_message = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $device_token)) . chr(0) . chr(strlen($payload)) . $payload;
	fwrite($apns, $apns_message);
}
 
@socket_close($apns);
@fclose($apns);
?>