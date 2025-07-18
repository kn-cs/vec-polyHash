INCDRS = -I../include/

SRCFLS = ../source/poly1305_const.S 		\
	 ../source/poly1305_avx2_maax_g4x3.S	\
	 ../source/poly1305_keypowers.S	\
	 ../source/poly1305_input.c 		\
	 ../source/poly1305.c
         
OBJFLS = ../source/poly1305_const.o 		\
	 ../source/poly1305_avx2_maax_g4x3.o	\
	 ../source/poly1305_keypowers.o	\
	 ../source/poly1305_input.o 		\
	 ../source/poly1305.o

TESTSRC = ./poly1305_g4x3_verify.c
TESTOBJ = ./poly1305_g4x3_verify.o

SPEEDSRC = ./poly1305_g4x3_speed.c
SPEEDOBJ = ./poly1305_g4x3_speed.o

RECORDSRC = ./poly1305_g4x3_record_speed.c
RECORDOBJ = ./poly1305_g4x3_record_speed.o
	  
EXE1    = poly1305_g4x3_verify
EXE2    = poly1305_g4x3_speed
EXE3    = poly1305_g4x3_record_speed

CFLAGS = -march=native -mtune=native -mavx2 -m64 -O3 -funroll-loops -fomit-frame-pointer

CC     = gcc-10
LL     = gcc-10

all:	$(EXE1) $(EXE2) $(EXE3)

$(EXE1): $(TESTOBJ) $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(TESTOBJ) -lm -lcpucycles
	
$(EXE2): $(SPEEDOBJ) $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(SPEEDOBJ) -lm -lcpucycles
	
$(EXE3): $(RECORDOBJ) $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) $(RECORDOBJ) -lm -lcpucycles	

.c.o:
	$(CC) $(INCDRS) $(CFLAGS) -o $@ -c $<

clean:
	-rm $(EXE1) $(EXE2) $(EXE3)
	-rm $(TESTOBJ) $(SPEEDOBJ) $(RECORDOBJ)
	-rm $(OBJFLS)
