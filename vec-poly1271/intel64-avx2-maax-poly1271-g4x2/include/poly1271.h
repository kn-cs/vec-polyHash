#ifndef __POLY1271__
#define __POLY1271__

#include "poly1271_basictypes.h"

#define ALIGN32 __attribute__ ((aligned(32)))

typedef uint64 ALIGN32 vec[4];

#define KEY_LENGTH 126
#define BLOCK_LENGTH 120
#define KEY_SIZE 16
#define BLOCK_SIZE 15
#define MAX_MSG_SIZE 4194304
#define MAX_MSG_LENGTH 33554432
#define MAX_KP_SIZE 25

void poly1271(uchar8 *,uchar8 *,const vec *,const uint64);

extern void poly1271_avx2_maax_g4x2(uint64 *,const uint64 *,const vec *,const uint64,const uint64);
extern void poly1271_keypowers(vec *,const uint64 *,const uint64);

#endif
