/* Formatted on 09/10/19 1:37:48 PM (QP5 v5.136.908.31019) */
DECLARE
   v_HITT_ISC_PONG3   HITT_ISC_PONG3%ROWTYPE;

   CURSOR c_customers
   IS
      SELECT * FROM HITT_ISC_PONG3;
BEGIN
   OPEN c_customers;

   LOOP
      FETCH c_customers INTO v_HITT_ISC_PONG3;

      EXIT WHEN c_customers%NOTFOUND;
      DBMS_OUTPUT.put_line (
         v_HITT_ISC_PONG3.id || ' ' || v_HITT_ISC_PONG3.tname);
   END LOOP;

   CLOSE c_customers;
END;