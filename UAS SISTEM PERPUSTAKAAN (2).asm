.MODEL SMALL
.STACK 100H

; =========================================================================
; MACRO DEFINITION
; =========================================================================
CETAK_TEKS MACRO PESAN
    LEA DX, PESAN
    MOV AH, 09H
    INT 21H
ENDM

CETAK_KARAKTER MACRO KAR
    MOV DL, KAR
    MOV AH, 02H
    INT 21H
ENDM

.DATA
    ; --- Database Kredensial Petugas ---
    DATA_PASS_PETUGAS DB 'admin123$'
    ATTEMPT_COUNTER   DB 3

    ; --- Tampilan Antarmuka Login ---
    INP_LOGIN_HDR DB 13,10,'============================================'
                  DB 13,10,'|        LOGIN PETUGAS PERPUSTAKAAN        |'
                  DB 13,10,'============================================$'
    INP_USER_NAMA DB 13,10,'  Masukkan Nama Petugas : $'
    INP_USER_PASS DB 13,10,'  Masukkan Password     : $'
    MSG_LOGIN_ERR DB 13,10,'[AKSES DITOLAK] Password Salah!$'
    MSG_ATTEMPT   DB 13,10,'Sisa percobaan login Anda: $'
    MSG_BLOCKED   DB 13,10,'[SISTEM TERKUNCI] Terlalu banyak salah login!$'
    MSG_LOGIN_OK  DB 13,10,'[AKSES DITERIMA] Selamat Bekerja, $'

    ; --- Tampilan Antarmuka Menu Utama ---
    HDR           DB 13,10,'============================================'
                  DB 13,10,'|          PERPUSTAKAAN DIGITAL v10.0      |'
                  DB 13,10,'============================================$'
    
    MENU_MAIN     DB 13,10,'  1. Lihat Katalog Buku (ID 1-12)'
                  DB 13,10,'  2. Form Peminjaman Buku'
                  DB 13,10,'  3. Form Pengembalian, Kondisi & Cetak Struk'
                  DB 13,10,'  4. Keluar Aplikasi'
                  DB 13,10,'--------------------------------------------'
                  DB 13,10,'Pilihan Menu [1-4]: $'
    
    MSG_KEMBALI   DB 13,10,13,10,'Tekan tombol apa saja untuk kembali ke Menu...$'
    LINE_STR      DB 13,10,'=============================================$'

    ; --- Header Halaman Katalog ---
    KAT_HDR1      DB 13,10,13,10,'=========== KATALOG BUKU AKTIF ============$'

    ; --- DATABASE 12 JUDUL BUKU (Disesuaikan ke 10-15) ---
    T_BK01 DB 13,10,'[ID: 01] Algoritma & Pemrograman     | Stok: $'
    T_BK02 DB 13,10,'[ID: 02] Perakitan Bahasa Assembly   | Stok: $'
    T_BK03 DB 13,10,'[ID: 03] Jaringan Komputer Dasar     | Stok: $'
    T_BK04 DB 13,10,'[ID: 04] Sistem Operasi Modern       | Stok: $'
    T_BK05 DB 13,10,'[ID: 05] Basis Data Relasional       | Stok: $'
    T_BK06 DB 13,10,'[ID: 06] Rekayasa Perangkat Lunak    | Stok: $'
    T_BK07 DB 13,10,'[ID: 07] Kecerdasan Buatan (AI)      | Stok: $'
    T_BK08 DB 13,10,'[ID: 08] Pemrograman Berorientasi Obj| Stok: $'
    T_BK09 DB 13,10,'[ID: 09] Keamanan Siber & Jaringan    | Stok: $'
    T_BK10 DB 13,10,'[ID: 10] Pengantar Cloud Computing   | Stok: $'
    T_BK11 DB 13,10,'[ID: 11] Struktur Data & Analisis    | Stok: $'
    T_BK12 DB 13,10,'[ID: 12] Pemrograman Web Dinamis     | Stok: $'

    P_BUKU    DW OFFSET T_BK01, OFFSET T_BK02, OFFSET T_BK03, OFFSET T_BK04, OFFSET T_BK05
              DW OFFSET T_BK06, OFFSET T_BK07, OFFSET T_BK08, OFFSET T_BK09, OFFSET T_BK10
              DW OFFSET T_BK11, OFFSET T_BK12

    ; --- DATABASE STOK BUKU ---
    STOK      DW 5,3,4,2,6,1,4,8,2,5,7,3

    ; --- Form Isian Input Peminjaman ---
    INP_NAMA      DB 13,10,13,10,'-- FORM PEMINJAMAN BUKU --'
                  DB 13,10,'Masukkan Nama Peminjam : $'
    INP_ID_B      DB 13,10,'Masukkan ID Buku (1-12): $'
    INP_TGL1      DB 13,10,'Tanggal Pinjam (01-31) : $'
    
    ; --- Form Isian Input Pengembalian (Multi-Peminjam & Kondisi) ---
    INP_TGL2      DB 13,10,13,10,'-- FORM PENGEMBALIAN BUKU --'
                  DB 13,10,'Masukkan Nama Pengembali : $'
    INP_TGL_KMB   DB 13,10,'Tanggal Kembali (01-31)  : $'
    INP_KONDISI   DB 13,10,'Kondisi Buku [1=Normal, 2=Rusak, 3=Hilang]: $'
    
    ; --- Struktur Nota Cetak Struk ---
    STRUK_HDR     DB 13,10,13,10,'============================================'
                  DB 13,10,'|             NOTA PENGEMBALIAN            |'
                  DB 13,10,'============================================$'
    STRUK_PETUGAS DB 13,10,'  Petugas Jaga      : $'
    STRUK_NAMA    DB 13,10,'  Nama Pengembali   : $'
    RES_LAMA      DB 13,10,'  Durasi Peminjaman : $'
    RES_HARI      DB ' Hari$'
    RES_KNDS      DB 13,10,'  Kondisi Buku      : $'
    RES_DENDA     DB 13,10,'  Total Denda Akumulasi : Rp $'
    STRUK_FTR     DB 13,10,'============================================$'
    
    ; --- Teks Status Kondisi ---
    TXT_NORMAL    DB 'Normal (Tidak Ada Denda Fisik)$'
    TXT_RUSAK     DB 'Rusak (Denda Fisik Rp 20.000)$'
    TXT_HILANG    DB 'Hilang (Denda Fisik Rp 50.000)$'

    ; --- Galat / Notifikasi Sistem ---
    MSG_SUKSES    DB 13,10,'[SUKSES] Buku berhasil dipinjam! (Tempo: 7 hari)$'
    MSG_SISA_STK  DB 13,10,'-> Sisa stok buku saat ini: $'
    MSG_ERR_ID    DB 13,10,'[ERROR] ID Buku tidak valid atau salah input!$'
    MSG_ERR_TGL   DB 13,10,'[ERROR] Tanggal kembali tidak masuk akal!$'
    MSG_ERR_MAX   DB 13,10,'[ERROR] Batas tanggal salah (wajib 01-31)!$'
    MSG_STATUS    DB 13,10,'[ERROR] Log Transaksi Kosong! Belum ada peminjaman.$'
    MSG_EMPTY     DB 13,10,'[ERROR] Maaf, stok fisik buku ini kosong!$'
    MSG_BYE       DB 13,10,'Sesi selesai. Terima kasih banyak!$'

    ; --- Transaksi & Buffer Terpisah ---
    TGL_P           DW 0
    TGL_K           DW 0
    SELISIH         DW 0
    TOTAL_DENDA     DW 0
    STATUS_PINJAM   DB 0
    ID_TERPINJAM    DW 0   
    STOK_SEKARANG   DW 0   
    KONDISI_BUKU    DB 0

    BUFFER_NAMA     DB 20, 0, 21 DUP('$')
    BUFFER_KEMBALI  DB 20, 0, 21 DUP('$') ; Buffer Nama untuk Multi-Peminjam
    BUFFER_ID       DB 3, 0, 4 DUP('$')
    BUFFER_INP_NAMA DB 20, 0, 21 DUP('$')
    BUFFER_PASS     DB 10 DUP('$')

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

