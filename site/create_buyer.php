<?php

include_once("db.php");

error_reporting(-1);

function create_new_buyer($userID, $username)
{
	$query = "select * from INSTASHOP_BUYERS where userID = $userID";
	$result = mysql_query($query);

	$exists = 0;
	while ($row = mysql_fetch_assoc($result)) {
		$exists = 1;
	}

	if (!$exists)
	{
		$query = "insert into INSTASHOP_BUYERS values ('".$userID ."', '". $username ."');";
		$result = mysql_query($query);
	}
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


create_new_buyer($_POST["userID"], $_POST["username"]);

mysql_close();

?>