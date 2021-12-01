# Toit on ESP32 with LCD, sending data to a LAMP server
Toit code for sending BME280 sensor data via HTTP to a LAMP stack.

For a full description of the project, please visit
https://blog.toit.io/a-really-toit-glamp-server-d8edd4897f42

This repository comes with a PHP script (insert.php) for injecting data into the MySQL database.

# Requirements
Install the BME280 Toit driver using
```
toit pkg install github.com/toitware/bme280-driver
```
Install the HTTP package using
```
toit pkg install github.com/toitware/toit-cert-roots
```
Install the LCD driver package (HD44780) using
```
toit pkg install github.com/nilwes/HD44780
```
