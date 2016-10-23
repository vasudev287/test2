// `timescale 1ns/1ps  
import GAM_package::* ;

module Memory_Layer_memory( input clk,
	input int class_i,node_i,Th_i,M_i,
	input   X_c,C_c,W_c,T_c,M_c,input RD_WR_T RD_WR_c,   
	input node_vector_T X_i,W_i,
	output int class_o,Th_o,M_o,
	output  node_vector_T W_o 
	);    //removing node_o, X_o
 
//check if we need X_o, Class_o ,Node_o 
  
  
//memory_T memory;   

  

always_ff@(negedge clk)   
begin
//use unique case to check if data is being 
// read/written to when always_comb executes before start of sim

if(RD_WR_c==WRITE) 
	begin 
	         
	if(X_c==1)                    
	memory.classes[class_i].node[node_i].X=X_i;   
	if(C_c==1) 
	memory.classes[class_i].class_name=class_i;      
	if(W_c==1)   
	memory.classes[class_i].node[node_i].W=W_i;
	if(T_c==1) 
	memory.classes[class_i].node[node_i].Th=Th_i;
	if(M_c==1) 
	memory.classes[class_i].node[node_i].M=M_i;
	end
end 

always_comb         
begin 	
if(RD_WR_c==READ)             
	begin     
	if(C_c==1) 
	class_o=memory.classes[class_i].class_name;    
	if(W_c==1) 
	W_o=memory.classes[class_i].node[node_i].W;
	if(T_c==1)  
	Th_o=memory.classes[class_i].node[node_i].Th; 
	if(M_c==1)  
	M_o=memory.classes[class_i].node[node_i].M;
	end




	
end       
endmodule
  