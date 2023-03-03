`timescale 1ns/100ps
module mymultdiv_tb();
    reg clock = 0, ctrl_Mult, ctrl_Div, interrupt;
    reg signed [31:0] operandA, operandB;

    // module outputs
    wire ready, except;
    wire signed [31:0] result;

    // Instantiate multdiv
    multdiv tester(operandA, operandB, ctrl_Mult, ctrl_Div, clock,
        result, except, ready);

    initial begin
        @(negedge clock);
		{ctrl_Mult, ctrl_Div} = 0;

		for (i = 0; i < 100; i = i + 1) begin
			@(negedge clock);
            if(ready) begin
			i = 150;
			end
		end

        if (i == 100) begin
            $display("Test Timed Out", tests);
    
                    // Write the timed out module outputs to the actual file
				    $fdisplay(actFile, "%d,%d,Timed Out, Timed Out",
                        operandA, operandB);

                    // Increment the Errors
                    errors = errors + 1;

                    // Output any differences to the difference file
                    $fdisplay(diffFile, "%0d,%d,%d,Timed Out,Timed Out,%d,%d",
                        tests,
                        operandA, operandB, 
                        exp_result, exp_except);

                end else begin
                    // Write the actual module outputs to the actual file
                    $fdisplay(actFile, "%d,%d,%d,%d",
                        operandA, operandB, 
                        result, except);
        
				
                    // Check for any inaccuracies in the module output and the expected output
                    if((result !== exp_result) | (except !== exp_except)) begin

                        // Increment the Errors
                        errors = errors + 1;

                        // Output any differences to the difference file
                        $fdisplay(diffFile, "%0d,%d,%d,%d,%d,%d,%d",
                            tests,
                            operandA, operandB, 
                            result, except,
                            exp_result, exp_except);
                        $display("Test %3d: FAILED", tests);
                    end else begin
                        $display("Test %3d: PASSED", tests);
                    end
                end

				@(negedge clock);

        $finish;
    end

    always
	    #10 clock <= ~clock; 
endmodule