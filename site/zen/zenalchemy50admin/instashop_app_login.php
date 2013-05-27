<?php


/**
 * @package admin
 * @copyright Copyright 2003-2011 Zen Cart Development Team
 * @copyright Portions Copyright 2003 osCommerce
 * @license http://www.zen-cart.com/license/2_0.txt GNU Public License V2.0
 * @version $Id: login.php 19296 2011-07-28 18:33:38Z wilt $
 */
define('ADMIN_SWITCH_SEND_LOGIN_FAILURE_EMAILS', 'Yes'); // Can be set to 'No' if you don't want warning/courtesy emails to be sent after several login failures have occurred

// PCI-DSS / PA-DSS requirements for lockouts and intervals:
define('ADMIN_LOGIN_LOCKOUT_TIMER', (30 * 60));
define('ADMIN_PASSWORD_EXPIRES_INTERVAL', strtotime('- 90 day'));

//////////
require ('includes/application_top.php');
echo "test1";

$admin_name = $admin_pass = $message = "";
$errors = array();
$error = $expired = false;



if (isset($_POST['action']) && $_POST['action'] != '')
{

  if ($_POST['action'] == 'do' . $_SESSION['securityToken'])
  {
echo "\ntest1!";
    $admin_name = zen_db_prepare_input($_POST['admin_name']);
echo "\ntest2";
    $admin_pass = zen_db_prepare_input($_POST['admin_pass']);
    if ($admin_name == '' && $admin_pass == '')
    {
      sleep(4);
      $error = true;
      $message = ERROR_WRONG_LOGIN;
    } else
    {
      list($error, $expired, $message, $redirect) = zen_validate_user_login($admin_name, $admin_pass);
      if ($redirect != '') zen_redirect($redirect);
    }
  } elseif ($_POST['action'] == 'rs' . $_SESSION['securityToken'])
  {
    $expired = true;
    $admin_name = zen_db_prepare_input($_POST['admin_name-' . $_SESSION['securityToken']]);
    $adm_old_pwd = zen_db_prepare_input($_POST['oldpwd-' . $_SESSION['securityToken']]);
    $adm_new_pwd = zen_db_prepare_input($_POST['newpwd-' . $_SESSION['securityToken']]);
    $adm_conf_pwd = zen_db_prepare_input($_POST['confpwd-' . $_SESSION['securityToken']]);

    $errors = zen_validate_pwd_reset_request($admin_name, $adm_old_pwd, $adm_new_pwd, $adm_conf_pwd);
    if (sizeof($errors) > 0)
    {
      $error = TRUE;
      foreach ($errors as $text)
      {
        $message .= '<br />' . $text;
      }
    } else
    {
      $message = SUCCESS_PASSWORD_UPDATED;
      list($error, $expired, $message, $redirect) = zen_validate_user_login($admin_name, $adm_new_pwd);
      if ($redirect != '') zen_redirect($redirect);
      zen_redirect(zen_href_link(FILENAME_DEFAULT, '', 'SSL'));
    }
    if ($error) sleep(3);
  }
}
if ($expired && $message == '') $message = sprintf(ERROR_PASSWORD_EXPIRED . ' ' . ERROR_PASSWORD_RULES, ((int)ADMIN_PASSWORD_MIN_LENGTH < 7 ? 7 : (int)ADMIN_PASSWORD_MIN_LENGTH));
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" <?php echo HTML_PARAMS; ?>>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<?php echo CHARSET; ?>">
<title><?php echo TITLE; ?></title>
<link href="includes/stylesheet.css" rel="stylesheet" type="text/css" />
<meta name="robot" content="noindex, nofollow" />
<script language="javascript" type="text/javascript"><!--
function animate(f)
{
  var button = document.getElementById("btn_submit");
  var img = document.getElementById("actionImg");
  button.style.cursor="wait";
  button.disabled = true;
  button.className = 'hiddenField';
  img.className = '';
  return true;
}
//--></script>
</head>

</html>
<?php require('includes/application_bottom.php'); ?>
