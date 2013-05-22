<?php

$host = "mysql51-033.wc1.ord1.stabletransit.com"; 
$user = "690403_alchemy50"; 
$pass = "50Bridge318"; 
$db   = "690403_instashop_buyers";

$con = mysql_connect($host, $user, $pass);
$r2 = mysql_select_db($db);
$query = "CREATE TABLE IF NOT EXISTS INSTASHOP_BUYERS (userID INT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(250)) ENGINE=INNODB;";
$result = mysql_query($query);

$userID = $_POST["userID"];

$query = "select * from INSTASHOP_BUYERS where userID = $userID";
$result = mysql_query($query);


$exists = 0;
while ($row = mysql_fetch_assoc($result)) {
	$exists = 1;
}

if (!$exists)
{
	$query = "insert into INSTASHOP_BUYERS values ('".$_POST["userID"] ."', '". $_POST["username"] ."');";
	$result = mysql_query($query);
}

mysql_close();

?>