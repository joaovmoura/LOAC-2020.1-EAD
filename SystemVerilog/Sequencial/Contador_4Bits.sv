// João Vitor Moura Figueiredo
// Contador 4 bits - contagem com reset, incremento de 1/3 , crescente/decrescente, congelamento e saturação
// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display


parameter divide_by=100000000;  // divisor do clock de referência
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
    LED <= SWI;
    SEG <= SWI;
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

	parameter NBITS = 4;
  	parameter INCR_1 = 1;
  	parameter INCR_3 = 3;
  	parameter INICIO_CONT = 0;
  	parameter FINAL_CONT = 15;
  	logic reset, decrescente, incr_3, congelamento, saturacao;
  	logic [NBITS-1:0] counter;
    
    //Atribuindo chaves de entrada e inicializando o contador
	always_comb	begin
		reset <= SWI[0];
		decrescente <= SWI[1];
		incr_3 <= SWI[2];
		congelamento <= SWI[3];
		saturacao <= SWI[4];
		counter = INICIO_CONT;
	end
	
    //Calculo do contador conforme o pulso do clock, considerando as alterações nas entradas
	always_ff@(posedge clk_2) begin
		if(~congelamento) begin
			if(saturacao && (counter == FINAL_CONT || counter == INICIO_CONT)) counter = counter;
            else begin
				if(reset) counter = INICIO_CONT;
				else if(decrescente) begin
					if(incr_3) counter = counter - INCR_3;
					else counter =  counter - INCR_1;
				end
				else begin 
					if(incr_3) counter = counter + INCR_3;
					else counter =  counter + INCR_1;			
				end	
			end
		end
		else begin
			counter = counter;
		end
	end
    
    //Atribuição da saída ao diplay LCD B
	always_comb begin
		lcd_b = counter;
	end
endmodule


