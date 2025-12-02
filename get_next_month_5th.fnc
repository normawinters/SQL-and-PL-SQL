CREATE OR REPLACE FUNCTION get_next_month_5th(p_date IN DATE)
RETURN DATE
IS
/* Purpose:  Find a date that is the 5h of next month for a meeting.
             Only meet on weekdays.
             User submits any date when the function is executed.
             Get the 5th day of the next month.  If the 5th day is 
             Saturday or Sunday than get the following Monday.
   Date:  12/2/2025
   Author: Norma Jean Winters
*/
  v_next_month_5th     DATE;
  v_day_of_week        VARCHAR2(10);
BEGIN

  -- Get the 5th of the next month
  v_next_month_5th := TRUNC(ADD_MONTHS(p_date, 1), 'MM') + 4;
  
  -- Get the day of week (e.g., 'SATURDAY', 'SUNDAY', etc.)
  v_day_of_week := TO_CHAR(v_next_month_5th, 'DAY');
  
  -- Check if it's Saturday or Sunday and adjust to next Monday
   --Trim any space Oracle may have added
  IF TRIM(v_day_of_week) = 'SATURDAY' THEN
    v_next_month_5th := v_next_month_5th + 2;
  ELSIF TRIM(v_day_of_week) = 'SUNDAY' THEN
    v_next_month_5th := v_next_month_5th + 1;
  END IF;
  
  RETURN v_next_month_5th;

END get_next_month_5th;
/
