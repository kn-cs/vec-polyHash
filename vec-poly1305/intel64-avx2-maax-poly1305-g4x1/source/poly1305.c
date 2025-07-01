#include "poly1305.h"

void poly1305(uchar8 *h,uchar8 *m,const vec *k,const uint64 l) {

    	uint64 n,r,s,f=1;	
	uint64 *q;
	
	/* return hash value 0 for an empty message */
	if (l == 0) {
	
		q = (uint64 *)h;
		*q = 0; *(q+1) = 0;
		return;
	}
	
	/* n = #bytes, r = #leftover bits */
	n = l/8; r = l%8;
	
	/* increase #bytes by 1 if there are leftover bits */
	if (r>0) n = n + 1;
	
	switch(r) {

		/* append 1 in an appropriate location if number of leftover bits is non-zero */
		case 1: m[n-1] = m[n-1] & 0x01; m[n-1] = m[n-1] | 0x02; f = 0; break;
		case 2: m[n-1] = m[n-1] & 0x03; m[n-1] = m[n-1] | 0x04; f = 0; break;
		case 3: m[n-1] = m[n-1] & 0x07; m[n-1] = m[n-1] | 0x08; f = 0; break;
		case 4: m[n-1] = m[n-1] & 0x0f; m[n-1] = m[n-1] | 0x10; f = 0; break;
		case 5: m[n-1] = m[n-1] & 0x1f; m[n-1] = m[n-1] | 0x20; f = 0; break;
		case 6: m[n-1] = m[n-1] & 0x3f; m[n-1] = m[n-1] | 0x40; f = 0; break;
		case 7: m[n-1] = m[n-1] & 0x7f; m[n-1] = m[n-1] | 0x80; f = 0; break;
	
		/* append 1 in the the first bit of the next byte if there are no leftover bits 
		 * but there is a left over block; increase #bytes */
		case 0: if (n%BLOCK_SIZE>0) {
			
				n = n + 1; 
				m[n-1] = m[n-1] & 0x00; 
				m[n-1] = m[n-1] | 0x01; 
				f = 0; 
			};		
	}	
	
	/* s = #blocks, r = #bytes_in_last block */
	s = n/BLOCK_SIZE; r = n%BLOCK_SIZE; 
			
	/* if there is a partial block increase #blocks */	 
	if (r > 0) s = s + 1;
	
	/* 
	 *  h : output
	 *  m : input message
	 *  k : key powers
	 *  s : number of blocks
	 *  f : f=1 if the last block is full, 0 otherwise
	 */	
	poly1305_avx2_maax_g4x1((uint64 *)h,(uint64 *)m,k,s,f);	
}
