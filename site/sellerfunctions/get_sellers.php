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
	$returnArray = array();

	$idsArray = array();

	if (strlen($category) == 0 && count($freeformTextArray) > 0)
	{
		for ($i = 0; $i < count($freeformTextArray); $i++)
		{
			$query = "select * from sellers_addresses WHERE instagram_username like '%". $freeformTextArray[$i] ."%';";
			$result = mysql_query($query);

			while ($row = mysql_fetch_assoc($result)) 
				if (strlen($row["instagram_id"]) > 0)
					array_push($idsArray, $row["instagram_id"]);	
		}

	}
	else if (strlen($category) > 0)
	{
		$query = "select * from sellers_addresses where seller_category = '$category';";
		$result = mysql_query($query);

		while ($row = mysql_fetch_assoc($result)) 
			if (strlen($row["instagram_id"]) > 0)
			array_push($idsArray, $row["instagram_id"]);	



		if (count($freeformTextArray) > 0)
		{
			$freeFormIDSArray = array();								

			for ($i = 0; $i < count($freeformTextArray); $i++)
				if (strlen($freeformTextArray[$i]) > 0)
				{			
					$searchTerm = $freeformTextArray[$i];

					$query = "select * from sellers_addresses WHERE instagram_username like '%". $searchTerm ."%';";
					$result = mysql_query($query);


					while ($row = mysql_fetch_assoc($result)) 
					if (strlen($row["instagram_id"]) > 0)
						array_push($freeFormIDSArray, $row["instagram_id"]);	
				}


			$matching_overlap_array = array();

			for ($i = 0; $i < count($freeFormIDSArray); $i++)
				if (in_array($freeFormIDSArray[$i], $idsArray))
					array_push($matching_overlap_array, $freeFormIDSArray[$i]);

			if (count($matching_overlap_array) > 0)
				{
					$prioritiesArray = array();
					for ($i = 0; $i < count($matching_overlap_array); $i++)
						array_push($prioritiesArray, $matching_overlap_array[$i]);

					for ($i = 0; $i < count($idsArray); $i++)
					if (!in_array($idsArray[$i], $matching_overlap_array))
						array_push($prioritiesArray, $idsArray[$i]);

					$idsArray = $prioritiesArray;
				}
			
				

		}
				
	}

	for ($i = 0; $i < count($idsArray); $i++)
		{
			$query = "select * from sellers_addresses where instagram_id = '$idsArray[$i]';";
			$result = mysql_query($query);

			while ($row = mysql_fetch_assoc($result)) 
				array_push($returnArray, $row);	
		}

	return $returnArray;

}

function pruneSellersByProducts($sellersArray)
{
	$returnArray = array();
	for ($i = 0; $i < count($sellersArray); $i++)
	{	
		$query = "select * from sellers_products where instagram_id = '".$sellersArray[$i]["instagram_id"] ."'";

		$result = mysql_query($query);
		if ($row = mysql_fetch_assoc($result)) 
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
else if (strlen($_POST["category"]) > 0 || strlen($_POST["freetext_string"]) > 0)
{
	$sellersArray = getSellersByCategoryAndFreeformText($_POST["category"], explode("___", $_POST["freetext_string"]));
	$sellersArray = pruneSellersByProducts($sellersArray);
	
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