// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

// Import libraries for HTTP.
import net
import http
// Import libraries for BME280 sensor and GPIO.
import gpio
import i2c
import bme280 as drivers
// Import libraries for LCD
import hd44780 as display

RSpin := gpio.Pin.out 13
ENpin := gpio.Pin.out 12
D4pin := gpio.Pin.out 18
D5pin := gpio.Pin.out 17
D6pin := gpio.Pin.out 16
D7pin := gpio.Pin.out 15

sda := 21 // I2C pins
scl := 22

// URL and port to your LAMP server
host := "url.toyourlampserver.here"
port := 80

main:
  display.lcd_init RSpin ENpin D4pin D5pin D6pin D7pin 

  bus := i2c.Bus
    --sda=gpio.Pin.out sda
    --scl=gpio.Pin.out scl
  device := bus.device drivers.I2C_ADDRESS_ALT //Alternate address 0x77
  bme := drivers.Driver device

  temp := bme.read_temperature
  hum  := bme.read_humidity
  pres := bme.read_pressure
  print "Temperature:$(%.1f temp) °C,  Humidity:$(%.1f hum) %, Pressure: $(%.1f pres) Pa"

  print_to_lcd temp hum pres
  send_to_server temp hum pres

print_to_lcd temp hum pres:
  time := Time.now.local
  text := display.translate_to_rom_a_00 "T:$(%.1f temp)°C" // Need translate_to_rom to get the degree sign.
  display.lcd_write text 0 0
  display.lcd_write "H:$(hum.to_int)%" 0 11
  display.lcd_write "P:$(pres.to_int/100) hPa  $(%02d time.h):$(%02d time.m)" 1 0
  

send_to_server temp hum pres:
  network_interface := net.open
  socket := network_interface.tcp_connect host port
  connection := http.Connection socket host
  parameters := "Temp=$(%.1f temp)&Hum=$(%.1f hum)&Press=$(%.1f pres)"  // HTTP parameters.
  request := connection.new_request "GET" "/insert.php?$parameters"  // Create an HTTP request.
  request.send
  print "Submitted URL ---> http://$host:$port/insert.php?$parameters"
