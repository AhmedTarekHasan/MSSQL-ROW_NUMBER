DECLARE @currentRowNumber INT = 1
DECLARE @maxRowNumber INT
DECLARE @name NVARCHAR(MAX)
DECLARE @subject NVARCHAR(MAX)


-- declaring a table variable to hold the data with an extra column for the 'RowNumber'
DECLARE @AllStudentsSubjectsWithRowNumber TABLE
(
	[Id] INT
	, [Name] NVARCHAR(MAX)
	, [Subject] NVARCHAR(MAX)
	, [RowNumber] INT
)


-- inserting data into the table variable without forgetting about the 'RowNumber' column
INSERT INTO @AllStudentsSubjectsWithRowNumber
(
	[Id]
	, [Name]
	, [Subject]
	, [RowNumber]
)
SELECT Id
, Name
, Subject
, ROW_NUMBER() OVER (ORDER BY Name, Subject) AS [RowNumber]
FROM StudentsSubjects


-- getting the maximum row number to be used to decide when to stop looping
SELECT @maxRowNumber = COUNT(Id) FROM @AllStudentsSubjectsWithRowNumber
PRINT ('@maxRowNumber = ' + CAST(@maxRowNumber AS NVARCHAR(MAX))) -- for demonstration


WHILE(@currentRowNumber <= @maxRowNumber)
BEGIN
	-- here you have a [RowNumber] to filter with to get the matching record
	-- then you can do whatever you want with this record. You can call a function
	-- or a stored procedure or do some data manipulations, it is up to you

	SELECT @name = Name
	, @subject = Subject
	
	FROM @AllStudentsSubjectsWithRowNumber
	
	WHERE [RowNumber] = @currentRowNumber

	PRINT (@name + ' attends classes of ' + @subject) -- for demonstration

	SET @currentRowNumber = @currentRowNumber + 1
END