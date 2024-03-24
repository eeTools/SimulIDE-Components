
// PinModes: undef_mode=0, input, openCo, output, source

IoPin@  outputPin = component.getPin("Out");

double m_volt;
bool m_changed;

void setup()
{
    print("LM35 init");
}

void reset()
{
    print("resetting LM35"); 
    
    outputPin.setPinMode( 3 );  // Output
    outputPin.setVoltage( 0 ); 
    
    m_volt = 0;
    m_changed = false;
}

void updateStep()
{
    if( !m_changed ) return;
    m_changed = false;
    
    string temp = formatFloat( m_volt*100, "", 4, 2 );
    temp += " Cº";
    component.setLinkedString( 0, temp, 0 );
}

void setLinkedValue( double val, int i )
{
    // val = 0 to 999
    // Temp = -55 to 150 ; diff = 205
    
    m_volt = -0.55 + val*2.05/1000;
    outputPin.setVoltage( m_volt );
    
    m_changed = true;
    //print("LM35 setLinkedValue "+volt);
}
