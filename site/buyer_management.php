<?php

include_once("./db.php");

error_reporting(-1);

function create_new_buyer($username)
{

				
	$query = "select * from INSTASHOP_BUYERS where userID = $userID";
	$result = mysql_query($query);

	$exists = 0;
	while ($row = mysql_fetch_assoc($result)) {
		$exists = 1;
	}

	if (!$exists)
	{
		$query = "insert into INSTASHOP_BUYERS values ('".$userID ."', '". $username ."', '');";
		$result = mysql_query($query);
	}
}

function associateInstagramIDWithPushID($instagramID, $pushID)
{
	$query = "update INSTASHOP_BUYERS set push_id = '$pushID' where instagram_id = '$instagramID'";
	$result = mysql_query($query);

}

if ($_POST["function"] == "create")
{
	create_new_buyer($_POST["instagram_id"], $_POST["username"]);
}
else if ($_POST["function"] == "update_push_id")
{
	associateInstagramIDWithPushID($_POST["instagram_id"], $_POST["push_id"]);
}




?>