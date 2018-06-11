
`define NMCss  32'd1047 // C sharp sharp
`define NMDss  32'd1175 // D sharp sharp
`define NMEss  32'd1319 // E sharp sharp
`define NMCs  32'd524 // C sharp
`define NMDs  32'd588 // D sharp
`define NMEs  32'd660 // E sharp
`define NMFs  32'd698 // F sharp
`define NMGs  32'd784 // G sharp
`define NMAs  32'd880 // A sharp
`define NMBs  32'd988 // B sharp
`define NMC   32'd262 // C
`define NMD   32'd294 // E
`define NME   32'd330 // D
`define NMF   32'd349 // F
`define NMG   32'd392 // G
`define NMA   32'd440 // A
`define NMB   32'd494 // B
`define NM0   32'd20000 //slience (over freq.)

module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1/4 beat
	8'd0 : tone = `NM0;	
    8'd1 : tone = `NM0;
    8'd2 : tone = `NMC;
    8'd3 : tone = `NM0;
    8'd4 : tone = `NMC;
    8'd5 : tone = `NM0;
    8'd6 : tone = `NMC;
    8'd7 : tone = `NM0;
           
    8'd8 : tone = `NMD;
    8'd9 : tone = `NMD;
    8'd10 :tone = `NMG;
    8'd11 :tone = `NMG;
    8'd12 :tone = `NMFs;
    8'd13 :tone = `NMFs;
    8'd14 :tone = `NMEs;
    8'd15 :tone = `NMEs;
////////////////////////////////////////
           
    8'd16 :tone = `NMEs;
    8'd17 :tone = `NMEs;
    8'd18 :tone = `NMEs;
    8'd19 :tone = `NMEs;
    8'd20 :tone = `NMFs;
    8'd21 :tone = `NMFs;
    8'd22 :tone = `NMEs;
    8'd23 :tone = `NMEs;
           
    8'd24 :tone = `NMEs;
    8'd25 :tone = `NM0;
    8'd26 :tone = `NMDs;
    8'd27 :tone = `NMDs;
    8'd28 :tone = `NMDs;
    8'd29 :tone = `NMDs;
    8'd30 :tone = `NMCs;
    8'd31 :tone = `NMCs;
///////////////////////////////////
           
    8'd32 :tone = `NMCs;
    8'd33 :tone = `NMCs;
    8'd34 :tone = `NMCs;
    8'd35 :tone = `NMCs;
    8'd36 :tone = `NMDs;
    8'd37 :tone = `NMDs;
    8'd38 :tone = `NMEs;
    8'd39 :tone = `NMEs;
           
    8'd40 :tone = `NMEs;
    8'd41 :tone = `NMEs;
    8'd42 :tone = `NMCs;
    8'd43 :tone = `NMCs;
    8'd44 :tone = `NMCs;
    8'd45 :tone = `NMCs;
    8'd46 :tone = `NMA;
    8'd47 :tone = `NMA;
/////////////////////////////
                  
    8'd48 :tone = `NMA;
    8'd49 :tone = `NMA;
    8'd50 :tone = `NMCs;
    8'd51 :tone = `NMCs;
    8'd52 :tone = `NMGs;
    8'd53 :tone = `NMGs;
    8'd54 :tone = `NMGs;
    8'd55 :tone = `NMGs;
                  
    8'd56 :tone = `NMCs;
    8'd57 :tone = `NMCs;
    8'd58 :tone = `NMEs;
    8'd59 :tone = `NMEs;
    8'd60 :tone = `NMEs;
    8'd61 :tone = `NMEs;
    8'd62 :tone = `NMEs;
    8'd63 :tone = `NMEs;
///////////////////////////////
                  
    8'd64 :tone = `NMEs;
    8'd65 :tone = `NMDs;
    8'd66 :tone = `NMDs;
    8'd67 :tone = `NMCs;
    8'd68 :tone = `NMCs;
    8'd69 :tone = `NMCs;
    8'd70 :tone = `NMA;
    8'd71 :tone = `NMA;
                  
    8'd72 :tone = `NMG;
    8'd73 :tone = `NMG;
    8'd74 :tone = `NMFs;
    8'd75 :tone = `NMFs;
    8'd76 :tone = `NMEs;
    8'd77 :tone = `NMEs;
    8'd78 :tone = `NMEs;
    8'd79 :tone = `NMEs;
/////////////////////////////
                  
    8'd80 :tone = `NMEs;
    8'd81 :tone = `NMEs;
    8'd82 :tone = `NMFs;
    8'd83 :tone = `NMFs;
    8'd84 :tone = `NMEs;
    8'd85 :tone = `NMEs;
    8'd86 :tone = `NMEs;
    8'd87 :tone = `NMEs;
                  
    8'd88 :tone = `NMDs;
    8'd89 :tone = `NMDs;
    8'd90 :tone = `NMDs;
    8'd91 :tone = `NMDs;
    8'd92 :tone = `NMCs;
    8'd93 :tone = `NMCs;
    8'd94 :tone = `NMCs;
    8'd95 :tone = `NMCs;
///////////////////////////////
                  
    8'd96 :tone =  `NMCs;
    8'd97 :tone =  `NMCs;
    8'd98 :tone =  `NMDs;
    8'd99 :tone =  `NMDs;
    8'd100 :tone = `NMEs;
    8'd101 :tone = `NMEs;
    8'd102 :tone = `NMEs;
    8'd103 :tone = `NMEs; 
                   
    8'd104 :tone = `NMAs;
    8'd105 :tone = `NMAs;
    8'd106 :tone = `NMAs;
    8'd107 :tone = `NMAs;
    8'd108 :tone = `NMAs;
    8'd109 :tone = `NMAs;
    8'd110 :tone = `NMEs;
    8'd111 :tone = `NMEs;
///////////////:// ////////////
                   
    8'd112 :tone = `NMEs;
    8'd113 :tone = `NMEs;
    8'd114 :tone = `NMA;
    8'd115 :tone = `NMA;
    8'd116 :tone = `NMCs;
    8'd117 :tone = `NMCs;
    8'd118 :tone = `NMCs;
    8'd119 :tone = `NMCs; 
                   
    8'd120 :tone = `NMDs;
    8'd121 :tone = `NMDs;
    8'd122 :tone = `NMDs;
    8'd123 :tone = `NMDs;
    8'd124 :tone = `NMCs;
    8'd125 :tone = `NMCs;
    8'd126 :tone = `NMCs;
    8'd127 :tone = `NM0;
///////////////////////////////////////////////////

		default : tone = `NM0;
	endcase
end

endmodule
