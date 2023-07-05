<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$prid = $_POST['prid'];
$prname = $_POST['prname'];
$prdesc = addslashes($_POST['prdesc']);
$prprice = $_POST['prprice'];
$prdel = $_POST['prdel'];
$prqty = $_POST['prqty'];


$sqlupdate = "UPDATE `tbl_product` SET `prname`='$prname',`prdel`='$prdel',`prdesc`='$prdesc',`prprice`='$prprice',`prqty`='$prqty' WHERE `prid` = '$prid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>