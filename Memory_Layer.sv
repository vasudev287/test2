import GAM_package::* ;

//add assertion in comparator or modules that are input sources to comparator to see either the inputs is not 0 

module Memory_Layer(
	input clk, 
	input node_vector_T x, 
	input int c, 
	
	input reset,learning_done/*,assoc_learning_done,       
	output assoc_learning_start*/,input LEARNING_RECALL_T learning_recall,
	output READY_WAIT_T ready_wait);       
 
  

logic  	en_connection,en_2min,ld_upcounter,en_upcounter,en_node_counter;  
logic  X_c,C_c,W_c,T_c,M_c;
RD_WR_T RD_WR_c; 
logic [1:0] mux1,mux2,mux3,mux4,mux5,mux6,demux;
comparator_T comparator;   
     
Memory_Layer_controller controller(
	clk,reset,learning_done,/*assoc_learning_done,*/comparator, learning_recall,
	ld_upcounter,en_upcounter,en_node_counter,/*assoc_learning_start,*/ 
	en_connection,en_2min,X_c,C_c,W_c,T_c,M_c,RD_WR_c,
	mux1,mux2,mux3,mux4,mux5,mux6,demux,
	ready_wait);       	     
	
Memory_Layer_datapath data_path(
	clk,x,c, ld_upcounter,en_upcounter,en_node_counter,en_connection,en_2min,learning_done,
	X_c,C_c,W_c,T_c,M_c,RD_WR_c,
	mux1,mux2,mux3,mux4,mux5,mux6,demux,comparator);    

 

    
endmodule      
