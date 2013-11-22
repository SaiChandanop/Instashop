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
	}
}

function editProductWithPost($_POST)
{

	$query = "update products_description set products_name='".$_POST["object_title"] ."', products_description='".$_POST["object_description"] ."', products_list_price='".$_POST["object_list_price"] ."' where products_id='".$_POST["edit_product_id"] . "'";
	
	echo "query: ". $query;
	mysql_query($query);
	
	$query = "update products set products_price='".$_POST["object_price"] ."' where products_id = ".$_POST["edit_product_id"];
	mysql_query($query);

	$query = "delete from products_categories_and_sizes where product_id = '". $_POST["edit_product_id"] ."'";
	mysql_query($query);

	print_r($_POST);
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


if ($action == "delete")
	deleteProductWithProductID($_POST["product_id"]);
else if ($action == "edit")
	editProductWithPost($_POST);
else if ($action == "edit_size_quantity_object")
	editProductCategorySize($_POST);


?>