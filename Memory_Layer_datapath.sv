//`timescale 1ns/1ps 

import GAM_package::* ;

module Memory_Layer_datapath(
	input clk,
	input node_vector_T x,
	input int c, 
	input logic ld_upcounter,en_upcounter,en_node_counter,en_connection,en_2min,learning_done, 
	input logic X_c,C_c,W_c,T_c,M_c,
	input RD_WR_T RD_WR_c,
	input logic [1:0] mux1_sel,mux2_sel,mux3_sel,mux4_sel,mux5_sel,mux6_sel,demux_sel,
	output comparator_T comparator_c); 


//internal registers   
node_vector_T Reg_x,Reg_Ws1, Reg_Ws2;
int Reg_Cx,Reg_Ths1,Reg_Ms1;               		//make these 8 bit register if possible
int Reg_min1_node,Reg_min2_node,Reg_min1_ED,Reg_min2_ED; 


//////////////internal wires//////////////////////////////////////////////
//multiplexer and demultiplexer outputs
int out_mux[6:1];     //mux[2] i/o type and module  
int in_mux[6:1][3:0];

node_vector_T in_mux2[3:0],out_mux2,in_demux,out_demux[3:0];    
//ED block 
int out_ED;	    
//2 min finder block 
 
//comparator
 
//calculate ws1 ws2 ths1 block

//up-counter block

//node counter block

//////////////////////////////////////////////////////////////////////////
//assignig inputs and outputs to signals
always@(x,c,out_demux[1],out_demux[2],Reg_Ths1,Reg_Ms1,Reg_Cx,Reg_min1_ED)      
begin
Reg_x<=x;   
Reg_Cx<=c;
Reg_Ws1<=out_demux[1];Reg_Ws2<=out_demux[2];
//in_mux[1][0]<=node_count;    
in_mux[6][2]<=Reg_Ths1;
in_mux[4][1]<=Reg_Ms1+1;  
in_mux[6][0]<=Reg_Cx;
in_mux[5][2]<=Reg_min1_ED; 
         
end                
                   
Memory_Layer_memory mem_dp(clk,
	Reg_Cx,out_mux[1],out_mux[3],out_mux[4],
	X_c,C_c,W_c,T_c,M_c,RD_WR_c, 
	Reg_x,out_mux2,in_mux[5][0], Reg_Ths1,Reg_Ms1,in_demux); //???node_o  //??do we need X_o 

ED_calculator ED (Reg_x,out_demux[0],out_ED); 
  
min_finder min2 (clk, en_2min,out_ED,in_mux[1][1], 
	Reg_min1_node,Reg_min2_node,Reg_min1_ED,Reg_min2_ED); 

calculate_W_Th calc_alg1 ( 
	Reg_x,Reg_Ws1,Reg_Ws2,Reg_Ths1,in_mux[4][1],Reg_min1_ED,    
	in_mux2[1],in_mux2[2],in_mux[3][2]);  //??type of mux[2]         
   
Memory_Layer_connection_memory conn_mem (
	Reg_min1_node,Reg_min2_node,Reg_Cx,
	en_connection,learning_done);  	
			
Memory_Layer_node_counter node_counter(
	Reg_Cx, en_node_counter,in_mux[1][0],in_mux[6][1]);              
              
comparator comp (out_mux[5],out_mux[6],comparator_c);     

demux dm (in_demux,out_demux[0],out_demux[1],out_demux[2],out_demux[3],demux_sel);

upcounter uc (clk,ld_upcounter,en_upcounter,1,in_mux[1][1]); //in_mux[1][1]=in_mux[5][1] 
//modify mux 2 
mux mux1(in_mux[1][0],in_mux[1][1],Reg_min1_node,Reg_min2_node,out_mux[1],mux1_sel);      
//mux mux2(in_mux[2][0],in_mux[2][1],in_mux[2][2],in_mux[2][3],out_mux[2],mux2_sel);
mux_W mux2(Reg_x,in_mux2[1],in_mux2[2],in_mux2[3],out_mux2,mux2_sel);   
mux mux3(0,Reg_min1_ED,in_mux[3][2],in_mux[3][3],out_mux[3],mux3_sel); 
mux mux4(1,in_mux[4][1],in_mux[4][2],in_mux[4][3],out_mux[4],mux4_sel);
mux mux5(in_mux[5][0],in_mux[1][1],in_mux[5][2],in_mux[5][3],out_mux[5],mux5_sel);
mux mux6(in_mux[6][0],in_mux[6][1],in_mux[6][2],in_mux[6][3],out_mux[6],mux6_sel);   


endmodule 




