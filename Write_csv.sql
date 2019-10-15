DECLARE
    ALERT_ID ALERT := FIND_ALERT('alert_complete'); 
    SHOWA NUMBER;
    V_FILENAME VARCHAR2(1000);
    OUT_FILE   CLIENT_TEXT_IO.FILE_TYPE;
    NN NUMBER := 0;
    DESCRIPTION    VARCHAR2 (1000); 
    
    V_DESCRIPTION    VARCHAR2 (1000); 
    CUSTOMER    VARCHAR2 (1000); 
    V_CUSTOMER         VARCHAR2 (1000); 
    CURSOR E IS
       
    I E%ROWTYPE;

BEGIN
    
    :SYSTEM.MESSAGE_LEVEL := 10;    
    
    V_FILENAME := CLIENT_GET_FILE_NAME('%USERPROFILE%\desktop','.csv','CSV Files (*.csv)|*.csv|','Save a file.',SAVE_FILE,TRUE);       
    V_FILENAME := HITT_INV_MAIN.VALIDATE_FILE_NAME(V_FILENAME);    
    OUT_FILE := CLIENT_TEXT_IO.FOPEN(V_FILENAME, 'w','TH8TISASCII'); 
    
                
    CLIENT_TEXT_IO.PUTF(OUT_FILE,
    'type'||','||
    'Reference'||','||
    'Date'||','||
    'Description'||','||
    'Customer'||','||
    'QTY'||','||
    'Unit Price'||','||
    'Amount'||','||
    'Tax'||','||
    'Total'||',');
          
           
    CLIENT_TEXT_IO.NEW_LINE(OUT_FILE,1);
                  
    OPEN E;
    LOOP
        FETCH E INTO I;
        EXIT WHEN E%NOTFOUND;
        NN := NN+1;
                  
        IF (INSTR(I.DESCRIPTION,'"') > 0) THEN
            BEGIN
                DESCRIPTION  := REPLACE(I.DESCRIPTION,'"','""');
                V_DESCRIPTION := '"'||DESCRIPTION||'"';
            END;
        ELSIF (INSTR(I.DESCRIPTION,',') > 0) THEN                             
            V_DESCRIPTION := '"'||I.DESCRIPTION||'"';
        ELSE 
            V_DESCRIPTION := I.DESCRIPTION;    
        END IF;  
        
        ------------------------------------------------------------------------
        IF (INSTR(I.CUSTOMER,'"') > 0) THEN
            BEGIN
                CUSTOMER   := REPLACE(I.CUSTOMER,'"','""');
                V_CUSTOMER := '"'||CUSTOMER||'"';
            END;
        ELSIF (INSTR(I.CUSTOMER,',') > 0) THEN                             
            V_CUSTOMER := '"'||I.CUSTOMER||'"';
        ELSE 
            V_CUSTOMER := I.CUSTOMER;    
        END IF;  
                    
        ---------------------------------------------------------------------------
        
        CLIENT_TEXT_IO.PUTF(OUT_FILE, 
            I.TYPE1||','||
            I.REFERENCE||','||    
            I.DATE1||','||    
            V_DESCRIPTION||','||    
            V_CUSTOMER||','||    
            I.QTY||','||    
            I.PRICE||','||    
            I.AMT ||','||    
            I.TAX ||','||    
            I.TOTAL ||',');
          
        CLIENT_TEXT_IO.NEW_LINE(OUT_FILE, 1);  
        IF MOD (NN,5000)=0 THEN
               SYNCHRONIZE;
        END IF;  --add by ck. 19-nov-2018  use for generate more than 10920 row          
    END LOOP;
    CLOSE E;
    CLIENT_TEXT_IO.FCLOSE (OUT_FILE);       
    :SYSTEM.MESSAGE_LEVEL := 0;
    SET_ALERT_PROPERTY(ALERT_ID,ALERT_MESSAGE_TEXT,'Export Excel OK');
    SHOWA := SHOW_ALERT(ALERT_ID);
       
END;
     


