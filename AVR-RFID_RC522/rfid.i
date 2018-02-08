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
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega8
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   // 16 bit access
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
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
/*****************************************************
SPI FUNCTION
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
    while(!(SPSR & (1<<7)));
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
/*****************************************************
MFRC-522 function
*****************************************************/
void MFRC_WRITE(unsigned char REG, unsigned char DATA){
    PORTB.2 = 0;
    SPI_TRANSMIT((REG<<1)&0x7E);
    SPI_TRANSMIT(DATA);
    PORTB.2 = 1;
}
unsigned char MFRC_READ(unsigned char REG){
    unsigned char DATA;	
        PORTB.2 = 0;
    SPI_TRANSMIT(((REG<<1)&0x7E)|0x80);
    DATA = SPI_TRANSMIT(0x00);
    PORTB.2 = 1;
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
/*
unsigned char MFRC_TO_CARD(unsigned char cmd, unsigned char *send data, unsigned char send_data_len, unsigned char *back_data, unsigned long *back_data_len){
    unsigned char status = ERROR;
    unsigned char irqEn = 0x00;
    unsigned char waitIRq = 0x00;
    unsigned char lastBits;
    unsigned char n;
    unsigned char tmp;
    unsigned long i;

    switch (cmd)
    {
        case 0x0E:		//MFAuthent Certification cards close
        {
            irqEn = 0x12;
            waitIRq = 0x10;
            break;
        }
        
        case 0x0C:	//Transmit FIFO data
        {
            irqEn = 0x77;
            waitIRq = 0x30;
            break;
        }
        
        default:
        break;
    }
   
    //mfrc522_write(ComIEnReg, irqEn|0x80);	//Interrupt request
    n=MFRC_READ(0x04);
    MFRC_WRITE(0x04,n&(~0x80));//clear all interrupt bits
    n=MFRC_READ(0x0A);//FIFOLevelReg
    MFRC_WRITE(0x0A,n|0x80);//flush FIFO data
    
	MFRC_WRITE(0x01, 0x00);	//NO action; Cancel the current cmd???

	//Writing data to the FIFO
    for (i=0; i<send_data_len; i++)
    {   
		MFRC_WRITE(0x09, send_data[i]);    
	}

	//Execute the cmd
	MFRC_WRITE(0x01, cmd);
    if (cmd == Transceive_CMD)
    {    
		n=MFRC_READ(0x0D);
		MFRC_WRITE(0x0D);  
	}   
    
	//Waiting to receive data to complete
	i = 2000;	//i according to the clock frequency adjustment, the operator M1 card maximum waiting time 25ms???
    do 
    {
		//CommIrqReg[7..0]
		//Set1 TxIRq RxIRq IdleIRq HiAlerIRq LoAlertIRq ErrIRq TimerIRq
        n = MFRC_READ(0x04);
        i--;
    }
    while ((i!=0) && !(n&0x01) && !(n&waitIRq));

	tmp=MFRC_READ(0x0D);
	MFRC_WRITE(0x0D,tmp&(~0x80));
	
    if (i != 0)
    {    
        if(!(MFRC_READ(0x06) & 0x1B))	//BufferOvfl Collerr CRCErr ProtecolErr
        {
            status = CARD_FOUND;
            if (n & irqEn & 0x01)
            {   
				status = CARD_NOT_FOUND;			//??   
			}

            if (cmd == Transceive_CMD)
            {
               	n = MFRC_READ(0x0A);      //FIFOLevelReg
              	lastBits = MFRC_READ(0x0C) & 0x07;     //ControlReg
                if (lastBits)
                {   
					*back_data_len = (n-1)*8 + lastBits;   
				}
                else
                {   
					*back_data_len = n*8;   
				}

                if (n == 0)
                {   
					n = 1;    
				}
                if (n > MAX_LEN)
                {   
					n = MAX_LEN;   
				}
				
				//Reading the received data in FIFO
                for (i=0; i<n; i++)
                {   
					back_data[i] = MFRC_READ(0x09);       //FIFODataReg
				}
            }
        }
        else
        {   
			status = ERROR;  
		}
        
    }
	
    //SetBitMask(ControlReg,0x80);           //timer stops
    //mfrc522_write(cmdReg, PCD_IDLE); 

    return status;   
}              


unsigned char MFRC_REQUEST(unsigned char req_mode, unsigned char * tag_type)
{
	unsigned char  status;  
	unsigned long backBits;//The received data bits

	MFRC_WRITE(0x0D, 0x07);//TxLastBists = BitFramingReg[2..0]	???
	
	tag_type[0] = req_mode;
	status = MFRC_TO_CARD(0x0C, tag_type, 1, tag_type, &backBits);

	if ((status != CARD_FOUND) || (backBits != 0x10))
	{    
		status = ERROR;
	}
   
	return status;
}
*/
/*****************************************************
CLCD FUNCTION
*****************************************************/
void COM_WRITE(unsigned char REG){
    PORTC.2 = 0;
    PORTC.1 = 0;
    PORTC.0 = 1; 
    delay_us(50);   
    PORTD = REG;
    delay_us(50);
    PORTC.0 = 0;
}              
void DATA_WRITE(unsigned char DATA){
    PORTC.2 = 1;
    PORTC.1 = 0;
    PORTC.0 = 1; 
    delay_us(50);   
    PORTD = DATA;
    delay_us(50);
    PORTC.0 = 0;
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
    unsigned char str2[] = "RFID-RC522";
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
        delay_ms(100);
    byte = MFRC_READ(0x37);
    delay_ms(200);
        while (1)
    {
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
