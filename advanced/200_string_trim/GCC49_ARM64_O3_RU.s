str_trim:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp,16]
	mov	x19, x0
; X19 всегда будет содержать значение "s"
	bl	strlen
; X0=str\_len
	cbz	x0, .L9        ; перейти на L9 (выход), если str\_len==0
	sub	x1, x0, #1
; X1=X0-1=str\_len-1
	add	x3, x19, x1
; X3=X19+X1=s+str\_len-1
	ldrb	w2, [x19,x1]   ; загрузить байт по адресу X19+X1=s+str\_len-1
; W2=загруженный символ
	cbz	w2, .L9        ; это ноль? тогда перейти на выход
	cmp	w2, 10         ; \verb|это '\n'?|
	bne	.L15
.L12:
; тело главного цикла. загруженный символ в этот момент всегда 10 или 13!
	sub	x2, x1, x0
; X2=X1-X0=str\_len-1-str\_len=-1
	add	x2, x3, x2
; X2=X3+X2=s+str\_len-1+(-1)=s+str\_len-2
	strb	wzr, [x2,1]    ; записать нулевой байт по адресу s+str\_len-2+1=s+str\_len-1
	cbz	x1, .L9        ; str\_len-1==0? перейти на выход, если это так
	sub	x1, x1, #1     ; str\_len--
	ldrb	w2, [x19,x1]   ; загрузить следующий символ по адресу X19+X1=s+str\_len-1
	cmp	w2, 10         ; \verb|это '\n'?|
	cbz	w2, .L9        ; перейти на выход, если это ноль
	beq	.L12           ; \verb|перейти на начало цикла, если это '\n'|
.L15:
	cmp	w2, 13         ; \verb|это '\r'?|
	beq	.L12           ; да, перейти на начало тела цикла
.L9:
; возврат "s"
	mov	x0, x19
	ldr	x19, [sp,16]
	ldp	x29, x30, [sp], 32
	ret
