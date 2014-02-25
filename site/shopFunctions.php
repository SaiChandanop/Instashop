<?
include_once("./db.php");



function getSuggestedShops()
{	
	$fileContents = file_get_contents("suggestedshops2.txt");
	$sellersInstagramIDs = explode("\n", $fileContents);

	$retAr = array();
	
	for ($i = 0; $i < count($sellersInstagramIDs) -1; $i++)
	{
		$query = "select instagram_id from sellers_addresses where instagram_username = '".$sellersInstagramIDs[$i] ."';";
		$result = mysql_query($query);

		while ($row = mysql_fetch_assoc($result)) 
			array_push($retAr, $row["instagram_id"]);
		
	}

	return $retAr;

}

if ($_POST["action"] == "get_suggested_shops")
	{
		$retVal = array();
		$retVal = getSuggestedShops();
		$json = json_encode($retVal);
		echo $json;
	}



?>