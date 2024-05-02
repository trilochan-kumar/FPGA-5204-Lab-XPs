`timescale 1ns / 1ps
module XADC_TEST_tb(

    );
    
wire [15 : 0] di_in;
wire [6 : 0] daddr_in;
wire den_in;
wire dwe_in;
wire drdy_out;
wire [15 : 0] do_out;
reg dclk_in;
reg reset_in;
wire vp_in;
wire vn_in;
wire user_temp_alarm_out;
wire vccint_alarm_out;
wire vccaux_alarm_out;
wire vccpint_alarm_out;
wire vccpaux_alarm_out;
wire vccddro_alarm_out;
wire ot_out;
wire [4 : 0] channel_out;
wire eoc_out;
wire vbram_alarm_out;
wire alarm_out;
wire eos_out;
wire busy_out;
wire vauxp7;
wire vauxn7;
wire vauxn15;
wire vauxp15;
initial
begin
    dclk_in = 1'b0;
    forever #5 dclk_in = ~dclk_in;
end

initial 
begin
         reset_in = 1'b1;
    #200 reset_in = 1'b0;
end
    
xadc_wiz_0 DUT (
          .di_in(16'b0),                  
          .daddr_in({{2{1'b0}},channel_out}),                  
          .den_in(eoc_out),                        
          .dwe_in(1'd0),                          
          .drdy_out(drdy_out),                       
          .do_out(do_out),                          
          .dclk_in(dclk_in),                        
          .reset_in(reset_in),                      
          .vp_in(1'b0),                            
          .vn_in(1'b0),                              
          .vauxp7(vauxp7),            // input wire vauxp7
          .vauxn7(vauxn7),            // input wire vauxn7
          .vauxp15(vauxp15),          // input wire vauxp15
          .vauxn15(vauxn15),                            
          .channel_out(channel_out),                  
          .eoc_out(eoc_out),                          
      
          .alarm_out(alarm_out),                    
          .eos_out(eos_out),                          
          .busy_out(busy_out)                       
        );

endmodule
