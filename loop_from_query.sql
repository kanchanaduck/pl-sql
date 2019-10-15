BEGIN
FOR CusInfo IN (SELECT * FROM HITT_ISC_PONG3)
  LOOP
      DBMS_OUTPUT.PUT_LINE(CusInfo.ID || ' ' || CusInfo.NO || ' ' || CusInfo.TNAME);
  END LOOP;
END;