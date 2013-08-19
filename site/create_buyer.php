<?php

$zen_host = "mysql51-040.wc1.ord1.stabletransit.com"; 
$zen_user = "690403_zencart"; 
$zen_pass = "50Bridge318"; 
$zen_db   = "690403_instashop_db";

$buyers_host = "mysql51-033.wc1.ord1.stabletransit.com"; 
$buyers_user = "690403_alchemy50"; 
$buyers_pass = "50Bridge318"; 
$buyers_db   = "690403_instashop_buyers";


$sellers_host = "mysql51-033.wc1.ord1.stabletransit.com"; 
$sellers_user = "690403_instashop"; 
$sellers_pass = "2Fpz7qm4"; 
$sellers_db   = "690403_instashop_sellers";

error_reporting(-1);

function create_new_buyer($host, $user, $pass, $db, $userID, $username)
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
	mysql_close();
}




function showDescriptions($host, $user, $pass, $db)
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
				
	$query = "select * from categories_description";
	$result = mysql_query($query);
		
	while ($row = mysql_fetch_assoc($result)) {
		echo "<BR>";
		print_r($row);
		echo "<BR>";
	}
}


function createZencartSeller($host, $user, $pass, $db)
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
				
	$query = "insert into categories values ('', '', '0', '0', '', '', '1')";
	$result = mysql_query($query);
		
	$retVal =  mysql_insert_id();

	echo "new zencart seller id: ".$retVal;
	echo "<br>";

	return $retVal;
}


function createInstashopSeller($host, $user, $pass, $db)
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
	


	$query = "insert into sellers values ('12', '1234')"; 
	$result = mysql_query($query);

}


create_new_buyer($buyers_host, $buyers_user, $buyers_pass, $buyers_db, $_POST["userID"], $_POST["username"]);

?>