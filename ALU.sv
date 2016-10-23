import GAM_package::* ; 
 
parameter array_length = 8; 

 
module  addition(
input logic signed [array_length  :0] a, b,        
output logic signed[array_length-1:0] c);
logic   overflow;  

always_comb 
begin  
	overflow= (a[array_length -1] & b[array_length -1]) ;   //changed     
	 c =  a+ b;         
//	assert (overflow == 1) $display ("Overflow occured");	
end   	  
 

endmodule                    
 
module subtraction(
input logic [array_length-1:0] a, b,
//input  logic[ array_length -1: 0] b;
output  logic [array_length-1:0] c);
always_comb 
begin 	
	
	if ( a < b  )
		c  = b - a;
	else 
		c = a-b; 
end  	    
endmodule 
 
module subtraction_signed(
	input logic signed [array_length:0] a,b,
	output logic signed [array_length:0] out);   
  
always_comb
out<=a-b;              

endmodule 

//int subtraction
module subtraction_int(
input int  a, b,        
output int c); 
always_comb  
begin       
c =  a-b;          
end   	  
endmodule    

   
module  multiplication(   //change w.r.t port sizes and overflow  

input logic [array_length-1:0] a,b,  
output logic   [(2*array_length)-1:0] c);  
logic overflow;
always_comb 
begin 
 {overflow, c} = a * b;
// assert to check overflow
//	assert (overflow != 1) $display ("Overflow occured");	

end 
endmodule


module  division(
input int signed a, // 
input int signed b,
output int signed c); 
always_comb 
begin 
 c = a / b; 
end
endmodule 

module  division_logic(                              
input logic signed [array_length:0]a,
input int b, 
output logic signed [array_length:0]c);  

always_comb          //new module [array_length:0] 
begin 
 c = (a / b);                       
end
endmodule
     


module  square(
input logic [array_length -1 :0] a,

output int   b);
always_comb 
begin 
 b = a ** 2; 
end    
endmodule  

//int square 
module  square_int(
input int  a,

output longint  b);
always_comb 
begin 
 b = a*a;     
end    
endmodule   

   
module  sqrt( 
input int a,
output int out);
int  square = 1;
int  delta = 3;
always_comb 
begin
square = 1;    
delta=3;    //eleminates warning in line 113
  
begin: sqrt_loop  
for ( int i =0; i < 4999; i++) // Adding 1000 to avoid maximum loop couner . Can also use -max_loop_cnt number 
begin 
square = square + delta;
delta = delta + 2;
if (square> a)
begin 
disable sqrt_loop; 
$display("Disbale Branch in sqrt square is %d and a is %d", square,a);
end   
end  
end: sqrt_loop  
out = (delta/2 - 1);

if (a == 0)
out = a;


end 
endmodule 
 
module  int_addition(
input int signed a, b,
output int signed c);     //change port c size to 8                 
logic   overflow;    		
 
always_comb 
begin 
	{overflow, c} = {a[31], a} + {b[31], b};
//	assert (overflow != 1) $display ("Overflow occured");	
end   	
endmodule      


// Validate the block mentioned below !!!!!!!!!!!!
module square_results_adder(
input logic [(VECTOR_LEN*32) -1 :0] a, 
output int out);

always_comb 

begin 	
	out = 0;

	for ( int i =0; i<VECTOR_LEN ; i++ )
	begin

		 out += a[(i*32) +:32];    

	end 

end 
     
endmodule             