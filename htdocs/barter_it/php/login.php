<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];


$sqllogin = "SELECT * FROM `tbl_user` WHERE `user_email` = '$email' AND `user_pass` = '$password'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
	while ($row = $result->fetch_assoc()) {
		$userarray = array();
		$userarray['id'] = $row['userid'];
		$userarray['email'] = $row['user_email'];
		$userarray['name'] = $row['user_name'];
		$userarray['password'] = $row['user_pass'];
		$userarray['phone'] = $row['user_phone'];
		$userarray['datereg'] = $row['user_datereg'];
		
		$response = array('status' => 'success', 'data' => $userarray);
		sendJsonResponse($response);
	}
}else{
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
$conn->close();


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>