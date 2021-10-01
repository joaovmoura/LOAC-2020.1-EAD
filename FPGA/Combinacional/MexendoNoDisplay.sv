// Brincamos com display de sete segmentos	

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
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

		//Parâmetros com os códigos hexadecimais dos símbolos a serem exibidos no display
    parameter LETRA_A = 'h77;
    parameter LETRA_b = 'h7c;
    parameter LETRA_C = 'h39;
		parameter LETR_c  = 'h58;
    parameter LETRA_d = 'h5e;
    parameter LETRA_E = 'h79;
    parameter LETRA_F = 'h71;
    parameter LETRA_g = 'h6f;
    parameter LETRA_H = 'h76;
    parameter LETR_h  = 'h74;
    parameter LETR_i  = 'h10;
    parameter LETRA_I = 'h6;
		parameter LETRA_J = 'h1e;
    parameter LETRA_L = 'h38;
    parameter LETRA_n = 'h54;
    parameter LETRA_O = 'h3f;
    parameter LETR_o  = 'h5c;
    parameter LETRA_P = 'h73;
		parameter LETRA_q = 'h67;
    parameter LETRA_r = 'h50;
    parameter LETRA_S = 'h6d;
    parameter LETRA_t = 'h78;
    parameter LETRA_U = 'h3e;
    parameter LETRA_v = 'h1c;
		parameter LETRA_y = 'h6e;
    parameter GRAU    = 'h63;
    parameter zero    = 'h3f;
    parameter um      = 'h06;
    parameter dois    = 'h5b;
    parameter tres    = 'h4f;
    parameter quatro  = 'h66;
    parameter cinco   = 'h6d;
    parameter seis    = 'h7d;
    parameter sete    = 'h7;
    parameter oito    = 'h7f;
    parameter nove    = 'h6F;
    
		//Variáveis de controle
    logic unsigned [5:0]W;

  always_comb begin
		//Chaves de zero a cinco controlam o que será exibido no display de 7 segmentos
    W <= SWI[5:0];
		
		//Descrição comportamental do funcionamento do sistema
		case (W)
			0: SEG  <= zero;
			1: SEG  <= um;
			2: SEG  <= dois;
			3: SEG  <= tres;
			4: SEG  <= quatro;
			5: SEG  <= cinco;
			6: SEG  <= seis;
			7: SEG  <= sete;
			8: SEG  <= oito;
			9: SEG  <= nove;
			10: SEG <= LETRA_A;
			11: SEG <= LETRA_b;
			12: SEG <= LETRA_C;
			13: SEG <= LETRA_d;
			14: SEG <= LETRA_E;
			15: SEG <= LETRA_F;
			16: SEG <= LETRA_A;
			17: SEG <= LETRA_b;
			18: SEG <= LETRA_C;
			19: SEG <= LETR_c;
			20: SEG <= LETRA_d;
			21: SEG <= LETRA_E;
			22: SEG <= LETRA_F;
			23: SEG <= LETRA_g;
			24: SEG <= LETRA_H;
			25: SEG <= LETR_h;
			26: SEG <= LETR_i;
			27: SEG <= LETRA_I;
			28: SEG <= LETRA_J;
			29: SEG <= LETRA_L;
			30: SEG <= LETRA_n;
			31: SEG <= LETRA_O;
			32: SEG <= LETR_o;
			33: SEG <= LETRA_P;
			34: SEG <= LETRA_q;
			35: SEG <= LETRA_r;
			36: SEG <= LETRA_S;
			37: SEG <= LETRA_t;
			38: SEG <= LETRA_U;
			39: SEG <= LETRA_v;
			40: SEG <= LETRA_y;
			41: SEG <= GRAU;
			default: SEG <= 0;
		endcase
	end
endmodule




