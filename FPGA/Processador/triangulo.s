/* Joao Vitor Moura */
/* executar o código Assembly na placa FPGA - Condição de existência do triângulo */

.section .text
.globl main
/*
  Recebe os lados do triângulo das chaves SWI[4:0] a cada clock
  
*/
main:
	li	s0,252
 	lw	a0,0(s0) /* Recebe lado 1 */
 	lw	a1,0(s0) /* Recebe lado 2 */
 	lw	a2,0(s0) /* Recebe lado 3 */
 	call	eh_triangulo
 	sw	a0,0(s0)

/* Iremos usar o registrador sp para fazer acessos à memória.
   Spike supõe RAM a partir do endereço 0x80000000.
   A instrução lui coloca este valor em sp.
   Não precisa usar esta instrução para a implementação FPGA. 
        lui     sp,0x80000
	addi	sp,sp,0x40 */

/* Verifica se os lados satisfazem a condição de exixtência de um triângulo
   se sim LED[4:0] -> 1
   se não LED[4:0] -> 2*/

eh_triangulo:

 	mv	a5,a0
 	add	a4,a0,a1
 	ble	a4,a2,.L3
 	add	a4,a0,a2
 	li	a0,2
 	ble	a4,a1,.L1
 	add	a1,a1,a2
 	sgt	a0,a1,a5
 	xori	a0,a0,1
 	addi	a0,a0,1
 	ret

.L3:
 	li	a0,2
.L1:
 	ret
fim:
.skip  0x20 - (fim -main)  /* cria espaço ate o endereço 0x20 */
        lw   t4, 48(s0)    /* esta instrução ficará no endereço 0x20 */