#ifndef __POLY1305__
#define __POLY1305__

#include "poly1305_basictypes.h"

#define ALIGN32 __attribute__ ((aligned(32)))

typedef uint64 ALIGN32 vec[4];

#define KEY_LENGTH 128
#define BLOCK_LENGTH 128
#define KEY_SIZE 16
#define BLOCK_SIZE 16
#define MAX_MSG_SIZE 4194304
#define MAX_MSG_LENGTH 33554432
#define MAX_KP_SIZE 43

void poly1305(uchar8 *,uchar8 *,const vec *,const uint64);

extern void poly1305_avx2_maax_g4x4(uint64 *,const uint64 *,const vec *,const uint64,const uint64);
extern void poly1305_keypowers(vec *,const uint64 *,const uint64);

#endif
