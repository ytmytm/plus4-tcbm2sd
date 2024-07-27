/*

Copyright (c) 2003-2006, Per Olofsson
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

-   Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

-   Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/


//////////////////////////////////

#include <SdFat.h> // 2.2.3

extern SdFat32 SD;

//////////////////////////////////

//#include <stdio.h>
//#include <stdlib.h>
//#include <string.h>
#include "diskimage.h"

// static allocation, always only one file and only one disk image present
DiskImage _di;
ImageFile _imgfile;

/* convert to rawname */
int di_rawname_from_name(unsigned char *rawname, char *name) {
  int i;

  memset(rawname, 0xa0, 16);
  for (i = 0; i < 16 && name[i]; ++i) {
    rawname[i] = name[i];
  }
  return(i);
}


/* convert from rawname */
int di_name_from_rawname(char *name, unsigned char *rawname) {
  int i;

  for (i = 0; i < 16 && rawname[i] != 0xa0; ++i) {
    name[i] = rawname[i];
  }
  name[i] = 0;
  return(i);
}


/* return status string */
int di_status(DiskImage *di, char *status) {
  /* special case for power up */
  if (di->status == 254) {
   return(73);
  }
  return(di->status);
}


int set_status(DiskImage *di, int status, int track, int sector) {
  di->status = status;
  di->statusts.track = track;
  di->statusts.sector = sector;
  return(status);
}


/* return number of tracks for image type */
int di_tracks(ImageType type) {
  switch (type) {
  case D64:
    return(35);
    break;
  case D64_40:
    return(40);
    break;
  case D64_42:
    return(42);
    break;
  case D71:
    return(70);
    break;
  case D81:
    return(80);
    break;
  }
  return(0);
}


/* return disk geometry for track */
int di_sectors_per_track(ImageType type, int track) {
  switch (type) {
  case D71:
    if (track > 35) {
      track -= 35;
    }
    // fall through
  case D64:
  case D64_40:
  case D64_42:
    if (track < 18) {
      return(21);
    } else if (track < 25) {
      return(19);
    } else if (track < 31) {
      return(18);
    } else {
      return(17);
    }
    break;
  case D81:
    return(40);
    break;
  }
  return(0);
}

/* convert track, sector to blocknum */
uint32_t get_block_num(ImageType type, TrackSector ts) {
  uint32_t block;

  switch (type) {
  case D64:
  case D64_40:
  case D64_42:
    if (ts.track < 18) {
      block = (ts.track - 1) * 21;
    } else if (ts.track < 25) {
      block = (ts.track - 18) * 19 + 17 * 21;
    } else if (ts.track < 31) {
      block = (ts.track - 25) * 18 + 17 * 21 + 7 * 19;
    } else {
      block = (ts.track - 31) * 17 + 17 * 21 + 7 * 19 + 6 * 18;
    }
    return(block + ts.sector);
    break;
  case D71:
    if (ts.track > 35) {
      block = 683;
      ts.track -= 35;
    } else {
      block = 0;
    }
    if (ts.track < 18) {
      block += (ts.track - 1) * 21;
    } else if (ts.track < 25) {
      block += (ts.track - 18) * 19 + 17 * 21;
    } else if (ts.track < 31) {
      block += (ts.track - 25) * 18 + 17 * 21 + 7 * 19;
    } else {
      block += (ts.track - 31) * 17 + 17 * 21 + 7 * 19 + 6 * 18;
    }
    return(block + ts.sector);
    break;
  case D81:
    return((ts.track - 1) * 40 + ts.sector);
    break;
  }
  return(0);
}


/* get a pointer to block data */
/* read one sector into buffer */
unsigned char *get_ts_addr(DiskImage *di, TrackSector ts) {
  di->file->seekSet(get_block_num(di->type, ts) * 256);
  di->file->read(di->image, 256);
  return (di->image);
}


