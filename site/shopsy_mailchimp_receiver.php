<?

include_once("./db.php");


if (strcmp($_POST["action"], "submit_email") == 0)
{

	$emailAddress = $_POST["email"];
	$instagram_username = $_POST["instagram_username"];		
	$query = "insert into mailchimp_emails values ('', '$emailAddress', '$instagram_username')";
	echo "query: ". $query;
	$result = mysql_query($query);
}

?>