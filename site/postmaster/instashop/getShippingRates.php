<?

require_once('../lib/Postmaster.php');
include_once("../../db.php");

Postmaster::setApiKey("tt_NDY1MDAxOjhfb0dFcXhXS2o2bVFtODhHeGkwb2JQQzZBVQ");

$result = Postmaster_Rates::get(array(

  "from_zip" => $_GET["from_zip"],
    "to_zip" => $_GET["to_zip"],
    "weight" => $_GET["weight"],
    "carrier" => $_GET["carrier"],

//    "from_zip" => "78701",
//    "to_zip" => "78704",
//    "weight" => 1.5,
//    "carrier" => "fedex",

));



$retar = array();
$retar["currency"] = $result["currency"];
$retar["charge"] = $result["charge"];
$retar["service"] = $result["service"];
$retar["carrier"] = $_GET["carrier"];


$json = json_encode($retar);
echo $json;


?>