; =========================================================================
; PROSEDUR LOGIN PETUGAS (NAMA BEBAS - VERIFIKASI PASSWORD SAJA)
; =========================================================================
HALAMAN_LOGIN:
    CETAK_TEKS INP_LOGIN_HDR
    CETAK_TEKS INP_USER_NAMA
    
    LEA DX, BUFFER_INP_NAMA
    MOV AH, 0AH
    INT 21H
    
    MOV BL, BUFFER_INP_NAMA[1]
    MOV BH, 0
    MOV BUFFER_INP_NAMA[BX+2], '$'

    CETAK_TEKS INP_USER_PASS
    LEA SI, BUFFER_PASS
    MOV CX, 0

LOOP_INPUT_PASS:
    MOV AH, 07H        
    INT 21H
    CMP AL, 13         
    JE VERIFIKASI_LOGIN
    CMP AL, 8          
    JE LOOP_INPUT_PASS 
    
    MOV [SI], AL       
    INC SI
    INC CX             
    CETAK_KARAKTER '*' 
    JMP LOOP_INPUT_PASS

VERIFIKASI_LOGIN:
    MOV BYTE PTR [SI], '$' 
    
    LEA SI, BUFFER_PASS
    LEA DI, DATA_PASS_PETUGAS
CEK_PASS:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL          
    JNE LOGIN_GAGAL
    CMP AL, '$'         
    JE LOGIN_SUKSES
    INC SI
    INC DI
    JMP CEK_PASS

