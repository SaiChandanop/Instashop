<?
include_once("./db.php");



function getSuggestedShops()
{	
	$sellersInstagramIDs = array();
	
	$query = "select * from suggested_sellers";
	$result = mysql_query($query);


	while ($row = mysql_fetch_assoc($result)) 
		array_push($sellersInstagramIDs, $row["instagram_id"]);

	return $sellersInstagramIDs;

}

	if ($_POST["action"] == "get_suggested_shops")
	{
		$retVal = array();
		$retVal = getSuggestedShops();
		$json = json_encode($retVal);
		echo $json;
	}



?>