// IDE: Arduino Mini w/ ATmega328 (3.3.V)
// in case of flashing problem change in Arduino/hardware/arduino/avr/boards.txt
// or home folder: Arduino15\packages\arduino\hardware\avr\1.8.6\boards.txt
// from: mini.menu.cpu.atmega328.upload.speed=115200
//   to: mini.menu.cpu.atmega328.upload.speed=57600

//#define WITH_SD
#define UNUSED_CODE

#ifdef WITH_SD
#include <SD.h>
#include <SPI.h>

File aFile;

// SD card setup
const uint8_t PIN_SD_SS = 10;
#endif

//////////////////////////////////

// TCBM bus https://www.pagetable.com/?p=1324
// data bus I/O
const uint8_t PIN_D0 = 2; // PD2
const uint8_t PIN_D1 = 3; // PD3
const uint8_t PIN_D2 = 4; // PD4
const uint8_t PIN_D3 = 5; // PD5
const uint8_t PIN_D4 = 6; // PD6
const uint8_t PIN_D5 = 7; // PD7
const uint8_t PIN_D6 = 8; // PB0
const uint8_t PIN_D7 = 9; // PB1
// inputs
//const uint8_t PIN_DAV = A2; // PC2
const uint8_t PIN_DAV = A3; // PC3 // crossed DAV/ACK
// outputs
const uint8_t PIN_DEV = A4; // PC4 // XXX can be input from CPLD if 2 devices are emulated at once
//const uint8_t PIN_ACK = A3;
const uint8_t PIN_ACK = A2; // PC2 // crossed DAV/ACK
const uint8_t PIN_STATUS0 = A0; // PC0
const uint8_t PIN_STATUS1 = A1; // PC1
// TCBM codes
const uint8_t TCBM_CODE_COMMAND = 0x81; // controller sends command byte (state change: 0x20/0x3f/0x40/0x5f LISTEN/UNLISTEN/TALK/UNTALK)
const uint8_t TCBM_CODE_SECOND  = 0x82; // controller sends command byte (secondary addr: 0x60/0xe0/0xf0 SECOND/CLOSE/OPEN)
const uint8_t TCBM_CODE_RECV    = 0x83; // controller sends data byte
const uint8_t TCBM_CODE_SEND    = 0x84; // controller receives data byte
// STATUSes
const uint8_t TCBM_STATUS_OK	= 0; // OK, also idle state when waiting for command byte
const uint8_t TCBM_STATUS_RECV	= 1; // controller was trying to receive a byte from the device, but the device did not have any data (also FILE NOT FOUND)
const uint8_t TCBM_STATUS_SEND	= 2; // controller was trying to send a byte to the device, but the device decided not to accept it
const uint8_t TCBM_STATUS_EOI	= 3; // byte currently received by the controller is the last byte of the stream

//////////

// 10 REM MACIEJ
const uint8_t demo[] = { 0x01, 0x10, 0x0e, 0x10, 0x0a, 0x00, 0x8f, 0x20, 0x4d, 0x41, 0x43, 0x49, 0x45, 0x4a, 0x0, 0x0, 0x0 };
uint16_t dpoint = 0;
const uint8_t dmax = sizeof(demo);

//////////

void tcbm_port_input() {
  pinMode(PIN_D0, INPUT);
  pinMode(PIN_D1, INPUT);
  pinMode(PIN_D2, INPUT);
  pinMode(PIN_D3, INPUT);
  pinMode(PIN_D4, INPUT);
  pinMode(PIN_D5, INPUT);
  pinMode(PIN_D6, INPUT);
  pinMode(PIN_D7, INPUT);
}

