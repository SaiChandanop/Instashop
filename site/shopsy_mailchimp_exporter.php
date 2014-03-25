<?

include_once("./db.php");



function printData()
{


$select = "SELECT * FROM mailchimp_emails";

$export = mysql_query ( $select ) or die ( "Sql error : " . mysql_error( ) );

$fields = mysql_num_fields ( $export );

for ( $i = 0; $i < $fields; $i++ )
{
    $header .= mysql_field_name( $export , $i ) . "\t";
}

while( $row = mysql_fetch_row( $export ) )
{
    $line = '';
    foreach( $row as $value )
    {                                            
        if ( ( !isset( $value ) ) || ( $value == "" ) )
        {
            $value = "\t";
        }
        else
        {
            $value = str_replace( '"' , '""' , $value );
            $value = '"' . $value . '"' . "\t";
        }
        $line .= $value;
    }
    $data .= trim( $line ) . "\n";
}
$data = str_replace( "\r" , "" , $data );

if ( $data == "" )
{
    $data = "\n(0) Records Found!\n";                        
}

header("Content-type: application/octet-stream");
header("Content-Disposition: attachment; filename=shopsy_emails.xls");
header("Pragma: no-cache");
header("Expires: 0");
print "$header\n$data";

}


//echo "post: ". $_POST["pwd"];

if (strcmp($_POST["pwd"], "Instashop22") == 0)
	printData();
else

{

?>

<html>
<body>

<form action="shopsy_mailchimp_exporter.php" method="post">
pwd: <input type="text" name="pwd"><br>
<input type="submit">
</form>

</body>
</html>

<? } ?>