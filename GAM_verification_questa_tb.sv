/* Standalone testbench for NFS_Design (questa sim simulation)
Taking patterns, classes from seperate text file for learnign and recall phases 
Writing pattern to different class
Reading the values line by line for every ack from DUT 
Writing in the same mode 
*/
//`timescale 1ns/1ps

`define DEBUG_MEMOMY_CONTENTS    

//write concurrent assertions to see that node(x) or class(c) values are never zero.   


// Testbench  logic 
module GAM_verification_questa_tb;

import GAM_package::* ; 
   


 
 /////////////////////////////////
   
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
       
      

 ////////////////////////////////////////////////////////
// File hadlers for all files 
integer image_vector_learning_file;	
integer image_class_learning_file;	
integer image_vector_recalling_file;
integer image_class_recalling_file;	
integer output_recalling_vector_file;	// File_Handler
integer scan_vector_input; // File_Handler 
integer output_recalling_class_file;
integer scan_class_input;
integer output_vector;
integer output_class;
////////////////////////////////////

node_vector_T image_vector;
int image_class; 
node_vector_T OutputSignal_pattern;
reg clk,reset;         
               

	initial
	begin
        clk=0;
        forever #5 clk=~clk;
	end
             
	initial    
	begin
		reset =1;  
		#9 reset=0;
	end   
//DUT instantiation  
Memory_Layer ML (clk,x, c, reset,learning_done,learning_recall,ready_wait);   
auto_associative_recall recall_alg3 (clk,x,15,learning_recall,recalling_pattern,class_name);     //give a value to Tk////            

	//////////////////////////////
// Opening all files related to project
initial 
	begin 
	learning_done =0; 
	image_vector_learning_file = $fopen ( "image_vector_learning.txt","r");
	image_class_learning_file = $fopen ( "image_class_learning.txt","r");
	output_recalling_vector_file = $fopen ("image_vector_output.txt", "a+");
	$display("****** \n *****File Created \n ********"); 
	image_vector_recalling_file = $fopen ( "image_vector_recalling.txt","r");
	image_class_recalling_file = $fopen ( "image_class_recalling.txt","r");
	output_recalling_class_file = $fopen ("image_class_output.txt", "a+");
	if (image_vector_learning_file == 0) 
		begin 
		$display( "vector_data_file handle is NULL");
		$stop;
		end 
	
	`ifdef DEBUG_MEMOMY_CONTENTS 
	$monitor("\n -----------------------------------------Memory Contents-----------------------------------------------------\n",$time,
			"\n \t class[1] node[1]: W = %b \t Th=%0d \t M=%0d", memory.classes[1].node[1].W ,memory.classes[1].node[1].Th, memory.classes[1].node[1].M,
			"\n \t class[1] node[2]: W = %b \t Th=%0d \t M=%0d", memory.classes[1].node[2].W ,memory.classes[1].node[2].Th, memory.classes[1].node[2].M,
			"\n \t class[1] node[3]: W = %b \t Th=%0d \t M=%0d", memory.classes[1].node[3].W ,memory.classes[1].node[3].Th, memory.classes[1].node[3].M, 
			"\n \t class[3] node[1]: W = %b \t Th=%0d \t M=%0d", memory.classes[3].node[1].W ,memory.classes[3].node[1].Th, memory.classes[3].node[1].M,
			"\n \t class[5] node[1]: W = %b \t Th=%0d \t M=%0d", memory.classes[5].node[1].W ,memory.classes[5].node[1].Th, memory.classes[5].node[1].M,
			"\n-------------------------------------------Memory Contents-----------------------------------------------------");      	 
		
	`endif	
		
		
	end
 
 always@( posedge clk) // ready_wait
 begin
if(!reset & !learning_done & ready_wait==READY )  
	begin 
	$fscanf (image_vector_learning_file, "%b", image_vector); 
	$fscanf (image_class_learning_file, "%d", image_class);
		
	if($feof(image_class_learning_file)) 
		begin
		learning_done=1;    
		end  	
	$display($time,"\t HDL:Input control pipe: learning_done:%b \t learning_recall: %s",learning_done, learning_recall) ; 
		
	learning_recall=LEARNING; 
	x = image_vector; 
	c = image_class;
	$display($time, "\t HDL:LEARNING PHASE INPUT: x: %b , c:%0d ",x,c);		
	end 
   
 end

 always@( negedge clk) // ready_wait
 begin 
 
 if (learning_done == 1 && learning_recall == RECALL && !$feof(image_vector_recalling_file) )
	begin 
	$display($time,"\t HDL: RECALL PHASE: sending recalled pattern: recall pattern: %b ",recalling_pattern);
	$fwrite(output_recalling_vector_file, "%b\n", recalling_pattern );
	$fwrite(output_recalling_class_file, "%d\n", class_name );
	end
if($feof(image_vector_recalling_file)) 
	begin
	$display("sending final recalled vector"); 
	$display($time,"\t HDL: RECALL PHASE: sending recalled pattern: recall pattern: %b ",recalling_pattern);
	$fwrite(output_recalling_vector_file, "%b\n", recalling_pattern );
	info_log("HDL: ----------------stop execution---------------------");
	$fclose(image_vector_recalling_file);
	$fclose(image_class_recalling_file); 
	$fclose(output_recalling_vector_file); 
	$fclose(image_vector_learning_file);      
	$fclose(image_class_learning_file); 
	$stop(); 	
	end
 if ( learning_done == 1 && ready_wait==IDLE  && learning_recall != RECALL)
 	begin 
	info_log("HDL: all learning inputs finished");      
	info_log("HDL:------------------- Waiting for recall phase to begin-----------------------\n \t \t \t----------------------------------------------------------------------------------------");
	learning_recall = RECALL; 
	end
  
 if (learning_done == 1 && learning_recall == RECALL && ! $feof(image_vector_recalling_file))
	begin 
	info_log("HDL:Input pipe receiving vector in recalling phase");  
	$fscanf (image_vector_recalling_file, "%b", image_vector);
	$fscanf (image_class_recalling_file, "%d", image_class);
	x = image_vector; 
	c = image_class;
	$display($time,"\t HDL: RECALL PHASE INPUT : x:%b",x);
	end 
end 
/*  always@( negedge clk) // ready_wait   //combine into above block if timing issues and place it exactly after begin before RECALL phase  
 begin 
 if (learning_done == 1 && learning_recall == RECALL && !$feof(image_vector_recalling_file) )
	begin 
	$display($time,"\t HDL: RECALL PHASE: sending recalled pattern: recall pattern: %b ",recalling_pattern);
	$fwrite(output_recalling_vector_file, "%b\n", recalling_pattern );
	$fwrite(output_recalling_class_file, "%d\n", class_name );
	end
else if($feof(image_vector_recalling_file)) 
	begin
	info_log("HDL: ----------------stop execution---------------------");
	$fclose(image_vector_recalling_file);
	$fclose(image_class_recalling_file); 
	$fclose(output_recalling_vector_file); 
	$fclose(image_vector_learning_file);      
	$fclose(image_class_learning_file); 
	$stop(); 	
	end
end */

endmodule  
                                             