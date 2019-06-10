
/*
Vaseem Khan
vk20117n@pace.edu
April 25, 2018 */


###########################################################################
#Part 1
#Question 1
DROP VIEW IF EXISTS Holder ;
CREATE VIEW Holder AS
SELECT
  IB.BGID,
  IB.Designation,
  IB.HQ_LocationX,
  IB.HQ_LocationY,
  SU.STUID,
  SU.UnitCmd,
  SU.UnitType,
  SU.Location_X,
  SU.Location_Y,
  ABS(SU.Location_X - SU.Location_Y) AS XYRange
FROM
  imperial_battlegroup IB
  INNER JOIN stormtrooper_unit SU ON SU.UnitCmd = IB.BGID
WHERE
  Designation = 'Battle Group I'
  AND UnitType = 'Aslt Infantry'
  AND ABS(Location_X - Location_Y) > 100;

  SELECT * FROM Holder;



#Question 2
DROP VIEW IF EXISTS Holder2;
CREATE VIEW Holder2 AS
SELECT
 STO.STID,
 STO.Rank,
 STO.Gender,
 STO.DutyCategory,
 STO.DutyStatus,
 SOA.Role,
 SU.STUID,
 CONCAT (IB.BGID,'<>',IB.Designation) AS HQ,
 SU.Location_X,
 SU.Location_Y,
 ABS(SU.Location_X - SU.Location_Y) AS UnitXYRange
 FROM stormtroopers_officer STO
 INNER JOIN st_officer_assign SOA ON SOA.STID = STO.STID
 INNER JOIN stormtrooper_unit SU ON SU.STUID = SOA.STUID
 INNER JOIN imperial_battlegroup IB ON IB.BGID = SU.UnitCmd
 WHERE DutyCategory = 'Reserve'
 AND Gender = 'Female'
 AND Role = 'Communications'
 AND ABS(Location_X - Location_Y) < 150;
     
SELECT * FROM Holder2;


#Question 3
DROP VIEW IF EXISTS Holder3;
CREATE VIEW Holder3 AS
SELECT
  STO.STID,
  STO.Rank,
  STO.Gender,
  STO.DutyCategory,
  STO.DutyStatus,
  SU.STUID,
  SOA.Role,
  CONCAT (IB.BGID, '<>', IB.Designation) AS HQ,
  CONCAT(
    '[HQ Range: ',
    ABS(HQ_LocationX - HQ_LocationY),
    '][ Unit Range: ',
    ABS(Location_X - Location_Y)
  ) AS HQ_UnitXYRange
FROM
  stormtroopers_officer STO
  INNER JOIN st_officer_assign SOA ON SOA.STID = STO.STID
  INNER JOIN stormtrooper_unit SU ON SU.STUID = SOA.STUID
  INNER JOIN imperial_battlegroup IB ON IB.BGID = SU.UnitCmd
WHERE
  (
    SU.STUID = 'STU-7'
    OR SU.STUID = 'STU-24'
  )
  AND Gender = 'Female';

SELECT * FROM Holder3;

#Question 4

  SELECT COUNT(*) INTO @MNScouts FROM stormtroopers_nco
  JOIN st_nco_assign ON stormtroopers_nco.STID = st_nco_assign.STID
  AND st_nco_assign.Role = 'Scout' AND stormtroopers_nco.Gender = 'Male';

  SELECT COUNT(*) INTO @FNScouts FROM stormtroopers_nco
  JOIN st_nco_assign ON stormtroopers_nco.STID = st_nco_assign.STID
  AND st_nco_assign.Role = 'Scout' AND stormtroopers_nco.Gender = 'Female';

  SELECT COUNT(*) INTO @MOScouts FROM stormtroopers_officer
  JOIN st_officer_assign ON stormtroopers_officer.STID = st_officer_assign.STID
  AND st_officer_assign.Role = 'Scout' AND stormtroopers_officer.Gender = 'Male';

  SELECT COUNT(*) INTO @FOScouts FROM stormtroopers_officer
  JOIN st_officer_assign ON stormtroopers_officer.STID = st_officer_assign.STID
  AND st_officer_assign.Role = 'Scout' AND stormtroopers_officer.Gender = 'Female';

  SELECT COUNT(*) INTO @MTScouts FROM stormtroopers_troop
  JOIN st_troop_assign ON stormtroopers_troop.STID = st_troop_assign.STID
  AND st_troop_assign.Role = 'Scout' AND stormtroopers_troop.Gender = 'Male';


  SELECT COUNT(*) INTO @FTScouts FROM stormtroopers_troop
  JOIN st_troop_assign ON stormtroopers_troop.STID = st_troop_assign.STID
  AND st_troop_assign.Role = 'Scout' AND stormtroopers_troop.Gender = 'Female';

  SET @TFS = @FOScouts + @FNScouts + @FTScouts;
  SET @TMS = @MOScouts + @MNScouts + @MTScouts;
  SET @TS = @TFS + @TMS;

  SELECT @FOScouts AS FOScouts,@FNScouts AS FNScouts,@FTScouts AS FTScouts, @MOScouts AS MOScouts, @MNScouts AS MNScouts,@MTScouts AS MTScouts,@TFS AS 'Total Female Scout',
  @TMS AS 'Total Male Scout',@TS AS 'Total Scout';



