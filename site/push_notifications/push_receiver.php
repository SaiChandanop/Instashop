<?
	include_once("../db.php");
	include_once("./push.php");
	include_once("./get_notifications.php");


	echo "here";

	$recipient_id = "12345";

	$notification_type = -1;
	if (strcmp($_POST["type"], "user_liked_product") == 0)
		$notification_type = 0;
	else if (strcmp($_POST["type"], "social_twitter") == 0)
		$notification_type = 1;
	else if (strcmp($_POST["type"], "social_facebook") == 0)
		$notification_type = 2;

	$find_instagram_query = "select * from sellers_products where product_id = '".	$_POST["product_id"] ."'";
	$result = mysql_query($find_instagram_query);
	
	if ($row = mysql_fetch_assoc($result)) 
		$recipient_id = $row["instagram_id"];
	
	$query = "insert into notifications values ('', '$notification_type', '".$_POST["product_id"]."', '".$_POST["instagram_id"] ."', '".$recipient_id."', '0', '". date("Y-m-d H:i:s") ."')";
	$result = mysql_query($query);
	$notificationID =  mysql_insert_id();

	echo "the query: $query";

	
	


	pushWithMessage(getMessageStringFromNotification($notificationID), getNotificationArrayFromNotificationID($notificationID), $recipient_id);

?>

