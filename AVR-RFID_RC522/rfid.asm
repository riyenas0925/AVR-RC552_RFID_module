
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "rfid.vec"
	.INCLUDE "rfid.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.24.8d Professional
;       4 Automatic Program Generator
;       5 © Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project : 
;       9 Version : 
;      10 Date    : 2018-01-29
;      11 Author  : F4CG                            
;      12 Company : F4CG                            
;      13 Comments: 
;      14 
;      15 
;      16 Chip type           : ATmega8
;      17 Program type        : Application
;      18 Clock frequency     : 16.000000 MHz
;      19 Memory model        : Small
;      20 External SRAM size  : 0
;      21 Data Stack size     : 256
;      22 *****************************************************/
;      23 
;      24 #include <mega8.h>
;      25 #include <delay.h>
;      26 
;      27 #define E PORTC.0
;      28 #define RW PORTC.1
;      29 #define RS PORTC.2
;      30 #define ST PORTC.3
;      31 #define SS PORTB.2
;      32 
;      33 #define SPIF 7
;      34 
;      35 #define CARD_FOUND		1
;      36 #define CARD_NOT_FOUND	2
;      37 #define ERROR			3
;      38 #define MAX_LEN 13
;      39 
;      40 /*****************************************************
;      41 LCD - Atmega8
;      42 E - PC0
;      43 RW - PC1
;      44 RS - PC2
;      45 
;      46 8bit mode
;      47 D0 ~ D7 - PD0 ~ PD7
;      48 
;      49 4bit mode
;      50 D4 ~ D7 - PD4 ~ PD7
;      51 *****************************************************/
;      52 
;      53 
;      54 /*****************************************************
;      55 SPI FUNCTION
;      56 *****************************************************/
;      57 
;      58 void SPI_INIT(){

	.CSEG
_SPI_INIT:
;      59     SPCR=0x51;  //Prescaler 16
	LDI  R30,LOW(81)
	OUT  0xD,R30
;      60 }
	RET
;      61 
;      62 /*
;      63 void SPI_WRITE(unsigned char DATA){
;      64     SPDR=DATA;
;      65     while(!(SPSR & (1<<SPIF)));
;      66 }
;      67 
;      68 void SPI_READ(){
;      69     SPDR=0x00;
;      70     while(!(SPSR & (1<<SPIF)));
;      71     return SPDR;
;      72 }
;      73 */
;      74 
;      75 unsigned char SPI_TRANSMIT(unsigned char DATA){
_SPI_TRANSMIT:
;      76     SPDR=DATA;
;	DATA -> Y+0
	LD   R30,Y
	OUT  0xF,R30
;      77     while(!(SPSR & (1<<SPIF)));
_0x3:
	SBIS 0xE,7
	RJMP _0x3
;      78     return SPDR;
	IN   R30,0xF
	RJMP _0x16
;      79 }
;      80 
;      81 /*
;      82 void MFRC_WRITE(unsigned char REG, unsigned char DATA){
;      83     SS = 0;
;      84     SPI_WRITE((REG<<1)&0x7E);
;      85     SPI_WRITE(DATA);
;      86     SS = 1;
;      87 }
;      88 
;      89 unsigned char MFRC_READ(unsigned char REG){
;      90     unsigned char DATA;	
;      91     
;      92     SS = 0;
;      93     SPI_WRITE(((REG<<1)&0x7E)|0x80);
;      94     DATA = SPI_READ();
;      95     SS = 1;
;      96     
;      97     return DATA;
;      98 }
;      99 */
;     100 
;     101 /*****************************************************
;     102 MFRC-522 function
;     103 *****************************************************/
;     104 
;     105 void MFRC_WRITE(unsigned char REG, unsigned char DATA){
_MFRC_WRITE:
;     106     SS = 0;
;	REG -> Y+1
;	DATA -> Y+0
	RCALL SUBOPT_0x0
;     107     SPI_TRANSMIT((REG<<1)&0x7E);
	RCALL SUBOPT_0x1
;     108     SPI_TRANSMIT(DATA);
	LD   R30,Y
	RCALL SUBOPT_0x1
;     109     SS = 1;
	SBI  0x18,2
;     110 }
	RJMP _0x15
