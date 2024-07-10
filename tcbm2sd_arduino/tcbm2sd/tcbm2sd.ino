// TCBM2SD
//
// (c) Maciej Witkowiak, <ytm@elysium.pl>


// IDE: Arduino Mini w/ ATmega328 (3.3.V)
// in case of flashing problem change in Arduino/hardware/arduino/avr/boards.txt
// or home folder: Arduino15\packages\arduino\hardware\avr\1.8.6\boards.txt
// from: mini.menu.cpu.atmega328.upload.speed=115200
//   to: mini.menu.cpu.atmega328.upload.speed=57600

#include <EEPROM.h>

//////////////////////////////////

#include <SdFat.h> // 2.2.3

SdFat32 SD;

// SD card setup
const uint8_t PIN_SD_SS = 10;

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
const uint8_t PIN_DAV = A3; // PC3 // crossed DAV/ACK (this is ACK on schematic)
// outputs
const uint8_t PIN_ACK = A2; // PC2 // crossed DAV/ACK (this is DAV on schematic)
const uint8_t PIN_DEV = A4; // PC4 // device number, controlled with EEPROM setting
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

void volatile inline tcbm_port_input() {
  DDRD = DDRD & 0x03;
  DDRB = DDRB & 0xFC;
/*
  pinMode(PIN_D0, INPUT);
  pinMode(PIN_D1, INPUT);
  pinMode(PIN_D2, INPUT);
  pinMode(PIN_D3, INPUT);
  pinMode(PIN_D4, INPUT);
  pinMode(PIN_D5, INPUT);
  pinMode(PIN_D6, INPUT);
  pinMode(PIN_D7, INPUT);
*/
}

void volatile inline tcbm_port_output() {
  DDRD = DDRD | 0xFC;
  DDRB = DDRB | 0x03;
/*
  pinMode(PIN_D0, OUTPUT);
  pinMode(PIN_D1, OUTPUT);
  pinMode(PIN_D2, OUTPUT);
  pinMode(PIN_D3, OUTPUT);
  pinMode(PIN_D4, OUTPUT);
  pinMode(PIN_D5, OUTPUT);
  pinMode(PIN_D6, OUTPUT);
  pinMode(PIN_D7, OUTPUT);
*/
}

void volatile inline tcbm_set_status(uint8_t status) {
  PORTC = (PORTC & 0xFC) | (status & 0x03);
//  digitalWrite(PIN_STATUS0, status & 0x01);
//  digitalWrite(PIN_STATUS1, status & 0x02);
}

void volatile inline tcbm_set_ack(uint8_t ack) {
  PORTC = (PORTC & 0xFB) | ((ack & 0x01) << 2);
//  digitalWrite(PIN_ACK, ack);
}

volatile inline uint8_t tcbm_get_dav(void) {
  return (PINC & 0x08) >> 3;
//  return digitalRead(PIN_DAV);
}

