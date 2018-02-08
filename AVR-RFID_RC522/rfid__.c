/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.8d Professional
Automatic Program Generator
© Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2018-01-29
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>

#define E PORTC.0
#define RW PORTC.1
#define RS PORTC.2
#define ST PORTC.3
#define SS PORTB.2

#define SPIF 7

/*****************************************************
LCD - Atmega8
E - PC0
RW - PC1
RS - PC2

8bit mode
D0 ~ D7 - PD0 ~ PD7

4bit mode
D4 ~ D7 - PD4 ~ PD7
*****************************************************/

void SPI_INIT(){
    SPCR=0x51;  //Prescaler 16
}

/*
void SPI_WRITE(unsigned char DATA){
    SPDR=DATA;
    while(!(SPSR & (1<<SPIF)));
}

void SPI_READ(){
    SPDR=0x00;
    while(!(SPSR & (1<<SPIF)));
    return SPDR;
}
*/

unsigned char SPI_TRANSMIT(unsigned char DATA){
    SPDR=DATA;
    while(!(SPSR & (1<<SPIF)));
    return SPDR;
}

/*
void MFRC_WRITE(unsigned char REG, unsigned char DATA){
    SS = 0;
    SPI_WRITE((REG<<1)&0x7E);
    SPI_WRITE(DATA);
    SS = 1;
}

unsigned char MFRC_READ(unsigned char REG){
    unsigned char DATA;	
    
    SS = 0;
    SPI_WRITE(((REG<<1)&0x7E)|0x80);
    DATA = SPI_READ();
    SS = 1;
    
    return DATA;
}
*/

void MFRC_WRITE(unsigned char REG, unsigned char DATA){
    SS = 0;
    SPI_TRANSMIT((REG<<1)&0x7E);
    SPI_TRANSMIT(DATA);
    SS = 1;
}

unsigned char MFRC_READ(unsigned char REG){
    unsigned char DATA;	
    
    SS = 0;
    SPI_TRANSMIT(((REG<<1)&0x7E)|0x80);
    DATA = SPI_TRANSMIT(0x00);
    SS = 1;
    
    return DATA;
}

void MFRC_RESET(){
    MFRC_WRITE(0x01,0x0F);     //CommandReg, SoftReset_CMD
}

void MFRC_INIT(){
    unsigned char byte;
    
    MFRC_RESET();
	
    MFRC_WRITE(0x2A, 0x8D);         //TmodeReg
    MFRC_WRITE(0x2B, 0x3E);    //TPrescaleReg
    MFRC_WRITE(0x2C, 30);       //TReloadReg_1
    MFRC_WRITE(0x2D, 0);	//TReloadReg_2
    MFRC_WRITE(0x15, 0x40);	        //TxASKReg
    MFRC_WRITE(0x11, 0x3D);          //ModeReg
	
    byte = MFRC_READ(0x14);     //TxControlReg
    if(!(byte&0x03))
    {
    	MFRC_WRITE(0x14,(byte|0x03));     //TxControlReg
    }

}

void COM_WRITE(unsigned char REG){
    RS = 0;
    RW = 0;
    E = 1; 
    delay_us(50);   
    PORTD = REG;
    delay_us(50);
    E = 0;
}              

void DATA_WRITE(unsigned char DATA){
    RS = 1;
    RW = 0;
    E = 1; 
    delay_us(50);   
    PORTD = DATA;
    delay_us(50);
    E = 0;
}     

void LCD_CHAR(unsigned char col, unsigned char row, unsigned char ch){
    COM_WRITE(0x80|(row + col*0x40));
    
    DATA_WRITE(ch);
    delay_ms(1);
}

void LCD_STR(unsigned char col, unsigned char row, unsigned char *str){
    COM_WRITE(0x80|(row + col*0x40));
    
    while(*str != 0){
        DATA_WRITE(*str);
        str++;
    }
}

void LCD_CLEAR(void){
    COM_WRITE(0x01);
    delay_ms(2);
}

/*****************************************************
8bit mode = 0, 4bit mode = 1
*****************************************************/
void LCD_INIT(int mode){                              
    if(mode == 0)
    {
        COM_WRITE(0x38);
        delay_ms(2);
        COM_WRITE(0x38);
        delay_ms(2);
        COM_WRITE(0x38);
        delay_ms(2);
        COM_WRITE(0x0E);
        delay_ms(2);
        COM_WRITE(0x06);
        delay_ms(2);
        LCD_CLEAR();
    }   
    
    if(mode == 1)
    {
        COM_WRITE(0x38);
        delay_ms(2);
        COM_WRITE(0x38);
        delay_ms(2);
        COM_WRITE(0x38);
        delay_ms(2);
        COM_WRITE(0x0E);
        delay_ms(2);
        COM_WRITE(0x06);
        delay_ms(2);
        LCD_CLEAR();
    }
}    

void main(void)
{
    unsigned char str1[] = "RFID-TEST...";
    unsigned char str2[] = "*RFID-RC522*";
    unsigned char str3[] = "Reset Clear";
    unsigned char str4[] = "FIFO Read...";
    unsigned char str5[] = "Version 1.0";
    unsigned char str6[] = "Version 2.0";
    unsigned char str7[] = "No Detect  ";
    
    unsigned char byte = 0;
    unsigned char SelfTestBuffer[64] = {0};
         
    delay_ms(1000);

    DDRD = 0xFF;
    DDRC = 0xFF;
    DDRB = 0xEF;  //SS(Out) MOSI(In) MISO(Out) SCK(Out)
        
    LCD_INIT(0);
    
    SPI_INIT();
        
    MFRC_INIT(); 
        
    /*
    MFRC_RESET();
    for(byte = 0; byte < 25; byte++){
        MFRC_WRITE(0x09,0x00);   //FIFODataReg
    }

    MFRC_WRITE(0x01,0x01);
    MFRC_WRITE(0x36,0x09);
    MFRC_WRITE(0x09,0x00);
    MFRC_WRITE(0x01,0x03);
    
    for(byte = 0; byte<	64; byte++)
    {
        SelfTestBuffer[byte] = MFRC_READ(0x09);       
        LCD_CHAR(0, 3, SelfTestBuffer[byte]);
        delay_ms(1500);
    }	
    */
    
    while (1)
    {
        byte = MFRC_READ(0x37);
    
        if(byte == 0x92)
        {               
            LCD_STR(0,0,str1);
            LCD_STR(1,0,str5);
        }
        
        else if(byte == 0x91)
        {
            LCD_STR(0,0,str1);
            LCD_STR(1,0,str6);
        }
       
        else
        {
            LCD_STR(0,0,str1);
            LCD_STR(1,0,str7);
        }                     
    };
}
