DECLARE @startingRowNumber INT = 1
DECLARE @endingRowNumber INT
DECLARE @maxRowNumber INT
DECLARE @currentCount INT
DECLARE @name NVARCHAR(MAX)


-- declaring a table variable to hold the data with an extra column for the 'RowNumber'
-- and an extra column for the 'GroupCount'
DECLARE @AllStudentsSubjectsWithRowNumber TABLE
(
	[Id] INT
	, [Name] NVARCHAR(MAX)
	, [Subject] NVARCHAR(MAX)
	, [GroupCount] INT
	, [RowNumber] INT
)


-- inserting data into the table variable without forgetting about the 'RowNumber' column
-- and the 'GroupCount' column
INSERT INTO @AllStudentsSubjectsWithRowNumber
(
	[Id]
	, [Name]
	, [Subject]
	, [GroupCount]
	, [RowNumber]
)
SELECT Id
, Name
, Subject
, COUNT(Id) OVER (PARTITION BY Name) AS [GroupCount]
, ROW_NUMBER() OVER (ORDER BY Name, Subject) AS [RowNumber]
FROM StudentsSubjects


-- getting the maximum row number to be used to decide when to stop looping
SELECT @maxRowNumber = COUNT(Id) FROM @AllStudentsSubjectsWithRowNumber


WHILE(@startingRowNumber <= @maxRowNumber)
BEGIN
	SELECT @name = Name, @currentCount = GroupCount FROM @AllStudentsSubjectsWithRowNumber WHERE RowNumber = @startingRowNumber

	SET @endingRowNumber = @startingRowNumber + @currentCount - 1

	-- here you have a @startingRowNumber and @endingRowNumber which you can use to select grouped records
	-- then you can do whatever you want with these records. You can call a function
	-- or a stored procedure or do some data manipulations, it is up to you

	SELECT *
	FROM @AllStudentsSubjectsWithRowNumber
	WHERE RowNumber >= @startingRowNumber
	AND RowNumber <= @endingRowNumber

	PRINT (@name + ' attends classes of ' + CAST(@currentCount AS NVARCHAR(MAX)) + ' subjects') -- for demonstration

	SET @startingRowNumber = @endingRowNumber + 1
END