#Question 5

#Create a single query (that may utilize any of the above listed constructs) that displays the number of male or 
#female troopers by rank category (Officer, NCO, or Troop) in STU-7 and the total number female and male troopers in STU-7. ****See Slide 5 for Expected Output from this query


SELECT COUNT(*) INTO @MNScouts FROM stormtroopers_nco
  JOIN st_nco_assign ON stormtroopers_nco.STID = st_nco_assign.STID
  AND st_nco_assign.Role = 'Trooper' AND stormtroopers_nco.Gender = 'Male' AND st_nco_assign.STUID = 'STU-7' AND stormtroopers_nco.DutyCategory = 'Active';

  SELECT COUNT(*) INTO @FNScouts FROM stormtroopers_nco
  JOIN st_nco_assign ON stormtroopers_nco.STID = st_nco_assign.STID
  AND st_nco_assign.Role = 'Trooper' AND stormtroopers_nco.Gender = 'Female' AND st_nco_assign.STUID = 'STU-7' AND stormtroopers_nco.DutyCategory = 'Active';

  SELECT COUNT(*) INTO @MOScouts FROM stormtroopers_officer
  JOIN st_officer_assign ON stormtroopers_officer.STID = st_officer_assign.STID
  AND st_officer_assign.Role = 'Trooper' AND stormtroopers_officer.Gender = 'Male'  AND st_officer_assign.STUID = 'STU-7' AND stormtroopers_officer.DutyCategory = 'Active';

  SELECT COUNT(*) INTO @FOScouts FROM stormtroopers_officer
  JOIN st_officer_assign ON stormtroopers_officer.STID = st_officer_assign.STID
  AND st_officer_assign.Role = 'Trooper' AND stormtroopers_officer.Gender = 'Female'AND st_officer_assign.STUID = 'STU-7' AND stormtroopers_officer.DutyCategory = 'Active';

  SELECT COUNT(*) INTO @MTScouts FROM stormtroopers_troop
  JOIN st_troop_assign ON stormtroopers_troop.STID = st_troop_assign.STID
  AND st_troop_assign.Role = 'Trooper' AND stormtroopers_troop.Gender = 'Male'  AND st_troop_assign.STUID = 'STU-7' AND stormtroopers_troop.DutyCategory = 'Active';


  SELECT COUNT(*) INTO @FTScouts FROM stormtroopers_troop
  JOIN st_troop_assign ON stormtroopers_troop.STID = st_troop_assign.STID
  AND st_troop_assign.Role = 'Trooper' AND stormtroopers_troop.Gender = 'Female' AND st_troop_assign.STUID = 'STU-7' AND stormtroopers_troop.DutyCategory = 'Active';

  SET @TFS = @FOScouts + @FNScouts + @FTScouts;
  SET @TMS = @MOScouts + @MNScouts + @MTScouts;
  SET @TS = @TFS + @TMS;

  SELECT @FOScouts AS FOTrooper,@FNScouts AS FNTrooper,@FTScouts AS FTTrooper, @MOScouts AS MOTrooper, @MNScouts AS MNTrooper,@MTScouts AS MTTrooper,
  @TFS AS 'Total Active STU-7 Female Trooper', @TMS AS 'Total Active STU-7 Male Trooper',@TS AS 'Total Active STU-7 Trooper';

#############################################################################
#Part 2
DROP PROCEDURE IF EXISTS Gender_Rank_Unit_Status;

DELIMITER //

CREATE PROCEDURE Gender_Rank_Unit_Status(Gen_der CHAR(15),Ra_nk CHAR(15),S_TID varchar(35),Duty_C char(15))
BEGIN
DECLARE rowCount INT DEFAULT 0;
DECLARE counter INT DEFAULT 0;
DECLARE x_STID VARCHAR(20) ;
DECLARE x_Role VARCHAR(30) ;

