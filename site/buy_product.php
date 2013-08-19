<?

include_once("./push_notification.php");
include_once("../db.php");


function decrementProductQuantity($product_id, $product_category_id)
{
	
	$responseArray = array();

	$query = "select * from products where products_id = '". $product_id ."'";
	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) {	
		$quantity = $row["products_quantity"];
		$quantity--;
		$query = "update products set products_quantity = '".$quantity ."' where products_id = '". $product_id ."'";
		$result = mysql_query($query);
    }


	$query = "select * from products_categories_and_sizes where id = '". $product_category_id ."'";
	echo "\n\nquery!!!: $query \n\n\n";

	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) {	
		$quantity = $row["quantity"];
		$quantity--;
		$query = "update products_categories_and_sizes set quantity = '".$quantity ."' where id = '". $product_category_id ."'";

		echo "\n\nquery2!!!: $query \n\n\n";
		$result = mysql_query($query);
    }




}


function getSellerZenIDFromProductID($product_id)
{	
	$returnValue = "";

	$query = "select * from products where products_id = '". $product_id ."'";
	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) {	
		$returnValue = $row["master_categories_id"];
    }

	return $returnValue;
}


function updateOrdersProducts($products_id, $products_name, $products_price, $products_quantity, $purchaser_id)
{

	//$query = "insert into orders_products 'orders_products_id', 'orders_id', 'products_id', 'products_model', 'products_name', 'products_price', 'final_price', 'products_tax','products_quantity', 'onetime_charges','products_priced_by_attribute', 'product_is_free', 'products_discount_type', 'products_discount_type_from','products_prid'";		

	$max = 0;

	$query = "select MAX(orders_id) from orders_products;";

	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result))
	{
		$max = $row["MAX(orders_id)"];
	}

	$max++;

	$query = "insert into orders_products values ('', '$max', '$products_id', '', '$products_name', '$products_price', '$products_price', '0','$products_quantity', '0','0', '0', '0', '0','$purchaser_id')";
	$result = mysql_query($query);
	$orders_id =  mysql_insert_id();	

	return $orders_id;
}

function createOrderStatusHistory($ordersID)
{

	$query = "insert into orders_status_history values ('', '$ordersID', '1', '". date('Y-m-d H:i:s') ."', '1', '')";
	$result = mysql_query($query);

}

function createPostmasterOrderRecord($ordersID, $postmaster_shipment_id, $postmaster_tracking_number, $postmaster_label_url)
{

	$query = "insert into orders_postmaster values ('', '$ordersID', '$postmaster_shipment_id', '$postmaster_tracking_number', '$postmaster_label_url')";
	$result = mysql_query($query);

	$postmaster_order_id =  mysql_insert_id();	

	return $postmaster_order_id;


}

$products_id = $_POST["products_id"];
$product_category_id = $_POST["product_category_id"];
$products_name = $_POST["products_name"];
$products_price = $_POST["products_price"];
$products_quantity = $_POST["products_quantity"];
$purchaser_id = $_POST["purchaser_id"];



decrementProductQuantity($products_id, $product_category_id);
$ordersID = updateOrdersProducts($products_id, $products_name, $products_price, $products_quantity, $purchaser_id);
createOrderStatusHistory($ordersID);

$postmaster_order_id = createPostmasterOrderRecord($ordersID, $_POST["postmaster_shipment_id"], $_POST["tracking_id"], $_POST["postmaster_label_url"]);

$seller_zen_id = getSellerZenIDFromProductID($products_id);
pushSoldMessageWithProductInfo($products_id, $products_name, $products_price, $purchaser_id, $seller_zen_id, $_POST["purchaser_username"], $postmaster_order_id);

?>