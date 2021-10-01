logic porta_cofre;
logic horario_expediente;
logic interruptor_gerente;

always_comb porta_cofre <= SWI[0];
always_comb horario_expediente <= SWI[1];
always_comb interruptor_gerente <= SWI[2]

logic atuadores;
always_comb SEG[0] <= atuadores;

always_comb atuadores <= porta_cofre & ~(horario_expediente & ~interruptor_gerente);
