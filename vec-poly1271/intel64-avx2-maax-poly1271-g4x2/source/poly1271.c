#include "poly1271.h"

void poly1271(uchar8 *h, uchar8 *m, const vec *k, const uint64 l) {

    	uint64 n,r,s,f=1;	
	uint64 *q;
	
	if (l == 0) {
	
		q = (uint64 *)h;
		*q = 0; *(q+1) = 0;
		return;
	}
	
	n = l/8; r = l%8;
	
	if (r>0) n = n + 1;
	
	switch(r) {

		case 1: m[n-1] = m[n-1] & 0x01; m[n-1] = m[n-1] | 0x02; f = 0; break;
		case 2: m[n-1] = m[n-1] & 0x03; m[n-1] = m[n-1] | 0x04; f = 0; break;
		case 3: m[n-1] = m[n-1] & 0x07; m[n-1] = m[n-1] | 0x08; f = 0; break;
		case 4: m[n-1] = m[n-1] & 0x0f; m[n-1] = m[n-1] | 0x10; f = 0; break;
		case 5: m[n-1] = m[n-1] & 0x1f; m[n-1] = m[n-1] | 0x20; f = 0; break;
		case 6: m[n-1] = m[n-1] & 0x3f; m[n-1] = m[n-1] | 0x40; f = 0; break;
		case 7: m[n-1] = m[n-1] & 0x7f; m[n-1] = m[n-1] | 0x80; f = 0; break;
	
		case 0: if (n%BLOCK_SIZE>0) {
			
				n = n + 1; 
				m[n-1] = m[n-1] & 0x00; 
				m[n-1] = m[n-1] | 0x01; 
				f = 0; 
			};		
	}	
	
	s = n/BLOCK_SIZE; r = n%BLOCK_SIZE; 
			
	if (r > 0) s = s + 1;
	
	/* 
	 *  h : output
	 *  m : input message
	 *  k : key powers
	 *  s : number of blocks
	 *  f : f=1 if the last block is full, 0 otherwise
	 */	
	poly1271_avx2_maax_g4x2((uint64 *)h,(uint64 *)m,k,s,f);	
}