DECLARE rank CURSOR FOR
SELECT st_officer_assign.STID,st_officer_assign.Role FROM st_officer_assign JOIN stormtroopers_officer ON st_officer_assign.STID = stormtroopers_officer.STID 
AND stormtroopers_officer.Gender=Gen_der and stormtroopers_officer.Rank=Ra_nk AND stormtroopers_officer.DutyCategory=Duty_C AND st_officer_assign.STUID=S_TID
UNION
SELECT st_nco_assign.STID,st_nco_assign.Role FROM st_nco_assign  INNER JOIN stormtroopers_nco  ON st_nco_assign.STID = stormtroopers_nco.STID 
AND stormtroopers_nco.Gender=Gen_der and stormtroopers_nco.Rank=Ra_nk AND stormtroopers_nco.DutyCategory=Duty_C AND st_nco_assign.STUID=S_TID
UNION
SELECT st_troop_assign.STID,st_troop_assign.Role FROM st_troop_assign INNER JOIN stormtroopers_troop  ON st_troop_assign.STID = stormtroopers_troop.STID 
AND stormtroopers_troop.Gender=Gen_der and stormtroopers_troop.Rank=Ra_nk AND stormtroopers_troop.DutyCategory=Duty_C AND st_troop_assign.STUID=S_TID;
DROP TABLE IF EXISTS GRUS_T;
CREATE TABLE IF NOT EXISTS GRUS_T (STID VARCHAR(15), Gender CHAR(15), Rank CHAR(15), DutyCategory CHAR(15), UnitAssigned CHAR(15), Role VARCHAR(25));

OPEN rank;

SELECT FOUND_ROWS() INTO rowCount;
process_loop: LOOP
IF counter < rowCount THEN
FETCH rank INTO x_STID,x_Role;

INSERT INTO GRUS_T VALUES(x_STID,Gen_der,Ra_nk,Duty_C,S_TID,x_Role);
SET counter = counter + 1;
ELSE
LEAVE process_loop;
END IF;
END LOOP process_loop;
CLOSE rank;
SELECT * FROM GRUS_T WHERE STID=x_STID;
END //

DELIMITER ;

CALL Gender_Rank_Unit_Status('Female','LT','STU-7','Active');
CALL Gender_Rank_Unit_Status('Male','CPL','STU-17','Reserve');
CALL Gender_Rank_Unit_Status('Female','TRPR','STU-7','Active');


#################################################################################
#Section 3

DROP PROCEDURE IF EXISTS HQTroopSummary;
DELIMITER // 

CREATE PROCEDURE HQTroopSummary (BG_ID varchar(20)) 

BEGIN DECLARE rowCount INT DEFAULT 0;
DECLARE counter INT DEFAULT 0;
DECLARE C_BGID VARCHAR(15);
DECLARE C_Designation varChar(15);
DECLARE C_HQ_LocationX VARCHAR(15);
DECLARE C_HQ_LocationY VARCHAR(15);
DECLARE C_ASLT VARCHAR(15);
DECLARE C_INF VARCHAR(15);
DECLARE C_REC VARCHAR(15);
DECLARE C_ALU VARCHAR(200);

DECLARE CURSOR4 CURSOR FOR
SELECT
  BGID,
  Designation,
  HQ_LocationX,
  HQ_LocationY,
  COUNT(IF(UnitType = 'Aslt Infantry', 1, NULL)) 'Aslt_Infantry',
  COUNT(IF(UnitType = 'Infantry', 1, NULL)) 'Infantry',
  COUNT(IF(UnitType = 'Reconnaissance', 1, NULL)) 'Reconnaissance',
  GROUP_CONCAT(STUID separator ': ') AS 'AllUnits'
FROM
  imperial_battlegroup, stormtrooper_unit
WHERE
  imperial_battlegroup.BGID = stormtrooper_unit.UnitCmd
  AND BGID = BG_ID
GROUP by
  BGID;

DROP TABLE IF EXISTS HQ_Summary;

  CREATE TABLE IF NOT EXISTS HQ_Summary(
    BGID varchar(20),
    Designation varchar(25),
    HQ_LocationX int,
    HQ_LocationY int,
    ASLTInfantry int,
    Infantry int,
    Reconnaissance int,
    AllUnits varchar(200)
  );OPEN CURSOR4;
SELECT
  FOUND_ROWS() INTO rowCount;process_loop: LOOP IF counter < rowCount THEN FETCH CURSOR4 INTO C_BGID,C_Designation,C_HQ_LocationX,C_HQ_LocationY,C_ASLT,C_INF,C_REC,C_ALU;
 
