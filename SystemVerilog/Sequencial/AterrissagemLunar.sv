// João Vitor Moura Figueiredo	
// Foguete lunar
// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter divide_by= 100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
  end
		
		//Definindo os valores das constantes
		parameter NBITS_COMBUST = 8;
		parameter NBITS_VELOCID = 12;
		parameter NBITS_ALTURA = 12;
  	parameter INCR = 1;
  	parameter COMBUST_INICIAL = 120;
  	parameter VELOCID_INICIAL = -50;
		parameter ALTURA_INICIAL = 500;
		parameter ACEL_GRAVIT = 5;
	
		//Chaves de entrada do sistema
  	logic reset;
		logic [6:0]decr_combust;
   
  //Atribuindo chaves de entrada
	always_comb	begin
		reset <= SWI[0];
		decr_combust <= SWI[7:1];
	end
	  
		logic [NBITS_COMBUST-1:0] combustivel = COMBUST_INICIAL;
		logic signed [NBITS_VELOCID-1:0] velocidade = VELOCID_INICIAL;
		logic [NBITS_ALTURA-1:0] altura = ALTURA_INICIAL;

    //Calculo dos contadores conforme o pulso do clock, considerando as alterações nas entradas
	always_ff@(posedge clk_2) begin
		if(~reset)begin
		  
		  if(altura!=0) begin
			
			  if(decr_combust!=0 && combustivel>0) begin
			
			    if(combustivel > decr_combust) begin
			      combustivel <= combustivel - decr_combust;
			      velocidade <= velocidade + decr_combust;
			    end
			    else begin
			      combustivel <= 0;
			      velocidade <= velocidade + combustivel;
			    end
			    
			  end
			  else begin
			    velocidade <= velocidade - ACEL_GRAVIT;
	      end
	      if(velocidade<0)begin
	        if((altura+velocidade)>0)altura <= altura + velocidade;
	        else altura <= 0;
	      end
	      else altura <= altura+velocidade;
		  end
		  else begin
			  combustivel <= combustivel;
			  velocidade  <= velocidade;
		  end
		end
		else begin
		  combustivel <= COMBUST_INICIAL;
			velocidade  <= VELOCID_INICIAL;
			altura <= ALTURA_INICIAL;
    end
	end

    //Atribuição da saída ao diplay LCD A
	always_comb begin
		LED   <= combustivel;
		lcd_b <= velocidade;
		lcd_a <= altura;
	end

endmodule


