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
	$rowArray = searchByProductCategories($rowArray, explode("___", $_POST["categories_string"]));
	$rowArray = pruneProductsByFreetextArray($rowArray, explode("___", $_POST["freetext_string"]));
}
else if (strlen($_POST["categories_string"]) > 0)
{
	$rowArray = searchByProductCategories($rowArray, explode("___", $_POST["categories_string"]));
}
else if (strlen($_POST["freetext_string"]) > 0)
{
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