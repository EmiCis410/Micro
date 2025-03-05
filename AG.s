PROCESSOR 16F887  

;*** CONFIGURACIÓN DEL MICROCONTROLADOR ***  
CONFIG  FOSC = INTRC_NOCLKOUT      
CONFIG  WDTE = OFF                 
CONFIG  PWRTE = ON                 
CONFIG  MCLRE = ON                 
CONFIG  CP = OFF                   
CONFIG  CPD = OFF                  
CONFIG  BOREN = ON                 
CONFIG  IESO = ON                  
CONFIG  FCMEN = ON                 
CONFIG  LVP = OFF                  
CONFIG  BOR4V = BOR40V             
CONFIG  WRT = OFF                  

#include <xc.inc>
    
psect  barfunc,local,class=CODE,delta=2
    
; Definición de variables
    dato   equ  0x20    ; Variable para almacenar la entrada
    temp   equ  0x21    ; Variable temporal
    gray   equ  0x30    ; Variable Gray
    aiken  equ  0x40    ; Variable Aiken

; Vectores de inicio
   org 0
   goto Start          
   org 5
   
; Configuración de puertos
Start: 
    bsf STATUS,5    
    movlw 0xFF      
    movwf TRISA     ; Puerto A como entrada
    movlw 0x00      
    movwf TRISB     ; Puerto B como salida (Aiken)
    movwf TRISC     ; Puerto C como salida (Gray)
    
    bsf STATUS,5    
    bsf STATUS,6    
    clrf ANSEL      
    clrf ANSELH     
    bcf STATUS,5    
    bcf STATUS,6    
    
; Bucle principal
Loop: 
    call in_port_A	; Leer puerto A y convertir según la nueva tabla
    call conv_aiken	; Convertir a Aiken
    call conv_gray	; Convertir a Gray
    call out_port_B	; Escribir en el puerto B (Aiken)
    call out_port_C	; Escribir en el puerto C (Gray)
    goto Loop		
       
; Leer el puerto A y convertir según la nueva tabla
in_port_A:
    movf PORTA, W      
    movwf temp         
    movwf dato         
    
    ; Verificar si el valor de entrada está en la tabla
    call check_table
    return

; Verificar si el valor de entrada está en la tabla y convertirlo
check_table:
    movlw 0x00
    subwf dato, W
    btfsc STATUS, 2
    goto set_0000
    
    movlw 0x07
    subwf dato, W
    btfsc STATUS, 2
    goto set_0001
    
    movlw 0x06
    subwf dato, W
    btfsc STATUS, 2
    goto set_0010
    
    movlw 0x05
    subwf dato, W
    btfsc STATUS, 2
    goto set_0011
    
    movlw 0x04
    subwf dato, W
    btfsc STATUS, 2
    goto set_0100
    
    movlw 0x0B
    subwf dato, W
    btfsc STATUS, 2
    goto set_0101
    
    movlw 0x0A
    subwf dato, W
    btfsc STATUS, 2
    goto set_0110
    
    movlw 0x09
    subwf dato, W
    btfsc STATUS, 2
    goto set_0111
    
    movlw 0x08
    subwf dato, W
    btfsc STATUS, 2
    goto set_1000
    
    movlw 0x0F
    subwf dato, W
    btfsc STATUS, 2
    goto set_1001
    
    movlw 0x0E
    subwf dato, W
    btfsc STATUS, 2
    goto set_1010
    
    movlw 0x0D
    subwf dato, W
    btfsc STATUS, 2
    goto set_1011
    
    movlw 0x0C
    subwf dato, W
    btfsc STATUS, 2
    goto set_1100
    
    ; Si no está en la tabla, asignar 0x00 o 0x0F
    movlw 0x00
    movwf dato
    return

set_0000:
    movlw 0x00
    movwf dato
    return

set_0001:
    movlw 0x01
    movwf dato
    return

set_0010:
    movlw 0x02
    movwf dato
    return

set_0011:
    movlw 0x03
    movwf dato
    return

set_0100:
    movlw 0x04
    movwf dato
    return

set_0101:
    movlw 0x05
    movwf dato
    return

set_0110:
    movlw 0x06
    movwf dato
    return

set_0111:
    movlw 0x07
    movwf dato
    return

set_1000:
    movlw 0x08
    movwf dato
    return

set_1001:
    movlw 0x09
    movwf dato
    return

set_1010:
    movlw 0x0A
    movwf dato
    return

set_1011:
    movlw 0x0B
    movwf dato
    return

set_1100:
    movlw 0x0C
    movwf dato
    return

; Conversión a código Aiken
conv_aiken: 
    movf dato, W         
    movwf aiken          
    movlw 0x05           
    subwf aiken, W
    btfsc STATUS,0 
    call aiken_sum	   
    return
 
aiken_sum:
    movlw 0x06           
    addwf aiken,W
    movwf aiken          
    return
    
; Conversión a código Gray
conv_gray:
    movf dato, W         
    movwf gray           
    rrf gray, W          
    xorwf gray, W        
    movwf gray           
    return
    
out_port_C:
    movf gray,W   
    movwf PORTC    
    return 
      
out_port_B:
    movf aiken,W   
    movwf PORTB    
    return 
    
END
