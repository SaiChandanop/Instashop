<?php

include_once("db.php");
error_reporting(-1);



function createZencartSeller($instagramUsername)
{				
	$query = "insert into categories values ('', '', '0', '0', '', '', '1')";

	$result = mysql_query($query);		
	$retVal =  mysql_insert_id();

	$query = "insert into categories_description values ('".$retVal ."', '1', '".$instagramUsername . "', '".$instagramUsername ."image')";
	
	$result = mysql_query($query);

	return $retVal;


}

function checkInshashopForInstagramID($instagramID)
{
	$retVal = 0;
	$query = "select * from sellers where instagram_id = '".$instagramID ."'";

	$result = mysql_query($query);
		
	while ($row = mysql_fetch_assoc($result)) {
//		print_r($row);
		$retVal = $row["id"];
	}

	return $retVal;
}


function createInstashopSeller($zencartID, $instagramID, $push_id)
{
	$query = "insert into sellers values ('". $zencartID ."', '".$instagramID ."', '$push_id')";
	$result = mysql_query($query);
}


function createInstashopSellerAddress($instagramID, $postDictionary)
{
	$query = "insert into sellers_addresses values ('". $instagramID ."', '".$postDictionary["seller_name"] ."', '".$postDictionary["seller_address"] ."','".$postDictionary["seller_city"] ."','".$postDictionary["seller_state"] ."','".$postDictionary["seller_zip"] ."','".$postDictionary["seller_phone"] ."' )";
	$result = mysql_query($query);
}




$con = mysql_connect($db_host, $_db_user, $db_pass);
if (!$con) {
	echo "Could not connect to server\n";
	trigger_error(mysql_error(), E_USER_ERROR);
} 
	
$r2 = mysql_select_db($db_db);
if (!$r2) {
	echo "Cannot select database\n";
	trigger_error(mysql_error(), E_USER_ERROR); 
} 




$zencartID = checkInshashopForInstagramID($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $_POST["userID"]);
if ($zencartID)
	{

	}
else
	{	
		$zencartID = createZencartSeller($zen_host, $zen_user, $zen_pass, $zen_db, $_POST["username"]);
		createInstashopSeller($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $zencartID, $_POST["userID"], $_POST["push_id"]);
	}

createInstashopSellerAddress($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $_POST["userID"], $_POST);




$retAr = array();
$retAr["zencart_id"] = $zencartID;
$json = json_encode($retAr);
echo $json;

?>