INSERT INTO
  HQ_Summary
VALUES
  (C_BGID,C_Designation,C_HQ_LocationX,C_HQ_LocationY,C_ASLT,C_INF,C_REC,C_ALU);
SET
  counter = counter + 1;
  ELSE LEAVE process_loop;END IF;END LOOP process_loop;CLOSE CURSOR4;
SELECT  * From HQ_Summary
WHERE   BGID = BG_ID;
END // 

DELIMITER ;


CALL HQTroopSummary ('BG_1');
CALL HQTroopSummary ('BG_2');









#####################################################################################

#Part 4 
#Function 1

DELIMITER //
DROP FUNCTION IF EXISTS walkerCubicAreaWeight;
CREATE FUNCTION walkerCubicAreaWeight (WType1 CHAR(5))
RETURNS DECIMAL(5,2)

BEGIN 
DECLARE Cubic_Area_Weight  FLOAT;
SELECT Weight INTO @A FROM imperial_walker_type WHERE WType = WType1;
SELECT Height INTO @B FROM imperial_walker_type WHERE WType = WType1;
SELECT Length INTO @C FROM imperial_walker_type WHERE WType = WType1;
SELECT Width INTO @D FROM imperial_walker_type WHERE WType = WType1;

SET Cubic_Area_Weight = @A/(@B*@C*@D) ;
RETURN Cubic_Area_Weight;
END //

DELIMITER ;




#Function 2
DELIMITER //
DROP FUNCTION IF EXISTS walkerFuelCapacity;
CREATE FUNCTION walkerFuelCapacity (WType1 varCHAR(20))
RETURNS DECIMAL(10,2)

BEGIN 
DECLARE Walker_Fuel_Capacity FLOAT;
SELECT OpRange INTO @E FROM imperial_walker_type WHERE WType = WType1;
SET Walker_Fuel_Capacity = walkerCubicAreaWeight(WType1) *@E ;
RETURN Walker_Fuel_Capacity;
END  //

DELIMITER ;




#Function 3

DELIMITER //
DROP FUNCTION IF EXISTS walkerFuelExpenditure ;
CREATE FUNCTION walkerFuelExpenditure (WType1 VARCHAR(10))
RETURNS DECIMAL(10,2)
BEGIN 
DECLARE Fuel_Expenditure_per_Mile FLOAT;
DECLARE FUELx DECIMAL (10,2) ;
SELECT OpRange INTO @F FROM imperial_walker_type WHERE WType = WType1;
SET FUELx = walkerFuelCapacity(WType1)*0.98;
SET Fuel_Expenditure_per_Mile =  (@F/FUELx)/100 ; 
RETURN Fuel_Expenditure_per_Mile;

END  //
DELIMITER ;




#Function 4

DELIMITER //
DROP FUNCTION IF EXISTS walkerArmorWeight ;
CREATE FUNCTION walkerArmorWeight (WType1 VARCHAR(10))
RETURNS DECIMAL(10,2)
BEGIN 
DECLARE Armor_Weight FLOAT;
SELECT Weight INTO @H FROM imperial_walker_type WHERE WType = WType1;
SET Armor_Weight = @H*0.33;
RETURN Armor_Weight;

END  //
DELIMITER ;





#FUNCTION 5
DELIMITER //
DROP FUNCTION IF EXISTS walkerStructureWeight ;
CREATE FUNCTION walkerStructureWeight (WType1 VARCHAR(10))
RETURNS DECIMAL(10,2)
BEGIN 
DECLARE Structure_Weight  FLOAT;
SELECT Weight INTO @I FROM imperial_walker_type WHERE WType = WType1;
SET Structure_Weight = @I*0.67;
RETURN Structure_Weight;

END  //
DELIMITER ;


##################################################################

#Part 5 Stored Procedures 

DROP PROCEDURE IF EXISTS walkerMasterSummary;
DELIMITER //

CREATE PROCEDURE walkerMasterSummary()
BEGIN

DECLARE rowCount INT DEFAULT 0;
DECLARE counter INT DEFAULT 0;
DECLARE insertCount INT DEFAULT 1;
DECLARE C_WID VARCHAR(20);
DECLARE C_WType_WTID VARCHAR(20);
DECLARE C_WALKERType VARCHAR(20);
DECLARE C_WUID VARCHAR(20);
DECLARE C_BGID VARCHAR(20);
DECLARE C_CubicAreaWeight DECIMAL(10,2);
DECLARE C_FuelCapacity DECIMAL(10,2);
DECLARE C_FuelExpenditure_Mile DECIMAL(10,2);
DECLARE C_ArmorWeight DECIMAL(10,2);
DECLARE C_StructureWeight DECIMAL(10,2);
DECLARE C_Status VARCHAR(20);
DECLARE CostToRepair INT;



