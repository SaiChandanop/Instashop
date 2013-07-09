<?

include_once("./push_notification.php");

$zen_host = "mysql51-040.wc1.ord1.stabletransit.com"; 
$zen_user = "690403_zencart"; 
$zen_pass = "50Bridge318"; 
$zen_db   = "690403_instashop_db";

echo "\n-------------------------------------------------------------------------------------------------------------------";
print_r($_POST);
echo "\n-------------------------------------------------------------------------------------------------------------------";
function decrementProductQuantity($host, $user, $pass, $db, $product_id)
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
	
	$responseArray = array();

	$query = "select * from products where products_id = '". $product_id ."'";
	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) {	
		$quantity = $row["products_quantity"];
		$quantity--;
		$query = "update products set products_quantity = '".$quantity ."' where products_id = '". $product_id ."'";
		$result = mysql_query($query);
    }
}


function getSellerZenIDFromProductID($host, $user, $pass, $db, $product_id)
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
	
	$returnValue = "";

	$query = "select * from products where products_id = '". $product_id ."'";
	$result = mysql_query($query);

	if ($row = mysql_fetch_assoc($result)) {	
		$returnValue = $row["master_categories_id"];
    }

	return $returnValue;
}


function updateOrdersProducts($host, $user, $pass, $db, $products_id, $products_name, $products_price, $products_quantity, $purchaser_id)
{

	//$query = "insert into orders_products 'orders_products_id', 'orders_id', 'products_id', 'products_model', 'products_name', 'products_price', 'final_price', 'products_tax','products_quantity', 'onetime_charges','products_priced_by_attribute', 'product_is_free', 'products_discount_type', 'products_discount_type_from','products_prid'";

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

function createOrderStatusHistory($host, $user, $pass, $db, $ordersID)
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
		

	$query = "insert into orders_status_history values ('', '$ordersID', '1', '". date('Y-m-d H:i:s') ."', '1', '')";
	$result = mysql_query($query);

}

function createPostmasterOrderRecord($host, $user, $pass, $db, $ordersID, $postmaster_shipment_id, $postmaster_tracking_number, $postmaster_label_url)
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
		

	$query = "insert into orders_postmaster values ('', '$ordersID', '$postmaster_shipment_id', '$postmaster_tracking_number', '$postmaster_label_url')";
	$result = mysql_query($query);

	$postmaster_order_id =  mysql_insert_id();	

	return $postmaster_order_id;


}

$products_id = $_POST["products_id"];
$products_name = $_POST["products_name"];
$products_price = $_POST["products_price"];
$products_quantity = $_POST["products_quantity"];
$purchaser_id = $_POST["purchaser_id"];



decrementProductQuantity($zen_host, $zen_user, $zen_pass, $zen_db, $products_id);
$ordersID = updateOrdersProducts($zen_host, $zen_user, $zen_pass, $zen_db, $products_id, $products_name, $products_price, $products_quantity, $purchaser_id);
createOrderStatusHistory($zen_host, $zen_user, $zen_pass, $zen_db, $ordersID);

$postmaster_order_id = createPostmasterOrderRecord($zen_host, $zen_user, $zen_pass, $zen_db, $ordersID, $_POST["postmaster_shipment_id"], $_POST["tracking_id"], $_POST["postmaster_label_url"]);

$seller_zen_id = getSellerZenIDFromProductID($zen_host, $zen_user, $zen_pass, $zen_db, $products_id);
pushSoldMessageWithProductInfo($products_id, $products_name, $products_price, $purchaser_id, $seller_zen_id, $_POST["purchaser_username"]);

?>