<?

define("SEARCH_TYPE_PRDOCUT", 0);
define("SEARCH_TYPE_SELLER", 1);

include_once("../db.php");
include_once("../get_products.php");


function searchByProductCategories($rowArray, $categoriesArray)
{
	$query = "select * from products_categories_and_sizes where ";

	for ($i = 0; $i < count($categoriesArray); $i++)
	{	
		if ($i > 0)
			$query .= " and ";
		
		$attributeKey = "attribute_" . ($i + 1);
		$query .= "$attributeKey = '".$categoriesArray[$i] ."'";				 

	}
	$result = mysql_query($query);
	while ($row = mysql_fetch_assoc($result)) 
	{						
		array_push($rowArray, $row);		
	}

	return $rowArray;
}

function searchByProductCategoriesNew($categoriesArray)
{
	$idsArray = array();
	$query = "select * from products_categories_and_sizes where ";

	for ($i = 0; $i < count($categoriesArray); $i++)
	{	
		if ($i > 0)
			$query .= " and ";
		
		$attributeKey = "attribute_" . ($i + 1);
		$query .= "$attributeKey = '".$categoriesArray[$i] ."'";				 

	}
	$query .= " order by product_id desc";
	$result = mysql_query($query);
	while ($row = mysql_fetch_assoc($result)) 
	{						
		array_push($idsArray, $row["product_id"]);	
	}

	return $idsArray;
}

function getProductsByIdsArray($idsArray)
{	
	$responseArray = array();

	for ($i = 0; $i < count($idsArray); $i++)
	{
		$product_id = $idsArray[$i];
		$query = "select * from products_description where products_id = '". $product_id ."'";
		$result = mysql_query($query);

		while ($row = mysql_fetch_assoc($result)) {						
			$responseObject = array();
			$responseObject["product_id"] = $row["products_id"];			
			$media_instagram_id = explode('_', $row["products_instagram_id"]);
			$responseObject["owner_instagram_id"] = $media_instagram_id[1];
			$responseObject["products_id"] = $row['products_id'];
			$responseObject["products_description"] = $row['products_description'];
			$responseObject["products_url"] = $row['products_url'];
			$responseObject["products_viewed"] = $row['products_viewed'];
			$responseObject["products_instagram_id"] = $row['products_instagram_id'];
			$responseObject["products_external_url"] = $row["products_external_url"];
			array_push($responseArray, $responseObject);
		}
	}

	return $responseArray;
}

function filterByProductCategoriesNew($productsArray, $categoriesArray)
{
	$responseArray = array();

	for ($j = 0; $j < count($productsArray); $j++)
	{
		$product = $productsArray[$j];
		$product_id = $product["product_id"];
		$query = "select * from products_categories_and_sizes where product_id = '". $product_id ."' and ";

		for ($i = 0; $i < count($categoriesArray); $i++)
		{	
			if ($i > 0)
				$query .= " and ";
			
			$attributeKey = "attribute_" . ($i + 1);
			$query .= "$attributeKey = '".$categoriesArray[$i] ."'";				 

		}
		$result = mysql_query($query);
		while ($row = mysql_fetch_assoc($result)) 
		{
			array_push($responseArray, $product);	
		}
	}
	return $responseArray;
}


function searchByFreetextArray($freeTextArray)
{
	$theReturnArray = array();

	for ($i = 0; $i < count($freeTextArray); $i++)
	{		
		$searchItem = strtolower($freeTextArray[$i]);
		
		$query = "select * from products_description WHERE LOWER(products_description.products_description) like '%". $searchItem ."%';";
		$result = mysql_query($query);		

		while ($row = mysql_fetch_assoc($result)) 
		{						
			array_push($theReturnArray, $row["products_id"]);		
		}


	}

	for ($i = 0; $i < count($freeTextArray); $i++)
	{		
		$searchItem = strtolower($freeTextArray[$i]);
		
		$query = "select * from products_description WHERE LOWER(products_description.products_name) like '%". $searchItem ."%';";
		$result = mysql_query($query);		

		while ($row = mysql_fetch_assoc($result)) {		
			array_push($theReturnArray, $row["products_id"]);			
		}	

	}

	return $theReturnArray;
}

function searchByFreetextArrayNew($freeTextArray)
{
	$responseArray = array();

	for ($i = 0; $i < count($freeTextArray); $i++)
	{		
		$searchItem = strtolower($freeTextArray[$i]);
		
		$query = "select * from products_description WHERE LOWER(products_description.products_description) like '%". $searchItem ."%'  order by products_id desc";
		$result = mysql_query($query);		

		while ($row = mysql_fetch_assoc($result)) 
		{						
			$responseObject = array();
			$responseObject["product_id"] = $row["products_id"];			
			$media_instagram_id = explode('_', $row["products_instagram_id"]);
			$responseObject["owner_instagram_id"] = $media_instagram_id[1];
			$responseObject["products_id"] = $row['products_id'];
			$responseObject["products_description"] = $row['products_description'];
			$responseObject["products_url"] = $row['products_url'];
			$responseObject["products_viewed"] = $row['products_viewed'];
			$responseObject["products_instagram_id"] = $row['products_instagram_id'];
			$responseObject["products_external_url"] = $row["products_external_url"];
			array_push($responseArray, $responseObject);	
		}


	}

	return $responseArray;
}

