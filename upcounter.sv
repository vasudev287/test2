module upcounter(
	input clk,load,enable,
	input int in1,
	output int out); 

int count; 

always_ff @(posedge clk)  
begin
if(load) 
begin 
//count=in1;
out = in1;
end 
else if(enable)         
	begin	
	//count=count+1;
	out=out+1;       
	end
end 
endmodule 