void tcbm_port_output() {
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

uint8_t tcbm_port_read(void) {
  return (PIND >> 2) | ((PINB & 0x03) << 6);
  /*
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
  */
}

void tcbm_port_write(uint8_t d) { // XX speed it up
    digitalWrite(PIN_D0, d & 0x01 ? 1 : 0);
    digitalWrite(PIN_D1, d & 0x02 ? 1 : 0);
    digitalWrite(PIN_D2, d & 0x04 ? 1 : 0);
    digitalWrite(PIN_D3, d & 0x08 ? 1 : 0);
    digitalWrite(PIN_D4, d & 0x10 ? 1 : 0);
    digitalWrite(PIN_D5, d & 0x20 ? 1 : 0);
    digitalWrite(PIN_D6, d & 0x40 ? 1 : 0);
    digitalWrite(PIN_D7, d & 0x80 ? 1 : 0);
//	PORTD = ( PORTD & 0x03 ) | ((d & 0x3F) << 2);
//	PORTB = ( PORTB & 0xFC ) | ((d & 0xC0) >> 6);
}

void tcbm_reset_bus() {
  tcbm_port_input();
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

uint8_t tcbm_read_cmd() { // read command byte - 0 or $81/82/83/84
  uint8_t tmp, cmd;
//  Serial.println(F("read_cmd, dav=")); Serial.println(tcbm_get_dav());
  if (tcbm_get_dav() != 1) return 0; // controller ready?
  tmp = tcbm_port_read();
  cmd = tcbm_port_read();
//  Serial.print(F("tmp,cmd=")); Serial.println((uint16_t)(tmp << 8 | cmd),HEX);
  if (tmp != cmd) return 0; // stable?
  if (!(cmd & 0x80)) return 0; // command?
//  Serial.println(F("set ACK=0"));
  tcbm_set_ack(0);
  return cmd;
}

uint8_t tcbm_read_cmd_block() { // block until read command byte - 0 or $81/82/83/84
  uint8_t tmp=0, cmd=1;
///  Serial.println(F("wait for DAV=1"));
  while (!(tcbm_get_dav() == 1));
  while (!(cmd & 0x80)) {
    tmp=0; cmd=1;
    while (tmp!=cmd) {
     tmp = tcbm_port_read();
     cmd = tcbm_port_read();
//    Serial.print(F("tmp,cmd=")); Serial.println((uint16_t)(tmp << 8 | cmd), HEX);
    }
  }
///  Serial.print(F("CMCMD=")); Serial.println((uint16_t)(tmp << 8 | cmd), HEX);
///  Serial.println(F("set ACK=0"));
  tcbm_set_ack(0);
  return cmd;
}

uint8_t tcbm_read_data(uint8_t status) { // read data following command byte, with preset status
  uint8_t data;
//  Serial.println(F("ACK=0 waiting for DAV=0"));
  while (!(tcbm_get_dav() == 0));
  data = tcbm_port_read();
  tcbm_set_status(status);
  tcbm_set_ack(1);
//  Serial.println(F("ACK=1 waiting for DAV=1"));
  while (!(tcbm_get_dav() == 1));
  tcbm_set_status(TCBM_STATUS_OK);
  return data;
}

void tcbm_write_data(uint8_t data, uint8_t status) { // write data following TCBM_CODE_SEND command, with preset status
//  Serial.println(F("ACK=0 waiting for DAV=0"));
  while (!(tcbm_get_dav() == 0));
  tcbm_port_output();
  tcbm_port_write(data);
  tcbm_set_status(status);
  tcbm_set_ack(1);
//  Serial.println(F("data+status out, ACK=1 waiting for DAV=1"));
  while (!(tcbm_get_dav() == 1));
  tcbm_port_input();
  tcbm_set_status(TCBM_STATUS_OK);
  tcbm_set_ack(0);
//  Serial.println(F("ACK=0 waiting for DAV=0"));
  while (!(tcbm_get_dav() == 0));
  tcbm_set_ack(1);
//  Serial.println(F("ACK=1 waiting for DAV=1"));
  while (!(tcbm_get_dav() == 1));
}

#ifdef UNUSED_CODE
uint16_t tcbm_read_byte() { // hibyte = command, lobyte = data
  uint8_t tmp, cmd, data;
  uint16_t result = 0;
  if (tcbm_get_dav() != 1) return 0; // controller ready?
  tmp = tcbm_port_read();
  cmd = tcbm_port_read();
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
  data = tcbm_port_read();
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
#endif

//////////////////////////////////

// state machine

const uint8_t STATE_IDLE = 0; // wait for LISTEN command
const uint8_t STATE_OPEN = 1; // after LISTEN, receiving filename or command on #15
const uint8_t STATE_LOAD = 2; // after OPEN on channek 0, after TALK
const uint8_t STATE_SAVE = 3; // after OPEN on channel 1, after LISTEN+SECOND
const uint8_t STATE_STAT = 4; // like STATE_LOAD but write from output_buf

uint8_t channel = 0; // opened channel: 0=load, 1=save, 15=command, anything else is not supported
uint8_t state = STATE_IDLE;
bool file_opened = false;

uint8_t input_buf_ptr = 0; // pointer to within input buffer
uint8_t input_buf[64]; // input buffer - filename + commands
uint8_t output_buf[64]; // output buffer, render status here

void state_init() {
	input_buf_ptr = 0;
	memset(input_buf, 0, sizeof(input_buf));
	memset(output_buf, 0, sizeof(output_buf));
//	strcpy(output_buf, (const char*)"00, OK, 00, 00");
  strcpy(output_buf, (const char*)"73, TCBM2SD 2024, 00, 00");
	file_opened = false;
}

void state_idle() {
	//
	uint8_t cmd = tcbm_read_cmd();
  if (cmd==0) return;
	uint8_t dat = tcbm_read_data(TCBM_STATUS_OK);
	uint8_t chn = 0; // channel
//  Serial.println((uint16_t)(cmd << 8 | dat), HEX);
	if (cmd != TCBM_CODE_COMMAND) return;
	if (dat == 0x20) { // LISTEN
		cmd = tcbm_read_cmd_block();
		dat = tcbm_read_data(TCBM_STATUS_OK);
		Serial.print(F("[LISTEN]:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
		if (cmd != TCBM_CODE_SECOND) return;
		chn = dat & 0x0F;
		switch (dat & 0xF0) {
			case 0xF0:	// OPEN
				Serial.print(F("open chn="));
				Serial.println(chn);
				channel = chn;
				state = STATE_OPEN; // filename or command incoming, until UNLISTEN
				break;
			case 0xE0:	// CLOSE
				Serial.print(F("close chn="));
				Serial.println(chn);
				if (channel == 15) {
					Serial.println(F("handle command from input buf"));
					// handle command from input buffer: S:, R:, CD<-, CD<name>, CD:<name>, CD//
				}
				state_init();
				break;
			case 0x60:	// SECOND
				Serial.print(F("second chn="));
				Serial.println(chn);
				channel = chn;
				switch (channel) {
					case 1:
						state = STATE_SAVE; // receive data stream to be saved, until UNLISTEN
						break;
					case 15:
						state = STATE_OPEN; // keep recieving data into input buffer
						break;
					default:
						Serial.println(F("unk SECOND"));
						state_init();
						break;
				}
				break;
			default:
				state_init();
				Serial.println(F("unk state after LISTEN"));
				return;
		}
	}
	if (dat == 0x40) { // TALK
		cmd = tcbm_read_cmd_block();
		dat = tcbm_read_data(TCBM_STATUS_OK);	// XXX status for file not found set here?
		Serial.print(F("[TALK]:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
		if (cmd != TCBM_CODE_SECOND) return;
		chn = dat & 0x0F;
		switch (dat & 0xF0) {
			case 0x60: // SECOND
				Serial.print(F("second chn="));
				Serial.println(chn);
				channel = chn;
				switch (channel) {
					case 0:
						if (file_opened) {
							state = STATE_LOAD; // send data stream from opened file, set TCBM_STATUS_EOI or TCBM_STATUS_SEND when end of file, keep sending data until UNTALK
						} else {
							Serial.println(F("file not open"));
							state_init();
						}
						break;
					case 15:
						Serial.println(F("status request, write from outputbuf"));
						state = STATE_STAT;
						break;
					default:
						Serial.println(F("unk state after OPEN"));
						state_init();
						break;
				}
				break;
			default:
				Serial.println(F("unk state after TALK"));
				return;
		}
	}
}

void state_load() {
	// send data until UNTALK
	uint8_t cmd;
	uint8_t dat;
	uint8_t status = TCBM_STATUS_OK; // NOT ok if file not found!
  uint8_t b;
	bool done = false;
	Serial.print(F("[LOAD] on channel=")); Serial.println(channel, HEX);
  if (input_buf[2]=='0') {
    Serial.println(F("filenotfound"));
    status = TCBM_STATUS_SEND; // XXX SEND works - FILE not found but gets state machine out of sync; RECV, EOI don't work - there is still SEARCHING+LOADING, should be moved to TALK?
  }
	while (!done) {
		cmd = tcbm_read_cmd_block();
		switch (cmd) {
			case TCBM_CODE_SEND:
//        Serial.print(F("new character from ")); Serial.println(dpoint, HEX);
        b = demo[dpoint];
				dpoint++;
				if (dpoint == dmax) {
					dpoint--;
          status = TCBM_STATUS_EOI; // status must be set with last valid byte, STATUS_RECV/SEND won't work here - will not stop; but we get LOAD ERROR
				}
        tcbm_write_data(b, status);
				break;
			case TCBM_CODE_COMMAND:
				dat = tcbm_read_data(status);
				if (dat == 0x5F) { // UNTALK
					Serial.println(F("[UNTALK]"));
				} else {
					Serial.print(F("unk LOAD CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				}
				done = true;
				break;
			default:
				dat = tcbm_read_data(status);
				Serial.print(F("unk LOAD state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				done = true;
				break;
		}
	}
	state = STATE_IDLE;
}

void state_status() { // pretty much the same as state_load but on channel 15 we write from output_buf
	// send data until UNTALK
	uint8_t cmd;
	uint8_t dat;
	uint8_t status = TCBM_STATUS_OK;
  uint8_t b;
	uint8_t c = 0;
	bool done = false;
	Serial.print(F("[DS] on channel=")); Serial.println(channel, HEX);
	while (!done) {
		cmd = tcbm_read_cmd_block();
		switch (cmd) {
			case TCBM_CODE_SEND:
 //       Serial.print(F("new character from ")); Serial.println(c, HEX);
        b = output_buf[c];
				c++;
				if (output_buf[c]==0 || c==sizeof(output_buf)) {
					c--;
					status = TCBM_STATUS_EOI; // status must be set with last valid byte
				}
        tcbm_write_data(b, status);
				break;
			case TCBM_CODE_COMMAND:
				dat = tcbm_read_data(status);
				if (dat == 0x5F) { // UNTALK
					Serial.println(F("[UNTALK]"));
				} else {
					Serial.print(F("unk DS CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				}
				done = true;
				break;
			default:
				dat = tcbm_read_data(status);
				Serial.print(F("unk DS state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				done = true;
				break;
		}
	}
	state = STATE_IDLE;
}

void state_save() {
	// receive data until UNLISTEN
	uint8_t cmd;
	uint8_t dat;
	uint16_t c = 0;
	bool done = false;
	Serial.print(F("[SAVE] on channel=")); Serial.println(channel, HEX);
	while (!done) {
		cmd = tcbm_read_cmd_block();
		dat = tcbm_read_data(TCBM_STATUS_OK);
		switch (cmd) {
			case TCBM_CODE_RECV:
				// read and ignore data
				c++;
        Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(dat, HEX);
				break;
			case TCBM_CODE_COMMAND:
				if (dat == 0x3F) { // UNLISTEN
					Serial.println(F("[UNLISTEN]"));
				} else {
					Serial.print(F("unk SAVE CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				}
				done = true;
				break;
			default:
				Serial.print(F("unk SAVE state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				done = true;
				break;
		}
	}
	Serial.print(F("saved bytes:")); Serial.println(c, HEX);
	state = STATE_IDLE;
}

void state_open() {
	// after LISTEN+OPEN, receive data into input buffer until UNLISTEN - it's command or file name, after UNLISTEN file is opened
	// XXX for channel 15 it's possible to have LISTEN+SECOND without LISTEN+OPEN with BASIC: OPEN 1,2,15:PRINT#15,"I0" ? 
	uint8_t cmd;
	uint8_t dat;
	bool done = false;
	Serial.print(F("[OPEN] on channel=")); Serial.println(channel, HEX);
	while (!done) {
		cmd = tcbm_read_cmd_block();
//    Serial.println(cmd,HEX);
		dat = tcbm_read_data(TCBM_STATUS_OK);
//    Serial.println(dat,HEX);
		switch (cmd) {
			case TCBM_CODE_RECV:
//        Serial.print(F("new character at ")); Serial.println(input_buf_ptr, HEX);
				input_buf[input_buf_ptr] = dat;
				input_buf_ptr++;
				if (input_buf_ptr==sizeof(input_buf)) {	// prevent overflow, just in case
          // or change status - that we won't accept anything more
					input_buf_ptr--;
					input_buf[input_buf_ptr] = 0;
				}
				break;
			case TCBM_CODE_COMMAND:
				if (dat == 0x3F) { // UNLISTEN
					Serial.println(F("[UNLISTEN]"));
					file_opened = true;
				} else {
					Serial.print(F("unk OPEN CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
					input_buf_ptr = 0;
				}
				done = true;
				break;
			default:
				Serial.print(F("unk OPEN state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				input_buf_ptr = 0;
				done = true;
				break;
		}
	}
	Serial.println(input_buf_ptr, HEX);
	Serial.print(F("...got [")); Serial.print((const char*)input_buf); Serial.println(F("]"));
	if (channel == 0) {
		// find file for LOAD
		dpoint = 0; // reset pointer, reset status for file not found
	}
	if (channel == 1) {
		// prepare for SAVE
	}
	state = STATE_IDLE;
}

//////////////////////////////////

void setup() {
  tcbm_init();
  state_init();
  state = STATE_IDLE;
  Serial.begin(115200);
  Serial.println(F("initializing I/O"));
#ifdef WITH_SD
  Serial.print(F("initializing SD card..."));
  pinMode(PIN_SD_SS, OUTPUT);
  if (!SD.begin(PIN_SD_SS)) { // CS pin
    Serial.println(F("SD init failed!"));
    return;
  }
#endif
  Serial.println(F("tcbm2sd ready"));
}

void loop() {
//  tcbm_read_byte(); state = -1;
//	Serial.println(state);
	switch (state) {
		case STATE_IDLE:
			state_idle();
			break;
		case STATE_OPEN:
			state_open();
			break;
		case STATE_LOAD:
			state_load();
			break;
		case STATE_SAVE:
			state_save();
			break;
		case STATE_STAT:
			state_status();
			break;
    case 255:
      break;
		default:
			Serial.print(F("unknown state=")); Serial.println(state, HEX);
			break;
	}
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
          tcbm_port_input();
          Serial.println(F("port input: "));
          tmp = tcbm_port_read();
          Serial.print(tmp, HEX);
          break;
      case 'o':
          tcbm_port_output();
          Serial.println(F("port output"));
          break;
      case 'z':
          tcbm_port_write(0);
          Serial.println(F("port=0x00"));
          break;
      case 'f':
          tcbm_port_write(255);
          Serial.println(F("port=0xff"));
          break;
      case 'a':
          tcbm_port_write(0xaa);
          Serial.println(F("port=0xaa"));
          break;
      case '5':
          tcbm_port_write(0x55);
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
}
