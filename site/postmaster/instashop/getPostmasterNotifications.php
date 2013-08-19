<?


include_once("../../db.php");

function getNotifications($id)
{	
	$query = "select * from orders_postmaster where id = '$id'";
	$result = mysql_query($query);

	$retar = array(); 
	if ($row = mysql_fetch_assoc($result))
	{
		$retar["id"] = $row["id"];
		$retar["orders_id"] = $row["orders_id"];
		$retar["postmaster_shipment_id"] = $row["postmaster_shipment_id"];
		$retar["postmaster_tracking_number"] = $row["postmaster_tracking_number"];
		$retar["postmaster_label_url"] = $row["postmaster_label_url"];
	}


	return $retar;
}

$con = mysql_connect($db_host, $_db_user, $db_pass);
if (!$con) {
	echo "Could not connect to server\n";
	trigger_error(mysql_error(), E_USER_ERROR);
} 
	
$r2 = mysql_select_db($db_db);
if (!$r2) {
	echo "Cannot select database\n";
	trigger_error(mysql_error(), E_USER_ERROR); 
} 


$val = getNotifications($_POST["id"]);
$json = json_encode($val);
echo $json;

?>