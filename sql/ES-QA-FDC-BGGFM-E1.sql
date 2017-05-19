-- =============================================
-- Creation date: 05/16/2017
-- Project Name: FDC GFM QA
-- =============================================

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputPath' and [ProcessCode] = 'fdcltamover3x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover3x', N'InputPath', N'\\pd-dev-efs-01\FTP\QA\QA-FDC-FTX-ALL\QA\LTA_3X', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='OutputPath' and [ProcessCode] = 'fdcltamover3x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover3x', N'OutputPath', N'\\pd-dev-efs-01\STAGED\QA\QA-FDC-FTX-ALL\IMREM-E1\FDC\LTA_3X', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputTriggerExtension' and [ProcessCode] = 'fdcltamover3x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover3x', N'InputTriggerExtension', N'trigger', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='SubPathRegex' and [ProcessCode] = 'fdcltamover3x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover3x', N'SubPathRegex', N'^.....$', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='SiteWSSQL' and [ProcessCode] = 'fdcltamover3x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover3x', N'SiteWSSQL', N'spToolSelectSiteWS', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='MellonMode' and [ProcessCode] = 'fdcltamover3x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover3x', N'MellonMode', N'False', NULL, NULL)
end
GO

-- fdcltamover4x

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputPath' and [ProcessCode] = 'fdcltamover4x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover4x', N'InputPath', N'\\pd-dev-efs-01\FTP\QA\QA-FDC-FTX-ALL\QA\LTA_4X', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='OutputPath' and [ProcessCode] = 'fdcltamover4x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover4x', N'OutputPath', N'\\pd-dev-efs-01\STAGED\QA\QA-FDC-FTX-ALL\IMREM-E1\FDC\LTA_4X', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputTriggerExtension' and [ProcessCode] = 'fdcltamover4x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover4x', N'InputTriggerExtension', N'trigger', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='SubPathRegex' and [ProcessCode] = 'fdcltamover4x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover4x', N'SubPathRegex', N'^.....$', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='SiteWSSQL' and [ProcessCode] = 'fdcltamover4x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover4x', N'SiteWSSQL', N'spToolSelectSiteWS', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='MellonMode' and [ProcessCode] = 'fdcltamover4x')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcltamover4x', N'MellonMode', N'False', NULL, NULL)
end
GO

-- fdcmellonmover

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputPath' and [ProcessCode] = 'fdcmellonmover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcmellonmover', N'InputPath', N'\\pd-dev-efs-01\FTP\QA\QA-FDC-FTX-ALL\QA\PRCIT-E2', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='OutputPath' and [ProcessCode] = 'fdcmellonmover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcmellonmover', N'OutputPath', N'\\pd-dev-efs-01\STAGED\QA\QA-FDC-FTX-ALL\PRCIT-E2', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputTriggerExtension' and [ProcessCode] = 'fdcmellonmover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcmellonmover', N'InputTriggerExtension', N'trigger', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='SubPathRegex' and [ProcessCode] = 'fdcmellonmover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcmellonmover', N'SubPathRegex', N'^.....$', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='SiteWSSQL' and [ProcessCode] = 'fdcmellonmover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcmellonmover', N'SiteWSSQL', N'spToolSelectSiteWS', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='MellonMode' and [ProcessCode] = 'fdcmellonmover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'fdcmellonmover', N'MellonMode', N'False', NULL, NULL)
end
GO