;     111 
;     112 unsigned char MFRC_READ(unsigned char REG){
_MFRC_READ:
;     113     unsigned char DATA;	
;     114     
;     115     SS = 0;
	ST   -Y,R16
;	REG -> Y+1
;	DATA -> R16
	RCALL SUBOPT_0x0
;     116     SPI_TRANSMIT(((REG<<1)&0x7E)|0x80);
	ORI  R30,0x80
	RCALL SUBOPT_0x1
;     117     DATA = SPI_TRANSMIT(0x00);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
	MOV  R16,R30
;     118     SS = 1;
	SBI  0x18,2
;     119     
;     120     return DATA;
	MOV  R30,R16
	LDD  R16,Y+0
	RJMP _0x15
;     121 }
;     122 
;     123 void MFRC_RESET(){
_MFRC_RESET:
;     124     MFRC_WRITE(0x01,0x0F);     //CommandReg, SoftReset_CMD
	RCALL SUBOPT_0x2
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x3
;     125 }
	RET
;     126 
;     127 void MFRC_INIT(){
_MFRC_INIT:
;     128     unsigned char byte;
;     129     
;     130     MFRC_RESET();
	ST   -Y,R16
;	byte -> R16
	RCALL _MFRC_RESET
;     131 	
;     132     MFRC_WRITE(0x2A, 0x8D);         //TmodeReg
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(141)
	RCALL SUBOPT_0x3
;     133     MFRC_WRITE(0x2B, 0x3E);    //TPrescaleReg
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x3
;     134     MFRC_WRITE(0x2C, 30);       //TReloadReg_1
	LDI  R30,LOW(44)
	ST   -Y,R30
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x3
;     135     MFRC_WRITE(0x2D, 0);	//TReloadReg_2
	LDI  R30,LOW(45)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x3
;     136     MFRC_WRITE(0x15, 0x40);	        //TxASKReg
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x3
;     137     MFRC_WRITE(0x11, 0x3D);          //ModeReg
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x3
;     138 	
;     139     byte = MFRC_READ(0x14);     //TxControlReg
	LDI  R30,LOW(20)
	ST   -Y,R30
	RCALL _MFRC_READ
	MOV  R16,R30
;     140     if(!(byte&0x03))
	MOV  R30,R16
	ANDI R30,LOW(0x3)
	BRNE _0x6
;     141     {
;     142     	MFRC_WRITE(0x14,(byte|0x03));     //TxControlReg
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOV  R30,R16
	ORI  R30,LOW(0x3)
	RCALL SUBOPT_0x3
;     143     }
;     144 }    
_0x6:
	LD   R16,Y+
	RET
