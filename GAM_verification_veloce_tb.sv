//`timescale 1ns/1ps

`define DEBUG_MEMOMY_CONTENTS    


//write concurrent assertions to see that node(x) or class(c) values are never zero.   
 
module GAM_verification_veloce_tb;

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
int class_name;       

    
//DUT instantiation
Memory_Layer ML (clk,x, c, reset,learning_done,learning_recall,ready_wait);   
auto_associative_recall recall_alg3 (x,15,learning_recall,recalling_pattern,class_name);     //give a value to Tk            

                 
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
		#9 reset=0;
	end   


//////////////////////////////////////////////////////////////pipes Instantiation
	//Input Pipe Instantiation 

	scemi_input_pipe #(	.BYTES_PER_ELEMENT(VECTOR_LEN),  
						.PAYLOAD_MAX_ELEMENTS(1),      
						.BUFFER_MAX_ELEMENTS(1),
						.VISIBILITY_MODE(1)
					) input_vector_pipe(clk); 
				   
	scemi_input_pipe #(.BYTES_PER_ELEMENT(4),    
					.PAYLOAD_MAX_ELEMENTS(1),      
					.BUFFER_MAX_ELEMENTS(1), 
					.VISIBILITY_MODE(1)
                   		  			  
                   ) input_class_pipe(clk);     
				   
	scemi_input_pipe #(.BYTES_PER_ELEMENT(1),   
					.PAYLOAD_MAX_ELEMENTS(1),           
					.BUFFER_MAX_ELEMENTS(1),    
					.VISIBILITY_MODE(1)   
                   	  	   	 		  
                   )input_control_pipe(clk);          
  
 				      
	//Output Pipe Instantiation       

	scemi_output_pipe #(.BYTES_PER_ELEMENT(VECTOR_LEN+4),      
					   .PAYLOAD_MAX_ELEMENTS(1),     
					   .BUFFER_MAX_ELEMENTS(1),  
						.VISIBILITY_MODE(1)
					   ) outputpipe(clk);                           
            
            
/////////////////////////////////////////////////////////////pipes instantiation 	

	//XRTL FSM to obtain operands from/to the HVL side
	//logic [(VECTOR_LEN+4+1)*8 -1:0]data_from_HVL;

	//pipe variables
	//control_from_HVL[0]:learning_done, control_from_HVL[1]:learning_recall, 	 	
	bit [7:0] control_from_HVL;  
	//end of msg indicators
	bit eom_vector_pipe=0; bit eom_class_pipe=0; bit eom_control_pipe=0;
	//valid elements indicator
	bit [7:0] ne_vector_valid=0;  bit [7:0] ne_class_valid=0;  bit [7:0] ne_control_valid=0; 
	
        
initial 
begin
//reset=1; 
learning_done=0; learning_recall=LEARNING;                   
//$display( $time,"\t  HDL:initial:learning_done= %b, learning_recall=%s",learning_done,learning_recall);         
//$monitor ($time, "\t HDL:initial:reset: %b ", reset); 
//$monitor ($time, "\t HDL:initial:ready_wait= %0d  learning_done= %0b learning_recall=%0b", ready_wait, learning_done, learning_recall); 
//$monitor ($time, "\t HDL:initial:recalling_pattern: %0d ", recalling_pattern) ; 
//$monitor ($time, "\t HDL: x: %b , c:%0d ",x,c);      
end    
 
  
 
always_ff @(posedge clk)
begin 
    
$display($time, "\t HDL:always: ready_wait: %s, eom_class_pipe: %0b eom_vector_pipe= %0b: eom_control_pipe=%0b",ready_wait,eom_class_pipe,eom_vector_pipe,eom_control_pipe);  
//if(!reset & (!eom_class_pipe | !eom_vector_pipe) )
if(!reset & !learning_done & ready_wait==READY )   
	begin
	info_log("HDL: Input control pipe receiving");  		  
	input_control_pipe.receive(1, ne_control_valid,control_from_HVL, eom_control_pipe );
	$display($time,"\t HDL:Input control pipe: learning_done:%b \t learning_recall: %b",control_from_HVL[0],control_from_HVL[1]) ; 
		
	learning_done=control_from_HVL[0];
	//assigning enum value to learning_recall 
		if(control_from_HVL[1] == 0)    
		learning_recall=LEARNING;    
		else   
		learning_recall=RECALL;
  	info_log("HDL: Input data pipe receiving") ; 
		
	input_vector_pipe.receive(1, ne_vector_valid,x, eom_vector_pipe );                              	  
	input_class_pipe.receive(1, ne_class_valid,c, eom_class_pipe ); 
	$display($time, "\t HDL:LEARNING PHASE INPUT: x: %b , c:%0d ",x,c);                           	  
	
	end  

end  	 
   
//data to HVL 
logic [(VECTOR_LEN+4)*8 -1:0]data_to_HVL;   

//recall phase: getting input vectors from HDL 
always @(negedge clk)  
begin 

//if ( eom_class_pipe || eom_vector_pipe)
if(learning_done & ready_wait==IDLE & learning_recal !=RECALL)  
	begin
	
	info_log("HDL: all learning inputs finished");      
	info_log("HDL:------------------- Waiting for recall phase to begin-----------------------\n \t \t \t----------------------------------------------------------------------------------------");
	
	input_control_pipe.receive(1, ne_control_valid,control_from_HVL, eom_control_pipe );
	
	info_log(" HDL: reading control for recall phase begining");
	learning_done=control_from_HVL[0]; 
		//assigning enum value to learning_recall  
		if(control_from_HVL[1] == 0)     
			learning_recall=LEARNING;    
		else  
			learning_recall=RECALL;
		 
	end 	  


if(learning_done==1 && learning_recall==RECALL && !eom_control_pipe)
	begin 
	info_log("HDL:Input pipe receiving vector in recalling phase");   
	
	input_vector_pipe.receive(1, ne_vector_valid,x, eom_vector_pipe );
	input_control_pipe.receive(1, ne_control_valid,control_from_HVL, eom_control_pipe ); 
	$display($time,"\t HDL: RECALL PHASE INPUT : x:%b",x);     
	end 
end 
 


always @(posedge clk)  
begin

if (learning_done == 1 && learning_recall == RECALL & !eom_control_pipe)  
	begin  
	$display($time,"\t HDL: RECALL PHASE: sending recalled pattern: recall pattern: %b ",recalling_pattern);
	data_to_HVL= {class_name,recalling_pattern};                
	outputpipe.send(1,data_to_HVL,0);  
	end 
    
     
//else if ( learning_done == 1 & learning_recall == LEARNING)
else if ( eom_vector_pipe & eom_control_pipe)        
	begin     
	$display($time,"\t HDL: eom_vector_pipe set.....\n \t \t \t----- EXECUTION FINISHED-------");   
	outputpipe.send(1,data_to_HVL,1);      
	outputpipe.flush();           
	$finish();      
	end  

end   
	
	
endmodule  
                                             