// João Vitor Moura Figueiredo
// Contagem 10s congelamento e reinicio

//Mudando o valor de clock para ter a frequência 1
parameter divide_by=50000000;  // divisor do clock de referência
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

  // Criando os numeros a serem exibidos no display
  parameter ZERO = 'b00111111;
  parameter UM = 'b00000110;
  parameter DOIS = 'b01011011;
  parameter TRES = 'b01001111;
  parameter QUATRO = 'b01100110;
  parameter CINCO = 'b01101101;
  parameter SEIS = 'b01111101;
  parameter SETE = 'b00000111;
  parameter OITO = 'b01111111;
  parameter NOVE = 'b01100111;
  parameter DEZ = 'b01110111; // O dez será exibido em hex, ou seja será mostrada a letra A
  parameter APAGADO = 'b00000000; //Display apagado

  parameter NBITS_CONTADOR = 4;

  logic [NBITS_CONTADOR-1:0] contador;

  always_comb begin 
    case (contador)
      0: SEG <= ZERO;
      1: SEG <= UM;
      2: SEG <= DOIS;
      3: SEG <= TRES;
      4: SEG <= QUATRO;
      5: SEG <= CINCO;
      6: SEG <= SEIS;
      7: SEG <= SETE;
      8: SEG <= OITO;
      9: SEG <= NOVE;
      10: SEG <= DEZ;
      default:SEG <= APAGADO;
    endcase
  end

  //Atribuindo controles de parada e de reset
  logic congelamento, reinicio, inversao;
  
  //
  always_comb begin
    reinicio <= SWI[0];
    congelamento <= SWI[1];  
    inversao <= SWI[2];
  end

  always_ff @(posedge clk_2 ) begin
    if (reinicio) contador <= 0; //Reseta a contagem para 0
    else if (congelamento) contador <= contador; //Congela a contagem
    else if (~inversao && contador < 10) contador <= contador + 1; //Incremento do contador
    else if (inversao && contador != 0) contador <= contador-1;
    else contador <= contador; //Para o contador quando chega ao fim
  end


endmodule

