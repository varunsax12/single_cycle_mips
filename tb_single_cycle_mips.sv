// testbench to test for a specific test which in the end writes to memory
// address=84 and data=7

// `timescale  1ns /  10ps

module tb_single_cycle_mips();

    logic clk, reset;                 // input
    logic [31:0] writedata, dataaddr; // input
    logic memwrite;                   // output

    single_cycle_mips uut (.clk(clk), .reset(reset), .writedata(writedata), .dataaddr(dataaddr), .memwrite(memwrite));

    // init test
    initial
        begin
            reset <= 1;
            #22;
            reset <= 0;
        end

    // generate clock
    always
        begin
            clk <= 1; #5;
            clk <= 0; #5;
        end

    // check results
    always @(negedge clk)
        begin
            if(memwrite)
                begin
                    if(dataaddr===84 & writedata===7)
                        begin
                            $display("Simulation succeeded");
                            $stop;
                        end
                    else if (dataaddr!==80)
                        begin
                            $display("Simulation failed, check error");
                            $stop;
                        end
                end
        end

endmodule
