`timescale 1ns/1ps

module ClkDiv_test ;

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter Clock_PERIOD = 10 ;

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg Clock_tb ;
reg Reset_tb ;
reg enable_tb ;
reg [7:0] ratio_tb ;
wire div_clk_tb ;

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #(Clock_PERIOD/2) Clock_tb = ~Clock_tb ;

////////////////////////////////////////////////////////
/////////////////// DUT Instantiation //////////////////
////////////////////////////////////////////////////////

ClkDiv DUT (
    .i_ref_clk(Clock_tb),
    .i_rst_n(Reset_tb),
    .i_clk_en(enable_tb),
    .i_div_ratio(ratio_tb),
    .o_div_clk(div_clk_tb)
);

////////////////////////////////////////////////////////
////////////////// Initial Block /////////////////////// 
////////////////////////////////////////////////////////

initial begin
    // Waveform Dumping
    $dumpfile("ClkDiv.vcd");   
    $dumpvars(0, ClkDiv_test); 

    // reset & signal initialization
    initialization() ;
    reset() ;
    
    // Divide by 2 
    run_test(2, 60);
    
    // Divide by 3 
    run_test(3, 60);

    // Divide by 4 
    run_test(4, 60);

    // Divide by 5 
    run_test(5, 60);

    // Divide by 16 
    run_test(16, 60);

    // Divide by 32 
    run_test(32, 60);

    // Divide by 1 (Bypass Mode)
    run_test(1, 60);

    // Divide by 0 (Disabled Mode)
    run_test(0, 60);

    $stop ;                
end

////////////////// Tasks /////////////////////// 

task initialization ;
begin
    Clock_tb  = 0 ; 
    enable_tb = 0 ;
    ratio_tb  = 0 ;
end
endtask

task reset ;
begin
    Reset_tb = 0 ;
    # (Clock_PERIOD/2) ;
    Reset_tb = 1 ;
end
endtask

task run_test ;
    input [7:0] ratio ;
    input integer cycles ;
    begin
        enable_tb = 1 ;
        ratio_tb  = ratio ;
        
        # (Clock_PERIOD * cycles) ;
        
        reset() ;
        enable_tb = 0 ;    
        # (Clock_PERIOD * 0.5) ;
    end
endtask

endmodule