LOGIN_SUKSES:
    CETAK_TEKS MSG_LOGIN_OK
    LEA DX, BUFFER_INP_NAMA + 2
    MOV AH, 09H
    INT 21H
    CETAK_KARAKTER '!'
    JMP MAIN_MENU

LOGIN_GAGAL:
    CETAK_TEKS MSG_LOGIN_ERR
    DEC ATTEMPT_COUNTER
    JZ BLOCKED_SISTEM
    
    CETAK_TEKS MSG_ATTEMPT
    MOV AL, ATTEMPT_COUNTER
    ADD AL, '0'
    CETAK_KARAKTER AL
    JMP HALAMAN_LOGIN

BLOCKED_SISTEM:
    CETAK_TEKS MSG_BLOCKED
    MOV AH, 4CH
    INT 21H

; =========================================================================
; INTERFACE MENU UTAMA
; =========================================================================
MAIN_MENU:
    CETAK_TEKS HDR
    CETAK_TEKS MENU_MAIN
    MOV AH, 01H 
    INT 21H
    MOV BL, AL          

TUNGGU_ENTER_MENU:
    MOV AH, 01H 
    INT 21H
    CMP AL, 13          
    JNE TUNGGU_ENTER_MENU 

    SUB BL, '0'         
    CMP BL, 1 
    JE MENU_KAT_1
    CMP BL, 2 
    JE MENU_PINJAM
    CMP BL, 3 
    JE MENU_KEMBALI
    CMP BL, 4 
    JE MENU_KELUAR
    JMP MAIN_MENU

MENU_KAT_1:
    CALL JALANKAN_KATALOG_1
    JMP MAIN_MENU
MENU_PINJAM:
    CALL JALANKAN_PINJAM
    JMP MAIN_MENU
MENU_KEMBALI:
    CALL JALANKAN_KEMBALI
    JMP MAIN_MENU
MENU_KELUAR:
    CETAK_TEKS MSG_BYE
    MOV AH, 4CH 
    INT 21H

; =========================================================================
; SUBROUTINE: HALAMAN KATALOG (12 BUKU)
; =========================================================================
JALANKAN_KATALOG_1 PROC
    CETAK_TEKS KAT_HDR1
    MOV SI, 0           
    MOV CX, 12          
LOOP_CORE:
    PUSH CX
    MOV BX, SI
    SHL BX, 1           
    
    MOV DX, P_BUKU[BX]
    MOV AH, 09H
    INT 21H
    
    MOV AX, STOK[BX]
    CALL CETAK_ANGKA
    
    INC SI
    POP CX
    LOOP LOOP_CORE
    
    CETAK_TEKS LINE_STR
    CALL SUB_SELESAI_PROSES
    RET
JALANKAN_KATALOG_1 ENDP

; =========================================================================
; SUBROUTINE: PROSES PEMINJAMAN BUKU
; =========================================================================
JALANKAN_PINJAM PROC
    CETAK_TEKS INP_NAMA
    LEA DX, BUFFER_NAMA 
    MOV AH, 0AH 
    INT 21H
    MOV BL, BUFFER_NAMA[1] 
    MOV BH, 0
    MOV BUFFER_NAMA[BX+2], '$' 

