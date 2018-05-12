DECLARE @pageSize INT = 5 -- page size to be passed
DECLARE @pageIndex INT = 6 -- zero-based page index to be passed (0, 1, 2, ....)


DECLARE @firstItemIndex INT
DECLARE @lastItemIndex INT
DECLARE @maxNumberOfPages INT
DECLARE @maxRowNumber INT
DECLARE @actualNumberOfPages INT
DECLARE @actualTotalNumberOfRows INT
DECLARE @actualCurrentPageNumber INT
DECLARE @actualCurrentPageRowsCount INT


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


-- getting the maximum row number
SELECT @maxRowNumber = COUNT(Id) FROM @AllStudentsSubjectsWithRowNumber
PRINT ('@maxRowNumber = ' + CAST(@maxRowNumber AS NVARCHAR(MAX))) -- for demonstration


-- ***********************************************************************************
-- This block of code is doing some calculations to:
-- 1. Make sure the passed parameters are correct
-- 2. Calculate first and last row in the current page
-- 3. Calculate corrective info to be returned to caller
-- ***********************************************************************************
IF (@pageSize <= 0)
BEGIN
	SET @pageSize = @maxRowNumber
END


IF (CEILING(CAST(CAST(@maxRowNumber AS FLOAT) / CAST(@pageSize AS FLOAT) AS FLOAT)) >= 1)
BEGIN
	SET @maxNumberOfPages = CEILING(CAST(CAST(@maxRowNumber AS FLOAT) / CAST(@pageSize AS FLOAT) AS FLOAT))
END
ELSE
BEGIN
	SET @maxNumberOfPages = 1
END
	

IF (@pageIndex < 0)
BEGIN
	SET @pageIndex = 0
END
ELSE
BEGIN
	IF (@pageIndex > @maxNumberOfPages - 1)
	BEGIN
		SET @pageIndex = @maxNumberOfPages - 1
	END
END

SET @firstItemIndex = @pageIndex * @pageSize
SET @lastItemIndex = (@pageIndex * @pageSize) + (@pageSize - 1)
SET @actualNumberOfPages = @maxNumberOfPages
SET @actualTotalNumberOfRows = @maxRowNumber
SET @actualCurrentPageNumber = @pageIndex + 1
	
IF (@lastItemIndex > @maxRowNumber - 1)
BEGIN
	SET @lastItemIndex = @maxRowNumber - 1
END
	
SET @actualCurrentPageRowsCount = @lastItemIndex - @firstItemIndex + 1

PRINT ('@maxNumberOfPages = ' + CAST(@maxNumberOfPages AS NVARCHAR(MAX))) -- for demonstration
PRINT ('@firstItemIndex = ' + CAST(@firstItemIndex AS NVARCHAR(MAX))) -- for demonstration
PRINT ('@lastItemIndex = ' + CAST(@lastItemIndex AS NVARCHAR(MAX))) -- for demonstration
PRINT ('@actualNumberOfPages = ' + CAST(@actualNumberOfPages AS NVARCHAR(MAX))) -- for demonstration
PRINT ('@actualTotalNumberOfRows = ' + CAST(@actualTotalNumberOfRows AS NVARCHAR(MAX))) -- for demonstration
PRINT ('@actualCurrentPageNumber = ' + CAST(@actualCurrentPageNumber AS NVARCHAR(MAX))) -- for demonstration
PRINT ('@actualCurrentPageRowsCount = ' + CAST(@actualCurrentPageRowsCount AS NVARCHAR(MAX))) -- for demonstration
-- ***********************************************************************************


-- selecting the requested page records
SELECT Id
, Name
, Subject
, RowNumber

FROM @AllStudentsSubjectsWithRowNumber

WHERE RowNumber >= (@firstItemIndex + 1)
AND RowNumber <= (@lastItemIndex + 1)