import GAM_package::* ;

module ED_calculator(
	input node_vector_T x,w,
	output int ED 
	 ); 

int ED_temp;
//intermediate variables
node_vector_T sub_result;    
logic [(VECTOR_LEN*32)-1:0]square_result;                 
int sum_out; 

genvar i;  
generate 
for(i=0;i<VECTOR_LEN;i=i+1)	      
begin  	
	subtraction sub (x[(i*8)+7:i*8],w[(i*8)+7:i*8],sub_result[(i*8)+7:i*8]);
	square sqr(sub_result[(i*8)+7:i*8],square_result[(i*32)+31:i*32]); 
end      
endgenerate          
       
square_results_adder add (square_result,sum_out); 
sqrt root (sum_out,ED);  

endmodule 
  
