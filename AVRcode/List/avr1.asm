
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _chuc=R4
	.DEF _dvi=R6
	.DEF _T1=R8
	.DEF _T2=R10
	.DEF _iop=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ngat0
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x52:
	.DB  0xF0,0x0,0xBE,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x08
	.DW  _0x52*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;#define ADC_VREF_TYPE 0x00
;// Declare your global variables here
;unsigned long ADC_out=0;
;unsigned int chuc, dvi;
;unsigned long nhietdo;
;unsigned long dienap;
;unsigned long dem=0;
;unsigned int T1=240;
;unsigned int T2=190;
;int iop;
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 001B {

	.CSEG
_read_adc:
; 0000 001C ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 001D // Delay needed for the stabilization of the ADC input voltage
; 0000 001E delay_us(10);
	__DELAY_USB 27
; 0000 001F // Start the AD conversion
; 0000 0020 ADCSRA|=0x40; //ADCSRA=ADCSRA | 0x40;
	SBI  0x6,6
; 0000 0021 // Wait for the AD conversion to complete
; 0000 0022 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0023 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0024 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2060001
; 0000 0025 }
;
;//UART
;void uart_char_send(unsigned char chr){
; 0000 0028 void uart_char_send(unsigned char chr){
_uart_char_send:
; 0000 0029     while (!(UCSRA &(1<<UDRE))) {};
;	chr -> Y+0
_0x6:
	SBIS 0xB,5
	RJMP _0x6
; 0000 002A         UDR=chr;
	LD   R30,Y
	OUT  0xC,R30
; 0000 002B }
_0x2060001:
	ADIW R28,1
	RET
;
;void uart_string_send(unsigned char *txt){
; 0000 002D void uart_string_send(unsigned char *txt){
; 0000 002E     unsigned char n, i;
; 0000 002F     n=strlen(txt);
;	*txt -> Y+2
;	n -> R17
;	i -> R16
; 0000 0030         for (i=0; i<n; i++){
; 0000 0031         uart_char_send(txt[i]);
; 0000 0032         }
; 0000 0033 }
;//Ngat nhan UART cho mot ky tu
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0036 {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0037 char data;
; 0000 0038 data=UDR;
	ST   -Y,R17
;	data -> R17
	IN   R17,12
; 0000 0039 if(data == '1'){
	CPI  R17,49
	BRNE _0xC
; 0000 003A     PORTC.0=0x01; }
	SBI  0x15,0
; 0000 003B if(data == 'q'){
_0xC:
	CPI  R17,113
	BRNE _0xF
; 0000 003C     PORTC.0=0x00; }
	CBI  0x15,0
; 0000 003D if(data == '2'){
_0xF:
	CPI  R17,50
	BRNE _0x12
; 0000 003E     PORTC.1=0x01; }
	SBI  0x15,1
; 0000 003F if(data == 'w'){
_0x12:
	CPI  R17,119
	BRNE _0x15
; 0000 0040     PORTC.1=0x00; }
	CBI  0x15,1
; 0000 0041 if(data == '3'){
_0x15:
	CPI  R17,51
	BRNE _0x18
; 0000 0042     PORTC.2=0x01; }
	SBI  0x15,2
; 0000 0043 if(data == 'e'){
_0x18:
	CPI  R17,101
	BRNE _0x1B
; 0000 0044     PORTC.2=0x00; }
	CBI  0x15,2
; 0000 0045 if(data == '4'){
_0x1B:
	CPI  R17,52
	BRNE _0x1E
; 0000 0046     PORTC.3=0x01; }
	SBI  0x15,3
; 0000 0047 if(data == 'r'){
_0x1E:
	CPI  R17,114
	BRNE _0x21
; 0000 0048     PORTC.3=0x00; }
	CBI  0x15,3
; 0000 0049 if(data == '5'){
_0x21:
	CPI  R17,53
	BRNE _0x24
; 0000 004A     PORTC.4=0x01; }
	SBI  0x15,4
; 0000 004B if(data == 't'){
_0x24:
	CPI  R17,116
	BRNE _0x27
; 0000 004C     PORTC.4=0x00; }
	CBI  0x15,4
; 0000 004D if(data == '6'){
_0x27:
	CPI  R17,54
	BRNE _0x2A
; 0000 004E     PORTC.5=0x01; }
	SBI  0x15,5
; 0000 004F if(data == 'y'){
_0x2A:
	CPI  R17,121
	BRNE _0x2D
; 0000 0050     PORTC.5=0x00; }
	CBI  0x15,5
; 0000 0051 if(data == '7'){
_0x2D:
	CPI  R17,55
	BRNE _0x30
; 0000 0052     PORTC.6=0x01; }
	SBI  0x15,6
; 0000 0053 if(data == 'u'){
_0x30:
	CPI  R17,117
	BRNE _0x33
; 0000 0054     PORTC.6=0x00; }
	CBI  0x15,6
; 0000 0055 if(data == '8'){
_0x33:
	CPI  R17,56
	BRNE _0x36
; 0000 0056     PORTC.7=0x01; }
	SBI  0x15,7
; 0000 0057 if(data == 'i'){
_0x36:
	CPI  R17,105
	BRNE _0x39
; 0000 0058     PORTC.7=0x00; }
	CBI  0x15,7
; 0000 0059 //Timer 1
; 0000 005A if(data =='x')
_0x39:
	CPI  R17,120
	BRNE _0x3C
; 0000 005B     {iop=0;}
	CLR  R12
	CLR  R13
; 0000 005C if(data == 'c')
_0x3C:
	CPI  R17,99
	BRNE _0x3D
; 0000 005D     {iop=1;}
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 005E if(data == 'a')//500ms
_0x3D:
	CPI  R17,97
	BRNE _0x3E
; 0000 005F     {
; 0000 0060     T1=240;
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	MOVW R8,R30
; 0000 0061     T2=190;
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	MOVW R10,R30
; 0000 0062     }
; 0000 0063 if(data == 's')//1000ms
_0x3E:
	CPI  R17,115
	BRNE _0x3F
; 0000 0064     {
; 0000 0065     T1=225;
	LDI  R30,LOW(225)
	LDI  R31,HIGH(225)
	MOVW R8,R30
; 0000 0066     T2=124;
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	MOVW R10,R30
; 0000 0067     }
; 0000 0068 if(data == 'd')//1500ms
_0x3F:
	CPI  R17,100
	BRNE _0x40
; 0000 0069     {
; 0000 006A     T1=210;
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	MOVW R8,R30
; 0000 006B     T2=58;
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	MOVW R10,R30
; 0000 006C     }
; 0000 006D if(data == 'f')//2000ms
_0x40:
	CPI  R17,102
	BRNE _0x41
; 0000 006E     {
; 0000 006F     T1=194;
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	MOVW R8,R30
; 0000 0070     T2=248;
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	MOVW R10,R30
; 0000 0071     }
; 0000 0072 if(data == 'g')//2500ms
_0x41:
	CPI  R17,103
	BRNE _0x42
; 0000 0073     {
; 0000 0074     T1=179;
	LDI  R30,LOW(179)
	LDI  R31,HIGH(179)
	MOVW R8,R30
; 0000 0075     T2=180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	MOVW R10,R30
; 0000 0076     }
; 0000 0077 if(data == 'h')//3000ms
_0x42:
	CPI  R17,104
	BRNE _0x43
; 0000 0078     {
; 0000 0079     T1=163;
	LDI  R30,LOW(163)
	LDI  R31,HIGH(163)
	MOVW R8,R30
; 0000 007A     T2=115;
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	MOVW R10,R30
; 0000 007B     }
; 0000 007C if(data == 'j')//3500ms
_0x43:
	CPI  R17,106
	BRNE _0x44
; 0000 007D     {
; 0000 007E     T1=149;
	LDI  R30,LOW(149)
	LDI  R31,HIGH(149)
	MOVW R8,R30
; 0000 007F     T2=49;
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	MOVW R10,R30
; 0000 0080     }
; 0000 0081 if(data == 'k')//4000ms
_0x44:
	CPI  R17,107
	BRNE _0x45
; 0000 0082     {
; 0000 0083     T1=133;
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	MOVW R8,R30
; 0000 0084     T2=239;
	LDI  R30,LOW(239)
	LDI  R31,HIGH(239)
	MOVW R10,R30
; 0000 0085     }
; 0000 0086 if(data == 'l')//4500ms
_0x45:
	CPI  R17,108
	BRNE _0x46
; 0000 0087     {
; 0000 0088     T1=118;
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	MOVW R8,R30
; 0000 0089     T2=171;
	LDI  R30,LOW(171)
	LDI  R31,HIGH(171)
	MOVW R10,R30
; 0000 008A     }
; 0000 008B if(data == 'z')//5000ms
_0x46:
	CPI  R17,122
	BRNE _0x47
; 0000 008C     {
; 0000 008D     T1=103;
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	MOVW R8,R30
; 0000 008E     T2=190;
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	MOVW R10,R30
; 0000 008F     }
; 0000 0090 }
_0x47:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ngat0(void)
; 0000 0093 {
_ngat0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0094 // Place your code here
; 0000 0095     dem+=1;
	LDS  R30,_dem
	LDS  R31,_dem+1
	LDS  R22,_dem+2
	LDS  R23,_dem+3
	__ADDD1N 1
	STS  _dem,R30
	STS  _dem+1,R31
	STS  _dem+2,R22
	STS  _dem+3,R23
; 0000 0096     chuc=(dem%100)/10;
	CALL SUBOPT_0x0
	__GETD1N 0x64
	CALL __MODD21U
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x1
	CALL __DIVD21U
	MOVW R4,R30
; 0000 0097     dvi=dem%10;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
; 0000 0098     uart_char_send(chuc + 0x30);
; 0000 0099     uart_char_send(dvi + 0x30);
; 0000 009A     uart_char_send(13);
	CALL SUBOPT_0x3
; 0000 009B     delay_ms(200);
; 0000 009C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 009F {
_timer1_ovf_isr:
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A0     if(iop == 0){
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x48
; 0000 00A1         PORTB.1 = 0x00;}
	CBI  0x18,1
; 0000 00A2     if(iop == 1){
_0x48:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x4B
; 0000 00A3         PORTB.1 = ~PORTB.1;
	SBIS 0x18,1
	RJMP _0x4C
	CBI  0x18,1
	RJMP _0x4D
_0x4C:
	SBI  0x18,1
_0x4D:
; 0000 00A4         TCNT1H=T1;
	OUT  0x2D,R8
; 0000 00A5         TCNT1L=T2;}
	OUT  0x2C,R10
; 0000 00A6 }
_0x4B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
;void main(void)
; 0000 00A8 {
_main:
; 0000 00A9 // Declare your local variables here
; 0000 00AA 
; 0000 00AB // Input/Output Ports initialization
; 0000 00AC // Port A initialization
; 0000 00AD // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AF PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00B0 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00B1 
; 0000 00B2 // Port B initialization
; 0000 00B3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00B4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B5 PORTB=0x00;
	OUT  0x18,R30
; 0000 00B6 DDRB=0x00;
	OUT  0x17,R30
; 0000 00B7 
; 0000 00B8 // Port C initialization
; 0000 00B9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00BA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00BB PORTC=0x00;
	OUT  0x15,R30
; 0000 00BC DDRC=0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00BD 
; 0000 00BE // Port D initialization
; 0000 00BF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C1 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00C2 DDRD=0xfe;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 00C3 
; 0000 00C4 // Timer/Counter 0 initialization
; 0000 00C5 // Clock source: System Clock
; 0000 00C6 // Clock value: Timer 0 Stopped
; 0000 00C7 // Mode: Normal top=0xFF
; 0000 00C8 // OC0 output: Disconnected
; 0000 00C9 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00CA TCNT0=0x00;
	OUT  0x32,R30
; 0000 00CB OCR0=0x00;
	OUT  0x3C,R30
; 0000 00CC 
; 0000 00CD //Timer 1
; 0000 00CE TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 00CF TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 00D0 TCNT1H=T1;//0xc2
	OUT  0x2D,R8
; 0000 00D1 TCNT1L=T2;//0xf6
	OUT  0x2C,R10
; 0000 00D2 
; 0000 00D3 // Timer/Counter 2 initialization
; 0000 00D4 // Clock source: System Clock
; 0000 00D5 // Clock value: Timer2 Stopped
; 0000 00D6 // Mode: Normal top=0xFF
; 0000 00D7 // OC2 output: Disconnected
; 0000 00D8 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 00D9 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00DA TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DB OCR2=0x00;
	OUT  0x23,R30
; 0000 00DC 
; 0000 00DD // External Interrupt(s) initialization
; 0000 00DE // INT0: On
; 0000 00DF // INT0 Mode: Falling Edge
; 0000 00E0 // INT1: Off
; 0000 00E1 // INT2: Off
; 0000 00E2 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00E3 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 00E4 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00E5 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00E6 
; 0000 00E7 // USART initialization
; 0000 00E8 // Communication Parameters:
; 0000 00E9 //8 Data, 1 Stop, No Parity
; 0000 00EA // USART Receiver: On
; 0000 00EB // USART Transmitter: On
; 0000 00EC // USART Mode: Asynchronous
; 0000 00ED // USART Baud Rate: 9600
; 0000 00EE UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00EF UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00F0 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00F1 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00F2 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00F3 
; 0000 00F4 // Analog Comparator initialization
; 0000 00F5 // Analog Comparator: Off
; 0000 00F6 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00F7 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F8 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F9 
; 0000 00FA // ADC initialization
; 0000 00FB // ADC Clock frequency: 1000.000 kHz
; 0000 00FC // ADC Voltage Reference: AREF pin
; 0000 00FD // ADC Auto Trigger Source: ADC Stopped
; 0000 00FE ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00FF ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0100 
; 0000 0101 // SPI initialization
; 0000 0102 // SPI disabled
; 0000 0103 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 0104 
; 0000 0105 // TWI initialization
; 0000 0106 // TWI disabled
; 0000 0107 TWCR=0x00;
	OUT  0x36,R30
; 0000 0108 
; 0000 0109 GICR|=0xC0; //GICR = GICR|0xC0
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 010A MCUCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x35,R30
; 0000 010B 
; 0000 010C // Global enable interrupts
; 0000 010D #asm("sei")
	sei
; 0000 010E while (1)
_0x4E:
; 0000 010F       {
; 0000 0110         ADC_out=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	CLR  R22
	CLR  R23
	STS  _ADC_out,R30
	STS  _ADC_out+1,R31
	STS  _ADC_out+2,R22
	STS  _ADC_out+3,R23
; 0000 0111         dienap = ADC_out*5000/1023;
	__GETD2N 0x1388
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	CALL __DIVD21U
	STS  _dienap,R30
	STS  _dienap+1,R31
	STS  _dienap+2,R22
	STS  _dienap+3,R23
; 0000 0112         nhietdo=dienap/10;
	LDS  R26,_dienap
	LDS  R27,_dienap+1
	LDS  R24,_dienap+2
	LDS  R25,_dienap+3
	CALL SUBOPT_0x1
	CALL __DIVD21U
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 0113         chuc=nhietdo/10;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1
	CALL __DIVD21U
	MOVW R4,R30
; 0000 0114         dvi=nhietdo%10;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x2
; 0000 0115         uart_char_send(chuc + 0x30);
; 0000 0116         uart_char_send(dvi + 0x30);
; 0000 0117         uart_char_send(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _uart_char_send
; 0000 0118         uart_char_send(13);
	CALL SUBOPT_0x3
; 0000 0119         delay_ms(200);
; 0000 011A }
	RJMP _0x4E
; 0000 011B }
_0x51:
	RJMP _0x51

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG
_ADC_out:
	.BYTE 0x4
_nhietdo:
	.BYTE 0x4
_dienap:
	.BYTE 0x4
_dem:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R26,_dem
	LDS  R27,_dem+1
	LDS  R24,_dem+2
	LDS  R25,_dem+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	RCALL SUBOPT_0x1
	CALL __MODD21U
	MOVW R6,R30
	MOV  R30,R4
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _uart_char_send
	MOV  R30,R6
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _uart_char_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _uart_char_send
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

;END OF CODE MARKER
__END_OF_CODE:
