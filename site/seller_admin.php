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
	/*	echo "<BR>";
		print_r($row);
		echo "<BR>";
*/
	}
}


function createZencartSeller($host, $user, $pass, $db, $instagramUsername)
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

//	echo "createZencartSeller, query1: ". $query;
	$result = mysql_query($query);		
	$retVal =  mysql_insert_id();

	$query = "insert into categories_description values ('".$retVal ."', '1', '".$instagramUsername . "', '".$instagramUsername ."image')";
	
//	echo "createZencartSeller query2: ". $query;
	$result = mysql_query($query);

	return $retVal;


}

function checkInshashopForInstagramID($host, $user, $pass, $db, $instagramID)
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
	

	$retVal = 0;
	$query = "select * from sellers where instagram_id = '".$instagramID ."'";

	$result = mysql_query($query);
		
	while ($row = mysql_fetch_assoc($result)) {
//		print_r($row);
		$retVal = $row["id"];
	}


	return $retVal;
}


function createInstashopSeller($host, $user, $pass, $db, $zencartID, $instagramID)
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
	

	$query = "insert into sellers values ('". $zencartID ."', '".$instagramID ."')"; 
	$result = mysql_query($query);

}

$zencartID = checkInshashopForInstagramID($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $_POST["userID"]);


if ($zencartID)
	{
	}
else
	{	
		$zencartID = createZencartSeller($zen_host, $zen_user, $zen_pass, $zen_db, $_POST["username"]);
		createInstashopSeller($sellers_host, $sellers_user, $sellers_pass, $sellers_db, $zencartID, $_POST["userID"]);
	}

$retAr = array();
$retAr["zencart_id"] = $zencartID;
$json = json_encode($retAr);
echo $json;

?>