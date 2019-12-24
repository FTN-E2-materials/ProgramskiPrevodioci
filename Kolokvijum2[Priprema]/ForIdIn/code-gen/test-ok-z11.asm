
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$0,-8(%14)
		MOV	$0,%0
		MOV 	$1,-4(%14)
@for0:
		CMPS 	$1,$5
		JLES 	@inc0
@dec0:
		MOV	$1,%0
		JMP	@statement_fora0
@inc0:
		MOV	$2,%0
@statement_fora0:
		CMPU 	%0,$1
		JNE 	@provera_kraja_inc0
@provera_kraja_dec0:
		CMPS 	-4(%14),$5
		JLTS 	@kraj_fora0
		JMP	@pocetak_sf0
@provera_kraja_inc0:
		CMPS 	-4(%14),$5
		JGTS 	@kraj_fora0
@pocetak_sf0:
		ADDS	-8(%14),-4(%14),%1
		MOV 	%1,-8(%14)
		CMPU 	%0,$1
		JNE 	@inkrement_deo0
@dekrement_deo0:
		SUBS	-4(%14),$1,-4(%14)
		JMP	@statement_fora0
@inkrement_deo0:
		ADDS	-4(%14),$1,-4(%14)
		JMP	@statement_fora0
@kraj_fora0:
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET