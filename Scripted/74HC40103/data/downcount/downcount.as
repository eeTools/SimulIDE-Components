
IoPort@ InputPort = component.getPort("PORTI");
IoPin@  outputPin = component.getPin("Out");
IoPin@  clockPin  = component.getPin("Clk");
IoPin@  loadPin   = component.getPin("Load");
IoPin@  resetPin  = component.getPin("Rst");

bool m_clkEdge;  // Clock Active edge
uint m_counter;

void setup()
{
    print("Down Counter init");
    m_clkEdge = true; // Clock Active at rising edge
}

void reset()
{
    print("resetting Down Counter"); 
    
    outputPin.setPinMode( 3 );  // Output
    outputPin.setVoltage( 5 ); 
    
    m_counter = 255;
    
    loadPin.changeCallBack( element, true );
    resetPin.changeCallBack( element, true );
}

void voltChanged() // Load counter value
{
    bool rst = resetPin.getInpState();
    //print("Rst "+rst); 
    if( rst ) { m_counter = 255; return; }
    
    bool ld = loadPin.getInpState();
    //print("Ld "+ld); 
    if( ld ) m_counter = InputPort.getInpState();
    //print("Counter "+m_counter); 
}

void extClock( bool clkState )  // Function called al clockPin change
{
    if( clkState != m_clkEdge ) return;

    if( m_counter > 0 )
    {
        m_counter--;
        if( m_counter == 0 ) outputPin.setVoltage( 0 ); // Out goes LOW when the count reaches zero
    }
    else outputPin.setVoltage( 5 ); // Out remains LOW for one full clock period
    
    //print("Counter "+m_counter); 
}