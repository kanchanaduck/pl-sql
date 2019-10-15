SELECT PHA.SEGMENT1 PO_NO,
            PHA.COMMENTS DESCRIPTION,
            TO_DATE(PHA.CREATION_DATE,'DD/MM/YY') ORDER_DATE,
            PV.SEGMENT1 VENDOR_NUMBER,
            PV.VENDOR_NAME,
            PAPF.LAST_NAME BUYER,
            PHA.CURRENCY_CODE,
            SUM(PLA.UNIT_PRICE * PLA.QUANTITY) AMOUNT,
            NVL(PHA.AUTHORIZATION_STATUS,'Incomplete') APPROVAL_STATUS,
            PLLA.SHIP_TO_ORGANIZATION_ID,
            PHA.ATTRIBUTE1 PO_TYPE,
            PLA.LINE_TYPE_ID ITEM_TYPE,
            PVC.LAST_NAME CONTACT
            
           /* cat.SEGMENT1 DEPT,
            cat.SEGMENT2 accode,
            NVL(substr(fsfa.ALIAS_NAME,5,3),cat.segment2) ACCODE_n*/
        
FROM PO_HEADERS_ALL PHA,
                 PO_LINES_ALL PLA,
                 PER_ALL_PEOPLE_F PAPF,
                 PO_VENDORS PV,
                  PO_VENDOR_SITES_ALL PVS,   ---ADD BY PAT 10/09/2019
                 PO_VENDOR_CONTACTS PVC,     ---ADD BY PAT 10/09/2019
                 PO_LINE_LOCATIONS_ALL PLLA,
                 PO_DISTRIBUTIONS_ALL PDA,
                 
                 MTL_CATEGORIES CAT,
                 FND_SHORTHAND_FLEX_ALIASES FSFA,
                 GL_CODE_COMBINATIONS_KFV GL_CODE
                 
WHERE TYPE_LOOKUP_CODE = 'STANDARD'
                AND PHA.PO_HEADER_ID = PLA.PO_HEADER_ID
                AND PHA.VENDOR_ID = PV.VENDOR_ID
               -- AND PHA.AGENT_ID = PAPF.PERSON_ID(+)
                AND PV.END_DATE_ACTIVE IS NULL
                AND PV.VENDOR_ID  = PVS.VENDOR_ID(+)   
                AND PVS.ATTRIBUTE10 = PAPF.PERSON_ID(+)                          ---CHANG BY PAT 10/09/2019
                 AND PVC.VENDOR_SITE_ID(+) = PVS.VENDOR_SITE_ID             ---add BY PAT 10/09/2019
                 AND PVC.TITLE = 'จัดซื้อ'                                                          ---add BY PAT 10/09/2019
                
                
                AND PLA.PO_HEADER_ID = PLLA.PO_HEADER_ID
                AND PLA.PO_LINE_ID = PLLA.PO_LINE_ID
                AND PDA.PO_HEADER_ID = PLLA.PO_HEADER_ID
                AND PDA.PO_LINE_ID = PLLA.PO_LINE_ID
                AND PLLA.LINE_LOCATION_ID = PDA.LINE_LOCATION_ID
                AND (PV.SEGMENT1 LIKE :P_VENDOR1||'%' OR PV.SEGMENT1 BETWEEN :P_VENDOR1 AND :P_VENDOR2)

                AND (TO_CHAR(PHA.CREATION_DATE,'MON-YY') = :P_PERIOD 
                         OR TO_DATE(TO_CHAR(PHA.CREATION_DATE,'DD-MON-YY')) BETWEEN :P_START_DATE AND :P_END_DATE)
                        --AND PLLA.SHIP_TO_ORGANIZATION_ID LIKE :P_ORG||'%'                            --remark by ck. 7-dec-2018
                AND PLLA.SHIP_TO_ORGANIZATION_ID LIKE DECODE(:P_ORG,'%',PLLA.SHIP_TO_ORGANIZATION_ID,:P_ORG)        --add by ck. 7-dec-2018
                AND PHA.ATTRIBUTE1 LIKE :P_PO_TYPE||'%'
                --AND PHA.AGENT_ID LIKE :P_BUYER||'%'
                AND NVL(PVS.ATTRIBUTE10,'-') LIKE :P_BUYER||'%'   ---CHANG BY PAT 10/09/2019
                AND PLA.LINE_TYPE_ID LIKE :P_ITEM_TYPE||'%'
                AND NVL(PHA.ATTRIBUTE14,'N/A') NOT IN (SELECT DISTINCT PER.FULL_NAME
                                              FROM PER_ALL_PEOPLE_F PER,
                                                PER_ALL_ASSIGNMENTS_F PAF,
                                                PER_JOBS JOB
               
                                         WHERE PAF.PERSON_ID = PER.PERSON_ID 
                                                AND PAF.JOB_ID = JOB.JOB_ID
                                                --and paf.job_id IN ('64','63')                                                                                                                             --remark by ck. 19-sep-2018
                                                AND PAF.JOB_ID IN (SELECT PJ.JOB_ID FROM PER_JOBS PJ WHERE PJ.NAME IN ('D/SMO','D/SSW','D/S'))           --add by ck. 19-sep-2018
                
                                           )
                
                
                AND CAT.CATEGORY_ID(+)=PLA.CATEGORY_ID    
                AND PDA.CODE_COMBINATION_ID=GL_CODE.CODE_COMBINATION_ID(+)
                   --and gl_code.SEGMENT1||'-'||gl_code.SEGMENT2||'-'||gl_code.SEGMENT3||'-'||gl_code.SEGMENT4||'-'||gl_code.SEGMENT5||'-'||gl_code.SEGMENT6=fsfa.CONCATENATED_SEGMENTS(+) --remark by ck. 7-dec-2018
                AND GL_CODE.CONCATENATED_SEGMENTS = FSFA.CONCATENATED_SEGMENTS(+)           --add by ck.7-dec-2018
                AND NVL(SUBSTR(FSFA.ALIAS_NAME,5,3),CAT.SEGMENT2) <> '846'
                AND UPPER(NVL(PHA.COMMENTS,'-'))  NOT LIKE  '%FIRST%LOT%'                            
                                   
                                   
                                   
       GROUP BY PHA.VENDOR_ID,PHA.SEGMENT1,
                PHA.COMMENTS,
                TO_DATE(PHA.CREATION_DATE,'DD/MM/YY'),
                PV.SEGMENT1,
                PV.VENDOR_NAME,
                PAPF.LAST_NAME,
                PHA.CURRENCY_CODE,
                PHA.AUTHORIZATION_STATUS,
                PHA.ATTRIBUTE1,
                PLA.LINE_TYPE_ID,
                PLLA.SHIP_TO_ORGANIZATION_ID,
                PVC.LAST_NAME
  