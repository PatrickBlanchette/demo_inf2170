main:    SUBSP   10,i
         LDA     0,i
         STA     s,s
         STA     olds,s
         DECI    sz,s
;
         LDA     0,i
for:     STA     i,s
         CPA     sz,s
         BRGE    endf
         LDA     szA,i
         CALL    malloc
         STX     s,s
         DECI    val,s
         LDA     val,s
         CALL    setv
         LDA     olds,s
         CALL    seto
         STX     olds,s
         LDA     i,s
         ADDA    1,i
         BR      for
;
endf:    LDX     s,s
while:   CPX     0,i
         BRLE    end
         CALL    getv
         STA     val,s
         DECO    val,s
         CHARO   ' ',i
         CALL    geto
         BR      while
end:     ADDSP   10,i         
         STOP                
; variable local du main
s:       .EQUATE 0           
olds:    .EQUATE 2
sz:      .EQUATE 4
i:       .EQUATE 6
val:     .EQUATE 8
;
; struct A
szA:     .EQUATE 4           ; octets
valA:    .EQUATE 0           ; Valuer de A
otherA:  .EQUATE 2           ; Next A
;
; retourne la valeur de struct A
;
; Params:
;     * Register X: address de struct A
; Returns:
;     * Register A: valeur de struct A
getv:    LDA     valA,x
         RET0               
;
; retourne la prochaine struct A
;
; Params:
;     * Register X: addresss de struct A
; Returns:
;     * Register X: addresse de la prochaine struct A
geto:    LDX     otherA,x
         RET0                            
;
; modifie la valeur de struct A
;
; Params:
;     * Register X: addresss de struct A
;     * Register A: nouvelle valeur de struct A
; Returns:
;     VOID
setv:    STA     valA,x
         RET0                            
;
; modifie la prochaine struct A de struct A
;
; Params:
;     * Register X: addresss de struct A
;     * Register A: nouvelle prochaine struct A
; Returns:
;     VOID
seto:    STA     otherA,x
         RET0                            
;
; Allocates `n` bytes on the Heap
;
; Params:
;	* Register A: `n` bytes to allocate
; Returns:
;	* Register X: Address of the allocated block
malloc:  LDX     heap_ptr,d  
         ADDA    heap_ptr,d  
         STA     heap_ptr,d  
         RET0                
heap_ptr:.ADDRSS heap        
heap:    .BYTE   0           
         .END                  