;     145 
;     146 /*
;     147 unsigned char MFRC_TO_CARD(unsigned char cmd, unsigned char *send data, unsigned char send_data_len, unsigned char *back_data, unsigned long *back_data_len){
;     148     unsigned char status = ERROR;
;     149     unsigned char irqEn = 0x00;
;     150     unsigned char waitIRq = 0x00;
;     151     unsigned char lastBits;
;     152     unsigned char n;
;     153     unsigned char tmp;
;     154     unsigned long i;
;     155 
;     156     switch (cmd)
;     157     {
;     158         case 0x0E:		//MFAuthent Certification cards close
;     159         {
;     160             irqEn = 0x12;
;     161             waitIRq = 0x10;
;     162             break;
;     163         }
;     164         
;     165         case 0x0C:	//Transmit FIFO data
;     166         {
;     167             irqEn = 0x77;
;     168             waitIRq = 0x30;
;     169             break;
;     170         }
;     171         
;     172         default:
;     173         break;
;     174     }
;     175    
;     176     //mfrc522_write(ComIEnReg, irqEn|0x80);	//Interrupt request
;     177     n=MFRC_READ(0x04);
;     178     MFRC_WRITE(0x04,n&(~0x80));//clear all interrupt bits
;     179     n=MFRC_READ(0x0A);//FIFOLevelReg
;     180     MFRC_WRITE(0x0A,n|0x80);//flush FIFO data
;     181     
;     182 	MFRC_WRITE(0x01, 0x00);	//NO action; Cancel the current cmd???
;     183 
;     184 	//Writing data to the FIFO
;     185     for (i=0; i<send_data_len; i++)
;     186     {   
;     187 		MFRC_WRITE(0x09, send_data[i]);    
;     188 	}
;     189 
;     190 	//Execute the cmd
;     191 	MFRC_WRITE(0x01, cmd);
;     192     if (cmd == Transceive_CMD)
;     193     {    
;     194 		n=MFRC_READ(0x0D);
;     195 		MFRC_WRITE(0x0D);  
;     196 	}   
;     197     
;     198 	//Waiting to receive data to complete
;     199 	i = 2000;	//i according to the clock frequency adjustment, the operator M1 card maximum waiting time 25ms???
;     200     do 
;     201     {
;     202 		//CommIrqReg[7..0]
;     203 		//Set1 TxIRq RxIRq IdleIRq HiAlerIRq LoAlertIRq ErrIRq TimerIRq
;     204         n = MFRC_READ(0x04);
;     205         i--;
;     206     }
;     207     while ((i!=0) && !(n&0x01) && !(n&waitIRq));
;     208 
;     209 	tmp=MFRC_READ(0x0D);
;     210 	MFRC_WRITE(0x0D,tmp&(~0x80));
;     211 	
;     212     if (i != 0)
;     213     {    
;     214         if(!(MFRC_READ(0x06) & 0x1B))	//BufferOvfl Collerr CRCErr ProtecolErr
;     215         {
;     216             status = CARD_FOUND;
;     217             if (n & irqEn & 0x01)
;     218             {   
;     219 				status = CARD_NOT_FOUND;			//??   
;     220 			}
;     221 
;     222             if (cmd == Transceive_CMD)
;     223             {
;     224                	n = MFRC_READ(0x0A);      //FIFOLevelReg
;     225               	lastBits = MFRC_READ(0x0C) & 0x07;     //ControlReg
;     226                 if (lastBits)
;     227                 {   
;     228 					*back_data_len = (n-1)*8 + lastBits;   
;     229 				}
;     230                 else
;     231                 {   
;     232 					*back_data_len = n*8;   
;     233 				}
;     234 
;     235                 if (n == 0)
;     236                 {   
;     237 					n = 1;    
;     238 				}
;     239                 if (n > MAX_LEN)
;     240                 {   
;     241 					n = MAX_LEN;   
;     242 				}
;     243 				
;     244 				//Reading the received data in FIFO
;     245                 for (i=0; i<n; i++)
;     246                 {   
;     247 					back_data[i] = MFRC_READ(0x09);       //FIFODataReg
;     248 				}
;     249             }
;     250         }
;     251         else
;     252         {   
;     253 			status = ERROR;  
;     254 		}
;     255         
;     256     }
;     257 	
;     258     //SetBitMask(ControlReg,0x80);           //timer stops
;     259     //mfrc522_write(cmdReg, PCD_IDLE); 
;     260 
;     261     return status;   
;     262 }              
;     263 
;     264 
;     265 unsigned char MFRC_REQUEST(unsigned char req_mode, unsigned char * tag_type)
;     266 {
;     267 	unsigned char  status;  
;     268 	unsigned long backBits;//The received data bits
;     269 
;     270 	MFRC_WRITE(0x0D, 0x07);//TxLastBists = BitFramingReg[2..0]	???
;     271 	
;     272 	tag_type[0] = req_mode;
;     273 	status = MFRC_TO_CARD(0x0C, tag_type, 1, tag_type, &backBits);
;     274 
;     275 	if ((status != CARD_FOUND) || (backBits != 0x10))
;     276 	{    
;     277 		status = ERROR;
;     278 	}
;     279    
;     280 	return status;
;     281 }
;     282 */
;     283 
;     284 
;     285 /*****************************************************
;     286 CLCD FUNCTION
;     287 *****************************************************/
;     288 
;     289 void COM_WRITE(unsigned char REG){
_COM_WRITE:
;     290     RS = 0;
;	REG -> Y+0
	CBI  0x15,2
;     291     RW = 0;
	RCALL SUBOPT_0x5
;     292     E = 1; 
;     293     delay_us(50);   
;     294     PORTD = REG;
;     295     delay_us(50);
;     296     E = 0;
;     297 }              
	RJMP _0x16
