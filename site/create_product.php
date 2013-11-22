<?
include_once("./db.php");

function getZencartIDFromInstagramID($instagramID)
{				
	$query = "select * from sellers where instagram_id = '".$instagramID ."'";
//	echo "get zencart id query: " . $query;
	$result = mysql_query($query);
		
	
	if ($row = mysql_fetch_assoc($result)) {
	
		$retVal = $row["id"];
	}

	return $retVal;
}



function createNewProduct($product_quantity, $product_model, $product_image, $product_price,  $product_date, $product_weight, $product_owner_id)
{

	$product_date = date('Y-m-d H:i:s');


	$query = "insert into products values ('', '1', '". $product_quantity ."', '" . $product_model ."', '". $product_image ."', '". $product_price ."', '', '" . $product_date ."',  '', '" . $product_weight ."', '', '1','','','','1','1','','', '', '', '', '', '', '', '', '', '". $product_price ."', '" . $product_owner_id ."', '','','','','','')";
				
//	echo "\nquery1: ". $query;
	
	$result = mysql_query($query);
	$productID =  mysql_insert_id();	

	return $productID;
}

function updateProductsToCategories($product_id, $product_owner_id)
{
	$query = "insert into products_to_categories values ('$product_id', '$product_owner_id')";

//	echo "\n updateProductsToCategories: ". $query;

	$result = mysql_query($query);


}

function updateProductsDescription($product_id, $product_title, $product_description, $product_url, $instagram_object_id, $product_list_price, $product_external_url)
{
	$query = "insert into products_description values ('". $product_id ."', '1', '".$product_title ."', '".$product_description ."', '". $product_url ."', '0', '$instagram_object_id', '$product_list_price', '$product_external_url')";
//	echo "\n updateProductsDescription: ". $query;
	$result = mysql_query($query);
	
}


function updateSellersProducts($instagram_user_id, $zencart_id, $product_id)
{

	$query = "insert into sellers_products values ('$instagram_user_id', '$zencart_id', '$product_id')";
//	echo "\n updateSellersProducts: ". $query;
	$result = mysql_query($query);

}


function updateProductsAttributes($product_ID, $postObject)
{

	$quantity = $postObject["object_quantity"];
	$size = $postObject["object_size"];

	$categories = explode("!!", $postObject["object_categories"]);


	$query = "insert into products_categories_and_sizes values ('','$product_ID','$quantity','$size','$categories[0]','$categories[1]','$categories[2]','$categories[3]','$categories[4]','$categories[5]','$categories[6]')";	
	$result = mysql_query($query);


	echo "\n updateProductsAttributes: ". $query;
		

}




if ($_POST["create_type"] == "product_object")
{

	$user_id = getZencartIDFromInstagramID($_POST["instagramUserId"]);
//echo "\ngetZencartIDFromInstagramID: user_id: ". $user_id;

	$product_id = createNewProduct($_POST["object_quantity"], $_POST["object_model"], $_POST["product_image"], $_POST["object_price"], $_POST["product_date"], $_POST["product_weight"], $user_id);
	//echo "\ncreateNewProduct product_id: ". $product_id;


	updateProductsAttributes($product_id, $_POST);

	updateProductsToCategories($product_id, $user_id);
	//echo "\nupdateProductsToCategories";

	updateProductsDescription($product_id, $_POST["object_title"], $_POST["object_description"], $_POST["object_image_urlstring"], $_POST["object_instagram_id"], $_POST["object_list_price"], $_POST["object_external_url"] );
	//echo "\n updateProductsDescription";

	updateSellersProducts($_POST["instagramUserId"], $user_id, $product_id);
	//echo "\n updateSellersProducts done";


	echo "product_id=$product_id";

}
else if ($_POST["create_type"] == "size_quantity_object")
{
	echo "\nsize_quantity_object!!!!!";
	print_r($_POST);
	updateProductsAttributes($_POST);

}

?>