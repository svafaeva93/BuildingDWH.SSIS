MERGE INTO TARDISDW_Merge.Dimension.Policy AS Target
USING Stage_Tardis.dbo.Staging_Policy AS Source
ON Target.MasterNumber = Source.MasterNumber -- Assuming MasterNumber is the primary key for Policy dimension
AND Target.MasterSeq = Source.MasterSeq 
WHEN MATCHED THEN
    UPDATE SET
        Target.MasterSeq = Source.MasterSeq,
        Target.YearOfAccount = Source.YearOfAccount,
        Target.MasterReference = Source.MasterReference,
        Target.Domicile = Source.Domicile,
        Target.CompanyID = (SELECT TOP 1 CompanyID FROM dbo.CompanyXRef WHERE CompanyCode = Source.CompanyName), -- Ensure only one value is returned
        Target.InceptionDate = Source.InceptionDate,
        Target.ExpiryDate = Source.ExpiryDate,
        Target.DateUpdated = CONVERT(datetime, Source.DateUpdated) -- Assuming Source.DateUpdated is in a compatible format

WHEN NOT MATCHED THEN
    INSERT (MasterNumber, MasterSeq, StatusID, ProductID, YearOfAccount, MasterReference, AssuredID, BrokerID, DepartmentID, BranchID, Domicile, CompanyID, InceptionDate, ExpiryDate, UnderWriterID, MethodOfAcceptanceID, RenewalStatusID, ClassID, AreaID, DateCreated, DateExpired, DateUpdated, CurrentYN, SourceSystemID)
    VALUES (Source.MasterNumber, Source.MasterSeq,
            (SELECT TOP 1 StatusID FROM dbo.StatusXRef WHERE StatusCode = Source.MasterStatusCode), -- Ensure only one value is returned
            (SELECT TOP 1 ProductID FROM dbo.ProductXRef WHERE ProductCode = Source.MasterProductCode), -- Ensure only one value is returned
            Source.YearOfAccount, Source.MasterReference,
            (SELECT TOP 1 AssuredID FROM dbo.AssuredXRef WHERE AssuredCode = Source.AssuredNameCode), -- Ensure only one value is returned
            (SELECT TOP 1 BrokerID FROM dbo.BrokerXRef WHERE BrokerCode = Source.BrokerNameCode), -- Ensure only one value is returned
            1, -- Defaulting to 1 if DepartmentID is NULL
            (SELECT TOP 1 BranchID FROM dbo.BranchXRef WHERE BranchCode = Source.BranchName), -- Ensure only one value is returned
            Source.Domicile,
            (SELECT TOP 1 CompanyID FROM dbo.CompanyXRef WHERE CompanyCode = Source.CompanyName), -- Ensure only one value is returned
            Source.InceptionDate, Source.ExpiryDate,
            (SELECT TOP 1 UnderwriterID FROM dbo.UnderwriterXRef WHERE UnderwriterCode = Source.UnderWriterNameCode), -- Ensure only one value is returned
            1, 1, 1, 1, -- Assuming default values for MethodOfAcceptanceID, RenewalStatusID, ClassID, and AreaID
            GETDATE(), NULL, GETDATE(), -- Assuming DateCreated and DateUpdated are set to current timestamp
            1, -- Assuming CurrentYN default value
            Source.SourceSystemID);

Select * from TARDISDW_Merge.Dimension.Policy 

select * from TARDISDW.Dimension.Policy

