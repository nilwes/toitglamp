<?php
$servername = "localhost";
$username = "mysqlusername";
$password = "mysqlpassword";
$dbname = "THP-Database";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully<br>";

$temp  = mysqli_real_escape_string($conn, $_GET['Temp']);
$hum   = mysqli_real_escape_string($conn, $_GET['Hum']);
$press = mysqli_real_escape_string($conn, $_GET['Press']);

$sql = mysqli_query($conn, "INSERT INTO THPData (Temp, Hum, Press) VALUES (" . $temp . "," . $hum . "," . $press . ");");

mysqli_close($conn);
?>
