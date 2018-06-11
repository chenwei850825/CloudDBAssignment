`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/01/04 17:09:27
// Design Name: 
// Module Name: alarm
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


module alarm(
    output [11:0]ohour,
    output am_pm,
    output [5:0]ominute,
    output [5:0]osec,
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
    input stop,
    input snooze
    );
    
  
                

    
    
    
    parameter IDLE = 0;
    parameter TIMESET = 1;
    parameter ALARMSET = 2;
    parameter COUNT = 3;
    parameter RING = 4;
    parameter SNOOZE = 5;
    
    reg [2:0] state, nextstate;
    
    
    reg [4:0] hour, nexthour;
    reg [5:0] minute, sec, nextminute, nextsec;
    wire [4:0]tmphour;
    
    
    
    reg [4:0] ahour, nextahour;
    reg [5:0] aminute, asec, nextaminute, nextasec;
    
    
    wire minutecarry;
    wire hourcarry;
    reg [3:0]snoozecount;
    
    
    assign minutecarry = ( sec >= 59 ) ? 1 : 0;
    assign hourcarry = ( minute >= 59 ) ? 1 : 0;
    assign tmphour = ( state == ALARMSET ) ?  ( ahour > 12 ) ? ahour - 12 : ahour : 
                                                  ( hour > 12 ) ? hour - 12 : hour;
    assign am_pm = (state == ALARMSET ) ?  ( ahour > 12 ) ? 1 : 0 :
                                           ( hour > 12 ) ? 1 : 0;
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
   assign ominute = ( state == ALARMSET ) ? aminute : minute;
   assign osec = ( state == ALARMSET ) ? asec : sec;
   assign curstate[0] = ( state == TIMESET ) ? 1 : 0;
   assign curstate[1] = ( state == ALARMSET ) ? 1 : 0;
   assign beep = ( nextstate == RING ) ? 1 : 0;
    
    always@ ( posedge clk, posedge rst ) begin
        if( rst ) begin
            state <= IDLE;
            hour <= 0;
            ahour <= 0;
            minute <= 0;
            aminute <= 0;
            sec <= 0;
            asec <= 0;
            snoozecount <= 0;
        end          
        else begin
            state <= nextstate;
            hour <= nexthour;
            ahour <= nextahour;
            minute <= nextminute;
            aminute <= nextaminute;
            sec <= nextsec;
            asec <= nextasec;
            snoozecount = ( state == SNOOZE ) ? snoozecount + 1 : 0;
        end
        
               
    end
    
    always @(*)begin
        case ( state )
        
            IDLE :begin         
            nextstate = ( set ) ? TIMESET : IDLE;
            nexthour = 0;
            nextahour = 0;
            nextminute = 0;
            nextaminute = 0;
            nextsec = 0;
            nextasec = 0;      
            end
            
            TIMESET :begin      
            nextstate = ( ok ) ? ALARMSET : TIMESET;
            nexthour = ( uphour ) ? ( hour < 23 ) ? hour + 1 : 0 :
                        ( downhour ) ? ( hour > 0 ) ? hour - 1 : 23 : 
                        hour;
            nextahour = 0;
            nextminute = ( upminute ) ? ( minute <  59) ? minute + 1 : 0 :
                         ( downminute ) ? ( minute > 0 ) ? minute - 1 : 59 :
                         minute;
            nextaminute = 0;
            nextsec = ( upsec ) ? ( sec < 59 ) ? sec + 1 : 0 :
                      ( downsec ) ? ( sec > 0 ) ? sec - 1 : 59 :
                      sec;
            nextasec = 0;
            end
            
            ALARMSET :begin
            nextstate = ( ok ) ? COUNT : ALARMSET;
            nexthour = hour;
            nextahour = ( uphour ) ? ( ahour < 23 ) ? ahour + 1 : 0 :
                                    ( downhour ) ? ( ahour > 0 ) ? ahour - 1 : 23 : 
                                    ahour;
            nextminute = minute;
            nextaminute = ( upminute ) ? ( aminute <  59) ? aminute + 1 : 0 :
                                     ( downminute ) ? ( aminute > 0 ) ? aminute - 1 : 59 :
                                     aminute;
            nextsec = sec;
            nextasec = ( upsec ) ? ( asec < 59 ) ? asec + 1 : 0 :
                                  ( downsec ) ? ( asec > 0 ) ? asec - 1 : 59 :
                                  asec;
            end
            
            COUNT :begin
            nextstate = ( hour == ahour  && minute == aminute && sec == asec  ) ? RING : COUNT;
            nexthour = ( hourcarry ) ? ( hour < 23 ) ? hour + 1 : 0 : 
                        hour;
            nextahour = ahour;
            nextminute = ( minutecarry ) ? ( minute < 59 ) ? minute + 1 : 0 :
                         minute;
            nextaminute = aminute;
            nextsec = ( sec < 59 ) ? sec + 1 : 0;
            nextasec = asec;
            end
            
            RING :begin
            nextstate = ( stop ) ? IDLE : 
                        ( snooze) ? SNOOZE : RING;
            nexthour = ( stop ) ? 0 : ( hourcarry ) ? ( hour < 23 ) ? hour + 1 : 0 : 
                        hour;
            nextahour = ahour;
            nextminute = ( stop ) ? 0 : ( minutecarry ) ? ( minute < 59 ) ? minute + 1 : 0 : 
                        minute;
            nextaminute = aminute;
            nextsec = ( stop ) ? 0 : ( sec < 59 ) ? sec + 1 : 0;
            nextasec = asec;
            end
            
            SNOOZE :begin
            nextstate = ( snoozecount >= 10 ) ? RING : SNOOZE;
            nexthour = ( hourcarry ) ? ( hour < 23 ) ? hour + 1 : 0 : 
                        hour;
            nextahour = ahour;
            nextminute = ( minutecarry ) ? ( minute < 59 ) ? minute + 1 : 0 : 
                        minute;
            nextaminute = aminute;
            nextsec = ( sec < 59 ) ? sec + 1 : 0;
            nextasec = asec;
            end
            
            default :begin
            nextstate = IDLE;
            nexthour = 0;
            nextahour = 0;
            nextminute = 0;
            nextaminute = 0;
            nextsec = 0;
            nextasec = 0;
            end
            
       endcase
            
    end
endmodule
