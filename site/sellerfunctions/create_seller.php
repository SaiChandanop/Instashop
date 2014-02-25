<?php
include_once("../db.php");

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
	
	$query = "insert into sellers_addresses values ('". $instagramID ."', '".$postDictionary["instagram_username"] ."', '".$postDictionary["seller_name"] ."', '".$postDictionary["seller_address"] ."','".$postDictionary["seller_city"] ."','".$postDictionary["seller_state"] ."','".$postDictionary["seller_zip"] ."','".$postDictionary["seller_phone"] ."','".$postDictionary["seller_email"] ."','".$postDictionary["seller_website"] ."','".$postDictionary["seller_category"] ."', '')";

	$result = mysql_query($query);
}



if ($_POST["action"] == "checkSeller")
{
	$retAr = array();

	$query = "select * from sellers_addresses where instagram_id = '".$_POST["userID"] ."'";

	$result = mysql_query($query);
		
	if ($row = mysql_fetch_assoc($result)) {
		
		$zencartID = checkInshashopForInstagramID($_POST["userID"]);

		if ($zencartID)
		{
			$retAr["zencart_id"] = $zencartID;
		}

	}
	else 
		$retAr["result"] = "no";

	$json = json_encode($retAr);
	echo $json;
}
else if ($_POST["action"] == "update_push_id")
{
	$query = "update sellers set push_id = ' ". $_POST["push_id"] ."' where instagram_id = '" . $_POST["instagram_id"] . "'";
	$result = mysql_query($query);
}

else
{
	$zencartID = checkInshashopForInstagramID($_POST["userID"]);
	if ($zencartID)
	{
		
	}
	else
	{	
		$zencartID = createZencartSeller($_POST["username"]);
		createInstashopSeller($zencartID, $_POST["userID"], $_POST["push_id"]);
		createInstashopSellerAddress($_POST["userID"], $_POST);
	}

	


	$retAr = array();
	$retAr["zencart_id"] = $zencartID;
	$json = json_encode($retAr);
	echo $json;
}

?>