MERGE INTO TARDISDW_Merge.Dimension.Policy AS Target
USING Stage_Tardis.dbo.Staging_Policy stgPolicy 
JOIN Tardisdw.dbo.StatusXRef statref  
JOIN Tardisdw.dbo.ProductXRef prodref
ON stgPolicy.masterStatusCode = statref.StatusCode
ON Target.MasterNumber = stgPolicy.MasterNumber -- Assuming MasterNumber is the primary key for Policy dimension
ON stgPolicy.MasterProductCode = 
AND Target.MasterSeq = stgPolicy.MasterSeq masterStatusCode
WHEN MATCHED THEN
    UPDATE SET
        Target.MasterSeq = stgPolicy.MasterSeq,
        Target.YearOfAccount = stgPolicy.YearOfAccount,
        Target.MasterReference = stgPolicy.MasterReference,
        Target.Domicile = stgPolicy.Domicile,
        Target.CompanyID = (SELECT TOP 1 CompanyID FROM dbo.CompanyXRef WHERE CompanyCode = stgPolicy.CompanyName), -- Ensure only one value is returned
        Target.InceptionDate = stgPolicy.InceptionDate,
        Target.ExpiryDate = stgPolicy.ExpiryDate,
        Target.DateUpdated = CONVERT(datetime, stgPolicy.DateUpdated) -- Assuming stgPolicy.DateUpdated is in a compatible format

WHEN NOT MATCHED THEN
    INSERT (MasterNumber, MasterSeq, StatusID, ProductID, YearOfAccount, MasterReference, AssuredID, BrokerID, DepartmentID, BranchID, Domicile, CompanyID, InceptionDate, ExpiryDate, UnderWriterID, MethodOfAcceptanceID, RenewalStatusID, ClassID, AreaID, DateCreated, DateExpired, DateUpdated, CurrentYN, SourceSystemID)
    VALUES (stgPolicy.MasterNumber
		   ,stgPolicy.MasterSeq
           ,stgPolicy.MasterStatusCode
		    , -- Ensure only one value is returned
            (SELECT TOP 1 ProductID FROM dbo.ProductXRef WHERE ProductCode = stgPolicy.MasterProductCode), -- Ensure only one value is returned
            stgPolicy.YearOfAccount, stgPolicy.MasterReference,
            (SELECT TOP 1 AssuredID FROM dbo.AssuredXRef WHERE AssuredCode = stgPolicy.AssuredNameCode), -- Ensure only one value is returned
            (SELECT TOP 1 BrokerID FROM dbo.BrokerXRef WHERE BrokerCode = stgPolicy.BrokerNameCode), -- Ensure only one value is returned
            1, -- Defaulting to 1 if DepartmentID is NULL
            (SELECT TOP 1 BranchID FROM dbo.BranchXRef WHERE BranchCode = stgPolicy.BranchName), -- Ensure only one value is returned
            stgPolicy.Domicile,
            (SELECT TOP 1 CompanyID FROM dbo.CompanyXRef WHERE CompanyCode = stgPolicy.CompanyName), -- Ensure only one value is returned
            stgPolicy.InceptionDate, stgPolicy.ExpiryDate,
            (SELECT TOP 1 UnderwriterID FROM dbo.UnderwriterXRef WHERE UnderwriterCode = stgPolicy.UnderWriterNameCode), -- Ensure only one value is returned
            1, 1, 1, 1, -- Assuming default values for MethodOfAcceptanceID, RenewalStatusID, ClassID, and AreaID
            GETDATE(), NULL, GETDATE(), -- Assuming DateCreated and DateUpdated are set to current timestamp
            1, -- Assuming CurrentYN default value
            stgPolicy.SourceSystemID);

Select * from TARDISDW_Merge.Dimension.Policy 

select * from TARDISDW.Dimension.Policy


-----------------------------------------------------

