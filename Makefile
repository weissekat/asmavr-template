MCU = atmega8
TARGET = ft232r 
INCPATH = /usr/share/avra
SRCFILE = main
 
$(SRCFILE).hex:
	avra -l $(SRCFILE).lst -I $(INCPATH) $(SRCFILE).asm
 
flash:
	avra -l $(SRCFILE).lst -I $(INCPATH) $(SRCFILE).asm
	avrdude -c $(TARGET) -p $(MCU) -U flash:w:$(SRCFILE).hex:i
 
clean:
	rm -f $(SRCFILE).hex $(SRCFILE).eep.hex $(SRCFILE).obj $(SRCFILE).cof $(SRCFILE).lst
