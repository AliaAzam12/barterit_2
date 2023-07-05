<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 10;
if(isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['cartuserid'])){
	$cartuserid = $_POST['cartuserid'];
}else{
	$cartuserid = '0';
}

if(isset($_POST['userid'])){
	$userid = $_POST['userid'];
	$sqlloadproduct = "SELECT * FROM `tbl_product` WHERE `pridowner` = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloadproduct = "SELECT * FROM `tbl_product` WHERE `prname` LIKE '%$search%'";
}else{
	$sqlloadproduct = "SELECT * FROM `tbl_product`";
}

$result = $conn->query($sqlloadproduct);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0) {
    $products["products"] = array();
while ($row = $result->fetch_assoc()) {
        $prlist = array();
        $prlist['prid'] = $row['prid'];
        $prlist['prname'] = $row['prname'];
        $prlist['prdesc'] = $row['prdesc'];
        $prlist['prprice'] = $row['prprice'];
        $prlist['prqty'] = $row['prqty'];
        $prlist['prdel'] = $row['prdel'];
        $prlist['prstate'] = $row['prstate'];
        $prlist['prloc'] = $row['prloc'];
        $prlist['prlat'] = $row['prlat'];
        $prlist['prlong'] = $row['prlong'];
        $prlist['prdate'] = $row['prdate'];
        array_push($products["products"],$prlist);
    }
    $response = array('status' => 'success', 'data' => $products, 'noPage' => "$number_of_page", 'noResult' => "$number_of_result");
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