;     298 
;     299 void DATA_WRITE(unsigned char DATA){
_DATA_WRITE:
;     300     RS = 1;
;	DATA -> Y+0
	SBI  0x15,2
;     301     RW = 0;
	RCALL SUBOPT_0x5
;     302     E = 1; 
;     303     delay_us(50);   
;     304     PORTD = DATA;
;     305     delay_us(50);
;     306     E = 0;
;     307 }     
_0x16:
	ADIW R28,1
	RET
;     308 
;     309 void LCD_CHAR(unsigned char col, unsigned char row, unsigned char ch){
;     310     COM_WRITE(0x80|(row + col*0x40));
;	col -> Y+2
;	row -> Y+1
;	ch -> Y+0
;     311     
;     312     DATA_WRITE(ch);
;     313     delay_ms(1);
;     314 }
;     315 
;     316 void LCD_STR(unsigned char col, unsigned char row, unsigned char *str){
_LCD_STR:
;     317     COM_WRITE(0x80|(row + col*0x40));
;	col -> Y+3
;	row -> Y+2
;	*str -> Y+0
	LDD  R30,Y+3
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	LDD  R26,Y+2
	ADD  R30,R26
	ORI  R30,0x80
	RCALL SUBOPT_0x6
;     318     
;     319     while(*str != 0){
_0x7:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x9
;     320         DATA_WRITE(*str);
	ST   -Y,R30
	RCALL _DATA_WRITE
;     321         str++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
;     322     }
	RJMP _0x7
_0x9:
;     323 }
	ADIW R28,4
	RET
;     324 
;     325 void LCD_CLEAR(void){
_LCD_CLEAR:
;     326     COM_WRITE(0x01);
	RCALL SUBOPT_0x2
	RCALL _COM_WRITE
;     327     delay_ms(2);
	RCALL SUBOPT_0x7
;     328 }
	RET
;     329 
;     330 /*****************************************************
;     331 8bit mode = 0, 4bit mode = 1
;     332 *****************************************************/
;     333 void LCD_INIT(int mode){                              
_LCD_INIT:
;     334     if(mode == 0)
;	mode -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0xA
;     335     {
;     336         COM_WRITE(0x38);
	RCALL SUBOPT_0x8
;     337         delay_ms(2);
	RCALL SUBOPT_0x7
;     338         COM_WRITE(0x38);
	RCALL SUBOPT_0x8
;     339         delay_ms(2);
	RCALL SUBOPT_0x7
;     340         COM_WRITE(0x38);
	RCALL SUBOPT_0x8
;     341         delay_ms(2);
	RCALL SUBOPT_0x7
;     342         COM_WRITE(0x0E);
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x6
;     343         delay_ms(2);
	RCALL SUBOPT_0x7
;     344         COM_WRITE(0x06);
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x6
;     345         delay_ms(2);
	RCALL SUBOPT_0x7
;     346         LCD_CLEAR();
	RCALL _LCD_CLEAR
;     347     }   
;     348     
;     349     if(mode == 1)
_0xA:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0xB
;     350     {
;     351         COM_WRITE(0x38);
	RCALL SUBOPT_0x8
;     352         delay_ms(2);
	RCALL SUBOPT_0x7
;     353         COM_WRITE(0x38);
	RCALL SUBOPT_0x8
;     354         delay_ms(2);
	RCALL SUBOPT_0x7
;     355         COM_WRITE(0x38);
	RCALL SUBOPT_0x8
;     356         delay_ms(2);
	RCALL SUBOPT_0x7
;     357         COM_WRITE(0x0E);
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x6
;     358         delay_ms(2);
	RCALL SUBOPT_0x7
;     359         COM_WRITE(0x06);
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x6
;     360         delay_ms(2);
	RCALL SUBOPT_0x7
;     361         LCD_CLEAR();
	RCALL _LCD_CLEAR
;     362     }
;     363 }    
_0xB:
_0x15:
	ADIW R28,2
	RET
