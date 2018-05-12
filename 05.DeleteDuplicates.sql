WITH AllStudentsSubjectsWithRowNumber ([Id], [Name], [Subject], [RowNumber])
AS
(
	SELECT Id
	, Name
	, Subject
	, ROW_NUMBER() OVER (PARTITION BY Name, Subject ORDER BY Name, Subject) AS [RowNumber]
	FROM StudentsSubjects
)

DELETE records

FROM StudentsSubjects as records

INNER JOIN AllStudentsSubjectsWithRowNumber
ON AllStudentsSubjectsWithRowNumber.Id = records.Id

WHERE AllStudentsSubjectsWithRowNumber.RowNumber > 1