data segment               
    
    
    ; tables
    mixed_table db 100 dup(?) ; store letter and numbers   
    items_table db 100 dup (?) ; store only letter
    numbers_table db 100 dup(?) ; store only numbers            
                
                
                
    ; 10d = 0ah =\n ; 13d=0dh=\r         
    NewLine db 0ah,0dh, "$"
             
    ; messages menu
                
    menu_msg1 db '(1) Select number of items and length of Names and Numbers',10,13,'$' 
    menu_msg2 db '(2) enter the items',10,13,'$'                                        
    menu_msg3 db '(3) show the items in the same sequnce',10,13,'$'
    menu_msg4 db '(4) show the entered items classfied as names or numbers',10,13,'$'
    menu_msg5 db '(5) display names',10,13,'$'
    menu_msg6 db '(6) display numbers',10,13,'$'
    menu_msg7 db '(7) exit',10,13,'$'
                                                                        
         
    ; messages in each option                                                       
                                                              
    O1_msg_numberOfItems db 'Enter number of items: $'
    O1_msg_invalidNumberOfItems db 'message: wrong number of items!',10,13,'$'
    O1_msg_lengthOfItems   db 'Enter length of items: $'
    O1_msg_invalidLengthOfItems db 'message: wrong length of items!',10,13,'$' 
                                                                        
    O2_msg_valuesForItime db 'Enter values for item: $'
    O2_msg_notValid db 'message: wrong input! just digits(1-9) and lowercase',10,13,'$'  
    O3_msg_showItems db 'Displaying Items and numbers',10,13,'$' 
    O3_msg_no_entered_values db 'No entered values, back to order 2',10,13,'$'            
  
    O4_msg_showItems db 'Displaying words',10,13,'$'
    O4_msg_showNums db 'Displaying numbers',10,13,'$'
 
    O5_msg_showNames db 'Displaying words',10,13,'$' 
 
    O6_msg_showNums db 'Displaying Numbers',10,13,'$' 
 
    o7_msg_closing db  'thank you for using our program',10,13,'$'
    
        
    enter_your_chose_msg db 'Enter your chose: $'   
    new_chose_msg db '==========================================================================',10,13,'$' 
    invalid_chose_msg db '--------------------------------------------------------------------------',10,13,'$'  
      
    ; take from user (length and item)
    length_of_items db ?
    num_of_items db ? 
    
    

data ends

stack segment  
     dw 16 dup (0)  
stack ends


code segment
  Main proc far
        Assume SS:stack,CS:code,DS:data
        mov ax,data
        mov ds,ax     
        
        mainMenu:  
        
        mov dx, offset menu_msg1
        mov ah,9                    ;output of a string at DS:DX. String must be terminated by '$'
        int 21h 
              
        mov dx,offset  menu_msg2     
        mov ah,9             
        int 21h
         
        mov dx,offset  menu_msg3
        mov ah,9              
        int 21h
     
        mov dx,offset  menu_msg4     
        mov ah,9              
        int 21h
                        
        mov dx,offset  menu_msg5     
        mov ah,9              
        int 21h
        
        mov dx,offset  menu_msg6     
        mov ah,9              
        int 21h            
      
        mov dx,offset  menu_msg7     
        mov ah,9                 
        int 21h
        
       
        mov dx,offset enter_your_chose_msg    
        mov ah,9                 
        int 21h
        
        
        Mov ah,1         ;taking order (from user) , ah,1 => store in al  
        int 21h
        sub al, 30h 
                    

        cmp al,1        ; if else  , check al
        je option1
        
        cmp al,2
        je option2
        
        cmp al,3
        je option3
        
        cmp al,4
        je option4
        
        
        cmp al,5
        je option5
        
        
        cmp al,6
        je option6
        
                 
        cmp al,7
        je Close
         
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
        
        mov dx, offset new_chose_msg
        mov ah,9
        int 21h   
         
        jmp mainMenu ;if input not valid number
                                                 
                                                 
        ; --------------------------------------------- Option 1 ---------------------------------------------      
        
    option1: 
        
        mov dx, offset NewLine
        mov ah, 9
        int 21h  
                              
        mov dx, offset O1_msg_numberOfItems
        mov ah, 9
        int 21h
        
        Mov ah,1                     ;taking number of items  
        int 21h
        
        sub al, 30h
        
        cmp al, 1
        jl  invalidNumberOfItems     ; if the value not between this
        cmp al, 9
        ja invalidNumberOfItems
        Mov num_of_items,al             ; store number of items to al 
        
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
        
        ;////////////
        
        mov dx, offset O1_msg_lengthOfItems
        mov ah, 9
        int 21h 
        
        
        mov ah,1
        int 21h   
        
        sub al,30h 
        
        cmp al, 1
        jl  invalidLengthOfItems    
        cmp al, 9
        ja invalidLengthOfItems
        mov length_of_items,al
        
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
        
        mov dx,offset new_chose_msg
        mov ah,9
        int 21h  
        
        
        jmp mainMenu         
        
