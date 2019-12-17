
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$10,-4(%14)
		MOV 	$0,-8(%14)
@switch0:
		MOV 	-4(%14),%0
@case10:
		CMPS 	$10,%0
		JNE 	@case_kraj10
		MOV 	$1,-8(%14)
		JMP 	@exit0
@case_kraj10:
@case20:
		CMPS 	$20,%0
		JNE 	@case_kraj20
		MOV 	$2,-8(%14)
@case_kraj20:
@exit0:
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET