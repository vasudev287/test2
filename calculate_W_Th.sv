import GAM_package::* ;
 
module calculate_W_Th(
	input node_vector_T X_in,Ws1_in,Ws2_in,
	input int Ths1_in,Ms1_in,min1_ED,  
	output node_vector_T Ws1_out,Ws2_out,
	output int Ths1_out ); 


//intermediate variables                    
node_vector_signed_T sub_result_Ws1,sub_result_Ws2,division_result_Ws1,division_result_Ws2;         
//logic [(VECTOR_LEN*32)-1:0]division_result_Ws1,division_result_Ws2;      
int add_result_Ths1;    
  
  
genvar i;                         
generate               
for(i=0;i<VECTOR_LEN;i=i+1)	             
begin  	    
	subtraction_signed sub_Ws1 ({1'b0,X_in[(i*8)+7:i*8]},{1'b0,Ws1_in[(i*8)+7:i*8]},sub_result_Ws1[(i*9)+8:i*9]);
	//use signed logic division instead of int division   
	//division div_Ws1 (int '(sub_result_Ws1[(i*9)+8:i*9]),Ms1_in,division_result_Ws1[(i*32)+31:i*32]);
	division_logic div_Ws1 (sub_result_Ws1[(i*9)+8:i*9],Ms1_in,division_result_Ws1[(i*9)+8:i*9]); 
 	//int_addition add_Ws1 (division_result_Ws1[(i*9)+9:i*9],int '(Ws1_in[(i*8)+7:i*8]),Ws1_out[(i*8)+7:i*8]);
	addition add_Ws1 (division_result_Ws1[(i*9)+8:i*9],{1'b0,Ws1_in[(i*8)+7:i*8]},Ws1_out[(i*8)+7:i*8]);
                     
/*	subtraction_signed sub_Ws2 ({1'b0,X_in[(i*8)+7:i*8]},{1'b0,Ws2_in[(i*8)+7:i*8]},sub_result_Ws2[(i*9)+8:i*9]);
	division div_Ws2 (sub_result_Ws2[(i*9)+8:i*9],Ms1_in*100,division_result_Ws2[(i*32)+31:i*32]);            
	int_addition add_Ws2 (division_result_Ws2[(i*32)+31:i*32],Ws2_out[(i*8)+7:i*8]);    
*/    
	subtraction_signed sub_Ws2 ({1'b0,X_in[(i*8)+7:i*8]},{1'b0,Ws2_in[(i*8)+7:i*8]},sub_result_Ws2[(i*9)+8:i*9]);
	division_logic div_Ws2 (sub_result_Ws2[(i*9)+8:i*9],100*Ms1_in,division_result_Ws2[(i*9)+8:i*9]);                     
 	addition add_Ws2 (division_result_Ws2[(i*9)+8:i*9],{1'b0,Ws2_in[(i*8)+7:i*8]},Ws2_out[(i*8)+7:i*8]);             
    
end           
endgenerate         
     
	int_addition add_Ths1 (Ths1_in,min1_ED,add_result_Ths1); 
	division div_Ths1 (add_result_Ths1,2,Ths1_out);    
 
endmodule          