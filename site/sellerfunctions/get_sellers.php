<?
include_once("../db.php");

function getSellerProducts($sellerID)
{
	$query = "select * from sellers";
	if (strlen($sellerID) > 0)
		$query = "select * from sellers where instagram_id = '$sellerID'";


	$result = mysql_query($query);


	$responseArray = array();

	while ($row = mysql_fetch_assoc($result)) 
	{
		$responseObject = array();

		$responseObject["instagram_id"] = $row["instagram_id"];
		

		$query = "select * from sellers_addresses where instagram_id = '".$responseObject["instagram_id"]."'";
		$address_result = mysql_query($query);

		while ($addressRow = mysql_fetch_assoc($address_result)) 
		{
			$responseObject["seller_name"] = $addressRow["seller_name"];
			$responseObject["seller_address"] = $addressRow["seller_address"];
			$responseObject["seller_city"] = $addressRow["seller_city"];
			$responseObject["seller_state"] = $addressRow["seller_state"];
			$responseObject["seller_zip"] = $addressRow["seller_zip"];
			$responseObject["seller_phone"] = $addressRow["seller_phone"];
				
		}
		array_push($responseArray, $responseObject);
	}

	mysql_close();
	return $responseArray;
}


$sellerID = $_GET["seller_instagram_id"];

$sellersArray = getSellerProducts($sellerID);
$json = json_encode($sellersArray);
echo $json;


?>