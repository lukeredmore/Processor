`timescale 1ns/100ps
module multcomprehensive_tb();
    reg clock = 0, ctrl_Mult = 0, ctrl_Div = 0;
    reg signed [31:0] operandA = 0, operandB = 0;

    // module outputs
    wire ready, except;
    wire signed [31:0] result;

    // Instantiate multdiv
    multdiv tester(operandA, operandB, ctrl_Mult, ctrl_Div, clock,
        result, except, ready);

    integer i, j, k;
    initial begin
        for (j = -100; j < 100; j = j + 1) begin
            for (k = -100; k < 100; k = k + 1) begin
                i = 0;
                operandA = j;
                operandB = k;
                ctrl_Mult = 1;

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
                end else if (j*k != result) begin
                    $display("%d * %d wrongly gave %d (exception %b)",
                                operandA, operandB, 
                                result, except);
                end

		        @(negedge clock);
            end
        end
        $finish;
    end

    always
	    #10 clock <= ~clock; 

    // iverilog -c FileList.txt tb/simplemult_tb.v && vvp a.out && rm a.out

endmodule