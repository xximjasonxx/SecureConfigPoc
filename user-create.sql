DROP USER IF EXISTS [id-pocapplication-pojm2j]
GO
CREATE USER [id-pocapplication-pojm2j] FROM EXTERNAL PROVIDER;
GO
ALTER ROLE db_datareader ADD MEMBER [id-pocapplication-pojm2j];
ALTER ROLE db_datawriter ADD MEMBER [id-pocapplication-pojm2j];
GRANT EXECUTE TO [id-pocapplication-pojm2j]
GO

insert into [dbo].[People] values(newid(), 'Jason', 'Farrell')
GO

insert into [dbo].[People] values(newid(), 'Claire', 'Farrell')
GO

insert into [dbo].[People] values(newid(), 'Ethan', 'Farrell');
GO