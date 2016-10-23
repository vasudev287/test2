//`timescale 1ns/1ps

import GAM_package::* ;  

module Memory_Layer_node_counter(
	input int class_name,
	input en_node_counter,
	output int node_count,
	output int node_max 
	);

//node_counter_mem_T node_counter;  //declared in package as global variable      
	
always@(posedge en_node_counter)	
begin
node_counter.node_count[class_name]= node_counter.node_count[class_name]+1; 
node_count=node_counter.node_count[class_name]; 
end  
  
        
always_comb           
begin
if(!en_node_counter)
node_max=node_counter.node_count[class_name];       
end   
     
endmodule   