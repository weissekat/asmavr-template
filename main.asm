.nolist
; .device ATmega8
.include "m8def.inc"
.list

.def ri = R1
.def temp = R16

; stack init macro
.macro lsp 
        ldi @0, low(@1)
        out SPL, @0
        ldi @0, high(@1)
        out SPH, @0
.endmacro

; start address
.org $0000

; interrupt vectors
        rjmp main; rjmp RESET ; Reset Handler
        reti; rjmp EXT_INT0 ; IRQ0 Handler
        reti; rjmp EXT_INT1 ; IRQ1 Handler
        reti; rjmp TIM2_COMP ; Timer2 Compare Handler
        reti; rjmp TIM2_OVF ; Timer2 Overflow Handler
        reti; rjmp TIM1_CAPT ; Timer1 Capture Handler
        reti; rjmp TIM1_COMPA ; Timer1 CompareA Handler
        reti; rjmp TIM1_COMPB ; Timer1 CompareB Handler
        reti; rjmp TIM1_OVF ; Timer1 Overflow Handler
        rjmp timer; rjmp TIM0_OVF ; Timer0 Overflow Handler
        reti; rjmp SPI_STC ; SPI Transfer Complete Handler
        reti; rjmp USART_RXC ; USART RX Complete Handler
        reti; rjmp USART_UDRE ; UDR Empty Handler
        reti; rjmp USART_TXC ; USART TX Complete Handler
        reti; rjmp ADC ; ADC Conversion Complete Handler
        reti; rjmp EE_RDY ; EEPROM Ready Handler
        reti; rjmp ANA_COMP ; Analog Comparator Handler
        reti; rjmp TWSI ; Two-wire Serial Interface Handler
        reti; rjmp SPM_RDY ; Store Program Memory Ready Handler

timer:
        ; save flag register
        in ri, SREG
        ; work some
        rcall work
        ; restore flag register
        out SREG, ri
        reti 

main:
        ; stack init
        lsp temp, RAMEND
        ; setup timer
        ldi temp, 0x04
        out TCCR0, temp
        ldi temp, $02
        out TIMSK, temp
        ; init leds port
        ldi temp, 0xFF
        out DDRD, temp
        ; enable interrupts
        sei

work:
        ; led on
        ldi temp, 0xFF
        out PORTD, temp
        ; delay
        rcall delay
        ; led off
        ldi temp, 0x00
        out PORTD, temp
        ret

delay:
        ; mess around byte
        ldi R17, 0xFF
loop:   dec R17
        brne loop
        ret
