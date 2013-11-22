<?

require_once('../lib/Postmaster.php');
Postmaster::setApiKey("tt_NDY1MDAxOjhfb0dFcXhXS2o2bVFtODhHeGkwb2JQQzZBVQ");
/*

$handle = fopen("php://input", "rb");
$http_raw_post_data = '';
while (!feof($handle)) {
    $http_raw_post_data .= fread($handle, 8192);
}
fclose($handle);

$post_data = json_decode($http_raw_post_data,true);
*/
$shipmentArray = array();
$shipmentArray["contact"] = "Josh";
$shipmentArray["line1"] = "201123 Jay Street #934";
$shipmentArray["city"] = "Brooklasdfyn";
$shipmentArray["state"] = "CT";
$shipmentArray["zip_code"] = "11201";





$result = Postmaster_AddressValidation::validate($shipmentArray);

//print_r($result);
/*
echo "RESULT 1: <br":


echo "<br> result 2: " . $result;
*/






?>