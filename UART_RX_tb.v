// Code your testbench hmodule
module UART_RECEIVER_TB();
 
  parameter clk_period_ns = 40;
  parameter clks_per_bit = 217;
  parameter clk_period_bit = 8600;
  reg clk;
  reg r_serial = 1;
  wire[7:0] w_Byte_parellel;
  
  task UART_SENDDATA;
    input[7:0] i_data;
    integer i;
    begin
      r_serial = 1'b0;
      #8600
      for(i = 0; i<=7; i++)
        begin
          r_serial <= i_data[i];
          #8600
        end
      r_serial = 1'b1;
      #8600
    end
  endtask
  
  UART_RECEIVER UART_RECEIVER_INST(
    .clk(clk),
    .i_serial(r_serial),
    .o_DV(),
    .o_Byte_parellel(w_Byte_parellel)
  );
  
  always #20 clk <= !clk;
  
  initial
    begin
      
      @(posedge clk)
      UART_SENDDATA(8'h37);
      @(posedge clk)
      if(w_Byte_parellel == 8'h37)
        $display("passed");
        else
          $display("failed");
      $finish
      
    end
  initial 
  begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
  
endmodule

  
  
  
