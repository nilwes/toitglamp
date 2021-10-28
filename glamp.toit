// Copyright (C) 2021 Toitware ApS. All rights reserved.

// Import libraries for HTTP.
import net
import http
// Import libraries for BME280 sensor and GPIO.
import gpio
import i2c
import bme280 as drivers
// Import libraries for LCD
import .src.HD44780

RSpin := gpio.Pin.out 13
ENpin := gpio.Pin.out 12
D4pin := gpio.Pin.out 18
D5pin := gpio.Pin.out 17
D6pin := gpio.Pin.out 16
D7pin := gpio.Pin.out 15

sda := 21
scl := 22
cursor := 0
blink  := 0

main:
  LCDinit "16x2" RSpin ENpin D4pin D5pin D6pin D7pin cursor blink

  bus := i2c.Bus
    --sda=gpio.Pin.out sda
    --scl=gpio.Pin.out scl
  device := bus.device drivers.I2C_ADDRESS_ALT //Alternate address 0x77
  bme := drivers.Driver device

  temp := bme.read_temperature
  hum  := bme.read_humidity
  pres := bme.read_pressure
  print "Temperature:$(%.1f temp) °C,  Humidity:$(%.1f hum) %, Pressure: $(%.1f pres) Pa"
  LCDwrite "T:$(%.1f temp)  |  H:$(hum.to_int)%" 0 0
  LCDwrite "P:$(pres.to_int/100) hPa" 1 3
  send_to_server temp hum pres


send_to_server temp hum pres:
  network_interface := net.open
  host := "ipadress.toyour.lampserver"
  socket := network_interface.tcp_connect host 80
  connection := http.Connection socket host
  parameters := "Temp=$(%.1f temp)&Hum=$(%.1f hum)&Press=$(%.1f pres)"  // HTTP parameters.
  request := connection.new_request "GET" "/insert.php?$parameters"  // Create an HTTP request.
  request.send
  print "Submitted URL ---> http://$host:80/insert.php?$parameters"
