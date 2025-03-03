/*****************************************************
Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>
#define ADC_VREF_TYPE 0x00
// Declare your global variables here
unsigned long ADC_out=0;
unsigned int chuc, dvi;
unsigned long nhietdo;
unsigned long dienap;
unsigned long dem=0;
unsigned int T1=240;
unsigned int T2=190;
int iop; 

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40; //ADCSRA=ADCSRA | 0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

//UART
void uart_char_send(unsigned char chr){
    while (!(UCSRA &(1<<UDRE))) {};
        UDR=chr;
}

void uart_string_send(unsigned char *txt){
    unsigned char n, i;
    n=strlen(txt);
        for (i=0; i<n; i++){
        uart_char_send(txt[i]);
        }
}
//Ngat nhan UART cho mot ky tu
interrupt [USART_RXC] void usart_rx_isr(void)
{
char data;
data=UDR;
if(data == '1'){
    PORTC.0=0x01; }
if(data == 'q'){
    PORTC.0=0x00; }
if(data == '2'){
    PORTC.1=0x01; }
if(data == 'w'){
    PORTC.1=0x00; }
if(data == '3'){
    PORTC.2=0x01; }
if(data == 'e'){
    PORTC.2=0x00; }
if(data == '4'){
    PORTC.3=0x01; }
if(data == 'r'){
    PORTC.3=0x00; }
if(data == '5'){
    PORTC.4=0x01; }
if(data == 't'){
    PORTC.4=0x00; }
if(data == '6'){
    PORTC.5=0x01; }
if(data == 'y'){
    PORTC.5=0x00; }
if(data == '7'){
    PORTC.6=0x01; }
if(data == 'u'){
    PORTC.6=0x00; }
if(data == '8'){
    PORTC.7=0x01; }
if(data == 'i'){
    PORTC.7=0x00; }
//Timer 1
if(data =='x')  
    {iop=0;} 
if(data == 'c')
    {iop=1;}
if(data == 'a')//500ms
    {
    T1=240;
    T2=190;
    }
if(data == 's')//1000ms
    {
    T1=225;
    T2=124;
    }
if(data == 'd')//1500ms
    {
    T1=210;
    T2=58;
    }
if(data == 'f')//2000ms
    {
    T1=194;
    T2=248;
    }
if(data == 'g')//2500ms
    {
    T1=179;
    T2=180;
    }
if(data == 'h')//3000ms
    {
    T1=163;
    T2=115;
    }
if(data == 'j')//3500ms
    {
    T1=149;
    T2=49;
    }
if(data == 'k')//4000ms
    {
    T1=133;
    T2=239;
    }
if(data == 'l')//4500ms
    {
    T1=118;
    T2=171;
    }
if(data == 'z')//5000ms
    {
    T1=103;
    T2=190;
    }
}
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ngat0(void)
{
// Place your code here
    dem+=1;
    chuc=(dem%100)/10;
    dvi=dem%10;
    uart_char_send(chuc + 0x30);
    uart_char_send(dvi + 0x30);
    uart_char_send(13);
    delay_ms(200); 
}
// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    if(iop == 0){
        PORTB.1 = 0x00;}
    if(iop == 1){
        PORTB.1 = ~PORTB.1;
        TCNT1H=T1;
        TCNT1L=T2;}
}
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0xff;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xfe;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

//Timer 1
TCCR1B=0x05;
TIMSK=0x04;
TCNT1H=T1;//0xc2
TCNT1L=T2;//0xf6

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// USART initialization
// Communication Parameters: 
//8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRC=0x86;
UCSRB=0x98; 
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

GICR|=0xC0; //GICR = GICR|0xC0
MCUCR=0x0F;

// Global enable interrupts
#asm("sei")
while (1)
      {
        ADC_out=read_adc(0);
        dienap = ADC_out*5000/1023;
        nhietdo=dienap/10;
        chuc=nhietdo/10;
        dvi=nhietdo%10;
        uart_char_send(chuc + 0x30);
        uart_char_send(dvi + 0x30);
        uart_char_send(10);
        uart_char_send(13);
        delay_ms(200);
}
}