FLUSH_KEYBOARD:
    MOV AH, 01H 
    INT 16H              
    JZ AMBIL_ID_BUKU_BUFFER 
    MOV AH, 00H 
    INT 16H              
    JMP FLUSH_KEYBOARD

AMBIL_ID_BUKU_BUFFER:
    CETAK_TEKS INP_ID_B
    LEA DX, BUFFER_ID 
    MOV AH, 0AH 
    INT 21H
    LEA SI, BUFFER_ID + 2  
    MOV AL, [SI]
    CMP AL, 13 
    JE JMP_SALAH
    SUB AL, '0'
    MOV BL, 10 
    MUL BL              
    MOV DI, AX
    INC SI
    MOV AL, [SI]
    CMP AL, 13 
    JE SELESAI_ID       
    SUB AL, '0'         
    
SELESAI_ID:
    ADD AX, DI          
    MOV WORD PTR [ID_TERPINJAM], AX 
    CMP AX, 1
    JL JMP_SALAH
    CMP AX, 12          
    JG JMP_SALAH

    SUB AX, 1           
    SHL AX, 1           
    MOV BX, AX          
    
    MOV AX, STOK[BX]        
    CMP AX, 0
    JE ERR_KOSONG       
    DEC AX              
    MOV STOK[BX], AX        
    MOV STOK_SEKARANG, AX

    CETAK_TEKS INP_TGL1
    MOV AH, 01H 
    INT 21H 
    SUB AL, '0' 
    MOV BL, 10 
    MUL BL 
    MOV CL, AL
    MOV AH, 01H 
    INT 21H 
    SUB AL, '0' 
    ADD AL, CL 
    MOV AH, 0
    CMP AX, 31 
    JG ERR_BATAS_MAKSIMAL
    
    MOV TGL_P, AX 
    MOV STATUS_PINJAM, 1  
    CETAK_TEKS MSG_SUKSES 
    CETAK_TEKS MSG_SISA_STK
    MOV AX, STOK_SEKARANG 
    CALL CETAK_ANGKA      
    CALL SUB_SELESAI_PROSES
    RET

JMP_SALAH:
    CETAK_TEKS MSG_ERR_ID
    CALL SUB_SELESAI_PROSES
    RET
ERR_KOSONG:
    CETAK_TEKS MSG_EMPTY 
    CALL SUB_SELESAI_PROSES
    RET
JALANKAN_PINJAM ENDP

; =========================================================================
; SUBROUTINE: PROSES PENGEMBALIAN BUKU (MULTI-PEMINJAM + DENDA KONDISI)
; =========================================================================
JALANKAN_KEMBALI PROC
    CMP STATUS_PINJAM, 1 
    JNE ERR_BELUM_PINJAM
    
    ; 1. Masukkan nama orang yang mau mengembalikan secara dinamis
    CETAK_TEKS INP_TGL2
    LEA DX, BUFFER_KEMBALI
    MOV AH, 0AH
    INT 21H
    MOV BL, BUFFER_KEMBALI[1]
    MOV BH, 0
    MOV BUFFER_KEMBALI[BX+2], '$'

    ; 2. Masukkan tanggal kembali
    CETAK_TEKS INP_TGL_KMB
    MOV AH, 01H 
    INT 21H 
    SUB AL, '0' 
    MOV BL, 10 
    MUL BL 
    MOV CL, AL
    MOV AH, 01H 
    INT 21H 
    SUB AL, '0' 
    ADD AL, CL 
    MOV AH, 0
    CMP AX, 31 
    JG ERR_BATAS_MAKSIMAL
    MOV TGL_K, AX
    CMP AX, TGL_P  
    JL ERR_LOGIKA_TANGGAL
    SUB AX, TGL_P  
    MOV SELISIH, AX

    ; 3. Masukkan kondisi fisik buku untuk denda tambahan
    CETAK_TEKS INP_KONDISI
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV KONDISI_BUKU, AL

    ; --- LOGIKA PERHITUNGAN DENDA AKUMULASI ---
    ; A. Cek Denda Keterlambatan Terlebih Dahulu
    MOV AX, SELISIH
    CMP AX, 7 
    JLE LATE_NOL
    SUB AX, 7 
    MOV BX, 1000 
    MUL BX          
    MOV TOTAL_DENDA, AX 
    JMP TAMBAH_DENDA_FISIK
