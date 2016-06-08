-- =============================================
-- Creation date: 06/08/2016
-- Project Name: FDC GFM
-- =============================================

IF NOT EXISTS (Select * from GlobalConfig where [Key]='InputPath' and [ProcessCode] = 'MGN_Reports_Mover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'MGN_Reports_Mover', N'InputPath', N'@@efs@@\FTP\UAT\UAT-MGN-FTX-01\Reports', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='OutputPath' and [ProcessCode] = 'MGN_Reports_Mover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'MGN_Reports_Mover', N'OutputPath', N'@@efs@@\STAGED\UAT\UAT-MGN-FTX-01\Reports', NULL, NULL)
end
GO

IF NOT EXISTS (Select * from GlobalConfig where [Key]='OutputPath' and [ProcessCode] = 'MGN_Reports_Mover')
begin
INSERT [dbo].[GlobalConfig] ([ProcessCode], [Key], [Value], [Misc], [ComputerName]) VALUES ( N'MGN_Reports_Mover', N'SubPathRegex', N'^20634$', NULL, NULL)
end
GO

		