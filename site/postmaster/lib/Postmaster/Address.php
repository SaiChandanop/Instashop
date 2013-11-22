<?php

class Postmaster_Address extends Postmaster_ApiResource
{
}

class Postmaster_AddressValidation extends Postmaster_ApiResource
{
  private static $urlBase = '/v1/validate';

  /*
   * Validate that an address is correct.
   */ 
  public static function validate($params=null)
  {
	echo "1";
    $class = get_class();
    Postmaster_ApiResource::_validateParams($params);
    Postmaster_Util::normalizeAddress($params);
	echo "2";
    $requestor = new Postmaster_ApiRequestor();
	echo "3";
    $response = $requestor->request('post', self::$urlBase, $params);
	echo "4";
    return Postmaster_Object::scopedConstructObject($class, $response);
  }
}