DECLARE CURSOR1 CURSOR FOR 
                SELECT WID,WalkerType,CONCAT(WTYPEID, WTYPE) AS WType_WTID,imperial_walkers_assign.WUID,BattleGroup AS BGID,walkerCubicAreaWeight(WalkerType) AS CubicAreaWeight,walkerFuelCapacity(WalkerType) AS FuelCapacity,
                                                walkerFuelExpenditure(WalkerType) AS FuelExpenditure_Mile,walkerArmorWeight(WalkerType) AS ArmorWeight,walkerStructureWeight(WalkerType) AS StructureWeight,Status FROM imperial_walkers_assign 
    JOIN walker_units ON imperial_walkers_assign.WUID =walker_units.WUID
    JOIN imperial_walker_type ON imperial_walkers_assign.WalkerType =imperial_walker_type.WType order by WID;

                

                DROP TABLE IF EXISTS walker_summary;
                CREATE TABLE IF NOT EXISTS walker_summary(
                WID VARCHAR(10),
                WType_WTID CHAR(15),
                WUID VARCHAR(6),
                BGID VARCHAR(5),
                CubicAreaWeight DECIMAL (10,2),
                FuelCapacity DECIMAL (10,2),
                FuelExpenditure_Mile DECIMAL (10,2),
                ArmorWeight DECIMAL (10,2),
                StructureWeight DECIMAL (10,2),
                Status CHAR(20),
                CostToRepair INT
                );

OPEN CURSOR1;
SELECT FOUND_ROWS() INTO rowCount;
process_loop: LOOP
                                IF counter < rowCount THEN
                                                FETCH CURSOR1 INTO C_WID,C_WALKERType,C_WType_WTID,C_WUID,C_BGID,C_CubicAreaWeight,
                                                C_FuelCapacity,C_FuelExpenditure_Mile,C_ArmorWeight,C_StructureWeight,C_Status;

         IF C_Status='Damaged' AND C_WALKERType ='AT-AT ' THEN
          SET CostToRepair = 112 * (C_ArmorWeight + C_StructureWeight) ;
          ELSE IF C_Status='Damaged' AND C_WALKERType ='AT-ST ' THEN
          SET CostToRepair = 89 * (C_ArmorWeight + C_StructureWeight) ;
          ELSE
          SET CostToRepair = 0;
          END IF;
          END IF;
                                
INSERT INTO walker_summary VALUES (C_WID,C_WType_WTID,C_WUID,C_BGID,C_CubicAreaWeight,C_FuelCapacity,C_FuelExpenditure_Mile,C_ArmorWeight,C_StructureWeight,C_Status,CostToRepair);
                                SET counter = counter + 1;
                                ELSE 
                                                LEAVE process_loop;
                                END IF;
                END LOOP process_loop;
                CLOSE CURSOR1;
select * from walker_summary;

END //
DELIMITER ;

call walkerMasterSummary;





###########################################################################################################
#Section 6

SELECT COUNT(*) INTO @DamagedWalker FROM imperial_walkers_assign IWA
WHERE IWA.Status = 'Damaged' AND IWA.WalkerType = 'AT-AT';
SET @DATAT = @DamagedWalker*112*125;

SELECT COUNT(*) INTO @DamagedWalker2 FROM imperial_walkers_assign IWA
WHERE IWA.Status = 'Damaged' AND IWA.WalkerType = 'AT-ST';
SET @DATST = @DamagedWalker2 *89*8;

SET @TOTALDAMAGEVALUE = @DATAT+@DATST;
SELECT @TOTALDAMAGEVALUE AS 'Total Walker Repair Cost';


SELECT COUNT(*) INTO @BG FROM stormtrooper_unit STU WHERE STU.UnitCmd = 'BG_2';
SELECT @BG AS 'Total Number of Units in Battle Group II';

SELECT COUNT(*) INTO @FST FROM stormtroopers_officer STO 
INNER JOIN st_officer_assign SOA ON STO.STID = SOA.STID
WHERE STO.Gender = 'Female'
AND STO.Weight < 220
AND SOA.Role = 'Communications';
SELECT @FST AS 'Total Lightweight Female Stormtrooper Officers';