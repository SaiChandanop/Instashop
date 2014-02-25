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



function getSellersByCategoryAndFreeformText($category, $freeformTextArray)
{
	$productIDS = array();
	if (strlen($category) > 0)
	{
		$query = "select distinct product_id from products_categories_and_sizes where attribute_1 = '$category'";
		$result = mysql_query($query);
		while ($row = mysql_fetch_assoc($result)) 
			array_push($productIDS, $row["product_id"]);

		
	}

	$sellerIDS = array();
	for ($i = 0; $i < count($productIDS); $i++)
	{
		$productID = $productIDS[$i];

		$query = "select * from sellers_products where product_id = '$productID'";
		$result = mysql_query($query);
		while ($row = mysql_fetch_assoc($result)) 
			array_push($sellerIDS, $row["instagram_id"]);
	}


	if (strlen($category) > 0)
	{
		$query = "select instagram_id from sellers_addresses where seller_category like '%$category%'";

		$result = mysql_query($query);
		while ($row = mysql_fetch_assoc($result)) 
		{
			array_push($sellerIDS, $row["instagram_id"]);
		}

		
	}

	
	$idsArray = array_unique($sellerIDS);
	$keysArray = array_keys($idsArray);
	$returnArray = array();
	for ($i = 0; $i < count($keysArray); $i++)
	{
		$key = $keysArray[$i];
		$item = array();
		$item["instagram_id"] = $idsArray[$key];
		array_push($returnArray, $item);
	}


	return $returnArray;

}

function pruneSellersByProducts($sellersArray)
{
	$returnArray = array();
	for ($i = 0; $i < count($sellersArray); $i++)
	{	
		$query = "select * from sellers_products where instagram_id = '".$sellersArray[$i]["instagram_id"] ."'";
		
//		echo "\nquery: ". $query;
		
		$result = mysql_query($query);
		$insert = 0;
		
		while ($row = mysql_fetch_assoc($result))
		{
		//	if ($row["product_id"] > 246)
				$insert = 1;
			
		} 
		
		if ($insert == 1)
			array_push($returnArray, $sellersArray[$i]);			

	}

	return $returnArray;

}

$sellersArray = array();

if (strlen($_GET["seller_instagram_id"]) > 0)
{
	$sellerID = $_GET["seller_instagram_id"];
	$sellersArray = getSellerProducts($sellerID);
}
else if (strlen($_POST["category"]) > 0 && strlen($_POST["freetext_string"]) > 0)
{
	$sellersArray = getSellersByCategoryAndFreeformText($_POST["category"], explode("___", $_POST["freetext_string"]));
	$sellersArray = pruneSellersByProducts($sellersArray);
	
}
else if (strlen($_POST["category"]) > 0)
{
	$sellersArray = getSellersByCategoryAndFreeformText($_POST["category"], explode("___", $_POST["freetext_string"]));
	$sellersArray = pruneSellersByProducts($sellersArray);
}

else if (strlen($_POST["freetext_string"]) > 0)
{
	$freeText = $_POST["freetext_string"];	
	$freeTextArray = explode("___", $freeText);

	for ($i = 0; $i < count($freeTextArray);  $i++)
	{		
		$obj = $freeTextArray[$i];
		if (strlen($obj) > 0)
		{
			$query = "select * from sellers_addresses where instagram_username like '%$obj%'";
	//		echo "query: " .$query;
			$address_result = mysql_query($query);

			while ($addressRow = mysql_fetch_assoc($address_result)) 
			{	
				if (strlen($addressRow["instagram_id"]) > 0)
					array_push($sellersArray, $addressRow);	
			}			
		}				
	}
}
else
{	
	$query = "select * from sellers_addresses;";
	$address_result = mysql_query($query);

	while ($addressRow = mysql_fetch_assoc($address_result)) 
	{	if (strlen($addressRow["instagram_id"]) > 0)
			array_push($sellersArray, $addressRow);	
	}
}

$json = json_encode($sellersArray);
echo $json;


?>