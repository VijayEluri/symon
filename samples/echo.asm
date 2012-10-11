;;
;; Read input from the keyboard, and echo to console.
;;


.alias iobase   $c000
.alias iostatus [iobase + 1]
.alias iocmd    [iobase + 2]
.alias ioctrl   [iobase + 3]

.org $0300

start:  cli
        lda #$09
        sta iocmd      ; Set command status
        lda #$16
        sta ioctrl     ; 0 stop bits, 8 bit word, 300 baud

;; Load a character from the keyboard and store it into
;; the accumulator

getkey: lda iostatus   ; Read the ACIA status
        and #$08       ; Is the rx register empty?
        beq getkey     ; Yes, wait for it to fill
        lda iobase     ; Otherwise, read into accumulator

;; Write the current char in the accumulator to the console

write:  pha            ; Save accumulator
        lda iostatus   ; Read the ACIA status
        and #$10       ; Is the tx register empty?
        beq write      ; No, wait for it to empty
        pla            ; Otherwise, load saved accumulator
        sta iobase     ; and write to output.

        jmp getkey     ; Repeat
