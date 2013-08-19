<?


$file = file_get_contents('./attributes1.csv', true);

//echo "file: " . $file;

$categories = array();

$linesArray = explode("\n", $file);
//print_r($linesArray);

for ($i = 0; $i < count($linesArray); $i++)
{
	$line = $linesArray[$i];
	$itemsArray = explode(",", $line);

	$firstItem = $itemsArray[0];

//	print_r($itemsArray);
	if (strlen($firstItem) > 0)
		array_push($categories, $firstItem);

/*		echo "firstItem: ".$firstItem;
		echo "<br>";
		echo "<br>";
*/
}


	print_r($categories);
?>