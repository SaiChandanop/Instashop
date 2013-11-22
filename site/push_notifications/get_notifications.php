<?

include_once("../db.php");


function getNotificationArrayFromNotificationID($notificationID)
{
	$query = "select * from notifications where id = '$notificationID'";
	$result = mysql_query($query);

	$payloadArray = array();
	if ($row = mysql_fetch_assoc($result)) 
			return $row;

}

function getUsernameFromInstagramID($instagramID)
{
	$query = "select * from sellers_addresses where instagram_id = '$instagramID'";
	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) 
	{
		return $row["instagram_username"];
	}
}

function getProductNameFromProductID($productID)
{
	$query = "select * from products_description where products_id = '$productID'";

	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) 
	{
		return $row["products_description"];
	}
	
}

function getMessageStringFromNotification($notificationID)
{	
	$retVal = "nope";

	$query = "select * from notifications where id = '$notificationID'";
	$result = mysql_query($query);

	
	if ($row = mysql_fetch_assoc($result)) 
	{
		$creatorName = getUsernameFromInstagramID($row["creator_id"]);
		$productName = getProductNameFromProductID($row["product_id"]);

		if ($row["type"] == 0)
		{			
			$retVal = "$creatorName liked your product";//$productName";
		}
		else if ($row["type"] == 1)
		{			
			$retVal = "$creatorName shared your product twitter";// $productName";
		}
		else if ($row["type"] == 2)
		{			
			$retVal = "$creatorName shared your product to facebook";// $productName";
		}
		
	}

	return $retVal;
}


if (strcmp($_POST["request_type"], "all") == 0)
{
	$retVal = array();
	$query = "select * from notifications where recipient_id = '".$_POST["instagram_id"] ."' order by notification_date DESC";
	$result = mysql_query($query);

	while ($row = mysql_fetch_assoc($result)) 
	{

		$notification_object = array();
		$notification_object["message"] = getMessageStringFromNotification($row["id"]);
		$notification_object["data"] = getNotificationArrayFromNotificationID($row["id"]);
		
		array_push($retVal, $notification_object);
	}

	$json = json_encode($retVal);
	echo $json;
}

?>