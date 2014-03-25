<?
	include_once("../db.php");


function getSellerDetails($instagramID)
{
	$query = "select * from sellers_addresses where instagram_id = '$instagramID'";

	$responseArray = array();
	$result = mysql_query($query);
	if ($row = mysql_fetch_assoc($result)) 
	{
		$responseArray = $row;
	}

	return $responseArray;
}


function updateSellerDescription($instagramID, $theDescription)
{
	$query = "update sellers_addresses set seller_description = '$theDescription' where instagram_id = '$instagramID'";
	$result = mysql_query($query);

	return getSellerDetails($instagramID);
}

$item = array();
$action = $_POST["action"];

if ($action == "getSellerDetails")
{	
	$item = getSellerDetails($_POST["instagramID"]);
	
}
else if ($action == "updateSellerDescription")
{
	$item = updateSellerDescription($_POST["instagramID"], $_POST["description"]);
}

$json = json_encode($item);
echo $json;


	
?>