function pruneProductsByFreetextArray($pruneArray, $freeTextArray)
{	
	$retAR = array();


	$productsArray = array();
	for ($i = 0; $i < count($pruneArray); $i++)
	{
		$item = getProductsByID($pruneArray[$i]["product_id"]);
		$ar = array();
		$ar["product_id"] = $item[0]["product_id"];
		array_push($productsArray, $ar );
	}

	$productsArray = getProductDescriptions($productsArray);
	

	for ($i = 0; $i < count($productsArray); $i++)
	{

		$inProductDescription = 1;
		for ($j = 0; $j < count($freeTextArray); $j++)
		{
			$searchItem = strtolower("" . $freeTextArray[$j] . "");
			$description = strtolower($productsArray[$i]["products_description"]);
//			echo "\nSearchItem: ". $searchItem;
//			echo "\description: ". $description;
			if (strpos($description, $searchItem) !== false) {
			}
			else
			{
				$inProductDescription = 0;
			}			
		}	

		$inProductName = 1;
		for ($j = 0; $j < count($freeTextArray); $j++)
		{
			$searchItem = strtolower("" . $freeTextArray[$j] . "");
			$name = strtolower($productsArray[$i]["products_name"]);
//			echo "\nSearchItem: ". $searchItem;
//			echo "\name: ". $name;

			if (strpos($name, $searchItem) !== false) {
			}
			else
			{
				$inProductName = 0;
			}			
//			echo "\ninProductDesctiption: $inProductDescription";
//			echo "\ninProductName: $inProductName";
//			echo "\n\n";

		}
		
		if ($inProductName || $inProductDescription)
			array_push($retAR, $productsArray[$i]);
	}

	return $retAR;
}

$rowArray = array();

$proceed = 1;

if (strlen($_POST["categories_string"]) > 0 && strlen($_POST["freetext_string"]) > 0)
{
//	$rowArray = searchByProductCategories($rowArray, explode("___", $_POST["categories_string"]));
//	$rowArray = pruneProductsByFreetextArray($rowArray, explode("___", $_POST["freetext_string"]));

	$productsArray = searchByFreetextArrayNew(explode("___", $_POST["freetext_string"]));
	$productsArray = filterByProductCategoriesNew($productsArray, explode("___", $_POST["categories_string"]));
	$json = json_encode($productsArray);
	echo $json;
	$proceed = 0;
}
else if (strlen($_POST["categories_string"]) > 0)
{
//	$rowArray = searchByProductCategories($rowArray, explode("___", $_POST["categories_string"]));
	$idsArray = searchByProductCategoriesNew(explode("___", $_POST["categories_string"]));
	$productsArray = getProductsByIdsArray($idsArray);
	$json = json_encode($productsArray);
	echo $json;
	$proceed = 0;
}
else if (strlen($_POST["freetext_string"]) > 0)
{
	$productsArray = searchByFreetextArrayNew(explode("___", $_POST["freetext_string"]));
	$json = json_encode($productsArray);
	echo $json;

/*
 	$idsArray = searchByFreetextArray(explode("___", $_POST["freetext_string"]));
 	 	
 	$ar = array();
 	for ($i = 0; $i < count($idsArray); $i++)
 	{
		$productsArray = getProductsByID($idsArray[$i]);
		$productsArray = getProductDescriptions($productsArray);
		$productsArray = getProductDetails($productsArray);
		$productsArray = getProductAttributes($productsArray);

		if ($productsArray[0] != null)
			array_push($ar, $productsArray[0]);
	}

	$json = json_encode($ar);
	echo $json;
*/

	$proceed = 0;
}




if ($proceed)
{
	$idsArray = array();
	for ($i = 0; $i < count($rowArray); $i++)
		array_push($idsArray, $rowArray[$i]["product_id"]);


	$ar = array();
	for ($i = 0; $i < count($idsArray); $i++)
	{
		$productsArray = getProductsByID($idsArray[$i]);
		$productsArray = getProductDescriptions($productsArray);
		$productsArray = getProductDetails($productsArray);
		$productsArray = getProductAttributes($productsArray);

		if ($productsArray[0] != null)
			array_push($ar, $productsArray[0]);
	}
	$json = json_encode($ar);
	echo $json;

}



?>