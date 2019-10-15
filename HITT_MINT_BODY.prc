CREATE OR REPLACE PACKAGE BODY HITT_MINTX AS


  FUNCTION MyFunction(Param1 IN NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN Param1;
  END;

  PROCEDURE MyProcedure(Param1 IN NUMBER) IS
    TmpVar NUMBER;
  BEGIN
    TmpVar := Param1;
    dbms_output.put_line(TmpVar);
  END;

END HITT_MINTX;

/
