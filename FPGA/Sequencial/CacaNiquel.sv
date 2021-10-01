// João Vitor Moura Figueiredo	
// Simulador caça-níquel com 3 contadores
// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter divide_by= 40000000;  // divisor do clock de referência
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
		parameter NBITS_COUNT = 4;
  	parameter INCR = 1;
  	parameter INICIO = 0;
		parameter LIMITE = 6;
  	parameter FINAL_DIGITO_1 = 3;
  	parameter FINAL_DIGITO_2 = 7;
  	parameter FINAL_DIGITO_3 = 11;
	
		//Chaves de entrada do sistema
  	logic reset, trava_cont_1, trava_cont_2, trava_cont_3;
   
  //Atribuindo chaves de entrada
	always_comb	begin
		reset <= SWI[0];
		trava_cont_1 <= SWI[1];
		trava_cont_2 <= SWI[2];
		trava_cont_3 <= SWI[3];
	end
	  
		logic [NBITS_COUNT-1:0] contador1;
		logic [NBITS_COUNT-1:0] contador2;
		logic [NBITS_COUNT-1:0] contador3;

    //Calculo dos contadores conforme o pulso do clock, considerando as alterações nas entradas
	always_ff@(posedge clk_2) begin
		if(~reset) begin
			if(~trava_cont_1 && contador1 < LIMITE) contador1 <= contador1 + INCR;
			else if(~trava_cont_1 && contador1 == LIMITE) contador1 <= INICIO;
			else contador1 <= contador1;

			if(~trava_cont_2 && contador2 < LIMITE) contador2 <= contador2 + INCR;
			else if(~trava_cont_2 && contador2 == LIMITE) contador2 <= INICIO;
			else contador2 <= contador2;

			if(~trava_cont_3 && contador3 < LIMITE) contador3 <= contador3 + INCR;
			else if(~trava_cont_3 && contador3 == LIMITE) contador3 <= INICIO;
			else contador3 <= contador3;
		end
		else begin
			contador1 <= INICIO;
			contador2 <= INICIO;
			contador3 <= INICIO;
		end
	end

    //Atribuição da saída ao diplay LCD A
	always_comb begin
		lcd_a[FINAL_DIGITO_1:0] <= contador1;
		lcd_a[FINAL_DIGITO_2:4] <= contador2;
		lcd_a[FINAL_DIGITO_3:8] <= contador3;
	end

endmodule




