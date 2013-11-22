<?

include_once("./push_notification.php");
include_once("./db.php"); // Just for my notes, this inclusino make the access to the database much easier.  

function getFlagReceivedNotification ($complaint_id, $products_id, $user_id) {
	
	$returnValue = "Thank you for your complaint ";
	
	// Do I need to check the connection first or this the responsibility in API Handler file?
	$data = mysql_query("SELECT * FROM flagged_content WHERE reporter_user_id = $user_id AND reported_product_id = $products_id");
	$list = mysql_fetch_assoc($data);
	
	if ($list) { // Allows access into the list if needed
		$retVal = $row["$user_id"];
		echo("User already flagged this item");
	}
	else {
		$query = "insert into flagged_content values ('', '". date("Y-m-d H:i:s") . "', '". $user_id ."', '". $products_id ."', '".
		$complaint_id ."');";
		echo("Thanks for the info - We'll look into it");
		mysql_query($query);
	}
	
	return $returnValue;
}

$complaint_id = $_POST["complaint_type"];
$products_id = $_POST["Product_ID"];
$user_id = $_POST["User_ID"];

$complaint_received_id = getFlagReceivedNotification ($complaint_id, $products_id, $user_id);

?>