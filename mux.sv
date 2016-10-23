import GAM_package::* ;

module mux(input int in1,in2,in3,in4,
	  output int out,
	input logic [1:0]select );  

always_comb
begin
case(select)
2'b00: out =in1;
2'b01:out =in2;
2'b10:out =in3;
2'b11:out =in4;   
endcase
end
         
endmodule

module mux_W(input node_vector_T in1,in2,in3,in4,
	  output node_vector_T out,       
	input logic [1:0]select );  

always_comb
begin
case(select)
2'b00: out =in1;
2'b01:out =in2;
2'b10:out =in3;
2'b11:out =in4;  
endcase
end

endmodule

