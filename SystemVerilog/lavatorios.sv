logic lavatorio_mulheres;
logic lavatorio_2;
logic lavatorio_3;

always_comb lavatorio_mulheres <= SWI[0];
always_comb lavatorio_2 <= SWI[1];
always_comb lavatorio_3 <= SWI[2];

logic led_livre_mulher;
logic led_livre_homem;

always_comb LED[0] <= led_livre_mulher;
always_comb LED[1] <= led_livre_homem;


always_comb led_livre_mulher <= ~(lavatorio_mulheres & lavatorio_2 & lavatorio3);

always_comb led_livre_homem <=  ~(lavatorio2 & lavatorio3);