/* return a pointer to the next block in the chain */
TrackSector next_ts_in_chain(DiskImage *di, TrackSector ts) {
  unsigned char *p;
  TrackSector newts;

  p = get_ts_addr(di, ts);
  newts.track = p[0];
  newts.sector = p[1];
  if (p[0] > di_tracks(di->type)) {
    newts.track = 0;
    newts.sector = 0;
  } else if (p[1] > di_sectors_per_track(di->type, p[0])) {
    newts.track = 0;
    newts.sector = 0;
  }
  return(newts);
}


/* return a pointer to the disk title */
unsigned char *di_title(DiskImage *di) {
  switch (di->type) {
  default:
  case D64:
  case D64_40:
  case D64_42:
  case D71:
    return(get_ts_addr(di, di->dir) + 144);
    break;
  case D81:
    return(get_ts_addr(di, di->dir) + 4);
    break;
  }
}


/* return number of free blocks in track */
int di_track_blocks_free(DiskImage *di, int track) {
  unsigned char *bam;

  switch (di->type) {
  default:
  case D64:
  case D64_40: // not quite right
  case D64_42: // not quite right
    bam = get_ts_addr(di, di->bam);
    break;
  case D71:
    bam = get_ts_addr(di, di->bam);
    if (track >= 36) {
      return(bam[track + 185]);
    }
    break;
  case D81:
    if (track <= 40) {
      bam = get_ts_addr(di, di->bam);
    } else {
      bam = get_ts_addr(di, di->bam2);
      track -= 40;
    }
    return(bam[track * 6 + 10]);
    break;
  }
  return(bam[track * 4]);
}


/* count number of free blocks */
int blocks_free(DiskImage *di) {
  int track;
  int blocks = 0;

  for (track = 1; track <= di_tracks(di->type); ++track) {
    if (track != di->dir.track) {
      blocks += di_track_blocks_free(di, track);
    }
  }
  return(blocks);
}


DiskImage *di_load_image(File32 *file) {

  if (!file) { return NULL; }

  DiskImage *di;
  di = &_di;

  di->file = file;

  /* check image type */
  switch (di->file->size()) {
  case 174848: // standard D64
  case 175531: // D64 with error info (which we just ignore)
    di->type = D64;
    di->bam.track = 18;
    di->bam.sector = 0;
    di->dir = di->bam;
    break;
  case 196608: // standard D64 / 40 tracks
  case 197376: // D64 / 40 tracks with error info (which we just ignore)
    di->type = D64_40;
    di->bam.track = 18;
    di->bam.sector = 0;
    di->dir = di->bam;
    break;
  case 205312: // standard D64 / 42 tracks
  case 206114: // D64 / 42 tracks with error info (which we just ignore)
    di->type = D64_42;
    di->bam.track = 18;
    di->bam.sector = 0;
    di->dir = di->bam;
    break;
  case 349696: // standard D71
  case 351062: // D71 with error info (which we just ignore)
    di->type = D71;
    di->bam.track = 18;
    di->bam.sector = 0;
    di->bam2.track = 53;
    di->bam2.sector = 0;
    di->dir = di->bam;
    break;
  case 819200: // standard D81
  case 822400: // D81 with error info (which we just ignore)
    di->type = D81;
    di->bam.track = 40;
    di->bam.sector = 1;
    di->bam2.track = 40;
    di->bam2.sector = 2;
    di->dir.track = 40;
    di->dir.sector = 0;
    break;
  default:
    return(NULL);
  }

  di->blocksfree = blocks_free(di);
  set_status(di, 254, 0, 0);
  return(di);
}


int match_pattern(unsigned char *rawpattern, unsigned char *rawname) {
  int i;

  for (i = 0; i < 16; ++i) {
    if (rawpattern[i] == '*') {
      return(1);
    }
    if (rawname[i] == 0xa0) {
      if (rawpattern[i] == 0xa0) {
	return(1);
      } else {
	return(0);
      }
    } else {
      if (rawpattern[i] == '?' || rawpattern[i] == rawname[i]) {
      } else {
	return(0);
      }
    }
  }
  return(1);
}


