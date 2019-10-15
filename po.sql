select POH.COMMENTS COMMENTS,
                            POH.SEGMENT1 PO_NUM,
                            POH.PO_HEADER_ID PO_HEADER_ID,
                            POH.CREATION_DATE PO_HEADER_C_DATE,
                            POH.ATTRIBUTE1 PO_TYPE,
                            POL.LINE_NUM LINE_NUM,
                            
                            MSI.SEGMENT1 FGNO,
                            NVL(MSI.DESCRIPTION,POL.ITEM_DESCRIPTION) DESCRIPTION,
                            PLL.NEED_BY_DATE NEED_BY_DATE,
                            POL.QUANTITY  QUANTITY_ORDERED,
                            PLL.QUANTITY_RECEIVED QAUNTITY_DELIVERED,
                            POL.QUANTITY - PLL.QUANTITY_RECEIVED  PO_BALANCE,
                            
                            POD.DESTINATION_ORGANIZATION_ID DESTINATION_ORGANIZATION_ID,
                            EE.NAME ORG_NAME,
                            
                            PT.LINE_TYPE ITEM_TYPE,
                            
                            FF.SEGMENT1||'-'||FF.SEGMENT2 ||'-'||FF.SEGMENT3||'-'||FF.SEGMENT4||'-'||FF.SEGMENT5||'-'||FF.SEGMENT6 OUT_CODE,
                            JJ.SEGMENT1 VENDOR,
                            JJ.VENDOR_NAME VENDOR_NAME,
                            PLL.SHIP_TO_ORGANIZATION_ID SHIP_TO_ORGANIZATION_ID,
                            
                            TO_CHAR (PLL.PROMISED_DATE, 'DD-MON-RR') PROMISED_DATE,
                            
                            NVL(POH.AUTHORIZATION_STATUS,'Imcomplete') AUTHORIZATION_STATUS,
                            
                            POL.UNIT_MEAS_LOOKUP_CODE UOM,
                            PLL.QUANTITY_CANCELLED QUANTITY_CANCELLED,
                            NVL (PLL.CLOSED_CODE,'OPEN') CLOSED_CODE,
                            
                            GG.AGENT_NAME AGENT_NAME,
                            C.LAST_NAME CONTACT_NAME,
                            C.AREA_CODE||' '||C.PHONE FAX,
                            S.AREA_CODE||' '||S.PHONE TEL,
                            to_date(TO_CHAR(PLL.PROMISED_DATE,'DD-MON-RR'),'DD-MON-RR')- to_date(to_char(POH.CREATION_DATE ,'DD-MON-RR'),'DD-MON-RR') DATES
    
 FROM PO_HEADERS_ALL POH,
                    PO_LINES_ALL POL,
                    PO_LINE_LOCATIONS_ALL PLL,
                    PO_DISTRIBUTIONS_ALL POD,
                    PO_RELEASES_ALL PR,
                    
                    PO_LINE_TYPES PT,
                    MTL_SYSTEM_ITEMS MSI,
                    
                    PO_VENDORS JJ,
                    PO_VENDOR_SITES_ALL S,
                    PO_VENDOR_CONTACTS C,
                    PO_AGENTS_V GG,
                    GL_CODE_COMBINATIONS FF,
                    HR_ORGANIZATION_UNITS EE 
    
 WHERE  POL.PO_HEADER_ID = POH.PO_HEADER_ID
                    AND PLL.PO_LINE_ID = POL.PO_LINE_ID
                    AND PLL.PO_HEADER_ID = POH.PO_HEADER_ID
                    AND PLL.PO_RELEASE_ID = PR.PO_RELEASE_ID(+)
                    
                    AND POD.PO_HEADER_ID = POL.PO_HEADER_ID
                    AND POD.PO_LINE_ID = POL.PO_LINE_ID
                    AND POD.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID
                    
                    AND POL.ITEM_ID = MSI.INVENTORY_ITEM_ID
                    AND PLL.SHIP_TO_ORGANIZATION_ID = NVL(MSI.ORGANIZATION_ID,HITT_FIND_ORG('999'))
                    
                    AND PT.LINE_TYPE_ID = POL.LINE_TYPE_ID
   
                    
                    
                    
                    AND EE.ORGANIZATION_ID = PLL.SHIP_TO_ORGANIZATION_ID
                    
                    AND JJ.VENDOR_ID = POH.VENDOR_ID(+)
                    AND S.VENDOR_ID = JJ.VENDOR_ID
                    AND S.VENDOR_SITE_CODE = 'HO'
                    AND C.VENDOR_SITE_ID = S.VENDOR_SITE_ID
                    AND C.TITLE = 'จัดซื้อ'
                    
                    AND FF.CODE_COMBINATION_ID = POD.CODE_COMBINATION_ID
                    AND GG.AGENT_ID = S.ATTRIBUTE15
                    AND POH.SEGMENT1 = :P_PO