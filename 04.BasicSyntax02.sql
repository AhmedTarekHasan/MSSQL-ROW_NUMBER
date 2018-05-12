SELECT Id
, Name
, Subject
, ROW_NUMBER() OVER (PARTITION BY Name ORDER BY Name, Subject) AS [RowNumber]
FROM StudentsSubjects