RawDirEntry *find_file_entry(DiskImage *di, unsigned char *rawpattern, FileType type) {
  unsigned char *buffer;
  TrackSector ts;
  RawDirEntry *rde;
  int offset;

  ts = next_ts_in_chain(di, di->dir);
  while (ts.track) {
    buffer = get_ts_addr(di, ts);
    for (offset = 0; offset < 256; offset += 32) {
      rde = (RawDirEntry *)(buffer + offset);
      if ((rde->type & ~0x40) == (type | 0x80)) {
	if (match_pattern(rawpattern, rde->rawname)) {
	  return(rde);
	}
      }
    }
    ts = next_ts_in_chain(di, ts);
  }
  return(NULL);
}


/* open a file for reading*/
ImageFile *di_open(DiskImage *di, const char *rawname, FileType type) {
  ImageFile *imgfile;
  RawDirEntry *rde;
  unsigned char *p;

  set_status(di, 255, 0, 0);

    imgfile = &_imgfile;
    if (strcmp("$", (const char*)rawname) == 0) {
      imgfile->ts = di->dir;
      p = get_ts_addr(di, di->dir);
      imgfile->buffer = p + 2;
      imgfile->nextts.track = p[0];
      imgfile->nextts.sector = p[1];
      imgfile->buflen = 254;
      rde = NULL;
    } else {
      if ((rde = find_file_entry(di, rawname, type)) == NULL) {
	set_status(di, 62, 0, 0);
	return(NULL);
      }
      imgfile->ts = rde->startts;
      if (imgfile->ts.track > di_tracks(di->type)) {
	return(NULL);
      }
      p = get_ts_addr(di, rde->startts);
      imgfile->buffer = p + 2;
      imgfile->nextts.track = p[0];
      imgfile->nextts.sector = p[1];
      if (imgfile->nextts.track == 0) {
	imgfile->buflen = imgfile->nextts.sector - 1;
      } else {
	imgfile->buflen = 254;
      }
    }

  imgfile->diskimage = di;
  imgfile->rawdirentry = rde;
  imgfile->position = 0;
  imgfile->bufptr = 0;

  set_status(di, 0, 0, 0);
  return(imgfile);
}


int di_read(ImageFile *imgfile, unsigned char *buffer, int len) {
  unsigned char *p;
  int bytesleft;
  int counter = 0;

  while (len) {
    bytesleft = imgfile->buflen - imgfile->bufptr;
    if (bytesleft == 0) {
      if (imgfile->nextts.track == 0) {
	return(counter);
      }
      imgfile->ts = next_ts_in_chain(imgfile->diskimage, imgfile->ts);
      if (imgfile->ts.track == 0) {
	return(counter);
      }
      p = get_ts_addr(imgfile->diskimage, imgfile->ts);
      imgfile->buffer = p + 2;
      imgfile->nextts.track = p[0];
      imgfile->nextts.sector = p[1];
      if (imgfile->nextts.track == 0) {
	imgfile->buflen = imgfile->nextts.sector - 1;
      } else {
	imgfile->buflen = 254;
      }
      imgfile->bufptr = 0;
    } else {
      if (len >= bytesleft) {
	while (bytesleft) {
	  *buffer++ = imgfile->buffer[imgfile->bufptr++];
	  --len;
	  --bytesleft;
	  ++counter;
	  ++(imgfile->position);
	}
      } else {
	while (len) {
	  *buffer++ = imgfile->buffer[imgfile->bufptr++];
	  --len;
	  --bytesleft;
	  ++counter;
	  ++(imgfile->position);
	}
      }
    }
  }
  return(counter);
}


/* close file on image */
void di_close(ImageFile *imgfile) {
}
