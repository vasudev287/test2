`ifndef PACKAGE
`define PACKAGE 

`define INFO_LOG   
 
package GAM_package;

parameter NODE_COUNT=10;         
parameter CLASS_COUNT=10;       //assert i/p c==CLASS_COUNT ;     
parameter DIMENSION_ROWS=2;     
parameter DIMENSION_COLUMNS=2;  
parameter VECTOR_LEN=DIMENSION_ROWS*DIMENSION_COLUMNS;       

  
parameter AGE_MAX=4;     //make sure to set the value correctly       
 
//use these 
typedef logic[$clog2(NODE_COUNT):1] NODE_INDEX_T; 
typedef logic[$clog2(CLASS_COUNT):1] CLASS_INDEX_T;        
             
          
typedef enum {READ,WRITE} RD_WR_T;  
typedef enum {LEARNING,RECALL} LEARNING_RECALL_T;             
typedef enum {READY, WAIT, IDLE} READY_WAIT_T;    
typedef enum {VALID,INVALID} INVALID_VALID_T;          
    
typedef enum logic[1:0]{EQUAL,GREATER,LESSER} comparator_T;      

//typedef  logic [7:0] pixel_T;      
//typedef  pixel_T [DIMENSION_ROWS-1:0][DIMENSION_COLUMNS-1:0] node_vector_T;        
typedef bit [(VECTOR_LEN*8)-1:0] node_vector_T;          

typedef bit [(VECTOR_LEN*9)-1:0] node_vector_signed_T;                

////////////////////memory structure//////////////////////////////
//single node structure in a class in memory layer    
                  
typedef struct { 
       //define enum type enum {INVALID,VALID}  
node_vector_T X;                       
int class_name; // chek if needed  
node_vector_T W;       
int Th;  
int M;  
}node_T;                                     
    

// class structure in memory layer   
typedef struct{                                      
int class_name;    
node_T node[NODE_COUNT:1];       
//single_node_connection_T connections[NODE_COUNT-1:0][NODE_COUNT-1:0];  //use a separate connection mem
int node_count;     
}class_T;
 
typedef struct{
class_T classes[CLASS_COUNT:1];     
}memory_T;   
////////////////////////////////////////////////////////////////////////
   

   
 
///////////////node counter structure /////////
typedef struct{
int node_count[CLASS_COUNT:1];       
}node_counter_mem_T;     
///////////////////////////////////////////////  

                 

/////////connection memory structure/////////// 
typedef struct{  
bit connection_presence;  
int age;  
}single_node_connection_T;    
  
typedef struct {
single_node_connection_T connection_nodes[NODE_COUNT:1][NODE_COUNT:1]; 
}connection_bw_nodes_T; 

typedef struct{
connection_bw_nodes_T connection_class[CLASS_COUNT:1];
}connection_mem_T ; 


 ///////////////////////////////////////////// 
 ////associate layer//////////////////////////////////////////////////////
 
/* typedef struct{
int class_name;
int m;  //assoc index of node 
node_vector_T W;
int response_class[NODE_COUNT:0];   
}AL_node_T;   //node associate Layer      

/////////connection memory structure/////////// 
typedef struct{   
logic connection_presence;
int weight;  
}AL_single_node_connection_T;    
 /////////////////////////////////////////////
  
typedef struct{      
AL_node_T node[CLASS_COUNT:1];  
AL_single_node_connection_T connection[CLASS_COUNT:1][CLASS_COUNT:1];   //connection set  
}AL_memory_T;    */
    
 //task for log 
task info_log(input string info_log_to_display); 
`ifdef INFO_LOG
$display("\n",$time, "\t INFO: %s", info_log_to_display);  
`endif      
endtask
 
 
 /////////////////////////////////////////////////////////////////////////
memory_T memory;    //memory Layer Memory 
//AL_memory_T AL_memory;   //associative layer memory  
node_counter_mem_T node_counter;  //node_counter 
connection_mem_T connection;  //connection memory 
INVALID_VALID_T invalid_node_list[CLASS_COUNT:1][NODE_COUNT:1] ;     ////node validity                      
      
 
 endpackage:GAM_package 
 
 import GAM_package::* ;  
 
 `endif   
 