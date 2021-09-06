logic temperatura_maior_que_15;
logic temperatura_maior_que_20;

always_comb SWI[3] <= temperatura_maior_que_15;
always_comb SWI[4] <= temperatura_maior_que_20;

logic aquecedor;
logic resfriador;
logic inconsistencia;

always_comb LED[6] <= aquecedor;
always_comb LED[7] <= resfriador;
always_comb SEG[7] <= inconsistencia;

always_comb aquecedor <= ~(temperatura_maior_que_15 |temperatura_maior_que_20);

always_comb resfriador <= (temperatura_maior_que_15 & temperatura_maior_que_20);

always_comb inconsistencia <= (~temperatura_maior_que_15 & temperatura_maior_que_20);

