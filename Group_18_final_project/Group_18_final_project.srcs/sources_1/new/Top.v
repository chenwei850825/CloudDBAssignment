module Top(
    input clk,
    input rst,
    input [1:0]mode,
    input record,
    inout wire PS2_CLK,
    inout wire PS2_DATA,
    output [11:0]hours,
    output am_pm,
    output beep,
    output [1:0]curstate,
    output wire [3:0]DIGIT,
    output wire [6:0]DISPLAY,
    output pmod_1,
    output pmod_2,
    output pmod_4
    );

    wire [5:0] minute, sec;
    wire [3:0] BCD0, BCD1, BCD2, BCD3;
    wire [5:0] minute1, sec1, minute2, sec2, minute3, sec3;
    wire [11:0] hours1, hours2, hours3;
    wire am_pm1, am_pm2, am_pm3, beep1, beep2, beep3;
    wire [1:0]curstate1, curstate2, curstate3;

    assign hours = ( mode[0] == 1 ) ? hours1 :
                    ( mode[1] ) ? hours2 :
                    ( mode[2]) ? hours3 :
                    0;
    assign am_pm = ( mode[0] == 1 ) ? am_pm1 :
                   ( mode[1] ) ? am_pm2:
                   ( mode[2]) ? am_pm3 :
                      0;
    assign minute = ( mode[0] == 1 ) ? minute1 :
                    ( mode[1] ) ? minute2:
                    ( mode[2]) ? minute3 :
                    0;
    assign sec = ( mode[0] == 1 ) ? sec1 :
                 ( mode[1] ) ? sec2:
                 ( mode[2]) ? sec3 :
                 0;
    assign curstate = ( mode[0] == 1 ) ? curstate1 :
                     ( mode[1] ) ? curstate2:
                     ( mode[2]) ? curstate3 :
                     0;
    assign beep = ( mode[0] == 1 ) ? beep1 :
                  ( mode[1] ) ? beep2:
                  ( mode[2]) ? beep3 :
                  0;
    assign BCD0 = sec % 10;
    assign BCD1 = sec / 10;
    assign BCD2 = minute % 10;
    assign BCD3 = minute / 10;



    wire set, ok, stop, snooze, uphour, downhour, upminute, downminute, upsec, downsec;
    wire l_set, l_ok, l_stop, l_snooze, l_uphour, l_downhour, l_upminute, l_downminute, l_upsec, l_downsec;
    wire clk13, clk16, clk26;

    clock_divider cd (.clk13(clk13), .clk16(clk16), .clk26(clk26), .clk(clk));

    reg rst2;
    reg [3:0]premode;

    always@ (rst, mode, premode )begin
        if (rst)
            rst2 <= 1;
        else if ( mode != premode )
            rst2 <= 1;
        else
            rst2 <= 0;
    end
    always@( posedge clk16 ) premode <= mode;


    SampleDisplay keyboard ( .uphour(uphour), .downhour(downhour), .upminute(upminute), .downminute(downminute),
            .upsec(upsec), .downsec(downsec), .set(set), .ok(ok), .stop(stop), .snooze(snooze), .PS2_CLK(PS2_CLK),
            .PS2_DATA(PS2_DATA), .rst(rst), .clk(clk) );


    CreateLargePulse #25 c_pulse_set (.large_pulse(l_set),.small_pulse(set),.rst(rst),.clk(clk));

    CreateLargePulse #25 c_pulse_ok (.large_pulse(l_ok),.small_pulse(ok),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_stop (.large_pulse(l_stop),.small_pulse(stop),.rst(rst),.clk(clk));

    CreateLargePulse #25 c_pulse_snooze (.large_pulse(l_snooze),.small_pulse(snooze),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_uphour (.large_pulse(l_uphour),.small_pulse(uphour),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_downhour (.large_pulse(l_downhour),.small_pulse(downhour),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_upminute (.large_pulse(l_upminute),.small_pulse(upminute),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_downminute (.large_pulse(l_downminute),.small_pulse(downminute),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_upsec (.large_pulse(l_upsec),.small_pulse(upsec),.rst(rst),.clk(clk));
    CreateLargePulse #25 c_pulse_downsec (.large_pulse(l_downsec),.small_pulse(downsec),.rst(rst),.clk(clk));

DownCounter  dr (.ohour(hours1), .am_pm(am_pm1), .ominute(minute1),
              .osec(sec1), .beep(beep1),  .clk(clk26), .rst(rst2), .set(l_set), .uphour(l_uphour), .downhour(l_downhour), .upminute(l_upminute),
              .downminute(l_downminute), .upsec(l_upsec), .downsec(l_downsec),
              .ok(l_ok), .stop(l_stop), .curstate(curstate1)
             );


alarm  alarmclock ( .ohour(hours2), .am_pm(am_pm2), .ominute(minute2),
                 .osec(sec2), .beep(beep2),  .clk(clk26), .rst(rst2), .set(l_set), .uphour(l_uphour), .downhour(l_downhour), .upminute(l_upminute),
                 .downminute(l_downminute), .upsec(l_upsec), .downsec(l_downsec),
                 .ok(l_ok), .stop(l_stop), .snooze(l_snooze), .curstate(curstate2)
                     );

StopWatch sh ( .ohour(hours3), .am_pm(am_pm3), .ominute(minute3),
                 .osec(sec3), .beep(beep3),  .clk(clk26), .rst(rst2), .set(l_set),
                 .ok(l_ok), .stop(l_stop), .curstate(curstate3), .record(record)
                   );


    Bell bl (.clk(clk),.reset(rst2),.beep(beep),.pmod_1(pmod_1),.pmod_2(pmod_2),.pmod_4(pmod_4));


    LED7SEG SevenSeg(.DIGIT(DIGIT),.DISPLAY(DISPLAY),.clk(clk13),.BCD3(BCD3),.BCD2(BCD2),.BCD1(BCD1),.BCD0(BCD0));

endmodule