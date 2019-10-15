declare

    TYPE P_TEXT IS VARRAY(10000000) OF VARCHAR2(32676);
    V_TEXT P_TEXT := P_TEXT();
    
    TYPE PP_TEXT IS VARRAY(10000000) OF VARCHAR2(32676);
    VV_TEXT PP_TEXT := PP_TEXT();       
    
    --OUT_FILE   TEXT_IO.FILE_TYPE;
  --FILES TEXT_IO.FILE_TYPE;
    
    
     out_file   CLIENT_TEXT_IO.File_Type;
   files CLIENT_TEXT_IO.file_type;
   
    LINEBUF   VARCHAR2(32676);  
    FILE_NAME VARCHAR2(20000);
      
    ALERT_ID ALERT := FIND_ALERT('alert_complete');
    ALERT_IE ALERT := FIND_ALERT('alert_error');
    SHOWA NUMBER;
    K NUMBER;
      
    ID1 NUMBER;
                   
    I NUMBER := 0;
    L NUMBER;
    N NUMBER := 0;
    C_DATE1 VARCHAR2 (100); 
BEGIN
    :SYSTEM.MESSAGE_LEVEL := 10;
    

    
     --:FILEPO := GET_FILE_NAME(File_Filter=> 'CSV Files (*.csv)|*.csv|');    
     :FILEPO :=  Client_Get_File_Name('%USERPROFILE%\desktop',null,'CSV Files (*.csv)|*.csv|','Open a file.',OPEN_FILE,TRUE);    
     
if :FILEPO is not null then
            
            delete HITT_DATA_PO_JAPANESE ;
            commit;
            
      FILE_NAME := :FILEPO;
--    OUT_FILE := TEXT_IO.FOPEN(FILE_NAME,'r');       
    
    
        OUT_FILE := CLIENT_TEXT_IO.Fopen(file_name,'r', 'TH8TISASCII');
    
                   
    K := 0;
        LOOP
            BEGIN
            I := 1;
            L := 1;
                        
            V_TEXT.EXTEND; 
            VV_TEXT.EXTEND;
              --TEXT_IO.GET_LINE(OUT_FILE,LINEBUF);
                CLIENT_TEXT_IO.get_line(out_file,linebuf);    
                                  
            IF SUBSTR(LINEBUF,1,1) = '"' THEN
                V_TEXT(L)  := REPLACE(SUBSTR(LINEBUF,2,INSTR(LINEBUF,'",')-2),'""','"');             
                VV_TEXT(I) := SUBSTR(LINEBUF,INSTR(LINEBUF,'",')+2);    
            ELSE
                V_TEXT(L)  := REPLACE(SUBSTR(LINEBUF,1,INSTR(LINEBUF,',')-1),'""','"');
                VV_TEXT(I) := SUBSTR(LINEBUF,INSTR(LINEBUF,',')+1);  
            END IF;  
                               
            V_TEXT.EXTEND; 
            VV_TEXT.EXTEND;
                                      
            FOR COUNT IN 1..20 LOOP  
                V_TEXT.EXTEND; 
                VV_TEXT.EXTEND;
                                                
                IF SUBSTR(VV_TEXT(I),1,1) = '"' THEN
                    V_TEXT(L+1)   := REPLACE(SUBSTR(VV_TEXT(I),2,INSTR(VV_TEXT(I),'",')-2),'""','"');             
                    VV_TEXT(I+1)  := SUBSTR(VV_TEXT(I),INSTR(VV_TEXT(I),'",')+2);    
                ELSIF SUBSTR(VV_TEXT(I),1,1) = ',' THEN
                    V_TEXT(L+1)   := '';
                    VV_TEXT(I+1)  := SUBSTR(VV_TEXT(I),INSTR(VV_TEXT(I),',')+1);
                ELSE
                    V_TEXT(L+1)   := REPLACE(SUBSTR(VV_TEXT(I),1,INSTR(VV_TEXT(I),',')-1),'""','"');
                    VV_TEXT(I+1)  := SUBSTR(VV_TEXT(I),INSTR(VV_TEXT(I),',')+1);         
                END IF;  
                                 
                I := I + 1;
                L := L + 1;    
            END LOOP; 
                                         
            IF K > 2 THEN
                V_TEXT.EXTEND; 
                VV_TEXT.EXTEND;
           
                   insert into HITT_DATA_PO_JAPANESE
                      (NUM,SLIPNO ,ITEM , QTY , HITT_DATE , SHIPPING_BY )
                         values
                        (    K,                
                V_TEXT(1),
                V_TEXT(3),
                V_TEXT(5),
                V_TEXT(8),
                V_TEXT(9)
                ) ;
                     
           
            END IF;
            K := K + 1;
                        
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('no_data_found');
                EXIT;                      
            END;        
        END LOOP; 
          
    STANDARD.COMMIT;  
    
    
    ----------------------------
end if;

    :SYSTEM.MESSAGE_LEVEL := 0;
END;