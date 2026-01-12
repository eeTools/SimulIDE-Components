
IoPin@ csPin = component.getPin("CS");

bool m_enabled;
uint m_steps = 256;
double m_resistance = 100000;

enum pinMode_t{
    undef_mode=0,
    input,
    openCo,
    output,
    source
};

enum spiMode_t{
    SPI_OFF=0,
    SPI_MASTER,
    SPI_SLAVE
};

void setup()
{
    print("script SPI setup() OK"); 
}

void reset()
{
    m_enabled = true;
    
    csPin.setPinMode( input );
    csPin.changeCallBack( element, true );
    
    spi.setMode( SPI_SLAVE );
}

void voltChanged() // Called at csPin changed
{
    bool enabled = !csPin.getInpState();
    if( m_enabled == enabled ) return;
    m_enabled = enabled;
    
    if( enabled ) spi.setMode( SPI_SLAVE );
    else          spi.setMode( SPI_OFF );
}

void byteReceived( uint d )
{
    print("script SPI byte received "+d ); 
}

