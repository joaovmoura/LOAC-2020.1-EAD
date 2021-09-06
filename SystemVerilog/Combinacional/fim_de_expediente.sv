// Questão 1

logic eh_noite;
logic maquinas_paradas;
logic eh_sexta;
logic expectativa_producao;

always_comb eh_noite <= SWI[4];
always_comb maquinas_paradas <= SWI[5];
always_comb eh_sexta <= SWI[6];
always_comb expectativa_producao <= SWI[7];

logic sinal_alarme;
always_comb LED[2] <= sinal_alarme;

always_comb sinal_alarme <= (eh_noite & maquinas_paradas) | (eh_sexta & expectativa_producao);

