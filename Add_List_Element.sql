--HOW TO USE
--1. Add procedure ADD_ORG (V_LIST IN VARCHAR2) below


PROCEDURE ADD_ORG (V_LIST IN VARCHAR2) IS

CURSOR C_ORG IS
SELECT DECODE(ORGANIZATION_CODE,'M01','MO - Motor','S01','SW - Switch','M02','MO - Motor','S02','SW - Switch') ORG_NAME,
             TO_CHAR(ORGANIZATION_ID) ORG_ID
FROM APPS.ORG_ORGANIZATION_DEFINITIONS 
WHERE ORGANIZATION_CODE IN ('M02','S02'); --2. **********Change this line
A NUMBER := 0;
BEGIN          
:SYSTEM.MESSAGE_LEVEL := 10;
                                
                CLEAR_LIST(V_LIST);
                FOR ORG IN C_ORG LOOP
                     A := A + 1;
                     ADD_LIST_ELEMENT(V_LIST,A,ORG.ORG_NAME,ORG.ORG_ID);
                   --ADD_LIST_ELEMENT(V_LIST,A,SHOW,VALUE);
                END LOOP;
:SYSTEM.MESSAGE_LEVEL := 0;
END;



--3. Add trigger WHEN_NEW_FORM_INSTANCE
--4. Call procedure ADD_ORG('*********NAME OF LIST ITEM')