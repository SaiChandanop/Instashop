<?
require_once('./lib/Postmaster.php');

Postmaster::setApiKey("tt_NDY1MDAxOjhfb0dFcXhXS2o2bVFtODhHeGkwb2JQQzZBVQ");


$validationResult = Postmaster_AddressValidation::validate(array(
  "company" => "Alchemy50",
  "contact" => "Josh Klobe",
  "line1" => "20 Jay St #934",
  "city" => "Brooklynasdf",
  "state" => "AA",
  "zip_code" => "11201",
  "country" => "US",
));

//print_r($validationResult);
echo "<BR>";
echo "<BR>";





$transitTimeResults = Postmaster_TransitTimes::get(array(
    "from_zip" => "78701",
    "to_zip" => "78704",
    "weight" => 1.5,
    "carrier" => "fedex",
));
//print_r($transitTimeResults);



$shipmentResult = Postmaster_Shipment::create(array(
  "to" => array(
    "company" => "Postmaster Inc.",
    "contact" => "Joe Smith",
    "line1" => "701 Brazos St. Suite 1616",
    "city" => "Austin",
    "state" => "TX",
    "zip_code" => "78701",
    "phone_no" => "512-693-4040",
  ),
  "from" => array(
    "company" => "Postmaster Inc.",
    "contact" => "Joe Smith",
    "line1" => "701 Brazos St. Suite 1616",
    "city" => "Austin",
    "state" => "TX",
    "zip_code" => "78701",
    "phone_no" => "512-693-4040",
  ),
  "carrier" => "fedex",
  "service" => "2DAY",
  "package" => array(
    "weight" => 1.5,
    "length" => 10,
    "width" => 6,
    "height" => 8,
  ),
));

print_r($shipmentResult);
//var_dump($shipmentResult);



//var_dump($result);




?>