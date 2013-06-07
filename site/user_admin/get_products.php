<?

$zen_host = "mysql51-040.wc1.ord1.stabletransit.com"; 
$zen_user = "690403_zencart"; 
$zen_pass = "50Bridge318"; 
$zen_db   = "690403_instashop_db";



function getProducts($host, $user, $pass, $db)
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

	$query = "select * from products_description\n";
	$result = mysql_query($query);


	$responseArray = array();

	while ($row = mysql_fetch_assoc($result)) {
		
		$responseObject = array();

		$responseObject["products_id"] = $row['products_id'];
		$responseObject["products_name"] = $row['products_name'];
		$responseObject["products_description"] = $row['products_description'];
		$responseObject["products_url"] = $row['products_url'];
		$responseObject["products_viewed"] = $row['products_viewed'];

		array_push($responseArray, $responseObject);
	}


	mysql_close();

	return $responseArray;
}

$productsArray = getProducts($zen_host, $zen_user, $zen_pass, $zen_db);
$json = json_encode($productsArray);

echo $json;

?>