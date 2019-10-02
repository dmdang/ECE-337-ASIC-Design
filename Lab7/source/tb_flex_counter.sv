// $Id: $
// File name:   tb_flex_counter.sv
// Created:     9/17/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: tb_flex_counter
`timescale 1ns / 100ps

module tb_flex_counter();

// Define local parameters used by the test bench
  //localparam  CLK_PERIOD    = 1;
  localparam  CLK_PERIOD = 2.5;
  localparam  FF_SETUP_TIME = 0.190;
  localparam  FF_HOLD_TIME  = 0.100;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); // Check right before the setup time starts

  localparam  INACTIVE_VALUE     = 1'b0;
  localparam  RESET_OUTPUT_VALUE = INACTIVE_VALUE;
  localparam  NUM_CNT_BITS = 4;
  localparam  ROLLOVER_2 = 'd2;
  localparam  ROLLOVER_NOT_2 = 'd3;
  localparam  RESET_FLAG = 1'b0;
  localparam  FLAG_IS_1 = 1'b1;
  localparam  FLAG_IS_0 = 1'b0;
  localparam  COUNT_OUT_IS_1 = 'd1;
  localparam  COUNT_OUT_IS_0 = 'd0;

// Declare DUT portmap signals
  logic [2:0] tb_test_num = 3'b000;
  string tb_test_case;
  //integer tb_stream_test_num;
  string tb_stream_check_tag;
// make inputs as wire, outputs as reg. WHAT IS THE CORRECT TYPE?
  reg tb_clk;
  reg tb_n_rst;
  reg tb_clear;
  reg tb_count_enable;
  reg [NUM_CNT_BITS-1:0] tb_rollover_val;
  reg [NUM_CNT_BITS-1:0] tb_count_out;
  reg tb_rollover_flag;


  // Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    //tb_n_rst = 1'b0;

    // Maintain the reset for more than one cycle
    //@(posedge tb_clk);
    //@(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    //@(negedge tb_clk);
    //tb_n_rst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    //@(negedge tb_clk);
    //@(negedge tb_clk);

    @(posedge tb_clk);
    tb_n_rst = 0;
    @(posedge tb_clk);
    tb_n_rst = 1;


    
  end
  endtask
  // Task to cleanly and consistently check DUT output values
  task check_output;
    input logic  expected_value;
    input string check_tag;
    input logic expected_flag;
  begin
    if(tb_count_out == expected_value) begin // Check passed. DO I INITIALIZE TB_ROLLOVER_VAL?
        $info("count_out is correct");
    end
    else begin // Check failed
      $error("count_out is wrong");
    end
    
    if(tb_rollover_flag == expected_flag) begin
   	$info("rollover flag is correct");
    end
    else begin
        $error("rollover flag is wrong");
    end
  end
  endtask

task clear;
begin
  
    // Activate the reset
    @(posedge tb_clk);

    tb_clear = 1'b1;

    // Maintain the reset for more one cycle
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    tb_clear = 1'b0;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    //@(negedge tb_clk);
    //@(negedge tb_clk);


end
endtask 



  // Clock generation block
  always
  begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end


// DUT Port map
  flex_counter DUT(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val), .count_out(tb_count_out), .rollover_flag(tb_rollover_flag));

// Test bench main process
initial 
begin
    tb_n_rst = 1'b1; // ANYTHING ELSE?
    tb_rollover_val = 'd2;
    tb_clear = 1'b0;
    tb_count_enable = 1'b0;
    #(0.1);


//*********************************************
// Test Case1: power-on-reset (work in progress)
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    //tb_async_in  = INACTIVE_VALUE; // Set to be the the non-reset value
    tb_n_rst  = 1'b0;    // Activate reset
    
    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    check_output( RESET_OUTPUT_VALUE, 
                  "after reset applied", RESET_FLAG);
    
    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output( RESET_OUTPUT_VALUE, 
                  "after clock cycle while in reset", RESET_FLAG);
    
    // Release the reset away from a clock edge
    @(posedge tb_clk);
    #(2 * FF_HOLD_TIME);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    #0.1;
    // Check that internal state was correctly keep after reset release
    check_output( RESET_OUTPUT_VALUE, 
                  "after reset was released", RESET_FLAG);

//*********************************************************************
// Test Case2: rollover for a rollover value that is not a power of two

    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "rollover for power not of 2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();
    clear();

    // Assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = ROLLOVER_NOT_2; // 'd5
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    @(posedge tb_clk); 
    @(posedge tb_clk);
    @(posedge tb_clk); 
    @(posedge tb_clk);
    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output( COUNT_OUT_IS_1,
                  "after processing delay", FLAG_IS_0);
    

//********************************
// Test Case3: continuous counting (same as case 2)
    
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "continuous counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    reset_dut();
    clear();

    // Assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = ROLLOVER_NOT_2; // 'd3
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    @(negedge tb_clk); 
    @(negedge tb_clk);
    @(negedge tb_clk);
    @(negedge tb_clk);
    @(negedge tb_clk);
    @(negedge tb_clk);
    @(negedge tb_clk); 
    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output( ROLLOVER_NOT_2,
                  "after processing delay", FLAG_IS_1);

//***********************************
// Test Case4: discontinuous counting
    
    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "discontinuous counting";
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();
    clear();

    // assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = ROLLOVER_2; // 'd2
    tb_count_enable = 1'b1;

    @(posedge tb_clk);
    tb_count_enable = 1'b0;
    @(posedge tb_clk);
    @(posedge tb_clk);

    #(CHECK_DELAY);
    check_output(COUNT_OUT_IS_1, "after processing delay", FLAG_IS_0);

//****************************************************************************
// Test Case5: clearing while counting to check clear vs count enable priority

    @(negedge tb_clk);
    tb_test_num = tb_test_num + 1;
    tb_test_case = "clearing while counting";
    //tb_async_in = INACTIVE_VALUE;
    reset_dut();
    clear();

    // assign test case stimulus
    tb_clear = 1'b0;
    tb_rollover_val = ROLLOVER_NOT_2; // 'd3
    tb_count_enable = 1'b1;

    @(posedge tb_clk);
    tb_clear = 1'b1;
    @(posedge tb_clk);
    @(posedge tb_clk);

    #(CHECK_DELAY);
    check_output(COUNT_OUT_IS_0, "after processing delay", FLAG_IS_0);

end 
endmodule 