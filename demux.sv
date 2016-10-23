import GAM_package::* ; 

module demux(input node_vector_T in,    
	  output node_vector_T out1,out2,out3,out4,
	 input logic [1:0]select );    

always_comb
begin
unique case(select)
2'b00: out1 =in; 
2'b01:out2 =in;
2'b10:out3 =in;
2'b11:out4 =in;        
endcase
end

endmodule

