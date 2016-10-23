//`timescale 1ns/1ps
  
import GAM_package::* ;  

module Memory_Layer_connection_memory(
	input int node1,node2,class_i,
	input en_connection,learning_done); 
	
connection_mem_T connection;     
                                   
always@(posedge en_connection) 
begin 
 
if( !learning_done)         // Removed en_connection & for removing simulation error as we used en_connection 

//simulate again in questa sim 
	begin
	connection.connection[class_i][node1][node2].connection_presence=1;    
	connection.connection[class_i][node2][node1].connection_presence=1;
	connection.connection[class_i][node1][node2].age=0;   //??in case there's already a connection          
	connection.connection[class_i][node2][node1].age=0;                 	
	  
	for(int i=1;i<NODE_COUNT;i++)     
		begin
		if(i!=node1 & i!=node2)
			begin
			if( connection.connection[class_i][node1][i].connection_presence==1)
			connection.connection[class_i][node1][i].age=connection.connection[class_i][node1][i].age+1;
			connection.connection[class_i][i][node1].age=connection.connection[class_i][i][node1].age+1;   			
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
	if(connection.connection[class_counter][i][j].age>=AGE_MAX) 
	connection.connection[class_counter][i][j].connection_presence=0;
	end   
	end 
	end     
	//removing all nodes with no connections
	
	for(int class_counter=1; class_counter< CLASS_COUNT;class_counter++)
		begin	
		for(int i=1;i<NODE_COUNT;i++)    
			begin
			static  int connection_count=0;             
			for(int j=1;j<NODE_COUNT;j++)	
				begin 
				if(connection.connection[class_i][node1][node2].connection_presence==1)
				connection_count=connection_count+1;
				end
			if(connection_count==0)
			invalid_node_list[class_counter][i]= INVALID;   
			 	         
			end         
	end                
	
end 
end
 
endmodule  