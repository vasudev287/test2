//`timescale 1ns/1ps
//assert connection[i][j].age=connection[j][i].age 
//assert node1>0 and node2 >0  
//assert reached max node count before starting to remove isolated nodes       
import GAM_package::* ;  

module Memory_Layer_connection_memory(
	input int node1,node2,class_i,
	input en_connection,learning_done); 
	
//connection_mem_T connection;  

//used in removing invalidating nodes block
int connection_count;    

//bit [2:0]node1,node2,class_i;
//int node1,node2,class_i;

                                   
always@(en_connection) 
begin 
/* node1= node1_int; 
node2=node2_int;
class_i=class_i_int; */ 
 
info_log("Connection_Memory: detected change in connection presence");   

//node 2 might be -1 if there's only 1 node in the class 
if(en_connection & node2 >0)         // Removed en_connection & for removing simulation error as we used en_connection 
//simulate again in questa sim 
	begin 
	info_log("Connection_Memory: modifying coonnections");      
	$display("\n", $time, "\t Connection_Memory: node1: %0d \t node2: %0d \t class_i:%0d",node1,node2,class_i);
	connection.connection_class[class_i].connection_nodes[node1][node2].connection_presence=1'b1;    
	connection.connection_class[class_i].connection_nodes[node2][node1].connection_presence=1'b1;
	connection.connection_class[class_i].connection_nodes[node1][node2].age=0;   //??in case there's already a connection          
	connection.connection_class[class_i].connection_nodes[node2][node1].age=0;                 	
	$display("\n", $time, "\t Connection_Memory: node1: %0d \t node2: %0d \t class_i:%0d \t connection_presence: %b",node1,node2,class_i,connection.connection_class[class_i].connection_nodes[node1][node2].connection_presence);  
	for(int i=1;i<NODE_COUNT;i++)     
		begin
		if(i!=node1 & i!=node2)
			begin
			if( connection.connection_class[class_i].connection_nodes[node1][i].connection_presence==1)
			connection.connection_class[class_i].connection_nodes[node1][i].age=connection.connection_class[class_i].connection_nodes[node1][i].age+1;
			connection.connection_class[class_i].connection_nodes[i][node1].age=connection.connection_class[class_i].connection_nodes[i][node1].age+1;   			
			end 
		end 
	end 
 

else if(learning_done)    //if learning finished, remove all connections with age>age_max  
begin                  
	
	//removing connection 
	for(int class_counter=1; class_counter< CLASS_COUNT;class_counter++)
	begin
	for(int i=1;i<NODE_COUNT;i++)      
	begin
	for(int j=1;j<NODE_COUNT;j++)	 
	begin     
	if(connection.connection_class[class_counter].connection_nodes[i][j].age>=AGE_MAX) 
	connection.connection_class[class_counter].connection_nodes[i][j].connection_presence=0;
	end   
	end 
	end 
	//invalidating nodes block    
	//removing all nodes with no connections
	
	for(int class_counter=1; class_counter< CLASS_COUNT;class_counter++)
		begin	
		for(int node1_counter=1;node1_counter<NODE_COUNT;node1_counter++)    
			begin
			connection_count=0;           
			for(int node2_counter=1;node2_counter<NODE_COUNT;node2_counter++)	
				begin 
				if(connection.connection_class[class_counter].connection_nodes[node1_counter][node2_counter].connection_presence==1) 
				connection_count=connection_count+1;
				end
			if(connection_count==0)
			invalid_node_list[class_counter][node1_counter]= INVALID;   
			 	         
			end         
	end                
	
end 
end

 
endmodule