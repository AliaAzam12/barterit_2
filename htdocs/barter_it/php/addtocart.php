<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$prid = $_POST['prid'];
$cartqty = $_POST['cartqty'];
$cartprice = $_POST['cartprice'];
$pridowner = $_POST['pridowner'];
$sellerid = $_POST['sellerid'];

$checkcatchid = "SELECT * FROM `tbl_cart` WHERE `pridowner` = '$pridowner' AND  `prid` = '$prid'";
$resultqty = $conn->query($checkcatchid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_cart` SET `cartqty`= (cartqty + $cartqty),`cartprice`= (cartprice + $cartprice) WHERE `pridowner` = '$pridowner' AND  `prid` = '$prid'";
}else{
	$sql = "INSERT INTO `tbl_cart`(`prid`, `cartqty`, `cartprice`, `pridowner`, `sellerid`) VALUES ('$prid','$cartqty','$cartprice','$pridowner','$sellerid')";
}

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>