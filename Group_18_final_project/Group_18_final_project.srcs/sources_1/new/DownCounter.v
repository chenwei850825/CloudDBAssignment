module DownCounter(
    output [11:0]ohour,
    output am_pm,
    output reg [5:0]ominute,
    output reg [5:0]osec,
    output beep,
    output [1:0]curstate,
    input clk,
    input rst,
    input set,
    input uphour,
    input downhour,
    input upminute,
    input downminute,
    input upsec,
    input downsec,
    input ok,
    input stop
    );
    
    reg [4:0] hour;
    wire [4:0]tmphour;
    wire minutecarry;
    wire hourcarry;
    
    
    assign minutecarry = ( osec <= 0 && nextstate == COUNT ) ? 1 : 0;
    assign hourcarry = ( ominute <= 0 && minutecarry ) ? 1 : 0;
    assign tmphour = ( hour > 12 ) ? hour - 12 : hour;
    
    assign ohour = ( tmphour == 0 ) ? 12'b000000000000:
                           ( tmphour == 1 ) ? 12'b000000000001:
                           ( tmphour == 2 ) ? 12'b000000000011:
                           ( tmphour == 3 ) ? 12'b000000000111:
                           ( tmphour == 4 ) ? 12'b000000001111:
                           ( tmphour == 5 ) ? 12'b000000011111:
                           ( tmphour == 6 ) ? 12'b000000111111:
                           ( tmphour == 7 ) ? 12'b000001111111:
                           ( tmphour == 8 ) ? 12'b000011111111:
                           ( tmphour == 9 ) ? 12'b000111111111:
                           ( tmphour == 10 ) ? 12'b001111111111:
                           ( tmphour == 11 ) ? 12'b011111111111:
                           ( tmphour == 12 ) ? 12'b111111111111: 0;
    assign am_pm = ( hour > 12 ) ? 1 : 0;
    assign beep = ( nextstate == RING ) ? 1 : 0;
    assign curstate[0] = ( state == SET ) ? 1 : 0;
    assign curstate[1] = 0;
    
    parameter IDLE = 0;
    parameter SET = 1;
    parameter COUNT = 2;
    parameter STOP = 3;
    parameter RING = 4;
    
    reg [2:0] state , nextstate;
    reg [4:0] nexthour;
    reg [5:0] nextminute, nextsec;
    
    
    always@ ( posedge clk, posedge rst ) begin
        if( rst ) begin
            state <= IDLE;
            hour <= 0;
            ominute <= 0;
            osec <= 0;
        end
        
        else begin
            state <= nextstate;
            hour <= nexthour;
            ominute <= nextminute;
            osec <=  nextsec;   
        end
    
    end
    
    always@ (*) begin
        case(state) 
        
            IDLE : begin
                nextstate = ( set ) ? SET : IDLE;
                nexthour = 0;
                nextminute = 0;
                nextsec = 0;
            end
            
            SET : begin
                nextstate = ( ok ) ? COUNT : SET;
                nexthour = ( uphour ) ? ( hour < 23 ) ? hour + 1 : 0 :
                                        ( downhour ) ? ( hour > 0 ) ? hour - 1 : 23 : 
                                        hour;
                            nextminute = ( upminute ) ? ( ominute <  59) ? ominute + 1 : 0 :
                                         ( downminute ) ? ( ominute > 0 ) ? ominute - 1 : 59 :
                                         ominute;
                            nextsec = ( upsec ) ? ( osec < 59 ) ? osec + 1 : 0 :
                                      ( downsec ) ? ( osec > 0 ) ? osec - 1 : 59 :
                                      osec;
                  
            end
            
            COUNT : begin
                nextstate = ( hour == 0  && ominute == 0 && osec == 0  ) ? RING : 
                            (ok) ? STOP : COUNT;
                nexthour = ( hourcarry ) ? ( hour > 0 ) ? hour - 1 : 23 : 
                                        hour;
                nextminute = ( minutecarry ) ? ( ominute > 0 ) ? ominute - 1 : 59 :
                                         ominute;
                nextsec = ( osec > 0 ) ? osec - 1 : 
                          ( hour == 0  && ominute == 0 && osec == 0 ) ? 0 : 59;
            end
            
            STOP : begin
                nextstate = ( ok ) ? COUNT : STOP;
                nexthour = hour;
                nextminute = ominute;
                nextsec = osec;          
            end
            
            RING :  begin
                nextstate = ( stop ) ? IDLE : RING;
                nexthour = 0;
                nextminute = 0;
                nextsec = 0;        
            end
            
            default : begin
                nextstate = IDLE;
                nexthour = 0;
                nextminute = 0;
                nextsec = 0;
             end
        
        endcase
    
    end
endmodule