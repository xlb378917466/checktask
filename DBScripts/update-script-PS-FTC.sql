﻿/*
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
PRINT N'Creating [dbo].[tblKeyCases]...';


GO
CREATE TABLE [dbo].[tblKeyCases] (
    [KeyCaseId]         INT           IDENTITY (1, 1) NOT NULL,
    [PublicationName]   VARCHAR (500) NULL,
    [PublicationDPSI]   VARCHAR (500) NULL,
    [DirSourceLocation] VARCHAR (500) NULL,
    [Status]            INT           NULL,
    [IsActive]          BIT           NULL,
    [KeyCaseXML]        XML           NULL,
    [CreatedBy]         VARCHAR (50)  NULL,
    [CreatedDate]       DATETIME      NULL,
    [ModifiedBy]        VARCHAR (50)  NULL,
    [ModifiedDate]      DATETIME      NULL,
    CONSTRAINT [PK_tblKeyCases] PRIMARY KEY CLUSTERED ([KeyCaseId] ASC)
);


GO
PRINT N'Creating [dbo].[tblURJPublicationHistory]...';


GO
CREATE TABLE [dbo].[tblURJPublicationHistory] (
    [HstPublicationID]  INT           IDENTITY (1, 1) NOT NULL,
    [PublicationID]     INT           NOT NULL,
    [PublicationDPSI]   VARCHAR (50)  NOT NULL,
    [DirSourceLocation] VARCHAR (500) NOT NULL,
    [FilesXML]          XML           NOT NULL,
    [ModifiedBy]        VARCHAR (500) NOT NULL,
    [ModifiedDate]      DATETIME      NOT NULL,
    CONSTRAINT [PK_tblURJPublicationHistory] PRIMARY KEY CLUSTERED ([HstPublicationID] ASC)
);


GO
PRINT N'Creating [dbo].[tblURJPublicationMaster]...';


GO
CREATE TABLE [dbo].[tblURJPublicationMaster] (
    [PublicationID]     INT           IDENTITY (1, 1) NOT NULL,
    [PublicationDPSI]   VARCHAR (50)  NOT NULL,
    [DirSourceLocation] VARCHAR (500) NOT NULL,
    [FilesXML]          XML           NOT NULL,
    [ModifiedBy]        VARCHAR (500) NOT NULL,
    [ModifiedDate]      DATETIME      NOT NULL,
    [CreatedDate]       DATETIME      NOT NULL,
    [CreatedBy]         VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tblURJPublicationMaster] PRIMARY KEY CLUSTERED ([PublicationID] ASC)
);


GO
PRINT N'Creating DF_tblKeyCases_Status...';


GO
ALTER TABLE [dbo].[tblKeyCases]
    ADD CONSTRAINT [DF_tblKeyCases_Status] DEFAULT ((2)) FOR [Status];


GO
PRINT N'Creating FK_tblKeyCases_tblPackageStatusMaster...';


GO
ALTER TABLE [dbo].[tblKeyCases] WITH NOCHECK
    ADD CONSTRAINT [FK_tblKeyCases_tblPackageStatusMaster] FOREIGN KEY ([Status]) REFERENCES [dbo].[tblPackageStatusMaster] ([Statuscode]);


GO
PRINT N'Creating FK_tblURJPublicationHistory_tblURJPublicationMaster...';


GO
ALTER TABLE [dbo].[tblURJPublicationHistory] WITH NOCHECK
    ADD CONSTRAINT [FK_tblURJPublicationHistory_tblURJPublicationMaster] FOREIGN KEY ([PublicationID]) REFERENCES [dbo].[tblURJPublicationMaster] ([PublicationID]);


GO
PRINT N'Creating [dbo].[uspGetAllPremiumPublications]...';


GO
-- ============================================================  
-- Author:   
-- Create date:  
-- Description:   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetAllPremiumPublications]  --'0072', 1
 -- Add the parameters for the stored procedure here  

AS  
BEGIN  
 BEGIN TRY  
     
	SELECT * FROM dbo.tblKeyCases

END TRY  
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetAllURJPublications]...';


GO
-- ============================================================  
-- Author:  Kalaiyarasi Karuppusamy  
-- Create date: 28/04/2015   
-- Description: To Get all URJ publication Details   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetAllURJPublications]   
AS  
BEGIN  
 BEGIN TRY  
     
	SELECT 
		PublicationDPSI, 
		DirSourceLocation, 
		FilesXML,
		ModifiedDate		
		FROM dbo.tblURJPublicationMaster 	
 
 END TRY  
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetDLMaster]...';


GO
-- ============================================================  
-- Author:   
-- Create date:  
-- Description:   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetDLMaster]  --'0072', 1
 -- Add the parameters for the stored procedure here  

AS  
BEGIN  
 BEGIN TRY  
    
	SELECT dlm.*,lf.*,pm.PublicationDPSI,pm.PublicationID FROM dbo.tblDLMaster dlm inner join dbo.tblLooseleaf lf on dlm.DLID = lf.DLID inner join tblPublicationMaster pm on pm.PublicationID =lf.PublicationID where lf.IsActive=1

END TRY 
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetDLMasterByDPSI]...';


GO
-- ============================================================  
-- Author:   
-- Create date:  
-- Description:   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetDLMasterByDPSI]  --'0072', 1
 -- Add the parameters for the stored procedure here  
 @PublicationDPSI VARCHAR(50)
  
AS  
BEGIN  
 BEGIN TRY  
     
	SELECT dlm.*,pm.PublicationID,pm.PublicationDPSI,pm.DirSourceLocation FROM dbo.tblDLMaster dlm inner join dbo.tblLooseleaf lf  on dlm.DLID = lf.DLID inner join dbo.tblPublicationMaster pm on pm.PublicationID=lf.PublicationID where  lf.IsActive=1 and pm.PublicationDPSI=@PublicationDPSI

END TRY 
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetFTCJobs]...';


GO
-- =============================================
-- Author:		Kalaiyarasi Karuppusamy
-- Create date: 27th April 2015
-- Description:	Retrieves all the FTC jobs pending
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFTCJobs]   
AS  
BEGIN  
	SET NOCOUNT ON; 
	
	SELECT [KeyCaseId]
      ,KC.[PublicationDPSI]
      , (SELECT TOP(1) PM.DirSourceLocation FROM [dbo].[tblPublicationMaster] PM
        WHERE PM.PublicationDPSI = KC.PublicationDPSI AND PM.IsActive = 1) AS  'DirSourceLocation'
      ,KC.[KeyCaseXML]      
	FROM [dbo].[tblKeyCases] KC
	WHERE [Status] = 2 
END
GO
PRINT N'Creating [dbo].[uspGetKeyCaseDetailsByDPSI]...';


GO
-- ============================================================  
-- Author:   
-- Create date:  
-- Description:   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetKeyCaseDetailsByDPSI]  --'0072', 1
 -- Add the parameters for the stored procedure here  
 @PublicationDPSI VARCHAR(50)
AS  
BEGIN  
 BEGIN TRY  
     
	SELECT * from dbo.tblKeyCases where PublicationDPSI=@PublicationDPSI
 
 END TRY  
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetKeyCaseStatus]...';


GO
-- ============================================================  
-- Author:   
-- Create date:  
-- Description:   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetKeyCaseStatus]  --'0072', 1
 -- Add the parameters for the stored procedure here  
 @PublicationDPSI VARCHAR(50)
AS  
BEGIN  
 BEGIN TRY  
     
	SELECT IsActive from tblKeyCases where PublicationDPSI=@PublicationDPSI
 
 END TRY  
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetPublicationDetailsByDPSI]...';


GO

-- ============================================================  
-- Author:   
-- Create date:  
-- Description:   
-- ============================================================  

Create PROCEDURE [dbo].[uspGetPublicationDetailsByDPSI]  --'0072', 1
 -- Add the parameters for the stored procedure here  
 @PublicationDPSI VARCHAR(50)
AS  
BEGIN  
 BEGIN TRY  
     
	SELECT 
		PublicationID, 
		PublicationName, 
		PublicationDPSI, 
		DirSourceLocation, 
		CountryCode, 
		GuideCardXML, 
		CreatedBy, 
		CreatedDate, 
		ModifiedBy, 
		ModifiedDate 
		FROM dbo.tblPublicationMaster 
		WHERE
		PublicationDPSI = @PublicationDPSI
		AND IsActive = 1    
 
 END TRY  
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspGetURJPublicationDetails]...';


GO
-- ============================================================  
-- Author:  Kalaiyarasi Karuppusamy  
-- Create date: 20/04/2015   
-- Description: To get particular URJ publication Details   
-- ============================================================  

CREATE PROCEDURE [dbo].[uspGetURJPublicationDetails]  
 -- Add the parameters for the stored procedure here  
 @PublicationDPSI VARCHAR(50) 
AS  
BEGIN  
 BEGIN TRY  
     
	SELECT 
		PublicationID, 
		PublicationDPSI, 
		DirSourceLocation, 
		FilesXML, 
		CreatedBy, 
		CreatedDate, 
		ModifiedBy, 
		ModifiedDate 
		FROM dbo.tblURJPublicationMaster 
		WHERE PublicationDPSI = @PublicationDPSI   
 
 END TRY  
   
 BEGIN CATCH   
    DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
 END CATCH  
END
GO
PRINT N'Creating [dbo].[uspInsertUpdateKeyCaseDetails]...';


GO
-- ============================================================
  -- Author:		
  -- Create date: 
  -- Description:	
  -- ============================================================
  CREATE PROCEDURE [dbo].[uspInsertUpdateKeyCaseDetails]
  -- Add the parameters for the stored procedure here
  @PublicationDPSI VARCHAR(50),
  @KeyCaseXML XML, 
  @LastUpdatedBy VARCHAR(50), 
  @LastUpdatedDate DateTime,
  @DirSourceLocation [varchar](500)
  
  AS
  BEGIN
	  BEGIN TRY
		  BEGIN TRANSACTION UpdateKeyCaseDetails
		  IF EXISTS (SELECT 1 FROM dbo.tblKeyCases WHERE PublicationDPSI =  @PublicationDPSI)
			  BEGIN 
				  UPDATE dbo.tblKeyCases SET
				  IsActive = 1, 
				  [Status] = 2,
				  KeyCaseXML = @KeyCaseXML, DirSourceLocation = @DirSourceLocation,
				  ModifiedBy = @LastUpdatedBy, ModifiedDate = GETDATE()
				  WHERE PublicationDPSI = @PublicationDPSI
			  END
		  ELSE
			  BEGIN
				  INSERT INTO dbo.tblKeyCases(PublicationDPSI, IsActive,KeyCaseXML, DirSourceLocation, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
				  VALUES (@PublicationDPSI,1, @KeyCaseXML, @DirSourceLocation, @LastUpdatedBy, GETDATE(), @LastUpdatedBy, GETDATE())

			  END

		  COMMIT TRANSACTION UpdateKeyCaseDetails
	  END TRY

	  BEGIN CATCH
		  ROLLBACK TRANSACTION UpdateKeyCaseDetails
		  DECLARE @ErrorMessage NVARCHAR(4000);
		  DECLARE @ErrorSeverity INT;
		  DECLARE @ErrorState INT;

		  SELECT @ErrorMessage = ERROR_MESSAGE(),
		  @ErrorSeverity = ERROR_SEVERITY(),
		  @ErrorState = ERROR_STATE();
		  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  END CATCH
  END
GO
PRINT N'Creating [dbo].[uspInsertUpdateURJDetails]...';


GO
-- ============================================================
  -- Author:	Kalaiyarasi Karuppusamy
  -- Create date: 22/04/2015
  -- Description:	To insert/Update URJ file Details
  -- ============================================================
  CREATE PROCEDURE [dbo].[uspInsertUpdateURJDetails]
  -- Add the parameters for the stored procedure here
	  @PublicationDPSI VARCHAR(50), 
	  @URJFilesXML XML, 
	  @LastUpdatedBy VARCHAR(50), 
	  @LastUpdatedDate DateTime,
	  @DirSourceLocation [varchar](500)
  AS
  BEGIN
	  BEGIN TRY
		  BEGIN TRANSACTION UdpateguideCardDetails
			  IF EXISTS (SELECT 1 FROM dbo.tblURJPublicationMaster WHERE PublicationDPSI =  @PublicationDPSI)
			  BEGIN
				  INSERT INTO dbo.tblURJPublicationHistory (PublicationID, PublicationDPSI, DirSourceLocation, FilesXML, ModifiedBy, ModifiedDate)
				  SELECT PublicationID, PublicationDPSI, DirSourceLocation, FilesXML, ModifiedBy, ModifiedDate
				  FROM dbo.tblURJPublicationMaster WHERE PublicationDPSI = @PublicationDPSI

				  UPDATE dbo.tblURJPublicationMaster 
				  SET FilesXML = @URJFilesXML, DirSourceLocation = @DirSourceLocation,
				  ModifiedBy = @LastUpdatedBy, ModifiedDate = GETDATE()
				  WHERE PublicationDPSI = @PublicationDPSI
			  END
			  ELSE
			  BEGIN
				  INSERT INTO dbo.tblURJPublicationMaster(PublicationDPSI, FilesXML, DirSourceLocation, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
				  VALUES (@PublicationDPSI, @URJFilesXML, @DirSourceLocation, @LastUpdatedBy, GETDATE(), @LastUpdatedBy, GETDATE())
			  END

		  COMMIT TRANSACTION UdpateguideCardDetails
	  END TRY
	  BEGIN CATCH
		  ROLLBACK TRANSACTION UdpateguideCardDetails
		  DECLARE @ErrorMessage NVARCHAR(4000);
		  DECLARE @ErrorSeverity INT;
		  DECLARE @ErrorState INT;

		  SELECT @ErrorMessage = ERROR_MESSAGE(),
		  @ErrorSeverity = ERROR_SEVERITY(),
		  @ErrorState = ERROR_STATE();
		  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  END CATCH
  END
GO
PRINT N'Creating [dbo].[uspUpdateFTCJobStatus]...';


GO
-- =============================================
-- Author:		Kalaiyarasi Karuppusamy
-- Create date: 4th May 2015
-- Description:	Update Job status of FTC publishing
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateFTCJobStatus] 
	@KeyCaseId INT,
	@Status INT
AS
BEGIN
	BEGIN TRY        
  		IF EXISTS (SELECT 1 FROM dbo.tblKeyCases WHERE KeyCaseId= @KeyCaseId)  
			BEGIN 				
				UPDATE [dbo].tblKeyCases 
				SET	[Status] = @Status,	
				ModifiedDate = GETDATE()			
				WHERE KeyCaseId = @KeyCaseId			
			END  
		ELSE  
			BEGIN
				RAISERROR ('Job does not exist in the system!!', 16, 1);  
			END
	END TRY
	BEGIN CATCH      
		DECLARE @ErrorMessage NVARCHAR(4000);      
		DECLARE @ErrorSeverity INT;      
		DECLARE @ErrorState INT;    
		      
			SELECT @ErrorMessage = ERROR_MESSAGE(),      
			@ErrorSeverity = ERROR_SEVERITY(),      
			@ErrorState = ERROR_STATE();
		
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);      
	      
	END CATCH
END
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[tblKeyCases] WITH CHECK CHECK CONSTRAINT [FK_tblKeyCases_tblPackageStatusMaster];

ALTER TABLE [dbo].[tblURJPublicationHistory] WITH CHECK CHECK CONSTRAINT [FK_tblURJPublicationHistory_tblURJPublicationMaster];


GO
PRINT N'Update complete.';


GO
