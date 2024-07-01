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
const uint8_t TCBM_STATUS_OK=0; // OK, also idle state when waiting for command byte
const uint8_t TCBM_STATUS_RECV=1; // controller was trying to receive a byte from the device, but the device did not have any data (also FILE NOT FOUND)
const uint8_t TCBM_STATUS_SEND=2; // controller was trying to send a byte to the device, but the device decided not to accept it
const uint8_t TCBM_STATUS_EOI=3; // byte currently received by the controller is the last byte of the stream

//////////

// 10 REM MACIEJ
const uint8_t demo[] = { 0x01, 0x10, 0x0e, 0x10, 0x0a, 0x00, 0x8f, 0x20, 0x4d, 0x41, 0x43, 0x49, 0x45, 0x4a, 0x0, 0x0, 0x0 };
uint16_t dpoint = 0;
const uint8_t dmax = sizeof(demo);

//////////

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
  uint8_t tmp, cmd, data;
  uint16_t result = 0;
  if (tcbm_get_dav() != 1) return 0; // controller ready?
  tmp = tcbm_data_read();
  cmd = tcbm_data_read();
  if (tmp != cmd) return 0; // stable?
  if (!(cmd & 0x80)) return 0; // command?
  /*
  Serial.println(F("waiting for DAV=1")); // this wait or the other wait is not necessary
  while (!(tcbm_get_dav() == 1));
  Serial.println(F("waiting for byte with 7 bit set"));
  do {
    tmp = tcbm_data_read();
    cmd = tcbm_data_read();
  } while (!( (cmd & 0x80) && (cmd==tmp) ));
  */
  //Serial.print(F("...got 0x")); Serial.println(cmd, HEX);
  tcbm_set_ack(0);
  //Serial.println(F("ACK=0, waiting for DAV=0"));
  while (!(tcbm_get_dav() == 0));
  data = tcbm_data_read();
  //Serial.print(F("...got 0x")); Serial.println(data, HEX);
  if (cmd == 0x84) {
    tcbm_set_status(TCBM_STATUS_EOI); // don't know how to send bytes yet, STATUS_RECV here may give load 'file not found'?
  } else {
    tcbm_set_status(TCBM_STATUS_OK);
  }
  tcbm_set_ack(1);
  //Serial.println(F("set status=%10 and ACK=1"));
  //Serial.println(F("waiting for DAV=1"));
  while (!(tcbm_get_dav() == 1));
  tcbm_set_status(TCBM_STATUS_OK);
  //Serial.println(F("set status=%00"));
  //
  result = (cmd << 8) | data;
  Serial.print(F("result=0x")); Serial.println(result,HEX);
  return result; 
}

//////////////////////////////////

void setup() {
  Serial.begin(115200);
  Serial.println(F("initializing I/O"));
  tcbm_init();
  Serial.print(F("initializing SD card..."));
//  pinMode(PIN_SD_SS, OUTPUT);
//  if (!SD.begin(PIN_SD_SS)) { // CS pin
//    Serial.println(F("init failed!"));
//    return;
//  }
  Serial.println(F("done"));
  Serial.println(F("tcbm2sd ready"));
}

void loop() {
  char cmd;
  uint8_t tmp;
  if (Serial.available() > 0) {
    cmd = Serial.read();
    switch (cmd) {
      case '0':
          tcbm_set_status(TCBM_STATUS_OK);
          Serial.println(F("status=00"));
          break;
      case '1':
          tcbm_set_status(TCBM_STATUS_RECV);
          Serial.println(F("status=01"));
          break;
      case '2':
          tcbm_set_status(TCBM_STATUS_SEND);
          Serial.println(F("status=10"));
          break;
      case '3':
          tcbm_set_status(TCBM_STATUS_EOI);
          Serial.println(F("status=11"));
          break;
      case 'i':
          tcbm_data_input();
          Serial.println(F("port input: "));
          tmp = tcbm_data_read();
          Serial.print(tmp, HEX);
          break;
      case 'o':
          tcbm_data_output();
          Serial.println(F("port output"));
          break;
      case 'z':
          tcbm_data_write(0);
          Serial.println(F("port=0x00"));
          break;
      case 'f':
          tcbm_data_write(255);
          Serial.println(F("port=0xff"));
          break;
      case 'a':
          tcbm_data_write(0xaa);
          Serial.println(F("port=0xaa"));
          break;
      case '5':
          tcbm_data_write(0x55);
          Serial.println(F("port=0x55"));
          break;
      case 'r':
          tcbm_reset_bus();
          Serial.println(F("reset bus"));
          break;
      default:
          Serial.println(F("unknown command, use: 0/1/2/3 i/o z/f/a/5 r"));
          break;
    }
  }
  tcbm_read_byte();
}
