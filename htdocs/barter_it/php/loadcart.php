<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['pridowner'])){
	$pridowner = $_POST['pridowner'];	
	$sqlcart = "SELECT * FROM `tbl_cart` INNER JOIN `tbl_product` ON tbl_cart.prid = tbl_product.prid WHERE tbl_cart.pridowner = '$pridowner'";
}

$result = $conn->query($sqlcart);
if ($result->num_rows > 0) {
    $cartitems["carts"] = array();
	while ($row = $result->fetch_assoc()) {
        $cartlist = array();
        $cartlist['cartid'] = $row['cartid'];
        $cartlist['prid'] = $row['prid'];
        $cartlist['prname'] = $row['prname'];
        $cartlist['prdesc'] = $row['prdesc'];
        $cartlist['prqty'] = $row['prqty'];
        $cartlist['prprice'] = $row['prprice'];
        $cartlist['cartqty'] = $row['cartqty'];
        $cartlist['cartprice'] = $row['cartprice'];
        $cartlist['pridowner'] = $row['pridowner'];
        $cartlist['sellerid'] = $row['sellerid'];
        $cartlist['cartdate'] = $row['cartdate'];
        array_push($cartitems["carts"] ,$cartlist);
    }
    $response = array('status' => 'success', 'data' => $cartitems);
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