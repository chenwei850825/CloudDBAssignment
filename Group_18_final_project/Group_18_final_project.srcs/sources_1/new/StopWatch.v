`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/12 10:03:39
// Design Name: 
// Module Name: StopWatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module StopWatch(
    output [11:0]ohour,
    output am_pm,
    output  [5:0]ominute,
    output  [5:0]osec,
    output beep,
    output [1:0]curstate,
    input clk,
    input rst,
    input set,
    input ok,
    input stop,
    input record
    );
    
    wire [4:0]hour;
    wire [4:0]tmphour;
    
    
    wire minutecarry;
    wire hourcarry;
        
    assign minutecarry = ( osec >= 59 ) ? 1 : 0;
    assign hourcarry = ( ominute >= 59 ) ? 1 : 0;
        
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
    assign beep = 0;
    assign curstate[0] = 0;
    assign curstate[1] = 0;
    
    
    parameter IDLE = 0;
    parameter COUNT = 1;
    parameter CHECK = 2;
    
    reg[1:0] state, nextstate;
    reg [4:0] ahour;
    reg [5:0] aminute, asec;
    reg [4:0] nextahour;
    reg [5:0] nextaminute, nextasec;
    reg [5:0] recordhour, nextrecordhour;
    reg [5:0] recordminute, nextrecordminute;
    reg [5:0] recordsec, nextrecordsec;
    
    assign hour = ( record ) ? recordhour : ahour;
    assign ominute = ( record ) ? recordminute : aminute;
    assign osec = ( record ) ? recordsec : asec;
    
    always@( posedge clk, posedge rst )begin
        if (rst)begin
            state <= IDLE;
            ahour <= 0;
            aminute <= 0;
            asec <= 0;
            recordhour <= 0;
            recordminute <= 0;
            recordsec <= 0;
        end        
        else begin
            state <= nextstate;
            ahour <= nextahour;
            aminute <= nextaminute;
            asec <= nextasec;
            recordhour <= nextrecordhour;
            recordminute <= nextrecordminute;
            recordsec <= nextrecordsec;
        end  
    end
    
    
    always@(*)begin
        case(state)
        IDLE:begin
            nextstate = ( ok ) ? COUNT : IDLE;
            nextahour = 0;
            nextaminute = 0;
            nextasec = 0;
            nextrecordhour =  0;
            nextrecordminute =  0;
            nextrecordsec =  0;
        end
        
        
        COUNT: begin
                    nextstate = ( stop ) ? IDLE : 
                                ( record) ? CHECK :
                                COUNT;
                    nextahour = ( hourcarry ) ? ( ahour < 23 ) ? ahour + 1 : 0 : 
                                ahour;
                    nextaminute = ( minutecarry ) ? ( aminute < 59 ) ? aminute + 1 : 0 :
                                 aminute;
                    nextasec = ( asec < 59 ) ? asec + 1 : 0;
                    nextrecordhour = ( ok ) ? ahour : recordhour;
                    nextrecordminute = ( ok ) ? aminute : recordminute;
                    nextrecordsec = ( ok ) ?  asec : recordsec; 
                                
        end        
        CHECK:begin        
            nextstate = ( record == 0 && ok ) ? COUNT : CHECK;                 
                            nextahour = ahour;
                            nextaminute =  aminute;
                            nextasec = asec ;
                            nextrecordhour =  recordhour;
                            nextrecordminute =  recordminute;
                            nextrecordsec =  recordsec;         
        end        
        default : begin
            nextstate = IDLE;
            nextahour = 0;
            nextaminute = 0;
            nextasec = 0;
            nextrecordhour =  0;
            nextrecordminute=  0; 
            nextrecordsec =  0;
        end
       endcase
    
    end
    
endmodule
