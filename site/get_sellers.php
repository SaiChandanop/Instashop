<?

$sellers_host = "mysql51-033.wc1.ord1.stabletransit.com"; 
$sellers_user = "690403_instashop"; 
$sellers_pass = "2Fpz7qm4"; 
$sellers_db   = "690403_instashop_sellers";


function getSellerProducts($host, $user, $pass, $db, $sellerID)
{

	$con = mysql_connect($host, $user, $pass);
	if (!$con) {
	    echo "Could not connect to server\n";
	    trigger_error(mysql_error(), E_USER_ERROR);
	} 
	
	$r2 = mysql_select_db($db);
	if (!$r2) {
	    echo "Cannot select database\n";
	    trigger_error(mysql_error(), E_USER_ERROR); 
	} 

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

$sellersArray = getSellerProducts($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $sellerID);
$json = json_encode($sellersArray);
echo $json;


?>