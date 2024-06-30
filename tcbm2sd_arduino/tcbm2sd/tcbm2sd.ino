// IDE: Arduino Mini w/ ATmega328 (3.3.V)
// in case of flashing problem change in Arduino/hardware/arduino/avr/boards.txt
// or home folder: Arduino15\packages\arduino\hardware\avr\1.8.6\boards.txt
// from: mini.menu.cpu.atmega328.upload.speed=115200
//   to: mini.menu.cpu.atmega328.upload.speed=57600

//#include <SD.h>
//#include <SPI.h>

//File aFile;

// SD card setup
const uint8_t PIN_SD_SS = 10;

//////////////////////////////////

// TCBM bus https://www.pagetable.com/?p=1324
// data bus I/O
const uint8_t PIN_D0 = 2;
const uint8_t PIN_D1 = 3;
const uint8_t PIN_D2 = 4;
const uint8_t PIN_D3 = 5;
const uint8_t PIN_D4 = 6;
const uint8_t PIN_D5 = 7;
const uint8_t PIN_D6 = 8;
const uint8_t PIN_D7 = 9;
// inputs
//const uint8_t PIN_DAV = A2;
const uint8_t PIN_DAV = A3; // crossed DAV/ACK
// outputs
const uint8_t PIN_DEV = A4; // XXX can be input from CPLD if 2 devices are emulated at once
//const uint8_t PIN_ACK = A3;
const uint8_t PIN_ACK = A2; // crossed DAV/ACK
const uint8_t PIN_STATUS0 = A0;
const uint8_t PIN_STATUS1 = A1;
// TCBM codes
const uint8_t TCBM_CODE_COMMAND = 0x81; // controller sends command byte (state change: 0x20/0x3f/0x40/0x5f LISTEN/UNLISTEN/TALK/UNTALK)
const uint8_t TCBM_CODE_SECOND  = 0x82; // controller sends command byte (secondary addr: 0x60/0xe0/0xf0 SECOND/CLOSE/OPEN)
const uint8_t TCBM_CODE_RECV    = 0x83; // controller sends data byte
const uint8_t TCBM_CODE_SEND    = 0x84; // controller receives data byte
// STATUSes
const uint8_t TCBM_STATUS_OK=0;
const uint8_t TCBM_STATUS_RECV=1;
const uint8_t TCBM_STATUS_SEND=2;
const uint8_t TCBM_STATUS_EOI=3;

void tcbm_data_input() {
  pinMode(PIN_D0, INPUT);
  pinMode(PIN_D1, INPUT);
  pinMode(PIN_D2, INPUT);
  pinMode(PIN_D3, INPUT);
  pinMode(PIN_D4, INPUT);
  pinMode(PIN_D5, INPUT);
  pinMode(PIN_D6, INPUT);
  pinMode(PIN_D7, INPUT);
}

void tcbm_data_output() {
  pinMode(PIN_D0, OUTPUT);
  pinMode(PIN_D1, OUTPUT);
  pinMode(PIN_D2, OUTPUT);
  pinMode(PIN_D3, OUTPUT);
  pinMode(PIN_D4, OUTPUT);
  pinMode(PIN_D5, OUTPUT);
  pinMode(PIN_D6, OUTPUT);
  pinMode(PIN_D7, OUTPUT);
}

void tcbm_set_status(uint8_t status) {
  digitalWrite(PIN_STATUS0, status & 0x01);
  digitalWrite(PIN_STATUS1, status & 0x02);
}

void tcbm_set_ack(uint8_t ack) {
  digitalWrite(PIN_ACK, ack);
}

uint8_t tcbm_get_dav(void) {
  return digitalRead(PIN_DAV);
}

uint8_t tcbm_data_read(void) {
  return (
      (digitalRead(PIN_D0) ? 1 : 0)      |
      (digitalRead(PIN_D1) ? 1 : 0) << 1 |
      (digitalRead(PIN_D2) ? 1 : 0) << 2 |
      (digitalRead(PIN_D3) ? 1 : 0) << 3 |
      (digitalRead(PIN_D4) ? 1 : 0) << 4 |
      (digitalRead(PIN_D5) ? 1 : 0) << 5 |
      (digitalRead(PIN_D6) ? 1 : 0) << 6 |
      (digitalRead(PIN_D7) ? 1 : 0) << 7
  );
}

void tcbm_data_write(uint8_t d) {
    digitalWrite(PIN_D0, d & 0x01 ? 1 : 0);
    digitalWrite(PIN_D1, d & 0x02 ? 1 : 0);
    digitalWrite(PIN_D2, d & 0x04 ? 1 : 0);
    digitalWrite(PIN_D3, d & 0x08 ? 1 : 0);
    digitalWrite(PIN_D4, d & 0x10 ? 1 : 0);
    digitalWrite(PIN_D5, d & 0x20 ? 1 : 0);
    digitalWrite(PIN_D6, d & 0x40 ? 1 : 0);
    digitalWrite(PIN_D7, d & 0x80 ? 1 : 0);
}

void tcbm_reset_bus() {
  tcbm_data_input();
  tcbm_set_status(TCBM_STATUS_OK);
  tcbm_set_ack(1); // not ready
}

void tcbm_init() {
  // data valid
  pinMode(PIN_DAV, INPUT_PULLUP);
  // outputs
  pinMode(PIN_ACK, OUTPUT);
  pinMode(PIN_STATUS0, OUTPUT);
  pinMode(PIN_STATUS1, OUTPUT);

  // device number selection
  pinMode(PIN_DEV, OUTPUT);
  digitalWrite(PIN_DEV, 1); // we are device 8

  // reset bus status and data direction
  tcbm_reset_bus();
}

uint16_t tcbm_read_byte() { // hibyte = command, lobyte = data
  uint8_t cmd, data;
  uint16_t result;
  Serial.println("waiting for DAV=1"); // this wait or the other wait is not necessary
  while (!(tcbm_get_dav() == 1));
  Serial.println("waiting for byte with 7 bit set");
  do {
    cmd = tcbm_data_read();
  } while (!(cmd & 0x80));
  Serial.print("...got 0x");
  Serial.println(cmd, HEX);
  tcbm_set_ack(0);
  Serial.println("ACK=0, waiting for DAV=0");
  while (!(tcbm_get_dav() == 0));
  data = tcbm_data_read();
  Serial.print("...got 0x");
  Serial.println(data, HEX);
  tcbm_set_status(TCBM_STATUS_SEND);
  tcbm_set_ack(1);
  Serial.println("set status=%10 and ACK=1");
  Serial.println("waiting for DAV=1");
  while (!(tcbm_get_dav() == 1));
  tcbm_set_status(TCBM_STATUS_OK);
  Serial.println("set status=%00");
  //
  result = (cmd << 8) | data;
  Serial.print("result=0x");
  Serial.println(result,HEX);
  return result; 
}

//////////////////////////////////

void setup() {
  Serial.begin(115200);
  Serial.println("initializing I/O");
  tcbm_init();
  Serial.print("initializing SD card...");
//  pinMode(PIN_SD_SS, OUTPUT);
//  if (!SD.begin(PIN_SD_SS)) { // CS pin
//    Serial.println("init failed!");
//    return;
//  }
  Serial.println("done");
  Serial.println("tcbm2sd ready");
}

void loop() {
  tcbm_read_byte();
}
