<?

$zen_host = "mysql51-040.wc1.ord1.stabletransit.com"; 
$zen_user = "690403_zencart"; 
$zen_pass = "50Bridge318"; 
$zen_db   = "690403_instashop_db";


$sellers_host = "mysql51-033.wc1.ord1.stabletransit.com"; 
$sellers_user = "690403_instashop"; 
$sellers_pass = "2Fpz7qm4"; 
$sellers_db   = "690403_instashop_sellers";




function getZencartIDFromInstagramID($host, $user, $pass, $db, $instagramID)
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
				
	$query = "select * from sellers where instagram_id = '".$instagramID ."'";
	$result = mysql_query($query);
		
	
	if ($row = mysql_fetch_assoc($result)) {
	
		$retVal = $row["id"];
	}

	return $retVal;
}



function createNewProduct($host, $user, $pass, $db, $product_quantity, $product_model, $product_image, $product_price, $product_date, $product_weight, $product_owner_id)
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

	$query = "insert into products values ('', '', '". $product_quantity ."', '" . $product_model ."', '". $product_image ."', '". $product_price ."', '" . $product_date ."', '', '', '" . $product_weight ."', '', '1','','','','','','','', '', '', '', '', '', '', '', '', '". $product_price ."', '" . $product_owner_id ."', '','','','','','')";
				
	echo "query: ". $query;
	
	$result = mysql_query($query);
	$productID =  mysql_insert_id();	

	mysql_close();

	return $productID;
}

function updateProductsToCategories($host, $user, $pass, $db, $product_id, $product_owner_id)
{
	$con = mysql_connect($host, $user, $pass);
	$r2 = mysql_select_db($db);

	$query = "insert into products_to_categories values ('$product_id', '$product_owner_id')";
	$result = mysql_query($query);

	mysql_close();

}

function updateProductsDescription($host, $user, $pass, $db, $product_id, $product_title, $product_description, $product_url)
{
	$con = mysql_connect($host, $user, $pass);
	$r2 = mysql_select_db($db);

	$query = "insert into products_description values ('". $product_id ."', '1', '".$product_title ."', '".$product_description ."', '". $product_url ."', '0')";
	$result = mysql_query($query);

	mysql_close();
}

function updateSellersProducts($host, $user, $pass, $db, $instagram_user_id, $zencart_id, $product_id)
{
	$con = mysql_connect($host, $user, $pass);
	$r2 = mysql_select_db($db);

	$query = "insert into sellers_products values ('$instagram_user_id', '$zencart_id', '$product_id')";
	echo "\n update sellers query: ". $query;
	$result = mysql_query($query);

	mysql_close();

}
print_r($_POST);

$user_id = getZencartIDFromInstagramID($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $_POST["instagramUserId"]);
echo "\ngetZencartIDFromInstagramID: user_id: ". $user_id;

$product_id = createNewProduct($zen_host, $zen_user, $zen_pass, $zen_db, $_POST["object_quantity"], $_POST["object_model"], $_POST["product_image"], $_POST["object_price"], $_POST["product_date"], $_POST["product_weight"], $user_id);
echo "\ncreateNewProduct product_id: ". $product_id;

updateProductsToCategories($zen_host, $zen_user, $zen_pass, $zen_db, $product_id, $user_id);
echo "\nupdateProductsToCategories";

updateProductsDescription($zen_host, $zen_user, $zen_pass, $zen_db, $product_id, $_POST["object_title"], $_POST["object_description"], $_POST["object_url"]);
echo "\n updateProductsDescription";

updateSellersProducts($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $_POST["instagramUserId"], $user_id, $product_id);




?>