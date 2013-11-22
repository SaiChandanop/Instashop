<?

define("SEARCH_TYPE_PRDOCUT", 0);
define("SEARCH_TYPE_SELLER", 1);

include_once("../db.php");
include_once("../get_products.php");



function searchByProductNameAndDescription($freeTextArray)
{
		$returnArray = array();

		$query;
		for ($i = 0; $i < count($freeTextArray); $i++)
		{			
			if ($i == 0)
				$query = "select * from products_description WHERE products_description like '%".$freeTextArray[$i] ."%' ";

			else 
				$query .= "and products_description like '%".$freeTextArray[$i] ."%' ";
			//$query = "select * from products_description WHERE products_description like '%".$requestString ."%';";
			
//			echo "\n!!!!query: ".$query ."\n";

			
		}

		$result = mysql_query($query);
		while ($row = mysql_fetch_assoc($result)) {						
				$ar = array();
				$ar["id"] = $row["products_id"];
				$ar["type"] = SEARCH_TYPE_PRDOCUT;

				if (!in_array($ar, $returnArray))
					array_push($returnArray, $ar);

		}


		for ($i = 0; $i < count($freeTextArray); $i++)
		{		
			$query = "select * from products_description WHERE products_description like '%".$freeTextArray[$i] ."%';";
			$result = mysql_query($query);
		
			while ($row = mysql_fetch_assoc($result)) {						
				$ar = array();
				$ar["id"] = $row["products_id"];
				$ar["type"] = SEARCH_TYPE_PRDOCUT;


				if (!in_array($ar, $returnArray))
					array_push($returnArray, $ar);
				}

		}

		return $returnArray;
}

function filterSelectedProductsByCategories($ar, $categoriesArray)
{
	$returnArray = array();

	for ($i = 0; $i < count($ar); $i++)
	{
		$query = "select * from products_categories_and_sizes where product_id = '".$ar[$i]["id"] ."';";		
		$result = mysql_query($query);
		
		if ($row = mysql_fetch_assoc($result)) {
			
			$categoriesMatch = 1;
			for ($j = 0; $j < count($categoriesArray); $j++)
			{
				$rowKey = "attribute_". ($j + 1);
				
				if ($categoriesArray[$j] != $row[$rowKey])
					$categoriesMatch = 0;
				
			}
			if ($categoriesMatch && count($categoriesArray) > 0)
			{				
				array_push($returnArray, $ar[$i]["id"]);
			}
		}
		
	}

	return $returnArray;
}

function searchByProductCategories($idsArray, $categoriesArray)
{


	$query = "select * from products_categories_and_sizes where ";

	for ($i = 0; $i < count($categoriesArray); $i++)
	{	
		if ($i > 0)
			$query .= " and ";
		
		$attributeKey = "attribute_" . ($i + 1);
		$query .= "$attributeKey = '".$categoriesArray[$i] ."'";				 

	}
//	echo "query: ". $query;

	$result = mysql_query($query);
	while ($row = mysql_fetch_assoc($result)) {						

		$productID = $row["product_id"];

		if (!in_array($productID, $idsArray))
			array_push($idsArray, $productID);		
	}

	return $idsArray;
}



$ar = array();
$idsArray = array();


if (strlen($_POST["categories_string"]) > 0)
	{
		$idsArray = filterSelectedProductsByCategories($idsArray, explode("___", $_POST["categories_string"]));
		$idsArray = searchByProductCategories($idsArray, explode("___", $_POST["categories_string"]));
	}

if (strlen($_POST["freetext_string"]) > 0 && strlen($_POST["categories_string"]) > 0)
{	
	$matching_overlap_array = array();

	$free_text_matches = searchByProductNameAndDescription(explode("___", $_POST["freetext_string"]));	
	
	for ($i = 0; $i < count($free_text_matches); $i++)
	{
		$id = $free_text_matches[$i]["id"];
		if (in_array($id, $idsArray))
			array_push($matching_overlap_array, $id);
		
	}

	if (count($matching_overlap_array) > 0)
	{
		$priority_ids_array = array();
		for ($i = 0; $i < count($matching_overlap_array); $i++)
			array_push($priority_ids_array, $matching_overlap_array[$i]);

		for ($i = 0; $i < count($idsArray); $i++)
			if (!in_array($idsArray[$i], $matching_overlap_array))
				array_push($priority_ids_array, $idsArray[$i]);

		$idsArray = $priority_ids_array;

	}	
}
else if (strlen($_POST["freetext_string"]) > 0)
{
//	echo "\n search string: ". $_POST["freetext_string"];
	$free_text_matches = searchByProductNameAndDescription(explode("___", $_POST["freetext_string"]));	
	
	for ($i = 0; $i < count($free_text_matches); $i++)
		array_push($idsArray, $free_text_matches[$i]["id"]);
	
}

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





?>