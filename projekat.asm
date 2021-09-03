data SEGMENT
    poruka1 db "Broj se nalazi u stringu.$"
    poruka2 db "Broj se nalazi u stringu.$"
    niz dw 1,2,3,4,5,6,7,8,9,10
data ENDS

stek segment stack
    dw 128 dup(0)
stek ends

writeString macro s
    push ax
    push dx  
    mov dx, offset s
    mov ah, 09
    int 21h
    pop dx
    pop ax
endm

code segment
; int binarySearch(int arr[], int l, int r, int x)
binarySearch proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov bp, sp
    
    mov di, [bp + 12]   ; pokazivac na niz
    mov dx, [bp + 14]   ; leva granica
    mov ax, [bp + 16]   ; desna granica
    mov cx, [bp + 18]   ; broj koji se trazi

    sub ax, dx          ; ax = ax - dx => r - l
    js notFound           ; proverimo da li je r > l
    
    mov si, 2           ; podelimo razliku za 2, da bi mogli da dodjemo do sredine
    div si
    add ax, si          ; l = l + (r - l) / 2

    add di, ax
    add di, ax
    mov si, [di]
    cmp cx, si          ; uporedi da li je to taj broj
    je returnIndeks     ; vrati indeks
    jb recursiveRight    ; idemo u levi podniz
    jmp recursiveLeft
recursiveRight:
    push cx             ; x
    push [bp + 16]      ; desna granica
    inc ax              ; leva granica nam je sad sredina povecana za 1
    push ax             ; leva granica
    push niz            ; niz
    call binarySearch
    jmp return


recursiveLeft:
    push cx             ; x
    dec ax              ; desna granica je sada sredina smanjena za 1
    push ax             ; desna granica
    push [bp + 14]      ; leva granica
    push niz            ; niz
    call binarySearch
    jmp return

notFound:
    writeString poruka1
    jmp return

returnIndeks:
    writeString poruka2

return:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 6
binarySearch endp

start:
    ASSUME cs: code, ss:stek
    mov ax, data
    mov ds, ax

    ; int binarySearch(int arr[], int l, int r, int x)
    push 8              ; x
    push 10             ; r
    push 0              ; l
    push offset niz     ; niz
    call binarySearch

end start
ends