LATE_NOL:
    MOV TOTAL_DENDA, 0

TAMBAH_DENDA_FISIK:
    ; B. Cek Kondisi Tambahan (1=Normal, 2=Rusak, 3=Hilang)
    CMP KONDISI_BUKU, 2
    JE TAMBAH_RUSAK
    CMP KONDISI_BUKU, 3
    JE TAMBAH_HILANG
    JMP CETAK_NOTA_FINAL

TAMBAH_RUSAK:
    ADD TOTAL_DENDA, 20000
    JMP CETAK_NOTA_FINAL
TAMBAH_HILANG:
    ADD TOTAL_DENDA, 50000

    ; --- OUTPUT STRUK NOTA FINAL ---
CETAK_NOTA_FINAL:
    CETAK_TEKS STRUK_HDR 
    CETAK_TEKS STRUK_PETUGAS
    LEA DX, BUFFER_INP_NAMA + 2 
    MOV AH, 09H
    INT 21H
    
    CETAK_TEKS STRUK_NAMA
    LEA DX, BUFFER_KEMBALI + 2 ; Mencetak nama orang yang mengembalikan
    MOV AH, 09H 
    INT 21H
    
    CETAK_TEKS RES_LAMA 
    MOV AX, SELISIH 
    CALL CETAK_ANGKA 
    CETAK_TEKS RES_HARI

    CETAK_TEKS RES_KNDS
    CMP KONDISI_BUKU, 2
    JE KNDS_RUSAK
    CMP KONDISI_BUKU, 3
    JE KNDS_HILANG
    CETAK_TEKS TXT_NORMAL
    JMP TAMPIL_TOTAL_DENDA
KNDS_RUSAK:
    CETAK_TEKS TXT_RUSAK
    JMP TAMPIL_TOTAL_DENDA
KNDS_HILANG:
    CETAK_TEKS TXT_HILANG

TAMPIL_TOTAL_DENDA:
    CETAK_TEKS RES_DENDA 
    MOV AX, TOTAL_DENDA 
    CALL CETAK_ANGKA
    CETAK_TEKS STRUK_FTR
    
    ; Kembalikan stok karena buku sudah pulang (Kecuali jika statusnya Hilang)
    CMP KONDISI_BUKU, 3
    JE RESET_STATUS
    MOV AX, ID_TERPINJAM
    SUB AX, 1
    SHL AX, 1
    MOV BX, AX
    MOV AX, STOK[BX]
    INC AX
    MOV STOK[BX], AX

RESET_STATUS:
    MOV STATUS_PINJAM, 0 
    CALL SUB_SELESAI_PROSES
    RET

ERR_BELUM_PINJAM:   
    CETAK_TEKS MSG_STATUS  
    CALL SUB_SELESAI_PROSES
    RET
ERR_LOGIKA_TANGGAL: 
    CETAK_TEKS MSG_ERR_TGL 
    CALL SUB_SELESAI_PROSES
    RET
ERR_BATAS_MAKSIMAL: 
    CETAK_TEKS MSG_ERR_MAX 
    CALL SUB_SELESAI_PROSES
    RET
JALANKAN_KEMBALI ENDP

; =========================================================================
; SUBROUTINE GLOBAL UTILITY
; =========================================================================
SUB_SELESAI_PROSES PROC
    CETAK_TEKS MSG_KEMBALI
    MOV AH, 07H 
    INT 21H
    RET
SUB_SELESAI_PROSES ENDP

CETAK_ANGKA PROC
    PUSH AX 
    PUSH BX 
    PUSH CX 
    PUSH DX
    MOV CX, 0 
    MOV BX, 10
BAGI_LAGI:
    MOV DX, 0 
    DIV BX 
    PUSH DX 
    INC CX
    OR AX, AX 
    JNZ BAGI_LAGI
CETAK_LOOP:
    POP DX 
    ADD DL, '0'
    MOV AH, 02H 
    INT 21H
    LOOP CETAK_LOOP
    POP DX 
    POP CX 
    POP BX 
    POP AX
    RET
CETAK_ANGKA ENDP

END START