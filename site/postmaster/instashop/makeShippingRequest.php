<?
require_once('../lib/Postmaster.php');
Postmaster::setApiKey("tt_NDY1MDAxOjhfb0dFcXhXS2o2bVFtODhHeGkwb2JQQzZBVQ");



$handle = fopen("php://input", "rb");
$http_raw_post_data = '';
while (!feof($handle)) {
    $http_raw_post_data .= fread($handle, 8192);
}
fclose($handle);

// do what you want with it
//
// For diagnostic purposes, I'm just going to decode, make sure I got an array, 
// and respond with JSON that includes status, code, and the original request

$post_data = json_decode($http_raw_post_data,true);


//$post_data["seller_instagram_id"];
//$post_data["buyer_instagram_id"];
//    [15] => charge


$fromArray =  array();
$fromArray["company"] = "test_seller_company";
$fromArray["contact"] = $post_data["seller_name"];
$fromArray["line1"] = "20 Jay St Ste 934";//$post_data["seller_address"];
$fromArray["city"] = $post_data["seller_city"];
$fromArray["state"] = $post_data["seller_state"];
$fromArray["zip_code"] = $post_data["seller_zip"];
//$fromArray["phone_no"] = $post_data["seller_phone"];
$fromArray["phone_no"] = "212-221-1212";



$toArray = array();
$toArray["company"] = "test buyer company";
$toArray["contact"] = $post_data["buyer_name"];
$toArray["line1"] = "20 Jay St Ste 934";//$post_data["buyer_address"];
$toArray["city"] = $post_data["buyer_city"];
$toArray["state"] = $post_data["buyer_state"];
$toArray["zip_code"] = $post_data["buyer_zip"];
//$toArray["phone_no"] = $post_data["buyer_phone"];
$toArray["phone_no"] = "212-221-1212";




$shipmentArray = array(
  "to" => $toArray, 
  "from" => $fromArray,
  "carrier" => strtolower($post_data["carrier"]),
  "service" => $post_data["service"],

  "package" => array(
    "weight" => $post_data["package_weight"],
    "length" => $post_data["package_length"],
    "width" =>  $post_data["package_width"],
    "height" => $post_data["package_height"],
  ),
);

$result = Postmaster_Shipment::create($shipmentArray);
$shipment_id = $result->id;

$retDict = array();
$retDict["postmaster_shipment_id"] = $result -> id;
$trackingArray = $result -> tracking;
$retDict["tracking_id"] = $trackingArray[0];
$retDict["actual_shipping_cost"] = $result -> cost;

$retDict["buyer_name"] = $result -> to -> contact;
$retDict["buyer_phone_no"] = $result -> to -> phone_no;
$retDict["buyer_line1"] = $result -> to -> line1;
$retDict["buyer_city"] = $result -> to -> city;
$retDict["buyer_state"] = $result -> to -> state;
$retDict["buyer_zip_code"] = $result -> to -> zip_code;
$retDict["buyer_country"] = $result -> to -> country;
$retDict["buyer_company"] = $result -> to -> company;
$retDict["buyer_residential"] = $result -> to -> residential;

$packagesArray = $result -> packages;
$packagesArray = $packagesArray[0];

$retDict["postmaster_label_url"] = $packagesArray -> label_url;         
$json = json_encode($retDict);
echo $json;

?>
