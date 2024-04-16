
// PinModes: undef_mode=0, input, openCo, output, source

IoPort@ PortA = component.getPort("PORTA");
IoPort@ PortB = component.getPort("PORTB");
IoPort@ PortS = component.getPort("PORTS");
IoPort@ PortF = component.getPort("PORTF");

IoPin@  mPin  = component.getPin("M");
IoPin@  cnPin = component.getPin("Cn");
IoPin@  c4Pin = component.getPin("Cn4");
IoPin@  abPin = component.getPin("AB");
IoPin@  gPin  = component.getPin("G");
IoPin@  pPin  = component.getPin("P");

uint8 m_f;
uint8 m_eventPin;
bool m_cO;
bool m_ab;

void setup()
{
    print("74181 init ");
}

void reset()
{ 
    print("resetting 74181");
    
    m_f = 0;
    m_eventPin = 0;
    m_cO = false;
    m_ab = false;
    
    PortA.setPinMode( 1 ); // Input
    PortB.setPinMode( 1 ); // Input
    PortS.setPinMode( 1 ); // Input
    PortF.setPinMode( 3 ); // Output
    PortF.setOutState( 0 );
    
    mPin.setPinMode( 1 );   // Input
    cnPin.setPinMode( 1 );  // Input
    c4Pin.setPinMode( 3 );  // Output
    c4Pin.setVoltage( 0 );
    abPin.setPinMode( 3 );  // Output
    abPin.setVoltage( 0 );
    gPin.setPinMode( 3 );   // Output
    gPin.setVoltage( 0 );
    pPin.setPinMode( 3 );   // Output
    pPin.setVoltage( 0 );
    
    PortA.changeCallBack( element, true ); // Register for Input Port voltage changes
    PortB.changeCallBack( element, true ); // Register for Input Port voltage changes
    PortS.changeCallBack( element, true ); // Register for Input Port voltage changes
    
    cnPin.changeCallBack( element, true ); // Register for Input Port voltage changes
    mPin.changeCallBack( element, true );  // Register for Input Port voltage changes
}

void voltChanged()
{
    uint8 A = ~PortA.getInpState() & 0x0F;
    uint8 B = ~PortB.getInpState() & 0x0F;
    uint8 op = PortS.getInpState();
    
    bool carryOut = !cnPin.getInpState();
    uint8 Cn = carryOut ? 1 : 0;
    
    bool logicOp = mPin.getInpState();

    
    uint8 f = 0;
    if( logicOp ){        // Logic
        switch( op ){
            case 0:  f = ~A&0x0F;       break;
            case 1:  f = ~(A | B)&0x0F; break;
            case 2:  f = ~A&0x0F & B;   break;
            case 3:  f = 0;             break;
            case 4:  f = ~(A & B)&0x0F; break;
            case 5:  f = ~B&0x0F;       break;
            case 6:  f = A ^ B;         break;
            case 7:  f = A & ~B&0x0F;   break;
            case 8:  f = ~A&0x0F | B;   break;
            case 9:  f = ~(A ^ B)&0x0F; break;
            case 10: f = B;             break;
            case 11: f = A & B;         break;
            case 12: f = 0x0F;          break;
            case 13: f = A | ~B&0x0F;   break;
            case 14: f = A | B;         break;
            case 15: f = A;             break;
        }
    }else{                 // Arithmetic
        
        switch( op ){
            case 0:  f = A;                         break;
            case 1:  f = (A | B);                   break;
            case 2:  f = (A | (~B&0x0F))  ;         break;
            case 3:  f = 0x0F;                      break;
            case 4:  f = A + (A & (~B&0x0F));       break;
            case 5:  f = (A | B) + (A & (~B&0x0F)); break;
            case 6:  f = A - B + 0x0F;              break;
            case 7:  f = (A & (~B&0x0F)) + 0x0F;    break;
            case 8:  f = A + (A & B);               break;
            case 9:  f = A + B;                     break;
            case 10: f = (A | (~B&0x0F)) + (A & B); break;
            case 11: f = (A & B) + 0x0F;            break;
            case 12: f = A + A;                     break;
            case 13: f = (A | B) + A;               break;
            case 14: f = (A | (~B&0x0F)) + A;       break;
            case 15: f = A + 0x0F;                  break;
        }
        f += Cn;
        carryOut = (f & 16) > 0;
    }
    f = ~f;
    
    bool ab = (f&0x0F) == 0x00;
    //m_eventPin = 0;
    if( m_f != f )
    {
        m_f = f;
        PortF.setOutState( f );
        //m_eventPin += 1;
    }
    if( m_cO != carryOut)
    {
        m_cO = carryOut;
        c4Pin.setOutState( !carryOut );
        //m_eventPin += 2;
    }
    if( m_ab != ab )
    {
        m_ab = ab;
        abPin.setOutState( ab );
        //m_eventPin += 4;
    }
    /*if( m_eventPin > 0 )
    {
        component.cancelEvents();
        component.addEvent( 50*1e3 );
    }*/

    //print("74181 op = "+op+" Logic = "+logicOp+" A = "+A+" B = "+B+" F = "+f );
}

/*void runEvent()  // Encode Pin to change in m_eventPin
{
    if( m_eventPin&1 > 0 ) PortF.setOutState( m_f );
    if( m_eventPin&2 > 0 ) c4Pin.setOutState( !m_cO );
    if( m_eventPin&4 > 0 ) abPin.setOutState( m_ab );
}*/