volatile inline uint8_t tcbm_port_read(void) {
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

volatile void tcbm_port_write(uint8_t d) {
  PORTD = ( PORTD & 0x03 ) | ((d & 0x3F) << 2);
  PORTB = ( PORTB & 0xFC ) | ((d & 0xC0) >> 6);
/*
    digitalWrite(PIN_D0, d & 0x01 ? 1 : 0);
    digitalWrite(PIN_D1, d & 0x02 ? 1 : 0);
    digitalWrite(PIN_D2, d & 0x04 ? 1 : 0);
    digitalWrite(PIN_D3, d & 0x08 ? 1 : 0);
    digitalWrite(PIN_D4, d & 0x10 ? 1 : 0);
    digitalWrite(PIN_D5, d & 0x20 ? 1 : 0);
    digitalWrite(PIN_D6, d & 0x40 ? 1 : 0);
    digitalWrite(PIN_D7, d & 0x80 ? 1 : 0);
*/
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
  volatile uint8_t tmp, cmd;
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
  volatile uint8_t tmp=0, cmd=1;
///  Serial.println(F("wait for DAV=1"));
  while (!(tcbm_get_dav() == 1));
  while (!(cmd==0x81 || cmd==0x82 || cmd==0x83 || cmd==0x84)) {
  while (!(cmd & 0x80)) {
    tmp=0; cmd=1;
    while (tmp!=cmd) {
     tmp = tcbm_port_read();
     cmd = tcbm_port_read();
//    Serial.print(F("tmp,cmd=")); Serial.println((uint16_t)(tmp << 8 | cmd), HEX);
    }
  }
  }
///  Serial.print(F("CMCMD=")); Serial.println((uint16_t)(tmp << 8 | cmd), HEX);
///  Serial.println(F("set ACK=0"));
  tcbm_set_ack(0);
  return cmd;
}

uint8_t tcbm_read_data(uint8_t status) { // read data following command byte, with preset status
  volatile uint8_t data;
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

//////////////////////////////////

const uint16_t EEPROM_MAGIC = 0x55aa;
const uint16_t O_EEPROM_MAGIC = 0;
const uint16_t O_EEPROM_DEVNUM = 2;

void dev_from_eeprom() {
	uint16_t magic = 0;
	uint8_t devnum = 1; // default is device #8

	EEPROM.get(O_EEPROM_MAGIC, magic);
	if (magic == EEPROM_MAGIC) {
		EEPROM.get(O_EEPROM_DEVNUM, devnum);
		Serial.print(F("dev magic, devnum=")); Serial.println(devnum);
		// protect against corruption
		if (devnum != 0 && devnum != 1) {
			devnum = 1; // DEV == 1 - device #8
		}
	} else {
		Serial.print(F("no magic, default to #8"));
	}
	digitalWrite(PIN_DEV, devnum);
}

void dev_to_eeprom(uint8_t devnum) {
	if (devnum == 0 || devnum == 1) {
		EEPROM.put(O_EEPROM_MAGIC, EEPROM_MAGIC); // put does update(), so doesn't rewrite EEPROM if the value didn't change
		EEPROM.put(O_EEPROM_DEVNUM, devnum);
		digitalWrite(PIN_DEV, devnum);
	}
}

//////////////////////////////////

const uint8_t STATE_IDLE = 0; // wait for LISTEN command
const uint8_t STATE_OPEN = 1; // after LISTEN, receiving filename or command on #15
const uint8_t STATE_LOAD = 2; // after OPEN on channek 0, after TALK
const uint8_t STATE_SAVE = 3; // after OPEN on channel 1, after LISTEN+SECOND
const uint8_t STATE_STAT = 4; // like STATE_LOAD but write from output_buf
const uint8_t STATE_DIR  = 5; // like STATE_LOAD but render directory listing

uint8_t channel = 0; // opened channel: 0=load, 1=save, 15=command, anything else is not supported
uint8_t state = STATE_IDLE;
bool file_opened = false;

uint8_t input_buf_ptr = 0; // pointer to within input buffer
uint8_t input_buf[64]; // input buffer - filename + commands
uint8_t output_buf_ptr = 0; // pointer to within output buffer (can't rely on C strings when sending data bytes)
uint8_t output_buf[64]; // output buffer, render status here
uint8_t cbm_errno = 0; // CBM DOS error number

String pwd = "/";

// filesystem

uint8_t filename[17];
bool filename_is_dir = false;

// convert everything to lowercase petscii
static char to_petscii(unsigned char c) {
  if (c >= 0x80+'a' && c <= 0x80+'z') {
    c -= 0xa0;
  }
  if (c >= 0x80+'A' && c <= 0x80+'Z') {
    c -= 0x80;
  }
  if (c >= 'a' && c <= 'z') {
    c -= 0x20;
  }
  //if (c >= 'A' && c <= 'Z') { // don't deal with upper/lower case, keep everything lowercase petscii
  //  c += 0x20;
  //}

  return c;
}

bool input_to_filename(uint8_t start) {
	// copy input buffer from [start] to filename buffer:
	// skip over initial '0:'
	// if '$' stop immediately (no directory filtering)
	// strip any <CR> characters
	// return true if filename is directory
	memset(filename, 0, sizeof(filename));
	uint8_t in=start;
	uint8_t out=0;
	filename_is_dir = false;
	if (input_buf[in]=='0') { in++; }
	if (input_buf[in]==':') { in++; }
	while (out<sizeof(filename) && in<input_buf_ptr && !filename_is_dir && input_buf[in]) {
		if (input_buf[in]!=0x0d) {
			filename[out] = to_petscii(input_buf[in]);
			out++;
			if (input_buf[in]=='$') {
				Serial.println(F("..filename is $"));
				filename_is_dir = true;
			}
		}
		in++;
	}
	Serial.print(F("...filename [")); Serial.print((const char*)input_buf); Serial.println(F("]"));
	return filename_is_dir;
}

// match filename[] to directory entry, return matched filename (if not matched it can be wrong - then SD.exists(fname) fails with file-not-found error
String fullfname; // global to pass result
String match_filename(bool onlyDir) {
  String fname = String((const char*)filename);
  String cwd = String(pwd); // local directory or root
  if (filename[0]=='/') {
    cwd = '/'; // absolute path
  }
  fullfname = cwd + fname;

//  Serial.print(F(" searching for:")); Serial.println(fullfname);
  if (fname.indexOf('*')<0 && fname.indexOf('?')<0) {
//    Serial.println(F(" no globs"));
    return fullfname;
  }
//  Serial.print(F(" matching...")); Serial.println(fname);

  File dir;
  File entry;
  char entryname_c[128];
  dir = SD.open(cwd); // current dir
  if (!dir) {
    return fullfname; // this will fail later on open
  }
  entry = dir.openNextFile();
  String entryname;
  if (entry) {
    entry.getName(entryname_c,sizeof(entryname_c));
    entryname = String(entryname_c);
  }
  while (entry) {
    uint8_t i=0;
    bool match;
    char c;
    if ((onlyDir && entry.isDirectory()) || (!onlyDir && !entry.isDirectory())) {
      i=0;
      match = true;
      entry.getName(entryname_c,sizeof(entryname_c));
      entryname = String(entryname_c);
//      Serial.println(entryname);
      while (i<16 && i<fname.length() && i<entryname.length() && match) {
        c = fname.charAt(i);
//        Serial.print(i); Serial.print(":"); Serial.println(c); 
        switch (c) {
          case '?':
            break;  // skip to next one
          case '*':
            fullfname = pwd + entryname;
            entry.close();
            dir.close();
            return fullfname; // have match
            break;
          default:
            match = match && (to_petscii(c) == to_petscii(entryname.charAt(i)));
            break;
        }
//        Serial.println(i);
        i++;
      }
      if (match && ((i==16 && entryname.length()>16) || (i<=16 && entryname.length()==fname.length()))) {
//        Serial.println(F("..matched/first 16 chars to longentry "));
        fullfname = pwd + entryname;
        entry.close();
        dir.close();
        return fullfname;
      }
    }
    entry.close();
    entry = dir.openNextFile();
  }
  if (entry) {
    entry.close();
  }
  if (dir) {
    dir.close();
  }
  return fullfname; // this will fail
}

void set_error_msg(uint8_t error) {
  cbm_errno = error;
  memset(output_buf, 0, sizeof(output_buf));
  switch (cbm_errno) {
    case 0:
      strcpy((char*)output_buf, (const char*)"00, OK,00,00");
      break;
    case 1:
      strcpy((char*)output_buf, (const char*)"01, FILES SCRATCHED,01");
      break;
    case 23:
      strcpy((char*)output_buf, (const char*)"23, READ ERROR,00,00");
      break;
    case 26:
      strcpy((char*)output_buf, (const char*)"26, WRITE PROTECT ON,00,00");
      break;
    case 30:
      strcpy((char*)output_buf, (const char*)"30, SYNTAX ERROR,00,00");
      break;
    case 62:
      strcpy((char*)output_buf, (const char*)"62, FILE NOT FOUND,00,00");
      break;
    case 63:
      strcpy((char*)output_buf, (const char*)"63, FILE EXISTS,00,00");
      break;
    case 73:
      strcpy((char*)output_buf, (const char*)"73, TCBM2SD 2024,00,00");
      break;
    default:
      strcpy((char*)output_buf, (const char*)"99, UNKNOWN,00,00");
      break;
  }
}

void handle_command() {
  String fname;
	Serial.print(F("...command [")); Serial.print((const char*)input_buf); Serial.println(F("]"));
  set_error_msg(0);
	// CD?
	if (input_buf[0]=='C' && input_buf[1]=='D') {
		input_to_filename(2);
		Serial.print(F("CD"));
		if (!filename[0]) {
			Serial.println(F("...no dirname"));
			return;
		}
		if ((filename[0]==0x5f) || (filename[0]=='.' && filename[1]=='.' && filename[2]==0)) {
			Serial.println(F("...parent"));
//      Serial.println(pwd);
      if (pwd.length()>1) {
        pwd = pwd.substring(0,pwd.length()-1);
//        Serial.println(pwd);
        int i = pwd.lastIndexOf('/');
//        Serial.println(i);
        if (i>=0) {
          pwd = pwd.substring(0,i+1);
        }
      }
      Serial.println(pwd);
			return;
		}
		if (filename[0]=='/' && filename[1]=='/' && filename[2]==0) {
			Serial.println(F("...root"));
      pwd = "/";
			return;
		}
    fname = match_filename(true);
    if (SD.exists(fname)) {
      pwd = fname + String("/");
    } else {
      Serial.println(F("...NOT FOUND"));
      set_error_msg(62);
    }
		Serial.print(F("...[")); Serial.print((const char*)filename); Serial.println(F("]"));
    Serial.println(pwd);
		return;
	}
	// S?
	if (input_buf[0]=='S') {
		Serial.print(F("SCRATCH"));
		input_to_filename(1);
		if (!filename[0]) {
			Serial.println(F("...no name"));
      set_error_msg(62);
			return;
		}
		Serial.print(F("... [")); Serial.print((const char*)filename); Serial.println(F("]"));
    fname = match_filename(false);
    if (SD.exists(fname)) { // will remove only first matching file
      if (SD.remove(fname)) {
        Serial.println(F("...deleted"));
        set_error_msg(1);
      } else {
        Serial.println(F("...not deleted"));
        set_error_msg(26);
      }
    } else {
      Serial.println(F("...NOT FOUND"));
      set_error_msg(62);
    }
		return;
	}
	// I
	if (input_buf[0]=='I') {
		Serial.println(F("INIT"));
		return;
	}
	// UI / UJ
	if (input_buf[0]=='U' && (input_buf[1]=='I' || input_buf[1]=='J')) {
		Serial.println(F("RESET"));
    set_error_msg(73);
		return;
	}
	// U0><devnum+8>
	if (input_buf[0]=='U' && input_buf[1]=='0' && input_buf[2]=='>' && (input_buf[3]==8 || input_buf[3]==9)) {
		if (input_buf[3]==8) {
			dev_to_eeprom(1);
		} else {
			dev_to_eeprom(0);
		}
		return;
	}
	// unknown command
	set_error_msg(30);
}

//////////////////////////////////

// state machine

void state_init() {
	input_buf_ptr = 0;
	memset(input_buf, 0, sizeof(input_buf));
	file_opened = false;
}

void state_idle() {
	//
	uint8_t cmd = tcbm_read_cmd();
	if (cmd==0) return;
	uint8_t dat = tcbm_read_data(TCBM_STATUS_OK);
	uint8_t chn = 0; // channel
//  Serial.print(F("IDLE:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
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
					handle_command();
				}
				state_init();
				break;
			case 0x60:	// SECOND
				Serial.print(F("second chn="));
				Serial.println(chn);
				channel = chn;
				switch (channel) {
					case 1:
						input_to_filename(0);
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
		dat = tcbm_read_data(TCBM_STATUS_OK);
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
							input_to_filename(0);
							if (filename_is_dir) {
								state = STATE_DIR;	// render and send directory data
							} else {
								state = STATE_LOAD; // send data stream from opened file, set TCBM_STATUS_EOI or TCBM_STATUS_SEND when end of file, keep sending data until UNTALK
							}
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
	uint8_t status = TCBM_STATUS_OK;
	uint8_t b;
	uint16_t c = 0;
	bool done = false;
	File aFile;
  set_error_msg(0);
  String fname = match_filename(false); // only files

	Serial.print(F("[LOAD] on channel=")); Serial.print(channel, HEX);
	Serial.print(F(" searching for:")); Serial.print(fname);
	if (SD.exists(fname)) {
		Serial.println(F("filefound"));
		aFile = SD.open(fname, FILE_READ);
		if (!aFile) {
			Serial.println(F("file open error"));
			status = TCBM_STATUS_SEND; // FILE not found == nothing to send
			state_init(); // called this to reset input buf ptr and set file_opened flag to false
      set_error_msg(23);
		}
	} else {
		Serial.println(F("filenotfound"));
		status = TCBM_STATUS_SEND; // FILE not found == nothing to send
	}
	while (!done) {
		cmd = tcbm_read_cmd_block();
		switch (cmd) {
			case TCBM_CODE_SEND:
				if (status != TCBM_STATUS_OK) {		// file not found, not OK
//					Serial.println(F("0D : 0D"));
					tcbm_write_data(13, status);	// file not found but 1551 will send <CR>
          set_error_msg(62);
					done = true; // exit immediately, there will be no UNTALK
				} else {
					b = aFile.read();
					if (!aFile.available()) {		// was that last byte?
						status = TCBM_STATUS_EOI;	// status must be set with last valid byte
					}
					c++;
//					Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(b, HEX);
					tcbm_write_data(b, status);
				}
				break;
			case TCBM_CODE_COMMAND:
				status = TCBM_STATUS_OK;  // commands are always received with status OK, even if we signalled EOI
				dat = tcbm_read_data(status);
				if (dat == 0x5F) { // UNTALK
					Serial.println(F("[UNTALK]"));
				} else {
					Serial.print(F("unk LOAD CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
					status = TCBM_STATUS_SEND; // some kind of error XXX but done is true so we exit immediately
				}
				done = true;
				break;
			default:
				dat = tcbm_read_data(status);
				Serial.print(F("unk LOAD state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				status = TCBM_STATUS_SEND; // some kind of error XXX but done is true so we exit immediately
				done = true;
				break;
		}
	}
  state_init(); // called this to reset input buf ptr and set file_opened flag to false
	if (aFile) {
		aFile.close();
	}
	Serial.print(F("loaded bytes:")); Serial.println(c, HEX);
	state = STATE_IDLE;
}

// render volume header to the buffer, incl. load address
void dir_render_header() {
	uint8_t i=0, j=0;
	output_buf_ptr = 0;
	// load address 0x0401 (PET)
	output_buf[i++] = 1;
	output_buf[i++] = 4;
	// BASIC link 0x0101
	output_buf[i++] = 1;
	output_buf[i++] = 1;
	// size 0
	output_buf[i++] = 0;
	output_buf[i++] = 0;
	output_buf[i++] = 0x12; // REV ON?
	output_buf[i++] = '"';
	// volume name -- last part of path
  String p(pwd);
//  Serial.println(p);
  if (p.length()>1) {
    p=p.substring(0,p.length()-1);
//    Serial.println(p);
    int idx = p.lastIndexOf('/');
//    Serial.println(i);
    if (idx>=0) {
      p = p.substring(idx,p.length());
    }
  }
//  Serial.println(p);
	for (uint8_t j=0; j<16; j++) {
    if (j<p.length()) {
      output_buf[i++]=to_petscii(p.charAt(j));
    } else {
		  output_buf[i++]=' ';
    }
	}
	output_buf[i++] = '"';
	output_buf[i++] = ' ';
	output_buf[i++] = '0';
	output_buf[i++] = '0';
	output_buf[i++] = ' ';
	output_buf[i++] = '2';
	output_buf[i++] = 'A';
	output_buf[i++] = 0; // end of line
	output_buf_ptr = i;
}

// render blocks free to the buffer, incl. three zero bytes at the end of BASIC
void dir_render_footer() {
	uint8_t i=0;
	// BASIC link 0x0101
	output_buf[i++] = 1;
	output_buf[i++] = 1;
	// 999
	output_buf[i++] = 0xe7;
	output_buf[i++] = 0x03;
	output_buf[i++] = 'B';
	output_buf[i++] = 'L';
	output_buf[i++] = 'O';
	output_buf[i++] = 'C';
	output_buf[i++] = 'K';
	output_buf[i++] = 'S';
	output_buf[i++] = ' ';
	output_buf[i++] = 'F';
	output_buf[i++] = 'R';
	output_buf[i++] = 'E';
	output_buf[i++] = 'E';
	output_buf[i++] = '.';
	output_buf[i++] = 0; // end of line
	// end of program
	output_buf[i++] = 0;
	output_buf[i++] = 0;
	output_buf_ptr = i;
}

bool dir_render_file(File32 *dir) {
//    File32 entry =  dir->openNextFile();
  File32 entry;
  entry.openNext(dir,O_RDONLY);
	output_buf_ptr = 0;
	char name[128];
	uint32_t size;

	if (!entry) { return false; } // no more files
/*
    Serial.print(entry.name());
    if (entry.isDirectory()) {
      Serial.println("DIR");
    } else {
      // files have sizes, directories do not
      Serial.print("\t\t");
      Serial.println(entry.size(), DEC);
	}
*/
  memset(name, 0, sizeof(name));
	entry.getName7(name,sizeof(name));
//  Serial.println(name);
	size = 1 + entry.size() / 254;

	memset(output_buf, 0, sizeof(output_buf));
	uint8_t i=0, c=0;

	// BASIC link 0x0101
	output_buf[i++] = 1;
	output_buf[i++] = 1;
	// size
	output_buf[i++] = (uint8_t)(size & 0x00FF);
	output_buf[i++] = (uint8_t)((size & 0xFF00) >> 8);
	// pad so that name starts at 5th character
	if (size < 10)		{ output_buf[i++] = ' '; }
	if (size < 100) 	{ output_buf[i++] = ' '; }
	if (size < 1000) 	{ output_buf[i++] = ' '; }
	if (size < 10000) 	{ output_buf[i++] = ' '; }
	// quote
	output_buf[i++] = '"';
	// name
	while (name[c] && c<16) {
		output_buf[i++] = to_petscii(name[c++]);
	}
	// endquote
	output_buf[i++] = '"';
	// pad to 16
	while (c<16) {
		output_buf[i++] = ' ';
    c++;
	}
	// space or splat
  if (entry.isHidden()) {
    output_buf[i++] = '*';
  } else {
	  output_buf[i++] = ' ';
  }
	// filetype
    if (entry.isDir()) {
		output_buf[i++] = 'D';
		output_buf[i++] = 'I';
		output_buf[i++] = 'R';
	} else {
		output_buf[i++] = 'P';
		output_buf[i++] = 'R';
		output_buf[i++] = 'G';
	}
	// space or <
  if (entry.attrib() & (FS_ATTRIB_READ_ONLY | FS_ATTRIB_SYSTEM)) {
    output_buf[i++] = '<';
  } else {
  	output_buf[i++] = ' ';
  }
	// last space
	output_buf[i++] = ' ';
	// end of line
	output_buf[i++] = 0; // end of line
	//
	output_buf_ptr = i;
  entry.close();
	return true;
}

void state_directory() {
	// send data until UNTALK
	uint8_t cmd;
	uint8_t dat;
	uint8_t status = TCBM_STATUS_OK;
	uint8_t b, i;
	bool done = false;
	bool footer = false; // footer && end of buffer means end of transmission
  set_error_msg(0);

	File32 aFile;
	aFile = SD.open(pwd); // current dir
	if (!aFile) {
		Serial.println(F("directory open error"));
		status = TCBM_STATUS_SEND; // FILE not found == nothing to send
		state_init(); // called this to reset input buf ptr and set file_opened flag to false
    set_error_msg(23);
	}

	Serial.print(F("[DIRECTORY] on channel=")); Serial.println(channel, HEX);
	dir_render_header();
  i = 0;
	while (!done) {
		cmd = tcbm_read_cmd_block();
		switch (cmd) {
			case TCBM_CODE_SEND:
				b = output_buf[i];
//				Serial.print(i,HEX); Serial.print(F(" : ")); Serial.println(b, HEX);
				i++;
				if (i == output_buf_ptr) {
//					Serial.print(F("..end of buffer:"));
					i = 0;
					if (footer) {
//						Serial.print(F("..EOI"));
						status = TCBM_STATUS_EOI; // status must be set with last valid byte, STATUS_RECV/SEND won't work here - will not stop; but we get LOAD ERROR
					} else {
//						Serial.print(F("..next file"));
						footer = !dir_render_file(&aFile);
						if (footer) {
//							Serial.print(F("..no more files, footer"));
							dir_render_footer();
						}
					}
				}
				tcbm_write_data(b, status);
				break;
			case TCBM_CODE_COMMAND:
				status = TCBM_STATUS_OK;  // commands are always received with status OK, even if we signalled EOI
				dat = tcbm_read_data(status);
				if (dat == 0x5F) { // UNTALK
					Serial.println(F("[UNTALK]"));
				} else {
					Serial.print(F("unk DIR CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				}
				done = true;
				break;
			default:
				dat = tcbm_read_data(status);
				Serial.print(F("unk DIR state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX);
				done = true;
				break;
		}
	}
  if (aFile) {
    aFile.close();
  }
  set_error_msg(0);
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
 //				Serial.print(F("new character from ")); Serial.println(c, HEX);
				b = output_buf[c];
				c++;
				if (output_buf[c]==0 || c==sizeof(output_buf)) {
					c--;
					status = TCBM_STATUS_EOI; // status must be set with last valid byte
				}
				tcbm_write_data(b, status);
				break;
			case TCBM_CODE_COMMAND:
				status = TCBM_STATUS_OK;  // commands are always received with status OK, even if we signalled EOI
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
	// reset any error
  set_error_msg(0);
	state = STATE_IDLE;
}

void state_save() {
	// receive data until UNLISTEN
	uint8_t cmd;
	uint8_t dat;
	uint8_t status = TCBM_STATUS_OK;
	uint16_t c = 0;
	bool done = false;
	File aFile;

  String fname = pwd + String((const char*)filename);

  set_error_msg(0);
	Serial.print(F("[SAVE] on channel=")); Serial.println(channel, HEX);
	Serial.print(F(" searching for:")); Serial.print(fname);
	if (SD.exists(fname)) {
		Serial.println(F("filefound"));
		status = TCBM_STATUS_RECV; // FILE EXISTS == nothing to receive
		state_init(); // called this to reset input buf ptr and set file_opened flag to false
    set_error_msg(63);
	} else {
		Serial.println(F("filenotfound"));
		aFile = SD.open(fname, FILE_WRITE);
		if (!aFile) {
			Serial.println(F("file open error"));
			status = TCBM_STATUS_RECV; // FILE NOT OPEN FOR WRITE == nothing to receive
			state_init(); // called this to reset input buf ptr and set file_opened flag to false
      set_error_msg(26);
		}
	}
	while (!done) {
		cmd = tcbm_read_cmd_block();
		dat = tcbm_read_data(status);
		switch (cmd) {
			case TCBM_CODE_RECV:
//				Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(dat, HEX);
				if (aFile) {
					aFile.write(dat);
				}
				c++;
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
	if (aFile) {
		aFile.close();
	}
	Serial.print(F("saved bytes:")); Serial.println(c, HEX);
	state = STATE_IDLE;
}

void state_open() {
	// after LISTEN+OPEN, receive data into input buffer until UNLISTEN - it's command or file name, after UNLISTEN file is opened
	uint8_t cmd;
	uint8_t dat;
	bool done = false;
	Serial.print(F("[OPEN] on channel=")); Serial.println(channel, HEX);
	while (!done) {
		cmd = tcbm_read_cmd_block();
//		Serial.println(cmd,HEX);
		dat = tcbm_read_data(TCBM_STATUS_OK);
//		Serial.println(dat,HEX);
		switch (cmd) {
			case TCBM_CODE_RECV:
//				Serial.print(F("new character at ")); Serial.println(input_buf_ptr, HEX);
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
		// find file for LOAD?
		// reset pointer, reset status for file not found
	}
	if (channel == 1) {
		// prepare for SAVE
	}
  if (channel == 15) {
    // Directory browser doesn't call CLOSE, only unlisten
    handle_command();
    state_init(); // reset input buffer
  }
	state = STATE_IDLE;
}

//////////////////////////////////

void setup() {
  tcbm_init();
  dev_from_eeprom();
  state_init();
  set_error_msg(73);
  state = STATE_IDLE;
  Serial.begin(115200); // in fact 57600(?)
  Serial.println(F("initializing I/O"));
  Serial.print(F("initializing SD card..."));
  pinMode(PIN_SD_SS, OUTPUT);
  if (!SD.begin(PIN_SD_SS)) { // CS pin
    Serial.println(F("SD init failed!"));
    return;
  }
  Serial.println(F("tcbm2sd ready"));
  Serial.end();
}

void loop() {
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
		case STATE_DIR:
			state_directory();
			break;
		default:
			Serial.print(F("unknown state=")); Serial.println(state, HEX);
			break;
	}
}
