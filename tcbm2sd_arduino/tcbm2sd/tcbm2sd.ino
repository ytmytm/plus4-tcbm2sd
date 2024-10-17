// TCBM2SD
//
// (c) Maciej Witkowiak, <ytm@elysium.pl>


// IDE: Arduino Mini w/ ATmega328 (3.3.V)
// in case of flashing problem change in Arduino/hardware/arduino/avr/boards.txt
// or home folder: Arduino15\packages\arduino\hardware\avr\1.8.6\boards.txt
// from: mini.menu.cpu.atmega328.upload.speed=115200
//   to: mini.menu.cpu.atmega328.upload.speed=57600

const uint8_t debug=0; // set to value larger than zero for debug messages
const uint8_t debug2=0; // only for next/prev button; utility commands debug
//#define DISABLE_BROWSER // disable embedded loader binary when debug is enabled (it may not fit in flash)

//////////////////////////////////

// buffer size for current working directory path (32K by FAT32)
// need about 600 RAM bytes free (check out Arduino IDE messages)
// when debug=1 set to low value: 24 (must be more than 17)

#define PATH_SIZE 71

// disable buttons (if A6/A7 are not connected or without pullup)
#define DISABLE_NEXT_PREV_BUT

//////////////////////////////////

#include <EEPROM.h>

//////////////////////////////////

#include <SdFat.h> // 2.2.3

SdFat32 SD;

// SD card setup
const uint8_t PIN_SD_SS = 10;

//////////////////////////////////

#include "diskimage.h"
bool in_image = false;
File32 disk_img;
DiskImage *di;
ImageFile *dinfile;

//////////////////////////////////

// embedded loader w/ fastload protocol to load user-chosen '/BOOT.T2SD' file
// use e.g. Directory Browser 1.2 with tcbm2sd fastloader patch
// http://plus4world.powweb.com/software/Directory_Browser

// created with xxd -i <input.prg> <output.h>
// no #embed available here yet :/

#ifndef DISABLE_BROWSER
const PROGMEM
#include "loader.h"
#else // dummy
const PROGMEM unsigned char loader_prg[] = { 0x01, 0x10, 0x00, 0x00, 0x00 };
unsigned int loader_prg_len = 5;
#endif

//////////////////////////////////

const uint32_t PIN_SD_CD_CHANGE_THR_MS = 100;	// .1s delay for debouncing
uint32_t but_lastchangetime = 0; // common deboucing counter for both sd_cd and button next/prev
uint8_t sd_cd_laststate = 1;  // initial state=removed (or INPUT_PULLUP when not connected)
// SD change switch
const uint8_t PIN_SD_CD = A5; // may not be connected so check only for CHANGE, SD inserted=0, SD removed=1
// buttons
const uint8_t PIN_BUT_PREV = A6; // also TCBM cable sense
const uint8_t PIN_BUT_NEXT = A7; // buttons prev/next won't work if this is not pulled up
const uint16_t PIN_BUT_ANALOG_THR = 600; // threshold for A6/A7 analog pins to be LOW (closed), not HIGH
const uint8_t PIN_BUT_PREVNEXT_TRIES = 20; // check this many directory positions for next/prev disk image
const uint32_t BUT_PREVNEXT_CHANGE_THR_MS = 100; // .1s delay for debouncing
bool but_prevnext_enabled = true; // switch to false if A7 is not pulled up upon boot

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

void tcbm_disabled() {
	// make yourself transparent on TCBM bus, no pullups
	pinMode(PIN_DAV, INPUT);
	pinMode(PIN_ACK, INPUT);
	pinMode(PIN_STATUS0, INPUT);
	pinMode(PIN_STATUS1, INPUT);
	tcbm_port_input(); // pullups enabled
	tcbm_port_write(0x00); // pullups disabled
	while(true) { }; // never return
}

