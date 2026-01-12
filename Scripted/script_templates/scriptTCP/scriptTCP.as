

bool m_connected;

string m_received;

void setup() // Executed when Component is created
{
    print("tcp  setup() OK"); 
}

void reset() // Executed at Simulation start
{
    print("tcp reset()");

    m_received = "";
    
    m_connected = false;

    Wb_link.connectToHost( 0, "127.0.0.1", 10020 ); // Connect to host at Socket nº 0
}

void updateStep()
{
    if( !m_connected ) return;

    Wb_link.sendMsgToHost("Message", 0 ); // Send message to host at Socket nº 0
    
    // Wb_link.closeSocket( 0 ); // Closing Socket nº 0
}

void received( string msg, int link ) // Received message from host at Socket nº link
{
    if( msg == "\r\n") return;
    
    m_received = msg;
}

void tcpConnected( int link ) // We got connected to Socket nº link
{
    print("tcp Connected to " + link );

    m_connected = true;
}

void tcpDisconnected( int link ) // We got disconnected from Socket nº link
{
    print("tcp Disconnected from " + link );
    
    m_connected = false;
}