;     364 
;     365 void main(void)
;     366 {
_main:
;     367     unsigned char str1[] = "RFID-TEST...";
;     368     unsigned char str2[] = "RFID-RC522";
;     369     unsigned char str3[] = "Reset Clear";
;     370     unsigned char str4[] = "FIFO Read...";
;     371     unsigned char str5[] = "Version 1.0";
;     372     unsigned char str6[] = "Version 2.0";
;     373     unsigned char str7[] = "No Detect  ";
;     374     
;     375     unsigned char byte = 0;
;     376     unsigned char SelfTestBuffer[64] = {0};
;     377          
;     378     delay_ms(1000);
	SBIW R28,63
	SBIW R28,63
	SBIW R28,23
	LDI  R24,149
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xC*2)
	LDI  R31,HIGH(_0xC*2)
	RCALL __INITLOCB
;	str1 -> Y+136
;	str2 -> Y+125
;	str3 -> Y+113
;	str4 -> Y+100
;	str5 -> Y+88
;	str6 -> Y+76
;	str7 -> Y+64
;	byte -> R16
;	SelfTestBuffer -> Y+0
	LDI  R16,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x9
	RCALL _delay_ms
;     379 
;     380     DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
;     381     DDRC = 0xFF;
	OUT  0x14,R30
;     382     DDRB = 0xEF;  //SS(Out) MOSI(In) MISO(Out) SCK(Out)
	LDI  R30,LOW(239)
	OUT  0x17,R30
;     383         
;     384     LCD_INIT(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x9
	RCALL _LCD_INIT
;     385     
;     386     SPI_INIT();
	RCALL _SPI_INIT
;     387         
;     388     MFRC_INIT(); 
	RCALL _MFRC_INIT
;     389         
;     390     /*
;     391     MFRC_RESET();
;     392     for(byte = 0; byte < 25; byte++){
;     393         MFRC_WRITE(0x09,0x00);   //FIFODataReg
;     394     }
;     395 
;     396     MFRC_WRITE(0x01,0x01);
;     397     MFRC_WRITE(0x36,0x09);
;     398     MFRC_WRITE(0x09,0x00);
;     399     MFRC_WRITE(0x01,0x03);
;     400     
;     401     for(byte = 0; byte<	64; byte++)
;     402     {
;     403         SelfTestBuffer[byte] = MFRC_READ(0x09);       
;     404         LCD_CHAR(0, 3, SelfTestBuffer[byte]);
;     405         delay_ms(1500);
;     406     }	
;     407     */
;     408     
;     409     delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x9
	RCALL _delay_ms
;     410     byte = MFRC_READ(0x37);
	LDI  R30,LOW(55)
	ST   -Y,R30
	RCALL _MFRC_READ
	MOV  R16,R30
;     411     delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x9
	RCALL _delay_ms
;     412     
;     413     while (1)
_0xD:
;     414     {
;     415         if(byte == 0x92)
	CPI  R16,146
	BRNE _0x10
;     416         {               
;     417             LCD_STR(0,0,str1);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xA
;     418             LCD_STR(1,0,str5);
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(90))
	SBCI R31,HIGH(-(90))
	RJMP _0x17
;     419         }
;     420         
;     421         else if(byte == 0x91)
_0x10:
	CPI  R16,145
	BRNE _0x12
;     422         {
;     423             LCD_STR(0,0,str1);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xA
;     424             LCD_STR(1,0,str6);
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(78))
	SBCI R31,HIGH(-(78))
	RJMP _0x17
;     425         }
;     426        
;     427         else
_0x12:
;     428         {
;     429             LCD_STR(0,0,str1);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xA
;     430             LCD_STR(1,0,str7);
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(66))
	SBCI R31,HIGH(-(66))
_0x17:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCD_STR
;     431         }                     
;     432     };
	RJMP _0xD
;     433 }
_0x14:
	RJMP _0x14


;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CBI  0x18,2
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	RJMP _SPI_TRANSMIT

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _MFRC_WRITE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	CBI  0x15,1
	SBI  0x15,0
	__DELAY_USW 200
	LD   R30,Y
	OUT  0x12,R30
	__DELAY_USW 200
	CBI  0x15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	RJMP _COM_WRITE

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(56)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(138))
	SBCI R31,HIGH(-(138))
	RCALL SUBOPT_0x9
	RCALL _LCD_STR
	RJMP SUBOPT_0x2

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
