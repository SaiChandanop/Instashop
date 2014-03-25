<?
	include_once("../db.php");
	include_once("./push.php");
	include_once("./get_notifications.php");


	echo "here";
	
	$instagram_push_ids = explode("___", $_POST["instagram_push_ids"]);

	for ($i = 0; $i < count($instagram_push_ids); $i++)
	{	

		if (strcmp($_POST["type"], "user_joined") == 0)
			$notification_type = 4;

		$query = "select instagram_username from sellers_addresses where instagram_id = '".$_POST["user_ID"]. "'";

		$result = mysql_query($query);

		$row = mysql_fetch_assoc($result);
		$user = $row["instagram_username"];
		
		$query = "insert into notifications values ('', '4', '".$_POST["product_id"]."', '".$_POST["user_ID"]. "', '".$instagram_push_ids[$i] ."', '0', '". date("Y-m-d H:i:s") ."')";
		$result = mysql_query($query);
		$notificationID =  mysql_insert_id();

		echo "the query: $query";

		pushWithMessage("$user joined Shopsy", getNotificationArrayFromNotificationID($notificationID), $instagram_push_ids[$i]);
	}

		

?>

