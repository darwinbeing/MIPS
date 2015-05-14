//=============================================
// Baseline cache test
// A simple cache + SRAM
//=============================================
module test_cache;
  reg clock;
  reg rst;

  // memory signals
  wire        read_mem;
  wire        write_mem;
  wire        grant_mem;
  wire        ready_mem;
  wire [31:0] mem_databus;
  wire [31:0] cpu_databus;
  wire [31:0] cache_databus;
  wire [31:0] mem_adbus;

  // cpu signals
  reg         read;
  reg         write;
  wire        ready_cache;
  wire  [3:0] grant;
  wire [31:0] databus; 
  reg  [31:0] cpubus, membus;
  reg  [31:0] adbus;
  reg         skip_wait;

  integer i;
  assign grant_mem = grant[1];
  assign cpu_databus = cpubus;
  
  cache dut (
    .clk         (clock),
    .read_mem    (read_mem),
    .write_mem   (write_mem),
    .grant_mem   (grant_mem), 
    .ready_mem   (ready_mem),
    .mem_databus (cache_databus),
    .mem_adbus   (mem_adbus),
    .read        (read),
    .write       (write),
    .ready       (ready_cache),
    .grant       (grant_cache),
    .databus     (cpu_databus),
    .adbus       (adbus)
  );

  arbiter arbiter (
    .clk          (clock),
    .rst          (rst),
    .skip_wait    (skip_wait),
    .read_request ({2'b0, read_mem, 1'b0}),
    .write_request({2'b0, write_mem, 1'b0}),
    .grant        (grant),
    .memsel       (cs),
    .rwbar        (rwbar),
    .ready        (ready_mem)
  );
  
  memory memory (
    .clk    (clock),
    .cs     (cs),
    .rwbar  (rwbar),
    .adbus  (mem_adbus[9:2]),
    .databus(cache_databus)
  );

  always #10 clock = ~clock ;

  initial begin
    read = 1'b0;
    write = 1'b0;
    clock = 1;
    rst = 0;
    skip_wait = 0;
    #100 rst = 1;
    #100 rst = 0;
    #200;
    @(negedge clock);

    //-------------------------------------------
    // start cache write (write miss)
    //-------------------------------------------
    for (i = 0; i < 32; i = i + 4) begin
      write = 1'b1;
      adbus = i;
      cpubus = i;
      // wait for memory write
      wait(ready_cache);
      @(posedge clock);
      // deassert cpu write
      write = 1'b0;
      @(negedge clock);
    end

    @(posedge clock);
    //-------------------------------------------
    // start cache read (read hit)
    //-------------------------------------------
    for (i = 0; i < 32; i = i + 4) begin
      read  = 1'b1;
      adbus = i;
      cpubus = 32'hz;
      wait(ready_cache);
      @(posedge clock);
      // deassert cpu read
      read = 1'b0;
      @(posedge clock);
    end

    //-------------------------------------------
    // start cache write (write hit)
    //-------------------------------------------
    @(posedge clock);
    for (i = 0; i < 32; i = i + 4) begin
      write = 1'b1;
      adbus = i;
      cpubus = -i;
      wait(ready_cache);
      @(posedge clock);
      // deassert cpu write
      write = 1'b0;
      @(negedge clock);
    end

    //-------------------------------------------
    // start cache write (write miss)
    //-------------------------------------------
    for (i = 0; i < 32; i = i + 4) begin
      write = 1'b1;
      adbus = i + 512;  // causes write miss
      cpubus = i;
      wait(ready_cache);
      @(posedge clock);
      // deassert cpu write
      write = 1'b0;
      @(negedge clock);
    end

    //-------------------------------------------
    // start cache read (read miss)
    //-------------------------------------------
    for (i = 0; i < 32; i = i + 4) begin
      read  = 1'b1;
      adbus = i;
      cpubus = 32'hz;
      wait(ready_cache);
      @(posedge clock);
      // deassert cpu read
      read = 1'b0;
      @(negedge clock);
    end

    //-------------------------------------------
    // Finish Test 
    //-------------------------------------------
    @(negedge clock) $stop;

  end
endmodule 


