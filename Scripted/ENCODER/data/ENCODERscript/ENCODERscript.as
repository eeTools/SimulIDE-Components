
// PinModes: undef_mode=0, input, openCo, output, source

IoPort@  outputPort = component.getPort("PORTA");

uint m_value;
bool m_is16_bits;
bool m_changed;

void setup()
{
    print("ENCODER_script init");
    m_value = 0;
    m_is16_bits = true;
}

void reset()
{
    print("resetting ENCODER_script"); 
    
    outputPort.setPinMode( 3 );  // Output
    outputPort.setOutState( m_value ); 
}

void updateStep()
{
    if( !m_changed ) return;
    m_changed = false;
    
    outputPort.setOutState( m_value );
}

void setLinkedValue( double val, int i )
{
    // val = 0 to 
    m_value = uint(val);
    m_changed = true;
    //print("ENCODER_script setLinkedValue "+val);
}

void set16_bits( bool s )
{
    if( m_is16_bits == s ) return;
    m_is16_bits = s;
    
    uint bits = m_is16_bits ? 16 : 10;
    
    string stepsStr = formatUInt( bits );
    component.setPropStr( 0, "Steps", stepsStr );
    
    string maxValStr = formatUInt( bits-1 );
    component.setPropStr( 0, "Max_Val", maxValStr );
}

bool get16_bits()
{
    return m_is16_bits;
}

void setValue( uint v )
{
    m_value = v;
    
    string valueStr = formatUInt( m_value );
    component.setPropStr( 0, "Value", valueStr );
    
    m_changed = true;
    //print("ENCODER_script setValue "+v);
}

uint getValue()
{
    //print("ENCODER_script getValue "+m_value);
    return m_value;
}