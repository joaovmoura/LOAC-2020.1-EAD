// João Vitor Moura
// Pisca-pisca reinicio, congelamento e troca de sentido

parameter divide_by = 50000000;  // divisor do clock de referência
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

  parameter NBITS_PISCA = 8;
  parameter INICIO_DIR = 'b10000000; //inicio do sentido da direita
  parameter INICIO_ESQ = 'b00000001; //inicio do sentido da esquerda

  logic [NBITS_PISCA-1:0] pisca_pisca; //Alocando saída do pisca pisca nos LEDs
  logic reinicio, congelamento, troca_sentido;

  /* 
  Chaves de entrada:
    
  SWI[0]: reinicia o pisca pisca seguindo o ultimo sentido configurado

  SWI[1]: pausa o andamento dos leds

  SWI[2]: troca o sentido direita-esquerda e vice-versa
  */

  always_comb begin
    reinicio <= SWI[0];
    congelamento <= SWI[1];
    troca_sentido <= SWI[2]; 
  end

  always_ff @(posedge clk_2 ) begin
    if ((pisca_pisca==0 || reinicio) && ~troca_sentido) pisca_pisca <= INICIO_DIR; //overflow ou reinicio c/ sentido para a direita
    else if ((pisca_pisca==0 || reinicio) && troca_sentido) pisca_pisca <= INICIO_ESQ; //overflow ou reinicio c/ sentido para a esquerda
    else if (congelamento) pisca_pisca <= pisca_pisca; //congelamento
    else if (troca_sentido) pisca_pisca <= pisca_pisca*2; //para a esquerda
    else pisca_pisca <= pisca_pisca/2; //para a direita

  end

  always_comb begin 
    LED <= pisca_pisca;
  end
endmodule


