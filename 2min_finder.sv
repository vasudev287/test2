module min_finder(
	input clk,enable,
	input int ED_in, node_in,
	output int min1_node,min2_node,min1_ED,min2_ED);          

int unsigned min1_node_temp,min2_node_temp='1;
int unsigned min1_ED_temp,min2_ED_temp='1;        

//implementing this operation in always@posedge clk block, else statement, simulate again to verify working
/* 
always @(negedge enable) begin
{min1_ED_temp,min2_ED_temp,min1_node_temp,min2_node_temp} ='1;      
end    
*/         
always@(posedge clk)    
begin  
	if(enable) 
	begin      
	if (ED_in < min1_ED_temp)     
		begin  
		min2_ED_temp=min1_ED_temp; 
		min2_node_temp=min1_node_temp;
		min1_ED_temp=ED_in;
		min1_node_temp=node_in;	            	         
		end   
	else if (ED_in == min1_ED_temp)     
		begin
		min2_ED_temp=ED_in;
		min2_node_temp=node_in;
		end  
		
	else if (ED_in < min2_ED_temp)
		begin
		min2_ED_temp=ED_in; 
		min2_node_temp=node_in;		         
		end 
		
	else if (ED_in == min2_ED_temp)
		begin
		min2_ED_temp=ED_in; 
		min2_node_temp=node_in;		         
		end    
		
	min1_node=min1_node_temp;
	min2_node=min2_node_temp;
	min1_ED=min1_ED_temp;    
	min2_ED=min2_ED_temp;      
	end        
	else  
	{min1_ED_temp,min2_ED_temp,min1_node_temp,min2_node_temp} ='1;               

end     
endmodule        