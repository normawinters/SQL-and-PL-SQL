CREATE OR REPLACE FUNCTION get_next_month_5th(p_date IN DATE)
RETURN DATE
IS
  v_next_month_5th DATE;
  v_day_of_week VARCHAR2(10);
BEGIN
  -- Get the 5th of the next month
  v_next_month_5th := TRUNC(ADD_MONTHS(p_date, 1), 'MM') + 4;
  
  -- Get the day of week (e.g., 'SATURDAY', 'SUNDAY', etc.)
  v_day_of_week := TO_CHAR(v_next_month_5th, 'DAY');
  
  -- Check if it's Saturday or Sunday and adjust to next Monday
  IF TRIM(v_day_of_week) = 'SATURDAY' THEN
    v_next_month_5th := v_next_month_5th + 2;
  ELSIF TRIM(v_day_of_week) = 'SUNDAY' THEN
    v_next_month_5th := v_next_month_5th + 1;
  END IF;
  
  RETURN v_next_month_5th;
END get_next_month_5th;
/