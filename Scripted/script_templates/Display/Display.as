
void setup()
{
    print("Dispaly init ");
}

void reset()
{ 
    print("resetting Display");
    
    screen.setBackground( 0xF0FFF0 );
    //clear();
    
    for( int y=10; y<230; y++ )
    {
        screen.setPixel( 10, y, 0x000055 );
    }
    
    for( int x=10; x<309; x++ )
    {
        screen.setPixel( x, 230-(x*x)/500, 0xCC5522 );
        screen.setPixel( x, 230, 0x000000 );
    }
}

void clear()
{
    screen.setBackground( 0 );
}