MERGE INTO TARDISDW_Merge.Dimension.Policy AS Target
USING Stage_Tardis.dbo.Staging_Policy stgPolicy 
JOIN Tardisdw.dbo.StatusXRef statref  
JOIN Tardisdw.dbo.ProductXRef prodref
JOIN Tardisdw.dbo.AssuredXref assuref 
JOIN Tardisdw.dbo.BrokerXRef brokerref
JOIN Tardisdw.dbo.BranchXRef branchref
JOIN Tardisdw.dbo.CompanyXRef compref
JOIN Tardisdw.dbo.UnderwriterXRef undref
ON stgPolicy.masterStatusCode = statref.StatusCode
--ON Target.MasterNumber = stgPolicy.MasterNumber 
ON stgPolicy.MasterProductCode = prodref.ProductCode 
ON stgPolicy.AssuredNameCode = assuref.AssuredCode
ON stgPolicy.BrokerNameCode = brokerref.BrokerCode 
ON stgPolicy.BranchName = branchref.BranchCode 
ON stgPolicy.CompanyName = compref.CompanyCode 
ON stgPolicy.UnderwriterNameCode = undref.UnderwriterCode 
AND Target.MasterSeq = stgPolicy.MasterSeq 

WHEN MATCHED THEN
    UPDATE SET
        Target.MasterSeq = stgPolicy.MasterSeq,
        Target.YearOfAccount = stgPolicy.YearOfAccount,
        Target.MasterReference = stgPolicy.MasterReference,
        Target.Domicile = stgPolicy.Domicile,
        Target.CompanyID = (SELECT TOP 1 CompanyID FROM dbo.CompanyXRef WHERE CompanyCode = stgPolicy.CompanyName), -- Ensure only one value is returned
        Target.InceptionDate = stgPolicy.InceptionDate,
        Target.ExpiryDate = stgPolicy.ExpiryDate,
        Target.DateUpdated = CONVERT(datetime, stgPolicy.DateUpdated) -- Assuming stgPolicy.DateUpdated is in a compatible format

WHEN NOT MATCHED THEN
    INSERT (MasterNumber, MasterSeq, StatusID, ProductID, YearOfAccount, MasterReference, AssuredID, BrokerID, DepartmentID, BranchID, Domicile, CompanyID, InceptionDate, ExpiryDate, UnderWriterID, MethodOfAcceptanceID, RenewalStatusID, ClassID, AreaID, DateCreated, DateExpired, DateUpdated, CurrentYN, SourceSystemID)
    VALUES (stgPolicy.MasterNumber
		   ,stgPolicy.MasterSeq
           ,stgPolicy.MasterStatusCode
		    , -- Ensure only one value is returned
            (SELECT TOP 1 ProductID FROM dbo.ProductXRef WHERE ProductCode = stgPolicy.MasterProductCode), -- Ensure only one value is returned
            stgPolicy.YearOfAccount, stgPolicy.MasterReference,
            (SELECT TOP 1 AssuredID FROM dbo.AssuredXRef WHERE AssuredCode = stgPolicy.AssuredNameCode), -- Ensure only one value is returned
            (SELECT TOP 1 BrokerID FROM dbo.BrokerXRef WHERE BrokerCode = stgPolicy.BrokerNameCode), -- Ensure only one value is returned
            1, -- Defaulting to 1 if DepartmentID is NULL
            (SELECT TOP 1 BranchID FROM dbo.BranchXRef WHERE BranchCode = stgPolicy.BranchName), -- Ensure only one value is returned
            stgPolicy.Domicile,
            (SELECT TOP 1 CompanyID FROM dbo.CompanyXRef WHERE CompanyCode = stgPolicy.CompanyName), -- Ensure only one value is returned
            stgPolicy.InceptionDate, stgPolicy.ExpiryDate,
            (SELECT TOP 1 UnderwriterID FROM dbo.UnderwriterXRef WHERE UnderwriterCode = stgPolicy.UnderWriterNameCode), -- Ensure only one value is returned
            1, 1, 1, 1, -- Assuming default values for MethodOfAcceptanceID, RenewalStatusID, ClassID, and AreaID
            GETDATE(), NULL, GETDATE(), -- Assuming DateCreated and DateUpdated are set to current timestamp
            1, -- Assuming CurrentYN default value
            stgPolicy.SourceSystemID);

Select * from TARDISDW_Merge.Dimension.Policy 

select * from TARDISDW.Dimension.Policy





