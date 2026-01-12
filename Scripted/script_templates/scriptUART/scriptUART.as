
IoPin@  txPin = component.getPin("Tx");

enum pinModes{
    undef_mode=0, 
    input,
    openCo,
    output,
    source
}

const int BAUDRATE = 9600;

void setup() // Executed when Component is created
{
    print("Serial setup() OK"); 
}

void reset() // Executed at Simulation start
{
    print("Serial reset()");
    
    Uart0.setBaudRate( BAUDRATE );
    
    txPin.setOutState( true );
    txPin.setPinMode( output );
}

void frameSent( uint data )
{
    print( "frameSent "+data );
}

void byteReceived( uint data )
{
    print( "byte Received "+data );
}

