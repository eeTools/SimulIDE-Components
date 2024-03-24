
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
    
    byteReceived( 128 ); // Power-on preset to midscale
    
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
    
    //print("script SPI "+enabled); 
}

void byteReceived( uint d )
{
    double data = d*1000/(m_steps);       // data = 0 to 1000
    component.setLinkedValue( 0, data, 0 );
    
    //print("script SPI byte received "+d+" data "+data ); 
}

void setResistance( double res )
{
    if( res < 1e-6 ) return;
    m_resistance = res;
    component.setLinkedValue( 0, res, 1 );
    
    //print("script SPI setResistance "+res ); 
}

double getResistance()
{
    return m_resistance;
}
