<?

include_once("./db.php");


function saveProductWithIDS($instagram_id, $product_id)
{

	$query = "select * from saved_products where instagram_id = '$instagram_id' and product_id = '$product_id'";
	$result = mysql_query($query);
	if ($row = mysql_fetch_assoc($result)) 
	{	
		$query = "delete from saved_products where id = '". $row["id"] ."'";		
		mysql_query($query);
		echo "query: ".$query; 
	}
	else 
	{
		$responseArray = array();
		$query = "insert into saved_products values ('', '$instagram_id', '$product_id')";
		$result = mysql_query($query);
		echo "query: ".$query;
	}
	
	
}


if (strcmp($_POST["request_type"], "saved") == 0)
	saveProductWithIDS($_POST["instagram_id"], $_POST["product_id"]);



