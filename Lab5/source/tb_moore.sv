// $Id: $
// File name:   tb_moore.sv
// Created:     9/24/2019
// Author:      David Dang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: tb_moore
`timescale 1ns / 10ps

module tb_moore();

// define params
  localparam CLK_PERIOD        = 2.5;
  localparam  FF_SETUP_TIME = 0.190;
  localparam PROPAGATION_DELAY = 0.8; // Allow for 800 ps for FF propagation delay

  localparam  INACTIVE_VALUE     = 1'b1;
  localparam  SR_SIZE_BITS       = 4;
  localparam  SR_MAX_BIT         = SR_SIZE_BITS - 1;
  localparam  RESET_OUTPUT_VALUE = 'd0;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME);

// Declare Test Case Signals
  integer tb_test_num;
  string  tb_test_case;
  string  tb_stream_check_tag;
  int     tb_bit_num;
  logic   tb_mismatch;
  logic   tb_check;
  //int     tb_bit_num;

  // Declare the Test Bench Signals for Expected Results
  logic tb_expected_ouput;
  logic [19:0] tb_test_data = 20'b11011001110011011010;

  // Declare DUT Connection Signals. NOT SURE IF LOGIC OR WIRE
  reg tb_clk;
  reg tb_n_rst;
  reg tb_i;
  reg tb_o;

// Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    tb_n_rst = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_n_rst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input logic expected_value;
    input string check_tag;
  begin
    tb_mismatch = 1'b0;
    tb_check    = 1'b1;
    if(expected_value == tb_o) begin // Check passed
      $info("Correct output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      tb_mismatch = 1'b1;
      $error("Incorrect output %s during %s test case", check_tag, tb_test_case);
    end

    // Wait some small amount of time so check pulse timing is visible on waves
    #(0.1);
    tb_check =1'b0;
  end
  endtask

  // Clock generation block
  always begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end

  // Task to manage the timing of sending one bit through the shift register
  task send_bit;
    input logic bit_to_send;
  begin
    // Synchronize to the negative edge of clock to prevent timing errors
    @(negedge tb_clk);
    
    // Set the value of the bit
    tb_i = bit_to_send;
    // Activate the shift enable
    //tb_shift_enable = 1'b1;
    
    // Wait for the value to have been shifted in on the rising clock edge
    @(posedge tb_clk);
    #(PROPAGATION_DELAY);

    // Turn off the Shift enable
    //tb_shift_enable = 1'b0;
  end
  endtask

  // Task to contiguosly send a stream of bits through the shift register
  task send_stream;
    input logic [19:0] bit_stream;
  begin
    // Coniguously stream out all of the bits in the provided input vector
    for(tb_bit_num = 0; tb_bit_num < 20; tb_bit_num++) begin
      // Send the current bit
      send_bit(bit_stream[tb_bit_num]);
    end
  end
  endtask


  // DUT Portmap
  moore DUT (.clk(tb_clk), .n_rst(tb_n_rst), .i(tb_i), .o(tb_o));

  initial begin
    tb_n_rst = 1'b1; // Initialize to be inactive
    tb_i = 'd0;
    tb_o = 'd0;
    tb_test_num = 0;    // Initialize test case counter
    tb_test_case = "Test bench initializaton";
    tb_stream_check_tag = "N/A";
    tb_bit_num          = -1;   // Initialize to invalid number
    tb_mismatch         = 1'b0;
    tb_check            = 1'b0;
    // wait a bit
    #(0.1);

    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    tb_n_rst     = 1'b0;

    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    tb_expected_ouput = RESET_OUTPUT_VALUE;
    check_output(0, "after reset applied");

    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output(0, "after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(negedge tb_clk);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    // Check that internal state was correctly keep after reset release
    #(PROPAGATION_DELAY);
    check_output(0, "after reset was released");

//*********************************************************************
// Test Case2: idle to state0
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "idle to state0";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    reset_dut();

    // Assign test case stimulus


    // Wait for DUT to process stimulus before checking results
    //tb_i = 1'b1;
    send_stream(tb_test_data);    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "idle to state0");

//*********************************************************************
// Test Case3: state0 to state1
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state0 to state1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state0 to state1");

//*********************************************************************
// Test Case4: state1 to state2
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state1 to state2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state1 to state2");

//*********************************************************************
// Test Case5: state2 to state3
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state2 to state3";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(1, "state2 to state3");

//*********************************************************************
// Test Case6: reset
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "reset";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    reset_dut();    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "reset");

//*********************************************************************
// Test Case7: idle to state0
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "idle to state0";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();

    // Assign test case stimulus


    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "idle to state0");

//*********************************************************************
// Test Case8: state0 back to idle
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state0 back to idle";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();

    // Assign test case stimulus


    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state0 back to idle");

//*********************************************************************
// Test Case9: stay on idle
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "stay on idle";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();

    // Assign test case stimulus


    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "stay on idle");

//*********************************************************************
// Test Case10: idle to state0
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "idle to state0";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();

    // Assign test case stimulus


    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "idle to state0");

//*********************************************************************
// Test Case11: state0 to state1
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state0 to state1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state0 to state1");

//*********************************************************************
// Test Case11: stay on state1
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "stay on state1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "stay on state1");

//*********************************************************************
// Test Case12: state1 to state2
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state1 to state2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state1 to state2");

//*********************************************************************
// Test Case13: state2 to idle
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state2 to idle";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state2 to idle");

//*********************************************************************
// Test Case14: idle to state0
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "idle to state0";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;
    //reset_dut();

    // Assign test case stimulus


    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "idle to state0");

//*********************************************************************
// Test Case15: state0 to state1
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state0 to state1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state0 to state1");

//*********************************************************************
// Test Case16: state1 to state2
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state1 to state2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state1 to state2");

//*********************************************************************
// Test Case17: state2 to state3
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state2 to state3";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(1, "state2 to state3");

//*********************************************************************
// Test Case18: state3 back to state1
// ********************************************************************
    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state3 back to state1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(1, "state3 back to state1");

//*********************************************************************
// Test Case19: state1 to state2
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state1 to state2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state1 to state2");

//*********************************************************************
// Test Case20: state2 to state3
// ********************************************************************

    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state2 to state3";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b1;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(1, "state2 to state3");

//*********************************************************************
// Test Case20: state3 back to idle
// ********************************************************************
    //@(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "state3 back to idle";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    //tb_async_in = INACTIVE_VALUE;

    // Assign test case stimulus

    // Wait for DUT to process stimulus before checking results
    tb_i = 1'b0;    
    @(posedge tb_clk);

    // Move away from risign edge and allow for propagation delays before checking
    #(CHECK_DELAY);
    // Check results
    check_output(0, "state3 back to idle");
















  end
endmodule 