;////////////////////////////    order 1 => if invalid number of items
        
        invalidNumberOfItems: 
        mov dx, offset NewLine
        mov ah, 9
        int 21h
        
        mov dx, offset O1_msg_invalidNumberOfItems
        mov ah, 9
        int 21h          
        
        mov dx, offset invalid_chose_msg
        mov ah,9
        int 21h
        
        jmp mainMenu   
        
;////////////////////////////    order 1 => if invalid length of items       
        
        invalidLengthOfItems:  
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
         
        mov dx, offset O1_msg_invalidLengthOfItems
        mov ah, 9
        int 21h 
        
        mov dx, offset invalid_chose_msg
        mov ah,9
        int 21h
                               
        jmp mainMenu
         
        ; --------------------------------------------- Option 2 ---------------------------------------------      
        
    option2:          
                                ; check if no number of items entered 
        cmp num_of_items,0
        je  invalidNumberOfItems 
        
        cmp num_of_items, 1
        jl  invalidNumberOfItems
        
        cmp num_of_items, 9
        ja invalidNumberOfItems
        
                                ; loop through number of items in that length and assign values
                                ; distinguish bw numbers and chars                              
        
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
          
        mov dx, offset O2_msg_valuesForItime
        mov ah, 9
        int 21h
        
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
        
        
        
        mov si,0 
        mov di,0   
        mov bx,0  
        
        mov cl,num_of_items  
        mov ch,0
        assign_items:           ; outerloop
            push cx  
            
            mov cl,length_of_items
            mov ch,0   
            
            assign_values:
                mov ah,1        ; taking value        
                int 21h
                                ; check if item is started with a digit -> store it to numbers_table, if not then lowercase to items_table

                cmp al,30h
                jl input_notValid
                cmp al,39h
                ja word_or_not_valid 
                
                mov numbers_table[bx],al
                mov mixed_table[di],al 
                       
                inc bx                      
                inc di 
                jmp numbers_continue
                
                word_or_not_valid:  
                
                    cmp al,61h
                    jl input_notValid
                    cmp al,7ah
                    ja input_notValid   
                    
                    mov items_table[si],al 
                    mov mixed_table[di],al  
                    
                    inc si
                    inc di
                
                numbers_continue:
                loop assign_values
                
                
                ; ////////////////////////////////
                
                mov items_table[si],0ah,0dh
                mov numbers_table[bx],0ah,0dh
                
                inc si
                inc bx  
                inc num_of_items
                
                ; ////////////////////////////////
            
            
            mov dx, offset NewLine
            mov ah, 9
            int 21h 
             
            pop cx 
            loop assign_items
            
            mov dx,offset new_chose_msg
            mov ah,9
            int 21h
      
        jmp mainMenu 
            
 ;////////////////////////////               
        input_notValid:   
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
  
        mov dx, offset O2_msg_notValid
        mov ah, 9
        int 21h  
        
        mov dx, offset invalid_chose_msg
        mov ah,9
        int 21h                         
        
        jmp mainMenu  
            
        ; --------------------------------------------- Option 3 ---------------------------------------------      
        
        option3:
            
            cmp mixed_table[00],0
            je no_entered_values
            
            mov dx, offset NewLine
            mov ah, 9
            int 21h  
            
            mov dx, offset O3_msg_showItems
            mov ah, 9
            int 21h
            
            ; print the items from table mixed 
            mov di,0
            mov cl,num_of_items
            mov ch,0
              
            O3_print_items: 
                push cx  ; num of items 
                
                mov cl,length_of_items
                mov ch,0
                O3_print_values: 
                
                    mov dl,mixed_table[di]
                    Mov ah, 02h         
                    int 21h 
                    
                    inc di
                    loop O3_print_values
            
                mov dx, offset NewLine
                mov ah, 9
                int 21h 
            
                pop cx
                LOOP O3_print_items
            
      
        
        mov dx,offset new_chose_msg
        mov ah,9
        int 21h

                jmp mainMenu     
