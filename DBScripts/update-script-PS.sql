/*
Deployment script for LN_DL_Packaging_P2

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "LN_DL_Packaging_P2"
:setvar DefaultFilePrefix "LN_DL_Packaging_P2"
--:setvar DefaultDataPath "c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
--:setvar DefaultLogPath "c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating [dbo].[fnGetAlternateDpsi]...';


GO
CREATE FUNCTION [dbo].[fnGetAlternateDpsi]
(
	@DPSI NVARCHAR(10)
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @AlternateDPSI NVARCHAR(10)

	IF EXISTS (SELECT 1 WHERE @DPSI LIKE 'P-%')
		BEGIN
			SET @AlternateDPSI = REPLACE(@DPSI, 'P-', '')
		END
	ELSE
		BEGIN
			SET @AlternateDPSI = 'P-' + @DPSI
		END

	IF NOT EXISTS (SELECT 1 FROM tblDLMaster WHERE DLDetailsXML.value('(/dpsi/@dpsiCode)[1]', 'nvarchar(10)') = @AlternateDPSI)
		BEGIN
			SET @AlternateDPSI = NULL
		END
		
	RETURN @AlternateDPSI
END
GO
PRINT N'Creating [dbo].[fnGetAlternateDlId]...';


GO
CREATE FUNCTION [dbo].[fnGetAlternateDlId]
(
	@DlId INT
)
RETURNS INT
BEGIN
	DECLARE @DPSI NVARCHAR(10)
	DECLARE @AlternateDPSI NVARCHAR(10)
	DECLARE @AlternateDlId INT

	SELECT @DPSI = DLDetailsXML.value('(/dpsi/@dpsiCode)[1]', 'nvarchar(10)') 
	FROM tblDLMaster 
	WHERE DLID = @DlId

	SELECT @AlternateDPSI = dbo.fnGetAlternateDpsi(@DPSI)

	SELECT @AlternateDlId = DLID 
	FROM tblDLMaster  
	WHERE DLDetailsXML.value('(/dpsi/@dpsiCode)[1]', 'nvarchar(10)') = @AlternateDPSI

	RETURN @AlternateDlId
END
GO
PRINT N'Creating [dbo].[vwDlDpsiMappings]...';


GO
CREATE VIEW [dbo].[vwDlDpsiMappings]
AS 
SELECT 
	DLID, 
	DLDetailsXML.value('(/dpsi/@dpsiCode)[1]', 'nvarchar(10)') as DPSI, 
	dbo.fnGetAlternateDlId(DLID) as AlternateDLID,
	dbo.fnGetAlternateDpsi(DLDetailsXML.value('(/dpsi/@dpsiCode)[1]', 'nvarchar(10)')) as AlternateDPSI
FROM tblDLMaster
GO
PRINT N'Update complete.';


GO
