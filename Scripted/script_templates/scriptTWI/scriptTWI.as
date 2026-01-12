
IoPin@ sdaPin = component.getPin("SDA");
IoPin@ sclPin = component.getPin("SCL");

IoPort@ addrPort = component.getPort("PORTA");

uint m_ctrlCode = 0x18;
uint m_address  = 0x18;
uint m_data;

enum pinMode_t{
    undef_mode=0,
    input,
    openCo,
    output,
    source
};

enum twiMode_t{
    TWI_OFF=0,
    TWI_MASTER,
    TWI_SLAVE
};

void setup()
{
    twi.setAddress( m_address );
    print("twi setup() OK"); 
}

void reset()
{
    sdaPin.setPinMode( openCo );
    sclPin.setPinMode( openCo );
    
    addrPort.setPinMode( input );
    addrPort.changeCallBack( element, true );
    
    twi.setMode( TWI_SLAVE );
}

void voltChanged() // Called at addrPort changed
{
    m_address = m_ctrlCode | addrPort.getInpState();
    twi.setAddress( m_address );
    print("twi Address changed "+m_address ); 
}

void byteReceived( uint d ) // Master sent byte
{
    print("twi byte received "+d ); 
}

uint slaveWrite() // Master is reading
{
    print("slaveWrite "+ m_data );
    
    return m_data; // return data to send
}

void setControl_Code( uint ctrlCode )
{
    m_ctrlCode = ctrlCode;
}

uint getControl_Code()
{
    return m_ctrlCode;
}

