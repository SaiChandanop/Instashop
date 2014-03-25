<?

include_once("../db.php");

function deleteProductWithProductID($productID)
{
	if (strlen($productID) > 0 && $productID != "*")
	{
		$query = "delete from products where products_id = '$productID';";
		echo "query: " . $query;

		mysql_query($query);

		$query = "delete from products_description where products_id = '$productID';";
		mysql_query($query);
	}
}

function editProductWithPost($_POST)
{
	
	$query = "update products_description set products_description='".$_POST["object_description"] ."', products_external_url = '". $_POST["object_external_url"] ."' where products_id='".$_POST["edit_product_id"] . "'";
	mysql_query($query);
	

	$query = "delete from products_categories_and_sizes where product_id = '". $_POST["edit_product_id"] ."'";
	mysql_query($query);

	
	$edit_product_id = $_POST["edit_product_id"];

	$categories = explode("!!", $_POST["object_categories"]);
	print_r($categories);
	$query = "insert into products_categories_and_sizes values ('','$edit_product_id','$quantity','$size','$categories[0]','$categories[1]','$categories[2]','$categories[3]','$categories[4]','$categories[5]','$categories[6]')";	
	$result = mysql_query($query);

}

function editProductCategorySize($postObject)
{
	
	echo "HERE";

	$productID = $postObject["zencart_product_id"];
	$quantity = $postObject["object_quantity"];
	$size = $postObject["object_size"];


	$categories = explode("|", $postObject["categories"]);

	$query = "insert into products_categories_and_sizes values ('','$productID','$quantity','$size','$categories[0]','$categories[1]','$categories[2]','$categories[3]','$categories[4]','$categories[5]','$categories[6]')";	
	echo "\nquery2: ".$query;
	$result = mysql_query($query);



}

$action = $_POST["action"];

print_r($_POST);

if ($action == "delete")
	deleteProductWithProductID($_POST["product_id"]);
else if ($action == "edit")
	editProductWithPost($_POST);
else if ($action == "edit_size_quantity_object")
	editProductCategorySize($_POST);


?>