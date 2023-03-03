`timescale 1ns/100ps
module simplediv_tb();
    reg clock = 0, ctrl_Mult = 0, ctrl_Div = 0;
    reg signed [31:0] operandA = 2, operandB = -5;

    // module outputs
    wire ready, except;
    wire signed [31:0] result;

    // Instantiate multdiv
    multdiv tester(operandA, operandB, ctrl_Mult, ctrl_Div, clock,
        result, except, ready);

    integer i;
    initial begin
        $dumpfile("simplediv_7_3.vcd");
        $dumpvars(0, simplediv_tb);
        i = 0;
        ctrl_Div = 1;

        @(negedge clock);
		{ctrl_Mult, ctrl_Div} = 0;
		for (i = 0; i < 100; i = i + 1) begin
			@(negedge clock);
            if(ready) begin
			i = 150;
			end
		end
        if (i == 100) begin
            $display("Timed Out");
        end else begin
            // Write the actual module outputs to the actual file
            $display("%d / %d gave %d (exception %b)",
                        operandA, operandB, 
                        result, except);
        end

		@(negedge clock);

        $finish;
    end

    always
	    #10 clock <= ~clock; 


endmodule