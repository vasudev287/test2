//`timescale 1ns/1ps

`define DEBUG_MEMOMY_CONTENTS    

//write concurrent assertions to see that node(x) or class(c) values are never zero.   
 
module GAM_verification_tb;

reg clk,reset;         
import GAM_package::* ; 

   
   
            
//memory layer signals         
node_vector_T x;       
int c;        
logic learning_done;      
LEARNING_RECALL_T learning_recall;  
READY_WAIT_T ready_wait;     
    
//recall module signals 
int Tk;                       
node_vector_T recalling_pattern;      
       

//DUT instantiation  
Memory_Layer ML (clk,x, c, reset,learning_done,learning_recall,ready_wait);   
auto_associative_recall recall_alg3 (x,Tk,learning_recall,recalling_pattern);                

   
//tbx clkgen
	initial
	begin
        clk=0;
        forever #5 clk=~clk;
	end

//tbx clkgen
	initial    
	begin
		reset =1;
		#10 reset=0;
	end   


//////////////////////////////////////////////////////////////pipes Instantiation
//Input Pipe Instantiation 

	scemi_input_pipe #(.BYTES_PER_ELEMENT(VECTOR_LEN+4), 
                   .PAYLOAD_MAX_ELEMENTS(VECTOR_LEN+4),   //?? 
                   .BUFFER_MAX_ELEMENTS(100)			  //??			  
                   ) inputpipe(clk);          
				   
	//Output Pipe Instantiation   

	scemi_output_pipe #(.BYTES_PER_ELEMENT(VECTOR_LEN+4),
					   .PAYLOAD_MAX_ELEMENTS(1),   
					   .BUFFER_MAX_ELEMENTS(10) 
					   ) outputpipe(clk);                   
            
        
/////////////////////////////////////////////////////////////pipes instantiation 	

	//XRTL FSM to obtain operands from the HVL side
	reg [(VECTOR_LEN*8)+31:0]class_image;    //            
	bit eom=0;
	reg [7:0] num_elements_valid=0;   //returns number of valid elements 
	// reg issued;

always @(posedge clk)
begin
  
if(ready_wait==READY & !learning_done)      
	begin 
	     	
	inputpipe.receive(VECTOR_LEN+4, num_elements_valid, class_image, eom );                          	  
	x=  class_image[(VECTOR_LEN*8)-1:0];  
 	c=  class_image[(VECTOR_LEN*8)+31:(VECTOR_LEN*8)]  ;             
	end     
else if (learning_done = 1 & learning_recall = RECALL)
	begin
		outputpipe.send(VECTOR_LEN*8,recalling_pattern,0);

	end 
else 	if ( learning_done = 1 & learning_recall == LEARNING)
		begin 
		outputpipe.send(VECTOR_LEN*8,recalling_pattern,1);
		$finish;
		end 
	
 

end 


	
	
endmodule
                                             