uint8_t tcbm_read_cmd() { // read command byte - 0 or $81/82/83/84
  volatile uint8_t tmp, cmd;
  if (debug2>1) { Serial.println(F("read_cmd, dav=")); Serial.println(tcbm_get_dav()); }
  if (tcbm_get_dav() != 1) return 0; // controller ready?
  tmp = tcbm_port_read();
  cmd = tcbm_port_read();
  if (debug2>1) { Serial.print(F("tmp,cmd=")); Serial.println((uint16_t)(tmp << 8 | cmd),HEX); }
  if (tmp != cmd) return 0; // stable?
  if (!(cmd & 0x80)) return 0; // command?
  if (!(cmd==0x81 || cmd==0x82 || cmd==0x83 || cmd==0x84)) return 0; // valid command?
  if (debug2>1) { Serial.println(F("set ACK=0")); }
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
		if (debug) { Serial.print(F("dev magic, devnum=")); Serial.println(devnum); }
		// protect against corruption
		if (devnum != 0 && devnum != 1) {
			devnum = 1; // DEV == 1 - device #8
		}
	} else {
		if (debug) { Serial.print(F("no magic, default to #8")); }
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
const uint8_t STATE_FASTLOAD = 6; // like STATE_LOAD but with fast transfer protocol
const uint8_t STATE_BROWSER = 7; // like STATE_LOAD but write from db12b[] array
const uint8_t STATE_FASTDIR = 8; // like STATE_DIR but with fast transfer protocol
const uint8_t STATE_FASTLOAD_TS = 9; // like STATE_LOAD from image but t&s passed in filename[0..1] with fast transfer protocol
const uint8_t STATE_FAST_BLOCKREAD = 10; // like STATE_LOAD from image, but read filename[2]*256 bytes from offset pointed by t&s filename[0..1] with fast transfer protocol
const uint8_t STATE_FAST_BLOCKWRITE = 11; // like STATE_SAVE into image but write filename[2]*256 bytes from offset pointed by t&s filename[0..1] with fast transfer protocol

uint8_t channel = 0; // opened channel: 0=load, 1=save, 15=command, anything else is not supported
uint8_t state = STATE_IDLE;
bool file_opened = false;

uint8_t input_buf_ptr = 0; // pointer to within input buffer
uint8_t input_buf[48]; // input buffer - filename + commands
uint8_t output_buf_ptr = 0; // pointer to within output buffer (can't rely on C strings when sending data bytes)
uint8_t output_buf[48]; // output buffer, render status here

// parameters, valid only for STATE_STAT/STATE_BROWSER, used to send status (RAM) or directory browser (FLASH)
char* status_buffer; // data pointer
uint16_t status_len; // data length
bool status_flash; // true (from flash), false (from RAM)

// filesystem
char pwd[PATH_SIZE] = { "/" };
char filename[17];
bool filename_is_dir = false;
char entryname_c[17]; // used within match_filename and dir_render_file, can't reuse input/output_buf because of 'R' command
// global: result of pattern matching: pwd+real filename
char fullfname[PATH_SIZE] = { "\0" }; // result of match_filename

//////////////////////////////////

// convert everything to lowercase petscii
static char to_petscii(unsigned char c) {
  if (c == 0x5f) return 0x7e;  // convert short filename marker
  if (c == 0x7e) return 0x5f;  // convert short filename marker
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
	if (input_buf[in]=='0' && input_buf[in+1]==':') { in++; }
	if (input_buf[in]==':') { in++; }
	while (out<sizeof(filename) && in<input_buf_ptr && !filename_is_dir && input_buf[in]) {
		if (input_buf[in]!=0x0d) {
			filename[out] = to_petscii(input_buf[in]);
			out++;
			if (input_buf[in]=='$') {
				if (debug) { Serial.println(F("..filename is $")); }
				filename_is_dir = true;
			}
		}
		in++;
	}
	if (debug) { Serial.print(F("...filename [")); Serial.print((const char*)input_buf); Serial.println(F("]")); }
	return filename_is_dir;
}

// match filename[] to directory entry, return matched filename (if not matched it can be wrong - then SD.exists(fname) fails with file-not-found error
char *match_filename(bool onlyDir) {
	File dir;
	File entry;
	if (in_image) {
		di_rawname_from_name((unsigned char*)fullfname, filename);
		dinfile = di_open(di, fullfname, T_PRG);
		if (dinfile) {
			if (debug) { Serial.println(F("found in img")); }
			di_close(dinfile);
			return fullfname;
		} else {
			if (debug) { Serial.println(F("NOT found in img")); }
			fullfname[0]='\0';
			return fullfname; // this will fail later on open
		}
	}
	if (filename[0]=='/') {
		// absolute path
		fullfname[0] = '/';
		fullfname[1] = '\0';
	} else {
		// relative path
		strcpy(fullfname, pwd);
	}
	dir = SD.open(fullfname); // current dir (we don't care if this open succeeded or not yet)
	if (!dir) {
		fullfname[0] = '\0';
		return fullfname; // this will fail later on open
	}

	// is there enough space?
	if (strlen(fullfname)+strlen(filename) > sizeof(fullfname)) {
		if (debug) { Serial.print(F("ovflow")); };
		fullfname[0] = '\0';
		return fullfname; // this will fail later on open
	}

	if (debug) { Serial.print(F(" searching for:")); Serial.println(filename); };

	if (strchr(filename, '*') == nullptr && strchr(filename, '?') == nullptr) {
		if (debug) { Serial.println(F(" no globs")); }
		strcat(fullfname, filename); // append filename to cwd
		entry = SD.open(fullfname); // check if it's dir when dir was requested and file if file was requested
		if (entry) {
			if ((onlyDir && !entry.isDirectory()) || (!onlyDir && entry.isDirectory())) {
				fullfname[0] = '\0';
			}
			entry.close();
		}
		if (dir) { dir.close(); }
		return fullfname;
	}
	if (debug) { Serial.print(F(" matching...")); Serial.println(filename); }

	entry = dir.openNextFile();
	while (entry) {
		uint8_t i=0;
		bool match;
		char c;
		size_t len;
		if ((onlyDir && entry.isDirectory()) || (!onlyDir && !entry.isDirectory())) {
			i=0;
			match = true;
			len = entry.getName(entryname_c,sizeof(entryname_c));
			if (len>16 || len==0) { // fall back on short 8.3 filename if we can't handle it
				entry.getSFN(entryname_c,sizeof(entryname_c));
			}
			if (debug) { Serial.println(entryname_c); }

			while (i<16 && i<strlen(filename) && i<strlen(entryname_c) && match) {
				c = filename[i];
				if (debug>1) { Serial.print(i); Serial.print(":"); Serial.println(c); }
				switch (c) {
					case '?':
						break;  // skip to next one
					case '*':
						if (strlen(fullfname)+strlen(entryname_c) > sizeof(fullfname)) {
							if (debug) { Serial.print(F("ovflow2")); };
							fullfname[0] = '\0';
						} else {
							strcat(fullfname, entryname_c);
						}
						entry.close();
						dir.close();
						return fullfname; // we have match
						break;
					default:
						match = match && (to_petscii(c) == to_petscii(entryname_c[i]));
						break;
				}
				i++;
			}

			if (match && ((i==16 && strlen(entryname_c)>16) || (i<=16 && strlen(entryname_c)==strlen(filename)))) {
				if (debug) { Serial.println(F("..matched/first 16 chars to longentry ")); }
				if (strlen(fullfname)+strlen(entryname_c) > sizeof(fullfname)) {
					if (debug) { Serial.print(F("ovflow3")); };
					fullfname[0] = '\0';
				} else {
					strcat(fullfname, entryname_c);
				}
				entry.close();
				dir.close();
				return fullfname;
			}
		}
		entry.close();
		entry = dir.openNextFile();
	}
	// no match, cleanup
	if (entry) {
		entry.close();
	}
	if (dir) {
		dir.close();
	}
	fullfname[0] = '\0';
	return fullfname; // this will fail
}

void set_error_msg(uint8_t error) {
  memset(output_buf, 0, sizeof(output_buf));
  switch (error) {
    case 0:
      strcpy_P((char*)output_buf, (const char*)F("00, OK,00,00"));
      break;
    case 1:
      strcpy_P((char*)output_buf, (const char*)F("01, FILES SCRATCHED,01"));
      break;
    case 23:
      strcpy_P((char*)output_buf, (const char*)F("23, READ ERROR,00,00"));
      break;
    case 26:
      strcpy_P((char*)output_buf, (const char*)F("26, WRITE PROTECT ON,00,00"));
      break;
    case 30:
      strcpy_P((char*)output_buf, (const char*)F("30, SYNTAX ERROR,00,00"));
      break;
    case 62:
      strcpy_P((char*)output_buf, (const char*)F("62, FILE NOT FOUND,00,00"));
      break;
    case 63:
      strcpy_P((char*)output_buf, (const char*)F("63, FILE EXISTS,00,00"));
      break;
    case 73:
      strcpy_P((char*)output_buf, (const char*)F("73, TCBM2SD BY YTM 2024,00,02"));
      break;
    case 74:
      strcpy_P((char*)output_buf, (const char*)F("74, DRIVE NOT READY,00,00"));
      break;
    default:
      strcpy_P((char*)output_buf, (const char*)F("99, UNKNOWN,00,00"));
      break;
  }
}

// called after 'I', 'UI' and 'UJ' commands to refresh SD card status
void reload_sd_card() {
	// close any opened files (d64/d71/d81 image? but they would be read-only anyway)
	if (in_image) {
		disk_img.close();
		in_image = false;
	}
	SD.end(); // reload SD card
	if (!SD.begin(PIN_SD_SS)) { // CS pin
		if (debug) { Serial.println(F("SD init failed!")); }
		set_error_msg(74);
	}
}

// helper functions for CD operations
// go to root
void pwd_root() {
	pwd[0] = '/';
	pwd[1] = '\0';
}
// go to parent (cut off last path item)
void pwd_goto_parent() {
    uint8_t len = strlen(pwd);
    if (len > 1) {  // Only if not already at root
        pwd[len-1] = '\0'; // cut trailing '/'
        // Find the (formerly second) to last '/'
        char* lastSlash = strrchr(pwd, '/')+1;
        if (lastSlash != pwd) {  // Ensure it's not the root '/'
            *lastSlash = '\0';  // Cut the string here
        } else {
            pwd[1] = '\0';  // Only root '/'
        }
    }
}
// return last path item with leading slash without trailing slash (/home/user/ -> /user)
void pwd_get_current_dir(char * buffer) {
    uint8_t len = strlen(pwd);
    char *lastSlash;
    if (len > 1) {  // Only if not already at root
        pwd[len-1] = '\0'; // cut trailing '/'
        // Find the (formerly second) to last '/'
        lastSlash = strrchr(pwd, '/');
    } else {
        lastSlash = pwd; // there is only root slash
    }
    strcpy(buffer, lastSlash);
    if (len > 1) {
        pwd[len-1] = '/'; // restore trailing '/'
    }
}



void handle_command() {
	char *fname;
	if (debug||debug2) { Serial.print(F("...command [")); Serial.print((const char*)input_buf); Serial.println(F("]")); }
	if (!input_buf[0]) {
		if (debug) { Serial.println(F("no command, no change")); }
		return;
	}
	set_error_msg(0);
	// CD
	if (input_buf[0]=='C' && input_buf[1]=='D') {
		input_to_filename(2);
		if (debug) { Serial.print(F("CD")); }
		if (!filename[0]) {
			if (debug) { Serial.println(F("...no dirname")); }
			return;
		}
		if ((filename[0]==0x5f) || (filename[0]==0x7e) || (filename[0]=='.' && filename[1]=='.' && filename[2]==0)) {
			if (debug) { Serial.println(F("...parent")); }
			if (in_image) {
				if (debug) { Serial.println(F("out of image")); }
				disk_img.close();
				in_image = false;
			} else {
				pwd_goto_parent();
			}
			if (debug) { Serial.println(pwd); }
			return;
		}
		if (filename[0]=='/' && filename[1]=='/' && filename[2]==0) {
			if (debug) { Serial.println(F("...root")); }
			if (in_image) { // XYX I think SD2IEC goes to root of image file, not out of image
				if (debug) { Serial.println(F("out of image<root>")); }
				disk_img.close();
				in_image = false;
			} else {
				pwd_root();
			}
			return;
		}
		fname = match_filename(true);
		if (SD.exists(fname)) {
			// copy matched directory name and add trailing '/'
			strcpy(pwd, fname);
			uint8_t len = strlen(pwd);
			pwd[len] = '/';
			pwd[len+1] = '\0';
		} else {
			if (debug) { Serial.print(F("...NOT FOUND ")); Serial.println((char*)filename); }
			fname = match_filename(false);
			if (debug) { Serial.print(F("...IMAGE? ")); Serial.println(fname); }
			disk_img = SD.open(fname,O_RDWR);
			if (debug) { Serial.println(F("...SUCC?")); }
			if (disk_img) {
				if (debug) { Serial.println(F("...SUCC")); }
				di = di_load_image(&disk_img);
				if (di) {
					if (debug) { Serial.println(F("...SUCC2")); Serial.print(F("type=")); Serial.println(di->type); Serial.print(F("free=")); Serial.println(di->blocksfree); }
					in_image = true;
				}
			} else {
				set_error_msg(62);
			}
		}
		if (debug) { Serial.print(F("...[")); Serial.print((const char*)filename); Serial.println(F("]")); }
		if (debug) { Serial.println(pwd); }
		return;
	}
	// MD / RD
	if ((input_buf[0]=='M' || input_buf[0]=='R') && input_buf[1]=='D') {
		if (in_image) {
			set_error_msg(26);
			return;
		}
		input_to_filename(2);
		fname = match_filename(true);
		if (debug) { Serial.print(F("MKDIR/RMDIR")); Serial.println(fname); }
		switch (input_buf[0]) {
			case 'M':
				if (debug) { Serial.print(F("mkdir")); }
				if (SD.exists(fname)) {
					if (debug) { Serial.print(F("...exists")); }
					set_error_msg(63);
					return;
				}
				if (!SD.mkdir(fname)) {
					if (debug) { Serial.print(F("...failed")); }
					set_error_msg(26);
					return;
				}
				return;
				break;
			case 'R':
				if (debug) { Serial.print(F("rmdir")); }
				if (!SD.exists(fname)) {
					if (debug) { Serial.print(F("...not found")); }
					set_error_msg(62);
					return;
				}
				if (!SD.rmdir(fname)) {
					if (debug) { Serial.print(F("...failed")); }
					set_error_msg(26);
					return;
				}
				return;
				break;
			default:
				break;
		}
		set_error_msg(0); // have to reset status b/c output_buf was destroyed
		return;
	}
	// R? <new>=<old>
	if (input_buf[0]=='R') {
		if (in_image) {
			set_error_msg(26);
			return;
		}
		if (debug) { Serial.print(F("RENAME")); }
		// scan for '='
		uint8_t in=1;
		bool found=false;
		if (input_buf[in]=='0' && input_buf[in+1]==':') { in++; }
		if (input_buf[in]==':') { in++; }
		// in points to next char
		while (in<input_buf_ptr && input_buf[in] && !found) {
		  found = (input_buf[in] == '=');
		  in++;
		}
		if (!found) {
		  if (debug) { Serial.println(F("missing '='")); }
		  set_error_msg(30);
		  return;
		}
		// target
		input_buf[in-1] = '\0'; // replace '=' with '\0' to cut the string
		input_to_filename(1);
		if ((strlen(filename))==0) {
			if (debug) { Serial.print(F("missing tgtname")); }
			set_error_msg(30);
			return;
		}
		char *tgtname = match_filename(false);
		// remember in output_buf as next match_filename will overwrite fullfname buffer
		tgtname = strcpy((char*)output_buf, tgtname);
		if (debug) { Serial.print(F("to:")); Serial.println(tgtname); }
		if (SD.exists(tgtname)) {
		  if (debug) { Serial.println(F("...EXISTS")); }
		  set_error_msg(63);
		  return;
		}
		// source
		input_to_filename(in);
		if ((strlen(filename))==0) {
			if (debug) { Serial.print(F("missing srcname")); }
			set_error_msg(30);
			return;
		}
		char *sourcename = match_filename(false);
		if (debug) { Serial.print(F("from:")); Serial.print(sourcename); Serial.print(F(" to:")); Serial.println(tgtname); }
		if (!SD.exists(sourcename)) {
		  if (debug) { Serial.println(F("...NOT FOUND")); }
		  set_error_msg(62);
		  return;
		}
		// action
		if (!SD.rename(sourcename, tgtname)){
		  set_error_msg(26);
		} else {
			set_error_msg(0); // have to reset status b/c output_buf was destroyed
		}
		return;
	}

	// S?
	if (input_buf[0]=='S') {
		if (in_image) {
			set_error_msg(26);
			return;
		}
		if (debug) { Serial.print(F("SCRATCH")); }
		input_to_filename(1);
		if (!filename[0]) {
			Serial.println(F("...no name"));
			set_error_msg(62);
			return;
		}
		if (debug) { Serial.print(F("... [")); Serial.print((const char*)filename); Serial.println(F("]")); }
		fname = match_filename(false);
		if (SD.exists(fname)) { // will remove only first matching file
			if (SD.remove(fname)) {
				if (debug) { Serial.println(F("...deleted")); }
				set_error_msg(1);
			} else {
				if (debug) { Serial.println(F("...not deleted")); }
				set_error_msg(26);
			}
		} else {
			if (debug) { Serial.println(F("...NOT FOUND")); }
			set_error_msg(62);
		}
		return;
	}
	// I - reset SD card interface after SD eject/insert event (not detectable)
	if (input_buf[0]=='I') {
		if (debug) { Serial.println(F("INIT")); }
		reload_sd_card();
		return;
	}
	// UI / UJ
	if (input_buf[0]=='U' && (input_buf[1]=='I' || input_buf[1]=='J')) {
		if (debug) { Serial.println(F("RESET")); }
		reload_sd_card();
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
	// U0<%xx011111>[filename] - fastload utility (like BURST CMD TEN)
	if (input_buf[0]=='U' && input_buf[1]=='0' && (input_buf[2] & 0x3f) == 0x1f) {
		input_to_filename(3);
		state = STATE_FASTLOAD;
		if (debug2) { Serial.print(F("UFastload:[")); Serial.print(filename); Serial.println(F("]")); }
		return;
	}
	if (in_image && input_buf[0]=='U' && input_buf[1]=='0') {
		filename[0] = input_buf[3];	// track
		filename[1] = input_buf[4];	// sector
		filename[2] = input_buf[5];	// number of sectors (for block read/write)
		if (debug2) { Serial.print(F("TSFAST:")); Serial.print(input_buf[3],HEX); Serial.print(F(":")); Serial.print(input_buf[4],HEX); Serial.print(F(":")); Serial.println(input_buf[5],HEX); }
		// U0<%xx111111><track><sector> - fastload utility (like BURST CMD TEN) but within image start with t&s
		if ((input_buf[2] & 0x3f) == 0x3f) {
			state = STATE_FASTLOAD_TS;
			return;
		}
		// U0<%00000000><track><sector><number-of-sectors> - block read + number of sectors to load (consecutive, not through t&s link in sector data)
		if (input_buf[2]==0x00) {
			state = STATE_FAST_BLOCKREAD;
			return;
		}
		// U0<%00000010><track><sector><number-of-sectors> - block write + number of sectors to write (consecutive, not through t&s link in sector data)
		if (input_buf[2]==0x02) {
			state = STATE_FAST_BLOCKWRITE;
			return;
		}
	}
	if (debug||debug2) {
		uint8_t in=0;
		Serial.println();
		while (in<input_buf_ptr) {
			Serial.print(input_buf[in],HEX); Serial.print(F(" "));
			in++;
		}
		Serial.println();
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
		if (debug|debug2) { Serial.print(F("[LISTEN]:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
		if (cmd != TCBM_CODE_SECOND) return;
		chn = dat & 0x0F;
		switch (dat & 0xF0) {
			case 0xF0:	// OPEN
				if (debug) { Serial.print(F("open chn=")); }
				if (debug) { Serial.println(chn); }
				channel = chn;
				state = STATE_OPEN; // filename or command incoming, until UNLISTEN
				break;
			case 0xE0:	// CLOSE
				if (debug|debug2) { Serial.print(F("close chn=")); }
				if (debug|debug2) { Serial.println(chn); }
				if (channel == 15) {
					if (debug|debug2) { Serial.println(F("handle command from input buf")); }
					// handle command from input buffer: S:, R:, CD<-, CD<name>, CD:<name>, CD//
					handle_command();
				}
				state_init();
				break;
			case 0x60:	// SECOND
				if (debug) { Serial.print(F("second chn=")); }
				if (debug) { Serial.println(chn); }
				channel = chn;
				switch (channel) {
					case 15:
						state = STATE_OPEN; // keep recieving data into input buffer
						break;
					case 1: // SAVE
					default:
						input_to_filename(0);
						state = STATE_SAVE; // receive data stream to be saved, until UNLISTEN
						break;
				}
				break;
			default:
				state_init();
				if (debug) { Serial.println(F("unk state after LISTEN")); }
				return;
		}
	}
	if (dat == 0x40) { // TALK
		cmd = tcbm_read_cmd_block();
		dat = tcbm_read_data(TCBM_STATUS_OK);
		if (debug) { Serial.print(F("[TALK]:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
		if (cmd != TCBM_CODE_SECOND) return;
		chn = dat & 0x0F;
		switch (dat & 0xF0) {
			case 0x70: // SECOND (fastload on channel 0)
				if (debug) { Serial.print(F("[FASTLOAD]")); }
				// fall through
			case 0x60: // SECOND
				if (debug) { Serial.print(F("second chn=")); }
				if (debug) { Serial.println(chn); }
				channel = chn;
				switch (channel) {
					case 15:
						if (debug) { Serial.println(F("status request, write from outputbuf")); }
						state = STATE_STAT;
						break;
					case 0:	// LOAD
					default:
						if (file_opened) {
							input_to_filename(0);
							if (filename_is_dir) {
								// render and send directory data
								if ((dat & 0xF0) == 0x70) {
									state = STATE_FASTDIR;
								} else {
									state = STATE_DIR;
								}
							} else {
								// not directory, a file instead
								if (filename[0]=='*' && !in_image) {
									// send data stream from embedded browser
									state = STATE_BROWSER;
								} else {
									// send data stream from opened file, set TCBM_STATUS_EOI or TCBM_STATUS_SEND when end of file, keep sending data until UNTALK
									if ((dat & 0xF0) == 0x70) {
										state = STATE_FASTLOAD;
									} else {
										state = STATE_LOAD;
									}
								}
							}
						} else {
							if (debug) { Serial.println(F("file not open")); }
							state_init();
						}
						break;
				}
				break;
			default:
				if (debug) { Serial.println(F("unk state after TALK")); }
				return;
		}
	}
}

// every 8th file in image reads 30 bytes, not 32
uint8_t in_image_file_count;

// render volume header to the buffer, incl. load address
void dir_render_header() {
	uint8_t i=0, j=0;

	if (in_image) {
		in_image_file_count = 0;
		dinfile = di_open(di, "$", T_PRG);
		if (!dinfile) {
			if (debug) { Serial.println("cant open $ on disk image"); };
		}
	}

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
	if (in_image) {
		uint8_t j=i;
		unsigned char *t = di_title(di);
		memcpy(output_buf+i, t, 16);
		i += 16;
		output_buf[i++] = '"';
		output_buf[i++] = ' ';
		memcpy(output_buf+i, t+18, 5); // disk ID
		i += 5;
		// cleanup
		while (j<i) {
			if (output_buf[j] == 0xa0) { output_buf[j]=' '; };
			j++;
		}
		// read 254 bytes of the 1st sector
		char c;
		for (uint8_t k=0; k<254; k++) {
			di_read(dinfile, (unsigned char*)&c, 1);
		}
	} else {
		// volume name -- last part of path
		pwd_get_current_dir((char*)(output_buf+i));
		// keep track how many characters were copied
		uint8_t len = strlen((char*)(output_buf+i));
		// convert to petscii / fill with spaces
		for (uint8_t j=0; j<16; j++) {
			if (j<len) {
				output_buf[i]=to_petscii(output_buf[i]);
				i++;
			} else {
				output_buf[i++]=' ';
			}
		}
		strcpy_P((char*)(output_buf+i), (const char*)F("\" 00 2A"));
		i += 7;
	}
	output_buf[i++] = 0; // end of line
	output_buf_ptr = i;
}

// render blocks free to the buffer, incl. three zero bytes at the end of BASIC
void dir_render_footer() {
	uint8_t i=0;
	// BASIC link 0x0101
	output_buf[i++] = 1;
	output_buf[i++] = 1;
	if (in_image) {
		if (debug) { Serial.print("bfree:"); Serial.println(di->blocksfree); }
		output_buf[i++] = (uint8_t)( di->blocksfree & 0x00FF);
		output_buf[i++] = (uint8_t)((di->blocksfree & 0xFF00) >> 8);
		di_close(dinfile);
	} else {
		// 9999 BLOCKS FREE.
		output_buf[i++] = (uint8_t)( 9999 & 0x00FF);
		output_buf[i++] = (uint8_t)((9999 & 0xFF00) >> 8);
	}
	strcpy_P((char*)(output_buf+i), (const char*)F("BLOCKS FREE."));
	i += 12;
	output_buf[i++] = 0; // end of line
	// end of program
	output_buf[i++] = 0;
	output_buf[i++] = 0;
	output_buf_ptr = i;
}

const char ftype_0[] PROGMEM = { "DEL" };
const char ftype_1[] PROGMEM = { "SEQ" };
const char ftype_2[] PROGMEM = { "PRG" };
const char ftype_3[] PROGMEM = { "USR" };
const char ftype_4[] PROGMEM = { "REL" };
const char ftype_5[] PROGMEM = { "CBM" };
const char ftype_6[] PROGMEM = { "DIR" };
const char ftype_7[] PROGMEM = { "???" };
const char *const ftype[] PROGMEM = { ftype_0, ftype_1, ftype_2, ftype_3, ftype_4, ftype_5, ftype_6, ftype_7 };

bool dir_render_file(File32 *dir) {

	uint32_t size;
	uint8_t type;
	bool unclosed;
	bool locked;

	if (in_image) {
		uint8_t fsize = 32;
		do {
			in_image_file_count++;
			if (in_image_file_count==8) { fsize=30; in_image_file_count=0; };
			size = di_read(dinfile, input_buf, fsize);
			if (size < 30) { return false; }; // no more files
		} while (input_buf[0]==0); // keep looping over deleted files
		type = input_buf[0] & 7;
		unclosed = !(input_buf[0] & 0x80);
		locked = input_buf[0] & 0x40;
		size = (input_buf[29] << 8) | input_buf[28];
		di_name_from_rawname(entryname_c, input_buf+3);
		if (debug) { Serial.println(entryname_c); };
	} else {

		File32 entry;
		entry.openNext(dir,O_RDONLY);

		if (!entry) { return false; } // no more files
		memset(entryname_c, 0, sizeof(entryname_c));
		size_t len = entry.getName(entryname_c, sizeof(entryname_c));
		if (len>16 || len==0) { // fall back on short 8.3 filename if we can't handle it
			entry.getSFN(entryname_c, sizeof(entryname_c));
			if (debug>1) {
				uint8_t n = strlen(entryname_c);
				for (uint8_t i=0; i<n; i++) {
					Serial.print(i); Serial.print(":"); Serial.print(entryname_c[i]); Serial.print(":"); Serial.println(entryname_c[i], HEX);
				}
			}
		}
		size = 1 + entry.size() / 254;
		unclosed = entry.isHidden();
		if (entry.isDir()) {
			type = 6; // DIR
		} else {
			type = 2; // PRG
		}
		// if it's a disk image D64/71/81, also return DIR
		uint8_t flen = strlen(entryname_c);
		if (flen>4) {
			if (
					(entryname_c[flen-4] == '.') &&
					(   (entryname_c[flen-3] == 'D') || (entryname_c[flen-3] == 'd') ) &&
					( ( (entryname_c[flen-2] == '6') && (entryname_c[flen-1] == '4') ) ||
					  ( (entryname_c[flen-2] == '7') && (entryname_c[flen-1] == '1') ) ||
					  ( (entryname_c[flen-2] == '8') && (entryname_c[flen-1] == '1') )
					)
			) type = 6; // DIR
		}
		locked = (entry.attrib() & (FS_ATTRIB_READ_ONLY | FS_ATTRIB_SYSTEM));

		if (debug) {
			Serial.println(entryname_c);
			if (entry.isDirectory()) {
				Serial.println(F("DIR"));
			} else {
				// files have sizes, directories do not
				Serial.print(F("\t\t"));
				Serial.println(entry.size(), DEC);
			}
		}

		entry.close();
	}

	output_buf_ptr = 0;
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
	while (entryname_c[c] && c<16) {
		output_buf[i++] = to_petscii(entryname_c[c++]);
	}
	// endquote
	output_buf[i++] = '"';
	// pad to 16
	while (c<16) {
		output_buf[i++] = ' ';
		c++;
	}
	// space or splat
	output_buf[i++] = unclosed ? '*' : ' ';
	// filetype
	strcpy_P((char*)(output_buf+i), (const char*)(pgm_read_ptr(&(ftype[type]))));
	i += 3;
	// space or <
	output_buf[i++] = locked ? '<' : ' ';
	// last space
	output_buf[i++] = ' ';
	// end of line
	output_buf[i++] = 0; // end of line
	//
	output_buf_ptr = i;
	return true;
}

void state_standard_load() {
	// send data until UNTALK
	send_data_stream(false);
}

void state_fastload() {
	// send data on altering DAV level, confirm by ACK
	send_data_stream(true);
}

void send_data_stream(bool fast_mode) {
	// send data until UNTALK
	uint8_t cmd;
	uint8_t dat;
	uint8_t status = TCBM_STATUS_OK;
	uint8_t b; // current value
	uint8_t nb; // next value (for reading from image)
	uint8_t i = 0; // output_buffer offset
	uint16_t c = 0; // total byte counter
	uint8_t ack = 1; // initial ACK state is 1
	uint8_t dav = 0; // waiting for initial DAV=0
	uint8_t ret = 0; // final status code
	bool done = false;
	bool eoi = false;
	bool jduntalk = false; // was there already UNTALK sent for DIR transmission? (needed for JiffyDOS which stops after two bytes and resumes)
	bool footer = false; // directory footer && end of buffer means end of STATE_DIR transmission

	char *fname;
	File32 aFile;
	ret = 0; // everything is going to be fine

	if (fast_mode) { tcbm_set_ack(ack); } // set ack high (it should be already high)
	switch (state) {
		case STATE_FASTLOAD_TS:
			if (debug2) { Serial.print(F("[FASTLOADTS] on channel=")); Serial.print(channel, HEX); }
			if (!in_image) {
				status = TCBM_STATUS_SEND;
				ret = 62;
			}
			dinfile = di_open_ts(di, filename[0], filename[1]);
			if (!dinfile) {
				if (debug2) { Serial.println(F("filenotopened")); }
				status = TCBM_STATUS_SEND; // FILE not found == nothing to send
				ret = 62;
			} else { // read the very first byte of the file
				di_read(dinfile, (uint8_t*)&nb, 1);
			}
			break;
		case STATE_FASTLOAD:
			if (debug) { Serial.print(F("[FASTLOAD] on channel=")); Serial.print(channel, HEX); }
			// fall through to STATE_LOAD
		case STATE_LOAD:
			if (debug) { Serial.print(F("[LOAD] on channel=")); Serial.print(channel, HEX); }
			fname = match_filename(false); // search only for files
			if (debug) { Serial.print(F(" searching for:")); Serial.print(fname); }
			if (in_image) {
				if (debug) { Serial.println(F("image")); }
				dinfile = di_open(di, fname, T_PRG);
				if (!dinfile) {
					if (debug) { Serial.println(F("imfilenotfound")); }
					status = TCBM_STATUS_SEND; // FILE not found == nothing to send
					ret = 62;
				} else { // read the very first byte of the file
					di_read(dinfile, (uint8_t*)&nb, 1);
				}
			} else {
				if (SD.exists(fname)) {
					if (debug) { Serial.println(F(" filefound")); }
					aFile = SD.open(fname, FILE_READ);
					if (!aFile) {
						if (debug) { Serial.println(F("...file open error")); }
						status = TCBM_STATUS_SEND; // FILE not found == nothing to send
						state_init(); // called this to reset input buf ptr and set file_opened flag to false
						ret = 23;
					}
				} else {
					if (debug) { Serial.println(F("filenotfound")); }
					status = TCBM_STATUS_SEND; // FILE not found == nothing to send
					ret = 62;
				}
			}
			break;
		case STATE_FASTDIR:
			if (debug) { Serial.print(F("[FASTDIR] on channel=")); Serial.print(channel, HEX); }
		case STATE_DIR:
			if (debug) { Serial.print(F("[DIRECTORY] on channel=")); Serial.println(channel, HEX); }
			aFile = SD.open(pwd); // current dir
			if (!aFile) {
				if (debug) { Serial.println(F("directory open error")); }
				status = TCBM_STATUS_SEND; // FILE not found == nothing to send
				state_init(); // called this to reset input buf ptr and set file_opened flag to false
				ret = 23;
			}
			dir_render_header();
			break;
		case STATE_STAT:
		case STATE_BROWSER:
			if (debug) { Serial.print(F("[DS] on channel=")); Serial.println(channel, HEX); }
			if (debug) { Serial.print(F("sending ")); Serial.print(status_len, HEX); Serial.print(F(" bytes from ")); Serial.println(status_flash); }
			break;
		default:
			if (debug) { Serial.println(F("unknown state, we shouldnt be here")); };
			status = TCBM_STATUS_SEND; // nothing to send
			ret = 23;
			break;
	}

	if (fast_mode) {

	// initial state is DAV=1, ACK=1 - controller will put DAV=0 when port is switched to input, then we switch to output
	if (debug>2) { Serial.print(F("ACK=")); Serial.print(ack); Serial.print(F("waiting for DAV=")); Serial.println(dav); }
	while (!(tcbm_get_dav() == dav)); // wait for initial dav=low
	tcbm_port_output();

	while (!done) {
		if (status != TCBM_STATUS_OK) {   // file not found, not OK
			tcbm_set_status(status); // put out status
			tcbm_port_input(); // return to initial state1
			if (debug>1) { Serial.println(F("ACK=1 waiting for final DAV=1")); }
			tcbm_set_ack(1);
			while (!(tcbm_get_dav() == 1)); // must return to initial state
			tcbm_set_status(TCBM_STATUS_OK);
			done = true; // exit immediately, there will be no UNTALK
        } else {
			switch (state) {
				case STATE_FASTLOAD_TS:
				case STATE_FASTLOAD:
					if (in_image) {
						uint32_t size;
						b = nb; // pass value read last time as the current one
						size = di_read(dinfile, (uint8_t*)&nb, 1); // try to read next one
						if (size==0) {
							status = TCBM_STATUS_EOI; // status must be set with last valid byte
							if (debug>1) { Serial.println(F("EOF")); }
						}
					} else {
						b = aFile.read();
						if (!aFile.available()) {   // was that last byte?
							status = TCBM_STATUS_EOI; // status must be set with last valid byte
							if (debug>1) { Serial.println(F("EOF")); }
						}
					}
					break;
				case STATE_FASTDIR:
					b = output_buf[i];
					if (debug>1) { Serial.print(i,HEX); Serial.print(F(" : ")); Serial.println(b, HEX); }
					i++;
					if (i == output_buf_ptr) {
						if (debug) { Serial.print(F("..end of buffer:")); }
						i = 0;
						if (footer) {
							if (debug) { Serial.print(F("..EOI")); }
							status = TCBM_STATUS_EOI; // status must be set with last valid byte
						} else {
							if (debug) { Serial.print(F("..next file")); }
							footer = !dir_render_file(&aFile);
							if (footer) {
								if (debug) { Serial.print(F("..no more files, footer")); }
								dir_render_footer();
							}
						}
					}
					break;
				default:
					if (debug) { Serial.println(F("unknown state (2), we shouldnt be here")); };
					status = TCBM_STATUS_EOI;
					break;
			}
			c++;
			if (debug>2) { Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(b, HEX); }
			tcbm_set_status(status); // put out status
			tcbm_port_write(b);
			ack ^= 1; // flip ACK
			dav ^= 1; // flip DAV
			if (debug>2) { Serial.print(F("ACK=")); Serial.print(ack); Serial.print(F("waiting for DAV=")); Serial.println(dav); }
			tcbm_set_ack(ack);
			while (!(tcbm_get_dav() == dav)); // wait for confirmation
		}
	}

	} else {

	// standard Kernal protocol
	while (!done) {
		cmd = tcbm_read_cmd_block();
		switch (cmd) {
			case TCBM_CODE_SEND:
				switch (state) {
					case STATE_LOAD:
						if (status != TCBM_STATUS_OK) {		// file not found, not OK
							if (debug>1) { Serial.println(F("0D : 0D")); }
							tcbm_write_data(13, status);	// file not found but 1551 will send <CR>
							done = true; // exit immediately, there will be no UNTALK
						} else {
							if (in_image) {
								uint32_t size;
								b = nb; // pass value read last time as the current one
								size = di_read(dinfile, (uint8_t*)&nb, 1); // try to read next one
								if (size==0) {
									status = TCBM_STATUS_EOI; // status must be set with last valid byte
									if (debug>1) { Serial.println(F("EOF")); }
								}
							} else {
								b = aFile.read();
								if (!aFile.available()) {		// was that last byte?
									status = TCBM_STATUS_EOI;	// status must be set with last valid byte
								}
							}
							c++;
							if (debug>1) { Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(b, HEX); }
							tcbm_write_data(b, status);
						}
						break;
					case STATE_DIR:
						b = output_buf[i];
						if (debug>1) { Serial.print(i,HEX); Serial.print(F(" : ")); Serial.println(b, HEX); }
						i++;
						if (i == output_buf_ptr) {
							if (debug) { Serial.print(F("..end of buffer:")); }
							i = 0;
							if (footer) {
								if (debug) { Serial.print(F("..EOI")); }
								eoi = true;
								status = TCBM_STATUS_EOI; // status must be set with last valid byte
							} else {
								if (debug) { Serial.print(F("..next file")); }
								footer = !dir_render_file(&aFile);
								if (footer) {
									if (debug) { Serial.print(F("..no more files, footer")); }
									dir_render_footer();
								}
							}
						}
						tcbm_write_data(b, status);
						break;
					case STATE_STAT:
					case STATE_BROWSER:
						if (debug>1) { Serial.print(F("new character from ")); Serial.println(c, HEX); }
						if (status_flash) {
							b = pgm_read_byte(status_buffer+c);
						} else {
							b = status_buffer[c];
						}
						c++;
						if (c==status_len) {
							c--;
							status = TCBM_STATUS_EOI; // status must be set with last valid byte
						}
						tcbm_write_data(b, status);
						break;
					default:
						if (debug) { Serial.println(F("unknown state (2), we shouldnt be here")); };
						status = TCBM_STATUS_EOI;
						tcbm_write_data(13, status);
						done = true;
				}
				break;
			case TCBM_CODE_COMMAND:
			case TCBM_CODE_SECOND:
				status = TCBM_STATUS_OK;  // commands are always received with status OK, even if we signalled EOI
				dat = tcbm_read_data(status);
				if (dat == 0x5F) { // UNTALK
					if (debug) { Serial.println(F("[UNTALK]")); }
				} else {
					if (debug) { Serial.print(F("unk LOAD/STAT/DIR CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
					status = TCBM_STATUS_SEND; // some kind of error XXX but done is true so we exit immediately
				}
				// JiffyDOS sends UNTALK after 2 bytes of directory, then TALK+TKSA again, don't stop yet
				if (state==STATE_DIR && !jduntalk && !eoi) {
					done = false;
					status = TCBM_STATUS_OK;
				} else {
					done = true;
				}
				// LISTEN appears after JiffyDOS directory listing is interrupted with RUN/STOP, then exit
				if (state==STATE_DIR && cmd==0x81 && dat==0x20) { jduntalk = true; }
				break;
			default:
				dat = tcbm_read_data(status);
				if (debug) { Serial.print(F("unk LOAD/STAT/DIR state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
				status = TCBM_STATUS_SEND; // some kind of error XXX but done is true so we exit immediately
				done = true;
				break;
		}
	}
	} // if (fast_mode)

	state_init();	// called this to reset input buf ptr and set file_opened flag to false
	if (aFile) {	// close whatever was opened
		aFile.close();
	}
	if (dinfile) {
		di_close(dinfile);
	}
	set_error_msg(ret);
	if (debug) { Serial.print(F("sent bytes:")); Serial.println(c, HEX); }
	state = STATE_IDLE;
}

void state_fastblock(void) {
	uint8_t status = TCBM_STATUS_OK;
	uint8_t b; // current value
	uint16_t c = 0; // total byte counter
	uint8_t ack = 1; // initial ACK state is 1
	uint8_t dav = 0; // waiting for initial DAV=0
	uint8_t ret = 0; // final status code
	bool done = false;
	uint32_t offs;
	uint16_t bytes;
	size_t r; // debug: number of written bytes

	tcbm_set_ack(ack); // set ack high (it should be already high)

	if (debug2 && state == STATE_FAST_BLOCKREAD) { Serial.print(F("[FB-R]:")); }
	if (debug2 && state == STATE_FAST_BLOCKWRITE) { Serial.print(F("[FB-W]:")); }
	if (debug2) { Serial.print(filename[0],HEX); Serial.print(F(":")); Serial.print(filename[1],HEX); Serial.print(F(":")); Serial.print(filename[2],HEX); Serial.print(F(":")); }
	if (in_image) {
		offs = di_get_ts_image_offs(di, filename[0], filename[1]);
		bytes = filename[2] << 8;
		if (debug2) { Serial.print(F("seekto:")); Serial.print(offs,HEX); }
		// seek to needed block
		di->file->seekSet(offs);
	} else {
		status = TCBM_STATUS_SEND;
		ret = 74; // drive (image) not ready
	}

	// initial state is DAV=1, ACK=1 - controller will put DAV=0 when port is switched to input, then we switch to output
	if (state == STATE_FAST_BLOCKREAD) {
		if (debug2) { Serial.print(F("ACK=")); Serial.print(ack); Serial.print(F("waiting for DAV=")); Serial.println(dav); }
		while (!(tcbm_get_dav() == dav)); // wait for initial dav=low
		tcbm_port_output();
	} else {
		// for writing it's the opposite, controller will put DAV=0 then first data is available
		// so we need to wait until DAV=0, but already within the main loop
		dav = 1; // will be filpped inside the loop
	}

	while (!done) {
		if (status != TCBM_STATUS_OK) {   // not OK or end of transmission
			tcbm_set_status(status); // put out status
			tcbm_port_input(); // return to initial state1
			if (debug2) { Serial.println(F("ACK=1 waiting for final DAV=1")); }
			tcbm_set_ack(1);
			while (!(tcbm_get_dav() == 1)); // must return to initial state
			tcbm_set_status(TCBM_STATUS_OK);
			done = true;
        } else {
			switch (state) {
				case STATE_FAST_BLOCKREAD:
					b = di->file->read();
					bytes--;
					if (bytes==0) {
						status = TCBM_STATUS_EOI; // status must be set with last valid byte
						if (debug2) { Serial.println(F("EOF")); }
					}
					c++;
					if (debug2>1) { Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(b, HEX); }
					tcbm_set_status(status); // put out status
					tcbm_port_write(b);
					ack ^= 1; // flip ACK
					dav ^= 1; // flip DAV
					if (debug2>1) { Serial.print(F("ACK=")); Serial.print(ack); Serial.print(F("waiting for DAV=")); Serial.println(dav); }
					tcbm_set_ack(ack);
					while (!(tcbm_get_dav() == dav)); // wait for confirmation
					break;
				case STATE_FAST_BLOCKWRITE:
					ack ^= 1; // flip ACK
					dav ^= 1; // flip DAV
					if (debug2>1) { Serial.print(F("waiting for DAV=")); Serial.println(dav); }
					while (!(tcbm_get_dav() == dav)); // wait for data
					b = tcbm_port_read();
					bytes--;
					if (bytes==0) {
						status = TCBM_STATUS_EOI; // status must be set with last valid byte
						if (debug2) { Serial.println(F("EOF")); }
					}
					c++;
					tcbm_set_status(status); // put out status
					if (debug2>1) { Serial.print(F("ACK=")); Serial.print(ack); }
					tcbm_set_ack(ack);	// confirm we got it
					r = di->file->write(b);
					if (debug2>1) { Serial.print(c,HEX); Serial.print(F(" : ")); Serial.print(b, HEX); Serial.print(F(" : ")); Serial.println(r, HEX); }
					break;
				default:
					break;
				}
			}
	}
	set_error_msg(ret);
	if (debug2) { Serial.print(F("bytes:")); Serial.println(c, HEX); }
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
	uint8_t len = strlen(pwd); // remember path length

	set_error_msg(0);

	// concat filename to path
	if (strlen(pwd)+strlen(filename) < sizeof(pwd)) {
		strcat(pwd, filename);
	} else {
		// path size overflow
		if (debug) { Serial.println(F("path too long")); }
		status = TCBM_STATUS_RECV;
		state_init();
		set_error_msg(26);
	}
	if (strchr(filename, '*') != nullptr || strchr(filename, '?') != nullptr) {
		if (debug) { Serial.println(F(" illegal characters")); }
		status = TCBM_STATUS_RECV;
		state_init();
		set_error_msg(26);
	}
	if (debug) { Serial.print(F("[SAVE] on channel=")); Serial.println(channel, HEX); }
	if (debug) { Serial.print(F(" searching for:")); Serial.print(pwd); }
	if (in_image) {
		if (debug) { Serial.println(F(" image")); }
		status = TCBM_STATUS_RECV;
		state_init();
		set_error_msg(26);
	} else {
		if (SD.exists(pwd)) {
			if (debug) { Serial.println(F("filefound")); }
			status = TCBM_STATUS_RECV; // FILE EXISTS == nothing to receive
			state_init(); // called this to reset input buf ptr and set file_opened flag to false
			set_error_msg(63);
		} else {
			if (debug) { Serial.println(F("filenotfound")); }
			aFile = SD.open(pwd, FILE_WRITE);
			if (!aFile) {
				if (debug) { Serial.println(F("file open error")); }
				status = TCBM_STATUS_RECV; // FILE NOT OPEN FOR WRITE == nothing to receive
				state_init(); // called this to reset input buf ptr and set file_opened flag to false
				set_error_msg(26);
			}
		}
	}
	while (!done) {
		cmd = tcbm_read_cmd_block();
		dat = tcbm_read_data(status);
		switch (cmd) {
			case TCBM_CODE_RECV:
				if (debug>1) { Serial.print(c,HEX); Serial.print(F(" : ")); Serial.println(dat, HEX); }
				if (aFile) {
					aFile.write(dat);
				}
				c++;
				break;
			case TCBM_CODE_COMMAND:
				if (dat == 0x3F) { // UNLISTEN
					if (debug) { Serial.println(F("[UNLISTEN]")); }
				} else {
					if (debug) { Serial.print(F("unk SAVE CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
				}
				done = true;
				break;
			default:
				if (debug) { Serial.print(F("unk SAVE state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
				done = true;
				break;
		}
	}
	// restore pwd
	pwd[len] = '\0';
	if (aFile) {
		aFile.close();
	}
	if (debug) { Serial.print(F("saved bytes:")); Serial.println(c, HEX); }
	state = STATE_IDLE;
}

void state_open() {
	// after LISTEN+OPEN, receive data into input buffer until UNLISTEN - it's command or file name, after UNLISTEN file is opened
	uint8_t cmd;
	uint8_t dat;
	bool done = false;
	if (debug) { Serial.print(F("[OPEN] on channel=")); Serial.println(channel, HEX); }
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
					if (debug|debug2) { Serial.println(F("[UNLISTEN]")); }
					file_opened = true;
				} else {
					if (debug|debug2) { Serial.print(F("unk OPEN CODE cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
					input_buf_ptr = 0;
				}
				done = true;
				break;
			default:
				if (debug) { Serial.print(F("unk OPEN state cmd:")); Serial.println((uint16_t)(cmd << 8 | dat), HEX); }
				input_buf_ptr = 0;
				done = true;
				break;
		}
	}
	if (debug) { Serial.println(input_buf_ptr, HEX); }
	if (debug) { Serial.print(F("...got [")); Serial.print((const char*)input_buf); Serial.println(F("]")); }
	if (channel == 0) {
		// find file for LOAD?
		// reset pointer, reset status for file not found
	}
	if (channel == 1) {
		// prepare for SAVE
	}
	state = STATE_IDLE;
	if (channel == 15) {
		// Directory browser doesn't call CLOSE, only unlisten
		handle_command();
		state_init(); // reset input buffer
	}
}

//////////////////////////////////

void disk_image_prevnext(bool prev) {
	File entry;
	size_t len;
	int16_t diridx;
	uint16_t curidx;
	uint8_t tries = PIN_BUT_PREVNEXT_TRIES;

	// we must be in an image to know which one is the prev one
	if (!in_image && prev) return;
	if (in_image) {
		// name of the current image
		len = disk_img.getName(filename, sizeof(filename));
		if (len>16 || len==0) { // fall back on short 8.3 filename if we can't handle it
			disk_img.getSFN(filename,sizeof(filename));
		}
		// image must be closed
		disk_img.close();
	} else {
		filename[0]='\0'; // no name for current image
	}
	in_image = false;
	if (debug2) { Serial.print(F("closed ")); Serial.print(filename); Serial.println(diridx,HEX); }
	if (debug2) { Serial.print(F("pwd=")); Serial.println(pwd); }
	// find its offset in current directory
	File dir = SD.open(pwd);
	if (!dir) return;
	diridx = 0;
	if (filename[0]!='\0') { // we were in the image, find its index
		memset(entryname_c, 0, sizeof(entryname_c));
		while (strncmp(entryname_c,filename,sizeof(filename)) != 0) {
			entry = dir.openNextFile(O_RDONLY);
			if (!entry) { return; } // no more files
			len = entry.getName(entryname_c,sizeof(entryname_c));
			if (len>16 || len==0) { // fall back on short 8.3 filename if we can't handle it
				entry.getSFN(entryname_c,sizeof(entryname_c));
			}
			diridx++;
			entry.close();
			if (debug2) { Serial.print(F("checking ")); Serial.print(entryname_c); Serial.println(diridx,HEX); }
		}
		diridx--;
	} else {
    diridx = -1; // will be increased to 1
	}
	if (debug2) { Serial.print(F("found")); Serial.println(diridx,HEX); }

	// find any other image previous/next within [tries] range
	while (tries > 0) {
		if (prev && diridx==0) break; // there is no previous file
		if (prev) { diridx--; } else { diridx++; };
		if (debug2) { Serial.print(F("opening ")); Serial.println(diridx,HEX); };
		// each time rewind folder (open file by directory index doesn't work - cost for not using Cd() but we can't afford it anyway)
		dir.rewindDirectory();
		disk_img = dir.openNextFile(O_RDWR);
		curidx = diridx;
		while (curidx>0) {
			if (disk_img) { disk_img.close(); }
			disk_img = dir.openNextFile(O_RDWR);
			curidx--;
		}

		if (disk_img) {
			if (debug2) { Serial.print(F("SUCC size=")); Serial.println(disk_img.fileSize()); }
			if (debug2) { char imgname[17]; disk_img.getName(imgname, 17); Serial.print(F("name=[")); Serial.print(imgname); Serial.println(F("]")); }
			di = di_load_image(&disk_img);
			if (di) {
				if (debug2) { Serial.println(F("...SUCC2")); Serial.print(F("type=")); Serial.println(di->type); Serial.print(F("free=")); Serial.println(di->blocksfree); }
				in_image = true;
				dir.close();
				return;
			}
		}
		tries--;
	}

	// failed, try to reopen the image where we started
	if (debug2) { Serial.print(F("reopen")); }
	if (filename[0]!='\0') { // only if we were in the image
		if (disk_img.open(&dir, filename, O_RDWR)) {
			di = di_load_image(&disk_img);
			if (di) {
				in_image = true;
				dir.close();
				return;
			}
		}
	}

	dir.close();
}

//////////////////////////////////

void setup() {
	// are buttons connected?
	delay(20);
#ifdef DISABLE_NEXT_PREV_BUT
  but_prevnext_enabled = false;
#else
	if (analogRead(PIN_BUT_NEXT) < PIN_BUT_ANALOG_THR) { // grounded: BUT_NEXT doesn't have pullup or pressed, in any case buttons won't be used
		but_prevnext_enabled = false;
	} else {
		// is TCBM cable connected?
		if (analogRead(PIN_BUT_PREV) < PIN_BUT_ANALOG_THR) { // grounded: TCBM cable connected or BUT_PREV pressed
			tcbm_disabled(); // will never return
		}
	}
#endif
  // no, continue
  pinMode(PIN_SD_CD, INPUT_PULLUP);
  sd_cd_laststate = digitalRead(PIN_SD_CD);
  but_lastchangetime = millis();
  //
  tcbm_init();
  dev_from_eeprom();
  state_init();
  set_error_msg(73);
  state = STATE_IDLE;
  if (debug || debug2) {
  Serial.begin(115200); // in fact 57600(?)
  Serial.println(F("initializing I/O"));
  Serial.print(F("initializing SD card..."));
  }
  pinMode(PIN_SD_SS, OUTPUT);
  if (!SD.begin(PIN_SD_SS)) { // CS pin
    if (debug) { Serial.println(F("SD init failed!")); }
    return;
  }
  if (debug) { Serial.println(F("tcbm2sd ready")); }
}

void loop() {

  uint8_t sd_cd_state = digitalRead(PIN_SD_CD);
  if (sd_cd_state != sd_cd_laststate && (millis() - but_lastchangetime > PIN_SD_CD_CHANGE_THR_MS)) {
    if (debug) { Serial.print(F("SD CD was")); Serial.print(sd_cd_laststate); Serial.print(F(" is ")); Serial.println(sd_cd_state); }
    sd_cd_laststate = sd_cd_state;
    but_lastchangetime = millis();
    if (sd_cd_state == 1) { // SD card was in, now it's out
      SD.end();
    } else {
      reload_sd_card();     // SD card was out, now it's in
      pwd_root();           // go to root folder
    }
  }

  if (but_prevnext_enabled && (analogRead(PIN_BUT_PREV) < PIN_BUT_ANALOG_THR) && (millis() - but_lastchangetime > BUT_PREVNEXT_CHANGE_THR_MS)) {
    if (debug2) { Serial.print(F("prev wait until released")); }
    while(analogRead(PIN_BUT_PREV) < PIN_BUT_ANALOG_THR) { };
    if (debug2) { Serial.println(F(" prev image")); };
    disk_image_prevnext(true);
    but_lastchangetime = millis();
  }
  if (but_prevnext_enabled && (analogRead(PIN_BUT_NEXT) < PIN_BUT_ANALOG_THR) && (millis() - but_lastchangetime > BUT_PREVNEXT_CHANGE_THR_MS)) {
    if (debug2) { Serial.print(F("next wait until released")); }
    while(analogRead(PIN_BUT_NEXT) < PIN_BUT_ANALOG_THR) { };
    if (debug2) { Serial.println(F(" next image")); };
    disk_image_prevnext(false);
    but_lastchangetime = millis();
  }

	switch (state) {
		case STATE_IDLE:
			state_idle();
			break;
		case STATE_OPEN:
			state_open();
			break;
		case STATE_LOAD:
			state_standard_load();
			break;
		case STATE_SAVE:
			state_save();
			break;
		case STATE_STAT:
			// send out output_buffer string from RAM (assuming null-terminated string)
			status_buffer = (char*)output_buf;
			status_len = strlen((const char*)output_buf);
			status_flash = false;
			state_standard_load();
			break;
		case STATE_DIR:
			state_standard_load();
			break;
		case STATE_FASTLOAD:
		case STATE_FASTLOAD_TS:
			state_fastload();
			break;
		case STATE_FAST_BLOCKREAD:
		case STATE_FAST_BLOCKWRITE:
			state_fastblock();
			break;
		case STATE_BROWSER:
			// send out directory browser from flash
			status_buffer = (char*)loader_prg;
			status_len = loader_prg_len;
			status_flash = true;
			state_standard_load();
			break;
		case STATE_FASTDIR:
			state_fastload();
			break;
		default:
			if (debug) { Serial.print(F("unknown state=")); Serial.println(state, HEX); }
			break;
	}
}
