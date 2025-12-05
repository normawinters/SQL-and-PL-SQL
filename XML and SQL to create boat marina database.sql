-- Script Name: XML and SQL to create boat marina database 
-- Purpose: Demonstrate sql and xml 
-- What the script does: Create three tables: port, boat_dock, and boat_slip.  
--      Insert data into tables,and then a sql statement for xml tags.
-- Description: Manages boat slips across different docks and ports
-- Oracle versions: Oracle 9i Release 2 , Oracle 10g, Oracle 11g, Oracle 12c
   Oracle 18c, Oracle 19c, Oracle 21c, Oracle 23Ai


-- Create PORT table
CREATE TABLE port (
  port_id        NUMBER(2,0),
  port_name      VARCHAR2(20),
  port_location  VARCHAR2(20),
  CONSTRAINT pk_port PRIMARY KEY (port_id)
);
/
-- Create BOAT_DOCK table
CREATE TABLE boat_dock (
  dock_number    NUMBER(2,0),
  dock_name      VARCHAR2(20),
  port_id        NUMBER(2,0),
  CONSTRAINT pk_dock PRIMARY KEY (dock_number),
  CONSTRAINT fk_port FOREIGN KEY (port_id) REFERENCES port (port_id)
);
/

-- Create BOAT_SLIP table
CREATE TABLE boat_slip (
  slip_number      NUMBER(4,0),
  boat_name        VARCHAR2(30),
  boat_type        VARCHAR2(20),
  owner_id         NUMBER(4,0),
  registration_date DATE,
  monthly_fee      NUMBER(7,2),
  deposit          NUMBER(7,2),
  dock_number      NUMBER(2,0),
  CONSTRAINT pk_slip PRIMARY KEY (slip_number),
  CONSTRAINT fk_dock FOREIGN KEY (dock_number) REFERENCES boat_dock (dock_number)
);
/

-- Insert PORT data
INSERT INTO port (port_id, port_name, port_location)
VALUES (10, 'Harbor Bay', 'San Francisco');
/
INSERT INTO port (port_id, port_name, port_location)
VALUES (20, 'Marina Del Rey', 'Los Angeles');
/
INSERT INTO port (port_id, port_name, port_location)
VALUES (30, 'Pacific Marina', 'San Diego');
/
INSERT INTO port (port_id, port_name, port_location)
VALUES (40, 'Coastal Harbor', 'Seattle');
/
-- Insert BOAT_DOCK data
INSERT INTO boat_dock (dock_number, dock_name, port_id)
VALUES (1, 'North Dock', 10);
/
INSERT INTO boat_dock (dock_number, dock_name, port_id)
VALUES (2, 'South Dock', 30);
/
INSERT INTO boat_dock (dock_number, dock_name, port_id)
VALUES (3, 'East Dock', 10);
/
INSERT INTO boat_dock (dock_number, dock_name, port_id)
VALUES (4, 'West Dock', 20);
/
-- Insert BOAT_SLIP data
INSERT INTO boat_slip
VALUES (
  101, 'Sea King', 'Yacht', NULL,
  TO_DATE('17-11-2021','dd-mm-yyyy'),
  5000, NULL, 1
);
/
INSERT INTO boat_slip
VALUES (
  102, 'Wave Runner', 'Sailboat', 201,
  TO_DATE('01-05-2021','dd-mm-yyyy'),
  2850, NULL, 2
);
/
INSERT INTO boat_slip
VALUES (
  103, 'Ocean Pearl', 'Sailboat', 201,
  TO_DATE('09-06-2021','dd-mm-yyyy'),
  2450, NULL, 1
);
/
INSERT INTO boat_slip
VALUES (
  104, 'Mariner', 'Sailboat', 201,
  TO_DATE('02-04-2021','dd-mm-yyyy'),
  2975, NULL, 4
);
/
INSERT INTO boat_slip
VALUES (
  105, 'Blue Horizon', 'Catamaran', 104,
  TO_DATE('13-07-2020','dd-mm-yyyy'),
  3000, NULL, 4
);
/
INSERT INTO boat_slip
VALUES (
  106, 'Wind Chaser', 'Catamaran', 104,
  TO_DATE('03-12-2021','dd-mm-yyyy'),
  3000, NULL, 4
);
/
INSERT INTO boat_slip
VALUES (
  107, 'Tranquility', 'Motorboat', 106,
  TO_DATE('17-12-2020','dd-mm-yyyy'),
  800, NULL, 4
);
/
INSERT INTO boat_slip
VALUES (
  108, 'Freedom', 'Fishing Boat', 102,
  TO_DATE('20-02-2021','dd-mm-yyyy'),
  1600, 300, 2
);
/
INSERT INTO boat_slip
VALUES (
  109, 'Serenity', 'Fishing Boat', 102,
  TO_DATE('22-02-2021','dd-mm-yyyy'),
  1250, 500, 2
);
/
INSERT INTO boat_slip
VALUES (
  110, 'Lucky Strike', 'Fishing Boat', 102,
  TO_DATE('28-09-2021','dd-mm-yyyy'),
  1250, 1400, 2
);
/
INSERT INTO boat_slip
VALUES (
  111, 'Sea Breeze', 'Fishing Boat', 102,
  TO_DATE('08-09-2021','dd-mm-yyyy'),
  1500, 0, 2
);
/
INSERT INTO boat_slip
VALUES (
  112, 'Morning Star', 'Motorboat', 105,
  TO_DATE('23-05-2020','dd-mm-yyyy'),
  1100, NULL, 4
);
/
INSERT INTO boat_slip
VALUES (
  113, 'Sunset', 'Motorboat', 102,
  TO_DATE('03-12-2021','dd-mm-yyyy'),
  950, NULL, 2
);
/
INSERT INTO boat_slip
VALUES (
  114, 'Voyager', 'Motorboat', 103,
  TO_DATE('23-01-2022','dd-mm-yyyy'),
  1300, NULL, 1
);
/

-- Query 1: List all boats with their dock and port information
SELECT bs.boat_name, bd.dock_name, bs.boat_type, bs.slip_number, 
       bs.registration_date, p.port_location
FROM boat_slip bs, boat_dock bd, port p
WHERE bs.dock_number = bd.dock_number
  AND bd.port_id = p.port_id
ORDER BY bs.boat_name;

-- Query 2: Count boats by dock
SELECT bd.dock_name, COUNT(*) count_of_boats
FROM boat_dock bd, boat_slip bs
WHERE bd.dock_number = bs.dock_number
GROUP BY bd.dock_name
ORDER BY 2 DESC;


-- Query 3: Generate XML for each boat slip
SELECT slip_number, boat_name, 
       XMLELEMENT("BoatSlip", 
         XMLForest(slip_number, boat_name, boat_type, 
                   dock_number, monthly_fee, deposit)) boat_xml
FROM boat_slip;
