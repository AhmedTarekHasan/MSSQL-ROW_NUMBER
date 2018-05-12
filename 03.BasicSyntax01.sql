SELECT Id
, Name
, Subject
, ROW_NUMBER() OVER (ORDER BY Name, Subject) AS [RowNumber]
FROM StudentsSubjects