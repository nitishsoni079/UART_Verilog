`timescale 1ns/10ps

module UART_RECEIVER
  #(parameter CLKS_PER_BIT = 217)
  (
   input        clk,
   input        i_Serial,
   output       o_DV,
    output [7:0] o_Byte_parellel
   );
   
  parameter IDLE         = 3'b000;
  parameter RX_START_BIT = 3'b001;
  parameter RX_DATA_BITS = 3'b010;
  parameter RX_TERMINATE_BITS = 3'b011;
  parameter cleanup = 3'b100;
  
  reg[2:0] DATABIT_INDEX = 0;
  reg[2:0] RX_MAIN = 3'b000;
  reg[7:0] clock_count = 0;
  reg[7:0] r_Byte_parallel = 0;
  reg r_DV = 0;
  
  always@ (posedge clk)
    begin
      case(RX_MAIN)
          IDLE: begin
            r_DV <= 1'b0;
            clock_count <= 0;
            DATABIT_INDEX <= 0;
            
            if(i_Serial == 1'b0)
              begin 
                RX_MAIN <= RX_START_BIT;
              end
            else
              begin
              RX_MAIN <= IDLE;
              end
          end
          
          RX_START_BIT:
          begin
            if(clock_count == CLKS_PER_BIT+1/2)
              begin
                if(i_Serial == 1'b0)
                  RX_MAIN <= RX_DATA_BITS;
                else
                  RX_MAIN <= IDLE;
              end
            else
              begin
                clock_count <= clock_count + 1;
                RX_MAIN <= RX_START_BIT;
                end
            end
          
          RX_DATA_BITS:
          begin
            if(clock_count < 217)
              begin
                clock_count <= clock_count+1;
                RX_MAIN <= RX_DATA_BITS;
              end
            else
               
              begin
                r_Byte_parallel[DATABIT_INDEX] <= i_Serial;
                clock_count <= 0;
                if(DATABIT_INDEX < 7)
                  begin
                    DATABIT_INDEX <= DATABIT_INDEX + 1;
                    RX_MAIN <= RX_DATA_BITS;
                  end
                else
                  begin
                    clock_count <= 0;
                    RX_MAIN <= RX_TERMINATE_BITS;
                  end
              end
              end
            
            RX_TERMINATE_BITS:
            begin
              if(clock_count < 217)
                begin
                  clock_count <= clock_count + 1;
                  RX_MAIN <= RX_TERMINATE_BITS;
                end
              else
                begin
                  r_DV = 1'b1;
                  clock_count <= 0;
                  RX_MAIN <= cleanup;
                end
            end
            
            cleanup:
            begin
              RX_MAIN <= IDLE;
              r_DV <= 1'b0;
            end
            default:
            RX_MAIN <= IDLE;
            endcase
          end
         
          assign o_DV = r_DV;
          assign o_Byte_parellel = r_Byte_parellel;
          
          endmodule
                
                  
               
           
                
                  
            
                
            
           
            
            
            
          
            
  
