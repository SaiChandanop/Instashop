<?php


echo "begin\n";
echo "request: \n";
print_r($_REQUEST);
echo "\n picture: \n";
print_r($_FILES['picture']);

$_FILES["picture"]["name"] = $_REQUEST["title"] . ".jpeg";

$didUpload = move_uploaded_file($_FILES["picture"]["tmp_name"],
      "upload/" . $_FILES["picture"]["name"]);

echo "\nStored in: " . "upload/" . $_FILES["picture"]["name"];
echo "\n done, success: ". $didUpload;


?>

