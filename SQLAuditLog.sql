CREATE DATABASE Audit_Table;

USE Audit_Table;

/*Creating employee table*/
CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY,
	NAME NVARCHAR(100),
	Position NVARCHAR(100),
	Salary DECIMAL(10,2)
	);

/*Creating audit table*/
CREATE TABLE EmployeeAudit(
	AuditID INT IDENTITY(1,1) PRIMARY KEY, 
	EmployeeID INT,
	NAME NVARCHAR(100),
	Position NVARCHAR(100),
	Salary DECIMAL(10,2),
	OperationType NVARCHAR(10),
	OperationDate DATETIME DEFAULT GETDATE(),
	PerformedBy NVARCHAR(100)
	);

/*Insert trigger*/
CREATE TRIGGER Trg_Employee_Insert
ON Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO EmployeeAudit(EmployeeID, Name, Position, Salary, OperationType, OperationDate, PerformedBy)
	SELECT EmployeeID, Name, Position,Salary,'INSERT',GETDATE(),SYSTEM_USER FROM inserted;
END;

DROP TRIGGER Trg_Employee_Insert;
/*Update trigger*/
CREATE TRIGGER Trg_Employee_Update
ON Employees
AFTER UPDATE
AS
BEGIN
	INSERT INTO EmployeeAudit (EmployeeID, Name, Position, Salary, OperationType, OperationDate,PerformedBy)
	SELECT EmployeeID, Name, Position, Salary, 'UPDATE',GETDATE(), SYSTEM_USER FROM inserted;
END;
DROP TRIGGER Trg_Employee_Update
/*Delete trigger*/
CREATE TRIGGER Trg_Employee_Delete
ON Employees
AFTER DELETE
AS
BEGIN
	INSERT INTO EmployeeAudit (EmployeeID, Name, Position, Salary, OperationType, OperationDate, PerformedBy)
	SELECT EmployeeID, Name, Position, Salary, 'DELETE',GETDATE(), SYSTEM_USER FROM deleted;
END;
DROP TRIGGER Trg_Employee_Delete


/*Sample audit log*/

--Insert
INSERT INTO employees VALUES (1, 'Alice', 'Manager', 75000);

--UPDATE
UPDATE Employees SET Salary = 80000 WHERE EmployeeID = 1;

--DELETE
DELETE FROM Employees WHERE EmployeeID =1;

-- VIEW audit log
SELECT * FROM EmployeeAudit;