;////////////////////////////                
        no_entered_values:       
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
        
        mov dx, offset O3_msg_no_entered_values
        mov ah, 9
        int 21h
        
        mov dx, offset invalid_chose_msg
        mov ah,9
        int 21h     

        jmp mainMenu
                
        ; --------------------------------------------- Option 4 ---------------------------------------------      

        option4:
            cmp mixed_table[00],0
            je no_entered_values
            
            mov dx, offset NewLine
            mov ah, 9
            int 21h 
            
            mov dx, offset O4_msg_showItems
            mov ah, 9
            int 21h
            
            ; print the items 
            mov di,0
            mov cl,num_of_items
            mov ch,0
              
            O4_print_items: ; outerloop
                push cx  
                
                mov cl,length_of_items
                mov ch,0
                O4_print_values: 
                    mov dl,items_table[di]
                    Mov ah, 02h         
                    int 21h 
                         
                    inc di
                    loop O4_print_values       
                pop cx
                loop O4_print_items
            
            mov dx,offset NewLine
            mov ah,9
            int 21h
            
            ; print the numbers 
            
            
            mov dx, offset O4_msg_showNums
            mov ah, 9
            int 21h
            
                
            mov si,0
            mov cl,num_of_items
            mov ch,0  
            O4_print_numbers: ; outerloop
                  
                push cx
                mov cl,length_of_items
                mov ch,0
                O4_print_items_numbers: 
                    mov dl,numbers_table[si]
                    Mov ah, 02h         
                    int 21h
                    inc si
                    loop O4_print_items_numbers

                pop cx
                loop O4_print_numbers  
                
                 mov dx,offset NewLine
                 mov ah,9
                 int 21h
                
                 mov dx,offset new_chose_msg
                 mov ah,9
                 int 21h 
                 
                jmp mainMenu     
        
        ; --------------------------------------------- Option 5 ---------------------------------------------      

        option5:
            cmp mixed_table[00],0
            je no_entered_values
            
            mov dx, offset NewLine
            mov ah, 9
            int 21h 
            mov dx, offset O5_msg_showNames
            mov ah, 9
            int 21h
            
            ; print the items 
            mov di,0
            mov cl,num_of_items
            mov ch,0
              
              
            O5_print_items:
                push cx  
                
                mov cl,length_of_items
                mov ch,0
                O5_print_values: 
                    mov dl,items_table[di]
                    Mov ah, 02h         
                    int 21h 
                         
                    inc di
                    loop O5_print_values       
                pop cx
                loop O5_print_items
                
                
                                     
                 mov dx, offset NewLine
                 mov ah, 9
                 int 21h                                      
                                     
                 mov dx,offset new_chose_msg
                 mov ah,9
                 int 21h 

                jmp mainMenu            

                
        ; --------------------------------------------- Option 6 ---------------------------------------------      

        option6:
            cmp mixed_table[00],0
            je no_entered_values
            
           
            
            ; print the numbers
            
            mov dx, offset NewLine
            mov ah, 9
            int 21h 
            mov dx, offset O6_msg_showNums
            mov ah, 9
            int 21h
            
                
            mov si,0
            mov cl,num_of_items
            mov ch,0  
            O6_print_numbers:
                  
                push cx
                mov cl,length_of_items
                mov ch,0
                O6_print_items_numbers: 
                    mov dl,numbers_table[si]
                    Mov ah, 02h         
                    int 21h
                    inc si
                    loop O6_print_items_numbers

                pop cx
                loop O6_print_numbers
                
                
                mov dx, offset NewLine
                mov ah, 9
                int 21h    
                
                mov dx,offset new_chose_msg
                mov ah,9
                int 21h 

                jmp mainMenu    
                    
        ; --------------------------------------------- Option 7 ---------------------------------------------                  
        
        Close: 
        mov dx, offset NewLine
        mov ah, 9
        int 21h 
        
        mov dx,offset new_chose_msg
        mov ah,9
        int 21h  
        
        mov dx,offset o7_msg_closing
        mov ah,9
        int 21h    
            
        mov ax, 4ch                  ; return control to DOS (exit program)
        int 21h      
            
            
Main endp        
    Code ends
        end Main