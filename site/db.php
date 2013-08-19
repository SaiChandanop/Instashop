<?

$db_host = "mysql51-076.wc1.ord1.stabletransit.com"; 
$db_user = "843923_instashop"; 
$db_pass = "Instashop22"; 
$db_db   = "843923_instashop_db";


$con = mysql_connect($db_host, $db_user, $db_pass);
if (!$con) {
	echo "Could not connect to server\n";
	trigger_error(mysql_error(), E_USER_ERROR);
} 
	
$r2 = mysql_select_db($db_db);
if (!$r2) {
	echo "Cannot select database\n";
	trigger_error(mysql_error(), E_USER_ERROR); 
} 




?>
