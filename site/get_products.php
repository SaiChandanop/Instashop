<?

//require_once 'Instagram.php';
$config = array(
        'client_id' => 'd63f114e63814512b820b717a73e3ada',
        'client_secret' => '75cd3c5f8d894ed7a826c4af7f1f085f',
        'grant_type' => 'authorization_code',
        'redirect_uri' => 'igd63f114e63814512b820b717a73e3ada://authorize',
     );




$zen_host = "mysql51-040.wc1.ord1.stabletransit.com"; 
$zen_user = "690403_zencart"; 
$zen_pass = "50Bridge318"; 
$zen_db   = "690403_instashop_db";


$sellers_host = "mysql51-033.wc1.ord1.stabletransit.com"; 
$sellers_user = "690403_instashop"; 
$sellers_pass = "2Fpz7qm4"; 
$sellers_db   = "690403_instashop_sellers";


function getSellerProducts($host, $user, $pass, $db)
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



	$query = "select * from sellers_products";
	$result = mysql_query($query);


	$responseArray = array();

	while ($row = mysql_fetch_assoc($result)) 
	{
		$responseObject = array();

		$responseObject["product_id"] = $row["product_id"];
		$responseObject["owner_instagram_id"] = $row["instagram_id"];
		
		array_push($responseArray, $responseObject);
	}

	mysql_close();
	return $responseArray;
}

function getProductDescriptions($host, $user, $pass, $db, $theProductsArray)
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

	for ($i = 0; $i < count($theProductsArray); $i++)
	{
		$product = $theProductsArray[$i];
		$product_id = $product["product_id"];
		$query = "select * from products_description where products_id = '". $product_id ."'";
		$result = mysql_query($query);

		while ($row = mysql_fetch_assoc($result)) {						
			$product["products_id"] = $row['products_id'];
			$product["products_name"] = $row['products_name'];
			$product["products_description"] = $row['products_description'];
			$product["products_url"] = $row['products_url'];
			$product["products_viewed"] = $row['products_viewed'];

			array_push($responseArray, $product);
		}

	}

	return $responseArray;
}


function getProductDetails($host, $user, $pass, $db, $theProductsArray)
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

	for ($i = 0; $i < count($theProductsArray); $i++)
	{
		$product = $theProductsArray[$i];
		$product_id = $product["product_id"];
		$query = "select * from products where products_id = '". $product_id ."'";
		$result = mysql_query($query);

		while ($row = mysql_fetch_assoc($result)) {						
			$product["products_price"] = $row['products_price'];
			$product["products_quantity"] = $row['products_quantity'];
			$product["products_model"] = $row['products_model'];
			$product["products_date_added"] = $row['products_date_added'];
			array_push($responseArray, $product);
		}

	}

	return $responseArray;
}

//echo "hi";
$productsArray = getSellerProducts($sellers_host, $sellers_user, $sellers_pass, $sellers_db);
$productsArray = getProductDescriptions($zen_host, $zen_user, $zen_pass, $zen_db, $productsArray);
$productsArray = getProductDetails($zen_host, $zen_user, $zen_pass, $zen_db, $productsArray);

//print_r($productsArray); 
$json = json_encode($productsArray);
echo $json;


session_start();


// Instantiate the API handler object
//$instagram = new Instagram($config);
//$instagram->openAuthorizationUrl();



?>