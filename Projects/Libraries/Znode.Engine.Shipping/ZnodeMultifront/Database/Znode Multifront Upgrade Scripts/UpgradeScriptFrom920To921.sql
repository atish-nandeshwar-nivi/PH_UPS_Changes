

IF EXISTS (SELECT TOP 1 1 FROM Sys.Tables WHERE Name = 'ZnodeMultifront')
BEGIN 
 IF EXISTS (SELECT TOP 1 1 FROM ZnodeMultifront where BuildVersion =   921  )
 BEGIN 
 PRINT 'Script is already executed....'
  SET NOEXEC ON 
 END 
END
ELSE 
BEGIN 
   SET NOEXEC ON
END 
INSERT INTO [dbo].[ZnodeMultifront] ( [VersionName], [Descriptions], [MajorVersion], [MinorVersion], [LowerVersion], [BuildVersion], [PatchIndex], [CreatedBy], 
[CreatedDate], [ModifiedBy], [ModifiedDate]) 
VALUES ( N'Znode_Multifront_9_2_1', N'Upgrade GA Release By 9_2_1',9,2,1,921,0,2, GETDATE(),2, GETDATE())
GO 
SET ANSI_NULLS ON
GO


UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>UserId</name><headertext>Checkbox</headertext><width>40</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>y</ischeckbox><checkboxparamfield>UserId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>UserName</name><headertext>Username</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>y</isallowlink><islinkactionurl>/Customer/CustomerEdit</islinkactionurl><islinkparamfield>UserId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>FullName</name><headertext>Full Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>y</isallowlink><islinkactionurl>/Customer/CustomerEdit</islinkactionurl><islinkparamfield>UserId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>Email</name><headertext>Email ID</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Email Id</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>PhoneNumber</name><headertext>Phone Number</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Phone Number</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>6</id><name>Accountname</name><headertext>Account</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Account</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>7</id><name>RoleName</name><headertext>Role Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>8</id><name>StoreName</name><headertext>Store Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>9</id><name>DepartmentName</name><headertext>Department Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>10</id><name>LastName</name><headertext>Last Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>y</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Last Name</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>11</id><name>IsLock</name><headertext>Is Lock</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>y</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Is Lock</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>12</id><name>CreatedDate</name><headertext>Created Date </headertext><width>60</width><datatype>Date</datatype><columntype>DateTime</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>13</id><name>CompanyName</name><headertext>Company Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>14</id><name>CityName</name><headertext>City</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>15</id><name>StateName</name><headertext>State</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>16</id><name>PostalCode</name><headertext>Postal Code</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>17</id><name>CountryName</name><headertext>Country</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format></format><isvisible>n</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>18</id><name>Manage</name><headertext>Action</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Manage|Disable|Delete</format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>y</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Manage|Disable|Delete</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl>/Customer/CustomerEdit|/User/CustomerEnableDisableAccount|/User/CustomerDelete</manageactionurl><manageparamfield>UserId|UserId,IsLock|UserId</manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class>grid-action</Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
WHERE ItemName ='ZnodeCustomerAccount'

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_AdminUsers')
BEGIN 
	DROP PROCEDURE Znode_AdminUsers
END
GO

CREATE PROCEDURE [dbo].[Znode_AdminUsers]
(	@RoleName		VARCHAR(200),
    @UserName		VARCHAR(200),
    @WhereClause	VARCHAR(MAX)  = '',
    @Rows			INT           = 100,
    @PageNo			INT           = 1,
    @Order_By		VARCHAR(1000) = '',
    @RowCount		INT        = 0 OUT,
	@IsCallOnSite   BIT = 0 ,
	@PortalId		VARCHAR(1000) = 0 )
AS
   /* 
      Summary: List of users with detsils and shows link with ASPNet tables 
      This procedure is used for finding both users and admin users 
      here use three view "View_RoleUsers" for check  @UserName is present or not 
      "View_AdminUserDetail"  this view use for admin users 
      "View_CustomerUserDetail" Use for customer users 
      Unit Testing   
	  SELECT * FROM ZnodeUser 
      DECLARE @EDE INT=0  EXEC Znode_AdminUsers '','admin@znode.com',@WhereClause='',@Order_By='',@PageNo= 1 ,@Rows= 214,@IsCallOnSite='false',@PortalId=0,@RowCount=@EDE OUT  SELECT @EDE
   */
     BEGIN
         BEGIN TRY
            SET NOCOUNT ON;


            DECLARE @SQL NVARCHAR(MAX)= '', @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');
             
			IF @PortalId  <> '0' 
			BEGIN 
			    SET @WhereClause = CASE WHEN  @WhereClause = '' THEN ' (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' ELSE @WhereClause+' AND (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' END 
			END 
			IF EXISTS
            (
            SELECT TOP 1 1
            FROM View_RoleUsers
            WHERE Username = @UserName
            )
			-- this check for admin user
            AND @RoleName <> ''  

			BEGIN
				SET @SQL = ' 
				--;with Cte_AdminUserDetail AS 
				--(
					 
				SELECT  DISTINCT A.UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,A.CreatedBy,A.CreatedDate,A.ModifiedBy,A.ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				INTO #Cte_AdminUserDetail
				FROM View_AdminUserDetail A
				'+CASE WHEN @PortalId  <> '0' THEN ' INNER JOIN ZnodeUserPortal ZUP ON (ZUP.UserId = A.UserId) 'ELSE '' END  +'	 
				'+dbo.Fn_GetWhereClause(@WhereClause, ' WHERE ')+'
				--),
				;with Cte_AdminUserDetailRowId AS 
				(
				SELECT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId
				FROM  #Cte_AdminUserDetail
				)
					 
				SELECT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId,CustomerPaymentGUID ,RowId 
				INTO #AccountDetails
				FROM Cte_AdminUserDetailRowId 
					 
				SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetails ),0)
					 
				SELECT DISTINCT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				FROM #AccountDetails '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC' );
			    PRINT @SQL
				EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;
			END;
			-- For Customer user
            ELSE   
            BEGIN
				IF @roleName = ''
				BEGIN
				
				SET @SQL = '
				--;With Cte_CustomerUserDetail  AS 
				--(
				SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #Cte_CustomerUserDetail
				FROM View_CustomerUserAddDetail a 
				
				WHERE 
				(EXISTS   -- this will check for customer 
				(
				SELECT TOP 1 1
				FROM AspNetUserRoles AS b
				WHERE a.AspNetUserId = b.userid
				AND EXISTS
				(SELECT TOP 1 1	FROM AspNetRoles AS d	WHERE(d.Name IN(''Customer'',''Admin'')OR d.TypeOfRole = ''B2B'')	AND d.Id = b.RoleId	)  
				) OR AspNetuserId IS NULL OR '+CAST(CAST(@IsCallOnSite AS INT ) AS VARCHAR(50))+'= ''1'' ) 
				'+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+'
				--),
				;With Cte_CustomerUserDetailRowId  AS 
				(
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				FROM #Cte_CustomerUserDetail -- genrate the unique rowid 
				)
					 			 
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RowId,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #AccountDetail FROM Cte_CustomerUserDetailRowId  

				SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetail    ),0)

				
												  
				SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				FROM #AccountDetail '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC');
                PRINT @SQL    					
				EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;
				END;
            ELSE
				BEGIN
					SELECT * FROM View_CustomerUserDetail AS VICUD WHERE 1 = 0;
					SET @RowCount = 0;
				END;
            END;			
         END TRY
         BEGIN CATCH
            DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUsers @RoleName = '+@RoleName+' ,@UserName='+@UserName+',@WhereClause='+@WhereClause+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50));
            EXEC Znode_InsertProcedureErrorLog
            @ProcedureName    = 'Znode_AdminUsers',
            @ErrorInProcedure = @ERROR_PROCEDURE,
            @ErrorMessage     = @ErrorMessage,
            @ErrorLine        = @ErrorLine,
            @ErrorCall        = @ErrorCall;
         END CATCH;


     END;

	 GO
	 
IF EXISTS (SELECT * FROM sys.views where name = 'View_CustomerUserAddDetail')
	drop view View_CustomerUserAddDetail
GO
CREATE   VIEW [dbo].[View_CustomerUserAddDetail]
AS
     SELECT a.userId,
            a.AspNetuserId,
            azu.UserName,
            a.FirstName,
            a.MiddleName,
            a.LastName,
            a.PhoneNumber,
            a.Email,
            a.EmailOptIn,
            a.CreatedBy,
            CONVERT( DATE, a.CreatedDate) CreatedDate,
            A.ModifiedBy,
            CONVERT( DATE, a.ModifiedDate) ModifiedDate,
            ur.RoleId,
            r.Name RoleName,
            CASE
                WHEN B.LockoutEndDateUtc IS NULL
                THEN CAST(1 AS    BIT)
                ELSE CAST(0 AS BIT)
            END IsActive,
            CAST(CASE WHEN ISNULL(LockoutEndDateUtc, 0) = 0 THEN  0 ELSE  1 END  AS    BIT) AS IsLock,
            (ISNULL(RTRIM(LTRIM(a.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(a.MiddleName)), '')+CASE
                                                                                                  WHEN ISNULL(RTRIM(LTRIM(a.MiddleName)), '') = ''
                                                                                                  THEN ''
                                                                                                  ELSE ' '
                                                                                              END+ISNULL(RTRIM(LTRIM(a.LastName)), '')) FullName,
            e.Name AccountName,
            h.PermissionsName,
            j.DepartmentName,
            i.DepartmentId,
            a.AccountId,
            f.AccountPermissionAccessId,
            a.ExternalId,
            CASE
                WHEN a.AccountId IS NULL
                THEN 0
                ELSE 1
            END IsAccountCustomer,
            a.BudgetAmount,
            ZAUOA.AccountUserOrderApprovalId,
            (ISNULL(RTRIM(LTRIM(ZU.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '')+CASE
                                                                                                    WHEN ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '') = ''
                                                                                                    THEN ''
                                                                                                    ELSE ' '
                                                                                                END+ISNULL(RTRIM(LTRIM(ZU.LastName)), '')) ApprovalName,
            ZAUOA.ApprovalUserId,
            h.PermissionCode,
            CASE
                WHEN a.AccountId IS NULL
                THEN up.PortalId
                ELSE ZPA.PortalId
            END PortalId
			,r.TypeOfRole,CASE WHEN a.AspNetuserId IS NULL THEN 1 ELSE 0 END IsGuestUser
			,a.CustomerPaymentGUID
			,CASE WHEN zp.StoreName IS NULL THEN 'ALL' ELSE zp.StoreName END StoreName
			,
			Case when a.AccountId  is not null then ZAA.CountryName else ZA.CountryName end CountryName ,
			Case when a.AccountId  is not null then ZAA.CityName else ZA.CityName end CityName ,
			Case when a.AccountId  is not null then ZAA.StateName else ZA.StateName end StateName ,
			Case when a.AccountId  is not null then ZAA.PostalCode else ZA.PostalCode end PostalCode ,
			Case when a.AccountId  is not null then ZAA.CompanyName else ZA.CompanyName end CompanyName 
     FROM ZnodeUser a
          left JOIN ASPNetUsers B ON(a.AspNetuserId = b.Id)
          LEFT JOIN ZnodeAccount e ON(e.AccountId = a.AccountId)
          LEFT JOIN AspNetUserRoles ur ON(ur.UserId = a.AspNetUserId)
          LEFT JOIN AspNetRoles r ON(r.Id = ur.RoleId)
          LEFT JOIN ZnodeDepartmentUser i ON(i.UserId = a.UserId)
          LEFT JOIN ZnodeDepartment j ON(j.DepartmentId = i.DepartmentId)
          LEFT JOIN ZnodeAccountUserPermission f ON(f.UserId = a.UserId)
          LEFT JOIN ZnodeAccountPermissionAccess g ON(g.AccountPermissionAccessId = f.AccountPermissionAccessId)
          LEFT JOIN ZnodeAccessPermission h ON(h.AccessPermissionId = g.AccessPermissionId)
          LEFT JOIN ZnodeAccountUserOrderApproval ZAUOA ON a.UserId = ZAUOA.UserID
          LEFT JOIN ZnodeUser ZU ON(ZU.UserId = ZAUOA.ApprovalUserId)
          LEFT JOIN ZnodeUserPortal up ON(up.UserId = a.UserId)
                                          
          LEFT JOIN ZnodePortalAccount ZPA ON(ZPA.AccountId = a.AccountId)
                                
          LEFT JOIN AspNetZnodeUser azu ON(azu.AspNetZnodeUserId = b.UserName)
	      LEFT JOIN ZnodePortal zp ON (up.PortalId = zp.PortalId)
		  LEFT JOIN ZnodeAddress ZA on ZA.AddressId 
				in (Select AddressId from  ZnodeUserAddress ZUA where a.UserId = ZUA.UserId)  and ZA.IsDefaultBilling =  1
		  LEFT JOIN ZnodeAddress ZAA on ZAA.AddressId 
				in (Select AddressId from  ZnodeAccountAddress ZUAA where a.AccountId = ZUAA.AccountId) and ZAA.IsDefaultBilling = 1 
	
	  WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeUSer ZUQ WHERE ZUQ.UserId = a.UserId AND ZUQ.EmailOptIn = 1 AND ZUQ.AspNetUserId IS NULL )
	  AND a.AspNetUserId IS NOT NULL
GO

   
 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_InsertPublishProductIds')
BEGIN 
	DROP PROCEDURE Znode_InsertPublishProductIds
END
GO

CREATE  PROCEDURE [dbo].[Znode_InsertPublishProductIds]
(
	 @PublishCatalogId           INT            = NULL,
     @UserId                     INT				  ,
	 @PimProductId               TransferId Readonly,
	 @IsCallAssociated           BIT           = 0,
	 @PimCategoryHierarchyId	 INT		   = 0  ,
	 @IsDebug					 INT		   = 0     
	)
AS
    
/*
  Summary :	Publish Product on the basis of publish catalog
				Retrive all Product details with attributes and insert into following tables 
				1.	ZnodePublishedXml
				2.	ZnodePublishCategoryProduct
				3.	ZnodePublishProduct
				4.	ZnodePublishProductDetail

                Product details include all the type of products link, grouped, configure and bundel products (include addon) their associated products 
				collect their attributes and values into tables variables to process for publish.  
                
				Finally genrate XML for products with their attributes and inserted into ZnodePublishedXml Znode Admin process xml from sql server to mongodb
				one by one.

     Unit Testing
    
     SELECT * FROM ZnodePimCustomField WHERE CustomCode = 'Test'
     SELECT * FROM ZnodePimCatalogCategory WHERE pimCatalogId = 3 AND PimProductId = 181
     SELECT * FROM ZnodePimCustomFieldLocale WHERE PimCustomFieldId = 1
	 SELECT * FROM ZnodePublishProduct WHERE PublishProductid = 213 = 30
     select * from znodepublishcatalog
	 SELECT * FROM view_loadmanageProduct WHERE Attributecode = 'ProductNAme' AND AttributeValue LIKE '%Apple%'
     SELECT * FROM ZnodePimCategoryProduct WHERE  PimProductId = 181
	 SELECT * FROM ZnodePimCatalogcategory WHERE pimcatalogId = 3 
     EXEC Znode_GetPublishProducts  @PublishCatalogId = 5 ,@UserId= 2 ,@NotReturnXML= NULL,@PimProductId = 117,@IsDebug= 1 
	 	DECLARE @ttr TransferId 
	INSERT INTO @ttr  
	SELECT 25719 
     EXEC Znode_InsertPublishProductIds  @PublishCatalogId = 3,@UserId= 2  ,@PimProductId = @ttr  ,@IsDebug= 1 
     EXEC Znode_GetPublishProducts  @PublishCatalogId =1,@UserId= 2 ,@RequiredXML= 1	
	 SELECT * FROM 	ZnodePimCatalogCategory  WHERE pimcatalogId = 3  
	 SELECT * FROM [dbo].[ZnodePimCategoryHierarchy]  WHERE pimcatalogId = 3 
    */ 

     BEGIN
      --  BEGIN TRAN InsertPublishProductIds;
         BEGIN TRY
			SET NOCOUNT ON;
		
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate(); 
			 DECLARE @PimCatalogId int= ISNULL((SELECT PimCatalogId FROM ZnodePublishcatalog WHERE PublishCatalogId = @PublishCatalogId), 0);  --- this variable is used to carry y pim catalog id by using published catalog id
			 DECLARE 
			  @ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),
			  @DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),
			  @LocaleId INT = 0,
			  @SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId(), 
			  @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId(),
			  @ProductTypeAttributeId INT = dbo.Fn_GetProductTypeAttributeId()

			 DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )
			 INSERT INTO @TBL_LocaleId (LocaleId) SELECT LocaleId FROM ZnodeLocale WHERE IsActive = 1
			 
			 -- This variable used to carry the locale in loop 
			 -- This variable is used to carry the default locale which is globaly set
             DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 
			 DECLARE @DeletePublishProductId VARCHAR(MAX)= '', @PimProductIds VARCHAR(MAX)= '', @PimAttributeId VARCHAR(MAX)= '';
             DECLARE @TBL_CategoryHierarchyIds TABLE (CategoryId int,ParentCategoryId int ) 
			 DECLARE @TBL_PublishCategoryIds TABLE (PublishCategoryId  int ) 
		
			 -- This table will used to hold the all currently active locale ids  
			 
			IF Object_ID ('tempdb..#ActiveProduct') is not null
				drop table #ActiveProduct

			IF Object_ID ('tempdb..#TBL_PimProductIds') is not null
				drop table #TBL_PimProductIds

			 --this table holds all active product data
			-- CREATE TABLE #ActiveProduct ( PimProductId INT ) 
			 --
			 --INSERT INTO #ActiveProduct ( PimProductId )
				 --SELECT PAV.PimProductId FROM ZnodePimAttributeValue PAV
				 --INNER JOIN ZnodePimAttributeValueLocale PAVL ON PAV.PimAttributeValueId = PAVL.PimAttributeValueId
				 --INNER JOIN ZnodePimAttribute PA  ON PAV.PimAttributeId = PA.PimAttributeId
				 --WHERE PA.AttributeCode = 'IsActive' AND PAVL.AttributeValue = 'true'

		     -- This table hold the complete xml of product with other information like category and catalog
             CREATE TABLE #TBL_PimProductIds(PimProductId INT  ,PimCategoryId INT,PimCatalogId INT,PublishCatalogId INT,IsParentProducts BIT ,DisplayOrder INT,ProductName NVARCHAR(MAX),SKU  NVARCHAR(MAX),
											 IsActive NVARCHAR(MAX),PimAttributeFamilyId INT ,ProfileId   VARCHAR(MAX),CategoryDisplayOrder INT ,ProductIndex INT,PimCategoryHierarchyId INT ,PRIMARY KEY (PimCatalogId,PimCategoryId,PimCategoryHierarchyId,PimProductId)  )

			  -- This table is used to hold the product which publish in current process 
             DECLARE @TBL_PublishProductIds TABLE(PublishProductId  INT  ,PimProductId INT,PublishCatalogId  INT
													,PublishCategoryId VARCHAR(MAX),CategoryProfileIds VARCHAR(max),VersionId INT , PRIMARY KEY (PimProductId,PublishProductId,PublishCatalogId)); 
	 
			--Retrive category data : parent / client
			
				
			---------------
			-- this check is used when this procedure is call by internal procedure to publish only product and no need to return publish xml;    
			--Collected list of products for  publish 
       
			If @PimCategoryHierarchyId = 0 
			Begin

				INSERT INTO #TBL_PimProductIds ( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId,CategoryDisplayOrder,PublishCatalogId,PimCategoryHierarchyId )
				SELECT DISTINCT ZPCC.PimProductId, ZPCC.PimCategoryId, 1 AS IsParentProducts, NULL AS DisplayOrder, ZPCC.PimCatalogId,ZPCC.DisplayOrder ,ZPC.PublishCatalogId,ISNULL(ZPCC.PimCategoryHierarchyId,0)
				FROM ZnodePimCatalogCategory AS ZPCC
				INNER JOIN ZnodePublishCatalog ZPC ON ZPC.PimCatalogId = ZPCC.PimCatalogId
		    	WHERE  (ZPCC.PimCatalogId = @PimCatalogId OR EXISTS( SELECT TOP 1 1 FROM @PimProductId SP WHERE SP.Id = ZPCC.PimProductId) ) AND ZPCC.PimProductId IS NOT NULL
				--AND EXISTS ( SELECT * FROM #ActiveProduct PAV WHERE ZPCC.PimProductId = PAV.PimProductId )

			END
			ELSE
			BEGIN
				
				INSERT INTO @TBL_CategoryHierarchyIds(CategoryId , ParentCategoryId )
				Select Distinct PimCategoryId , Null FROM (
				SELECT PimCategoryId,ParentPimCategoryId from DBO.[Fn_GetRecurciveCategoryIds](@PimCategoryHierarchyId,@PimCatalogId)
				Union 
				Select PimCategoryId , null  from ZnodePimCategoryHierarchy where PimCategoryHierarchyId = @PimCategoryHierarchyId 
				Union 
				Select PimCategoryId , null  from [Fn_GetRecurciveCategoryIds_new] (@PimCategoryHierarchyId,@PimCatalogId) ) Category  


				INSERT INTO  @TBL_PublishCategoryIds 
				select ZPC.PublishCategoryId from ZnodePublishCategory ZPC 
				Inner join  @TBL_CategoryHierarchyIds CT1 On 
				ZPC.PimCategoryId = CT1.CategoryId 
			
			
				INSERT INTO #TBL_PimProductIds ( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId,CategoryDisplayOrder,PublishCatalogId,PimCategoryHierarchyId )
				SELECT DISTINCT ZPCC.PimProductId, ZPCC.PimCategoryId, 1 AS IsParentProducts, NULL AS DisplayOrder, ZPCC.PimCatalogId,ZPCC.DisplayOrder ,ZPC.PublishCatalogId,ISNULL(ZPCC.PimCategoryHierarchyId,0)
				FROM ZnodePimCatalogCategory AS ZPCC
				INNER JOIN ZnodePublishCatalog ZPC ON ZPC.PimCatalogId = ZPCC.PimCatalogId
		    	WHERE  (ZPCC.PimCatalogId = @PimCatalogId OR EXISTS( SELECT TOP 1 1 FROM @PimProductId SP WHERE SP.Id = ZPCC.PimProductId) ) AND ZPCC.PimProductId IS NOT NULL
				--AND EXISTS ( SELECT * FROM #ActiveProduct PAV WHERE ZPCC.PimProductId = PAV.PimProductId )
				AND (
						ZPCC.PimCategoryId in 
							(
								Select CategoryId from @TBL_CategoryHierarchyIds
							) 
					) 



				SELECT ZPCP.PublishCatalogId,THO.PimProductId,PimCategoryHierarchyId,ProductIndex
				INTO #TBL_PublishCategoryProduct 
				FROM ZnodePublishCategoryProduct ZPCP 
				INNER JOIN ZnodePublishProduct THO ON (THO.PublishProductId = ZPCP.PublishProductId  AND ZPCP.PublishCatalogId = THO.PublishCatalogId)
				WHERE ZPCP.PublishCatalogId = @PublishCatalogId
				AND EXISTS (SELECT TOP 1 1 FROM #TBL_PimProductIds TYU WHERE TYU.PimProductId  =  THO.PimProductId )


				

UPDATE  #TBL_PimProductIds 
SET ProductIndex = CASE WHEN EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCategoryProduct TH WHERE TH.PimProductId = #TBL_PimProductIds.PimProductId 
	AND #TBL_PimProductIds.PimCategoryHierarchyId = TH.PimCategoryHierarchyId  ) THEN (SELECT TOP  1 ProductIndex FROM #TBL_PublishCategoryProduct TM WHERE TM.PimProductId = #TBL_PimProductIds.PimProductId 
	AND #TBL_PimProductIds.PimCategoryHierarchyId = TM.PimCategoryHierarchyId  )

	WHEN EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCategoryProduct TH WHERE TH.PimProductId = #TBL_PimProductIds.PimProductId 
	AND #TBL_PimProductIds.PimCategoryHierarchyId <> TH.PimCategoryHierarchyId  )  
	THEN (SELECT TOP  1 MAX(isnull(ProductIndex,0))+1  FROM #TBL_PublishCategoryProduct TM1 WHERE TM1.PimProductId = #TBL_PimProductIds.PimProductId 
	)

				  ELSE  1 END 


					
			END
						
             --Collected list of link products for  publish
			 INSERT INTO #TBL_PimProductIds( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId , PublishCatalogId,PimCategoryHierarchyId)
				 SELECT ZPLPD.PimProductId, ZPCC.PimCategoryId, 0 AS IsParentProducts, NULL AS DisplayOrder, CTPP.PimCatalogId,CTPP.PublishCatalogId,isnull(ZPCC.PimCategoryHierarchyId,0)
				 FROM ZnodePimLinkProductDetail AS ZPLPD
				 INNER JOIN #TBL_PimProductIds AS CTPP ON ZPLPD.PimParentProductId = CTPP.PimProductId AND  IsParentProducts = 1 
				 INNER JOIN ZnodePimCatalogCategory AS ZPCC ON ZPCC.PimProductId = ZPLPD.PimProductId AND ZPCC.PimCatalogId = CTPP.PimCatalogId
				 WHERE NOT EXISTS ( SELECT TOP 1 1 FROM #TBL_PimProductIds AS CTPPI WHERE CTPPI.PimProductId = ZPLPD.PimProductId) 
				-- AND EXISTS ( SELECT TOP 1 1 FROM ZnodePimAttributeValue AS VILMP WHERE VILMP.PimProductId = ZPLPD.PimProductId ) 
				 AND ZPCC.PimProductId IS NOT NULL
				-- AND EXISTS (SELECT * FROM #ActiveProduct PAV WHERE ZPLPD.PimProductId = PAV.PimProductId )
				 GROUP BY ZPLPD.PimProductId, ZPCC.PimCategoryId,CTPP.PimCatalogId,CTPP.PublishCatalogId ,ZPCC.PimCategoryHierarchyId

				
             --Collected list of Addon products for  publish
  
		     INSERT INTO #TBL_PimProductIds( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId,PublishCatalogId,PimCategoryHierarchyId)
					 SELECT ZPAPD.PimChildProductId, ISNULL(ZPCC.PimCategoryId,0) AS PublishCategoryId, 0 AS IsParentProducts, null AS DisplayOrder,CTALP.PimCatalogId,CTALP.PublishCatalogId,ISNULL(ZPCC.PimCategoryHierarchyId,0)
					 FROM ZnodePimAddOnProductDetail AS ZPAPD 
					 INNER JOIN ZnodePimAddOnProduct AS ZPAP ON ZPAP.PimAddOnProductId = ZPAPD.PimAddOnProductId
					 INNER JOIN #TBL_PimProductIds AS CTALP ON CTALP.PimProductId = ZPAP.PimProductId AND  IsParentProducts = 1
					 LEFT JOIN ZnodePimCatalogCategory AS ZPCC ON ZPCC.PimProductId = ZPAPD.PimChildProductId AND ZPCC.PimCatalogId = CTALP.PimCatalogId
					 WHERE NOT EXISTS (SELECT TOP 1 1 FROM #TBL_PimProductIds AS CTALPI WHERE CTALPI.PimProductId = ZPAPD.PimChildProductId) 
				---	 AND EXISTS(SELECT TOP 1 1FROM ZnodePimAttributeValue AS VILMP WHERE VILMP.PimProductId = ZPAPD.PimChildProductId) 
					-- AND EXISTS ( SELECT * FROM #ActiveProduct PAV WHERE ZPAPD.PimChildProductId = PAV.PimProductId ) 
					 GROUP BY ZPAPD.PimChildProductId, ZPCC.PimCategoryId , CTALP.PimCatalogId,CTALP.PublishCatalogId,ZPCC.PimCategoryHierarchyId

					 				 	

             --Collected list of Bundle / Group / Config products for  publish
             INSERT INTO #TBL_PimProductIds(PimProductId,PimCategoryId,IsParentProducts,DisplayOrder,PimCatalogId,PublishCatalogId,PimCategoryHierarchyId)
                    SELECT ZPTA.PimProductId,ISNULL(ZPCC.PimCategoryId,0),0 AS IsParentProducts,NULL DisplayOrder,CTAAP.PimCatalogId,CTAAP.PublishCatalogId,ISNULL(ZPCC.PimCategoryHierarchyId,0)
                    FROM ZnodePimProductTypeAssociation AS ZPTA INNER JOIN #TBL_PimProductIds AS CTAAP ON CTAAP.PimProductId = ZPTA.PimParentProductId AND IsParentProducts = 1
                    LEFT JOIN ZnodePimCatalogCategory AS ZPCC ON ZPCC.PimProductId = ZPTA.PimProductId AND ZPCC.PimCatalogId = CTAAP.PimCatalogId
                    WHERE NOT EXISTS( SELECT TOP 1 1 FROM #TBL_PimProductIds AS CTAAPI WHERE CTAAPI.PimProductId = ZPTA.PimProductId)
					--AND EXISTS(SELECT TOP 1 1 FROM ZnodePimAttributeValue AS VILMP WHERE VILMP.PimProductId = ZPTA.PimProductId)
					--AND EXISTS ( SELECT * FROM #ActiveProduct PAV WHERE ZPTA.PimProductId = PAV.PimProductId ) 
					GROUP BY ZPTA.PimProductId,ZPCC.PimCategoryId,CTAAP.PimCatalogId,CTAAP.PublishCatalogId,ZPCC.PimCategoryHierarchyId
        				

			   UPDATE TBPP
               SET PublishCatalogId = ZPC.PublishCatalogId 
			   FROM #TBL_PimProductIds TBPP 
			   INNER JOIN ZnodePublishCatalog ZPC ON ZpC.PimCatalogId = TBPP.PimCatalogId;
        
		DECLARE @PublishProductId TRANSFERId 

		
		IF @PublishCatalogId IS NOT NULL AND @PublishCatalogId <> 0 
			BEGIN
			If @PimCategoryHierarchyId = 0 
			BEGIN
			  -- SELECT * FROM @TBL_PimProductIds AS TBP
				INSERT INTO @PublishProductId
				SELECT DISTINCT ZPP.PublishProductId 
				FROM ZnodePublishProduct AS ZPP 
				INNER JOIN ZnodePublishCategoryProduct ZPPC ON (ZPPC.PublishProductId = ZPP.PublishProductId AND ZPPC.PublishCatalogId = ZPP.PublishCatalogId)
				--INNER JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCategoryId = ZPPC.PublishCategoryId)
				WHERE NOT EXISTS
				(SELECT TOP 1 1 FROM #TBL_PimProductIds AS TBP WHERE ZPP.PimProductId = TBP.PimProductId 
				AND TBP.PublishCatalogId = ZPP.PublishCatalogId 
				AND ISNULL(TBP.PimCategoryHierarchyId,0) = ISNULL(ZPPC.PimCategoryHierarchyId,0) )
				AND ZPP.PublishCatalogId = @PublishCatalogId
				--Remove extra products from catalog
			END
			ELSE 
			BEGIN
				INSERT INTO @PublishProductId
				SELECT DISTINCT ZPP.PublishProductId 
				FROM ZnodePublishProduct AS ZPP 
				INNER JOIN ZnodePublishCategoryProduct ZPPC ON (ZPPC.PublishProductId = ZPP.PublishProductId AND ZPPC.PublishCatalogId = ZPP.PublishCatalogId)
				INNER JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCatalogId = ZPPC.PublishCatalogId  AND   ZPC.PublishCategoryId = ZPPC.PublishCategoryId)
				WHERE NOT EXISTS
				(SELECT TOP 1 1 FROM #TBL_PimProductIds AS TBP WHERE ZPP.PimProductId = TBP.PimProductId 
				AND TBP.PublishCatalogId = ZPP.PublishCatalogId 
				AND ISNULL(TBP.PimCategoryHierarchyId,0) = ISNULL(ZPPC.PimCategoryHierarchyId,0))
				AND ZPP.PublishCatalogId = @PublishCatalogId
				AND ZPC.PimCategoryId  in 
				(
					Select CategoryId from @TBL_CategoryHierarchyIds
				)
			
			   


			END
		END
		ELSE IF @IsCallAssociated = 0 
		BEGIN 
			DECLARE @TBL_ProductIdscollect TABLE(PublishProductId INT , PimproductId INT , PublishcatalogId  INT  , ProductType NVARCHAr(max))
			If @PimCategoryHierarchyId = 0 
			Begin
				INSERT INTO @TBL_ProductIdscollect (PublishProductId,PimproductId,PublishcatalogId,ProductType)
				SELECT PublishProductId,ZPAV.PimproductId,TBPOCI.PublishcatalogId,ZPATF.AttributeDefaultValueCode
				FROM ZnodePimAttributeValue ZPAV 
				INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId )
				INNER JOIN #TBL_PimProductIds TBLIDF ON (TBLIDF.PimProductId = ZPAV.PimProductId )
				INNER JOIN ZnodePublishProduct TBPOCI ON (TBPOCI.PimProductId = TBLIDF.PimProductId AND TBPOCI.PublishCatalogId = TBLIDF.PublishCatalogId 	)
				INNER JOIN ZnodePimAttributeDefaultValue ZPATF ON (ZPATF.PimAttributeId =  @ProductTypeAttributeId 
								AND ZPADV.PimAttributeDefaultValueId = ZPATF.PimAttributeDefaultValueId )
				 WHERE  IsParentProducts = 1	
				 AND LocaleId =@DefaultLocaleId
			END 
			Else 
			Begin
				INSERT INTO @TBL_ProductIdscollect (PublishProductId,PimproductId,PublishcatalogId,ProductType)
				SELECT TBPOCI.PublishProductId,ZPAV.PimproductId,TBPOCI.PublishcatalogId,ZPATF.AttributeDefaultValueCode
				FROM ZnodePimAttributeValue ZPAV 
				INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId )
				INNER JOIN #TBL_PimProductIds TBLIDF ON (TBLIDF.PimProductId = ZPAV.PimProductId )
				INNER JOIN ZnodePublishProduct TBPOCI ON (TBPOCI.PimProductId = TBLIDF.PimProductId AND TBPOCI.PublishCatalogId = TBLIDF.PublishCatalogId 	)
				INNER JOIN ZnodePimAttributeDefaultValue ZPATF ON (ZPATF.PimAttributeId =  @ProductTypeAttributeId 
								AND ZPADV.PimAttributeDefaultValueId = ZPATF.PimAttributeDefaultValueId )
				INNER JOIN ZnodePublishCategoryProduct  ZPCP ON ZPCP.PublishCatalogId = TBPOCI.PublishCatalogId AND 
				ZPCP.PublishProductId = TBPOCI.PublishProductId
				INNER JOIN ZnodePublishCategory ZPC ON  (ZPC.PublishCatalogId = ZPCP.PublishCatalogId  AND ZPC.PublishCategoryId = ZPCP.PublishCategoryId)
				 WHERE  IsParentProducts = 1	AND LocaleId =@DefaultLocaleId
				 AND ZPC.PimCategoryId  in 
				(
					Select CategoryId from @TBL_CategoryHierarchyIds
				
				) 
			END 

			IF EXISTS (SELECT TOP 1 1 FROM @TBL_ProductIdscollect WHERE ProductType IN ('GroupedProduct','BundleProduct','ConfigurableProduct','SimpleProduct') )
		 
			BEGIN 
	
			   DECLARE @TBL_DeleteTrackProduct TABLE (PublishProductId INT,AssociatedZnodeProductId INT  ,PublishCatalogId INT,PublishCatalogLogId INT ,IsDelete BIT , PublishCategoryId int  )

			   ;With Cte_PublishProduct AS
			   (
				 SELECT TBL.PublishProductId,PimproductId,TBL.PublishcatalogId,ProductType ,MAx(PublishCatalogLogId) PublishCatalogLogId
				 FROM  @TBL_ProductIdscollect TBL 
				 INNER JOIN ZnodePublishCatalogLog TBLG ON (TBLG.PublishCatalogId = TBL.PublishcatalogId)
				 WHERE IsCatalogPublished = 1 
				 GROUP BY TBL.PublishProductId,PimproductId,TBL.PublishcatalogId,ProductType

			   )
			   , Cte_ConfigData AS 
				 (
				 SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
				 FROM ZnodePublishedXml ZPXML 
				 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
				 CROSS APPLY ZPXML.PublishedXML.nodes('/ConfigurableProductEntity') t(p)
				 WHERE  IsConfigProductXML = 1 and 
				 (ZPXML.PublishCategoryId in (Select PublishCategoryId from @TBL_PublishCategoryIds) OR @PimCategoryHierarchyId = 0 ) 
				 AND ProductType = 'ConfigurableProduct'
				 UNION ALL 
				  SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
				 FROM ZnodePublishedXml ZPXML 
				 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
				 CROSS APPLY ZPXML.PublishedXML.nodes('/GroupProductEntity') t(p)
				 WHERE  IsGroupProductXML = 1 and 
				 (ZPXML.PublishCategoryId in (Select PublishCategoryId from @TBL_PublishCategoryIds) OR @PimCategoryHierarchyId = 0 ) 
				 AND ProductType = 'GroupedProduct'
				 UNION ALL 
				  SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
				 FROM ZnodePublishedXml ZPXML 
				 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
				 CROSS APPLY ZPXML.PublishedXML.nodes('/BundleProductEntity') t(p)
				 WHERE  IsBundleProductXML = 1 and 
				 (ZPXML.PublishCategoryId in (Select PublishCategoryId from @TBL_PublishCategoryIds) OR @PimCategoryHierarchyId = 0 ) 
				 AND ProductType = 'BundleProduct'
				 UNION ALL 
				 SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
				 FROM ZnodePublishedXml ZPXML 
				 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
				 CROSS APPLY ZPXML.PublishedXML.nodes('/AddonEntity') t(p)
				 WHERE  IsAddOnXML = 1 and 
				 (ZPXML.PublishCategoryId in (Select PublishCategoryId from @TBL_PublishCategoryIds) OR @PimCategoryHierarchyId = 0 ) 
				 AND LocaleId = @DefaultLocaleId 
			
				 )

			--	 SELECT * FROM ZnodePublishCatalogLog WHERE PublishCatalogId = 8 

			INSERT INTO @TBL_DeleteTrackProduct (PublishProductId,AssociatedZnodeProductId,PublishcatalogId,PublishCatalogLogId)
			SELECT ZPP.PublishProductId,AssociatedZnodeProductId,PublishcatalogId,PublishCatalogLogId 
			FROM Cte_ConfigData ZPP	
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM  @TBL_PublishProductIds TBLP WHERE TBLP.PublishProductId = ZPP.AssociatedZnodeProductId)
		
	

			;With Cte_updateStatus AS
			(
		 
				 SELECT  PublishProductId,PublishcatalogId
				  FROM @TBL_DeleteTrackProduct CTR 
				 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
				 CROSS APPLY ZPXML.PublishedXML.nodes('/ConfigurableProductEntity') t(p)
				 WHERE  IsConfigProductXML = 1 
				 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
				 AND LocaleId = @DefaultLocaleId 
				 AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
				 AND CTR.PublishProductId = ZPXML.PublishedId ) 

				 UNION ALL 
				  SELECT PublishProductId,PublishcatalogId
				 FROM @TBL_DeleteTrackProduct CTR 
				 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
				 CROSS APPLY ZPXML.PublishedXML.nodes('/GroupProductEntity') t(p)
				 WHERE  IsGroupProductXML = 1 
				 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
				 AND LocaleId = @DefaultLocaleId 
				 AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
				 AND CTR.PublishProductId = ZPXML.PublishedId ) 

				 UNION ALL 
				  SELECT  PublishProductId,PublishcatalogId
				   FROM @TBL_DeleteTrackProduct CTR 
				 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
				 CROSS APPLY ZPXML.PublishedXML.nodes('/BundleProductEntity') t(p)
				 WHERE  IsBundleProductXML = 1 
				 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
				 AND LocaleId = @DefaultLocaleId 
				 AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
				 AND CTR.PublishProductId = ZPXML.PublishedId ) 


				 UNION ALL 
				 SELECT PublishProductId,PublishcatalogId
				 FROM @TBL_DeleteTrackProduct CTR 
				 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
				 CROSS APPLY ZPXML.PublishedXML.nodes('/AddonEntity') t(p)
				 WHERE  IsAddOnXML = 1 
				 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
				 AND LocaleId = @DefaultLocaleId 
				 AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
				 AND CTR.PublishProductId = ZPXML.PublishedId ) 
		
			)

			UPDATE a 
			SET IsDelete = CASE WHEN TYR.PublishProductId IS NULL THEN 1 ELSE 0 END 
			FROM @TBL_DeleteTrackProduct a 
			LEFT JOIN Cte_updateStatus TYR ON (TYR.PublishProductId = a.PublishProductId AND TYR.PublishCatalogId = a.PublishCatalogId)

		
			INSERT INTO @PublishProductId 
			SELECT DISTINCT AssociatedZnodeProductId 
			FROM @TBL_DeleteTrackProduct
			WHERE IsDelete =1  
		--	AND 1=0

		END 

	
		INSERT INTO @PublishProductId
		SELECT distinct PublishProductid
		FROM ZnodePublishProduct ZPP
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId =  ZPP.PublishCatalogId )
        WHERE Not EXISTS (SELECT TOP 1 1 FROM ZnodePimCatalogCategory ZPPP WHERE (ZPPP.PimCatalogid = ZPc.PimCatalogId AND ZPPP.PimProductId = ZPP.PimProductId))  
		AND EXISTS (SELECT TOP 1 1 FROM #TBL_PimProductIds TYR WHERE TYR.PimProductId = ZPP.PimProductId )
		AND NOT EXISTS (SELECT TOP 1 1 FROM @PublishProductId YTR WHERE YTR.Id = ZPP.PublishProductId  )
		--AND  1=0	
		END  
	
		EXEC dbo.Znode_DeletePublishCatalogProduct  @PublishProductIds = @PublishProductId,@PublishCatalogId = @PublishCatalogId ,
		@PimCategoryHierarchyId  =@PimCategoryHierarchyId  ,
		@PimCatalogId  = @PimCatalogId 

			   IF  @IsDebug = 1 
			   BEGIN 
			SELECT * FROM #TBL_PimProductIds
			 END 
			 -- This merge statement is used for crude oprtaion with publisgh product table
			MERGE INTO ZnodePublishProduct TARGET USING  (
				SELECT PimProductId, PublishCatalogId
				FROM #TBL_PimProductIds AS TBP
				GROUP BY PimProductId, PublishCatalogId
			 )  SOURCE
				ON --check for if already exists then just update otherwise insert the product  
				TARGET.PimProductId = SOURCE.PimProductId AND  TARGET.PublishCatalogId = SOURCE.PublishCataLogId 
				WHEN MATCHED      THEN UPDATE SET TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate	
				WHEN NOT MATCHED  THEN INSERT(PimProductId, PublishCatalogId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
									   VALUES( SOURCE.PimProductId, SOURCE.PublishCatalogId, @UserId, @GetDate, @UserId, @GetDate )
				OUTPUT INSERTED.PublishProductId, INSERTED.PimProductId, INSERTED.PublishCatalogId
				INTO @TBL_PublishProductIds(PublishProductId, PimProductId, PublishCatalogId); 
			
			-- Here used the ouput clause to catch what data inserted or updated into variable table
	    	
	

	          SELECT PublishProductId,
				 ISNULL(ZPC.PublishCategoryId,0)PublishCategoryId,
				 TBP.PublishCatalogId,ZPC.PimCategoryHierarchyId,CASE WHEN ISNULL(@PimCategoryHierarchyId,0) <> 0  THEN TBP.ProductIndex ELSE     ROW_NUMBER()Over(Partition BY TBPP.PublishProductId Order BY ISNULL(ZPC.PublishCategoryId,0)) END  ProductIndex
				 INTO #TB_CategoryProduct 
				 FROM #TBL_PimProductIds AS TBP 
				 LEFT JOIN ZnodePublishCategory AS ZPC ON (ISNULL(TBP.PimCategoryId, 0) = ISNULL(ZPC.PimCategoryId, -1) AND ZPC.PublishCatalogId = TBP.PublishCatalogId 
				 AND ISNULL(ZPC.PimCategoryHierarchyId, 0) = ISNULL(TBP.PimCategoryHierarchyId, -1))
				 INNER JOIN @TBL_PublishProductIds AS TBPP ON TBP.PimProductId = TBPP.PimProductId
				 AND TBP.PublishCatalogId = TBPP.PublishCatalogId
				 GROUP BY PublishProductId, ZPC.PublishCategoryId, TBP.PublishCatalogId,ZPC.PimCategoryHierarchyId,TBP.ProductIndex
		
			
			-- This merge staetment is used for crude opration with  ZnodePublishCategoryProduct table
			 MERGE INTO ZnodePublishCategoryProduct TARGET 
			 USING  #TB_Categoryproduct SOURCE
					ON  TARGET.PublishCatalogId = SOURCE.PublishCatalogId AND ISNULL(TARGET.PublishCategoryId, 0) = ISNULL(SOURCE.PublishCategoryId, 0) AND TARGET.PublishProductId = SOURCE.PublishProductId 
					
					WHEN MATCHED THEN UPDATE SET TARGET.PublishCategoryId = CASE WHEN SOURCE.PublishCategoryId = 0 THEN NULL ELSE SOURCE.PublishCategoryId END 
												 ,TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate,TARGET.PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId				
												 ,ProductIndex = case when Source.ProductIndex is null then 1 else  Source.ProductIndex end
					WHEN NOT MATCHED THEN INSERT(PublishProductId,PublishCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PimCategoryHierarchyId,ProductIndex) 
										  VALUES(SOURCE.PublishProductId,CASE WHEN SOURCE.PublishCategoryId =0 THEN NULL ELSE SOURCE.PublishCategoryId  END , SOURCE.PublishCatalogId,@UserId,@GetDate,@userId,@GetDate,SOURCE.PimCategoryHierarchyId,case when Source.ProductIndex is null then 1 else  Source.ProductIndex end);
   
    
   WHILE @Counter <= @maxCountId
   BEGIN 
    SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId WHERE RowId = @Counter)
   
     
	 SELECT VIR.PimProductId,PimAttributeId,AttributeValue,ZnodePimAttributeValueLocaleId,VIR.LocaleId ,COUNT(*)Over(Partition By VIR.PimProductId,PimAttributeId ORDER BY VIR.PimProductId,PimAttributeId  ) RowId
	 INTO #TBL_AttributeVAlue
	 FROM View_LoadManageProductInternal VIR
	 WHERE (LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId )
	 AND EXISTS (SELECT TOP 1 1 FROM @TBL_PublishProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
	 AND (PimAttributeId = @ProductNamePimAttributeId  OR PimAttributeId = @SKUPimAttributeId OR PimAttributeId = @IsActivePimAttributeId  )
  
   

		
	          MERGE INTO ZnodePublishProductDetail   TARGET
			  USING  (SELECT   ZPP.PublishProductId ,TBLA.AttributeValue PRoductName,TBLAI.AttributeValue SKU ,ISNULL(TBLAII.AttributeValue,'0') IsActive --,TBLAIII.AttributeValue ProductType
						FROM  @TBL_PublishProductIds zpp
						INNER JOIN #TBL_AttributeVAlue TBLA ON (TBLA.PimAttributeId = @ProductNamePimAttributeId AND TBLA.PimProductId = ZPP.PimProductId AND TBLA.LocaleId  = CASE WHEN TBLA.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
					--	INNER JOIN @TBL_AttributeVAlue  TBLA ON (TBLA.PimProductId = ZPP.PimProductId AND TBLA.PimAttributeId = @ProductNamePimAttributeId)
					    INNER JOIN #TBL_AttributeVAlue TBLAI ON (TBLAI.PimAttributeId = @SKUPimAttributeId AND TBLAI.PimProductId = ZPP.PimProductId AND TBLAI.LocaleId  = CASE WHEN TBLAI.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
					--	INNER JOIN @TBL_AttributeVAlue  TBLAI ON (TBLAI.PimProductId = ZPP.PimProductId AND TBLAI.PimAttributeId = @SKUPimAttributeId)
					    INNER JOIN #TBL_AttributeVAlue TBLAII ON (TBLAII.PimAttributeId = @IsActivePimAttributeId AND TBLAII.PimProductId = ZPP.PimProductId AND TBLAII.LocaleId  = CASE WHEN TBLAII.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
						--INNER JOIN #TBL_AttributeVAlue TBLAIII ON (TBLAIII.PimAttributeId = @ProductTypePimAttributeId AND TBLAIII.PimProductId = ZPP.PimProductId AND TBLAIII.LocaleId  = CASE WHEN TBLAIII.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
					--	INNER JOIN @TBL_AttributeVAlue  TBLAIII ON (TBLAII.PimProductId = ZPP.PimProductId AND TBLAII.PimAttributeId = @ProductTypeAttributeId)
						GROUP BY ZPP.PublishProductId,TBLA.AttributeValue,TBLAI.AttributeValue,TBLAII.AttributeValue --,TBLAIII.AttributeValue
						)   SOURCE
			ON (TARGET.PublishProductId = SOURCE.PublishProductId
				 AND TARGET.LocaleId = @LocaleId 
			) 
			WHEN MATCHED THEN 
			UPDATE 
			SET TARGET.ProductName   = SOURCE.ProductName
				,TARGET.SKU			 = SOURCE.SKU
				,TARGET.IsActive	= SOURCE.IsActive
				,TARGET.ModifiedBy	 = @userid
				,TARGET.ModifiedDate  = @GetDate
			WHEN NOT MATCHED THEN 
			INSERT (PublishProductId
					,ProductName
					,SKU
					,IsActive
					,LocaleId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate)
			VALUES ( SOURCE.PublishProductId
					,SOURCE.ProductName
					,SOURCE.SKU
					,SOURCE.IsActive
					,@LocaleId
					,@userId
					,@GetDate
					,@userId
					,@GetDate);

		 
         DROP TABLE #TBL_AttributeVAlue 
		
		 SET @Counter = @counter + 1 
			  END 

		IF @PublishCatalogId IS NULL OR @PublishCatalogId =0 
		BEGIN 
			SELECT PublishProductId, PimProductId, PublishCatalogId 
			FROM @TBL_PublishProductIds
		END 
		IF (ISnull(@PimCategoryHierarchyId ,0) <> 0 ) 
		Begin
			SELECT PublishProductId, PimProductId, PublishCatalogId 
			FROM @TBL_PublishProductIds
		End 

		--COMMIT TRAN InsertPublishProductIds;
		END TRY 
		BEGIN CATCH 
		 SELECT ERROR_MESSAGE()
            UPDATE ZnodePublishCatalogLog 
			SET IsCatalogPublished = 0 
			,IscategoryPublished = 0 
			,IsProductPublished = 0 
			,PublishStateId = 1 
		    WHERE PublishCatalogLogId IN (SELECT Max(PublishCatalogLogId) FROM ZnodePublishCatalogLog WHERE PublishCatalogId = @PublishCatalogId  GROUP BY PublishStateId , PublishCatalogId )
		END CATCH 
	END

	GO

		
if not exists(select * from sys.indexes where name = 'idx_ZnodePublishCatalogLog_PublishCatalogId_LocaleId')
begin
	CREATE INDEX idx_ZnodePublishCatalogLog_PublishCatalogId_LocaleId on ZnodePublishCatalogLog(PublishCatalogId,LocaleId)
end

go

if exists (select * from sys.procedures where name = 'Znode_GetPublishAssociatedProducts')
	drop proc Znode_GetPublishAssociatedProducts
go
CREATE PROCEDURE [dbo].[Znode_GetPublishAssociatedProducts]
(   
	@PublishCatalogId VARCHAR(MAX) = '',
    @PimProductId     TransferId Readonly,
    @ProductType      VARCHAR(300) = 'BundleProduct',
    @VersionId        INT          = 0,
    @UserId           INT,
	@PimCategoryHierarchyId int = 0,
	@PublishStateId INT = 0  
)
AS
  /*
    Summary : If PimcatalogId is provided then get all  Bundles / Group / Configurable product and  provide above mentioned data
              If PimProductId is provided then get all Bundles / Group / Configurable if associated with given product id and provide above mentioned data
    		 Input: @PublishCatalogId or @PimProductId
    		 Output should be in XML format
             Required o/p
    			<BundleProductEntity>
    			<ZnodeProductId></ZnodeProductId>
    			<ZnodeCatalogId></ZnodeCatalogId>
    			<AsscociadedZnodeProductIds></AsscociadedZnodeProductIds>
    			</BundleProductEntity>
    Unit Testing 
    BundleProduct
	DECLARE 
    EXEC [dbo].[Znode_GetPublishAssociatedProducts] @PublishCatalogId = 1  , @ProductType = 'BundleProduct' ,@userId = 2 
    EXEC [dbo].[Znode_GetPublishAssociatedProducts] @PublishCatalogId =2 , @ProductType = 'ConfigurableProduct',@userId = 2 ,@PimCategoryHierarchyId = 7 
    Group Product
    EXEC [dbo].[Znode_GetPublishAssociatedProducts]  @PublishCatalogId ='2',@PimProductIdh =''  , @PimProducttType = 'GroupedProduct'
    EXEC [dbo].[Znode_GetPublishAssociatedProducts]  @PublishCatalogId ='',@PimProductId ='200066'  , @PimProducttType = 'GroupedProduct'
    EXEC [dbo].[Znode_GetPublishAssociatedProducts] @PimProductId ='200066'  , @PimProducttType = 'GroupedProduct'
   */
     BEGIN
         BEGIN TRAN GetPublishAssociatedProducts;
         BEGIN TRY
             SET NOCOUNT ON;
			 
			 IF OBJECT_ID('tempdb..#TBL_PublishCatalogId') is not null
				DROP TABLE #TBL_PublishCatalogId
			
			  CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT , VersionId INT,LocaleId INT  );
			  DECLARE @PimAttributeId INT = [dbo].[Fn_GetProductTypeAttributeId]()
					  ,@PimAttributeDefaultValueId INT = (SELECT TOP 1 PimAttributeDefaultValueId FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = @ProductType)
					,@DefaultLocaleId INT = dbo.fn_getDefaultlocaleId() 
			 DECLARE @GetDate DATETIME =dbo.Fn_GetDate()
			 
			 DECLARE @TBL_PublisshIds TABLE (PublishProductId INT , PimProductId INT , PublishCatalogId INT)
			 DECLARE  @PimProductId_New TransferId
					 
			 IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			 BEGIN 
			   INSERT INTO @TBL_PublisshIds 
			   EXEC [dbo].[Znode_InsertPublishProductIds] @PublishCatalogId,@userid,@PimProductId,1
			   
			   --SET @PimProductId = SUBSTRING((SELECT DISTINCT ','+CAST(PimProductId AS VARCHAr(50)) FROM @TBL_PublisshIds FOR XML PATH ('')),2,8000 )

			   INSERT INTO @PimProductId_New
			   SELECT DISTINCT PimProductId FROM @TBL_PublisshIds

			  -- SELECT 	@PimProductId	
			 END 
			 
			 IF  ISnull(@PimCategoryHierarchyId,0) <> 0 
			 BEGIN 
			 
			   INSERT INTO @TBL_PublisshIds 
			   EXEC [dbo].[Znode_InsertPublishProductIds] @PublishCatalogId,@userid,@PimProductId,1,@PimCategoryHierarchyId
			   
			   --SET @PimProductId = SUBSTRING((SELECT DISTINCT ','+CAST(PimProductId AS VARCHAr(50)) FROM @TBL_PublisshIds FOR XML PATH ('')),2,8000 )

			   INSERT INTO @PimProductId_New
			   SELECT PimProductId FROM @TBL_PublisshIds

			   
			 END 

			

			 IF  ISnull(@PimCategoryHierarchyId,0) <> 0 
			 BEGIN 
				 INSERT INTO #TBL_PublishCatalogId 
				 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,MAX(PublishCatalogLogId) ,ZPCP.LocaleID  
				 FROM ZnodePublishProduct ZPP 
				 INNER JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = ZPP.PimProductId )
				 INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPV.PimAttributeValueId)
				 LEFT JOIN  ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
				 WHERE (EXISTS (SELECT TOP 1 1 FROM @TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId   ) 
				 AND  (ZPP.PublishCatalogId =  @PublishCatalogId ))
				 AND ZPV.PimAttributeId  = @PimAttributeId
				 AND ZPAVL.PimAttributeDefaultValueId= @PimAttributeDefaultValueId
				 AND ZPAVL.LocaleId = @DefaultLocaleId
				 AND ISNULL(ZPCP.LocaleId,0) <> 0 
				 AND ZPCP.PublishStateId= @PublishStateId
				 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,ZPCP.LocaleID 
					
			 END
			 ELSE 
			 BEGIN 
			 
				IF NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0
				BEGIN
					 INSERT INTO #TBL_PublishCatalogId 
					 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,  MAX(PublishCatalogLogId) PublishCatalogLogId	,ZPCP.LocaleID 
					 FROM ZnodePublishProduct ZPP 
					 INNER JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = ZPP.PimProductId )
					 INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPV.PimAttributeValueId)
					 LEFT JOIN  ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId AND ISNULL(ZPCP.LocaleId,0) <> 0 )			 			 
					 WHERE (EXISTS (SELECT TOP 1 1 FROM @TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId  AND  @PublishCatalogId = '' ) 
					 OR (ZPP.PublishCatalogId =  @PublishCatalogId ))
					 AND ZPV.PimAttributeId  = @PimAttributeId
					 AND ZPAVL.PimAttributeDefaultValueId= @PimAttributeDefaultValueId
					 AND ZPAVL.LocaleId = @DefaultLocaleId
					 --AND ISNULL(ZPCP.LocaleId,0) <> 0 
					 --AND CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0   THEN  @PublishStateId ELSE  ZPCP.Publishstateid END  = @PublishStateId
					 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,ZPCP.LocaleID
				END
				ELSE
				BEGIN
					 INSERT INTO #TBL_PublishCatalogId 
					 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,  MAX(PublishCatalogLogId) PublishCatalogLogId	,ZPCP.LocaleID 
					 FROM ZnodePublishProduct ZPP 
					 INNER JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = ZPP.PimProductId )
					 INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPV.PimAttributeValueId)
					 LEFT JOIN  ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId AND ISNULL(ZPCP.LocaleId,0) <> 0 )			 			 
					 WHERE (EXISTS (SELECT TOP 1 1 FROM @TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId  AND  @PublishCatalogId = '' ) 
					 OR (ZPP.PublishCatalogId =  @PublishCatalogId ))
					 AND ZPV.PimAttributeId  = @PimAttributeId
					 AND ZPAVL.PimAttributeDefaultValueId= @PimAttributeDefaultValueId
					 AND ZPAVL.LocaleId = @DefaultLocaleId
					 --AND ISNULL(ZPCP.LocaleId,0) <> 0 
					 --AND CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0   THEN  @PublishStateId ELSE  ZPCP.Publishstateid END  = @PublishStateId
					 AND ZPCP.Publishstateid = @PublishStateId
					 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,ZPCP.LocaleID
				END 
				 
			 END
	 		
             DECLARE @TBL_ProductTypeXML TABLE
             (PublishProductId INT,
			  PublishCatalogId INT,
              ReturnXML        XML,
              VersionId        INT
             );
             DECLARE @TBL_PimProductId TABLE
             ([PimProductId]   INT,
              PublishCatalogId INT,
              PublishProductId INT
             );
            
             DECLARE @TBL_PimAssociatedEntity TABLE
             (
			  ZnodeProductId                  INT,
              ZnodeCatalogId                  INT,
              AsscociadedZnodeProductIds  VARCHAR(MAX),
			  ConfigurableProductEntity       NVARCHAR(MAX),
              LocaleId                        INT,
			  DisplayOrder					  INT,
              VersionId                       INT
             );
			
		
		     SET @versionid  =(SELECT TOP 1 VersionId FROM #TBL_PublishCatalogId TBLV )

             IF @ProductType = 'BundleProduct'
             BEGIN
				    
					IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			        BEGIN 
			 		 
						 DELETE FROM ZnodePublishedXML WHERE  IsBundleProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )

					 END 
					 ELSE 
					 BEGIN 
				 
						 DELETE FROM ZnodePublishedXML WHERE  IsBundleProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			           
					 END 

					 IF OBJECT_ID('tempdb..#BundleProductPublishedXML') is not null
						drop table #BundleProductPublishedXML

					 SELECT TBP.PublishProductId, TBP.VersionId, '<BundleProductEntity><VersionId>'+CAST(TBP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeCatalogId>'+CAST(TBP.PublishCatalogId AS VARCHAR(50))+'</ZnodeCatalogId><ZnodeProductId>'
					 +CAST(TBP.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><AssociatedZnodeProductId>'
					 +CAST(TBPU.PublishProductId AS VARCHAR(50))+'</AssociatedZnodeProductId><AssociatedProductDisplayOrder>'+CAST(ISNULL(ZPTA.DisplayOrder,0) AS VARCHAR(50))+'</AssociatedProductDisplayOrder></BundleProductEntity>' ReturnXML 
					 INTO #BundleProductPublishedXML
					 FROM #TBL_PublishCatalogId TBP
					 INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
					 INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )
					 
					 UPDATE TARGET
					 SET  PublishedXML = ReturnXML
						 ,ModifiedBy = @userId 
						 ,ModifiedDate = @GetDate
					 FROM ZnodePublishedXML TARGET
					 INNER JOIN #BundleProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
																	AND TARGET.IsBundleProductXML = 1 AND TARGET.LocaleId = 0 

				 	 INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsBundleProductXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
					 SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
					 FROM #BundleProductPublishedXML SOURCE
					 WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
																	AND TARGET.IsBundleProductXML = 1 AND TARGET.LocaleId = 0 )
                                         
             END;
             ELSE
             IF @ProductType = 'GroupedProduct'
             BEGIN
				  
				     IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			         BEGIN 
			 		 
						 DELETE FROM ZnodePublishedXML WHERE  IsGroupProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )

					 END 
					 ELSE 
					 BEGIN 					 

						 DELETE FROM ZnodePublishedXML WHERE  IsGroupProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			           
					 END 
				     
					 IF OBJECT_ID('tempdb..#GroupedProductPublishedXML') is not null
						drop table #GroupedProductPublishedXML

					 SELECT TBP.PublishProductId, TBP.VersionId, '<GroupProductEntity><VersionId>'+CAST(TBP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeCatalogId>'+CAST(TBP.PublishCatalogId AS VARCHAR(50))+'</ZnodeCatalogId><ZnodeProductId>'
					 +CAST(TBP.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><AssociatedZnodeProductId>'
					 +CAST(TBPU.PublishProductId AS VARCHAR(50))+'</AssociatedZnodeProductId><AssociatedProductDisplayOrder>'+CAST(ISNULL(ZPTA.DisplayOrder,0) AS VARCHAR(50))+'</AssociatedProductDisplayOrder></GroupProductEntity>'  ReturnXML
					 INTO #GroupedProductPublishedXML
					 FROM #TBL_PublishCatalogId TBP
					 INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
					 INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )

					 UPDATE TARGET
					 SET PublishedXML = ReturnXML
						 ,ModifiedBy = @userId 
						 ,ModifiedDate = @GetDate
					 FROM ZnodePublishedXML TARGET
					 INNER JOIN #GroupedProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
																	AND TARGET.IsGroupProductXML = 1 AND TARGET.LocaleId = 0 

				 	 INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsGroupProductXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
					 SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
					 FROM #GroupedProductPublishedXML SOURCE
					 WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
										AND TARGET.IsGroupProductXML = 1 AND TARGET.LocaleId = 0 )

             END;
             ELSE
             IF @ProductType = 'ConfigurableProduct'
             BEGIN
					IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
					BEGIN 	
						 		 
						DELETE FROM ZnodePublishedXML WHERE  IsConfigProductXML = 1 
						AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
		        
					END 
					ELSE 
					BEGIN 						
							DELETE FROM ZnodePublishedXML WHERE  IsConfigProductXML = 1 
							AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV 
							WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   
							AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			           
							;WITH CTE_ConfigProductXML as
							(
								SELECT DISTINCT TBP.PublishProductId , TBP.VersionId, TBPU.PublishProductId as AssociatedZnodeProductId
								FROM #TBL_PublishCatalogId TBP
								INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
								INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )
							)
							,CTE_PublishedXML as
							(
								SELECT ZPX.PublishCatalogLogId,ZPX.PublishedId,ZPX.IsAddonXML,ZPX.IsConfigProductXML, p.value('(./AssociatedZnodeProductId)[1]', 'INT')  as AssociatedZnodeProductId
								FROM ZnodePublishedXML ZPX
								CROSS APPLY ZPX.PublishedXML.nodes('/ConfigurableProductEntity') t(p)
								where ZPX.IsConfigProductXML = 1
							)
							DELETE ZPXML  
							FROM ZnodePublishedXML ZPXML
							INNER JOIN CTE_PublishedXML CPX	ON ZPXML.PublishCatalogLogId = CPX.PublishCatalogLogId AND ZPXML.PublishedId = CPX.PublishedId AND ZPXML.IsConfigProductXML = CPX.IsConfigProductXML		
							INNER JOIN CTE_ConfigProductXML CAX on CPX.PublishCatalogLogId = CAX.VersionId 
							AND CPX.PublishedId = CAX.PublishProductId
							AND CPX.IsConfigProductXML = 1
							AND CPX.AssociatedZnodeProductId = CAX.AssociatedZnodeProductId
					 END 
						IF OBJECT_ID('tempdb..#ConfigurableProductPublishedXML') is not null
							drop table #ConfigurableProductPublishedXML

						SELECT DISTINCT TBP.PublishProductId , TBP.VersionId, '<ConfigurableProductEntity><VersionId>'+CAST(TBP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeCatalogId>'+CAST(TBP.PublishCatalogId AS VARCHAR(50))+'</ZnodeCatalogId><ZnodeProductId>'
						+CAST(TBP.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><AssociatedZnodeProductId>'
						+CAST(TBPU.PublishProductId AS VARCHAR(50))+'</AssociatedZnodeProductId><AssociatedProductDisplayOrder>'+CAST(ISNULL(ZPTA.DisplayOrder,0) AS VARCHAR(50))+'</AssociatedProductDisplayOrder>'
						+(SELECT DISTINCT  ZPA.AttributeCode ConfigurableAttributeCode 
														FROM ZnodePimConfigureProductAttribute ZPCPA 
														LEFT JOIN ZnodePimAttribute ZPA ON (Zpa.PimAttributeId = ZPCPA.PimAttributeId) 
														WHERE  ZPCPA.PimProductId = TBP.PimProductId 
														FOR XML PATH('ConfigurableAttributeCodes')) +'</ConfigurableProductEntity>'  ReturnXML
						INTO #ConfigurableProductPublishedXML
						FROM #TBL_PublishCatalogId TBP
						INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
						INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )
			
						UPDATE TARGET
						SET PublishedXML = ReturnXML
								, ModifiedBy = @userId 
								,ModifiedDate = @GetDate
						FROM ZnodePublishedXML TARGET
						INNER JOIN #ConfigurableProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId AND TARGET.IsConfigProductXML = 1 AND TARGET.LocaleId = 0
																			   AND TARGET.IsConfigProductXML = 1 AND TARGET.LocaleId = 0

						INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsConfigProductXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
						SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
						FROM #ConfigurableProductPublishedXML SOURCE
						WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
										 AND TARGET.IsConfigProductXML = 1 AND TARGET.LocaleId = 0 )

             END;

				

			SELECT PublishedXML ReturnXML
			FROM ZnodePublishedXML  ZPXM 
			WHERE EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLP WHERE TBLP.VersionId = ZPXM.PublishCatalogLogId and TBLP.PublishProductid = ZPXm.PublishedId )
			AND IsConfigProductXML = CASE WHEN @ProductType = 'ConfigurableProduct' THEN  1 ELSE 0 END 
			AND IsGroupProductXML = CASE WHEN @ProductType = 'GroupedProduct' THEN  1 ELSE 0 END 
			AND IsBundleProductXML = CASE WHEN @ProductType = 'BundleProduct' THEN  1 ELSE 0 END 
				  

			IF OBJECT_ID('tempdb..#TBL_PublishCatalogId') is not null
				drop table #TBL_PublishCatalogId

			IF OBJECT_ID('tempdb..#ConfigurableProductPublishedXML') is not null
				drop table #ConfigurableProductPublishedXML
		
		    COMMIT TRAN GetPublishAssociatedProducts;
			
         END TRY
         BEGIN CATCH
		    SELECT ERROR_MESSAGE()
            DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishAssociatedProducts @PublishCatalogId = '+@PublishCatalogId+',@ProductType= '+@ProductType+',@VersionId='+CAST(@VersionId AS VARCHAR(50))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
			ROLLBACK TRANSACTION GetPublishAssociatedProducts;
			EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPublishAssociatedProducts',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
go
IF EXISTS(SELECT * FROM SYS.PROCEDURES WHERE NAME ='Znode_GetPublishAssociatedAddons')
	DROP PROC Znode_GetPublishAssociatedAddons
GO
CREATE PROCEDURE [dbo].[Znode_GetPublishAssociatedAddons](@PublishCatalogId NVARCHAR(MAX) = 0,
                                                         @PimProductId    TransferId Readonly,
                                                         @VersionId        INT           = 0,
                                                         @UserId           INT,														 
														 @PimCategoryHierarchyId int = 0, 
														 @LocaleId       TransferId READONLY,
														 @PublishStateId INT = 0 
														   )
AS 
   
/*
    Summary : If PimcatalogId is provided get all products with Addons and provide above mentioned data
              If PimProductId is provided get all Addons if associated with given product id and provide above mentioned data
    			Input: @PublishCatalogId or @PimProductId
    		    output should be in XML format
              sample xml5
              <AddonEntity>
              <ZnodeProductId></ZnodeProductId>
              <ZnodeCatalogId></ZnodeCatalogId>
              <AddonGroupName></AddonGroupName>
              <TempAsscociadedZnodeProductIds></TempAsscociadedZnodeProductIds>
              </AddonEntity>
    <AddonEntity>
      <ZnodeProductId>6</ZnodeProductId>
      <ZnodeCatalogId>2</ZnodeCatalogId>
      <AddonGroupName>RadioButton</AddonGroupName>
      <TempAsscociadedZnodeProductIds>53,54,55,56,57,82</TempAsscociadedZnodeProductIds>
      <ZnodeProductId>14</ZnodeProductId>
      <ZnodeCatalogId>2</ZnodeCatalogId>
      <AddonGroupName>RadioButton</AddonGroupName>
      <TempAsscociadedZnodeProductIds>6,7</TempAsscociadedZnodeProductIds>
      <ZnodeProductId>16</ZnodeProductId>
      <ZnodeCatalogId>2</ZnodeCatalogId>
      <AddonGroupName>RadioButton</AddonGroupName>
      <TempAsscociadedZnodeProductIds>7,14,54,6</TempAsscociadedZnodeProductIds>
    </AddonEntity>
    Unit Testing 
     SELECT * FROM ZnodePublishcatalog
	begin tran
     EXEC [dbo].[Znode_GetPublishAssociatedAddons] @PublishCatalogId = '3',@userId= 2  ,@PimProductId=  '29' ,@UserId=2
	rollback tran
     EXEC [dbo].[Znode_GetPublishAssociatedAddons] @PublishCatalogId = 3 ,@PimProductId=  '' ,@UserId=2
     EXEC [dbo].[Znode_GetPublishAssociatedAddons] @PublishCatalogId =null ,@PimProductId=  6   

	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[Znode_GetPublishAssociatedAddons]
	@PublishCatalogId = 3,
	@UserId = 2,
	@PimCategoryHierarchyId = 125

	SELECT	'Return Value' = @return_value


   
	*/

     BEGIN
        -- BEGIN TRANSACTION GetPublishAssociatedAddons;
         BEGIN TRY
          SET NOCOUNT ON 
			 DECLARE @GetDate DATETIME= dbo.Fn_GetDate();
             DECLARE @LocaleIdIn INT, @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId()
			 , @Counter INT= 1
			 , @MaxRowId INT= 0;

            -- DECLARE @PimAddOnGroupId VARCHAR(MAX);

			 CREATE TABLE #TBL_PublisshIds  (PublishProductId INT , PimProductId INT , PublishCatalogId INT)

             DECLARE @TBL_LocaleId TABLE
             (RowId    INT IDENTITY(1, 1),
              LocaleId INT
             );


			 IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			 BEGIN 
			 		 
			   INSERT INTO #TBL_PublisshIds 
			   EXEC [dbo].[Znode_InsertPublishProductIds] @PublishCatalogId,@userid,@PimProductId,1
			   
			  -- SET @PimProductId = SUBSTRING((SELECT DISTINCT ','+CAST(PimProductId AS VARCHAr(50)) FROM #TBL_PublisshIds FOR XML PATH ('')),2,8000 )

			  -- SELECT 	@PimProductId	
			 END 
			 IF  ISnull(@PimCategoryHierarchyId,0) <> 0 
			 BEGIN 
			 		 
			   INSERT INTO #TBL_PublisshIds 
			   EXEC [dbo].[Znode_InsertPublishProductIds] @PublishCatalogId,@userid,@PimProductId,1,@PimCategoryHierarchyId 
	
			 END 

			 CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT , VersionId INT ,LocaleId INT  );

			 IF  ISnull(@PimCategoryHierarchyId,0) <> 0 
			 BEGIN 
				 INSERT INTO #TBL_PublishCatalogId 
				 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId, MAX(ZPCP.PublishCatalogLogId)  ,LocaleId 
				 FROM ZnodePublishProduct ZPP 
				 INNER JOIN ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
				 WHERE EXISTS (SELECT TOP 1 1 FROM #TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId   ) 
				 AND ZPCP.Publishstateid = @PublishStateId
				 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,LocaleId 
			 END 
			 ELSE 
			 Begin
				 BEGIN 
				 INSERT INTO #TBL_PublishCatalogId  
				 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,MAX(PublishCatalogLogId)  ,LocaleId 
				 FROM ZnodePublishProduct ZPP INNER JOIN ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
				 WHERE (EXISTS (SELECT TOP 1 1 FROM #TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId  AND  @PublishCatalogId = '0' ) 
				 OR (ZPP.PublishCatalogId =  @PublishCatalogId ))
				 AND CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0   THEN  @PublishStateId ELSE  ZPCP.Publishstateid END  = @PublishStateId
				 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,LocaleId 
			 END 

			 End
			
             DECLARE @TBL_AddonGroupLocale TABLE
             (PimAddonGroupId INT,
              DisplayType     NVARCHAR(400),
              AddonGroupName  NVARCHAR(MAX),
			  LocaleId INT 
             );
           
             INSERT INTO @TBL_LocaleId(LocaleId)
                    SELECT LocaleId
                    FROM ZnodeLocale MT 
                    WHERE IsActive = 1
					AND (EXISTS (SELECT TOP 1 1  FROM @LocaleId RT WHERE RT.Id = MT.LocaleId )
					OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleId ));

          
             SET @MaxRowId = ISNULL(
                                   (
                                       SELECT MAX(RowId)
                                       FROM @TBL_LocaleId
                                   ), 0);
    
             WHILE @Counter <= @MaxRowId
                 BEGIN
                     SET @LocaleIdIn =
                     (
                         SELECT LocaleId
                         FROM @TBL_LocaleId
                         WHERE RowId = @Counter
                     );
                     INSERT INTO @TBL_AddonGroupLocale
                     (PimAddonGroupId,
                      DisplayType,
                      AddonGroupName					  
                     )
                     EXEC Znode_GetAddOnGroupLocale
                          '',
                          @LocaleIdIn;

					UPDATE @TBL_AddonGroupLocale SET LocaleId = @LocaleIdIn WHERE LocaleId IS NULL 

                    SET @Counter = @Counter + 1;
                 END;
				     
				 IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			     BEGIN 
			 		 
			         DELETE FROM ZnodePublishedXML WHERE IsAddOnXML =1  
					 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			    
			  
				 END 
				 ELSE 
				 BEGIN 
					
					 ;WITH CTE_AddOnXML as
						 (
							 SELECT ZPPP.PublishProductId,ZPPP.PublishCatalogId,ZPPD.LocaleId,ZPPP.VersionId, ZPP.PublishProductId as AssociatedZnodeProductId  				 
							 FROM [ZnodePimAddOnProductDetail] AS ZPOPD
							 INNER JOIN [ZnodePimAddOnProduct] AS ZPAOP ON ZPOPD.[PimAddOnProductId] = ZPAOP.[PimAddOnProductId]
							 INNER JOIN #TBL_PublishCatalogId ZPPP ON (ZPPP.PimProductId = ZPAOP.PimProductId )
							 INNER JOIN #TBL_PublishCatalogId ZPP ON(ZPP.PimProductId = ZPOPD.[PimChildProductId] AND ZPP.PublishCatalogId = ZPPP.PublishCatalogId and ZPPP.LocaleId  = ZPP.LocaleId )
							 INNER JOIN ZnodePublishProductDetail ZPPD ON (ZPPD.PublishProductId = ZPPP.PublishProductId)
							 INNER JOIN @TBL_AddonGroupLocale TBAG ON (TBAG.PimAddonGroupId   = ZPAOP.PimAddonGroupId AND TBAG.LocaleId = ZPPD.LocaleId )
							 WHERE  ZPP.LocaleId = ZPPD.LocaleId AND ZPPP.LocaleId =  ZPPD.LocaleId 
						)
						,CTE_PublishedXML as
						(
							SELECT ZPX.PublishCatalogLogId,ZPX.PublishedId,ZPX.IsAddonXML, p.value('(./AssociatedZnodeProductId)[1]', 'INT')  as AssociatedZnodeProductId, p.value('(./LocaleId)[1]', 'INT') as LocaleId1
							FROM ZnodePublishedXML ZPX
							CROSS APPLY ZPX.PublishedXML.nodes('/AddonEntity') t(p)
							where ZPX.IsAddonXML = 1
						)
						DELETE ZPXML  
						FROM ZnodePublishedXML ZPXML
						INNER JOIN CTE_PublishedXML CPX	ON ZPXML.PublishCatalogLogId = CPX.PublishCatalogLogId AND ZPXML.PublishedId = CPX.PublishedId AND ZPXML.IsAddonXML = CPX.IsAddonXML		
						INNER JOIN CTE_AddOnXML CAX on --CPX.PublishCatalogLogId = CAX.VersionId AND
							 CPX.PublishedId = CAX.PublishProductId
							AND ZPXML.IsAddonXML = 1 
							AND CPX.LocaleId1 = CAX.LocaleId 
							AND CPX.AssociatedZnodeProductId = CAX.AssociatedZnodeProductId
				 END 
			
					--SELECT * FROM #TBL_PublishCatalogId

					DELETE FROM ZnodePublishedXml WHERE PublishCatalogLogId IN (SELECT VersionId 
					FROM #TBL_PublishCatalogId ) AND IsAddOnXML = 1 

					IF OBJECT_ID('tempdb..#AddonProductPublishedXML') is not null
						drop table #AddonProductPublishedXML

					SELECT   ZPPP.PublishProductId,ZPPP.PublishCatalogId,ZPPD.LocaleId,ZPPP.VersionId,'<AddonEntity><VersionId>'+CAST(ZPPP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeProductId>'+CAST(ZPPP.[PublishProductId] AS VARCHAR(50))+'</ZnodeProductId><ZnodeCatalogId>'
				     +CAST(ZPPP.[PublishCatalogId] AS VARCHAR(50))+'</ZnodeCatalogId><AssociatedZnodeProductId>'+CAST(ZPP.PublishProductId  AS VARCHAR(50))
					 +'</AssociatedZnodeProductId><DisplayOrder>'+CAST( ISNULL(ZPAOP.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder><AssociatedProductDisplayOrder>'
					 +CAST(ISNULL(ZPOPD.DisplayOrder,'') AS VARCHAR(50))+'</AssociatedProductDisplayOrder><RequiredType>'+ISNULL(RequiredType,'')+'</RequiredType><DisplayType>'
					 + ISNULL(DisplayType,'')+'</DisplayType><GroupName>'+ISNULL((select ''+AddonGroupName for xml path('')),'')+'</GroupName><LocaleId>'+CAST(ZPPD.LocaleId AS VARCHAR(50))+'</LocaleId><IsDefault>'+CAST(ISNULL(IsDefault,0) AS VARCHAR(50))+'</IsDefault></AddonEntity>'  ReturnXML		   
				      INTO #AddonProductPublishedXML
                      FROM [ZnodePimAddOnProductDetail] AS ZPOPD
						INNER JOIN [ZnodePimAddOnProduct] AS ZPAOP ON ZPOPD.[PimAddOnProductId] = ZPAOP.[PimAddOnProductId]
						INNER JOIN #TBL_PublishCatalogId ZPPP ON (ZPPP.PimProductId = ZPAOP.PimProductId )
						INNER JOIN #TBL_PublishCatalogId ZPP ON(ZPP.PimProductId = ZPOPD.[PimChildProductId] AND ZPP.PublishCatalogId = ZPPP.PublishCatalogId )
						INNER JOIN ZnodePublishProductDetail ZPPD ON (ZPPD.PublishProductId = ZPPP.PublishProductId)
						INNER JOIN @TBL_AddonGroupLocale TBAG ON (TBAG.PimAddonGroupId   = ZPAOP.PimAddonGroupId AND TBAG.LocaleId = ZPPD.LocaleId )
						WHERE  ZPP.LocaleId = ZPPD.LocaleId AND ZPPP.LocaleId =  ZPPD.LocaleId 


						UPDATE TARGET
						SET PublishedXML = ReturnXML
								, ModifiedBy = @userId 
								,ModifiedDate = @GetDate
						FROM ZnodePublishedXML TARGET
						INNER JOIN #AddonProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.VersionId AND TARGET.PublishedId = SOURCE.PublishProductId
														AND TARGET.IsAddonXML = 1 AND TARGET.LocaleId = SOURCE.LocaleId 

						INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsAddonXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
						SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
						FROM #AddonProductPublishedXML SOURCE
						WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.VersionId AND TARGET.PublishedId = SOURCE.PublishProductId
														AND TARGET.IsAddonXML = 1 AND TARGET.LocaleId = SOURCE.LocaleId  )
					
					SELECT Cast(PublishedXML as xml) ReturnXML
					FROM #TBL_PublishCatalogId TBLPP 
					INNER JOIN ZnodePublishedXML ZPX ON (ZPX.PublishCatalogLogId = TBLPP.VersionId AND ZPX.PublishedId = TBLPP.publishProductid )
					WHERE ZPX.IsAddonXML = 1
             --SELECT ReturnXML
             --FROM @TBL_AddonXML;
		
           --  COMMIT TRANSACTION GetPublishAssociatedAddons;
         END TRY
         BEGIN CATCH
		     SELECT ERROR_MESSAGE(),ERROR_PROCEDURE()
             DECLARE @Status BIT;
             SET @Status = 0;
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishAssociatedAddons @PublishCatalogId = '+@PublishCatalogId+',@VersionId='+CAST(@VersionId AS VARCHAR(50))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
             SELECT 0 AS ID,
                    CAST(0 AS BIT) AS Status;
           --  ROLLBACK TRANSACTION GetPublishAssociatedAddons;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishAssociatedAddons',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO

	 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_AdminUsers')
BEGIN 
	DROP PROCEDURE Znode_AdminUsers
END
GO
CREATE PROCEDURE [dbo].[Znode_AdminUsers]
(	@RoleName		VARCHAR(200),
    @UserName		VARCHAR(200),
    @WhereClause	VARCHAR(MAX)  = '',
    @Rows			INT           = 100,
    @PageNo			INT           = 1,
    @Order_By		VARCHAR(1000) = '',
    @RowCount		INT        = 0 OUT,
	@IsCallOnSite   BIT = 0 ,
	@PortalId		VARCHAR(1000) = 0 )
AS
   /* 
      Summary: List of users with detsils and shows link with ASPNet tables 
      This procedure is used for finding both users and admin users 
      here use three view "View_RoleUsers" for check  @UserName is present or not 
      "View_AdminUserDetail"  this view use for admin users 
      "View_CustomerUserDetail" Use for customer users 
      Unit Testing   
	  SELECT * FROM ZnodeUser 
      DECLARE @EDE INT=0  EXEC Znode_AdminUsers '','admin@znode.com',@WhereClause='',@Order_By='',@PageNo= 1 ,@Rows= 214,@IsCallOnSite='false',@PortalId=0,@RowCount=@EDE OUT  SELECT @EDE
   */
     BEGIN
         BEGIN TRY
            SET NOCOUNT ON;


            DECLARE @SQL NVARCHAR(MAX)= '', @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');
             
			IF @PortalId  <> '0' 
			BEGIN 
			    SET @WhereClause = CASE WHEN  @WhereClause = '' THEN ' (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' ELSE @WhereClause+' AND (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' END 
			END 
			IF EXISTS
            (
            SELECT TOP 1 1
            FROM View_RoleUsers
            WHERE Username = @UserName
            )
			-- this check for admin user
            AND @RoleName <> ''  

			BEGIN
				SET @SQL = ' 
				--;with Cte_AdminUserDetail AS 
				--(
					 
				SELECT  DISTINCT A.UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,A.CreatedBy,A.CreatedDate,A.ModifiedBy,A.ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				INTO #Cte_AdminUserDetail
				FROM View_AdminUserDetail A
				'+CASE WHEN @PortalId  <> '0' THEN ' INNER JOIN ZnodeUserPortal ZUP ON (ZUP.UserId = A.UserId) 'ELSE '' END  +'	 
				'+dbo.Fn_GetWhereClause(@WhereClause, ' WHERE ')+'
				--),
				;with Cte_AdminUserDetailRowId AS 
				(
				SELECT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId
				FROM  #Cte_AdminUserDetail
				)
					 
				SELECT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId,CustomerPaymentGUID ,RowId 
				INTO #AccountDetails
				FROM Cte_AdminUserDetailRowId 
					 
				SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetails ),0)
					 
				SELECT DISTINCT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				FROM #AccountDetails '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC' );
			    PRINT @SQL
				EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;
			END;
			-- For Customer user
            ELSE   
            BEGIN
				IF @roleName = ''
				BEGIN
				
				SET @SQL = '
				--;With Cte_CustomerUserDetail  AS 
				--(
				SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #Cte_CustomerUserDetail
				FROM View_CustomerUserAddDetail a 
				
				WHERE 
				(EXISTS   -- this will check for customer 
				(
				SELECT TOP 1 1
				FROM AspNetUserRoles AS b
				WHERE a.AspNetUserId = b.userid
				AND EXISTS
				(SELECT TOP 1 1	FROM AspNetRoles AS d	WHERE(d.TypeOfRole is NULL OR d.TypeOfRole = ''B2B'')	AND d.Id = b.RoleId	)  
				) OR AspNetuserId IS NULL OR '+CAST(CAST(@IsCallOnSite AS INT ) AS VARCHAR(50))+'= ''1'' ) 
				'+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+'
				--),
				;With Cte_CustomerUserDetailRowId  AS 
				(
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				FROM #Cte_CustomerUserDetail -- genrate the unique rowid 
				)
					 			 
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RowId,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #AccountDetail FROM Cte_CustomerUserDetailRowId  

				SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetail    ),0)

				
												  
				SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				FROM #AccountDetail '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC');
                PRINT @SQL    					
				EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;
				END;
            ELSE
				BEGIN
					SELECT * FROM View_CustomerUserDetail AS VICUD WHERE 1 = 0;
					SET @RowCount = 0;
				END;
            END;			
         END TRY
         BEGIN CATCH
            DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUsers @RoleName = '+@RoleName+' ,@UserName='+@UserName+',@WhereClause='+@WhereClause+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50));
            EXEC Znode_InsertProcedureErrorLog
            @ProcedureName    = 'Znode_AdminUsers',
            @ErrorInProcedure = @ERROR_PROCEDURE,
            @ErrorMessage     = @ErrorMessage,
            @ErrorLine        = @ErrorLine,
            @ErrorCall        = @ErrorCall;
         END CATCH;


     END;

	 GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'User','ConvertShopperToAdmin',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'User' and ActionName = 'ConvertShopperToAdmin')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'ConvertShopperToAdmin') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'ConvertShopperToAdmin'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'ConvertShopperToAdmin')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'ConvertShopperToAdmin'))

GO



IF NOT EXISTS  (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeMedia' AND COLUMN_NAME = 'Version')
BEGIN 
ALTER TABLE [dbo].[ZnodeMedia]
    ADD [Version] INT CONSTRAINT [DF_ZnodeMedia_Version] DEFAULT ((0)) NOT NULL;
END

GO

IF EXISTS (SELECT * FROM sys.views where name = 'View_GetAllMediaInRoot')
	DROP VIEW View_GetAllMediaInRoot
GO
	CREATE VIEW [dbo].[View_GetAllMediaInRoot]
	AS
		 SELECT MediaCategoryId,
				MediaPathId,
				[Folder],
				[FileName],
				Size,
				Height,
				Width,
				Type,
				[MediaType],
				CreatedDate,
				ModifiedDate,
				MediaId,
				Path,
				MediaServerPath MediaServerPath,
				MediaThumbnailPath MediaServerThumbnailPath,
				FamilyCode,
				CreatedBy,
				[DisplayName] [DisplayName],
				[Description] [ShortDescription]
				,[Version]
		 FROM
		 (
			 SELECT 0 AS MediaCategoryId,
					ZMPL.MediaPathId,
					'-1' ParentMediaPathId,
					CASE
						WHEN ZMPL.[PathName] IS NULL
						THEN 'Root'
						ELSE ZMPL.[PathName]
					END AS Folder,
					zM.FileName,
					zM.Size,
					zM.Height,
					zM.Width,
					zM.Type,
					zM.Type AS MediaType,
					CONVERT( DATE, zm.CreatedDate) CreatedDate,
					CONVERT( DATE, zm.ModifiedDate) ModifiedDate,
					zM.MediaId,
					NULL AS MediaAttributeName,
					NULL AS MediaAttributeValue,
					zmf.FamilyCode,
					[dbo].[Fn_GetMediaThumbnailMediaPath]( zM.Path) MediaThumbnailPath,
					[dbo].[Fn_GetMediaPathServer]( zM.Path)  MediaServerPath,
					zM.Path,
					zM.CreatedBy,
					zmae.AttributeCode,
					zmav.AttributeValue,
					zM.Version
			 FROM dbo.ZnodeMedia AS zM
				  LEFT JOIN ZnodeMediaCategory zma ON(zm.mediaid = zma.MediaId)
		 --         LEFT JOIN ZnodeMediaConfiguration ZMC ON (ZMC.MediaConfigurationId = ZM.MediaConfigurationId )
				  --LEFT JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
				  LEFT JOIN ZnodeMediaAttributeFamily zmf ON(zma.MediaAttributeFamilyId = zmf.MediaAttributeFamilyId)
				  LEFT OUTER JOIN dbo.ZnodeMediaPath AS zmp ON(zma.MediaPathId = zmp.MediaPathId)
				  LEFT OUTER JOIN dbo.ZnodeMediaPathLocale AS ZMPL ON zmp.MediaPathId = ZMPL.MediaPathId
				  LEFT JOIN dbo.ZnodeMediaAttributeValue Zmav ON(zmav.MediaCategoryId = zma.MediaCategoryId)
				  LEFT JOIN dbo.ZnodeMediaAttribute zmae ON(zmae.MediaAttributeId = Zmav.MediaAttributeId
															AND zmae.AttributeCode IN('DisplayName', 'Description'))) v 
		 PIVOT(MAX(AttributeValue) FOR AttributeCode IN([DisplayName],
															[Description])) PV;
GO

IF EXISTS (SELECT * FROM sys.views where name = 'View_GetMediaPathDetail')
	DROP VIEW View_GetMediaPathDetail
GO
CREATE VIEW [dbo].[View_GetMediaPathDetail]  
AS  
     SELECT MediaCategoryId,  
            MediaPathId,  
            [Folder],  
            [FileName],  
            Size,  
   Height,  
   Width,  
      Type,  
            [MediaType],  
            CreatedDate,  
            ModifiedDate,  
            MediaId,  
            Path,  
            MediaServerPath MediaServerPath,  
            MediaThumbnailPath MediaServerThumbnailPath,  
            FamilyCode,  
            CreatedBy,  
            [DisplayName] [DisplayName],  
            [Description] [ShortDescription] ,  
			[Version]    
  
     /* INTO #temp2*/  
  
     FROM  
     (  
         SELECT Zmc.MediaCategoryId,  
                ZMPL.MediaPathId,  
                ZMPL.[PathName] [Folder],  
                zM.[FileName],  
                Zm.Size,  
    Zm.Height,  
    Zm.Width,  
    Zm.Type,  
                Zm.Type [MediaType],  
                CONVERT( DATE, zm.CreatedDate) CreatedDate,  
                CONVERT( DATE, zm.ModifiedDate) ModifiedDate,  
                Zm.MediaId,  
                zma.AttributeCode,  
                Zmav.AttributeValue,  
                ISNULL(CASE WHEN ZMCF.CDNURL = '' THEN NULL ELSE ZMCF.CDNURL END,ZMCF.URL)+ZMSM.ThumbnailFolderName+'\'+zM.Path MediaThumbnailPath,    
     ISNULL(CASE WHEN ZMCF.CDNURL = '' THEN NULL ELSE ZMCF.CDNURL END,ZMCF.URL)+zM.Path  MediaServerPath,   
    zM.Path,  
               zmafl.FamilyCode FamilyCode,  
                Zm.CreatedBy 
				, Zm.Version 
         FROM ZnodeMediaCategory ZMC  
              LEFT JOIN ZnodeMediaAttributeFamily zmafl ON(zmc.MediaAttributeFamilyId = zmafl.MediaAttributeFamilyId)  
     INNER JOIN ZnodeMediaPathLocale ZMPL ON(ZMC.MediaPathId = ZMPL.MediaPathId)  
              INNER JOIN ZnodeMedia zM ON(Zm.MediaId = Zmc.MediaId)  
        LEFT JOIN ZnodeMediaConfiguration ZMCF ON (ZMCF.MediaConfigurationId = ZM.MediaConfigurationId AND ZMCF.IsActive = 1)  
     LEFT JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMCF.MediaServerMasterId)  
              LEFT JOIN dbo.ZnodeMediaAttributeValue Zmav ON(zmav.MediaCategoryId = zmc.MediaCategoryId)  
              LEFT JOIN dbo.ZnodeMediaAttribute zma ON(zma.MediaAttributeId = Zmav.MediaAttributeId  
                                                       AND AttributeCode IN('DisplayName', 'Description'))    
      
     ) v PIVOT(MAX(AttributeValue) FOR AttributeCode IN([DisplayName],  
                                                        [Description])) PV;
GO


IF EXISTS (SELECT * FROM sys.views where name = 'View_MediaPathDetails')
	DROP VIEW View_MediaPathDetails
GO
CREATE View [dbo].[View_MediaPathDetails]   
AS   
SELECT ZM.MediaId  
,ZM.MediaConfigurationId  
,ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZM.Path Path      
,ZM.FileName  
,ZM.Size  
,ZM.Height  
,ZM.Width  
,ZM.Length  
,ZM.Type  
,ZM.CreatedBy  
,ZM.CreatedDate  
,ZM.ModifiedBy  
,ZM.ModifiedDate  
FROM ZnodeMedia ZM   
LEFT JOIN ZnodeMediaConfiguration ZMC ON (ZMC.MediaConfigurationId = ZM.MediaConfigurationId)  
LEFT JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
GO

IF EXISTS (SELECT TOP 1  1 FROM sys.Objects WHERE OBJECT_NAME(object_id) = 'Fn_GetMediaPathServer')
BEGIN
DROP FUNCTION dbo.Fn_GetMediaPathServer
END
GO
CREATE FUNCTION [dbo].[Fn_GetMediaPathServer]  
(@path VARCHAR(1000)  
  
)  
RETURNS VARCHAR(4000)  
AS  
     BEGIN  
         DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);  
         DECLARE @V_MediaServerThumbnailPathWithMedia VARCHAR(4000);  
         SET @V_MediaServerThumbnailPath =  
         (  
             SELECT ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL) 
			 FROM ZnodeMediaConfiguration ZMC Inner join ZnodeMedia ZM ON ZMC.MediaConfigurationId = ZM.MediaConfigurationId    
            Inner join ZnodeMediaCategory ZMCT ON ZM.MediaId = ZMCT.MediaId  
            Inner join ZnodeMediaPath ZMP ON ZMCT.MediaPathId = ZMP.MediaPathId where ZMC.IsActive=1  
            and ZM.[Path] =  @path  
         );  
         --SET @V_MediaServerThumbnailPathWithMedia = SUBSTRING(  
         --                                                    (  
         --                                                        SELECT ',',  
         --                                                               @V_MediaServerThumbnailPath+item  
         --                                                        FROM dbo.Split(@path, ',') a  
         --                                                        FOR XML PATH('')  
         --                                                    ), 2, 4000);  
         RETURN CASE  
                    WHEN (@V_MediaServerThumbnailPath IS NULL  
                         OR RTRIM(LTRIM(@V_MediaServerThumbnailPath)) = '')  
                         --OR @V_MediaServerThumbnailPath = @V_MediaServerThumbnailPath  
                    THEN '/MediaFolder/no-image.png'  
                    ELSE @V_MediaServerThumbnailPath+@path  
                END;  
   --RETURN @V_MediaServerThumbnailPath  
     END;

GO

IF EXISTS (SELECT TOP 1  1 FROM sys.Objects WHERE OBJECT_NAME(object_id) = 'Fn_GetMediaThumbnailMediaPath')
BEGIN
DROP FUNCTION dbo.Fn_GetMediaThumbnailMediaPath
END
GO
CREATE FUNCTION [dbo].[Fn_GetMediaThumbnailMediaPath]      
(@path VARCHAR(1000)      
)      
RETURNS VARCHAR(4000)      
AS      
     BEGIN      
         DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);      
         DECLARE @V_MediaServerThumbnailPathWithMedia VARCHAR(4000);      
         SET @V_MediaServerThumbnailPath =      
         (      
             SELECT ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'          
             FROM ZnodeMediaConfiguration ZMC       
    INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)      
       WHERE IsActive = 1       
         );      
         SET @V_MediaServerThumbnailPathWithMedia = SUBSTRING(      
                                                             (      
                                                                 SELECT ',',      
                                                                        @V_MediaServerThumbnailPath+item      
                                                                 FROM dbo.Split(@path, ',') a      
                                                                 FOR XML PATH(''), TYPE).value('.', 'varchar(Max)'), 2, 4000);      
         RETURN CASE      
                    WHEN @V_MediaServerThumbnailPathWithMedia IS NULL      
                         OR RTRIM(LTRIM(@V_MediaServerThumbnailPathWithMedia)) = ''      
                         OR @V_MediaServerThumbnailPath = @V_MediaServerThumbnailPathWithMedia      
                    THEN '/MediaFolder/no-image.png'      
                    ELSE @V_MediaServerThumbnailPathWithMedia      
                END;      
     END;

	 GO

IF EXISTS (SELECT TOP 1  1 FROM sys.Objects WHERE OBJECT_NAME(object_id) = 'Fn_GetServerThumbnailMediaPath')
BEGIN
DROP FUNCTION dbo.Fn_GetServerThumbnailMediaPath
END
GO
CREATE FUNCTION [dbo].[Fn_GetServerThumbnailMediaPath]()  
RETURNS VARCHAR(4000)  
AS  
     BEGIN  
         DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);  
         DECLARE @V_MediaServerThumbnailPathWithMedia VARCHAR(4000);  
         SET @V_MediaServerThumbnailPath =  
         (  
             SELECT ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'    
             FROM ZnodeMediaConfiguration ZMC   
    INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)  
             WHERE IsActive = 1  
         );  
         SET @V_MediaServerThumbnailPathWithMedia = @V_MediaServerThumbnailPath  
         RETURN @V_MediaServerThumbnailPathWithMedia  
  
  
   --CASE  
   --                 WHEN @V_MediaServerThumbnailPathWithMedia IS NULL  
   --                      OR RTRIM(LTRIM(@V_MediaServerThumbnailPathWithMedia)) = ''  
   --                      OR @V_MediaServerThumbnailPath = @V_MediaServerThumbnailPathWithMedia  
   --                 THEN '/MediaFolder/no-image.png'  
   --                 ELSE @V_MediaServerThumbnailPathWithMedia  
   --             END;  
     END;

	 GO

	 IF EXISTS (SELECT TOP 1  1 FROM sys.Objects WHERE OBJECT_NAME(object_id) = 'Fn_GetThumbnailMediaPath')
BEGIN
DROP FUNCTION dbo.Fn_GetThumbnailMediaPath
END
GO
CREATE FUNCTION [dbo].[Fn_GetThumbnailMediaPath]  
(  
  @MediaId Varchar(1000)   
  ,@IsrequiredId BIT = 0   
)  
RETURNS VARCHAr(4000)  
AS  
BEGIN  
 -- Declare the return variable here  
    DECLARE @V_MediaServerThumbnailPath VARCHAr(4000)  
 SET @V_MediaServerThumbnailPath = (SELECT ISNULL(CASE WHEN a.CDNURL = '' THEN NULL ELSE a.CDNURL END,a.URL)+ThumbnailFolderName+'/' 
 FROM ZnodeMediaConfiguration a 
 INNER JOIN ZnodeMediaServerMaster b ON (a.MediaServerMasterId = b.MediaServerMasterId ) WHERE IsActive=1)    
   
 DECLARE @V_MediaDetails TABLE (MediaId INT , [Path] VARCHAr(300))  
  
 INSERT INTO @V_MediaDetails  
 SELECT MediaId , [Path]   
 FROM ZnodeMedia q   
 INNER JOIN  dbo.Split(@MediaId,',') a ON( q.MediaId = a.item)  
 ORDER BY a.id  
   
 SET  @V_MediaServerThumbnailPath = CASE WHEN @IsrequiredId = 1 THEN  SUBSTRING ((SELECT ',',@V_MediaServerThumbnailPath+[Path] 
 FROM @V_MediaDetails  FOR XML PATH ('') ) ,2,4000) +'~'+SUBSTRING ((SELECT ','+CAST(MediaId AS VARCHAr(1000) )  
 FROM @V_MediaDetails  FOR XML PATH ('') ) ,2,4000) ELSE SUBSTRING ((SELECT ',',@V_MediaServerThumbnailPath+[Path] 
 FROM @V_MediaDetails FOR XML PATH ('') ) ,2,4000)  END       
   
  
  
 RETURN ISNULL(@V_MediaServerThumbnailPath,CASE WHEN @IsrequiredId = 1 THEN '/MediaFolder/no-image.png~' ELSE '/MediaFolder/no-image.png' END )  
  
END

GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetAccountGlobalAttributeValue')
BEGIN 
	DROP PROCEDURE Znode_GetAccountGlobalAttributeValue
END
GO
CREATE  PROCEDURE [dbo].[Znode_GetAccountGlobalAttributeValue]
(
    @EntityName       nvarchar(200) = 0,
    @GlobalEntityValueId   INT = 0,
	@LocaleCode       VARCHAR(100) = '',
   @GroupCode  nvarchar(200) = null,
       @SelectedValue bit = 0
 --   @LocaleId       INT = 0,
	--@GlobalEnt
)
AS
/*
	 Summary :- This procedure is used to get the Attribute and EntityValue attribute value as per filter pass 
	 Unit Testing 
	 BEGIN TRAN
	 EXEC [Znode_GetGlobalEntityAttributeValue] 'Store',1
	 ROLLBACK TRAN

*/	 
     BEGIN
 BEGIN TRY
 declare @EntityValue nvarchar(200), @LocaleId int

  DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);
          SET @V_MediaServerThumbnailPath =
         (
             SELECT ISNULL(CASE WHEN CDNURL = '' THEN NULL ELSE CDNURL END,URL)+ZMSM.ThumbnailFolderName+'/'  
             FROM ZnodeMediaConfiguration ZMC 
			 INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
		     WHERE IsActive = 1 
         );


 Select @EntityValue=Name  from ZnodeAccount
 Where AccountId=@GlobalEntityValueId

            Declare	@EntityAttributeList as	table  (GlobalEntityId int,EntityName nvarchar(300),EntityValue nvarchar(max),
			GlobalAttributeGroupId int,GlobalAttributeId int,AttributeTypeId int,AttributeTypeName nvarchar(300),
			 AttributeCode nvarchar(300) ,IsRequired bit,IsLocalizable bit,AttributeName  nvarchar(300) , HelpDescription nvarchar(max),DisplayOrder int
			) 
			 
			Declare @EntityAttributeValidationList  as	table  
			( GlobalAttributeId int, ControlName nvarchar(300), ValidationName nvarchar(300),SubValidationName nvarchar(300),
			 RegExp nvarchar(300), ValidationValue nvarchar(300),IsRegExp Bit)

			Declare	@EntityAttributeValueList as	table  (GlobalAttributeId int,AttributeValue nvarchar(max),
			GlobalAttributeValueId int,GlobalAttributeDefaultValueId int,AttributeDefaultValueCode nvarchar(300),
			AttributeDefaultValue nvarchar(300),
			MediaId int,MediaPath nvarchar(300),IsEditable bit,DisplayOrder int )



			Declare	@EntityAttributeDefaultValueList as	table  (GlobalAttributeDefaultValueId int,GlobalAttributeId int,
			AttributeDefaultValueCode nvarchar(300),AttributeDefaultValue nvarchar(300),RowId int,IsEditable bit,DisplayOrder int )

			set @LocaleId = (select top 1 LocaleId from ZnodeLocale where Code = @LocaleCode)

            IF ISnull(@GroupCode, '') = ''
            Begin
			
				insert into @EntityAttributeList
					(	GlobalEntityId ,EntityName ,EntityValue ,
					GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
					AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription,DisplayOrder  ) 
				SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
					c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
					c.IsLocalizable,f.AttributeName,c.HelpDescription,c.DisplayOrder
				 FROM dbo.ZnodeGlobalEntity AS qq
					  INNER JOIN dbo.ZnodeGlobalGroupEntityMapper AS w ON qq.GlobalEntityId = w.GlobalEntityId
					  INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = w.GlobalAttributeGroupId
					  INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
					  INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
					  INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
					  Where qq.EntityName = @EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
			END
			Else

               Begin
                       insert into @EntityAttributeList
                               ( GlobalEntityId ,EntityName ,EntityValue ,
                               GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
                               AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription,DisplayOrder  )
                               SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
                               c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
                               c.IsLocalizable,f.AttributeName,c.HelpDescription,c.DisplayOrder
                        FROM dbo.ZnodeGlobalEntity AS qq
                                 INNER JOIN dbo.ZnodeGlobalGroupEntityMapper AS w ON qq.GlobalEntityId = w.GlobalEntityId
                                 INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = w.GlobalAttributeGroupId
                                 INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
                                 INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
                                 INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
                                 --Inner JOIN ZnodeGlobalAttributeGroup g on ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId
                                 Where qq.EntityName=@EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
                                 AND exists( select 1 from ZnodeGlobalAttributeGroup g where ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId and g.GroupCode = @GroupCode )	
               END


		  INSERT INTO @EntityAttributeValidationList
		  (GlobalAttributeId,ControlName , ValidationName ,SubValidationName ,
		RegExp, ValidationValue,IsRegExp)

		 Select aa.GlobalAttributeId,i.ControlName,i.Name AS ValidationName,j.ValidationName AS SubValidationName,
		j.RegExp,k.Name AS ValidationValue,CAST(CASE WHEN j.RegExp IS NULL THEN 0 ELSE 1 END AS BIT) AS IsRegExp
		
		fROM @EntityAttributeList aa
		  inner  JOIN dbo.ZnodeGlobalAttributeValidation AS k ON k.GlobalAttributeId = aa.GlobalAttributeId
          inner  JOIN dbo.ZnodeAttributeInputValidation AS i ON k.InputValidationId = i.InputValidationId
          LEFT  JOIN dbo.ZnodeAttributeInputValidationRule AS j ON k.InputValidationRuleId = j.InputValidationRuleId

		  insert into @EntityAttributeValueList
		  (GlobalAttributeId,GlobalAttributeValueId,GlobalAttributeDefaultValueId,AttributeValue ,MediaId,MediaPath)
		  Select DISTINCT GlobalAttributeId,aa.AccountGlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
		  case when bb.MediaPath is not null then  @V_MediaServerThumbnailPath+bb.MediaPath--+'~'+convert(nvarchar(10),bb.MediaId) 
		  else bb.AttributeValue end,		  
		  bb.MediaId,bb.MediaPath
		  from  dbo.ZnodeAccountGlobalAttributeValue aa
		   inner join ZnodeAccountGlobalAttributeValueLocale bb ON bb.AccountGlobalAttributeValueId = aa.AccountGlobalAttributeValueId 
		  Where  AccountId=@GlobalEntityValueId

		

		  

		  update aa
		  Set AttributeDefaultValueCode= h.AttributeDefaultValueCode,
              AttributeDefaultValue=g.AttributeDefaultValue,
			  GlobalAttributeDefaultValueId=g.GlobalAttributeDefaultValueId,
			  AttributeValue=case when aa.AttributeValue is  null then h.AttributeDefaultValueCode else aa.AttributeValue end,
			  IsEditable = ISNULL(h.IsEditable, 1),DisplayOrder = h.DisplayOrder
		  from  @EntityAttributeValueList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeDefaultValueId = aa.GlobalAttributeDefaultValueId                                       
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
          
		  insert into @EntityAttributeDefaultValueList
		  (GlobalAttributeDefaultValueId,GlobalAttributeId,AttributeDefaultValueCode,
			AttributeDefaultValue ,RowId ,IsEditable ,DisplayOrder )
		  Select  h.GlobalAttributeDefaultValueId, aa.GlobalAttributeId,h.AttributeDefaultValueCode,g.AttributeDefaultValue,0,ISNULL(h.IsEditable, 1),
		  h.DisplayOrder
		  from  @EntityAttributeList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeId = aa.GlobalAttributeId
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
		  
		 
			if not exists (Select 1 from @EntityAttributeList )
			Begin
			insert into @EntityAttributeList
			(	GlobalEntityId ,EntityName ,EntityValue ,
			GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
			AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription  ) 
			SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,0 GlobalAttributeGroupId,
			0 GlobalAttributeId,0 AttributeTypeId,''AttributeTypeName,''AttributeCode,0 IsRequired,
			0 IsLocalizable,'' AttributeName,'' HelpDescription
			FROM dbo.ZnodeGlobalEntity AS qq
			 Where qq.EntityName=@EntityName 
			End
				

			SELECT GlobalEntityId,EntityName,EntityValue,GlobalAttributeGroupId,
			AA.GlobalAttributeId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,
			IsLocalizable,AttributeName,ControlName,ValidationName,SubValidationName,RegExp,
			ValidationValue,cast(isnull(IsRegExp,0) as bit)  IsRegExp,
			HelpDescription,AttributeValue,GlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
			aab.AttributeDefaultValueCode,
			aab.AttributeDefaultValue,isnull(aab.RowId,0)   RowId,cast(isnull(aab.IsEditable,0) as bit)   IsEditable
			,bb.MediaId,AA.DisplayOrder
			fROM @EntityAttributeList AA				
			left join @EntityAttributeDefaultValueList aab on aab.GlobalAttributeId=AA.GlobalAttributeId	
			left join @EntityAttributeValidationList vl on vl.GlobalAttributeId=aa.GlobalAttributeId			
			LEFT JOIN @EntityAttributeValueList BB ON BB.GlobalAttributeId=AA.GlobalAttributeId		 
		    and ( (aab.GlobalAttributeDefaultValueId=bb.GlobalAttributeDefaultValueId	)
			or  ( bb.MediaId is not null and isnull(vl.ValidationName,'')='IsAllowMultiUpload'  and bb.GlobalAttributeDefaultValueId is null )
			or  ( bb.MediaId is  null and  bb.GlobalAttributeDefaultValueId is null ))
			order by AA.DisplayOrder, aab.DisplayOrder

			SELECT 1 AS ID,CAST(1 AS BIT) AS Status;       
		  END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;
		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		    @ErrorCall NVARCHAR(MAX)= null       			 
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		 
          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetGlobalEntityValueAttributeValues',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO

	 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetCatalogCategoryProducts')
BEGIN 
	DROP PROCEDURE Znode_GetCatalogCategoryProducts
END
GO
CREATE PROCEDURE [dbo].[Znode_GetCatalogCategoryProducts]
( 
  @WhereClause      XML,
  @Rows             INT           = 100,
  @PageNo           INT           = 1,
  @Order_BY         VARCHAR(1000) = 'DisplayOrder asc',
  @RowsCount        INT OUT,
  @LocaleId         INT           = 1,
  @PimCategoryId    INT           = 0,
  @PimCatalogId     INT           = 0,
  @IsAssociated     BIT           = 0,
  @ProfileCatalogId INT           = 0,
  @AttributeCode   VARCHAR(max) = '',
  @PimCategoryHierarchyId INT =0,
  @PortalId INT=0
  )
AS
   
/*
	   Summary:  Get product List  Catalog / category / respective product list   		   
	   Unit Testing   
	   begin tran
	   declare @p7 int = 0  
	   EXEC Znode_GetCatalogCategoryProducts @WhereClause=N'',@Rows=10,@PageNo=1,@Order_By=N'',
	   @RowsCount=@p7 output,@PimCategoryId=11,@PimCatalogId = 1 ,@LocaleId=1 ,@ProfileCatalogId = 1 
	   rollback tran
	  
    */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @DefaultAttributeFamily INT= dbo.Fn_GetDefaultPimProductFamilyId(), @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @OrderId INT= 0;
             DECLARE @SQL VARCHAR(MAX), 
					 @PimProductId TransferId,--VARCHAR(MAX)= '', 
					 @PimAttributeId VARCHAR(MAX),
					 @OutPimProductIds VARCHAR(max);
             DECLARE @TransferPimProductId TransferId 

			 DECLARE @tbl_ProductPricingSku TABLE (sku nvarchar(200),RetailPrice numeric(28,6),SalesPrice numeric(28,6),TierPrice numeric(28,6),
			 TierQuantity numeric(28,6),CurrencyCode varchar(200),CurrencySuffix varchar(2000),CultureCode varchar(2000), ExternalId NVARCHAR(2000)
			 ,Custom1 NVARCHAR(MAX), Custom2 NVARCHAR(MAX), Custom3 NVARCHAR(MAX))				

			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

			 --DECLARE @TBL_ProfileCatalogCategory TABLE
    --         (
				--  ProfileCatalogId     INT,
				--  PimProductId         INT,
				--  PimCategoryId        INT,
				--  PimCatalogCategoryId INT,
				--  PimCategoryHierarchyId INT
    --         );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (
				  PimAttributeId            INT,
				  AttributeDefaultValueCode VARCHAR(100),
				  IsEditable                BIT,
				  AttributeDefaultValue     NVARCHAR(MAX),
				  DisplayOrder INT 
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (
				  PimProductId   INT,
				  AttributeValue NVARCHAR(MAX),
				  AttributeCode  VARCHAR(600),
				  PimAttributeId INT
				  
             );
             DECLARE @FamilyDetails TABLE
             (
				  PimProductId         INT,
				  PimAttributeFamilyId INT,
				  FamilyName           NVARCHAR(3000)
             );
             DECLARE @TBL_AttributeValue TABLE
             (
				  PimCategoryAttributeValueId INT,
				  PimCategoryId               INT,
				  CategoryValue               NVARCHAR(MAX),
				  AttributeCode               VARCHAR(300),
				  PimAttributeId              INT
             );
             IF @Order_By = ''
                 BEGIN
                     SET @Order_By = 'DisplayOrder asc'
                 END;
             --IF @ProfileCatalogId > 0
             --    BEGIN
             --        INSERT INTO @TBL_ProfileCatalogCategory (ProfileCatalogId,PimProductId,PimCategoryId,PimCatalogCategoryId,PimCategoryHierarchyId)
             --        SELECT ZPC.ProfileCatalogId,PimProductId,PimCategoryId,ZCC.PimCatalogCategoryId,PimCategoryHierarchyId
             --        FROM ZnodePimCatalogCategory AS ZCC
             --        INNER JOIN ZnodeProfileCatalog AS ZPC ON(ZPC.PimCatalogId = ZCC.PimCatalogId)
             --        WHERE ZPC.ProfileCatalogId = @ProfileCatalogId

             --        AND NOT EXISTS
             --            (
             --               SELECT TOP 1 1
             --               FROM ZnodeProfileCatalogCategory AS ZPCC
             --               WHERE ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId
             --            );
             --    END;
			 
             IF @PimCatalogId = 0
                 BEGIN
					INSERT INTO @TransferPimProductId 
                    SELECT PimProductId 
                    FROM ZnodePimCategoryProduct AS ZCP
                    WHERE ZCP.PimCategoryId = @PimCategoryId
					AND PimProductId IS NOT NULL 
                                                   
                 END;
             ELSE
                 BEGIN
				 
                     IF @IsAssociated = 0
                        AND @ProfileCatalogId > 0
                         BEGIN
				INSERT INTO @TransferPimProductId 
                SELECT DISTINCT PimProductId 
                FROM ZnodePimCatalogCategory AS ZCP
                WHERE ZCP.PimCatalogId = @PimCatalogId
              --  AND ZCP.PimCategoryId = @PimCategoryId
				AND ZCP.PimCategoryHierarchyId = @PimCategoryHierarchyId 
                AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM ZnodeProfileCatalogCategory AS TBPCC
                    WHERE TBPCC.PimCatalogCategoryId = ZCP.PimCatalogCategoryId
                        AND TBPCC.ProfileCatalogId = @ProfileCatalogId
                )
               	AND PimProductId IS NOT NULL                                         
                        END;
                     ELSE
                         BEGIN
                             IF @IsAssociated = 1
                                AND @ProfileCatalogId > 0
                                 BEGIN
						INSERT INTO @TransferPimProductId 
                        SELECT PimProductId
                        FROM ZnodePimCatalogCategory AS ZCP
                        WHERE ZCP.PimCatalogId = @PimCatalogId
                            AND ZCP.PimCategoryHierarchyId = @PimCategoryHierarchyId
                            AND EXISTS
                        (
                            SELECT TOP 1 1
                            FROM ZnodeProfileCatalogCategory AS TBPCC
                            WHERE TBPCC.PimCatalogCategoryId = ZCP.PimCatalogCategoryId
                                AND TBPCC.ProfileCatalogId = @ProfileCatalogId
                        )
                       AND PimProductId IS NOT NULL                                             
                                     SET @IsAssociated = 0;
                                 END;
                             ELSE
                                 BEGIN
					INSERT INTO @TransferPimProductId 
                    SELECT DISTINCT PimProductId 
                    FROM ZnodePimCatalogCategory AS ZCP
                    WHERE ZCP.PimCatalogId = @PimCatalogId
                 --   AND ZCP.PimCategoryId = @PimCategoryId
					AND ZCP.PimCategoryHierarchyId = @PimCategoryHierarchyId 
				    AND PimProductId IS NOT NULL  
			
         --           ORDER BY CASE WHEN @OrderId = 0
         --                       THEN 1
         --                       ELSE ZCP.PimCatalogCategoryId
								 --END 
								 --DESC
                                   
                                 END;
                         END;
                 END;
				
				 IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId)
				 BEGIN 
                  INSERT INTO @TransferPimProductId
				  SELECT '0'

				 END 

				 
             DECLARE @ProductIdTable TABLE
             ([PimProductId] INT,
              [CountId]      INT,
              PimCategoryId  INT,
              RowId          INT IDENTITY(1,1)
             );
            DECLARE  @ProductListIdRTR TransferId
	 DECLARE @TAb Transferid 
	 DECLARE @tBL_mainList TABLE (Id INT,RowId INT)
	 --	IF @PimProductId <> ''  OR   @IsCallForAttribute=1
		--BEGIN 
	 SET @IsAssociated = CASE WHEN @IsAssociated = 0 THEN 1  
					 WHEN @IsAssociated = 1 THEN 0 END 
		--END 



	 INSERT INTO @ProductListIdRTR
	 EXEC Znode_GetProductList  @IsAssociated,@TransferPimProductId
	 


	 IF CAST(@WhereClause AS NVARCHAR(max))<> N''
	 BEGIN 
	 
	  SET @SQL = 'SELECT PimProductId FROM ##Temp_PimProductId'+CAST(@@SPID AS VARCHAR(500))

	  EXEC Znode_GetFilterPimProductId @WhereClause,@ProductListIdRTR,@localeId
	  
      INSERT INTO @TAB 
	  EXEC (@SQL)
	-- SELECT * FROM @TAB
	 END 
	 
	 
	 IF EXISTS (SELECT Top 1 1 FROM @TAb ) OR CAST(@WhereClause AS NVARCHAR(max)) <> N''
	 BEGIN 
	 
		 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
		 --SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
		 INSERT INTO @TBL_MainList(id,RowId)
		 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @TAb ,@AttributeCode,@localeId,
		 @PimCategoryHierarchyId=@PimCategoryHierarchyId ,@PortalId=@PortalId
	 
		 END 
	 ELSE 
	 BEGIN
	      
	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 --SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO @TBL_MainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @ProductListIdRTR ,@AttributeCode,@localeId,
	 @PimCategoryHierarchyId=@PimCategoryHierarchyId ,@PortalId=@PortalId 
	 
	 END 

	
	
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT id 
			 FROM @TBL_MainList 
            
			 UPDATE @ProductIdTable
               SET
                   PimCategoryId = @PimCategoryId;
             --SET @PimProductId = SUBSTRING(
             --                             (
             --                                 SELECT ','+CAST(PimProductId AS VARCHAR(100))
             --                                 FROM @ProductIdTable
             --                                 FOR XML PATH('')
             --                             ), 2, 4000);

			 INSERT INTO @PimProductId  ( Id )
			 SELECT PimProductId FROM @ProductIdTable

             SET @PimAttributeId = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetGridPimAttributes]() FOR XML PATH('')), 2, 4000);
             
			 DECLARE @PimAttributeIds TransferId  
			 INSERT INTO @PimAttributeIds
			 SELECT PimAttributeId  
			 FROM [dbo].[Fn_GetProductGridAttributes]()
		
			 
			
			 INSERT INTO @TBL_AttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)   
			 EXEC Znode_GetAttributeDefaultValueLocale @PimAttributeId,@LocaleId;
          
			 INSERT INTO @TBL_AttributeDetails (PimProductId,AttributeValue,AttributeCode,PimAttributeId)
             EXEC Znode_GetProductsAttributeValue @PimProductId,@PimAttributeId,@localeId;
			  
             SET @PimAttributeId = [dbo].[Fn_GetCategoryNameAttributeId]();
			 
             INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
             EXEC [dbo].[Znode_GetCategoryAttributeValue] @PimCategoryId,@PimAttributeId,@LocaleId;
         
		    ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'+ zm.PATH   
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;
			    
             INSERT INTO @FamilyDetails (PimAttributeFamilyId,PimProductId)
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId] @PimProductId,1;

             UPDATE a
             SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                  AND LocaleId = @LocaleId);
             UPDATE a
             SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                  AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';

				

             SELECT zpp.PimProductid AS ProductId,zpp.PimProductId,@PimCatalogId AS PimCatalogId,zpp.PimCategoryId,[ProductName],
			 ProductType,ISNULL(zf.FamilyName, '') AS AttributeFamily,[SKU],[Price],[Quantity],
                    CASE
                        WHEN Piv.[IsActive] IS NULL
                        THEN CAST(0 AS BIT)
                        ELSE CAST(Piv.[IsActive] AS BIT)
                    END AS [IsActive],
                    piv.[ProductImage] ImagePath,
                    [Assortment],
                    TBAV.CategoryValue AS [CategoryName],
                    @LocaleId AS LocaleId,
                    ZCC.[DisplayOrder],
                    ZPCC.ProfileCatalogCategoryId,
                    zpp.RowId,
					ZCC.PimCategoryHierarchyId
			 INTO #temp_ProductDetails 
             FROM @ProductIdTable AS zpp
			 INNER JOIN @TBL_MainList TMM ON (TMM.Id = zpp.PimProductId)
                  LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
                  INNER JOIN
             (
                 SELECT PimProductId,
                        AttributeValue,
                        AttributeCode
                 FROM @TBL_AttributeDetails
             ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
                                                                 [SKU],
                                                                 [Price],
                                                                 [Quantity],
                                                                 [IsActive],
                                                                 [ProductType],
                                                                 [ProductImage],
                                                                 [Assortment],
                                                                 [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
                  LEFT JOIN @TBL_AttributeValue AS TBAV ON(TBAV.PimCategoryId = ZPP.PimCategoryId)
                  LEFT JOIN ZnodePimCategoryProduct AS ZPCP ON(ZPCP.PimProductId = Zpp.PimProductId
                                                               AND ZPCP.PimCategoryId = Zpp.PimCategoryId)
                  LEFT JOIN ZnodePimCatalogCategory AS ZCC ON(ZCC.PimProductId = Zpp.PimProductId
                                                             AND ZCC.PimCategoryHierarchyId = @PimCategoryHierarchyId
                                                              AND ZCC.PimCatalogId = @PimCatalogId)
                  LEFT JOIN ZnodeProfileCatalogCategory AS ZPCC ON(ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId
                                                                   AND ZPCC.ProfileCatalogId = @ProfileCatalogId)
                  
            ORDER BY zpp.RowId

			DECLARE @SKUS VARCHAR(max) 
			,@userId INT = 0,@Date DATETIME  = dbo.FN_getDate() 

			SELECT @SKUS = COALESCE(@SKUS+',' ,'') + SKU
			FROM #temp_ProductDetails
			 				
			INSERT INTO @tbl_ProductPricingSku		
			EXEC Znode_GetPublishProductPricingBySku 	@SKU=@SKUS, @PortalId= @PortalId,@Userid= @userid ,@currentUtcDate=	@Date
			
			SELECT DISTINCT ProductId, PimProductId	,PimCatalogId,	PimCategoryId,	ProductName	,ProductType,	
			AttributeFamily,	a.SKU	,dbo.Fn_GetPortalCurrencySymbol(@portalId)+CAST(Dbo.Fn_GetDefaultPriceRoundOff(RetailPrice) AS NVARCHAR(max)) Price,	Quantity,	
			IsActive,	ImagePath,	Assortment,	CategoryName,	LocaleId,	DisplayOrder	,ProfileCatalogCategoryId,	RowId,	PimCategoryHierarchyId	
			FROM #temp_ProductDetails a 
			LEFT JOIN @tbl_ProductPricingSku b ON (dbo.FN_TRIM(b.SKU) = a.SKU )
			ORDER BY RowId
					  
     IF EXISTS (SELECT Top 1 1 FROM @TAb )
	 BEGIN 

		  SELECT @RowsCount = (SELECT COUNT(1) FROM @TAb) 
	 END 
	 ELSE 
	 BEGIN
	 		  SELECT @RowsCount =(SELECT COUNT(1) FROM @ProductListIdRTR)   
	 END 
	

         END TRY
         BEGIN CATCH
		    SELECT ERROR_message()
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCatalogCategoryProducts @WhereClause = '''+ISNULL(CAST(@WhereClause AS VARCHAR(MAX)),'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',
			@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''')+',@PimCategoryId='+ISNULL(CAST(@PimCategoryId AS VARCHAR(50)),'''')+',@PimCatalogId='+ISNULL(CAST(@PimCatalogId AS VARCHAR(50)),'''')+',@IsAssociated='+ISNULL(CAST(@IsAssociated AS VARCHAR(50)),'''')+',
			@ProfileCatalogId='+ISNULL(CAST(@ProfileCatalogId AS VARCHAR(50)),'''')+',@AttributeCode='''+ISNULL(CAST(@AttributeCode AS VARCHAR(50)),'''''')+''',@PimCategoryHierarchyId='+ISNULL(CAST(@PimCategoryHierarchyId AS VARCHAR(10)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetCatalogCategoryProducts',
				@ErrorInProcedure = 'Znode_GetCatalogCategoryProducts',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetFormBuilderGlobalAttributeValue')
BEGIN 
	DROP PROCEDURE Znode_GetFormBuilderGlobalAttributeValue
END
GO
CREATE   PROCEDURE [dbo].[Znode_GetFormBuilderGlobalAttributeValue]
(
    @FormBuilderId  int=null,
    @UserId			int= null,
	@PortalId		int = null,
	@FormBuilderSubmitId int=null,
    @LocaleId       INT = 0
)
AS
/*
	 Summary :- This procedure is used to get the Attribute and EntityValue attribute value as per filter pass
	 Unit Testing
	 BEGIN TRAN
	 EXEC [Znode_GetFormBuilderGlobalAttributeValue_back] 1
	 ROLLBACK TRAN

*/
     BEGIN
 BEGIN TRY
 declare @EntityValue nvarchar(200),@FormCode nvarchar(200),@DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId()

 If isnull(@LocaleId,0) =0
 Begin
   Set @LocaleId =@DefaultLocaleId
 End

 If isnull( @FormBuilderSubmitId,0) >0
 Select @FormBuilderId=FormBuilderId
 From ZnodeFormBuilderSubmit
 Where FormBuilderSubmitId=@FormBuilderSubmitId

  DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);
          SET @V_MediaServerThumbnailPath =
         (
             SELECT ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'  
             FROM ZnodeMediaConfiguration ZMC
			 INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
		     WHERE IsActive = 1
         );
Declare	@AttributeList as	table (GlobalAttributeGroupId int,GlobalAttributeId int,AttributeGroupDisplayOrder int
,AttributeDisplayOrder int)

 Select @EntityValue=FormCode,@FormCode=FormCode
 from ZnodeFormBuilder
 Where FormBuilderId=@FormBuilderId

            Declare	@EntityAttributeList as	table  (GlobalEntityId int,EntityName nvarchar(300),EntityValue nvarchar(max),
			GlobalAttributeGroupId int,GlobalAttributeId int,AttributeTypeId int,AttributeTypeName nvarchar(300),
			 AttributeCode nvarchar(300) ,IsRequired bit,IsLocalizable bit,AttributeName  nvarchar(300) , HelpDescription nvarchar(max)
			,AttributeGroupDisplayOrder int,AttributeDisplayOrder int)

			Declare @EntityAttributeValidationList  as	table
			( GlobalAttributeId int, ControlName nvarchar(300), ValidationName nvarchar(300),SubValidationName nvarchar(300),
			 RegExp nvarchar(300), ValidationValue nvarchar(300),IsRegExp Bit)

			Declare	@EntityAttributeValueList as	table  (GlobalAttributeId int,AttributeValue nvarchar(max),
			GlobalAttributeValueId int,GlobalAttributeDefaultValueId int,AttributeDefaultValueCode nvarchar(300),
			AttributeDefaultValue nvarchar(300),
			MediaId int,MediaPath nvarchar(300) )



			Declare	@EntityAttributeDefaultValueList as	table  (GlobalAttributeDefaultValueId int,GlobalAttributeId int,
			AttributeDefaultValueCode nvarchar(300),AttributeDefaultValue nvarchar(300),RowId int,IsEditable bit,DisplayOrder int )

			insert into @AttributeList
			 Select qq.GlobalAttributeGroupId,isnull(dd.GlobalAttributeId ,qq.GlobalAttributeId) ,qq.DisplayOrder,dd.AttributeDisplayOrder
			   from dbo.ZnodeFormBuilderAttributeMapper  qq
			   left join ZnodeGlobalAttributeGroupMapper dd on dd.GlobalAttributeGroupId=qq.GlobalAttributeGroupId
			   Where qq.FormBuilderId=@FormBuilderId

	insert into @EntityAttributeList
		(	GlobalEntityId ,EntityName ,EntityValue ,
		GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
		AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription ,AttributeGroupDisplayOrder,AttributeDisplayOrder )
		SELECT @FormBuilderId GlobalEntityId,'FormBuilder' EntityName,@EntityValue EntityValue,qq.GlobalAttributeGroupId,
		c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
		c.IsLocalizable,null AttributeName,c.HelpDescription,qq.AttributeGroupDisplayOrder,qq.AttributeDisplayOrder
     FROM @AttributeList AS qq
          INNER JOIN dbo.ZnodeGlobalAttribute AS c ON qq.GlobalAttributeId = c.GlobalAttributeId
          INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId

		  update c
		  Set AttributeName=f.AttributeName
		  from  @EntityAttributeList c
		  INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
		   where  f.LocaleId=@LocaleId

		 if  @LocaleId !=@DefaultLocaleId
		 Begin
				update c
				Set AttributeName=f.AttributeName
				from  @EntityAttributeList c
				INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
				Where c.AttributeName is null
				and f.LocaleId=@DefaultLocaleId
		 End


		  INSERT INTO @EntityAttributeValidationList
		  (GlobalAttributeId,ControlName , ValidationName ,SubValidationName ,
		RegExp, ValidationValue,IsRegExp)

		 Select aa.GlobalAttributeId,i.ControlName,i.Name AS ValidationName,j.ValidationName AS SubValidationName,
		j.RegExp,k.Name AS ValidationValue,CAST(CASE WHEN j.RegExp IS NULL THEN 0 ELSE 1 END AS BIT) AS IsRegExp
		fROM @EntityAttributeList aa
		  inner  JOIN dbo.ZnodeGlobalAttributeValidation AS k ON k.GlobalAttributeId = aa.GlobalAttributeId
          inner  JOIN dbo.ZnodeAttributeInputValidation AS i ON k.InputValidationId = i.InputValidationId
          LEFT  JOIN dbo.ZnodeAttributeInputValidationRule AS j ON k.InputValidationRuleId = j.InputValidationRuleId

		  insert into @EntityAttributeValueList
		  (GlobalAttributeId,GlobalAttributeValueId,GlobalAttributeDefaultValueId,AttributeValue ,MediaId,MediaPath)
		  Select GlobalAttributeId,aa.FormBuilderGlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
		  case when bb.MediaPath is not null then  bb.MediaPath  else bb.AttributeValue end,
		  bb.MediaId,bb.MediaPath
		  from  dbo.ZnodeFormBuilderSubmit ss
		  inner join dbo.ZnodeFormBuilderGlobalAttributeValue aa on ss.FormBuilderSubmitId =aa.FormBuilderSubmitId
		  inner join ZnodeFormBuilderGlobalAttributeValueLocale bb ON bb.FormBuilderGlobalAttributeValueId = aa.FormBuilderGlobalAttributeValueId
		  Where  ss.FormBuilderId=@FormBuilderId
		  and ss.FormBuilderSubmitId=@FormBuilderSubmitId

		  update aa
		  Set AttributeDefaultValueCode= h.AttributeDefaultValueCode,
         	  GlobalAttributeDefaultValueId=h.GlobalAttributeDefaultValueId,
			  AttributeValue=case when aa.AttributeValue is  null then h.AttributeDefaultValueCode else aa.AttributeValue end
		  from  @EntityAttributeValueList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeDefaultValueId = aa.GlobalAttributeDefaultValueId

		  update h
		  Set AttributeDefaultValue=g.AttributeDefaultValue
		  from  @EntityAttributeValueList h
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
          where  g.LocaleId=@LocaleId

		 if  @LocaleId !=@DefaultLocaleId
		 Begin
				update h
				Set AttributeDefaultValue=g.AttributeDefaultValue
				from  @EntityAttributeValueList h
				inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
                Where h.AttributeDefaultValue is null
				and g.LocaleId=@DefaultLocaleId
		 End


		  insert into @EntityAttributeDefaultValueList
		  (GlobalAttributeDefaultValueId,GlobalAttributeId,AttributeDefaultValueCode,
			AttributeDefaultValue ,RowId ,IsEditable ,DisplayOrder )
		  Select  h.GlobalAttributeDefaultValueId, aa.GlobalAttributeId,h.AttributeDefaultValueCode,null AttributeDefaultValue,0,ISNULL(h.IsEditable, 1),
		  h.DisplayOrder
		  from  @EntityAttributeList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeId = aa.GlobalAttributeId

		  update h
		  Set h.AttributeDefaultValue=g.AttributeDefaultValue
          from @EntityAttributeDefaultValueList h
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
		  Where g.LocaleId=@LocaleId

		  if  @LocaleId !=@DefaultLocaleId
		 Begin
				  update h
				  Set h.AttributeDefaultValue=g.AttributeDefaultValue
				  from @EntityAttributeDefaultValueList h
				  inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
				  Where g.LocaleId=@DefaultLocaleId
				  and  h.AttributeDefaultValue is null
		 End



		  if not exists (Select 1 from @EntityAttributeList )
			Begin
			insert into @EntityAttributeList
			(	GlobalEntityId ,EntityName ,EntityValue ,
			GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
			AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription  )
			SELECT 0 GlobalEntityId,'FormBuilder' EntityName,@EntityValue EntityValue,0 GlobalAttributeGroupId,
			0 GlobalAttributeId,0 AttributeTypeId,''AttributeTypeName,''AttributeCode,0 IsRequired,
			0 IsLocalizable,'' AttributeName,'' HelpDescription
			End



			SELECT  GlobalEntityId,EntityName,EntityValue,GlobalAttributeGroupId,
			AA.GlobalAttributeId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,
			IsLocalizable,AttributeName,ControlName,ValidationName,SubValidationName,RegExp,
			ValidationValue,cast(isnull(IsRegExp,0) as bit)  IsRegExp,
			HelpDescription,AttributeValue,GlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
			aab.AttributeDefaultValueCode,
			aab.AttributeDefaultValue,isnull(aab.RowId,0)   RowId,cast(isnull(aab.IsEditable,0) as bit)   IsEditable
			,bb.MediaId--,aa.AttributeGroupDisplayOrder,aa.AttributeDisplayOrder
			fROM @EntityAttributeList AA
			left join @EntityAttributeDefaultValueList aab on aab.GlobalAttributeId=AA.GlobalAttributeId
			left join @EntityAttributeValidationList vl on vl.GlobalAttributeId=aa.GlobalAttributeId
			LEFT JOIN @EntityAttributeValueList BB ON BB.GlobalAttributeId=AA.GlobalAttributeId
		    and ( (aab.GlobalAttributeDefaultValueId=bb.GlobalAttributeDefaultValueId	)
			or  ( bb.MediaId is not null and isnull(vl.ValidationName,'')='IsAllowMultiUpload'  and bb.GlobalAttributeDefaultValueId is null )
			or  ( bb.MediaId is  null and  bb.GlobalAttributeDefaultValueId is null ))
			order by GlobalEntityId,AttributeGroupDisplayOrder,GlobalAttributeGroupId,aa.AttributeDisplayOrder, GlobalAttributeId,aab.DisplayOrder,aab.GlobalAttributeDefaultValueId


			--Select CMSWidgetsId,WidgetsKey,CMSMappingId,TypeOFMapping,FormBuilderId,
			--		FormTitle,ButtonText,IsTextMessage,TextMessage,RedirectURL
			--from ZnodeCMSFormWidgetConfiguration
			--where FormBuilderId=@FormBuilderId

			SELECT 0 AS ID,CAST(1 AS BIT) AS Status;
		  END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;
		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		    @ErrorCall NVARCHAR(MAX)= null
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;

          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetGlobalEntityValueAttributeValues',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;

GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetMediaFolderDetails')
BEGIN 
	DROP PROCEDURE Znode_GetMediaFolderDetails
END
GO
CREATE PROCEDURE [dbo].[Znode_GetMediaFolderDetails]
( @WhereClause VARCHAR(1000),
  @MediaPathId INT,
  @Rows        INT           = 1000,
  @PageNo      INT           = 0,
  @Order_BY    VARCHAR(1000) = '',
  @RowsCount   INT OUT,
  @LocaleId    INT           = 1)
AS
/*
  Summary: This Procedure is Used to Get Details of Media Folder
  Unit Testing:
  begin tran
	DECLARE @RowsCount BIGINT  
	EXEC Znode_GetMediaFolderDetails @MediaPathId = -1 , @WhereClause='',@Rows=2147483647,@PageNo=1 ,@Order_By='', @RowsCount = @RowsCount OUT  
  rollback tran
  begin tran
	DECLARE @RowsCount BIGINT  
	EXEC Znode_GetMediaFolderDetails @MediaPathId = 1 , @WhereClause='' ,@Rows=10,@PageNo=1 ,@RowsCount =@RowsCount 
  rollback tran
*/
     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @Rows_start VARCHAR(1000), @Rows_end VARCHAR(1000);
             SET @MediaPathId =  CASE WHEN @MediaPathId = -1 THEN 1 ELSE @MediaPathId END
			 
			 SET @Rows_start = CASE
                                   WHEN @Rows >= 1000000
                                   THEN 0
                                   ELSE(@Rows * (@PageNo - 1)) + 1
                               END;
             SET @Rows_end = CASE
                                 WHEN @Rows >= 1000000
                                 THEN @Rows
                                 ELSE @Rows * (@PageNo)
                             END;
             DECLARE @SQL NVARCHAR(MAX);
		

             SET @Order_BY = REPLACE(@Order_BY, 'MediaPathId', 'Convert(numeric,MediaPathId)');
             SET @Order_BY = REPLACE(@Order_BY, 'Size', 'Convert(numeric,Size)');
             SET @Order_BY = REPLACE(@Order_BY, 'MediaId', 'Convert(numeric,MediaId)');
             SET @Order_BY = REPLACE(@Order_BY, 'CreatedBy', 'Convert(numeric,CreatedBy)');
             SET @Order_BY = REPLACE(@Order_BY, 'MediaCategoryId', 'Convert(numeric,MediaCategoryId)');

             SET @SQL = ' DECLARE @V_MediaServerPath  VARCHAR(max) , @V_MediaServerThumbnailPath  VARCHAR(MAx)  


			 SELECT RANK()OVER(ORDER BY '+CASE
                                                 WHEN @Order_BY IS NULL
                                                      OR @Order_BY = ''
                                                 THEN ''
                                                 ELSE @Order_BY+' ,'
                                          END+'MediaId ) RowId, [MediaCategoryId],[MediaPathId],[Folder],[FileName],[Size],[Height],[Width],
			 [MediaType],[CreatedDate],[ModifiedDate],[MediaId],[Path],ISNULL(MediaServerPath,'''') AS MediaServerPath,
			  ISNULL(MediaServerThumbnailPath,'''') AS MediaServerThumbnailPath,[FamilyCode],[CreatedBy],[ShortDescription],[DisplayName], [Version] 
			 INTO #MediaPathDetail FROM '+CASE
                                                 WHEN @MediaPathId = -1
                                                 THEN ' View_GetAllMediaInRoot '
                                                 ELSE ' View_GetMediaPathDetail ZMC '
                                          END+' WHERE 1=1 '+CASE
                                                                   WHEN @WhereClause = ''
                                                                        OR @WhereClause IS NULL
                                                                        OR @WhereClause = '-1' 
                                                                   THEN 'AND exists (select top 1 1 from DBO.FN_GetMediaPathHierarchy('+CAST( @MediaPathId  AS VARCHAR(1000))+') Q 
			 where Q.MediaPathId = ZMC.MediaPathId )'
                                                                   ELSE CASE
                                                                            WHEN @MediaPathId = -1
                                                                            THEN ' AND '+@WhereClause
                                                                            ELSE ' AND exists (select top 1 1 from DBO.FN_GetMediaPathHierarchy('+CAST( @MediaPathId AS VARCHAR(1000))+') Q 
			 where Q.MediaPathId = ZMC.MediaPathId ) and  '+@WhereClause
                                                                        END
                                                               END+' Order BY '+CASE
                                                                                    WHEN @Order_BY IS NULL
                                                                                         OR @Order_BY = ''
                                                                                    THEN ' MediaCategoryId DESC'
                                                                                    ELSE @Order_BY
                                                                                END+' SELECT  @Count=ISNULL(Count(1),0) FROM  #MediaPathDetail  SELECT [MediaCategoryId],[MediaPathId],[Folder],[FileName],[Size],[Height],[Width],
			 [MediaType],[CreatedDate],[ModifiedDate],[MediaId],[Path],ISNULL(MediaServerPath,'''') AS MediaServerPath, ISNULL(MediaServerThumbnailPath,'''') AS MediaServerThumbnailPath,
			 [FamilyCode],[CreatedBy],[ShortDescription],[DisplayName],[Version] 
			 FROM #MediaPathDetail 
			 WHERE RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+' Order BY '+CASE
                                                                                   WHEN @Order_BY IS NULL
                                                                                        OR @Order_BY = ''
                                                                                   THEN ' MediaCategoryId DESC '
                                                                                   ELSE @Order_BY
                                                                              END;
           PRINT @SQL 
             EXEC SP_executesql
                  @SQL,
                  N'@Count INT OUT',
                  @Count = @RowsCount OUT;
				 
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetMediaFolderDetails @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',@MediaPathId='+ISNULL(CAST(@WhereClause AS VARCHAR(100)),'''')+',@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetMediaFolderDetails',
				@ErrorInProcedure = 'Znode_GetMediaFolderDetails',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;                                
         END CATCH;
     END;

	 GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPimCategoryProductList')
BEGIN 
	DROP PROCEDURE Znode_GetPimCategoryProductList
END
GO
CREATE PROCEDURE [dbo].[Znode_GetPimCategoryProductList]
(   @WhereClause   XML,
    @Rows          INT           = 100,
    @PageNo        INT           = 1,
    @Order_BY      VARCHAR(1000) = '',
    @RowsCount     INT OUT,
    @LocaleId      INT           = 1,
    @PimCategoryId INT,
    @IsAssociated  BIT           = 0
	,@AttributeCode VARCHAR(max) = ''
	)
AS
/*
     Summary :- This Procedure is used to get the product list for category products
				The result is fetched order by DisplayOrder or status as per requirement in both asc and desc

     Unit Testing
	 begin tran
     EXEC Znode_GetPimCategoryProductList '',@RowsCount = 0, @PimCategoryId = 22,@Order_BY ='DisplayOrder asc'
	 rollback tran
	*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX),
			  DisplayOrder INT
             );
			 DECLARE @TransferPimProductId TransferId
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
             DECLARE @TBL_FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             DECLARE @OrderByDisplay INT= 0;
             DECLARE @DefaultAttributeFamilyId INT= dbo.Fn_GetDefaultPimProductFamilyId(), @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();

			 DECLARE @TBL_ProductIdTable TABLE
             ([PimProductId] INT,
              [CountId]      INT,
              PimCategoryId  INT,
              RowId          INT
             );

             DECLARE @PimProductId TransferId ,--VARCHAR(MAX)= '',
					 @PimAttributeId VARCHAR(MAX),
					 @OutPimProductIds VARCHAR(MAX);

			 DECLARE @PimProductIds TransferId

             IF @Order_BY LIKE '%DisplayOrder%'
                 BEGIN
                     SET @OrderByDisplay = 1;
                 END;
             ELSE
             IF @Order_BY LIKE '%Status%'
                 BEGIN
                     SET @OrderByDisplay = 2;
                 END;
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

            INSERT INTO @TransferPimProductId
			SELECT PimProductId
			FROM ZnodePimCategoryProduct ZCP
            WHERE ZCP.PimCategoryId = @PimCategoryId
			ORDER BY CASE WHEN @Order_By LIKE '% DESC%'
            THEN
			CASE WHEN @OrderByDisplay = 1
					THEN ZCP.DisplayOrder
				WHEN @OrderByDisplay = 2
					THEN ZCP.Status
				 ELSE 1 END
				 ELSE 1 END DESC,
            CASE WHEN @Order_By LIKE '% ASC%'
				THEN
					CASE WHEN @OrderByDisplay = 1
					THEN ZCP.DisplayOrder
						WHEN @OrderByDisplay = 2
							THEN ZCP.Status
							 ELSE 1 END
							  ELSE 1 END
	         IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId  )
			 BEGIN
			   INSERT INTO @TransferPimProductId
			   SELECT '0'
			   SET @IsAssociated = 0
             END


   DECLARE @SQL NVARcHAR(max)= ''
		 DECLARE  @ProductListIdRTR TransferId
	 DECLARE @TAb Transferid
	 DECLARE @tBL_mainList TABLE (Id INT,RowId INT)
	 --	IF   @IsCallForAttribute=1
		--BEGIN
	 SET @IsAssociated = CASE WHEN @IsAssociated = 0 THEN 1
					 WHEN @IsAssociated = 1 THEN 0 END
		--END
	 INSERT INTO @ProductListIdRTR
	 EXEC Znode_GetProductList  @IsAssociated,@TransferPimProductId

	 IF CAST(@WhereClause AS NVARCHAR(max))<> N''
	 BEGIN

	  SET @SQL = 'SELECT PimProductId FROM ##Temp_PimProductId'+CAST(@@SPID AS VARCHAR(500))

	  EXEC Znode_GetFilterPimProductId @WhereClause,@ProductListIdRTR,@localeId

      INSERT INTO @TAB
	  EXEC (@SQL)

	 END

	 IF EXISTS (SELECT Top 1 1 FROM @TAb ) OR CAST(@WhereClause AS NVARCHAR(max)) <> N''
	 BEGIN

	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO @TBL_MainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @TAb ,@AttributeCode,@localeId

	 END
	 ELSE
	 BEGIN

	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO @TBL_MainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @ProductListIdRTR ,@AttributeCode,@localeId
	 END
			 INSERT INTO @TBL_ProductIdTable(PimProductId,RowId)
			 SELECT ID ,RowId FROM @TBL_MainList SP

			 INSERT INTO @PimProductIds ( Id )
			 SELECT Id FROM @TBL_MainList SP

             UPDATE @TBL_ProductIdTable SET PimCategoryId = @PimCategoryId;
             SET @PimAttributeId = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetGridPimAttributes]() FOR XML PATH('')), 2, 4000);

			 --INSERT INTO @TBL_AttributeDefaultValue(PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)
    --         EXEC Znode_GetAttributeDefaultValueLocale @PimAttributeId,@LocaleId;

             INSERT INTO @TBL_AttributeDetails(PimProductId, AttributeValue,AttributeCode,PimAttributeId)
			 EXEC Znode_GetProductsAttributeValue @PimProductIds,@PimAttributeId,@LocaleId;
             --EXEC Znode_GetProductsAttributeValue @OutPimProductIds,@PimAttributeId,@LocaleId;

             --- find the specific attributes and values ----
    --         WITH Cte_UpdateDefaultAttributeValue
			 --AS (SELECT PimProductId,AttributeCode,AttributeValue,SUBSTRING((SELECT ','+TBADV.AttributeDefaultValue
			 --FROM @TBL_AttributeDefaultValue AS TBADV
    --         INNER JOIN ZnodePimAttribute AS TBAC ON(TBADV.PimAttributeId = TBAC.PimAttributeId)
			 --WHERE TBAC.AttributeCode = TBAD.AttributeCode
    --         AND EXISTS(SELECT TOP 1 1 FROM dbo.split(TBAD.AttributeValue, ',') AS SP WHERE Sp.item = TBADV.AttributeDefaultValueCode)
    --         FOR XML PATH('')), 2, 4000) AS AttributeDefaultValue

			 --FROM @TBL_AttributeDetails AS TBAD)

    --         UPDATE TBAD SET AttributeValue = CTUDAV.AttributeDefaultValue
			 --FROM @TBL_AttributeDetails TBAD
			 --INNER JOIN Cte_UpdateDefaultAttributeValue CTUDAV
			 --ON(CTUDAV.PimProductId = TBAD.PimProductId AND CTUDAV.AttributeCode = TBAD.AttributeCode) WHERE AttributeDefaultValue IS NOT NULL;

			   ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId
			   , SUBSTRING( ( SELECT ','+ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'+ zm.PATH  
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue , SUBSTRING( ( SELECT ','+AttributeValue
			   FROM  @TBL_AttributeDetails AS TBAI
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId
			   FOR XML PATH('') ), 2 , 4000) MediaIds
			   FROM @TBL_AttributeDetails AS TBA
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))

		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;



			 INSERT INTO @TBL_FamilyDetails(PimAttributeFamilyId,PimProductId)
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId] @PimProductId,1;

             UPDATE TFD SET FamilyName = ZPFL.AttributeFamilyName FROM @TBL_FamilyDetails TFD INNER JOIN ZnodePimFamilyLocale ZPFL
			 ON(TFD.PimAttributeFamilyId = ZPFL.PimAttributeFamilyId AND LocaleId = @LocaleId);

             UPDATE TFD SET FamilyName = ZPFL.AttributeFamilyName FROM @TBL_FamilyDetails TFD INNER JOIN ZnodePimFamilyLocale ZPFL
			 ON(TFD.PimAttributeFamilyId = ZPFL.PimAttributeFamilyId AND LocaleId = @DefaultLocaleId) WHERE TFD.FamilyName IS NULL OR TFD.FamilyName = '';




             SELECT zpp.[PimProductId] AS [Productid],zpp.[PimProductId],ZPCP.[PimCategoryId],TBFD.FamilyName,[ProductName],[SKU],[ProductType],[Assortment],
             CASE WHEN ZPCP.Status IS NULL THEN CAST(0 AS BIT) ELSE CAST(ZPCP.Status AS BIT) END AS [Status],
			 piv.[ProductImage] [ImagePath],ZPCP.DisplayOrder

			 FROM @TBL_ProductIdTable AS zpp
			 LEFT JOIN ZnodePimCategoryProduct ZPCP ON(ZPCP.PimProductId = Zpp.PimProductId AND ZPCP.PimCategoryId = Zpp.PimCategoryId)
             INNER JOIN (SELECT PimProductId,AttributeValue,AttributeCode FROM @TBL_AttributeDetails) TB
			  PIVOT(MAX([AttributeValue])
			 FOR [AttributeCode] IN([ProductName],[IsActive],[ProductImage],[SKU],[ProductType],[Assortment])) AS Piv ON(Piv.[PimProductId] = zpp.[PimProductId])
             LEFT JOIN @TBL_FamilyDetails TBFD ON(TBFD.PimProductId = zpp.[PimProductId])
             ORDER BY CASE WHEN @Order_By LIKE '% DESC%' THEN CASE WHEN @OrderByDisplay = 1 THEN ZPCP.DisplayOrder
			 WHEN @OrderByDisplay = 2 THEN ZPCP.Status ELSE 1 END ELSE 1 END DESC,
             CASE WHEN @Order_By LIKE '% ASC%' THEN CASE WHEN @OrderByDisplay = 1 THEN ZPCP.DisplayOrder
             WHEN @OrderByDisplay = 2 THEN ZPCP.Status ELSE 1 END ELSE 1 END,zpp.RowId;
			   IF EXISTS (SELECT Top 1 1 FROM @TAb )
	 BEGIN

		  SELECT @RowsCount = (SELECT COUNT(1) FROM @TAb)
	 END
	 ELSE
	 BEGIN
	 		  SELECT @RowsCount=(SELECT COUNT(1) FROM @ProductListIdRTR)
	 END


         END TRY
         BEGIN CATCH
		  SELECT ERROR_MESSAGE()
            DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPimCategoryProductList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PimCategoryId='+CAST(@PimCategoryId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));

             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;

             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPimCategoryProductList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPortalGlobalAttributeValue')
BEGIN 
	DROP PROCEDURE Znode_GetPortalGlobalAttributeValue
END
GO
CREATE   PROCEDURE [dbo].[Znode_GetPortalGlobalAttributeValue]
(
    @EntityName       nvarchar(200) = 0,
    @GlobalEntityValueId   INT = 0,
	@LocaleCode       VARCHAR(100) = '',
    @GroupCode  nvarchar(200) = null,
	@SelectedValue bit = 0
)
AS
/*
	 Summary :- This procedure is used to get the Attribute and EntityValue attribute value as per filter pass 
	 Unit Testing 
	 BEGIN TRAN
	 EXEC [Znode_GetGlobalEntityAttributeValue] 'Store',1
	 ROLLBACK TRAN

*/	 
     BEGIN
 BEGIN TRY
 declare @EntityValue nvarchar(200), @LocaleId int

  DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);
          SET @V_MediaServerThumbnailPath =
         (
             SELECT ISNULL(CASE WHEN CDNURL = '' THEN NULL ELSE CDNURL END,URL)+ZMSM.ThumbnailFolderName+'/'  
             FROM ZnodeMediaConfiguration ZMC 
			 INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
		     WHERE IsActive = 1 
         );


 Select @EntityValue=StoreName from ZnodePortal
 Where PortalId=@GlobalEntityValueId

            Declare	@EntityAttributeList as	table  (GlobalEntityId int,EntityName nvarchar(300),EntityValue nvarchar(max),
			GlobalAttributeGroupId int,GlobalAttributeId int,AttributeTypeId int,AttributeTypeName nvarchar(300),
			 AttributeCode nvarchar(300) ,IsRequired bit,IsLocalizable bit,AttributeName  nvarchar(300) , HelpDescription nvarchar(max)
			,AttributeGroupDisplayOrder int,DisplayOrder int) 
			 
			Declare @EntityAttributeValidationList  as	table  
			( GlobalAttributeId int, ControlName nvarchar(300), ValidationName nvarchar(300),SubValidationName nvarchar(300),
			 RegExp nvarchar(300), ValidationValue nvarchar(300),IsRegExp Bit)

			Declare	@EntityAttributeValueList as	table  (GlobalAttributeId int,AttributeValue nvarchar(max),
			GlobalAttributeValueId int,GlobalAttributeDefaultValueId int,AttributeDefaultValueCode nvarchar(300),
			AttributeDefaultValue nvarchar(300),
			MediaId int,MediaPath nvarchar(300),IsEditable bit,DisplayOrder int )



			Declare	@EntityAttributeDefaultValueList as	table  (GlobalAttributeDefaultValueId int,GlobalAttributeId int,
			AttributeDefaultValueCode nvarchar(300),AttributeDefaultValue nvarchar(300),RowId int,IsEditable bit,DisplayOrder int )

			set @LocaleId = (select top 1 LocaleId from ZnodeLocale where Code = @LocaleCode)

			IF ISnull(@GroupCode, '') = '' 
            Begin
			
				insert into @EntityAttributeList
					(	GlobalEntityId ,EntityName ,EntityValue ,
					GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
					AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription ,AttributeGroupDisplayOrder,DisplayOrder ) 
					SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
					c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
					c.IsLocalizable,f.AttributeName,c.HelpDescription,w.AttributeGroupDisplayOrder,c.DisplayOrder
				 FROM dbo.ZnodeGlobalEntity AS qq
					  INNER JOIN dbo.ZnodeGlobalGroupEntityMapper AS w ON qq.GlobalEntityId = w.GlobalEntityId
					  INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = w.GlobalAttributeGroupId
					  INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
					  INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
					  INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
					  Where qq.EntityName=@EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
			END 
			Else 
			Begin
				insert into @EntityAttributeList
				(	GlobalEntityId ,EntityName ,EntityValue ,
				GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
				AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription ,AttributeGroupDisplayOrder,DisplayOrder ) 
				SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
				c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
				c.IsLocalizable, f.AttributeName, c.HelpDescription,w.AttributeGroupDisplayOrder,c.DisplayOrder
				FROM dbo.ZnodeGlobalEntity AS qq
					INNER JOIN dbo.ZnodeGlobalGroupEntityMapper AS w ON qq.GlobalEntityId = w.GlobalEntityId
					INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = w.GlobalAttributeGroupId
					INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
					INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
					INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
					--Inner JOIN ZnodeGlobalAttributeGroup g on ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId 
					Where qq.EntityName=@EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )					  
					AND exists( select 1 from ZnodeGlobalAttributeGroup g where ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId and g.GroupCode = @GroupCode )
 
			End 


		  INSERT INTO @EntityAttributeValidationList
		  (GlobalAttributeId,ControlName , ValidationName ,SubValidationName ,
		RegExp, ValidationValue,IsRegExp)

		 Select aa.GlobalAttributeId,i.ControlName,i.Name AS ValidationName,j.ValidationName AS SubValidationName,
		j.RegExp,k.Name AS ValidationValue,CAST(CASE WHEN j.RegExp IS NULL THEN 0 ELSE 1 END AS BIT) AS IsRegExp
		fROM @EntityAttributeList aa
		  inner  JOIN dbo.ZnodeGlobalAttributeValidation AS k ON k.GlobalAttributeId = aa.GlobalAttributeId
          inner  JOIN dbo.ZnodeAttributeInputValidation AS i ON k.InputValidationId = i.InputValidationId
          LEFT  JOIN dbo.ZnodeAttributeInputValidationRule AS j ON k.InputValidationRuleId = j.InputValidationRuleId

		  insert into @EntityAttributeValueList
		  (GlobalAttributeId,GlobalAttributeValueId,GlobalAttributeDefaultValueId,AttributeValue ,MediaId,MediaPath)
		  Select DISTINCT GlobalAttributeId,aa.PortalGlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
		  case when bb.MediaPath is not null then  @V_MediaServerThumbnailPath+bb.MediaPath--+'~'+convert(nvarchar(10),bb.MediaId) 
		  else bb.AttributeValue end,		  
		  bb.MediaId,bb.MediaPath
		  from  dbo.ZnodePortalGlobalAttributeValue aa
		   inner join ZnodePortalGlobalAttributeValueLocale bb ON bb.PortalGlobalAttributeValueId = aa.PortalGlobalAttributeValueId 
		  Where  PortalId=@GlobalEntityValueId

		

		  

		  update aa
		  Set AttributeDefaultValueCode= h.AttributeDefaultValueCode,
              AttributeDefaultValue=g.AttributeDefaultValue,
			  GlobalAttributeDefaultValueId=g.GlobalAttributeDefaultValueId,
			  AttributeValue=case when aa.AttributeValue is  null then h.AttributeDefaultValueCode else aa.AttributeValue end,
			  IsEditable = ISNULL(h.IsEditable, 1),DisplayOrder = h.DisplayOrder
		  from  @EntityAttributeValueList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeDefaultValueId = aa.GlobalAttributeDefaultValueId                                       
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
          
		  insert into @EntityAttributeDefaultValueList
		  (GlobalAttributeDefaultValueId,GlobalAttributeId,AttributeDefaultValueCode,
			AttributeDefaultValue ,RowId ,IsEditable ,DisplayOrder )
		  Select  h.GlobalAttributeDefaultValueId, aa.GlobalAttributeId,h.AttributeDefaultValueCode,g.AttributeDefaultValue,0,ISNULL(h.IsEditable, 1),
		  h.DisplayOrder
		  from  @EntityAttributeList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeId = aa.GlobalAttributeId
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
		  
		  if not exists (Select 1 from @EntityAttributeList )
			Begin
			insert into @EntityAttributeList
			(	GlobalEntityId ,EntityName ,EntityValue ,
			GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
			AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription  ) 
			SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,0 GlobalAttributeGroupId,
			0 GlobalAttributeId,0 AttributeTypeId,''AttributeTypeName,''AttributeCode,0 IsRequired,
			0 IsLocalizable,'' AttributeName,'' HelpDescription
			FROM dbo.ZnodeGlobalEntity AS qq
			 Where qq.EntityName=@EntityName 
			End

				

			SELECT  GlobalEntityId,EntityName,EntityValue,GlobalAttributeGroupId,
			AA.GlobalAttributeId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,
			IsLocalizable,AttributeName,ControlName,ValidationName,SubValidationName,RegExp,
			ValidationValue,cast(isnull(IsRegExp,0) as bit)  IsRegExp,
			HelpDescription,AttributeValue,GlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
			aab.AttributeDefaultValueCode,
			aab.AttributeDefaultValue,isnull(aab.RowId,0)   RowId,cast(isnull(aab.IsEditable,0) as bit)   IsEditable
			,bb.MediaId,AA.DisplayOrder
			fROM @EntityAttributeList AA				
			left join @EntityAttributeDefaultValueList aab on aab.GlobalAttributeId=AA.GlobalAttributeId	
			left join @EntityAttributeValidationList vl on vl.GlobalAttributeId=aa.GlobalAttributeId			
			LEFT JOIN @EntityAttributeValueList BB ON BB.GlobalAttributeId=AA.GlobalAttributeId		 
		    and ( (aab.GlobalAttributeDefaultValueId=bb.GlobalAttributeDefaultValueId	)
			or  ( bb.MediaId is not null and isnull(vl.ValidationName,'')='IsAllowMultiUpload'  and bb.GlobalAttributeDefaultValueId is null )
			or  ( bb.MediaId is  null and  bb.GlobalAttributeDefaultValueId is null ))
			order by  aa.DisplayOrder, aab.DisplayOrder

			SELECT 1 AS ID,CAST(1 AS BIT) AS Status;       
		  END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;
		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		    @ErrorCall NVARCHAR(MAX)= null       			 
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		 
          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetGlobalEntityValueAttributeValues',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO

	 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetProductFeedList')
BEGIN 
	DROP PROCEDURE Znode_GetProductFeedList
END
GO
CREATE PROCEDURE [dbo].[Znode_GetProductFeedList]  
(   @PortalId   VARCHAR(2000) = NULL,  
    @SKU     SelectColumnList READONLY,  
    @LocaleId   INT,  
    @FeedType   NVARCHAR(MAX) = NULL)  
AS  
/*  
Summary: This Procedure is used to get effective keyword feeding of Product list  
 SELECT * FROM ZnodePublishProductDetail  
 SELECT * FROM ZnodePublishProduct WHERE PublishCatalogId = 3  
 SELECT * FROM ZnodePortalCatalog   
 Unit Testing:  
 EXEC Znode_GetProductFeedList @PortalId='0',@ProductIds = '116,117,118'  
 ,@LocaleId=1,@FeedType='Bing'   
  
*/  
     BEGIN  
  BEGIN TRY  
         SET NOCOUNT ON;        
           
   IF OBJECT_ID('tempdb..#TBL_DomainName') is not null
			drop table #TBL_DomainName

		IF OBJECT_ID('tempdb..#TBL_SEODetails') is not null
			drop table #TBL_SEODetails

		IF OBJECT_ID('tempdb..#TBL_CompleteDetailes') is not null
			drop table #TBL_CompleteDetailes

		IF OBJECT_ID('tempdb..#TBL_CompleteDetailes') is not null
			drop table #TBL_CompleteDetailes

		IF OBJECT_ID('tempdb..#TBL_PortalIds') is not null
			drop table #TBL_PortalIds

		 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
         CREATE TABLE #TBL_DomainName 
         (PortalId   INT,
          DomainName NVARCHAR(300),
          RowId      INT
         );  	
         
         CREATE TABLE #TBL_SEODetails   
         (loc                   NVARCHAR(MAX),  
          lastmod               DATETIME,  
          [g:condition]         VARCHAR(100),  
          [description]         NVARCHAR(MAX),  
          [g:id]                INT,  
          link                  VARCHAR(100),  
          [g:identifier_exists] VARCHAR(200),  
          DomainName            NVARCHAR(300),  
          PortalId              INT  
    , SEOCode             NVARCHAR(4000)  
         );  
         CREATE TABLE #TBL_CompleteDetailes   
         (loc                   NVARCHAR(MAX),  
          lastmod               DATETIME,  
          [g:condition]         VARCHAR(100),  
          [description]         NVARCHAR(MAX),  
          [g:id]                INT,  
          link                  VARCHAR(100),  
          [g:identifier_exists] VARCHAR(200),  
          DomainName            NVARCHAR(300),  
          PortalId              INT,  
          [g:availability]      NVARCHAR(1000),  
          SKU                   NVARCHAR(MAX),  
    SEOCode               NVARCHAR(4000)  
         );  
         DECLARE @DefaultLocaleId INT=dbo.Fn_GetDefaultLocaleId()  ;
         CREATE TABLE #TBL_PortalIds (PortalId INT);  
   
         INSERT INTO #TBL_PortalIds  
         SELECT Zp.PortalId   
   FROM Znodeportal AS ZP   
   INNER JOIN ZnodePortalCatalog AS ZPC ON(ZPC.PortalId = Zp.PortalId)  
         INNER JOIN ZnodePublishCatalog AS ZPPC ON(ZPPC.PublishCatalogId = ZPC.PublishCatalogId)   
   INNER JOIN ZNodePublishProduct AS ZPP ON(ZPP.PublishCatalogId = ZPPC.PublishCatalogId)  
   INNER JOIN ZnodePublishProductDetail AS PPD ON (PPD.PublishProductId = ZPP.PublishProductId)  
         WHERE EXISTS(SELECT TOP 1 1 FROM @SKU AS Sp WHERE (sp.StringColumn  = PPD.SKU)  OR StringColumn = '0')  
   AND EXISTS(SELECT TOP 1 1 FROM DBO.Split(@PortalId, ',') AS Sp  
      WHERE(CAST(sp.Item AS INT)) = Zp.PortalId  OR @PortalId = '0')  
   AND EXISTS (SELECT TOP 1 1 FROM ZnodeDomain ZD WHERE ZP.PortalId = ZD.PortalId  
   AND IsActive = 1 AND ApplicationType = 'Webstore')  
   GROUP BY Zp.PortalId;   
  
         INSERT INTO #TBL_DomainName   
   SELECT  PortalId,DomainName,ROW_NUMBER() OVER(PARTITION BY PortalId ORDER BY DomainName)   
   FROM ZnodeDomain AS ZD   
         WHERE EXISTS(SELECT TOP 1 1 FROM #TBL_PortalIds AS TBP WHERE TBP.PortalId = ZD.PortalId)  
   AND IsActive = 1 AND ApplicationType = 'Webstore'  
    
  
  
         ;WITH Cte_SeoDetailsWithLocale  
         AS (  
   SELECT DISTINCT ZCSD.CMSSEODetailId,ZCSD.SEOURL AS loc,ZCSD.ModifiedDate AS lastmod,'new' AS [g:condition],ZCSDL.SEODescription AS [description],ZPCC.PublishProductId AS [g:id],  
             '' AS link,'false' AS [g:identifier_exists],TBDN.DomainName,ZPC.PortalId,ISNULL(ZCSDL.LocaleId, @DefaultLocaleId) AS LocaleId , ZCSD.SEOCode  
    FROM ZNodePublishProduct AS ZPCC   
    INNER JOIN ZnodePortalCatalog AS ZPC ON(ZPC.PublishCatalogId = ZPCC.PublishCatalogId)  
    LEFT JOIN ZnodePublishProductDetail AS PPD ON (PPD.PublishProductId = ZPCC.PublishProductId)  
             -- INNER JOIN @TBL_PortalIds TBLP ON (TBLP.PortalId = ZPC.PortalId)  
    LEFT JOIN ZnodeCMSSEODetail AS ZCSD ON(PPD.SKU = ZCSD.SEOCode and ZCSD.PortalId = ZPC.PortalId)  
             LEFT JOIN ZnodeCMSSEOType AS ZCST ON(ZCST.CMSSEOTypeId = ZCSD.CMSSEOTypeId AND ZCST.Name = 'Product')  
             LEFT JOIN ZnodeCMSSEODetailLocale AS ZCSDL ON(ZCSDL.CMSSEODetailId = ZCSD.CMSSEODetailId AND ZCSDL.LocaleId IN(@LocaleId, @DefaultLocaleId))  
             LEFT JOIN #TBL_DomainName AS TBDN ON(TBDN.RowId = 1 AND TBDN.PortalId = zpc.PortalId )   
    WHERE EXISTS(SELECT TOP 1 1 FROM @SKU AS Sp  
      WHERE (sp.StringColumn  = PPD.SKU) OR StringColumn = '0')  
   AND EXISTS(SELECT TOP 1 1 FROM #TBL_PortalIds AS TBP WHERE TBP.PortalId = ZPC.PortalId )  
    )  
  
         ,Cte_SeoDetailsWithFirstLocale  
         AS (  
    SELECT CMSSEODetailId,loc,lastmod,[g:condition],[description],[g:id],link,[g:identifier_exists],DomainName,PortalId,LocaleId,SEOCode  
             FROM Cte_SeoDetailsWithLocale   
    WHERE LocaleId = @LocaleId  
    )           
  ,Cte_SeoDetailsWithDefaultLocale  
         AS (  
    SELECT CMSSEODetailId,loc,lastmod,[g:condition],[description],[g:id],link,[g:identifier_exists],DomainName,PortalId,LocaleId,SEOCode  
             FROM Cte_SeoDetailsWithFirstLocale  
             UNION ALL  
             SELECT CMSSEODetailId,loc,lastmod,[g:condition],[description],[g:id],link,[g:identifier_exists],DomainName,PortalId,LocaleId,SEOCode  
             FROM Cte_SeoDetailsWithLocale AS CTSDWL  
             WHERE LocaleId = @DefaultLocaleId   
    AND NOT EXISTS(SELECT TOP 1 1 FROM Cte_SeoDetailsWithFirstLocale AS CTSDWDL WHERE CTSDWDL.CMSSEODetailId = CTSDWL.CMSSEODetailId))  
                
   INSERT INTO #TBL_SEODetails  
         SELECT DISTINCT loc,lastmod,[g:condition],[description],[g:id],link,[g:identifier_exists],DomainName,PortalId ,SEOCode  
   FROM Cte_SeoDetailsWithDefaultLocale;  
  
    
  
         INSERT INTO #TBL_CompleteDetailes  
         SELECT TBSD.loc,TBSD.lastmod,TBSD.[g:condition],TBSD.[description],TBSD.[g:id],TBSD.link,TBSD.[g:identifier_exists],TBSD.DomainName,TBSD.PortalId,  
         CASE WHEN SUM(ZI.Quantity) > 0 THEN 'In Stock' ELSE CASE WHEN @FeedType = 'Google' THEN 'Out Of Stock' ELSE 'Not In Stock' END  
         END AS [g:availability],ZPPD.SKU ,TBSD.SEOCode  
   FROM ZnodePublishProduct AS ZPP   
   LEFT JOIN #TBL_SEODetails AS TBSD ON(ZPP.PublishProductId = TBSD.[g:id] )  
         LEFT JOIN ZnodePublishProductDetail AS ZPPD ON(ZPPD.PublishProductId = ZPP.PublishProductId AND ZPPD.LocaleId = @LocaleId )  
         LEFT JOIN ZnodePortalWarehouse AS ZPW ON(ZPW.PortalId = TBSD.PortalId)  
         LEFT JOIN ZnodePortalAlternateWarehouse AS ZAPW ON(ZAPW.PortalWarehouseId = ZPW.PortalWarehouseId)  
         LEFT JOIN ZnodeInventory AS ZI ON(ZI.SKU = ZPPD.SKU AND (ZI.WarehouseId = ZPW.WarehouseId OR ZI.WarehouseId = ZAPW.WarehouseId))  
         WHERE EXISTS(SELECT TOP 1 1 FROM @SKU AS Sp WHERE (sp.StringColumn  = ZPPD.SKU) OR StringColumn = '0')  
   AND EXISTS(SELECT TOP 1 1 FROM #TBL_PortalIds AS TBP WHERE TBP.PortalId = TBSD.PortalId )  
         GROUP BY loc,lastmod,[g:condition],[description],[g:id],link,[g:identifier_exists],DomainName,TBSD.PortalId,ZPPD.SKU,ZPPD.LocaleId, TBSD.SEOCode;    
           
		    DECLARE @MediaConfiguration NVARCHAR(2000)=((SELECT TOP 1 ISNULL(CASE WHEN CDNURL = '' THEN NULL ELSE CDNURL END,URL) FROM ZnodeMediaConfiguration WHERE IsActive = 1));    
  
         ;WITH Cte_PortalList  
         AS (  
       SELECT zp.PortalId,dbo.Fn_GetDefaultPriceRoundOff(ZPS.RetailPrice)RetailPrice,Zps.SKU,TBCD.SEOCode,ROW_NUMBER() OVER(PARTITION BY Zps.SKU,zp.PortalId ORDER BY ZPS.RetailPrice) AS RowId  
             FROM ZnodePriceList AS ZPL   
    LEFT JOIN ZnodePriceListPortal AS ZPLP ON ZPL.PriceListId = ZPLP.PriceListId  
             LEFT JOIN dbo.ZnodeCulture AS zc ON ZPL.CultureId = zc.CultureId
    LEFT JOIN dbo.ZnodePortal AS zp ON ZPLP.PortalId = zp.PortalId  
             LEFT JOIN ZnodePrice AS Zps ON(Zps.PriceListId = ZPL.PriceListId)   
    LEFT JOIN #TBL_CompleteDetailes AS TBCD ON(TBCD.PortalId = Zp.PortalId AND TBCD.SKU = Zps.Sku)   
    WHERE CAST(@GetDate AS DATE) BETWEEN ZPL.ActivationDate AND ZPL.ExpirationDate   
    AND EXISTS( SELECT TOP 1 1 FROM #TBL_PortalIds AS TBP WHERE TBP.PortalId = ZPLP.PortalId)   
    GROUP BY zp.PortalId,ZPS.RetailPrice,Zps.SKU ,TBCD.SEOCode  
    )  
  
         SELECT loc,lastmod,[g:condition],[description],[g:id],link,[g:availability],[g:identifier_exists],DomainName,TBCD.PortalId  
  ,CTPL.RetailPrice AS [g:price]  
   ,@MediaConfiguration AS MediaConfiguration, TBCD.SEOCode  
         FROM #TBL_CompleteDetailes AS TBCD   
   LEFT JOIN Cte_PortalList AS CTPL ON(CTPL.PortalId = TBCD.PortalId AND CTPL.SKU = TBCD.SKU AND CTPL.RowID = 1)  
   WHERE  EXISTS(SELECT TOP 1 1 FROM #TBL_PortalIds AS TBP WHERE TBP.PortalId = TBCD.PortalId )  
  

    IF OBJECT_ID('tempdb..#TBL_DomainName') is not null
			drop table #TBL_DomainName

		IF OBJECT_ID('tempdb..#TBL_SEODetails') is not null
			drop table #TBL_SEODetails

		IF OBJECT_ID('tempdb..#TBL_CompleteDetailes') is not null
			drop table #TBL_CompleteDetailes

		IF OBJECT_ID('tempdb..#TBL_CompleteDetailes') is not null
			drop table #TBL_CompleteDetailes

		IF OBJECT_ID('tempdb..#TBL_PortalIds') is not null
			drop table #TBL_PortalIds

 END TRY  
 BEGIN CATCH  
  DECLARE @Status BIT ;  
  SET @Status = 0;  
  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductFeedList @PortalId = '+@PortalId+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@FeedType='+CAST(@FeedType AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
        SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
        EXEC Znode_InsertProcedureErrorLog  
   @ProcedureName = 'Znode_GetProductFeedList',  
   @ErrorInProcedure = @Error_procedure,  
   @ErrorMessage = @ErrorMessage,  
   @ErrorLine = @ErrorLine,  
   @ErrorCall = @ErrorCall;  
 END CATCH  
   
  END;
GO


IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetUserGlobalAttributeValue')
BEGIN 
	DROP PROCEDURE Znode_GetUserGlobalAttributeValue
END
GO
CREATE PROCEDURE [dbo].[Znode_GetUserGlobalAttributeValue]
(
    @EntityName       nvarchar(200) = 0,
    @GlobalEntityValueId   INT = 0,
	@LocaleCode       VARCHAR(100) = '',
    @GroupCode  nvarchar(200) = null,
	@SelectedValue bit = 0
	
)
AS
/*
	 Summary :- This procedure is used to get the Attribute and EntityValue attribute value as per filter pass 
	 Unit Testing 
	 BEGIN TRAN
	 EXEC [Znode_GetGlobalEntityAttributeValue] 'Store',1
	 ROLLBACK TRAN

*/	 
     BEGIN
 BEGIN TRY
DECLARE @EntityValue nvarchar(200), @LocaleId int

  DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);
          SET @V_MediaServerThumbnailPath =
         (
             SELECT ISNULL(CASE WHEN CDNURL = '' THEN NULL ELSE CDNURL END,URL)+ZMSM.ThumbnailFolderName+'/'  
             FROM ZnodeMediaConfiguration ZMC 
			 INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
		     WHERE IsActive = 1 
         );


		 Select @EntityValue=Isnull(FirstName,'')+' '+Isnull(LastName,'')
		  from ZnodeUser
		 Where UserId=@GlobalEntityValueId

            Declare	@EntityAttributeList as	table  (GlobalEntityId int,EntityName nvarchar(300),EntityValue nvarchar(max),
			GlobalAttributeGroupId int,GlobalAttributeId int,AttributeTypeId int,AttributeTypeName nvarchar(300),
			 AttributeCode nvarchar(300) ,IsRequired bit,IsLocalizable bit,AttributeName  nvarchar(300) , HelpDescription nvarchar(max),DisplayOrder int
			) 
			 
			Declare @EntityAttributeValidationList  as	table  
			( GlobalAttributeId int, ControlName nvarchar(300), ValidationName nvarchar(300),SubValidationName nvarchar(300),
			 RegExp nvarchar(300), ValidationValue nvarchar(300),IsRegExp Bit)

			Declare	@EntityAttributeValueList as	table  (GlobalAttributeId int,AttributeValue nvarchar(max),
			GlobalAttributeValueId int,GlobalAttributeDefaultValueId int,AttributeDefaultValueCode nvarchar(300),
			AttributeDefaultValue nvarchar(300),
			MediaId int,MediaPath nvarchar(300),IsEditable bit,DisplayOrder int )



			Declare	@EntityAttributeDefaultValueList as	table  (GlobalAttributeDefaultValueId int,GlobalAttributeId int,
			AttributeDefaultValueCode nvarchar(300),AttributeDefaultValue nvarchar(300),RowId int,IsEditable bit,DisplayOrder int )

			 set @LocaleId = (select top 1 LocaleId from ZnodeLocale where Code = @LocaleCode)


			IF ISnull(@GroupCode, '') = '' 
            Begin
                insert into @EntityAttributeList
                    (   GlobalEntityId ,EntityName ,EntityValue ,
                    GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
                    AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription,DisplayOrder ) 
                    SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
                    c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
                    c.IsLocalizable,f.AttributeName,c.HelpDescription,c.DisplayOrder
                 FROM dbo.ZnodeGlobalEntity AS qq
                      INNER JOIN dbo.ZnodeGlobalGroupEntityMapper AS w ON qq.GlobalEntityId = w.GlobalEntityId
                      INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = w.GlobalAttributeGroupId
                      INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
                      INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
                      INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
                      Where qq.EntityName = @EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
            END 
            Else 
            Begin
                insert into @EntityAttributeList
                    (   GlobalEntityId ,EntityName ,EntityValue ,
                    GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
                    AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription,DisplayOrder ) 
                    SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
                    c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
                    c.IsLocalizable,f.AttributeName,c.HelpDescription,c.DisplayOrder
                 FROM dbo.ZnodeGlobalEntity AS qq
                      INNER JOIN dbo.ZnodeGlobalGroupEntityMapper AS w ON qq.GlobalEntityId = w.GlobalEntityId
                      INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = w.GlobalAttributeGroupId
                      INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
                      INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
                      INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
                    --  Inner JOIN ZnodeGlobalAttributeGroup g on ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId 
                      Where qq.EntityName=@EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
                      AND exists( select 1 from ZnodeGlobalAttributeGroup g where ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId and g.GroupCode = @GroupCode )
            END
	

		  INSERT INTO @EntityAttributeValidationList
		  (GlobalAttributeId,ControlName , ValidationName ,SubValidationName ,
		RegExp, ValidationValue,IsRegExp)

		 Select aa.GlobalAttributeId,i.ControlName,i.Name AS ValidationName,j.ValidationName AS SubValidationName,
		j.RegExp,k.Name AS ValidationValue,CAST(CASE WHEN j.RegExp IS NULL THEN 0 ELSE 1 END AS BIT) AS IsRegExp
		
		fROM @EntityAttributeList aa
		  inner  JOIN dbo.ZnodeGlobalAttributeValidation AS k ON k.GlobalAttributeId = aa.GlobalAttributeId
          inner  JOIN dbo.ZnodeAttributeInputValidation AS i ON k.InputValidationId = i.InputValidationId
          LEFT  JOIN dbo.ZnodeAttributeInputValidationRule AS j ON k.InputValidationRuleId = j.InputValidationRuleId

		  insert into @EntityAttributeValueList
		  (GlobalAttributeId,GlobalAttributeValueId,GlobalAttributeDefaultValueId,AttributeValue ,MediaId,MediaPath)
		  Select GlobalAttributeId,aa.UserGlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
		  case when bb.MediaPath is not null then  @V_MediaServerThumbnailPath+bb.MediaPath--+'~'+convert(nvarchar(10),bb.MediaId) 
		  else bb.AttributeValue end,		  
		  bb.MediaId,bb.MediaPath
		  from  dbo.ZnodeUserGlobalAttributeValue aa
		   inner join ZnodeUserGlobalAttributeValueLocale bb ON bb.UserGlobalAttributeValueId = aa.UserGlobalAttributeValueId 
		  Where  UserId=@GlobalEntityValueId

		 update aa
		  Set AttributeDefaultValueCode= h.AttributeDefaultValueCode,
              AttributeDefaultValue=g.AttributeDefaultValue,
			  GlobalAttributeDefaultValueId=g.GlobalAttributeDefaultValueId,
			  AttributeValue=case when aa.AttributeValue is  null then h.AttributeDefaultValueCode else aa.AttributeValue end, 
			  IsEditable = ISNULL(h.IsEditable, 1),DisplayOrder = h.DisplayOrder
		  from  @EntityAttributeValueList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeDefaultValueId = aa.GlobalAttributeDefaultValueId                                       
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
          
		  insert into @EntityAttributeDefaultValueList
		  (GlobalAttributeDefaultValueId,GlobalAttributeId,AttributeDefaultValueCode,
			AttributeDefaultValue ,RowId ,IsEditable ,DisplayOrder )
		  Select  h.GlobalAttributeDefaultValueId, aa.GlobalAttributeId,h.AttributeDefaultValueCode,g.AttributeDefaultValue,0,ISNULL(h.IsEditable, 1),
		  h.DisplayOrder
		  from  @EntityAttributeList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeId = aa.GlobalAttributeId
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
		  
		   if not exists (Select 1 from @EntityAttributeList )
			Begin
				insert into @EntityAttributeList
				(	GlobalEntityId ,EntityName ,EntityValue ,
				GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
				AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription  ) 
				SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,0 GlobalAttributeGroupId,
				0 GlobalAttributeId,0 AttributeTypeId,''AttributeTypeName,''AttributeCode,0 IsRequired,
				0 IsLocalizable,'' AttributeName,'' HelpDescription
				FROM dbo.ZnodeGlobalEntity AS qq
				 Where qq.EntityName=@EntityName 
			End
				

			SELECT GlobalEntityId,EntityName,EntityValue,GlobalAttributeGroupId,
			AA.GlobalAttributeId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,
			IsLocalizable,AttributeName,ControlName,ValidationName,SubValidationName,RegExp,
			ValidationValue,cast(isnull(IsRegExp,0) as bit)  IsRegExp,
			HelpDescription,AttributeValue,GlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
			aab.AttributeDefaultValueCode,
			aab.AttributeDefaultValue,isnull(aab.RowId,0)   RowId,cast(isnull(aab.IsEditable,0) as bit)   IsEditable
			,bb.MediaId,AA.DisplayOrder
			fROM @EntityAttributeList AA				
			left join @EntityAttributeDefaultValueList aab on aab.GlobalAttributeId=AA.GlobalAttributeId	
			left join @EntityAttributeValidationList vl on vl.GlobalAttributeId=aa.GlobalAttributeId			
			LEFT JOIN @EntityAttributeValueList BB ON BB.GlobalAttributeId=AA.GlobalAttributeId		 
		    and ( (aab.GlobalAttributeDefaultValueId=bb.GlobalAttributeDefaultValueId	)
			or  ( bb.MediaId is not null and isnull(vl.ValidationName,'')='IsAllowMultiUpload'  and bb.GlobalAttributeDefaultValueId is null )
			or  ( bb.MediaId is  null and  bb.GlobalAttributeDefaultValueId is null ))
			order by AA.DisplayOrder,aab.DisplayOrder

			SELECT 1 AS ID,CAST(1 AS BIT) AS Status;       
		  END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;
		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		    @ErrorCall NVARCHAR(MAX)= null       			 
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		 
          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetGlobalEntityValueAttributeValues',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO

	 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_ManageLinkProductList')
BEGIN 
	DROP PROCEDURE Znode_ManageLinkProductList
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageLinkProductList]
(   @WhereClause      XML,
    @Rows             INT          = 100,
    @PageNo           INT          = 1,
    @Order_BY         VARCHAR(100) = '',
    @RowsCount        INT OUT,
    @LocaleId         INT          = 1,
    @RelatedProductId INT          = 0,
    @PimAttributeId   INT          = 0)
AS
   /*  Summary :- This Procedure is used to find the link product Detail
     Unit Testing
     EXEC Znode_ManageLinkProductList '' , @RowsCount = 0 ,@RelatedProductId=128
   */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @PimProductIds TransferId, --VARCHAR(MAX),
					 @PimAttributeIds VARCHAR(MAX),
					 @OutPimProductIds VARCHAR(max);
             DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();
             DECLARE @TransferPimProductId TransferId
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

		     DECLARE @TBL_LinkProductDetail TABLE
             (PimProductId           INT,
              PimLinkProductDetailId INT,
              RelatedProductId       INT,
              PimAttributeId         INT
             );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             DECLARE @DefaultAttributeFamily INT=
             (
                 SELECT PimAttributeFamilyId
                 FROM ZnodePimAttributeFamily
                 WHERE IsCategory = 0
                       AND IsDefaultFamily = 1
             );
             DECLARE @ProductIdTable TABLE
             (PimProductId INT,
              CountId      INT,
              RowId        INT IDENTITY(1,1)
             );
             INSERT INTO @TBL_LinkProductDetail
             (PimProductId,
              PimLinkProductDetailId,
              RelatedProductId,
              PimAttributeId
             )
                    SELECT PimProductId,
                           PimLinkProductDetailId,
                           PimParentProductId,
                           PimAttributeId
                    FROM ZnodePimLinkProductDetail
                    WHERE PimParentProductId = @RelatedProductId
                          AND PimAttributeId = @PimAttributeId;

				INSERT INTO @TransferPimProductId
                SELECT PimProductId
                FROM @TBL_LinkProductDetail

			 IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId)
			 BEGIN
			  INSERT INTO @TransferPimProductId
			  SELECT '-1'

             END
			 DECLARE @AttributeCode NVARCHAR(max)
			 SET @AttributeCode = SUBSTRING ((SELECT ','+AttributeCode FROM [dbo].[Fn_GetProductGridAttributes]()  WHERE AttributeCode NOT IN ('AttributeFamily') FOR XML PATH('') ),2,4000)

			 EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = @AttributeCode,
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = 0,
				  @OutProductId = @OutPimProductIds OUT;


			 INSERT INTO @ProductIdTable
             (PimProductId)
			 SELECT item
			 FROM dbo.split(@OutPimProductIds,',') SP

			 --SET @PimProductIds = SUBSTRING(
    --                                       (
    --                                           SELECT ','+CAST(PimProductId AS VARCHAR(100))
    --                                           FROM @ProductIdTable
    --                                           FOR XML PATH('')
    --                                       ), 2, 4000);

			INSERT INTO @PimProductIds ( Id )
			SELECT item
			FROM dbo.split(@OutPimProductIds,',') SP

             SET @PimAttributeIds = SUBSTRING( (SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000);

			 INSERT INTO @TBL_AttributeDefaultValue
             (PimAttributeId,
              AttributeDefaultValueCode,
              IsEditable,
              AttributeDefaultValue,
			  DisplayOrder
             )
             EXEC Znode_GetAttributeDefaultValueLocale
                  @PimAttributeIds,
                  @LocaleId;
             INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )
             EXEC [Znode_GetProductsAttributeValue]
                  @PimProductIds,
                  @PimAttributeIds,
                  @localeId;
             WITH Cte_UpdateDefaultAttributeValue
                  AS (SELECT PimProductId,
                             AttributeCode,
                             AttributeValue,
                             SUBSTRING(
                                      (
                                          SELECT ','+TBADV.AttributeDefaultValue
                                          FROM @TBL_AttributeDefaultValue TBADV
                                               INNER JOIN ZnodePimAttribute TBAC ON(TBADV.PimAttributeId = TBAC.PimAttributeId)
                                          WHERE TBAC.AttributeCode = TBAD.AttributeCode
                                                AND EXISTS
                                          (
                                              SELECT TOP 1 1
                                              FROM dbo.split(TBAD.AttributeValue, ',') SP
                                              WHERE Sp.item = TBADV.AttributeDefaultValueCode
                                          )
                                          FOR XML PATH('')
                                      ), 2, 4000) AttributeDefaultValue
                      FROM @TBL_AttributeDetails TBAD)
                  UPDATE TBAD
                    SET AttributeValue = CTUDAV.AttributeDefaultValue
                  FROM @TBL_AttributeDetails TBAD
                       INNER JOIN Cte_UpdateDefaultAttributeValue CTUDAV ON(CTUDAV.PimProductId = TBAD.PimProductId
                                                                            AND CTUDAV.AttributeCode = TBAD.AttributeCode)
                  WHERE AttributeDefaultValue IS NOT NULL;
             INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1;
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';

			 ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId
			  , SUBSTRING( ( SELECT ','+ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'+ zm.PATH  
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue
			   FROM @TBL_AttributeDetails AS TBA
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))

		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;



			INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT PimProductId ,FamilyName, 'AttributeFamily',NULL
			FROM @FamilyDetails

				-- LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
             --- Update the  product families name locale wise
        UPDATE  @TBL_AttributeDetails SET PimAttributeId = 0 WHERE PimAttributeId IS nULL
	     DECLARE @ProductXML XML

		--SELECT * FROM @TBL_AttributeDetails

	   	 SET @ProductXML =   '<MainProduct>'+ STUFF( (  SELECT '<Product>'
		                                                    +'<PimLinkProductDetailId>'+CAST(ISNULL(TBLPD.PimLinkProductDetailId,'') AS VARCHAR(50))+'</PimLinkProductDetailId>'
															+'<PimProductId>'+CAST(zpp.PimProductId AS VARCHAR(50))+'</PimProductId>'
															+'<RelatedProductId>'+CAST(ISNULL(TBLPD.RelatedProductId,'') AS VARCHAR(50))+'</RelatedProductId>'

		 + STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST( (SELECT ''+TBADI.AttributeValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'
															FROM @TBL_AttributeDetails TBADI
															 WHERE TBADI.PimProductId = zpp.PimProductId
															 ORDER BY TBADI.PimProductId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Product>'

			 FROM @ProductIdTable AS zpp
             LEFT JOIN @TBL_LinkProductDetail AS TBLPD ON(TBLPD.PimProductId = ZPP.PimProductId)
             ORDER BY zpp.RowId
			FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainProduct>'
			--FOR XML PATH ('MainProduct'))


			SELECT  @ProductXML  ProductXMl

		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1
			 AND  IsCategory = 0
			 AND ZPA.IsShowOnGrid = 1
			 UNION ALL
			 SELECT 'PublishStatus','Publish Status'


			SELECT @RowsCount AS RowsCount;













			 --SELECT zpp.PimProductid AS ProductId,
    --                [ProductName],
    --                ProductType,
    --                ISNULL(zf.FamilyName, '') AS AttributeFamily,
    --                [SKU],
    --                [Price],
    --                [Quantity],
    --                CASE
    --                    WHEN [IsActive] IS NULL
    --                    THEN CAST(0 AS BIT)
    --                    ELSE CAST([IsActive] AS BIT)
    --                END AS [IsActive],
    --                PimLinkProductDetailId,
    --                RelatedProductId,
    --                TBLPD.PimAttributeId,
    --                [dbo].FN_GetMediaThumbnailMediaPath(zm.Path) AS ImagePath,
    --                [Assortment],
    --                @LocaleId AS LocaleId,
    --                [DisplayOrder]
    --         FROM @ProductIdTable AS zpp
    --              INNER JOIN @TBL_LinkProductDetail AS TBLPD ON(TBLPD.PimProductId = ZPP.PimProductId)
    --              LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
    --              INNER JOIN
    --         (
    --             SELECT PimProductId,
    --                    AttributeValue,
    --                    AttributeCode
    --             FROM @TBL_AttributeDetails
    --         ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
    --                                                             [SKU],
    --                                                             [Price],
    --                                                             [Quantity],
    --                                                             [IsActive],
    --                                                             [ProductType],
    --                                                             [ProductImage],
    --                                                             [Assortment],
    --                                                             [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
    --              LEFT JOIN ZnodeMedia AS zm ON(zm.MediaId = piv.[ProductImage])
    --         ORDER BY zpp.RowId;
         END TRY
         BEGIN CATCH

              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageLinkProductList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@RelatedProductId='+CAST(@RelatedProductId AS VARCHAR(50))+',@PimAttributeId='+CAST(@PimAttributeId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));

             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;

             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageLinkProductList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO

    
 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetMediaAssociatedStoreList')
BEGIN 
	DROP PROCEDURE Znode_GetMediaAssociatedStoreList
END
GO

CREATE PROCEDURE [dbo].[Znode_GetMediaAssociatedStoreList]
( 
	@MediaPath NVARCHAR(MAX) 
)
AS
/*
	Summary : This procedure is used to get PortalId for associated store of media
	Unit Testing:
	EXEC [Znode_GetAssociatedStoreOfMedia] ='d9a98db6-52df-4692-b7ae-b50f55980dc8grapes.jpg'
	
*/
     BEGIN
         SET NOCOUNT ON;
		 BEGIN TRY
				DECLARE @Tbl_Portal TABLE (PortalId INT)

				INSERT INTO @Tbl_Portal (PortalId)
				SELECT DISTINCT ptc.[PortalId] from ZnodePimProductAttributeMedia pam 
				INNER JOIN ZnodePimAttributeValue pav on pav.PimAttributeValueId=pam.PimAttributeValueId
				INNER JOIN ZnodePimProduct pp on pp.PimProductId=pav.PimProductId
				INNER JOIN ZnodePimCatalogCategory pcc on pcc.PimProductId=pp.PimProductId
				INNER JOIN ZnodePublishCatalog pc on pc.PimCatalogId=pcc.PimCatalogId
				INNER JOIN ZnodePortalCatalog ptc on ptc.PublishCatalogId=pc.PublishCatalogId
				where pam.MediaPath=@MediaPath
				UNION ALL
				SELECT DISTINCT ZPC.[PortalId]
				FROM ZnodePortal ZPC 
				CROSS APPLY ZnodeBrandDetails ZBD  
				INNER JOIN ZnodeBrandDetailLocale ZBDL ON(ZBD.BrandId = ZBDL.BrandId) 
				--LEFT JOIN ZnodeBrandPortal ZBP ON (ZBP.BrandId = ZBD.BrandId AND ZBP.PortalId = ZPC.PortalId) 
				INNER JOIN ZnodeMedia ZM ON(ZM.MediaId = ZBD.MediaId)
				where ZM.Path=@MediaPath
				UNION ALL
				SELECT DISTINCT PortalId
				from ZnodePimCategoryAttributeValue pam 
				INNER JOIN ZnodePimCategoryAttributeValueLocale pav on pav.PimCategoryAttributeValueId=pam.PimCategoryAttributeValueId
				INNER JOIN ZnodePimCatalogCategory pcc on (pcc.PimCategoryId = pam.PimCategoryId)
				INNER JOIN ZnodePublishCatalog pc on pc.PimCatalogId=pcc.PimCatalogId
				INNER JOIN ZnodePortalCatalog ptc on ptc.PublishCatalogId=pc.PublishCatalogId
				INNER JOIN Znodemedia ZM on (CAST(ZM.mediaid AS NVARCHAR(MAX)) = pav.categoryvalue)
				WHERE pam.PimAttributeId in (SELECT pimattributeid from ZnodePimAttribute where IsCategory =1 and AttributeCode = 'Categoryimage')
				AND ZM.Path=@MediaPath

				SELECT DISTINCT PortalId FROM @Tbl_Portal

		END TRY
		BEGIN CATCH
	
		  DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetMediaAssociatedStoreList @MediaPath = '+@MediaPath;
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetMediaAssociatedStoreList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
		END CATCH

     END;

	GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPublishProductPricingBySku')
BEGIN 
	DROP PROCEDURE Znode_GetPublishProductPricingBySku
END
GO


CREATE PROCEDURE [dbo].[Znode_GetPublishProductPricingBySku]
(   
    @SKU              VARCHAR(MAX),
    @PortalId         INT,
    @currentUtcDate   VARCHAR(100), -- this date is required for the user date r
    @UserId           INT          = 0, -- userid is optional
	@ProfileId        INT          = 0, 
    @PublishProductId TransferId READONLY,
	@IsDebug          BIT          = 0
	)
AS 
   /* 
    --Summary: Retrive Price of product from pricelist
    --Input Parameters:
    --UserId, SKU(Comma separated multiple), PortalId
    --Conditions :
    --1. If userId is null then check for PriceList having sku associated to profile which is associated to Portal having  PortalId and  having higher Precedence and valid ActivationDate and ExpirationDate for PriceList  and SKU also.
    --Unit Testing : 
    --EXEC Znode_GetPublishProductPricingBySku_2 @SKU = 'apple,apr234' , @PortalId = 34 , @currentUtcDate = '2016-09-17 00:00:00.000';
    --2. If There is no any PriceList having given sku associated to profile  then check for  
    --PriceList associated portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --Unit Testing : 
    --EXEC Znode_GetPublishProductPricingBySku_2 @SKU = 'apple,apr234' , @PortalId = 34 , @currentUtcDate = '2016-09-17 00:00:00.000';
    --3. If userId is not null then check for PriceList having sku associated to User having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --4. If There is no any PriceList having given sku associated to user  then check for  
    --PriceList associated Account having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --5. If There is no any PriceList having given sku associated to account  then check for  
    --PriceList associated Profile having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --6. If There is no any PriceList having given sku associated to Profile  then check for  
    --PriceList associated Portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --7. If in each case Precedence is same then get PriceList according to higher PriceListId ActivationDate and ExpirationDate for PriceList and SKU also.
    --8. Also get the Tier Price, Tier Quantity of given sku.
    --Unit Testing   
    --Exec Znode_GetPublishProductPricingBySku  @SKU = 'Levi''s T-Shirt & Jeans - Bundle Product',@PortalId = 1, @currentUtcDate = '2016-07-31 00:00:00.000'
	*/
    
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @Tlb_SKU TABLE
             (SKU        VARCHAR(100),
              SequenceNo INT IDENTITY
             );

			  DECLARE @DefaultLocaleId INT = dbo.FN_GETDEFAULTLocaleId()

			 IF @SKU = '' 
			 BEGIN 
			  INSERT INTO @Tlb_SKU(SKU)
			  	SELECT SKU
					FROM ZnodePublishProductDetail a
					INNER JOIN @PublishProductId b ON (b.Id = a.PublishProductId )
					WHERE LocaleId = @DefaultLocaleId


			 END 
			 ELSE 
			 BEGIN
			   INSERT INTO @Tlb_SKU(SKU)
                    SELECT Item
                    FROM Dbo.split(@SKU, ',');
			  

			 END 

           
            -- DECLARE #TLB_SKUPRICELIST TABLE
          CREATE TABLE #TLB_SKUPRICELIST
		     (SKU          VARCHAR(100),
              RetailPrice  NUMERIC(28, 6),
              SalesPrice   NUMERIC(28, 6),
              PriceListId  INT,
              TierPrice    NUMERIC(28, 6),
              TierQuantity NUMERIC(28, 6),
			  ExternalId NVARCHAR(2000),
			  Custom1 NVARCHAR(MAX),
			  Custom2 NVARCHAR(MAX),
			  Custom3 NVARCHAR(MAX)
             );
             DECLARE @PriceListId INT, @PriceRoundOff INT;
             SELECT @PriceRoundOff = CONVERT( INT, FeatureValues)
             FROM ZnodeGlobalSetting
             WHERE FeatureName = 'PriceRoundOff';
		
             --Retrive portal wise pricelist  
             --DECLARE #Tbl_PortalWisePriceList TABLE
             CREATE TABLE #Tbl_PortalWisePriceList  
			 (PriceListId    INT,
              ActivationDate DATETIME,
              ExpirationDate DATETIME NULL,
              Precedence     INT,
			  SKU NVARCHAR(300)
             );
             --Retrive price for respective pricelist   
             Create TABLE  #Tbl_PriceListWisePriceData 
             (
				  PriceListId    INT,
				  SKU            VARCHAR(300),
				  SalesPrice     NUMERIC(28, 6),
				  RetailPrice    NUMERIC(28, 6),
				  UomId          INT,
				  UnitSize       NUMERIC(28, 6),
				  ActivationDate DATETIME,
				  ExpirationDate DATETIME NULL,
				  TierPrice      NUMERIC(28, 6),
				  TierQuantity   NUMERIC(28, 6),
				  TierUomId      INT,
				  TierUnitSize   NUMERIC(28, 6), 
				  ExternalId NVARCHAR(2000),
				  Custom1 NVARCHAR(MAX),
				  Custom2 NVARCHAR(MAX),
				  Custom3 NVARCHAR(MAX)
             );
			-- DECLARE #Tbl_SKUWisePriceList TABLE 
			 Create table #Tbl_SKUWisePriceList(PriceListId INT, SKU NVARCHAR(300))

			 insert into #Tbl_SKUWisePriceList(PriceListId,SKU) 
			 SELECT  PriceListId,SKU from ZnodePrice where (SELECT ''+SKU FOR XML PATH('')) in (Select SKU from @Tlb_SKU )
			 Union
			 SELECT PriceListId,SKU  from ZnodePriceTier where (SELECT ''+SKU FOR XML PATH('')) in (Select SKU from @Tlb_SKU )
			 
			 --1. If userId is null then check for PriceList having sku associated to profile which is associated to Portal having  PortalId and  having higher Precedence and valid ActivationDate and ExpirationDate for PriceList  and SKU also.
            IF @UserId = 0
                 BEGIN
					INSERT INTO #Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
					SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
					FROM ZnodePriceList AS a INNER JOIN ZnodePriceListProfile AS b ON a.PriceListId = b.PriceListId INNER JOIN ZnodePortalProfile AS c
						ON b.PortalProfileId = c.PortalProfileID AND  c.IsDefaultAnonymousProfile = 1 INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId 
						inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
					WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND c.PortalId = @PortalId
					ORDER BY b.Precedence;
		
			 
                     --2. If There is no any PriceList having given sku associated to profile  then check for PriceList associated portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
			IF Exists (Select top 1 1  FROM #Tbl_SKUWisePriceList tspl where NOT Exists (SELECT TOP 1 1 FROM #Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))
                         BEGIN
							INSERT INTO #Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
							SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
							FROM ZnodePriceList AS a INNER JOIN ZnodePriceListPortal AS b ON a.PriceListId = b.PriceListId
							INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId   
							inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
							AND NOT EXISTS (Select TOP 1 1 FROM  #Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
							WHERE @CurrentUtcDate BETWEEN a.ActivationDate 
							AND ISNULL(a.ExpirationDate, @GetDate) AND b.PortalId = @PortalId
							ORDER BY b.Precedence
							;
							--Delete from #Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  #Tbl_PortalWisePriceList )
						
                         END;
                 END;
                     --3. If userId is not null then check for PriceList having sku associated to User having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
             ELSE
                 BEGIN
				 
                     INSERT INTO #Tbl_PortalWisePriceList (PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
                            SELECT a.PriceListId, ActivationDate,ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
                            FROM ZnodePriceList AS a INNER JOIN ZnodePriceListUser AS b ON a.PriceListId = b.PriceListId
                                 INNER JOIN ZnodePortalunit zupu ON a.CultureId = zupu.CultureId AND zupu.PortalId = @PortalId  
								 inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
								 AND NOT EXISTS (Select TOP 1 1 FROM  #Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
                            WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND b.UserID = @UserId
							ORDER BY b.Precedence ;

                --4. If There is no any PriceList having given sku associated to user  then check for PriceList associated Account having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
				IF Exists (Select top 1 1  FROM #Tbl_SKUWisePriceList tspl where NOT Exists (SELECT TOP 1 1 FROM #Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))
						BEGIN
							INSERT INTO #Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
								   SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), c.Precedence,tsw.SKU
								   FROM ZnodePriceList AS a INNER JOIN ZnodePriceListAccount AS c ON a.PriceListId = c.PriceListId
										INNER JOIN ZnodeUser AS d ON c.Accountid = d.Accountid INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId   
										AND zupu.PortalId = @PortalId
										inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
										AND NOT EXISTS (Select TOP 1 1 FROM  #Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
								   WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND d.UserID = @UserId
									ORDER BY c.Precedence
							--Delete from #Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  #Tbl_PortalWisePriceList )
						 END;
                     -- 5. If There is no any PriceList having given sku associated to account  then check for PriceList associated Profile having PortalId and having higher   Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
				IF Exists (Select top 1 1  FROM #Tbl_SKUWisePriceList tspl 
				where NOT Exists (SELECT TOP 1 1 FROM #Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))

                         BEGIN
                             INSERT INTO #Tbl_PortalWisePriceList(PriceListId,ActivationDate,ExpirationDate,Precedence,SKU)
                                    SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
                                    FROM ZnodePriceList AS a
                                         INNER JOIN ZnodePriceListProfile AS b ON a.PriceListId = b.PriceListId 
										 INNER JOIN ZnodePortalProfile AS c ON b.PortalProfileId = c.PortalProfileId  AND c.PortalId = @PortalId 
                                         INNER JOIN dbo.ZnodeUserProfile zup ON c.ProfileId = zup.ProfileId AND (IsDefault = 1 OR   @ProfileId <> 0)
                                         INNER JOIN ZnodePortalunit zupu ON a.CultureId = zupu.CultureId AND zupu.PortalId = @PortalId 
										 inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
										 AND NOT EXISTS (Select TOP 1 1 FROM  #Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
                                    WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND (( zup.UserId = @UserId OR  @ProfileId <> 0) 
		   AND (ZUP.ProfileId = @ProfileId OR @ProfileId = 0 ));  
									--Delete from @Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  @Tbl_PortalWisePriceList )

					     END;
                   

                     ---6. If There is no any PriceList having given sku associated to Profile  then check for priceList associated Portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
                  				IF Exists (Select top 1 1  FROM #Tbl_SKUWisePriceList tspl 
								where NOT Exists (SELECT TOP 1 1 FROM #Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))

                         BEGIN
							INSERT INTO #Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
							SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
							FROM ZnodePriceList AS a INNER JOIN ZnodePriceListPortal AS b ON a.PriceListId = b.PriceListId
								INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId AND  zupu.PortalId = b.PortalId    
								inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
								AND NOT EXISTS (Select TOP 1 1 FROM  #Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
								WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND b.PortalId = @PortalId
							    ORDER BY b.Precedence
								;
								--Delete from #Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  #Tbl_PortalWisePriceList )
                         END;
						 
				--IF Exists (Select top 1 1  FROM #Tbl_SKUWisePriceList tspl where NOT Exists (SELECT TOP 1 1 FROM #Tbl_PortalWisePriceList tpwl
				--WHERE tspl.SKU = tpwl.SKU))
				--BEGIN
				
				--	INSERT INTO #Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
				--	SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
				--	FROM ZnodePriceList AS a INNER JOIN ZnodePriceListProfile AS b ON a.PriceListId = b.PriceListId INNER JOIN ZnodePortalProfile AS c
				--	ON b.ProfileId = c.ProfileId AND  c.IsDefaultAnonymousProfile = 1 INNER JOIN ZnodePortalunit AS zupu ON a.CurrencyId = zupu.CurrencyId
				--	inner join #Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
				--	AND NOT EXISTS (Select TOP 1 1 FROM  #Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
				--	WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND c.PortalId = @PortalId;
				--END

                 END;
			
             SET @PriceListId = 0;
             -- Check Activation date and expiry date 
             IF EXISTS( SELECT TOP 1 1 FROM #Tbl_PortalWisePriceList)
                 BEGIN
				
                     -- Declare  @d datetime
                     -- SET @d = @GetDate
                     -- Select ISNULL(ActivationDate,@d)  , ISNULL( ExpirationDate,@GetDate ),b.Precedence,* from ZnodePriceList  a inner join ZnodePriceListPortal b on a.PriceListId = b.PriceListId where @d between ISNULL(ActivationDate,@d) 
                     -- and ISNULL(ExpirationDate,@GetDate ) --and a.PriceListId <>  80
                     -- Order by ISNULL(ActivationDate,@d)  , ISNULL( ExpirationDate,@GetDate ) ,  b.Precedence DESC 
                     --	Retrive pricelist wise price
                   INSERT INTO #Tbl_PriceListWisePriceData( PriceListId, SKU, SalesPrice, RetailPrice, UomId, UnitSize, ActivationDate, ExpirationDate, TierPrice, TierQuantity, TierUomId, TierUnitSize , ExternalId ,Custom1,Custom2,Custom3)
				   SELECT ZP.PriceListId, ZP.SKU, ZP.SalesPrice, ZP.RetailPrice, ZP.UomId, ZP.UnitSize, ISNULL(ZP.ActivationDate, @CurrentUtcDate), ISNULL(ZP.ExpirationDate, @GetDate), ZPT.Price, ZPT.Quantity, ZPT.UomId, ZPT.UnitSize, ZP.ExternalId,
				   ZPT.Custom1,ZPT.Custom2,ZPT.Custom3
				   FROM [ZnodePrice] AS ZP 
				   INNER JOIN @Tlb_SKU AS TSKU ON (ZP.SKU = TSKU.SKU )
				   LEFT OUTER JOIN ZnodePriceTier AS ZPT ON ZP.SKU = ZPT.SKU AND ZP.PriceListId = ZPT.PriceListId
				   WHERE ZP.PriceListId IN
				   (
					   SELECT TOP 1 PriceListId
					   FROM #Tbl_PortalWisePriceList AS TBPWPL
					   WHERE  TBPWPL.SKU = ZP.SKU
					   ORDER BY Precedence 
				   );
				  


                     -- Check Activation date and expiry date 
                    INSERT INTO #TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3 )
					   SELECT DISTINCT  PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					   FROM #Tbl_PriceListWisePriceData
					   WHERE @currentUtcDate BETWEEN ActivationDate AND ISNULL(ExpirationDate, @GetDate);
					   
					  
					INSERT INTO #TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId ,Custom1,Custom2,Custom3)
					   SELECT PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					   FROM #Tbl_PriceListWisePriceData
					   WHERE SKU NOT IN(SELECT SKU FROM #TLB_SKUPRICELIST) and ActivationDate is null 
				
                 END;
                     -- Retrive data as per precedance from ZnodePriceListPortal table  
					
             ELSE
                 BEGIN
                     SET @PriceListId =( SELECT TOP 1 PriceListId FROM #Tbl_PortalWisePriceList ORDER BY Precedence  );

                     --Retrive pricelist wise price  
                     INSERT INTO #Tbl_PriceListWisePriceData( PriceListId, SKU, SalesPrice, RetailPrice, UomId, UnitSize, ActivationDate, ExpirationDate, TierPrice, TierQuantity, TierUomId, TierUnitSize, ExternalId ,Custom1,Custom2,Custom3)
					 SELECT ZP.PriceListId, ZP.SKU, ZP.SalesPrice, ZP.RetailPrice, ZP.UomId, ZP.UnitSize, ISNULL(ZP.ActivationDate, @CurrentUtcDate), 
							ISNULL(ZP.ExpirationDate, @GetDate), ZPT.Price, ZPT.Quantity, ZPT.UomId, ZPT.UnitSize, zp.ExternalId,Custom1,Custom2,Custom3
					 FROM [ZnodePrice] AS ZP INNER JOIN @Tlb_SKU AS TSKU ON ZP.SKU = TSKU.SKU LEFT OUTER JOIN ZnodePriceTier AS ZPT ON ZP.SKU = ZPT.SKU AND 
							   ZP.PriceListId = ZPT.PriceListId WHERE ZP.PriceListId = @PriceListId; 

                     -- Check Activation date and expiry date 
					INSERT INTO #TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId ,Custom1,Custom2,Custom3)
					SELECT PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					FROM #Tbl_PriceListWisePriceData WHERE @currentUtcDate BETWEEN ActivationDate AND ISNULL(ExpirationDate, @GetDate);
					
					INSERT INTO #TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId ,Custom1,Custom2,Custom3)
					SELECT PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					FROM #Tbl_PriceListWisePriceData
					WHERE SKU NOT IN ( SELECT SKU FROM #TLB_SKUPRICELIST) and ActivationDate is null;

                 END;
             SELECT SKU,
                    ROUND(RetailPrice, @PriceRoundOff) AS RetailPrice,
                    ROUND(SalesPrice, @PriceRoundOff) AS SalesPrice,
                    ROUND(TierPrice, @PriceRoundOff) AS TierPrice,
                    ROUND(TierQuantity, @PriceRoundOff) AS TierQuantity,
					ZCC.CurrencyCode  AS CurrencyCode,    
                    ZC.Symbol AS CurrencySuffix,  ZC.CultureCode,
					TSPL.ExternalId,
					Custom1,Custom2,Custom3
             FROM #TLB_SKUPRICELIST AS TSPL
                  INNER JOIN ZnodePriceList AS ZPL ON TSPL.PriceListId = ZPL.PriceListId
                  INNER JOIN ZnodeCulture AS ZC ON ZPL.CultureId = ZC.CultureId    
				  LEFT JOIN ZnodeCurrency AS ZCC ON ZC.CurrencyId = ZCC.CurrencyId   
				  ORDER BY TierQuantity ASC;
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishProductPricingBySku @SKU = '+@SKU+',@PortalId = '+CAST(@PortalId AS VARCHAR(10))+',@currentUtcDate = '+@currentUtcDate+',@UserId='+CAST(@UserId AS VARCHAR(100))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPublishProductPricingBySku',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PimCatalogId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>CatalogName</name>      <headertext>Catalog Name</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>500</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>PublishStatus</name>      <headertext>Publish Status</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>500</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>PublishProductCount</name>      <headertext>No. of Products Published</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PublishCategoryCount</name>      <headertext>No. of Categories Published</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>PublishCreatedDate</name>      <headertext>Published Date</headertext>      <width>30</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Manage|Edit|Copy|Publish|View|Trigger|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Manage|Edit|Copy|Publish|Publish History|Create Scheduler|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/PIM/Catalog/Manage|/PIM/Catalog/EditCatalogName|/PIM/Catalog/Copy|/PIM/Catalog/Publish|/PIM/Catalog/GetCatalogPublishStatus|/PIM/Catalog/CreateScheduler|/PIM/Catalog/Delete</manageactionurl>      <manageparamfield>pimCatalogId|pimCatalogId|pimCatalogId|pimCatalogId|pimCatalogId,UrlEncodedCatalogName|ConnectorTouchPoints,SchedulerCallFor|pimCatalogId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>IsActive</name>      <headertext>      </headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>HiddenField</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodePimCatalog'

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetCatalogList')
BEGIN 
	DROP PROCEDURE Znode_GetCatalogList
END
GO

CREATE PROCEDURE [dbo].[Znode_GetCatalogList]
(
	@WhereClause NVARCHAR(MAX),
    @Rows        INT           = 100,
    @PageNo      INT           = 1,
    @Order_BY    VARCHAR(100)  = '',
    @RowsCount   INT OUT
)
AS 
/*
	 Summary :- This Procedure is used to get the publish status of the catalog 
	 Unit Testig 
	 EXEC  Znode_GetCatalogList '',100,1,'',0
	  EXEC  Znode_GetCatalogList null,100,1,'',0
*/
   BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 

		 DECLARE @SQL  NVARCHAR(max) 
		 DECLARE @TBL_CatalogId TABLE (PimCatalogId int, PublishCatalogLogId int,CatalogName VARCHAR(max),PublishStatus VARCHAR(300),RowId INT ,CountId INT,PublishCreatedDate DATETIME ,PublishModifiedDate DATETIME,PublishCategoryCount INT ,PublishProductCount INT, IsActive BIT)
	 
		 SET @SQL = '


		DECLARE @TBL_PublishProductId TABLE (PublishProductId int,PublishCatalogId int )
		INSERT INTO @TBL_PublishProductId
		SELECT COUNT( DISTINCT PublishProductId ),PublishCatalogId
		FROM ZnodePublishCategoryProduct a
		WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where a.PublishCatalogId = b.PublishCatalogId)
		AND a.PublishCategoryId  <> 0 and a.PublishCategoryId is not null
		GROUP BY PublishCatalogId 

		DECLARE @TBL_PublishCategoryId TABLE (PublishCategoryId int,PublishCatalogId int )
		INSERT INTO @TBL_PublishCategoryId
		SELECT COUNT(DISTINCT PimCategoryId ),PublishCatalogId
		FROM ZnodePublishCategory ZPC
		WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where ZPC.PublishCatalogId = b.PublishCatalogId)
		GROUP BY PublishCatalogId


		--SELECT COUNT(DISTINCT PublishCategoryId ),PublishCatalogId
		--FROM ZnodePublishCategoryProduct ZPC
		--WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where ZPC.PublishCatalogId = b.PublishCatalogId)
		--AND ZPC.PublishCategoryId  <> 0 and ZPC.PublishCategoryId is not null
		--GROUP BY PublishCatalogId

		;With Cte_MaxPublish AS 
		(
			 SELECT max(PublishCatalogLogId) PublishCatalogLogId,PimCatalogId
			 FROM ZnodePublishCatalogLog ZPCL   
			 GROUP BY PimCatalogId
		)
		,Cte_CatalogLog AS (
		SELECT ZPC.CatalogName CatalogName, PublishCatalogLogId PublishCatalogLogId,  TYU.DisplayName   PublishStatus ,ZPC.PimCatalogId,ZPCL.CreatedDate AS PublishCreatedDate,ZPCL.ModifiedDate AS PublishModifiedDate,
		
		ISNULL(PC.PublishCategoryId,0) 
	 
		PublishCategoryCount,ISNULL(a.PublishProductId,0) 
		PublishProductCount,ZPC.IsActive
		FROM ZnodePimCatalog ZPC 
		LEFT JOIN ZnodePublishCatalogLog ZPCL  ON ( EXISTS (SELECT TOP 1 1 FROM Cte_MaxPublish CTE 											
		WHERE CTE.PimCatalogId = ZPC.PimCatalogId AND CTE.PublishCatalogLogId =  ZPCL.PublishCatalogLogId) )	
		LEFT JOIN ZnodePublishState TYU ON (TYU.PublishStateId = ZPCL.PublishStateId )
		LEFT JOIN  @TBL_PublishProductId a on (zpcl.PublishCatalogId = a.PublishCatalogId)
		LEFT JOIN  @TBL_PublishCategoryId PC ON (PC.PublishCatalogId = zpcl.PublishCatalogId))

	     ,Cte_PublishStatus 
		 AS (
		 SELECT PimCatalogId, PublishCatalogLogId, CatalogName, PublishStatus,PublishCreatedDate,PublishModifiedDate,PublishCategoryCount,PublishProductCount,IsActive,
		 '+[dbo].[Fn_GetPagingRowId](@Order_BY,'PublishCatalogLogId DESC')+' , Count(*)Over() CountId FROM Cte_CatalogLog
         WHERE 1=1 '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+' )
	 
		 SELECT PimCatalogId, PublishCatalogLogId,CatalogName,PublishStatus,RowId,CountId,PublishCreatedDate,PublishModifiedDate,PublishCategoryCount,PublishProductCount,IsActive
		 FROM Cte_PublishStatus 
		 '+[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)+' '
	

	     PRINT @sql 
		 INSERT INTO @TBL_CatalogId 
		 EXEC (@SQL)

		 SELECT  PimCatalogId,PublishCatalogLogId,CatalogName,PublishStatus,PublishCreatedDate,PublishModifiedDate,PublishCategoryCount,PublishProductCount,IsActive
		 FROM @TBL_CatalogId

		 SET @RowsCount = ISNULL((SELECT TOP 1 COUNTID FROM @TBL_CatalogId),0)
	 

	 
		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCatalogList @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znode_GetCatalogList',
					@ErrorInProcedure = 'Znode_GetCatalogList',
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END

   GO
 IF NOT EXISTS(SELECT * FROM SYS.INDEXES WHERE NAME = 'idx_ZnodeOmsSavedCartLineItem_OrderLineItemRelationshipTypeID')
BEGIN
	CREATE NONCLUSTERED INDEX idx_ZnodeOmsSavedCartLineItem_OrderLineItemRelationshipTypeID ON ZnodeOmsSavedCartLineItem(OrderLineItemRelationshipTypeId)
END

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_InsertUpdateSaveCartLineItemBundle')
BEGIN 
	DROP PROCEDURE Znode_InsertUpdateSaveCartLineItemBundle
END
GO

CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemBundle]
 (
	 @SaveCartLineItemType TT_SavecartLineitems READONLY  
	,@Userid  INT = 0 
	
 )
AS 
BEGIN 
BEGIN TRY 
 SET NOCOUNT ON 
   DECLARE @GetDate datetime= dbo.Fn_GetDate(); 
   DECLARE @OrderLineItemRelationshipTypeIdBundle int=
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Bundles'
		);
	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'AddOns'
		);
    DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT ) 	

	INSERT INTO @TBL_Personalise
	SELECT  NULL 
				,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @SaveCartLineItemType TRTR  ) a 
	CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
	 
	       INSERT INTO #tempoi
			   SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
			   FROM @SaveCartLineItemType a 
			   GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
	 
			INSERT INTO #tempoi 
			SELECT   Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, BundleProductIds
						,Quantity, @OrderLineItemRelationshipTypeIdBundle, CustomText, CartAddOnDetails, Sequence
						,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU  
			FROM @SaveCartLineItemType  a 
			WHERE BundleProductIds <> ''
			GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, BundleProductIds
			,Quantity,  CustomText, CartAddOnDetails, Sequence ,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
			 
			INSERT INTO #tempoi
			SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
			,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
			,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
				  WHEN  GroupProductIds <> '' THEN GroupProductIds 
				  WHEN BundleProductIds <> '' THEN BundleProductIds 
				  ELSE SKU END     ParentSKU 
			FROM @SaveCartLineItemType  a 
			WHERE AddOnValueIds <> ''
				GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
				,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
				,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
		 
		 

        CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
		INSERT INTO #OldValue  
		SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	  	FROM ZnodeOmsSavedCartLineItem a   
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.BundleProductIds,'')   )   
        AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle   

		INSERT INTO #OldValue 
		SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
		AND  b.OrderLineItemRelationshipTypeID IS NULL 

		------Merge Addon for same product
		SELECT * INTO #OldValueForAddon from #OldValue

		DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
		AND a.ParentOmsSavedCartLineItemId IS NOT NULL 

		INSERT INTO #OldValue 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon	

		------Merge Addon for same product
		IF EXISTS(SELECT * FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'') <> '' )
		BEGIN

			INSERT INTO #OldValueForAddon 
			SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
			FROM ZnodeOmsSavedCartLineItem b 
			INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
			WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
			AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

			SELECT distinct SKU, STUFF(
										( SELECT  ', ' + SKU FROM    
											( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											  where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											  FOR XML PATH('')
										), 1, 2, ''
									 ) AddOns
			INTO #AddOnsExists
			from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

			SELECT distinct a.BundleProductIds SKU, STUFF(
										 ( SELECT  ', ' + x.AddOnValueIds FROM    
											( SELECT DISTINCT b.AddOnValueIds FROM @SaveCartLineItemType b
											  where a.SKU=b.SKU ) x
											  FOR XML PATH('')
										 ), 1, 2, ''
									   ) AddOns
			INTO #AddOnAdded
			from @SaveCartLineItemType a

			if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
			begin
				delete from #OldValue
			end

		END

		IF NOT EXISTS (SELECT TOP 1 1  FROM @SaveCartLineItemType ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
		ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
		AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		BEGIN 
		
		DELETE FROM #OldValue 
		END 
		ELSE 
		BEGIN 
		 IF EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		 BEGIN 
	 

		 DECLARE @parenTofAddon INT  = 0 
		 SET @parenTofAddon = (SELECT TOP 1 ParentOmsSavedCartLineItemId 
		 FROM #OldValue a
		 WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 
		 AND (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem  t WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  )

		 DELETE FROM #OldValue WHERE ParentOmsSavedCartLineItemId <> @parenTofAddon  AND ParentOmsSavedCartLineItemId IS NOT NULL  

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		 AND ParentOmsSavedCartLineItemId IS  NULL  
		 
		 IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		IF (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem   WHERE ParentOmsSavedCartLineItemId =@parenTofAddon AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 

		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a 
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		 END 
		 ELSE IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		   ELSE IF  EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		      AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  = '' )
		 BEGIN 
		   DELETE FROM #OldValue
		 END 

		END 
		 

		DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
		INSERT INTO @TBL_Personaloldvalues
		SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
		FROM ZnodeOmsPersonalizeCartItem  a 
		WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
		IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		   AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
		BEGIN 
		    DELETE FROM #OldValue
		END 
		ELSE 
		BEGIN 
		 IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		   
		   DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
		   SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
		   OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		 
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		   
		   DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
		   OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
		
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		        AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		       AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		 BEGIN 
		     DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		 END 
		END 

		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
		;with cte as
		(
			SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.BundleProductIds as SKU
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.BundleProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
			WHERE a.OmsSavedCartLineItemId = 0
		)
		delete c1
		from cte a1		  
		Inner Join #OldValue b1 on a1.SKU = b1.SKU
		inner join #OldValue c1 on (b1.ParentOmsSavedCartLineItemId = c1.OmsSavedCartLineItemId OR b1.OmsSavedCartLineItemId = c1.OmsSavedCartLineItemId)
		where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)

		IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
		BEGIN 

		 UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon

		 --UPDATE Ab SET ab.Quantity = a.Quantity   
   --      FROM ZnodeOmsSavedCartLineItem a  
   --      INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
   --      INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  )   
		 --WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  

		 UPDATE Ab 
		 SET Ab.Quantity = Ab.Quantity+ty.Quantity,
		 Ab.Custom1 = ty.Custom1,
		 Ab.Custom2 = ty.Custom2,
		 Ab.Custom3 = ty.Custom3,
		 Ab.Custom4 = ty.Custom4,
		 Ab.Custom5 = ty.Custom5  
         FROM ZnodeOmsSavedCartLineItem a  
         INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
         INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  ) 
		 INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)  
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  


		END 
	    ELSE 
		BEGIN 
			
		UPDATE #tempoi
			SET ParentSKU = (SELECT TOP 1 SKU FROM #tempoi WHERE OrderLineItemRelationshipTypeID IS NULL )
			WHERE OrderLineItemRelationshipTypeID  = @OrderLineItemRelationshipTypeIdAddon 
			AND EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) 
		   
    SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
     INTO #yuuete   
     FROM  #tempoi  
     GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
     ORDER BY RowId, Id   
   
	DELETE FROM #yuuete WHERE Quantity <=0  

	;WITH Add_Dup AS
	(
		SELECT  Min(NewRowId)NewRowId ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID 
		FROM  #yuuete
		GROUP BY SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID
		HAVING OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon	
	)

	DELETE FROM #yuuete
	WHERE NOT EXISTS (SELECT TOP 1 1 FROM Add_Dup WHERE Add_Dup.NewRowId = #yuuete.NewRowId)
	AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

     ;WITH VTTY AS   
    (  
    SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
       FROM #yuuete m  
    INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
    WHERE m.OrderLineItemRelationshipTypeID IN ( @OrderLineItemRelationshipTypeIdAddon , @OrderLineItemRelationshipTypeIdBundle)   
    )   
    UPDATE m1   
    SET m1.RowId = TYU.RowId  
    FROM #yuuete m1   
    INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
      
    
    ;WITH VTRET AS   
    (  
    SELECT RowId,id,Min(NewRowId)NewRowId ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID   
    FROM #yuuete   
    GROUP BY RowId,id ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID  
	Having  SKU = ParentSKU  AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
    )   
  
    DELETE FROM #yuuete WHERE NewRowId  IN (SELECT NewRowId FROM VTRET)   
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
       OUTPUT INSERTED.OmsSavedCartLineItemId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  
  
 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
	INTO #Cte_newData 
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
    --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL  
	AND  EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) 
  
  --------------------------------------------------------------------------------------------------------

   --;with Cte_newData AS   
   -- (  
    SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData1
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
   -- )

	UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData1  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon   
	AND  EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) 
	AND  a.sequence in (SELECT  MIN(ab.sequence) FROM ZnodeOmsSavedCartLineItem ab where a.OmsSavedCartId = ab.OmsSavedCartId and 
	 a.SKU = ab.sku and ab.OrderLineItemRelationshipTypeId is not null  ) 


 -----------------------------------------------------------------------------------------------------

    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = b.id OR b.Id = 1  ))  
    INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
    WHERE ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = ISNULL(a.ParentOmsSavedCartLineItemId,0) OR ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  AND c.ParentOmsSavedCartLineItemId IS NULL
  --  )   
  
 

   ;with table_update AS 
   (
     SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 FROM ZnodeOmsSavedCartLineItem a
	 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
     AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
     AND a.ParentOmsSavedCartLineItemId IS NULL  
	 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
   )

     UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )   
    FROM table_update a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
    WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )    IS nOT NULL 
	 
  
    ;with Cte_Th AS   
    (             
      SELECT RowId    
     FROM #yuuete a   
     GROUP BY RowId   
     HAVING COUNT(NewRowId) <= 1   
      )   
    UPDATE a SET a.Quantity =  NULL   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
    WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
     AND a.OrderLineItemRelationshipTypeId IS NULL   
  
    UPDATE Ab SET ab.Quantity = a.Quantity   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
    INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  )   
    WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  
  
    

    UPDATE  ZnodeOmsSavedCartLineItem   
    SET GROUPID = NULL   
    WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
    AND OrderLineItemRelationshipTypeId IS NOT NULL     
       ;With Cte_UpdateSequence AS   
     (  
       SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
       FROM ZnodeOmsSavedCartLineItem   
       WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
     )   
    UPDATE Cte_UpdateSequence  
    SET  Sequence = RowId  
			
	
	UPDATE @TBL_Personalise
	SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	FROM @OmsInsertedData a 
	INNER JOIN ZnodeOmsSavedCartLineItem b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
	WHERE b.ParentOmsSavedCartLineItemId IS not nULL 
	
	DELETE FROM ZnodeOmsPersonalizeCartItem	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
    MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
	USING @TBL_Personalise SOURCE
		   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
		   WHEN NOT MATCHED THEN 
		    INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
							,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
			VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
							,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
		END 
END TRY
BEGIN CATCH 
  SELECT ERROR_MESSAGE()
END CATCH 
END

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_InsertUpdateSaveCartLineItemConfigurable')
BEGIN 
	DROP PROCEDURE Znode_InsertUpdateSaveCartLineItemConfigurable
END
GO

CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemConfigurable]
 (
	 @SaveCartLineItemType TT_SavecartLineitems READONLY  
	,@Userid  INT = 0 
	
 )
AS 
BEGIN 
BEGIN TRY 
 SET NOCOUNT ON 
   DECLARE @GetDate datetime= dbo.Fn_GetDate(); 
   DECLARE @OrderLineItemRelationshipTypeIdConfigurable int=
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Configurable'
		);
	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'AddOns'
		);
    DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT, OmsSavedCartId INT,SKU NVARCHAr(max),GroupId  NVARCHAr(max),ParentOmsSavedCartLineItemId INT,OrderLineItemRelationshipTypeId INT  ) 

	INSERT INTO @TBL_Personalise
	SELECT  NULL 
				,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @SaveCartLineItemType TRTR  ) a 
	CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
	 
	       INSERT INTO #tempoi
			   SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
			   FROM @SaveCartLineItemType a 
			   GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
	 
			INSERT INTO #tempoi 
			SELECT   Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, ConfigurableProductIds
						,Quantity, @OrderLineItemRelationshipTypeIdConfigurable, CustomText, CartAddOnDetails, Sequence
						,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU  
			FROM @SaveCartLineItemType  a 
			WHERE ConfigurableProductIds <> ''
			GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, ConfigurableProductIds
			,Quantity,  CustomText, CartAddOnDetails, Sequence ,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
			 
			INSERT INTO #tempoi
			SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
			,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
			,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
				  WHEN  GroupProductIds <> '' THEN GroupProductIds 
				  WHEN BundleProductIds <> '' THEN BundleProductIds 
				  ELSE SKU END     ParentSKU 
			FROM @SaveCartLineItemType  a 
			WHERE AddOnValueIds <> ''
				GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
				,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
				,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
		 
		 SELECT * 
		INTO #ZnodeOmsSavedCartLineItem_NT
		FROM ZnodeOmsSavedCartLineItem a 
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId)


        CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
		INSERT INTO #OldValue  
		SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	  	FROM #ZnodeOmsSavedCartLineItem_NT a   
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.ConfigurableProductIds,'')   )   
        AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdConfigurable   

		
		
		INSERT INTO #OldValue 
		SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM #ZnodeOmsSavedCartLineItem_NT b 
		INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
		AND  b.OrderLineItemRelationshipTypeID IS NULL 
		
		------Merge Addon for same product
		SELECT * INTO #OldValueForAddon from #OldValue
		  
		DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
		AND a.ParentOmsSavedCartLineItemId IS NOT NULL 

		INSERT INTO #OldValue 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM #ZnodeOmsSavedCartLineItem_NT b 
		INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon
		
		------Merge Addon for same product
		IF EXISTS(SELECT * FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'') <> '' )
		BEGIN
		
		
			INSERT INTO #OldValueForAddon 
			SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
			FROM #ZnodeOmsSavedCartLineItem_NT b 
			INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
			WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
			AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

			SELECT distinct SKU, STUFF(
										( SELECT  ', ' + SKU FROM    
											( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											  where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											  FOR XML PATH('')
										), 1, 2, ''
									 ) AddOns
			INTO #AddOnsExists
			from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

			SELECT distinct a.ConfigurableProductIds SKU, STUFF(
										 ( SELECT  ', ' + x.AddOnValueIds FROM    
											( SELECT DISTINCT b.AddOnValueIds FROM @SaveCartLineItemType b
											  where a.SKU=b.SKU ) x
											  FOR XML PATH('')
										 ), 1, 2, ''
									   ) AddOns
			INTO #AddOnAdded
			from @SaveCartLineItemType a

			

			if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
			begin
			   
				delete from #OldValue

				
			end

		END

		IF NOT EXISTS (SELECT TOP 1 1  FROM @SaveCartLineItemType ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
		ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
		AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		BEGIN 
		
		DELETE FROM #OldValue 
		END 
		ELSE 
		BEGIN 
		
		 IF EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		 BEGIN 
		 
		 DECLARE @parenTofAddon  TABLE( ParentOmsSavedCartLineItemId INT  )  
		 INSERT INTO  @parenTofAddon 
		 SELECT  ParentOmsSavedCartLineItemId FROM #OldValue a  WHERE a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
		 AND (SELECT COUNT (DISTINCT SKU ) FROM  #ZnodeOmsSavedCartLineItem_NT  t WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
					AND ParentOmsSavedCartLineItemId IS NOT NULL  
					AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		 AND ParentOmsSavedCartLineItemId IS  NULL  
		 
		 IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		IF (SELECT COUNT (DISTINCT SKU ) FROM  #ZnodeOmsSavedCartLineItem_NT   WHERE ParentOmsSavedCartLineItemId IN (SELECT ParentOmsSavedCartLineItemId FROM @parenTofAddon)AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 

		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 
		 -- SELECT 3
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM #ZnodeOmsSavedCartLineItem_NT a 
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdConfigurable  )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		    
			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		    AND ParentOmsSavedCartLineItemId IS  NULL  

		 END
		 ELSE IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END  
		 ELSE IF  EXISTS (SELECT TOP 1 1 FROM #ZnodeOmsSavedCartLineItem_NT Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdConfigurable AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		      AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  = '' )
		 BEGIN 
		   DELETE FROM #OldValue
		 END 

		END 

		

		
		DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
		
		INSERT INTO @TBL_Personaloldvalues
		SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
		FROM ZnodeOmsPersonalizeCartItem  a 
		WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
		IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		   AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
		BEGIN 
		 DELETE FROM #OldValue
		END 
		ELSE 
		BEGIN 
		  IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		    DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
		   SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
		   OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		 
		   DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
		   OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
	
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		        AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		       AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		 BEGIN 
		     DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		 END 
		END 

		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
		;with cte as
		(
			SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.ConfigurableProductIds as SKU
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.ConfigurableProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
			WHERE a.OmsSavedCartLineItemId = 0
		)
		delete c1
		from cte a1		  
		Inner Join #OldValue b1 on a1.SKU = b1.SKU
		inner join #OldValue c1 on (b1.ParentOmsSavedCartLineItemId = c1.OmsSavedCartLineItemId OR b1.OmsSavedCartLineItemId = c1.OmsSavedCartLineItemId)
		where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)
		
		IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
		BEGIN 

		  UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon
		 
		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon



		END 
		ELSE 
		BEGIN 
		
		
			   
    SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
     INTO #yuuete   
     FROM  #tempoi  
     GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
     ORDER BY RowId, Id   
       	     
    DELETE FROM #yuuete WHERE Quantity <=0  
  
     ;WITH VTTY AS   
    (  
    SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
       FROM #yuuete m  
    INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
    WHERE m.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon   
    )   
    UPDATE m1   
    SET m1.RowId = TYU.RowId  
    FROM #yuuete m1   
    INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
        
    
    ;WITH VTRET AS   
    (  
    SELECT RowId,id,Min(NewRowId)NewRowId ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID  
    FROM #yuuete   
    GROUP BY RowId,id ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID  
	Having  SKU = ParentSKU  AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
    )   
  
    DELETE FROM #yuuete WHERE NewRowId  IN (SELECT NewRowId FROM VTRET)   
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,	CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
        OUTPUT INSERTED.OmsSavedCartLineItemId,INSERTED.OmsSavedCartId,inserted.SKU,inserted.GroupId,INSERTED.ParentOmsSavedCartLineItemId,INSERTED.OrderLineItemRelationshipTypeId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  
  
 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU
	INTO   #Cte_newData
    FROM @OmsInsertedData a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	--AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
    --)   
	
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL   
    AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )

	---------------------------------------------------------------------------------------------------------------------

	 --;with Cte_newData AS   
  --  (  
    SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
	INTO #Cte_newData1 
    FROM @OmsInsertedData a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
	AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
	-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
    --) 

	UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData1  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon     
    AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	AND  a.sequence in (SELECT  MIN(ab.sequence) FROM ZnodeOmsSavedCartLineItem ab where a.OmsSavedCartId = ab.OmsSavedCartId and 
	 a.SKU = ab.sku and ab.OrderLineItemRelationshipTypeId is not null  ) 
 
	---------------------------------------------------------------------------------------------------------------------------
    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId  )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
    INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1 
	WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) and c.ParentOmsSavedCartLineItemId is null
  --  )   
  
   ;with table_update AS 
   (
     SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 FROM ZnodeOmsSavedCartLineItem a
	 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
     AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
     AND a.ParentOmsSavedCartLineItemId IS NULL  
	 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
   )

     UPDATE a SET  
    --SELECT  a.OmsSavedCartLineItemId,
	a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )   
    FROM table_update a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
    WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )    IS nOT NULL 
	 

	

    ;with Cte_Th AS   
    (             
      SELECT RowId    
     FROM #yuuete a   
     GROUP BY RowId   
     HAVING COUNT(NewRowId) <= 1   
      )   
    UPDATE a SET a.Quantity =  NULL   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
    WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
     AND a.OrderLineItemRelationshipTypeId IS NULL   
  
    UPDATE  ZnodeOmsSavedCartLineItem   
    SET GROUPID = NULL   
    WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
    AND OrderLineItemRelationshipTypeId IS NOT NULL     
       ;With Cte_UpdateSequence AS   
     (  
       SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
       FROM ZnodeOmsSavedCartLineItem   
       WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
     )   
    UPDATE Cte_UpdateSequence  
    SET  Sequence = RowId  
			
	
	UPDATE @TBL_Personalise
	SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	FROM @OmsInsertedData a 
	INNER JOIN ZnodeOmsSavedCartLineItem b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId  and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
	WHERE b.ParentOmsSavedCartLineItemId IS not nULL 
	
	DELETE FROM ZnodeOmsPersonalizeCartItem WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
    MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
	USING @TBL_Personalise SOURCE
		   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
		   WHEN NOT MATCHED THEN 
		    INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
							,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
			VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
							,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
		END 




END TRY
BEGIN CATCH 
  SELECT ERROR_MESSAGE()
END CATCH 
END

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_InsertUpdateSaveCartLineItemGroup')
BEGIN 
	DROP PROCEDURE Znode_InsertUpdateSaveCartLineItemGroup
END
GO

CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemGroup]
 (
	 @SaveCartLineItemType TT_SavecartLineitems READONLY  
	,@Userid  INT = 0 
	
 )
AS 
BEGIN 
BEGIN TRY 
 SET NOCOUNT ON 
   DECLARE @GetDate datetime= dbo.Fn_GetDate(); 
   DECLARE @OrderLineItemRelationshipTypeIdGroup int=
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Group'
		);
	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'AddOns'
		);
    DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT ) 	

	INSERT INTO @TBL_Personalise
	SELECT  NULL 
				,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @SaveCartLineItemType TRTR  ) a 
	CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
	 
	       INSERT INTO #tempoi
			   SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
			   FROM @SaveCartLineItemType a 
			   GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
	 
			INSERT INTO #tempoi 
			SELECT   Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, GroupProductIds
						,Quantity, @OrderLineItemRelationshipTypeIdGroup, CustomText, CartAddOnDetails, Sequence
						,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU  
			FROM @SaveCartLineItemType  a 
			WHERE GroupProductIds <> ''
			GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, GroupProductIds
			,Quantity,  CustomText, CartAddOnDetails, Sequence ,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
			 
			INSERT INTO #tempoi
			SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
			,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
			,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
				  WHEN  GroupProductIds <> '' THEN GroupProductIds 
				  WHEN BundleProductIds <> '' THEN BundleProductIds 
				  ELSE SKU END     ParentSKU 
			FROM @SaveCartLineItemType  a 
			WHERE AddOnValueIds <> ''
				GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
				,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
				,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
		 

        CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
		INSERT INTO #OldValue  
		SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	  	FROM ZnodeOmsSavedCartLineItem a   
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.GroupProductIds,'')   )   
        AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup   

		INSERT INTO #OldValue 
		SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
		AND  b.OrderLineItemRelationshipTypeID IS NULL 

		------Merge Addon for same product
		SELECT * INTO #OldValueForAddon from #OldValue

		DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
		AND a.ParentOmsSavedCartLineItemId IS NOT NULL 

		INSERT INTO #OldValue 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		------Merge Addon for same product
		IF EXISTS(SELECT * FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'') <> '' )
		BEGIN

			INSERT INTO #OldValueForAddon 
			SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
			FROM ZnodeOmsSavedCartLineItem b 
			INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
			WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
			AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

			SELECT distinct SKU, STUFF(
										( SELECT  ', ' + SKU FROM    
											( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											  where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											  FOR XML PATH('')
										), 1, 2, ''
									 ) AddOns
			INTO #AddOnsExists
			from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

			SELECT distinct a.GroupProductIds SKU, STUFF(
										 ( SELECT  ', ' + x.AddOnValueIds FROM    
											( SELECT DISTINCT b.AddOnValueIds FROM @SaveCartLineItemType b
											  where a.SKU=b.SKU ) x
											  FOR XML PATH('')
										 ), 1, 2, ''
									   ) AddOns
			INTO #AddOnAdded
			from @SaveCartLineItemType a

			if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
			begin
				delete from #OldValue
			end

		END

		IF NOT EXISTS (SELECT TOP 1 1  FROM @SaveCartLineItemType ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
		ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
		AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		BEGIN 
		
		DELETE FROM #OldValue 
		END 
		ELSE 
		BEGIN 
		
		 IF EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		 BEGIN 
		 
		 DECLARE @parenTofAddon  TABLE( ParentOmsSavedCartLineItemId INT  )  
		 INSERT INTO  @parenTofAddon 
		 SELECT  ParentOmsSavedCartLineItemId FROM #OldValue a
		 WHERE a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
		 AND (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem  t WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  
		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
					AND ParentOmsSavedCartLineItemId IS NOT NULL  
					AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		 AND ParentOmsSavedCartLineItemId IS  NULL  
		 

		  IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		 IF (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem   WHERE ParentOmsSavedCartLineItemId IN (SELECT ParentOmsSavedCartLineItemId FROM @parenTofAddon)AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 

		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 
		 -- SELECT 3
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a 
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup  )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		    
			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		     AND ParentOmsSavedCartLineItemId IS  NULL  

		 END
		 ELSE IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		   ELSE IF  EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		      AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  = '' )
			 BEGIN 
			   DELETE FROM #OldValue
			 END  
		END 

	


		DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
		INSERT INTO @TBL_Personaloldvalues
		SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
		FROM ZnodeOmsPersonalizeCartItem  a 
		WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
		IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		   AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
		BEGIN 
		 DELETE FROM #OldValue
		END 
		ELSE 
		BEGIN 
		 IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		   
		   DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
		   SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
		   OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		 
		   DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
		   OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
		
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		        AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		       AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		 BEGIN 
		     DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		 END 
		END 
		
		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
		;with cte as
		(
			SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.GroupProductIds as SKU
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.GroupProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
			WHERE a.OmsSavedCartLineItemId = 0
		)
		delete c1
		from cte a1		  
		Inner Join #OldValue b1 on a1.SKU = b1.SKU
		inner join #OldValue c1 on (b1.ParentOmsSavedCartLineItemId = c1.OmsSavedCartLineItemId OR b1.OmsSavedCartLineItemId = c1.OmsSavedCartLineItemId)
		where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)
		
		IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
		BEGIN 

		 UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon


		END 
		ELSE 
		BEGIN 
		
		
			   
    SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
     INTO #yuuete   
     FROM  #tempoi  
     GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
     ORDER BY RowId, Id   
       	    --select * from #yuuete
			
			 
    DELETE FROM #yuuete WHERE Quantity <=0  
  
     ;WITH VTTY AS   
    (  
    SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
       FROM #yuuete m  
    INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
    WHERE m.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon   
    )   
    UPDATE m1   
    SET m1.RowId = TYU.RowId  
    FROM #yuuete m1   
    INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
        
    
    ;WITH VTRET AS   
    (  
    SELECT RowId,id,Min(NewRowId)NewRowId ,SKU ,ParentSKU, OrderLineItemRelationshipTypeId 
    FROM #yuuete   
    GROUP BY RowId,id ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeId
	HAVING SKU = ParentSKU AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
    )   


    DELETE FROM #yuuete WHERE NewRowId  IN (SELECT NewRowId FROM VTRET)   
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
       OUTPUT INSERTED.OmsSavedCartLineItemId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  
  
 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
	INTO  #Cte_newData
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID	  
	 --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL   
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
  
  -----------------------------------------------------------------------------------------------------------------------------------

  	 --;with Cte_newData AS   
    --(  
    SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData1
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID	  
	 --)

	 UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData1  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon   
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	AND  a.sequence in (SELECT  MIN(ab.sequence) FROM ZnodeOmsSavedCartLineItem ab where a.OmsSavedCartId = ab.OmsSavedCartId and 
	 a.SKU = ab.sku and ab.OrderLineItemRelationshipTypeId is not null  ) 


----------------------------------------------------------------------------------------------------------------------------

    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
    INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
	WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) and c.ParentOmsSavedCartLineItemId is null
  --  )   
  
   ;with table_update AS 
   (
     SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 FROM ZnodeOmsSavedCartLineItem a
	 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
     AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
     AND a.ParentOmsSavedCartLineItemId IS NULL  
	 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
   )

     UPDATE a SET  
	a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )   
    FROM table_update a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
    WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )    IS nOT NULL 
	 
	
   
  
    ;with Cte_Th AS   
    (             
      SELECT RowId    
     FROM #yuuete a   
     GROUP BY RowId   
     HAVING COUNT(NewRowId) <= 1   
      )   
    UPDATE a SET a.Quantity =  NULL   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
    WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
     AND a.OrderLineItemRelationshipTypeId IS NULL   
  
    UPDATE  ZnodeOmsSavedCartLineItem   
    SET GROUPID = NULL   
    WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
    AND OrderLineItemRelationshipTypeId IS NOT NULL     
       ;With Cte_UpdateSequence AS   
     (  
       SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
       FROM ZnodeOmsSavedCartLineItem   
       WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
     )   
    UPDATE Cte_UpdateSequence  
    SET  Sequence = RowId  
			
	
	UPDATE @TBL_Personalise
	SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	FROM @OmsInsertedData a 
	INNER JOIN ZnodeOmsSavedCartLineItem b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
	WHERE b.ParentOmsSavedCartLineItemId IS not nULL 
	
	DELETE FROM ZnodeOmsPersonalizeCartItem	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
    MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
	USING @TBL_Personalise SOURCE
		   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
		   WHEN NOT MATCHED THEN 
		    INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
							,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
			VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
							,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
		END 




END TRY
BEGIN CATCH 
  SELECT ERROR_MESSAGE()
END CATCH 
END

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_InsertUpdateSaveCartLineItemQuantity')
BEGIN 
	DROP PROCEDURE Znode_InsertUpdateSaveCartLineItemQuantity
END
GO


CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemQuantity](
	  @CartLineItemXML xml, @UserId int,@Status bit OUT )
AS 
   /* 
    Summary: THis Procedure is USed to save and edit the saved cart line item      
    Unit Testing 
	begin tran  
    Exec Znode_InsertUpdateSaveCartLineItem @CartLineItemXML= '<ArrayOfSavedCartLineItemModel>
  <SavedCartLineItemModel>
    <OmsSavedCartLineItemId>0</OmsSavedCartLineItemId>
    <ParentOmsSavedCartLineItemId>0</ParentOmsSavedCartLineItemId>
    <OmsSavedCartId>1259</OmsSavedCartId>
    <SKU>BlueGreenYellow</SKU>
    <Quantity>1.000000</Quantity>
    <OrderLineItemRelationshipTypeId>0</OrderLineItemRelationshipTypeId>
    <Sequence>1</Sequence>
    <AddonProducts>YELLOW</AddonProducts>
    <BundleProducts />
    <ConfigurableProducts>GREEN</ConfigurableProducts>
  </SavedCartLineItemModel>
  <SavedCartLineItemModel>
    <OmsSavedCartLineItemId>0</OmsSavedCartLineItemId>
    <ParentOmsSavedCartLineItemId>0</ParentOmsSavedCartLineItemId>
    <OmsSavedCartId>1259</OmsSavedCartId>
    <SKU>ap1534</SKU>
    <Quantity>1.0</Quantity>
    <OrderLineItemRelationshipTypeId>0</OrderLineItemRelationshipTypeId>
    <Sequence>2</Sequence>
    <AddonProducts >PINK</AddonProducts>
    <BundleProducts />
    <ConfigurableProducts />
    <PersonaliseValuesList>Address~Hello</PersonaliseValuesList>
  </SavedCartLineItemModel>
</ArrayOfSavedCartLineItemModel>' , @UserId=1 ,@Status=0
	rollback tran
*/
BEGIN
	BEGIN TRAN InsertUpdateSaveCartLineItem;
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		DECLARE @AddOnQuantity numeric(28, 6)= 0;
		DECLARE @IsAddProduct   BIT = 0 
		DECLARE @OmsSavedCartLineItemId INT = 0
		DECLARE @TBL_SavecartLineitems TABLE
		( 
			RowId int , OmsSavedCartLineItemId int, ParentOmsSavedCartLineItemId int, OmsSavedCartId int, SKU nvarchar(600), Quantity numeric(28, 6), OrderLineItemRelationshipTypeID int, CustomText nvarchar(max), 
			CartAddOnDetails nvarchar(max), Sequence int, AddOnValueIds varchar(max), BundleProductIds varchar(max), ConfigurableProductIds varchar(max), GroupProductIds varchar(max), PersonalisedAttribute XML, 
			AutoAddon varchar(max), OmsOrderId int, ItemDetails nvarchar(max),
			Custom1	nvarchar(max),Custom2 nvarchar(max),Custom3 nvarchar(max),Custom4
			nvarchar(max),Custom5 nvarchar(max),GroupId NVARCHAR(max) ,ProductName Nvarchar(1000) , Description NVARCHAR(max),AddOnQuantity NVARCHAR(max)
		);

		DECLARE @OrderLineItemRelationshipTypeIdAddon int =
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'AddOns'
		);
		DECLARE @OrderLineItemRelationshipTypeIdSimple int =
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Simple'
		);
		DECLARE @OrderLineItemRelationshipTypeIdGroup int=
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Group'
		);
		DECLARE @OrderLineItemRelationshipTypeIdConfigurable int=
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Configurable'
		);
		 DECLARE @OrderLineItemRelationshipTypeIdBundle int=
		(
			SELECT TOP 1 OrderLineItemRelationshipTypeId
			FROM ZnodeOmsOrderLineItemRelationshipType
			WHERE [Name] = 'Bundles'
		);
		INSERT INTO @TBL_SavecartLineitems( RowId,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU, Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence, AddOnValueIds, BundleProductIds, ConfigurableProductIds, GroupProductIds, PersonalisedAttribute, AutoAddon, OmsOrderId, ItemDetails,
		Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,Description,AddOnQuantity )
			   SELECT DENSE_RANK()Over(Order BY Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' )) RowId ,Tbl.Col.value( 'OmsSavedCartLineItemId[1]', 'NVARCHAR(2000)' ) AS OmsSavedCartLineItemId, Tbl.Col.value( 'ParentOmsSavedCartLineItemId[1]', 'NVARCHAR(2000)' ) AS ParentOmsSavedCartLineItemId, Tbl.Col.value( 'OmsSavedCartId[1]', 'NVARCHAR(2000)' ) AS OmsSavedCartId, Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' ) AS SKU, Tbl.Col.value( 'Quantity[1]', 'NVARCHAR(2000)' ) AS Quantity
			   , Tbl.Col.value( 'OrderLineItemRelationshipTypeID[1]', 'NVARCHAR(2000)' ) AS OrderLineItemRelationshipTypeID, Tbl.Col.value( 'CustomText[1]', 'NVARCHAR(2000)' ) AS CustomText, Tbl.Col.value( 'CartAddOnDetails[1]', 'NVARCHAR(2000)' ) AS CartAddOnDetails, Tbl.Col.value( 'Sequence[1]', 'NVARCHAR(2000)' ) AS Sequence, Tbl.Col.value( 'AddonProducts[1]', 'NVARCHAR(2000)' ) AS AddOnValueIds, ISNULL(Tbl.Col.value( 'BundleProducts[1]', 'NVARCHAR(2000)' ),'') AS BundleProductIds, ISNULL(Tbl.Col.value( 'ConfigurableProducts[1]', 'NVARCHAR(2000)' ),'') AS ConfigurableProductIds, ISNULL(Tbl.Col.value( 'GroupProducts[1]', 'NVARCHAR(Max)' ),'') AS GroupProductIds, 
			          Tbl.Col.query('(PersonaliseValuesDetail/node())') AS PersonaliseValuesDetail, Tbl.Col.value( 'AutoAddon[1]', 'NVARCHAR(Max)' ) AS AutoAddon, Tbl.Col.value( 'OmsOrderId[1]', 'NVARCHAR(Max)' ) AS OmsOrderId,
					  Tbl.Col.value( 'ItemDetails[1]', 'NVARCHAR(Max)' ) AS ItemDetails,
					  Tbl.Col.value( 'Custom1[1]', 'NVARCHAR(Max)' ) AS Custom1,
					  Tbl.Col.value( 'Custom2[1]', 'NVARCHAR(Max)' ) AS Custom2,
					  Tbl.Col.value( 'Custom3[1]', 'NVARCHAR(Max)' ) AS Custom3,
					  Tbl.Col.value( 'Custom4[1]', 'NVARCHAR(Max)' ) AS Custom4,
					  Tbl.Col.value( 'Custom5[1]', 'NVARCHAR(Max)' ) AS Custom5,
					  Tbl.Col.value( 'GroupId[1]', 'NVARCHAR(Max)' ) AS GroupId,
					  Tbl.Col.value( 'ProductName[1]', 'NVARCHAR(Max)' ) AS ProductName,
					  Tbl.Col.value( 'Description[1]', 'NVARCHAR(Max)' ) AS Description, 
					  Tbl.Col.value( 'AddOnQuantity[1]', 'NVARCHAR(2000)' ) AS AddOnQuantity
			   FROM @CartLineItemXML.nodes( '//ArrayOfSavedCartLineItemModel/SavedCartLineItemModel' ) AS Tbl(Col);
			  

			  IF OBJECT_ID('tempdb..#TBL_SavecartLineitems') is not null
				drop table #TBL_SavecartLineitems

			 IF OBJECT_ID('tempdb..#OldValueForAddon') is not null
				drop table #OldValueForAddon

			  SELECT * INTO #TBL_SavecartLineitems FROM @TBL_SavecartLineitems
			

			UPDATE ZnodeOmsSavedCart
			SET ModifiedDate = GETDATE()
			WHERE OmsSavedCartId = (SELECT TOP 1  OmsSavedCartId FROM @TBL_SavecartLineitems)
				

			  UPDATE  @TBL_SavecartLineitems
			  SET 	Description = ISNUll(Description,'') 

			IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' )
			 BEGIN 				
				 IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0  ) 
				 BEGIN 
				    SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0 )

					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0)
					WHERE ( OmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					OR ParentOmsSavedCartLineItemId =  @OmsSavedCartLineItemId   ) 
					 
					--UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
					INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = SCLI.OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
					WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					AND SCLI.BundleProductIds <> ''

					DELETE	FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0
				 END 
				  DECLARE @TBL_bundleProduct TT_SavecartLineitems 
				  INSERT INTO @TBL_bundleProduct 
				  SELECT *  
				  FROM @TBL_SavecartLineitems 
				  WHERE ISNULL(BundleProductIds,'') <> '' 
				
				  EXEC Znode_InsertUpdateSaveCartLineItemBundle @TBL_bundleProduct,@userId
				 
				  DELETE FROM  @TBL_SavecartLineitems WHERE ISNULL(BundleProductIds,'') <> '' 
				  SET @OmsSavedCartLineItemId = 0 
				END 
			IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' )
			    BEGIN 				
				 IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0  ) 
				 BEGIN 

				   SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0 )
				 
				   	UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId = @OmsSavedCartLineItemId )
					WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId
					
					--UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE  ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
					INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = SCLI.OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
					WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					AND SCLI.ConfigurableProductIds <> ''

					DELETE	FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0
				 END 
				  DECLARE @TBL_Configurable TT_SavecartLineitems 
				  INSERT INTO @TBL_Configurable 
				  SELECT *  
				  FROM @TBL_SavecartLineitems 
				  WHERE ISNULL(ConfigurableProductIds,'') <> '' 

				  
				  EXEC Znode_InsertUpdateSaveCartLineItemConfigurable @TBL_Configurable,@userId
				  
				  DELETE FROM @TBL_SavecartLineitems 
				  WHERE ISNULL(ConfigurableProductIds,'') <> ''
				  SET @OmsSavedCartLineItemId = 0  
				END 
				IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' )
			    BEGIN 				
				 IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId <> 0  ) 
				 BEGIN 
				   SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId <> 0 )
				   	UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId = @OmsSavedCartLineItemId )
					WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId
					
					--UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND  OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
					INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = SCLI.OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
					WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					AND SCLI.GroupProductIds <> ''

					DELETE	FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId <> 0
				 END 
				  DECLARE @TBL_Group TT_SavecartLineitems 
				  INSERT INTO @TBL_Group 
				  SELECT *  
				  FROM @TBL_SavecartLineitems 
				  WHERE ISNULL(GroupProductIds,'') <> '' 

				
				  EXEC Znode_InsertUpdateSaveCartLineItemGroup @TBL_Group,@userId
				  
				  DELETE FROM @TBL_SavecartLineitems 
				  WHERE ISNULL(GroupProductIds,'') <> ''
				  SET @OmsSavedCartLineItemId = 0  
				END 
				 
                IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId <> 0  ) 
				 BEGIN 
				 
				   SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId <> 0 )
				   	UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId = @OmsSavedCartLineItemId )
					WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId
				
				 --   UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
					INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
					WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					
					DELETE	FROM @TBL_SavecartLineitems WHERE OmsSavedCartLineItemId <> 0
				 END 
			 
			

			  DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT )
			  DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
			  INSERT INTO @TBL_Personalise
			  SELECT  NULL 
							,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		  ,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					  ,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					  ,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			  FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @TBL_SavecartLineitems TRTR  ) a 
			  CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 
			  
			   ----To update saved cart item personalise value from given line item
			  DECLARE @TBL_Personalise1 TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
			  INSERT INTO @TBL_Personalise1
			  SELECT  a.OmsSavedCartLineItemId 
					  ,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		  ,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					  ,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					  ,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			  FROM (SELECT TOP 1 OmsSavedCartLineItemId,PersonalisedAttribute Valuex FROM  #TBL_SavecartLineitems TRTR ) a 
			  CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
		    
			
			  CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
				   
			   INSERT INTO #tempoi
			   SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
			   FROM @TBL_SavecartLineitems a 
			   GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
			  
			   INSERT INTO #tempoi
			   SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity, @OrderLineItemRelationshipTypeIdSimple, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU 
			   FROM @TBL_SavecartLineitems  a 
			   WHERE ISNULL(BundleProductIds,'') =  '' 
			   AND  ISNULL(GroupProductIds,'') = ''	AND ISNULL(	ConfigurableProductIds,'') = ''
			   	   GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
					,Quantity,  CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
			  
     		   INSERT INTO #tempoi
			   SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
					,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
					,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
					WHEN  GroupProductIds <> '' THEN GroupProductIds 
					WHEN BundleProductIds <> '' THEN BundleProductIds 
					 ELSE SKU END     ParentSKU 
			   FROM @TBL_SavecartLineitems  a 
			   WHERE AddOnValueIds <> ''
			   	   GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
					,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
					,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
           --hack
		
		 CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
		INSERT INTO #OldValue  
		SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	  	FROM ZnodeOmsSavedCartLineItem a   
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.SKU,'')   )   
        AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple   

			

		INSERT INTO #OldValue 
		SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
		AND  b.OrderLineItemRelationshipTypeID IS NULL 
		 
		DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
		AND a.ParentOmsSavedCartLineItemId IS NOT NULL 
		
		------Merge Addon for same product
		SELECT * INTO #OldValueForAddon from #OldValue
		
		INSERT INTO #OldValue 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		
		
		------Merge Addon for same product
		IF EXISTS(SELECT * FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'') <> '' )
		BEGIN

			INSERT INTO #OldValueForAddon 
			SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
			FROM ZnodeOmsSavedCartLineItem b 
			INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
			WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
			AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

			SELECT distinct SKU, STUFF(
										( SELECT  ', ' + SKU FROM    
											( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											  where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											  FOR XML PATH('')
										), 1, 2, ''
									 ) AddOns
			INTO #AddOnsExists
			from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

			SELECT distinct a.SKU, STUFF(
										 ( SELECT  ', ' + x.AddOnValueIds FROM    
											( SELECT DISTINCT b.AddOnValueIds FROM @TBL_SavecartLineitems b
											  where a.SKU=b.SKU ) x
											  FOR XML PATH('')
										 ), 1, 2, ''
									   ) AddOns
			INTO #AddOnAdded
			from @TBL_SavecartLineitems a

			if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
			begin
				delete from #OldValue
			end

		END

		IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_SavecartLineitems ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
		ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'')  <> '' )
		BEGIN 
		
		DELETE FROM #OldValue 
		END 
		ELSE 
		BEGIN 
	    
		 IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'')  <> '' )
		 BEGIN 
		 
		 DECLARE @parenTofAddon  TABLE( ParentOmsSavedCartLineItemId INT  )  
		 INSERT INTO  @parenTofAddon 
		 SELECT  ParentOmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
					AND ParentOmsSavedCartLineItemId IS NOT NULL  
					AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		 AND ParentOmsSavedCartLineItemId IS  NULL  
		 
		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 

		 -- SELECT 3
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a 
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple  )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		    
			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		 AND ParentOmsSavedCartLineItemId IS  NULL  

		 END
		 ELSE IF  EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		      AND EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'')  = '' )
		 BEGIN 

		   DELETE FROM #OldValue
		 END 
		END 
			
	

		DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
		INSERT INTO @TBL_Personaloldvalues
		SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
		FROM ZnodeOmsPersonalizeCartItem  a 
		WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
		

		IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		   AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
		BEGIN 
		 DELETE FROM #OldValue
		END 
		ELSE 
		BEGIN 
		 IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		   
		   DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
		   SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
		   OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		   
		
		   
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		   
		   

		   DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
		   OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
		   
		  
		   
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		        AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		       AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		 BEGIN 
		     DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		 END 


		  
		END 

		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
		--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
		;with cte as
		(
			SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.SKU
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @TBL_SavecartLineitems a 
			Inner Join #OldValue b on a.SKU = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
			WHERE a.OmsSavedCartLineItemId = 0
		)
		delete b1
		from cte a1		  
		Inner Join #OldValue b1 on a1.sku = b1.SKU
		where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)

		IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
		BEGIN 

		UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)


		END 
		ELSE 
		BEGIN 
		
		
			   
    SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
     INTO #yuuete   
     FROM  #tempoi  
     GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails ,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
     ORDER BY RowId, Id   
       	
			     
    DELETE FROM #yuuete WHERE Quantity <=0  
  
     ;WITH VTTY AS   
    (  
    SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
       FROM #yuuete m  
    INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
    WHERE m.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon   
    )   
	
    UPDATE m1   
    SET m1.RowId = TYU.RowId  
    FROM #yuuete m1   
    INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
        
    ;WITH VTRET AS   
    (  
    SELECT RowId,id,Min(NewRowId) NewRowId ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID  
    FROM #yuuete   
    GROUP BY RowId,id ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID
	Having  SKU = ParentSKU  AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdSimple
    )   
    
    DELETE FROM #yuuete WHERE NewRowId IN (SELECT NewRowId FROM VTRET)  
	
	

	
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
       OUTPUT INSERTED.OmsSavedCartLineItemId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  

 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID
				
    --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL   
  

    
    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
	INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1 
    WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  and c.ParentOmsSavedCartLineItemId is null
  --  )   
  


  --  SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 --FROM ZnodeOmsSavedCartLineItem a
	 --WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
  --   AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
  --   AND a.ParentOmsSavedCartLineItemId IS NULL  
	 --AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 --AND EXISTS (SELECT TOP 1 1 FROM #Cte_newAddon TI WHERE TI.SKU = a.SKU)



   ;with table_update AS 
   (
     SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 FROM ZnodeOmsSavedCartLineItem a
	 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
     AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
     AND a.ParentOmsSavedCartLineItemId IS NULL  
	 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 AND EXISTS (SELECT TOP 1 1 FROM #Cte_newAddon TI WHERE TI.SKU = a.SKU)
   )

    UPDATE a SET  
   --SELECT  a.OmsSavedCartLineItemId,
	a.ParentOmsSavedCartLineItemId =(SELECT TOP 1 max(OmsSavedCartLineItemId) 
	FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU  GROUP BY r.ParentSKU, r.SKU  )   
    FROM table_update a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
    WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
	  FROM #Cte_newAddon  r  
    WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU   GROUP BY r.ParentSKU, r.SKU  )    IS NOT NULL 
	 

	
	  
    ;with Cte_Th AS   
    (             
      SELECT RowId    
     FROM #yuuete a   
     GROUP BY RowId   
     HAVING COUNT(NewRowId) <= 1   
      )   
    UPDATE a SET a.Quantity =  NULL   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
    WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
     AND a.OrderLineItemRelationshipTypeId IS NULL   
  
    UPDATE  ZnodeOmsSavedCartLineItem   
    SET GROUPID = NULL   
    WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
    AND OrderLineItemRelationshipTypeId IS NOT NULL     
       ;With Cte_UpdateSequence AS   
     (  
       SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
       FROM ZnodeOmsSavedCartLineItem   
       WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
     )   
    UPDATE Cte_UpdateSequence  
    SET  Sequence = RowId  
	
	----To update saved cart item personalise value from given line item	
	if exists(select * from @TBL_Personalise1 where isnull(PersonalizeValue,'') <> '' and isnull(OmsSavedCartLineItemId,0) <> 0)
	Begin
		DELETE FROM ZnodeOmsPersonalizeCartItem 
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise1 yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )

		MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
		USING @TBL_Personalise1 SOURCE
			   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
		WHEN NOT MATCHED THEN 
				INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
								,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
				VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
								,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
	end		
	
	UPDATE @TBL_Personalise
	SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	FROM @OmsInsertedData a 
	INNER JOIN ZnodeOmsSavedCartLineItem b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
	WHERE b.ParentOmsSavedCartLineItemId IS NOT NULL 
	
	DELETE FROM ZnodeOmsPersonalizeCartItem 
	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
    MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
	USING @TBL_Personalise SOURCE
		   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
	WHEN NOT MATCHED THEN 
		    INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
							,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
			VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
							,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
		 
END 

	
	SET @Status = 1;
	COMMIT TRAN InsertUpdateSaveCartLineItem;
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()	
		SET @Status = 0;
		DECLARE @Error_procedure varchar(1000)= ERROR_PROCEDURE(), @ErrorMessage nvarchar(max)= ERROR_MESSAGE(), @ErrorLine varchar(100)= ERROR_LINE(), @ErrorCall nvarchar(max)= 'EXEC Znode_InsertUpdateSaveCartLineItem @CartLineItemXML = '+CAST(@CartLineItemXML
 AS varchar(max))+',@UserId = '+CAST(@UserId AS varchar(50))+',@Status='+CAST(@Status AS varchar(10));

		SELECT 0 AS ID, CAST(0 AS bit) AS Status,ERROR_MESSAGE();
		ROLLBACK TRAN InsertUpdateSaveCartLineItem;
		EXEC Znode_InsertProcedureErrorLog @ProcedureName = 'Znode_InsertUpdateSaveCartLineItem', @ErrorInProcedure = @Error_procedure, @ErrorMessage = @ErrorMessage, @ErrorLine = @ErrorLine, @ErrorCall = @ErrorCall;
	END CATCH;
END;

GO

 IF NOT EXISTS(SELECT * FROM SYS.INDEXES WHERE NAME = 'IDX_ZnodePublishProduct_PimProductId_PublishCatalogId')
BEGIN
	CREATE NONCLUSTERED INDEX [IDX_ZnodePublishProduct_PimProductId_PublishCatalogId]
    ON [dbo].[ZnodePublishProduct]([PimProductId] ASC)
    INCLUDE([PublishCatalogId]);
END

GO
 IF NOT EXISTS(SELECT * FROM SYS.INDEXES WHERE NAME = 'IDX_ZnodePimAttributeValue_PimProductId_PimAttributeId')
BEGIN
CREATE NONCLUSTERED   INDEX IDX_ZnodePimAttributeValue_PimProductId_PimAttributeId ON ZnodePimAttributeValue(PimProductId) INCLUDE (PimAttributeId) 

END
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPublishProductAttribute')
BEGIN 
	DROP PROCEDURE Znode_GetPublishProductAttribute
END
GO

CREATE PROCEDURE [dbo].[Znode_GetPublishProductAttribute]
(@PublishCatalogId INT)
AS 
/*
     Summary :- This Procedure is used to get the publish Product attribute details for a PublishCatalogId 
     Unit Testing 
     EXEC Znode_GetPublishProductAttribute 6
	 select * from znodepublishcatalog
	 select  * from znodeportal
     
*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
		
 
		     SELECT a.PimAttributeId,ISNULL(c.PimAttributeDefaultValueId,0) PimAttributeDefaultValueId
			 INTO #ProductPimAttribute
			 FROM ZnodePimAttributeValue a 
			 INNER JOIN ZnodePublishProduct b ON (b.PimProductId = a.PimProductId )
			 LEFT JOIN ZnodePimProductAttributeDefaultValue c ON (c.PimAttributeValueId = a.PimAttributeValueId)
			 WHERE PublishCatalogId = @PublishCatalogId
			 GROUP BY  PimAttributeId,ISNULL(c.PimAttributeDefaultValueId,0)	


			SELECT  @PublishCatalogId  ZnodeCatalogId,AttributeCode,AttributeTypeName,IsComparable,IsHtmlTags,IsFacets,IsUseInSearch,IsPersonalizable,                   
			IsConfigurable , ZPAL.AttributeName , ZPAL.LocaleId ,ZPA.DisplayOrder,zpa.PimAttributeId
			INTO #AttributeValueFacet
			FROM ZnodePimAttribute ZPA 
			INNER JOIN ZnodeAttributeType ZAT ON(ZAT.AttributeTypeId = ZPA.AttributeTypeId)
			INNER JOIN ZnodePimAttributeLocale ZPAL on ( ZPA.PimAttributeId = ZPAL.PimAttributeId ) 
			INNER JOIN ZnodePimFrontendProperties ZPFP ON(ZPA.PimAttributeId = ZPFP.PimAttributeId)
			WHERE EXISTS (SELECT TOP 1 1 FROM #ProductPimAttribute TYU WHERE TYU.PimAttributeId = ZPA.PimAttributeId)
		

            SELECT  ZPA.ZnodeCatalogId,AttributeCode,AttributeTypeName,IsComparable,IsHtmlTags,IsFacets,IsUseInSearch,IsPersonalizable,                   
			IsConfigurable , ZPA.AttributeName , ZPA.LocaleId 
			,ZPA.DisplayOrder,ZPDAV.DisplayOrder AS DefaultValueDisplayOrder, CASE WHEN AttributeCode IN ('Brand','ProductType','OutOfStockOptions') THEN ZPDAV.AttributeDefaultValueCode ELSE ZPDAVL.AttributeDefaultValue END
			AttributeDefaultValue
			FROM #AttributeValueFacet ZPA 
			INNER JOIN ZnodePimAttributeDefaultValue ZPDAV ON (ZPDAV.PimAttributeId = ZPA.PimAttributeId)
			INNER JOIN ZnodePimAttributeDefaultValueLocale ZPDAVL ON (ZPDAVL.PimAttributeDefaultValueId = ZPDAV.PimAttributeDefaultValueId)
			WHERE EXISTS (SELECT TOP 1 1 FROM #ProductPimAttribute TY WHERE TY.PimAttributeDefaultValueId = ZPDAV.PimAttributeDefaultValueId )


		    UNION ALL
			SELECT DISTINCT ZPA.ZnodeCatalogId,AttributeCode,AttributeTypeName,IsComparable,IsHtmlTags,IsFacets,IsUseInSearch,IsPersonalizable,                   
			IsConfigurable , ZPA.AttributeName , ZPA.LocaleId 
			,ZPA.DisplayOrder,NULL AS DefaultValueDisplayOrder, NULL AS AttributeDefaultValue
			FROM #AttributeValueFacet ZPA 
			
			UNION ALL
			SELECT DISTINCT ZPA.ZnodeCatalogId,AttributeCode,AttributeTypeName,IsComparable,IsHtmlTags,IsFacets,IsUseInSearch,IsPersonalizable,                   
			IsConfigurable , ZPA.AttributeName , ZPA.LocaleId 
			,ZPA.DisplayOrder,NULL AS DefaultValueDisplayOrder, NULL AS AttributeDefaultValue
			FROM #AttributeValueFacet ZPA 
			
			UNION ALL
			SELECT DISTINCT ZPA.ZnodeCatalogId,AttributeCode,AttributeTypeName,IsComparable,IsHtmlTags,IsFacets,IsUseInSearch,IsPersonalizable,                   
			IsConfigurable , ZPA.AttributeName , ZPA.LocaleId 
			,ZPA.DisplayOrder,NULL AS DefaultValueDisplayOrder, NULL AS AttributeDefaultValue
			FROM #AttributeValueFacet ZPA 
			
			

         END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(),
			 @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishProductAttribute @PublishCatalogId= '+CAST(@PublishCatalogId AS VARCHAR(10))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPublishProductAttribute',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_PurgeData')
BEGIN 
	DROP PROCEDURE Znode_PurgeData
END
GO

CREATE PROCEDURE [dbo].[Znode_PurgeData] 
(
 
  @DeleteAllProduct    							BIT = 0 -- This flag 1 will delete all product except ids in @ExceptProductId  table 
 ,@DeleteAllCategory							BIT = 0 -- This flag 1 will delete all category except ids in @ExceptCategoryId  table 
 ,@DeleteAllCatalog								BIT = 0 -- This flag 1 will delete all catalog except ids in @ExceptCatalogId  table 
 ,@DeleteAllSaveCart							Bit = 0	-- This flag 1 will delete all save carts of users.  
 ,@DeleteAllOrder								BIT = 0	-- This flag 1 will delete all orders. 
 ,@DeleteAllAccount								BIT = 0 -- This flag 1 will delete all Account. 
 ,@DeleteAllUser								BIT = 0 -- This flag 1 will delete all user. 
 ,@DeleteAllStore 								BIT = 0 -- This flag 1 will delete all store. 
 ,@DeleteAllGlobalAttribute  					BIT = 0 -- This flag 1 will delete all Global Attribute. 
 ,@DeleteAllProductCategoryAttribute			BIT = 0 -- This flag 1 will delete all Pim Attribute. 
 ,@DeleteAllMedia								BIT = 0 -- This flag 1 will delete all media. 
 ,@DeleteAllWarehouse							BIT = 0 -- This flag 1 will delete all warhouse. 
 ,@DeleteAllPricelist							BIT = 0 -- This flag 1 will delete all price list. 
 ,@DeleteAllProfile								BIT = 0 -- This flag 1 will delete all Profiles. 
 ,@DeleteAllSiteSearchData						BIT = 0	-- This flag 1 will delete all data related to search. 
 ,@DeleteAllCMSData								BIT = 0 -- This flag 1 will delete all CMS data. 
 ,@DeleteAllBrand								BIT = 0 -- This flag 1 will delete all brand. 
 ,@DeleteAllVendor								BIT = 0 -- This flag 1 will delete all vendor. 
 ,@DeleteAllCmsSeoDetails						BIT = 0 -- This flag 1 will delete all Seo details .   
 ,@ResetDomainData								BIT = 0 -- This flag 1 will delete and rest all domain. 
 ,@ExceptProductId								TransferId Readonly
 ,@ExceptCategoryId								TransferId Readonly
 ,@ExceptCatalogId								TransferId Readonly
 ,@ExceptAccountId								TransferId Readonly
 ,@ExceptUserId 								TransferId Readonly
 ,@ExceptStoreId 								TransferId Readonly 
 ,@ExceptGlobalAttributeId 						TransferId Readonly
 ,@ExceptProductCategoryAttributeId 		    TransferId Readonly
 ,@ExceptMediaId								TransferId Readonly
 ,@ExceptWarehouseId							TransferId ReadOnly 
 ,@ExceptPricelistId							TransferId ReadOnly 
 ,@ExceptProfileId								TransferId ReadOnly
 ,@ExceptSeoType								VARCHAR(2000) = ''
 ,@ResetIdentity								BIT = 0    -- Reset identity 
 ,@DeleteAllData								BIT = 0 	
 ,@DeleteAllShippingMethods						BIT = 0 
 ,@DeleteAllPaymentMethods						BIT = 0 
 ,@DeleteAllTaxes								BIT = 0 
)
AS 
BEGIN 
SET NOCOUNT ON 
 	 BEGIN TRY
	    DECLARE @StatusOut Table (Id INT ,Message NVARCHAR(max), Status BIT )
		DECLARE @DeletedIds TransferId 
		DECLARE @PortalId INT , @CMSThemeId INT , @CMSThemeCSSId INT,@PublishCatalogId INT
		,@PimCatalogId INT  
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  Object_Id('elmah_error')	 <> 0 
		BEGIN 
			 TRUNCATE TABLE elmah_error
			 DELETE FROM ZnodeImportLog
			 DELETE FROM ZnodeImportProcesslog
			 DELETE FROM ZnodeActivityLog	
             DELETE FROM ZnodePasswordLog	
             DELETE FROM ZnodeProceduresErrorLog
		END 
	
		DECLARE @DeleteId  NVARCHAR(max)= '', @StoreData NVARCHAR(max),@RunTime INT =1 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllVendor = 1   OR @DeleteAllData =1 
			BEGIN 
			 	INSERT INTO @DeletedIds 
				SELECT PimVendorId 
				FROM ZnodePimVendor ZP 
							
				INSERT INTO @StatusOut(id ,Status) 
				EXEC [dbo].[Znode_DeleteVendor] @PimVendorIds = @DeletedIds ,@Status = 0  
			    
				DELETE FROM ZnodePimProductAttributeDefaultValue WHERE PimAttributeValueId IN (
				SELECT PimAttributeValueId  
				FROM ZnodePimAttributeValue WHERE PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode= 'Vendor') )
				
				DELETE FROM ZnodePimAttributeValue WHERE PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode= 'Vendor') 

				DELETE FROM ZnodePimAttributeDefaultValueLocale  WHERE PimAttributeDefaultValueId IN (
				SELECT PimAttributeDefaultValueId FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode IN (SELECT VendorCode FROM ZnodePimVendor ))
				
				DELETE FROM  ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode IN (SELECT VendorCode FROM ZnodePimVendor )

			    PRINT '<-- Vendor Data Deleted Sucessfully-->'
				
			END
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			IF  @DeleteAllBrand = 1  OR @DeleteAllData =1 
			BEGIN 
			   INSERT INTO @DeletedIds 
			   SELECT BrandId
			   FROM ZnodeBrandDetails a
			   INSERT INTO @StatusOut (Id ,Status) 
			   EXEC [dbo].[Znode_DeleteBrand] @BrandIds = @DeletedIds, @Status = 0   
			 IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Brand Data Deleted Sucessfully-->'
			   END
			   ELSE 
				BEGIN 
				PRINT '<-- Brand Data Not Deleted Properly -->' 
				END  
		    END 
				
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllProduct = 1  OR @DeleteAllData =1 
		BEGIN 
		   	 INSERT INTO @DeletedIds 
		     SELECT PimProductId 
			 FROM ZnodePimProduct ZPP 
			 WHERE NOT EXISTS (SELECT TOP 1 1 FROM @ExceptProductId WHERE id = ZPP.PimProductId) 
			  INSERT INTO @StatusOut (Id ,Status) 
			  EXEC [dbo].[Znode_DeletePimProducts] @PimProductIds=@DeletedIds , @Status = 0   
			
			SELECT PimAddonGroupId,PimProductId,PimAddOnProductId  
			INTO #Temp_Addon 
			FROM ZnodePimAddOnProduct ZPP
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM @ExceptProductId WHERE id = ZPP.PimProductId)

			DELETE FROM ZnodePimAddOnProductDetail WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddOnProductId  = ZnodePimAddOnProductDetail.PimAddOnProductId )
			
			DELETE FROM  ZnodePimAddOnProduct  WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddOnProductId  = ZnodePimAddOnProduct.PimAddOnProductId )
			
			DELETE FROM ZnodePimAddonGroupLocale WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddonGroupId  = ZnodePimAddonGroupLocale.PimAddonGroupId )
			DELETE FROM ZnodePimAddonGroupProduct 	WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddonGroupId  = ZnodePimAddonGroupProduct.PimAddonGroupId )
			DELETE FROM ZnodePimAddonGroup 	WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddonGroupId  = ZnodePimAddonGroup.PimAddonGroupId )
			IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Product Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Product Data Not Deleted Properly -->' 
				END  
			  
	    END 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllCategory = 1 	  OR @DeleteAllData =1 
		BEGIN   
		   		INSERT INTO @DeletedIds 
				SELECT  PimCategoryId 
				FROM ZnodePimCategory ZPC
				WHERE NOT EXISTS  (SELECT TOP 1 1 FROM @ExceptCategoryId WHERE id =ZPC.PimCategoryId )
				--Remove extra products from catalog
				INSERT INTO @StatusOut (Id ,Status) 
				EXEC Znode_DeletePimCategory @PimCategoryId = @DeletedIds, @Status = 1;
			
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Category Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Category Data Not Deleted Properly -->' 
				END     
		  END
		  DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		  IF  @DeleteAllCatalog = 1 	OR @DeleteAllData =1 
		   BEGIN
		   	 INSERT INTO @DeletedIds 
		   	 SELECT PimCatalogId 
			 FROM ZnodePimCatalog ZP 
			 WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptCatalogId WHERE id = ZP.PimCatalogId)
		   	 INSERT INTO @StatusOut (Id ,Message,Status) 
			 EXEC [dbo].[Znode_DeletePimCatalog] @PimCatalogId = @DeletedIds ,@IsForceFullyDelete = 1  
		      

			 IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Catalog Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Catalog Data Not Deleted Properly -->' 
				END  
           END
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		   IF  @DeleteAllOrder = 1 	OR @DeleteAllData =1 
		   BEGIN
				 INSERT INTO @DeletedIds 
		   		 SELECT OmsOrderID 
				 FROM ZnodeOmsOrder  ZP 
				 INSERT INTO @StatusOut (Id ,Status) 
			     EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIds , @status = 0  
		    
		        IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Order Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Order Data Not Deleted Properly -->' 
				END  
		  END
		
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut
		   IF  @DeleteAllSaveCart = 1  OR @DeleteAllData =1 
		   BEGIN
		      DELETE FROM ZnodeOmsPersonalizeCartItem
			  DELETE FROM ZnodeOmsSavedCartLineItem 
			  DELETE FROM ZnodeOmsSavedCart
			  DELETE FROM ZnodeOmsCookieMapping
			  DELETE FROM ZnodeOmsQuotePersonalizeItem 
			  DELETE FROM ZnodeOmsQuoteLineItem
			  DELETE FROM ZnodeOmsQuote
			  DELETE FROM ZnodeOmsTemplateLineItem 
			  DELETE FROM ZnodeOmsTemplate
			 
		      PRINT '<-- Save Cart & Quote Data Deleted Sucessfully -->'
			  
		   END
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		   IF  @DeleteAllUser = 1 OR @DeleteAllData =1 
		   BEGIN  
		  
			   INSERT INTO @DeletedIds 
			   SELECT UserId
			   FROM ZnodeUser ZU 
			   WHERE NOT EXISTS (SELECT TOP 1  1 FROM @ExceptUserId RT WHERE RT.Id = ZU.UserId) 
			 --  INSERT INTO @StatusOut (Id ,Status) 
			   EXEC Znode_DeleteUserDetails @UserIds =@DeletedIds ,@Status = 0 , @IsForceFullyDelete =1 

			DELETE FROM AspNetUsers  WHERE NOT EXISTS (SELECT TOP 1 1 FROM AspNetZnodeUser rt WHERE rt.AspNetZnodeUserId = AspNetUsers.UserName )

		     	PRINT '<-- User Data Deleted Sucessfully-->'
			  
		   END
	    DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllAccount = 1 	OR @DeleteAllData =1 
		  BEGIN    
				 INSERT INTO @DeletedIds 
				  SELECT AccountId
			      FROM ZnodeAccount ZU 
			      WHERE NOT EXISTS (SELECT TOP 1  1 FROM @ExceptAccountId RT WHERE RT.Id = ZU.AccountiD) 
			    -- INSERT INTO @StatusOut (Id ,Status) 
				  EXEC Znode_DeleteAccount @AccountIds =  @DeletedIds,@Status= 0,@IsForceFullyDelete =1  
				 
		     	PRINT '<-- Accouts Data Deleted Sucessfully-->'
			    
		  END
		 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		 IF  @DeleteAllGlobalAttribute = 1 	 OR @DeleteAllData =1 
		   BEGIN 
		   	INSERT INTO @DeletedIds 
			SELECT GlobalAttributeId 
			FROM ZnodeGlobalAttribute ZP 
			WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptGlobalAttributeId a WHERE a.Id = ZP.GlobalAttributeId)
			AND ISNULL(ZP.IsSystemDefined,0) <> 1
			INSERT INTO @StatusOut (Id ,Status) 	   
			EXEC [dbo].[Znode_DeleteGlobalAttribute] @GlobalAttributeIds= @DeletedIds,@Status =0 , 	@IsForceFullyDelete= 1    
			
			DELETE FROM ZnodeGlobalAttributeGroupLocale	WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1 )
			DELETE FROM ZnodeGlobalAttributeGroupMapper WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)
			DELETE FROM ZnodeGlobalGroupEntityMapper WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)
			DELETE FROM ZnodeFormBuilderAttributeMapper	WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)
			DELETE FROM ZnodeGlobalAttributeGroup	WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)   
			 
			   IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Global Attribute Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Global Attribute Not Deleted Properly -->' 
				END 	   
		   END  
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		   IF  @DeleteAllProductCategoryAttribute = 1  OR @DeleteAllData =1 
		   BEGIN 
			   	INSERT INTO @DeletedIds 
				SELECT PimAttributeId
				FROM ZnodePimAttribute ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptProductCategoryAttributeId WHERE id = ZP.PimAttributeId )
				AND ZP.IsSystemDefined <> 1 
				INSERT INTO @StatusOut (Id ,Status) 			
				EXEC Znode_DeletePimAttributeWithReference @PimAttributeIds = @DeletedIds  , @Status = 1  
			  
			    DELETE FROM ZnodePimAttributeGroupLocale 
					WHERE PimAttributeGroupId IN (SELECT PimAttributeGroupId FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimAttributeGroupMapper wHERE PimAttributeGroupId IN (SELECT PimAttributeGroupId FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimFamilyGroupMapper 
					WHERE PimAttributeGroupId IN (SELECT PimAttributeGroupId FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  

				
				DELETE FROM ZnodePimFamilyLocale WHERE  PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )
				UPDATE ZP SET PimAttributeFamilyId = dbo.Fn_GetDefaultPimProductFamilyId() FROM ZnodePimProduct  ZP  WHERE  PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )

				DELETE FROM ZnodeImportTemplateMapping WHERE ImportTemplateId IN (SELECT ImportTemplateId FROM ZnodeImportTemplate WHERE PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  ))
				DELETE FROM ZnodeImportTemplate WHERE PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimFamilyGroupMapper 
					WHERE PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )
				
				DELETE  FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1 
				UPDATE ZP SET PimAttributeFamilyId = dbo.Fn_GetDefaultPimProductFamilyId() FROM ZnodePimAttributeValue  ZP  WHERE  PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  ) 
			   	IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- PIM Attribute Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- PIM Attribute Not Deleted Properly -->' 
				END 
		   END
		   DELETE FROM @DeletedIds 
		   DELETE FROM @StatusOut 
		   IF  @DeleteAllMedia = 1  OR @DeleteAllData =1 
		   BEGIN 
		  		INSERT INTO @DeletedIds 
		   		SELECT  MediaId   
				FROM ZnodeMedia ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptMediaId WHERE id = ZP.Mediaid )
				INSERT INTO @StatusOut (Id ,Message,Status)
				EXEC Znode_DeleteMedia @MediaIds = @DeletedIds  , @Status = 1  ,@IsCallInternal =1 
				DELETE FROM ZnodeMediaPathLocale WHERE MediaPathId IN (SELECT MediaPathId FROM ZnodeMediaPath WHERE PathCode<>'Root')
				DELETE FROM ZnodeMediaPath WHERE PathCode<>'Root'
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Media Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Media Not Deleted Properly -->' 
				END
				
		   END 
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		
		   IF  @DeleteAllWarehouse = 1 OR @DeleteAllData =1 
		   BEGIN 
		   	
		   		SET @DeleteId =  SUBSTRING((
				SELECT  ',' + CONVERT(NVARCHAR(500), WarehouseId)  
				FROM ZnodeWarehouse ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptWarehouseId WHERE id = ZP.WarehouseId )
				FOR XML PATH ('')
				),2,4000) 
				INSERT INTO @StatusOut (Id ,Status)
			    EXEC Znode_DeleteWarehouse @WarehouseId = @DeleteId  , @Status = 1 
		
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Warehouse Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Warehouse Not Deleted Properly -->' 
				END
		    END 
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		
			IF  @DeleteAllPricelist = 1   OR @DeleteAllData =1 
		    BEGIN 
				SET @DeleteId =  SUBSTRING((
				SELECT ',' + CONVERT(NVARCHAR(500), PriceListId)  
				FROM ZnodePriceList ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptPricelistId WHERE id = ZP.PriceListId )
				FOR XML PATH ('')
				),2,4000) 
			  
				INSERT INTO @StatusOut (Id ,Status)  
				EXEC Znode_DeletePriceList @PriceListId = @DeleteId  , @Status = 1 
		      
			   IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Price List Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Price List Not Deleted Properly -->' 
				END
		    END
		
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			IF  @DeleteAllProfile = 1  OR @DeleteAllData =1 
			 BEGIN 
				SET @DeleteId =  SUBSTRING((
				SELECT ',' + CONVERT(NVARCHAR(500), ProfileId)  
				FROM ZnodeProfile ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptProfileId WHERE id = ZP.ProfileId )
				FOR XML PATH ('')
				),2,4000) 
		   	 	INSERT INTO @StatusOut (Id ,Status)
				EXEC  Znode_DeleteProfile  @ProfileId=@DeleteId, @Status = 0 ,	@IsForceFullyDelete =1 
				
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Profile Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Profile Not Deleted Properly -->' 
				END
		    END
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			IF  @DeleteAllSiteSearchData  = 1  OR @DeleteAllData =1 
			BEGIN 
			
					DELETE FROM ZnodeSearchIndexServerStatus
					DELETE FROM ZnodeSearchIndexMonitor
					DELETE FROM ZnodeCatalogIndex
					DELETE FROM ZnodePublishCatalogSearchProfile
					DELETE FROM ZnodeCatalogIndex
					DELETE FROM ZnodeCMSCustomerReview 
					DELETE FROM ZnodePublishPortalLog
					DELETE FROM ZnodeListViewFilter
					DELETE FROM ZnodeListView
			
					PRINT '<-- Site Search Data Deleted Sucessfully-->'
			 END
			 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			 IF  @DeleteAllCMSData = 1 	OR @DeleteAllData =1 
			 BEGIN 
				IF EXISTS (SELECT TOP 1 1  FROM SYS.Tables WHERE name = '_ZnodeCMSPortalTheme' )
				BEGIN
				 DROP TABLE _ZnodeCMSPortalTheme 
				END 
				SELECT * 
				INTO _ZnodeCMSPortalTheme
				FROM ZnodeCMSPortalTheme
				DELETE FROM ZnodeCMSContentPagesProfile 
				DELETE FROM ZnodeFormWidgetEmailConfiguration
				DELETE FROM ZnodeCMSWidgetTitleConfigurationLocale
				DELETE FROM ZnodeCMSWidgetTitleConfiguration
				DELETE FROM ZnodeCMSTextWidgetConfiguration
				DELETE FROM ZnodeCMSFormWidgetConfiguration
				DELETE FROM ZnodeCMSPortalProductPage
				DELETE FROM ZnodeCMSContentPageGroupMapping
				DELETE FROM ZnodeCMSContentPageGroupLocale
				DELETE FROM ZnodeCMSContentPageGroup
				DELETE FROM ZnodeCMSContentPagesLocale
				DELETE FROM ZnodeCMSContentPages
				DELETE FROM ZnodeCMSContentPagesProfile
				DELETE FROM ZnodeCMSPortalTheme  
			    DELETE FROM ZnodeCMSThemeCSS 
				DELETE FROM ZnodeCMSTheme  
				DELETE FROM ZnodeEmailTemplateMapper
				DELETE FROM ZnodeEmailTemplateLocale
				DELETE FROM ZnodeEmailTemplateAreas
				DELETE FROM ZnodeEmailTemplate
			    DELETE FROM ZnodeCMSWidgetSliderBanner
				DELETE FROM ZnodeCMSSliderBannerLocale
				DELETE FROM ZnodeCMSSliderBanner
				DELETE FROM ZnodeCMSSlider
				DELETE FROM ZnodeCmsPortalMessage
				DELETE FROM ZnodeCMSPortalMessageKeyTag
				DELETE FROM ZnodeCMSMessage 
				DELETE FROM ZnodeCMSMessageKey 
				DELETE FROM ZnodeCMSTemplate
				DELETE FROM ZnodeFormBuilderGlobalAttributeValueLocale 
				DELETE FROM ZnodeFormBuilderGlobalAttributeValue
				DELETE FROM ZnodeFormBuilderAttributeMapper 
				DELETE FROM ZnodeFormBuilderSubmit 
				DELETE FROM ZnodeFormBuilder

				IF NOT EXISTS (SELECT TOP 1 1  FROM ZnodeCMSTheme)
				BEGIN 
			   INSERT INTO ZnodeCMSTheme(Name
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate
			,IsParentTheme
			,ParentThemeId)
			SELECT 'Default',2,GETDATE(),2,GETDATE(),1,NULL
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSTheme WHERE Name = 'Default')

			SET @CMSThemeId = CASE WHEN @CMSThemeId	 IS NULL THEN (SELECT TOP 1 CMSThemeId FROM ZnodeCMSTheme WHERE Name = 'Default'   )  ELSE  @CMSThemeId END 
			INSERT INTO ZnodeCMSThemeCSS  (CMSThemeId
			,CSSName
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate)
			SELECT @CMSThemeId,'DefaultCSS',2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSThemeCSS WHERE CSSName = 'DefaultCSS')
	  	
			SET @CMSThemeCSSId = CASE WHEN @CMSThemeCSSId IS NULL THEN (SELECT TOP 1 CMSThemeCSSId FROM ZnodeCMSThemeCSS 
			WHERE CSSName = 'DefaultCSS'
			) ELSE 	@CMSThemeCSSId END 

			 INSERT INTO ZnodeCMSPortalTheme (PortalId
					,CMSThemeId
					,CMSThemeCSSId
					,MediaId
					,FavIconId
					,WebsiteTitle
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate)
			 SELECT DISTINCT PortalId
					,@CMSThemeId
					,@CMSThemeCSSId
					,MediaId
					,FavIconId
					,WebsiteTitle
					,2
					,GETDATE()
					,2
					,GETDATE() 
			 FROM _ZnodeCMSPortalTheme	TYU 
			 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodeCMSPortalTheme TY  WHERE TY.PortalId = TYU.PortalId AND TY.CMSThemeId = @CMSThemeId AND TY.CMSThemeCSSId = @CMSThemeCSSId)
			 
			 END 

			 PRINT '<-- CMS Data Deleted Sucessfully-->'	  			   
			 IF  NOT EXISTS (SELECT TOP 1 1  FROM ZnodeCMSContentPageGroup )
			 BEGIN 
			    DECLARE @GroupId INT =0 
				INSERT INTO ZnodeCMSContentPageGroup (ParentCMSContentPageGroupId ,Code,CreatedBy,CreatedDate,ModIFiedBy,ModIFiedDate)
				SELECT NULL,'Root',2,GETDATE(),2,GETDATE()
			    SET @GroupId = SCOPE_IDENTITY()
				INSERT INTO ZnodeCMSContentPageGroupLocale(CMSContentPageGroupId,Name,LocaleId,CreatedBy,CreatedDate,ModIFiedBy,ModIFiedDate)
			    SELECT @GroupId,'Root',1,2,GETDATE(),2,GETDATE()
			 END
			 END 
	 		 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			 IF  @DeleteAllCmsSeoDetails =1 OR @DeleteAllData =1 
			 BEGIN 
			 
			   DELETE FROM ZnodeCMSSEODetailLocale 
			   WHERE CMSSEODetailId IN (SELECT CMSSEODetailId FROM ZnodeCMSSEODetail a 
			   INNER JOIN ZnodeCMSSEOType b ON (b.CMSSEOTypeId = a.CMSSEOTypeId)
			   WHERE NOT EXISTS (SELECT TOP 1 1 FROM dbo.split(@ExceptSeoType,',') t WHERE t.Item = b.Name))
			  
			   DELETE FROM ZnodeCMSSEODetail 
			   WHERE CMSSEODetailId IN (SELECT CMSSEODetailId FROM ZnodeCMSSEODetail a 
			   INNER JOIN ZnodeCMSSEOType b ON (b.CMSSEOTypeId = a.CMSSEOTypeId)
			   WHERE NOT EXISTS (SELECT TOP 1 1 FROM dbo.split(@ExceptSeoType,',') t WHERE t.Item = b.Name))
			   PRINT '<-- SEO Data Deleted Sucessfully-->'
			END 
			
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllStore = 1   OR @DeleteAllData =1 
		   BEGIN 
		   DECLARE @TBL_PortalIds TABLE	 ( PortalId int	);
		   DECLARE @TBL_Promotion TABLE ( PromotionId int	);
		  	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.tables WHERE Name = '_ZnodeDomain')
			BEGIN
				   CREATE TABLE  _ZnodeDomain (PortalId INT  ,DomainName NVARCHAR(max),IsActive BIT ,ApplicationType NVARCHAR(max),CreatedBy INT
		   ,CreatedDate DATETIME ,ModifiedBy INT ,ModIFiedDate DATETIME )
			END 


		   INSERT INTO _ZnodeDomain ( PortalId,DomainName ,IsActive  ,ApplicationType ,CreatedBy,CreatedDate ,ModIFiedBy ,ModIFiedDate) 
		   SELECT PortalId,DomainName ,IsActive  ,ApplicationType ,CreatedBy,CreatedDate ,ModIFiedBy ,ModIFiedDate
		   FROM ZnodeDomain 
		   DECLARE @TBL_DeletedUsers TABLE (AspNetUserId NVARCHAR(1000))

		       SET @DeleteId = Substring((select  ',' + convert(nvarchar(500), PromotionId)  
					FROM ZnodePromotion  SP
					WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptStoreId WHERE id = SP.PortalId )
					for XML Path ('')),2,4000) 
			   
			   

		-- inserting PortalIds which are not present in Order and Quote
		   INSERT INTO @TBL_PortalIds 
		   SELECT PortalId FROM ZnodePortal AS SP
		   WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptStoreId WHERE id = SP.PortalId );

		  	INSERT INTO @StatusOut (Id ,Status)
				EXEC Znode_DeletePromotion  @PromotionId = @DeleteId ,@Status = 1;

		
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Store Promotion Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Store Promotion Data Not Deleted Properly -->' 
				END	

-------------------------------------------------

			   DELETE FROM ZnodeGiftCardHistory	
                 WHERE EXISTS( SELECT *  FROM ZnodeGiftCard B	
                               WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS a	
                                                              WHERE a.PortalId = B.PortalId	) AND ZnodeGiftCardHistory.GiftCardId = B.GiftCardId );
	
	
                    DELETE FROM ZnodeRmaRequestItem	
                    WHERE EXISTS( SELECT *  FROM ZnodeGiftCard B WHERE EXISTS ( SELECT TOP 1 1	FROM @TBL_PortalIds AS a  WHERE a.PortalId = B.PortalId	
                              ) AND ZnodeRmaRequestItem.GiftCardId = B.GiftCardId );
	
	
                DELETE FROM ZnodeGiftCardLocale
                    WHERE EXISTS( SELECT *  FROM ZnodeGiftCard B	
                                            WHERE EXISTS ( SELECT TOP 1 1	FROM @TBL_PortalIds AS a	
                                             WHERE a.PortalId = B.PortalId	  ) AND ZnodeGiftCardLocale.GiftCardId = B.GiftCardId );
	
                    	
                    DELETE FROM ZnodeGiftCard	
                    WHERE EXISTS ( SELECT TOP 1 1	
                        FROM @TBL_PortalIds AS a	
                        WHERE a.PortalId = ZnodeGiftCard.PortalId	 );
		
                    DELETE FROM ZnodePortalLoginProvider	
                    WHERE EXISTS ( SELECT TOP 1 1	  FROM @TBL_PortalIds AS a	 WHERE a.PortalId = ZnodePortalLoginProvider.PortalId  );

--------------------------------------------------------------------------------------------------------

		 DELETE FROM  ZnodeBrandPortal  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeBrandPortal.PortalId);
	    DELETE FROM  ZnodeCustomPortalDetail  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCustomPortalDetail.PortalId);
		
		 DELETE FROM  ZnodeSupplier WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSupplier.PortalId)

	     DELETE FROM  ZnodeOmsTemplateLineItem  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeOmsTemplate ZOT ON 
	     TBP.PortalId = ZOT.PortalId AND ZOT.OmsTemplateId = ZnodeOmsTemplateLineItem.OmsTemplateId);

	     DELETE FROM ZnodeOmsTemplate WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsTemplate.PortalId);
	     DELETE FROM  ZnodeOmsUsersReferralUrl WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsUsersReferralUrl.PortalId)

		DELETE FROM ZnodePortalShipping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShipping.PortalId);
		DELETE FROM ZnodePortalTaxClass WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalTaxClass.PortalId);
		DELETE FROM ZnodePortalPaymentSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPaymentSetting.PortalId);
		DELETE FROM ZnodeCMSPortalMessageKeyTag WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessageKeyTag.PortalId);
		DELETE FROM ZnodePriceListProfile WHERE PortalProfileID IN (SELECT PortalProfileID FROM ZnodePortalProfile WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalProfile.PortalId))
		DELETE FROM ZnodePortalProfile WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalProfile.PortalId);
		DELETE FROM ZnodePortalFeatureMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalFeatureMapper.PortalId);
		DELETE FROM ZnodePortalShippingDetails WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShippingDetails.PortalId);
		DELETE FROM ZnodePortalUnit WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalUnit.PortalId);
		DELETE FROM ZnodeDomain WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeDomain.PortalId);
		
		DELETE FROM ZnodePortalSearchProfile   WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSearchProfile.PortalId);
		DELETE FROM dbo.ZnodePortalPixelTracking WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPixelTracking.PortalId); 
		DELETE FROM ZnodeRobotsTxt WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeRobotsTxt.PortalId);
		DELETE FROM ZnodePortalSmtpSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSmtpSetting.PortalId);
		DELETE FROM ZnodeActivityLog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeActivityLog.PortalId);
		DELETE FROM ZnodePortalCatalog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCatalog.PortalId );
		DELETE FROM ZnodeCMSPortalMessage  WHERE EXISTS  ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessage.PortalId );
		DELETE FROM ZnodeGoogleTagManager WHERE  EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGoogleTagManager.PortalId);
		DELETE FROM ZnodeTaxRuleTypes WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRuleTypes.PortalId);
		DELETE FROM ZnodeCMSContentPagesProfile WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
											WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesProfile.CMSContentPagesId )
		DELETE FROM ZnodeCMSContentPageGroupMapping WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPageGroupMapping.CMSContentPagesId )
	     DELETE FROM ZnodeCMSContentPagesLocale WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesLocale.CMSContentPagesId )
		
		DELETE FROM ZnodeBlogNewsCommentLocale WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNewsComment ZBC
													WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
														WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZBC.BlogNewsId ) and ZBC.BlogNewsCommentId = ZnodeBlogNewsCommentLocale.BlogNewsCommentId)
		DELETE FROM ZnodeBlogNewsComment WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
													WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsComment.BlogNewsId )
		 
		DELETE FROM ZnodeBlogNewsContent WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
													WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsContent.BlogNewsId )
		DELETE FROM ZnodeBlogNewsLocale WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsLocale.BlogNewsId )
													
		DELETE FROM ZnodeBlogNews WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeBlogNews.PortalId)
		DELETE FROM  ZnodeFormWidgetEmailConfiguration 	WHERE CMSContentPagesId IN (SELECT CMSContentPagesId FROM ZnodeCMSContentPages WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSContentPages.PortalId))
		DELETE FROM ZnodeCMSContentPages WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSContentPages.PortalId);
		DELETE FROM ZnodeCaseRequestHistory WHERE CaseRequestId IN (SELECT CaseRequestId   FROM ZnodeCaseRequest WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCaseRequest.PortalId))
		DELETE FROM ZnodeCaseRequest WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCaseRequest.PortalId);
		DELETE FROM ZnodePortalLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalLocale.PortalId);
		DELETE FROM ZnodeShippingPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeShippingPortal.PortalId);
		DELETE FROM ZnodePortalDisplaySetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalDisplaySetting.PortalId);
		
		DELETE FROM   @DeletedIds
		INSERT INTO @DeletedIds 
		SELECT DISTINCT UserId 
		FROM ZnodeUserPortal 
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId);

		--INSERT INTO @StatusOut (Id ,Status) 
		EXEC [dbo].Znode_DeleteUserDetails @UserIds = @DeletedIds , @status = 0,@IsForceFullyDelete =1 ,@IsCallInternal=1 
		
		DELETE FROM AspNetZnodeUser OUTPUT DELETED.AspNetZnodeUserId   INTO @TBL_DeletedUsers WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = AspNetZnodeUser.PortalId )
		
		DELETE FROM ZnodePortalAlternateWarehouse WHERE EXISTS ( SELECT TOP 1 1 FROM ZnodePortalWareHouse AS ZPWH WHERE EXISTS (
				SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZPWH.PortalId ) AND  ZPWH.PortalWarehouseId = ZnodePortalAlternateWarehouse.PortalWarehouseId);
		DELETE FROM ZnodePortalWareHouse WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalWareHouse.PortalId);
		DELETE ZnodePriceListPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePriceListPortal.PortalId );
		
		DELETE FROM ZnodeEmailTemplateMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeEmailTemplateMapper.PortalId);
		DELETE FROM ZnodeGIFtCard WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGIFtCard.PortalId );
		DELETE FROM ZnodeCMSPortalProductPage WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalProductPage.PortalId);

		DELETE FROM ZnodeCMSPortalSEOSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalSEOSetting.PortalId);

		DELETE FROM ZnodeCMSPortalTheme WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalTheme.PortalId);

		DELETE FROM ZnodeCMSSEODetailLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeCMSSEODetail AS zcsd ON TBP.PortalId = zcsd.PortalId WHERE zcsd.CMSSEODetailId = ZnodeCMSSEODetailLocale.CMSSEODetailId);
		 
		DELETE FROM ZnodeCMSSEODetail WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSSEODetail.PortalId);
		DELETE FROM ZnodePortalAccount WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAccount.PortalId);
		DELETE FROM ZnodePortalAddress WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAddress.PortalId);
		DELETE FROM ZnodePortalCountry WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCountry.PortalId);
		DELETE FROM ZnodeCMSUrlRedirect WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSUrlRedirect.PortalId);
		DELETE FROM ZnodeTaxPortaL  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxPortaL.PortalId);
	   	INSERT INTO @TBL_Promotion( PromotionId ) SELECT PromotionId FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePromotion.PortalId);
		DELETE FROM ZnodePromotionProduct WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionProduct.PromotionId);
		DELETE FROM dbo.ZnodePromotionCoupon  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCoupon.PromotionId);
		DELETE FROM ZnodePromotionCategory WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCategory.PromotionId);
		DELETE FROM ZnodePromotionCatalogs WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCatalogs.PromotionId);
		DELETE FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotion.PromotionId);
		DELETE FROM ZnodeBlogNewsLocale WHERE exists (select top 1 1 from ZnodeBlogNews ZBN
													WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsLocale.BlogNewsId )
		
        DELETE a FROM ZnodeFormBuilderGlobalAttributeValueLocale	a 
			INNER JOIN ZnodeFormBuilderGlobalAttributeValue aa ON (a.FormBuilderGlobalAttributeValueId = aa.FormBuilderGlobalAttributeValueId)INNER JOIN ZnodeFormBuilderSubmit b ON (b.FormBuilderSubmitId =aa.FormBuilderSubmitId)
			 WHERE EXISTS ( SELECT TOP 1 1
									   FROM @TBL_PortalIds AS TBDL
									   WHERE TBDL.PortalId = b.PortalId      
									 ); 
		DELETE a FROM ZnodeFormBuilderGlobalAttributeValue a INNER JOIN ZnodeFormBuilderSubmit b ON (b.FormBuilderSubmitId =a.FormBuilderSubmitId)
		 WHERE EXISTS ( SELECT TOP 1 1
								   FROM @TBL_PortalIds AS TBDL
								   WHERE TBDL.PortalId = b.PortalId      
								 ); 
		DELETE FROM ZnodeFormBuilderSubmit 
		WHERE EXISTS ( SELECT TOP 1 1
								   FROM @TBL_PortalIds AS TBDL
								   WHERE TBDL.PortalId = ZnodeFormBuilderSubmit.PortalId      
								 );   
		DELETE FROM   @DeletedIds
		INSERT INTO @DeletedIds 
		SELECT DISTINCT a.OmsOrderId 
		FROM ZnodeOmsOrder A 
		INNER JOIN ZnodeOMsOrderDetails b  ON (b.OmsOrderId = a.OmsOrderId )
		WHERE   EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = b.PortalId)

		INSERT INTO @StatusOut (Id ,Status) 
		EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIds , @status = 0 

		DELETE FROM @DeletedIds DELETE FROM @StatusOut 									  
		
		DELETE FROM dbo.ZnodeSearchSynonyms	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeSearchSynonyms.PublishCatalogId )
		DELETE FROM ZnodePublishedXml 
		DELETE FROM ZnodePublishCatalogLog	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalogLog.PublishCatalogId )
		DELETE FROM ZnodePublishCatalogSearchProfile WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalogSearchProfile.PublishCatalogId )
		DELETE FROM ZnodePublishCategoryProduct   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCategoryProduct.PublishCatalogId )
		DELETE FROM ZnodePublishCategoryDetail 	WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePublishCategoryProduct Tt WHERE Tt.PublishCategoryId = ZnodePublishCategoryDetail.PublishCategoryId )
		DELETE FROM ZnodePublishProductDetail WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePublishCategoryProduct Tt WHERE Tt.PublishCategoryId = ZnodePublishProductDetail.PublishProductId )
		
		DELETE FROM ZnodeCMSWidgetCategory WHERE PublishCategoryId IN (SELECT PublishCategoryId FROM ZnodePublishCategory   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCategory.PublishCatalogId ))

		DELETE FROM ZnodePublishCategory   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCategory.PublishCatalogId )
		DELETE FROM dbo.ZnodeCMSWidgetProduct	WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePublishCategoryProduct Tt WHERE Tt.PublishProductId = ZnodeCMSWidgetProduct.PublishProductId )
		DELETE FROM dbo.ZnodeSearchGlobalProductBoost	WHERE PublishProductId IN (SELECT PublishProductId FROM ZnodePublishProduct	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishProduct.PublishCatalogId ))
		DELETE FROM ZnodeCMSCustomerReview 
			WHERE PublishProductId IN (SELECT PublishProductId FROM ZnodePublishProduct	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishProduct.PublishCatalogId ))
		DELETE FROM ZnodePublishProduct	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishProduct.PublishCatalogId )
		DELETE FROM dbo.ZnodeSearchIndexServerStatus WHERE SearchIndexMonitorId IN (SELECT SearchIndexMonitorId FROM dbo.ZnodeSearchIndexMonitor WHERE CatalogIndexId IN (SELECT CatalogIndexId FROM ZnodeCatalogIndex	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeCatalogIndex.PublishCatalogId )))
		DELETE FROM dbo.ZnodeSearchIndexMonitor WHERE CatalogIndexId IN (SELECT CatalogIndexId FROM ZnodeCatalogIndex	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeCatalogIndex.PublishCatalogId ))
		DELETE FROM  ZnodeCatalogIndex   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeCatalogIndex.PublishCatalogId )
		DELETE FROM ZnodeSearchDocumentMapping WHERE PublishCatalogId IN (SELECT PublishCatalogId FROM ZnodePublishCatalog	  WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalog.PublishCatalogId ))
		
		DELETE FROM ZnodePublishCatalog	  WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalog.PublishCatalogId )
		DELETE FROM ZnodeOmsPersonalizeCartItem WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsSavedCartLineItem WHERE OmsSavedCartId IN (SELECT OmsSavedCartId FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId IN (SELECT OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId) ) 	 )) 
		DELETE FROM ZnodeOmsSavedCartLineItem WHERE OmsSavedCartId IN (SELECT OmsSavedCartId FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId IN (SELECT OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId) ) 	 )
		DELETE FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId IN (SELECT OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId) ) 
		DELETE FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId); 
		DELETE FROM ZnodeDomain WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeDomain.PortalId);
		DELETE FROM ZnodePortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortal.PortalId);
		
		PRINT '<-- Store Data Deleted Sucessfully-->'
	   
	   IF  NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortal) 
	   BEGIN 
	        SET @CMSThemeId = NULL 
			SET @CMSThemeCSSId = NULL  
			
	        SET IDENTITY_INSERT [dbo].[ZnodePortal] ON 
			INSERT [dbo].[ZnodePortal] ([PortalId], [CompanyName], [StoreName], [LogoPath], [UseSSL], [AdminEmail], [SalesEmail], [CustomerServiceEmail], [SalesPhoneNumber], [CustomerServicePhoneNumber], [ImageNotAvailablePath], [ShowSwatchInCategory], [ShowAlternateImageInCategory], [ExternalID], [MobileLogoPath], [DefaultOrderStateID], [DefaultReviewStatus], [SplashCategoryID], [SplashImageFile], [MobileTheme], [CopyContentBasedOnPortalId], [CreatedBy], [CreatedDate], [ModIFiedBy], [ModIFiedDate], [InStockMsg], [OutOfStockMsg], [BackOrderMsg], [OrderAmount], [Email], [StoreCode]) 
			VALUES (1, N'DemoStore', N'DemoStore', NULL, 0, N'test@znode.com', N'test@znode.com', N'test@znode.com', N'123456789', N'123456789', N'', 0, 0, NULL, NULL, 50, N'N', NULL, NULL, NULL, NULL, 2, CAST(N'2018-04-23T01:05:48.620' AS DateTime), 2, CAST(N'2018-04-23T01:05:48.620' AS DateTime), N'Demo', N'Demo', N'Demo', NULL, NULL, 'DemoStore')
			SET IDENTITY_INSERT [dbo].[ZnodePortal] OFF
			SET @PortalId  = 1
			INSERT INTO ZnodePimCatalog (CatalogName,IsActive,ExternalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			SELECT 'DefaultCatalog' , 1 ,NULL,2 ,GETDATE(),2,GETDATE() 
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimCatalog r WHERE r.CatalogName = 'DefaultCatalog' )
			SET @PimCatalogId = CASE WHEN @PimCatalogId IS nULL THEN (SELECT TOP 1 PimCatalogId FROM ZnodePimCatalog WHERE	CatalogName = 'DefaultCatalog'  ) ELSE  @PimCatalogId END 	
			INSERT INTO ZnodePublishCatalog (PimCatalogId
			,CatalogName
			,ExternalId
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate
			,Tokem)
			SELECT @PimCatalogId,'DefaultCatalog' , '',2,GETDATE(),2,GETDAte(),''
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishCatalog WHERE CatalogName = 'DefaultCatalog')
			SET  @PublishCatalogId = CASE WHEN  @PublishCatalogId IS nULL THEN (SELECT TOP 1 PublishCatalogId  FROM ZnodePublishCatalog WHERE CatalogName = 'DefaultCatalog'   )  ELSE @PublishCatalogId END 
			INSERT INTO ZnodeCMSTheme(Name
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate
			,IsParentTheme
			,ParentThemeId)
			SELECT 'Default',2,GETDATE(),2,GETDATE(),1,NULL
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSTheme WHERE Name = 'Default')
			SET  @CMSThemeId = CASE WHEN @CMSThemeId IS nULL THEN (SELECT TOP 1 CMSThemeId FROM ZnodeCMSTheme WHERE Name = 'Default'   )  ELSE @CMSThemeId END  
		
			INSERT INTO ZnodeCMSThemeCSS  (CMSThemeId
			,CSSName
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate)
			SELECT @CMSThemeId,'DefaultCSS',2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSThemeCSS WHERE CSSName = 'DefaultCSS')
			SET  @CMSThemeCSSId = CASE WHEN @CMSThemeCSSId IS nULL THEN (SELECT TOP 1 CMSThemeCSSId FROM ZnodeCMSThemeCSS WHERE CSSName = 'DefaultCSS'  )  ELSE @CMSThemeCSSId END  
		
			INSERT INTO ZnodeCMSPortalTheme (PortalId
			,CMSThemeId
			,CMSThemeCSSId
			,MediaId
			,FavIconId
			,WebsiteTitle
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate	)    
			SELECT  @PortalId,@CMSThemeId,@CMSThemeCSSId,NULL,NULL,NULL,2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSPortalTheme WHERE PortalId  = @PortalId  )
			INSERT INTO ZnodePortalCatalog (PortalId
			,PublishCatalogId
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate)
			SELECT @PortalId,@PublishCatalogId,2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePortalCatalog WHERE PortalId  = @PortalId )
			
			INSERT INTO ZnodeDomain (PortalId,DomainName ,IsActive,ApplicationType,CreatedBy ,CreatedDate ,ModIFiedBy ,ModIFiedDate)
			SELECT DISTINCT 1,DomainName ,IsActive,ApplicationType,CreatedBy ,GETDATE()CreatedDate ,ModIFiedBy ,GETDATE()ModIFiedDate 
			FROM _ZnodeDomain  TR
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeDomain TY WHERE TR.PortalId = TY.PortalId AND TR.DomainName = TY.DomainName) 
			GROUP BY DomainName ,IsActive,ApplicationType,CreatedBy,ModifiedBy

			INSERT INTO ZnodePortalUnit (PortalId,CurrencyId,WeightUnit,DimensionUnit,CurrencySuffix,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			SELECT @PortalId,(SELECT TOP 1 CurrencyId FROM ZnodeCulture WHERE CultureCode = 'en-US' ) 
			,'Lbs','IN','USD',2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalUnit  WHERE PortalId = @PortalId AND CurrencyId = (SELECT TOP 1 CurrencyId FROM ZnodeCulture WHERE CultureCode = 'en-US')  )

	   END 
	   
		
		   END  
			 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			 IF  @ResetDomainData = 1  OR @DeleteAllData =1     
			 BEGIN 
			  DECLARE @OneportalId INT = (SELECT TOP 1 PortalId  FROM ZnodePortal)
			  DELETE FROM ZnodeDomain 
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT @OneportalId, 'localhost:6766',1, '115915F1-7E6B-4386-A623-9779F27D9A5E','Admin',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost:6766'  and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ))
			  
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT @OneportalId, 'localhost:3288',1, 'c58cc0c0-1349-4001-8416-cf1cea7960e8','WebStore',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost:3288'  and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ))
			  
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT @OneportalId, 'localhost:44762',1, '8a8b4931-7d57-42e8-a005-b1c0cce49f1d','Api',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost:44762' and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ) )
			  
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT  @OneportalId  , 'localhost',1, '115915F1-7E6B-4386-A623-9779F27D9A5E','Admin',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost'  and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ))
			 PRINT '<-- Domain reset Sucessfully-->'
			 END 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF @DeleteAllShippingMethods = 1 OR @DeleteAllData =1 
		BEGIN 
		
		   	SET @DeleteId = Substring((select  ',' + convert(nvarchar(500), ShippingId)  
					FROM ZnodeShipping for XML Path ('')),2,4000) 
		  -- INSERT INTO @StatusOut (Id ,Status)

		   EXEC Znode_DeleteShipping  @ShippingId = @DeleteId , @Status =0 ,@IsForceFullyDelete =1 
		   
		 PRINT '<-- Shipping Methods are Deleted Sucessfully-->'
			   
		END
		DELETE FROM @DeletedIds DELETE FROM @StatusOut  
		IF @DeleteAllPaymentMethods	 = 1  OR @DeleteAllData =1 
		BEGIN 
			 	 
		INSERT INTO @DeletedIds 
		SELECT DISTINCT a.OmsOrderId 
		FROM ZnodeOmsOrder A 
		INNER JOIN ZnodeOMsOrderDetails b  ON (b.OmsOrderId = a.OmsOrderId )
		WHERE   EXISTS ( SELECT TOP 1 1 FROM ZnodePaymentSetting AS TBP WHERE TBP.PaymentSettingId = b.PaymentSettingId)

		INSERT INTO @StatusOut (Id ,Status) 
		EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIds , @status = 0 
		 
		 DELETE FROM ZnodePortalPaymentSetting 
		 DELETE FROM ZnodeProfilePaymentSetting
		 DELETE FROM ZnodePaymentSetting
		
			  
		 PRINT '<-- Payment Methods are Deleted Sucessfully-->'
			   
		END 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF @DeleteAllTaxes	= 1 OR @DeleteAllData =1 		
		BEGIN 
		 
		  	SET @DeleteId = Substring((select  ',' + convert(nvarchar(500), TaxClassId)  
					FROM ZnodeTaxClass for XML Path ('')),2,4000) 
		-- INSERT INTO @StatusOut (Id ,Status) 
		 EXEC [dbo].[Znode_DeleteTaxClass] @TaxClassId =  @DeleteId, @status = 0 , @IsForceFullyDelete =1 
		 DELETE FROM ZnodeTaxRuleTypes   
     	 PRINT '<-- Taxes Data Deleted Sucessfully-->'
		 		 
		END 
		IF  @ResetIdentity =1  OR @DeleteAllData =1 
		 BEGIN
		 DECLARE @table_name varchar(100)= NULL, @showReport bit= 0, @debug bit= 0
	
		IF  OBJECT_ID('tempdb..#reseed_temp1') < 0 
			Drop TABLE #reseed_temp1 
		CREATE TABLE   #reseed_temp1 
		( 
					 tbame varchar(100), mvalue varchar(20) DEFAULT 0
		)

			DECLARE @Tablename varchar(256), @columnname varchar(256), @IndentValue numeric, @query varchar(4000), @query1 nvarchar(4000), @id int;

			DECLARE Cur_Reseed CURSOR LOCAL FAST_FORWARD
			FOR SELECT b.name, c.name
				FROM sys.objects AS a, sys.objects AS b, sys.columns AS c
				WHERE a.type = 'PK' AND 
					  a.parent_object_id = b.object_id AND 
					  b.object_id = c.object_id AND 
					  c.column_id = 1 AND 
					  is_identity <> 0 AND 
					  b.name NOT LIKE '%-%' AND 
					  b.name NOT LIKE '%(%' AND 
					  RTRIM(LTRIM(b.name)) = RTRIM(LTRIM(COALESCE(@table_name, b.name)));

			OPEN Cur_Reseed;

			FETCH NEXT FROM Cur_Reseed INTO @Tablename, @columnname;

			WHILE(@@FETCH_STATUS = 0)

			BEGIN

				 IF  @columnname <> ''

				BEGIN

					SET @query = 'insert into #reseed_temp1  (tbame, mvalue) ( select  '''+@Tablename+''', max( '+@columnname+') from '+@Tablename+')';

					EXECUTE (@query);

					SELECT @Tablename = tbame, @IndentValue = isnull(mvalue,1)
					FROM #reseed_temp1 ;



					DBCC CHECKIDENT(@Tablename, RESEED, @IndentValue);



				END;

				FETCH NEXT FROM Cur_Reseed INTO @Tablename, @columnname;

			END;
			CLOSE Cur_Reseed;
			DEALLOCATE Cur_Reseed;
			DROP TABLE #reseed_temp1
		PRINT '<---Reset Identity Sucessfully-->'
		END   
		--COMMIT TRAN  CleanUpProcess
	 END TRY 
	 BEGIN CATCH 
	 SELECT ERROR_MESSAGE()
	--ROLLBACK TRAN CleanUpProcess
	 END CATCH  
END

GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PromotionId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PromoCode</name>      <headertext>Promotion Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Name</name>      <headertext>Promotion Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Discount</name>      <headertext>Discount</headertext>      <width>40</width>      <datatype>Decimal</datatype>      <columntype>Decimal</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PromotionTypeName</name>      <headertext>Discount Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>QuantityMinimum</name>      <headertext>Minimum Quantity</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>OrderMinimum</name>      <headertext>Minimum Order</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>StartDate</name>      <headertext>Start Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>EndDate</name>      <headertext>End Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete|View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>shippingId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete|View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Promotion/Edit|/Promotion/Delete</manageactionurl>      <manageparamfield>promotionId|promotionId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodePromotion'

GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?> <columns>  <column>   <id>1</id>   <name>GiftCardId</name>   <headertext>Checkbox</headertext>   <width>0</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>y</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>2</id>   <name>StoreName</name>   <headertext>Store Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>3</id>   <name>Name</name>   <headertext>Gift Card Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>y</isallowlink>   <islinkactionurl>/GiftCard/Edit</islinkactionurl>   <islinkparamfield>giftCardId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>4</id>   <name>CardNumber</name>   <headertext>Card Number</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>5</id>   <name>CreatedDate</name>   <headertext>Created Date</headertext>   <width>0</width>   <datatype>Date</datatype>   <columntype>DateTime</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>6</id>   <name>ExpirationDate</name>   <headertext>Expiration Date</headertext>   <width>0</width>   <datatype>Date</datatype>   <columntype>DateTime</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>7</id>   <name>Amount</name>   <headertext>Amount</headertext>   <width>0</width>   <datatype>Double</datatype>   <columntype>Double</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>9</id>   <name>CustomerName</name>   <headertext>Customer Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>10</id>   <name>Manage</name>   <headertext>Action</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format>Edit|Delete</format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext>Edit|Delete</displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl>/GiftCard/Edit|/GiftCard/Delete</manageactionurl>   <manageparamfield>giftCardId|giftCardId</manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column> </columns>'
WHERE ItemName ='ZnodeGiftCard'

GO


UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>LogMessageId</name>      <headertext>Log Message Id</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>LogMessage</name>      <headertext>Log Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Component</name>      <headertext>Component</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>TraceLevel</name>      <headertext>Trace  Level</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StackTraceMessage</name>      <headertext>Stack Trace Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>DomainName</name>      <headertext>Domain Name</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>ApplicationType</name>      <headertext>Application Type</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Button</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/LogMessage/GetLogMessage</manageactionurl>      <manageparamfield>logMessageId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeLogMessage'

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>LogMessageId</name>      <headertext>Log Message Id</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>LogMessage</name>      <headertext>Log Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Component</name>      <headertext>Component</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>TraceLevel</name>      <headertext>Trace  Level</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StackTraceMessage</name>      <headertext>Stack Trace Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>DomainName</name>      <headertext>Domain Name</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>ApplicationType</name>      <headertext>Application Type</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Button</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/LogMessage/GetEventLogMessage</manageactionurl>      <manageparamfield>logMessageId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeEventLogMessage'

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>LogMessageId</name>      <headertext>Log Message Id</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>LogMessage</name>      <headertext>Log Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Component</name>      <headertext>Component</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>TraceLevel</name>      <headertext>Trace  Level</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StackTraceMessage</name>      <headertext>Stack Trace Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>DomainName</name>      <headertext>Domain Name</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>ApplicationType</name>      <headertext>Application Type</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Button</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/LogMessage/GetIntegrationLogMessage</manageactionurl>      <manageparamfield>logMessageId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeIntegrationLogMessage'

GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>LogMessageId</name>      <headertext>Log Message Id</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>LogMessage</name>      <headertext>Log Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Component</name>      <headertext>Component</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>TraceLevel</name>      <headertext>Trace  Level</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StackTraceMessage</name>      <headertext>Stack Trace Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Button</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/LogMessage/GetDatabaseLogMessage</manageactionurl>      <manageparamfield>logMessageId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeDatabaseLogMessage'

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?> <columns>  <column>   <id>1</id>   <name>UserId</name>   <headertext>Customer ID</headertext>   <width>40</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>y</isconditional>   <isallowlink>y</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>2</id>   <name>FirstName</name>   <headertext>First Name</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>firstName</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>3</id>   <name>LastName</name>   <headertext>Last Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>lastName</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>4</id>   <name>PhoneNumber</name>   <headertext>Phone Number</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield>UserId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield>UserId</checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>5</id>   <name>Email</name>   <headertext>Email ID</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield>UserId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield>UserId</checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>email-id</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>6</id>   <name>UserName</name>   <headertext>Username</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield>UserId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield>UserId</checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>username</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>7</id>   <name>Accountname</name>   <headertext>Account Name</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield>UserId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield>UserId</checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column> </columns>'
WHERE ItemName ='ZnodeGiftCardCustomer'

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSWidgetProductId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PublishProductId</name>      <headertext>ID</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImagePath,ProductImage</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ProductName</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ProductType</name>      <headertext>Product Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>ModifiedDate</name>      <headertext>Modified Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditCMSAssociateProduct|/WebSite/UnassociateProduct</manageactionurl>      <manageparamfield>CMSWidgetProductId|CMSWidgetProductId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='AssociatedCMSOfferPageProduct'

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSWidgetBrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>BrandId</name>      <headertext>ID</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditCMSWidgetBrand|/WebSite/RemoveAssociatedBrands</manageactionurl>      <manageparamfield>cmsWidgetBrandId|cmsWidgetBrandId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeCMSWidgetBrand'

GO

IF NOT EXISTS  (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeCMSWidgetBrand' AND COLUMN_NAME = 'DisplayOrder')
BEGIN 
ALTER TABLE [dbo].[ZnodeCMSWidgetBrand]
    ADD [DisplayOrder] INT NULL;
END

GO
IF NOT EXISTS  (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeCMSWidgetProduct' AND COLUMN_NAME = 'DisplayOrder')
BEGIN 
ALTER TABLE [dbo].[ZnodeCMSWidgetProduct]
    ADD [DisplayOrder] INT NULL;
END

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PimLinkProductDetailId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PimLinkProductDetailId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PimProductId</name>      <headertext>ID</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>PimLinkProductDetailId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>20</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ProductImage,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ProductName</name>      <headertext>Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ProductType</name>      <headertext>Product Type</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Assortment</name>      <headertext>Assortment</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/PIM/Products/EditAssignLinkProducts|/PIM/Products/UnAssignLinkProducts</manageactionurl>      <manageparamfield>PimLinkProductDetailId|PimLinkProductDetailId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='View_ManageLinkProductList'

GO
IF NOT EXISTS  (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodePimLinkProductDetail' AND COLUMN_NAME = 'DisplayOrder')
BEGIN 
ALTER TABLE [dbo].[ZnodePimLinkProductDetail]
    ADD [DisplayOrder] INT NULL;
END

GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPublishProductbulk')
BEGIN 
	DROP PROCEDURE Znode_GetPublishProductbulk
END
GO
CREATE PROCEDURE [dbo].[Znode_GetPublishProductbulk]
(
@PublishCatalogId INT = 0 
,@VersionId       VARCHAR(50) = 0 
,@PimProductId    TransferId Readonly
,@UserId		  INT = 0 
,@PimCategoryHierarchyId  INT = 0 
,@PimCatalogId INT = 0 
,@LocaleIds TransferId READONLY
,@PublishStateId INT = 0 
)
With RECOMPILE
AS
-- 
/*
DECLARE @rrte transferId 
INSERT INTO @rrte
SELECT 1 

EXEC Znode_GetPublishProductbulk @PublishCatalogId=3,@UserId= 2 ,@localeIDs = @rrte,@PublishStateId = 3 

*/
BEGIN 
  BEGIN TRY 
 SET NOCOUNT ON 

EXEC Znode_InsertUpdatePimAttributeXML 1 
EXEC Znode_InsertUpdateCustomeFieldXML 1
EXEC Znode_InsertUpdateAttributeDefaultValue 1 


   IF OBJECT_ID('tempdb..#PimProductAttributeXML') is not null
   BEGIN 
	 DROP TABLE #PimProductAttributeXML
   END
   IF OBJECT_ID('tempdb..#PimDefaultValueLocale') is not null
   BEGIN 
    DROP TABLE #PimDefaultValueLocale
   END
   IF OBJECT_ID('tempdb..#TBL_CategoryCategoryHierarchyIds') is not null
   BEGIN 
    DROP TABLE #TBL_CategoryCategoryHierarchyIds
   END

   DECLARE @PimMediaAttributeId INT = dbo.Fn_GetProductImageAttributeId()
   
   CREATE TABLE #PimProductAttributeXML (PimAttributeXMLId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
  	
   CREATE TABLE #TBL_CategoryCategoryHierarchyIds  (CategoryId int , ParentCategoryId int ) 
	
   If (@PimCategoryHierarchyId <> 0 AND @PimCatalogId <> 0 )
		INSERT INTO #TBL_CategoryCategoryHierarchyIds(CategoryId , ParentCategoryId )
			Select Distinct PimCategoryId , Null FROM (
				SELECT PimCategoryId,ParentPimCategoryId from DBO.[Fn_GetRecurciveCategoryIds](@PimCategoryHierarchyId,@PimCatalogId)
				Union 
				Select PimCategoryId , null  from ZnodePimCategoryHierarchy where PimCategoryHierarchyId = @PimCategoryHierarchyId 
				Union 
				Select PimCategoryId , null  from [Fn_GetRecurciveCategoryIds_new] (@PimCategoryHierarchyId,@PimCatalogId) ) Category  


   CREATE TABLE #PimDefaultValueLocale  (PimAttributeDefaultXMLId INT  PRIMARY KEY ,PimAttributeDefaultValueId INT ,LocaleId INT ) 
   DECLARE @ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
		,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
   DECLARE @GetDate DATETIME =dbo.Fn_GetDate()
   DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )
			
			INSERT INTO @TBL_LocaleId (LocaleId)
			SELECT  LocaleId
			FROM ZnodeLocale MT 
			WHERE IsActive = 1
			AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
			OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) 

  DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 
 

 CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT   , VersionId INT, PublishCategoryId int ,LocaleId INT )

 CREATE INDEX idx_#TBL_PublishCatalogIdPimProductId on #TBL_PublishCatalogId(PimProductId)

  CREATE INDEX idx_#TBL_PublishCatalogIdPimPublishCatalogId on #TBL_PublishCatalogId(PublishCatalogId)

  If (@PimCategoryHierarchyId <> 0 AND @PimCatalogId <> 0 )
  BEGIN
			 INSERT INTO #TBL_PublishCatalogId(PublishCatalogId ,PublishProductId ,PimProductId  , VersionId ,PublishCategoryId ,LocaleId)  
			 SELECT distinct ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,MAX(ZPCP.PublishCataloglogId ) VersionId ,ZPC.PublishCategoryId,ZPCP.LocaleId
				 FROM ZnodePublishProduct ZPP INNER JOIN ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
				 INNER JOIN ZnodePublishCategoryProduct ZPPP ON ZPP.PublishProductId  = ZPPP.PublishProductId  
				 AND ZPCP.PublishCatalogId = ZPPP.PublishCatalogId
				 INNER JOIN ZnodePublishCategory ZPC ON ZPC.PublishCatalogId = ZPPP.PublishCatalogId AND ZPPP.PublishCategoryId = ZPC.PublishCategoryId 
				 WHERE ZPP.PublishCatalogId = @PublishCatalogId  and ZPCP.PublishStateId =  @PublishStateId
				 AND 
				 ZPC.PimCategoryId in (Select CategoryId from #TBL_CategoryCategoryHierarchyIds )
				 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId ,ZPC.PublishCategoryId,ZPCP.LocaleId	

			INSERT INTO #TBL_PublishCatalogId(PublishCatalogId ,PublishProductId ,PimProductId  , VersionId ,PublishCategoryId ,LocaleId)
			SELECT DISTINCT ZPP.PublishCatalogId,ZPP.PublishProductId,PimProductId,MAX(ZPCP.PublishCatalogLogId) VersionId,NULL, ZPCP.LocaleId
				 FROM ZnodePublishProduct ZPP 
				 INNER JOIN ZnodePublishCatalogLog ZPCP ON 
				 (ZPCP.PublishCatalogId = ZPP.PublishCatalogId) 
				 WHERE				 (EXISTS (SELECT TOP 1 1 FROM @pimProductId SP WHERE SP.Id = ZPP.PimProductId ))
				 AND (ZPP.PublishCatalogId = @publishCatalogId )
				 AND NOT Exists (Select TOP 1 1 from #TBL_PublishCatalogId TPL where TPL.PublishProductId = ZPP.PublishProductId)
				 AND ZPCP.PublishStateId =  @PublishStateId
			GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId , ZPCP.LocaleId



  END
  ELSE 
  BEGIN
			INSERT INTO #TBL_PublishCatalogId(PublishCatalogId ,PublishProductId,PimProductId ,VersionId,LocaleId  ) 
			 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,  
											MAX(PublishCatalogLogId) ,ZPCP.LocaleId
				 FROM ZnodePublishProduct ZPP 
				 INNER JOIN ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
				 WHERE (EXISTS (SELECT TOP 1 1 FROM @PimProductId SP 
				 WHERE SP.Id = ZPP.PimProductId  AND  (@PublishCatalogId IS NULL OR @PublishCatalogId = 0 ))
				 OR  (ZPP.PublishCatalogId = @PublishCatalogId ))
				 --AND  ZPCP.PublishStateId =  @PublishStateId
				 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId ,ZPCP.LocaleId
  END
           
		     DECLARE   @TBL_ZnodeTempPublish TABLE (PimProductId INT , AttributeCode VARCHAR(300) ,AttributeValue NVARCHAR(max) ) 			
			 DECLARE @TBL_AttributeVAlueLocale TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT,LocaleId INT 
			 )

	
	
		
WHILE @Counter <= @maxCountId
BEGIN
 
 SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId MT 
  WHERE  RowId = @Counter)
 
  INSERT INTO #PimProductAttributeXML 
  SELECT PimAttributeXMLId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeXML
  WHERE LocaleId = @LocaleId
  
  IF( @LocaleId <> @DefaultLocaleId )
  BEGIN
	INSERT INTO #PimProductAttributeXML 
	SELECT PimAttributeXMLId ,PimAttributeId,LocaleId
	FROM ZnodePimAttributeXML ZPAX
	WHERE ZPAX.LocaleId = @DefaultLocaleId  
	AND NOT EXISTS (SELECT TOP 1 1 FROM #PimProductAttributeXML ZPAXI WHERE ZPAXI.PimAttributeId = ZPAX.PimAttributeId )
  END

  INSERT INTO #PimDefaultValueLocale
  SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultXML
  WHERE localeId = @LocaleId

  IF( @LocaleId <> @DefaultLocaleId )
  BEGIN
	INSERT INTO #PimDefaultValueLocale 
	SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId 
	FROM ZnodePimAttributeDefaultXML ZX
	WHERE localeId = @DefaultLocaleId
	AND NOT EXISTS (SELECT TOP 1 1 FROM #PimDefaultValueLocale TRTR WHERE TRTR.PimAttributeDefaultValueId = ZX.PimAttributeDefaultValueId)
  END
  	 
  CREATE TABLE #TBL_CustomeFiled  (PimCustomeFieldXMLId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )

  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldXMLId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldXMLId,RTR.PimProductId ,RTR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldXML RTR 
  INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = RTR.PimProductId AND RTR.LocaleID = ZPP.LocaleId)
  WHERE RTR.LocaleId = @LocaleId
 
 
  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldXMLId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldXMLId,ITR.PimProductId ,ITR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldXML ITR
  INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ITR.PimProductId AND ITR.LocaleID = ZPP.LocaleId)
  WHERE ITR.LocaleId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM #TBL_CustomeFiled TBL  WHERE ITR.CustomCode = TBL.CustomCode AND ITR.PimProductId = TBL.PimProductId)
       
       
	 SELECT VIR.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId,VIR.LocaleId , VIR.AttributeValue, VIR.AttributeCode ,ROW_NUMBER() Over(Partition By VIR.PimProductId,PimAttributeId ORDER BY VIR.PimProductId,PimAttributeId  ) RowId
	 INTO #TBL_AttributeVAlue
	 FROM View_LoadManageProductInternal VIR
	 WHERE ( LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId )
	 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
	  UNION ALL 
	 SELECT VIR.PimProductId,VIR.PimAttributeId,ZPDE.PimProductAttributeMediaId,ZPDE.LocaleId ,ZPDE.MediaPath AS AttributeValue, d.AttributeCode ,ROW_NUMBER() Over(Partition By VIR.PimProductId,VIR.PimAttributeId ORDER BY VIR.PimProductId,VIR.PimAttributeId  ) RowId
	 FROM ZnodePimAttributeValue  VIR
	 INNER JOIN ZnodePimProductAttributeMedia ZPDE ON (ZPDE.PimAttributeValueId = VIR.PimAttributeValueId )
	 INNER JOIN ZnodePimAttribute d ON ( d.PimAttributeId=VIR.PimAttributeId )
	 WHERE ( ZPDE.LocaleId = @DefaultLocaleId OR ZPDE.LocaleId = @LocaleId )
	 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
	  Union All
	 SELECT VIR.PimProductId,VIR.PimAttributeId,ZPDVL.PimAttributeDefaultValueLocaleId,ZPDVL.LocaleId ,ZPDVL.AttributeDefaultValue AS AttributeValue, d.AttributeCode ,ROW_NUMBER() Over(Partition By VIR.PimProductId,VIR.PimAttributeId ORDER BY VIR.PimProductId,VIR.PimAttributeId  ) RowId
	 FROM ZnodePimAttributeValue  VIR
	 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1  )
	 INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON ZPADV.PimAttributeId = D.PimAttributeId
	 INNER JOIN ZnodePimAttributeDefaultValueLocale ZPDVL   on (ZPADV.PimAttributeDefaultValueId = ZPDVL.PimAttributeDefaultValueId)
	 --INNER JOIN ZnodePimProductAttributeDefaultValue ZPDVP ON (ZPDVP.PimAttributeValueId = VIR.PimAttributeValueId AND ZPADV.PimAttributeDefaultValueId = ZPDVP.PimAttributeDefaultValueId )
	 WHERE ( ZPDVL.LocaleId = @DefaultLocaleId OR ZPDVL.LocaleId = @LocaleId )
	 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
	 Union All 
	SELECT VIR.PimProductId,VIR.PimAttributeId,'','','',D.AttributeCode,ROW_NUMBER() Over(Partition By VIR.PimProductId,VIR.PimAttributeId ORDER BY VIR.PimProductId,VIR.PimAttributeId  ) RowId
	FROM ZnodePimAttributeValue  VIR
	INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
	WHERE  EXISTS(SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )

	 
	 UPDATE #TBL_AttributeVAlue SET rowid = (SELECT MAX(rowid) FROM #TBL_AttributeVAlue b WHERE a.PimProductId=b.PimProductId AND a.PimAttributeId = b.PimAttributeId )
	 FROM #TBL_AttributeVAlue a
	
  SET @versionId = (SELECT TOP 1 VersionId FROM #TBL_PublishCatalogId) 
  

 IF OBJECT_ID('tempdb..#Cte_GetData') IS NOT NULL
 BEGIN 
 DROP TABLE #Cte_GetData
 END 

 CREATE TABLE #Cte_GetData (PimProductId INT,AttributeCode VARCHAR(600),AttributeValue NVARCHAR(max),VersionId INT)

 CREATE INDEX idx_#Cte_GetDataPimProductId ON #Cte_GetData(PimProductId)


INSERT INTO #Cte_GetData(PimProductId ,AttributeCode,AttributeValue,VersionId)
SELECT  a.PimProductId,a.AttributeCode , '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(a.AttributeValue,'')+'</AttributeValues> </AttributeEntity>  </Attributes>'  AttributeValue,VersionId
FROM #TBL_AttributeVAlue a 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = a.PimAttributeId )
INNER JOIN #PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId)
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = a.PimProductId)
WHERE a.LocaleId  = CASE WHEN a.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END
AND NOT EXISTS (SELECT TOP 1 1 FROM Fn_GetProductMediaAttributeId() TY WHERE TY.PimAttributeId = c.PimAttributeId)
 


INSERT INTO #Cte_GetData(PimProductId ,AttributeCode,AttributeValue,VersionId)
SELECT THB.PimProductId,THB.CustomCode,'<Attributes><AttributeEntity>'+CustomeFiledXML+'</AttributeEntity></Attributes>' ,VersionId
FROM ZnodePimCustomeFieldXML THB 
INNER JOIN #TBL_CustomeFiled TRTE ON (TRTE.PimCustomeFieldXMLId = THB.PimCustomeFieldXMLId)
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = THB.PimProductId)
UNION ALL 
SELECT ZPAV.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues></AttributeValues>'+'<SelectValues>'+
			   STUFF((
                    SELECT '  '+ DefaultValueXML  FROM ZnodePimAttributeDefaultXML AA 
				 INNER JOIN #PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = AA.PimAttributeDefaultXMLId)
				 INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
				 WHERE (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId)
    FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues> </AttributeEntity></Attributes>' AttributeValue ,VersionId
FROM ZnodePimAttributeValue ZPAV  
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
AND EXISTS (select * from #PimProductAttributeXML b where b.PimAttributeXMLId = c.PimAttributeXMLId)

---for PLP

INSERT INTO #Cte_GetData(PimProductId ,AttributeCode,AttributeValue,VersionId)
SELECT DISTINCT  UOP.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues></AttributeValues>'+'<SelectValues>'+
			   STUFF((
                    SELECT DISTINCT '  '+REPLACE(DefaultValueXML,'</SelectValuesEntity>','<VariantDisplayOrder>'+CAST(ISNULL(ZPA.DisplayOrder,0) AS VARCHAR(200))+'</VariantDisplayOrder>
					<VariantSKU>'+ISNULL(ZPAVL_SKU.AttributeValue,'')+'</VariantSKU>
					<VariantImagePath>'+ISNULL((SELECT ''+ZM.Path FOR XML Path ('')),'')+'</VariantImagePath></SelectValuesEntity>')   
				 FROM ZnodePimAttributeDefaultXML AA 
				 INNER JOIN #PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = AA.PimAttributeDefaultXMLId)
				 INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
				 INNER JOIN ZnodePimAttributeValue ZPAV1 ON (ZPAV1.PimAttributeValueId= ZPADV.PimAttributeValueId )
				 -- check/join for active variants 
				 INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId =ZPAV1.PimProductId)
				 INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPAV.PimAttributevalueid = ZPAVL.PimAttributeValueId AND ZPAVL.AttributeValue = 'True')
				 INNER JOIN ZnodePimProductTypeAssociation YUP ON (YUP.PimProductId = ZPAV1.PimProductId)
				 -- SKU
				 INNER JOIN ZnodePimAttributeValue ZPAV_SKU ON(YUP.PimProductId = ZPAV_SKU.PimProductId)
				 INNER JOIN ZnodePimAttributeValueLocale ZPAVL_SKU ON (ZPAVL_SKU.PimAttributeValueId = ZPAV_SKU.PimAttributeValueId)
				 LEFT  JOIN ZnodePimAttributeValue ZPAV12 ON (ZPAV12.PimProductId= YUP.PimProductId  AND ZPAV12.PimAttributeId = @PimMediaAttributeId ) 
				 LEFT JOIN ZnodePimProductAttributeMedia ZPAVM ON (ZPAVM.PimAttributeValueId= ZPAV12.PimAttributeValueId ) 
				 LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = ZPAVM.MediaId)
				 LEFT JOIN ZnodePimAttribute ZPA ON (ZPA.PimattributeId = ZPAV1.PimAttributeId)
				 WHERE (YUP.PimParentProductId  = UOP.PimProductId AND ZPAV1.pimAttributeId = UOP.PimAttributeId )
				 -- Active Variants
				 AND ZPAV.PimAttributeId = (SELECT TOP 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'IsActive')
				 -- VariantSKU
				 AND ZPAV_SKU.PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'SKU')
FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues> </AttributeEntity></Attributes>' AttributeValue ,VersionId
FROM ZnodePimConfigureProductAttribute UOP 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = UOP.PimAttributeId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = UOP.PimProductId)
WHERE  EXISTS (SELECT * FROM #PimProductAttributeXML b WHERE b.PimAttributeXMLId = c.PimAttributeXMLId)


INSERT INTO #Cte_GetData(PimProductId ,AttributeCode,AttributeValue,VersionId)
SELECT DISTINCT  ZPAV.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+SUBSTRING((SELECT DISTINCT  ',' +ZPPG.MediaPath FROM ZnodePimProductAttributeMedia ZPPG
     INNER JOIN #TBL_AttributeVAlue FTRE ON (FTRE.PimProductId = ZPAV.PimProductId AND FTRE.PimAttributeId = ZPAV.PimAttributeId  AND FTRE.LocaleId  = CASE WHEN FTRE.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
	 WHERE ZPPG.PimProductAttributeMediaId = FTRE.ZnodePimAttributeValueLocaleId
	 FOR XML PATH ('')
 ),2,4000)+'</AttributeValues></AttributeEntity></Attributes>' AttributeValue ,VersionId	 
FROM ZnodePimAttributeValue ZPAV 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeMedia ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
AND EXISTS (SELECT * FROM #PimProductAttributeXML b WHERE b.PimAttributeXMLId = c.PimAttributeXMLId)

insert into #Cte_GetData(PimProductId ,AttributeCode,AttributeValue,VersionId)
SELECT ZPLP.PimParentProductId ,c.AttributeCode, '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(SUBSTRING((SELECT DISTINCT ','+CAST(PublishProductId AS VARCHAR(50)) 
							 FROM #TBL_PublishCatalogId ZPPI 
							 INNER JOIN ZnodePimLinkProductDetail ZPLPI ON (ZPLPI.PimProductId = ZPPI.PimProductId)
							 WHERE ZPLPI.PimParentProductId = ZPLP.PimParentProductId
							 AND ZPLPI.PimAttributeId   = ZPLP.PimAttributeId
							 FOR XML PATH ('') ),2,4000),'')+'</AttributeValues></AttributeEntity></Attributes>'   AttributeValue ,ZPP.VersionId
							
FROM ZnodePimLinkProductDetail ZPLP  
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPLP.PimParentProductId)
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPLP.PimAttributeId )
WHERE EXISTS (SELECT * FROM #PimProductAttributeXML b WHERE b.PimAttributeXMLId = c.PimAttributeXMLId)
GROUP BY ZPLP.PimParentProductId , ZPP.PublishProductId  ,ZPLP.PimAttributeId,c.AttributeCode,c.AttributeXML,ZPP.PublishCatalogId,ZPP.VersionId



SELECT a.PimProductId ,CAST((SELECT ''+dbo.FN_trim(b.AttributeValue) FOR XML PATH(''))  AS NVARCHAR(max)) AttributeValue , b.LocaleId  ,a.PimAttributeId,c.AttributeCode ,b.ZnodePimAttributeValueLocaleId
INTO #View_LoadManageProductInternal
FROM ZnodePimAttributeValue a 
INNER JOIN  ZnodePimAttributeValueLocale b ON ( b.PimAttributeValueId = a.PimAttributeValueId )
INNER JOIN ZnodePimAttribute c ON ( c.PimAttributeId=a.PimAttributeId )
WHERE c.AttributeCode = 'SKU'

INSERT INTO #Cte_GetData(PimProductId ,AttributeCode,AttributeValue,VersionId)
SELECT ZPAV.PimProductId,'DefaultSkuForConfigurable' ,'<Attributes><AttributeEntity>'+REPLACE(REPLACE (c.AttributeXML,'ProductType','DefaultSkuForConfigurable'),'Product Type','Default Sku For Configurable')+'<AttributeValues>'+
 (SELECT TOP 1 AttributeValue FROM #View_LoadManageProductInternal ad 
 INNER JOIN ZnodePimProductTypeAssociation yt ON (yt.PimProductId = ad.PimProductId)
 WHERE Ad.AttributeCode = 'SKU'
 AND yt.PimParentProductId = ZPAV.PimProductId
 ORDER BY yt.DisplayOrder , yt.PimProductTypeAssociationId ASC)
+'</AttributeValues></AttributeEntity></Attributes>' AttributeValue ,ZPP.VersionId
FROM ZnodePimAttributeValue ZPAV  
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
INNER JOIN ZnodePimAttributeDefaultValue dr ON (dr.PimAttributeDefaultValueId = ZPADVL.PimAttributeDefaultValueId)
 WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId
 AND dr.AttributeDefaultValueCode= 'ConfigurableProduct' 
)
AND EXISTS (SELECT * FROM #PimProductAttributeXML b WHERE b.PimAttributeXMLId = c.PimAttributeXMLId)
AND c.AttributeCode = 'ProductType' 


---------brand details 
CREATE TABLE #Cte_BrandData (PimProductId INT,BrandXML NVARCHAR(max))

INSERT INTO #Cte_BrandData ( PimProductId, BrandXML )
SELECT  DISTINCT ZBP.PimProductId,'<Brands><BrandEntity><BrandId>'+CAST(ZBD.BrandId AS VARCHAR(50))+'</BrandId><BrandCode>'+ZBD.BrandCode+'</BrandCode><BrandName>'+ZBDL.BrandName+'</BrandName></BrandEntity></Brands>' as BrandXML					   		   
FROM [ZnodeBrandDetails] AS ZBD
INNER JOIN ZnodeBrandDetaillocale ZBDL ON ZBD.BrandId = ZBDL.BrandId
INNER JOIN [ZnodeBrandProduct] AS ZBP ON ZBD.BrandId = ZBP.BrandId

--  --CREATE INDEX IND_Znode

  DELETE tu FROM ZnodePublishedXml tu  WHERE 
  EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TY WHERE TY.VersionId = tu.PublishCatalogLogId AND Tu.PublishedId = ty.PublishProductId  )
  AND IsProductXML = 1   AND LocaleId = @LocaleId 

  
--  --ALTER INDEX ALL ON ZnodePublishedXml  REBUILD WITH (FILLFACTOR = 80 ) 
  If (@PimCategoryHierarchyId <> 0 AND @PimCatalogId <> 0 )
  BEGIN
		
		--Collect index of other categorys
		IF OBJECT_ID('tempdb..#Index') IS NOT NULL
		BEGIN 
			DROP TABLE #Index
		END 
		CREATE TABLE #Index (RowIndex int ,PublishCategoryId int , PublishProductId  int )		
		INSERT INTO  #Index ( RowIndex ,PublishCategoryId , PublishProductId )
		SELECT CAST(ROW_NUMBER()Over(Partition BY ZPC.PublishProductId 
		Order BY ISNULL(ZPC.PublishCategoryId,'0') desc )   AS VARCHAR(100)),
		ZPC.PublishCategoryId , ZPC.PublishProductId
		FROM ZnodePublishCategoryProduct ZPC where ZPC.PublishCatalogId = @PublishCatalogId
		
	

		--Publish parent products with index number 
		INSERT INTO ZnodePublishedXml (PublishCatalogLogId,PublishedId,PublishedXML,IsProductXML,LocaleId
		,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PublishCategoryId)
		SELECT zpp.VersionId,zpp.PublishProductId,'<ProductEntity><VersionId>'+CAST(zpp.VersionId AS VARCHAR(50)) +'</VersionId><ZnodeProductId>'+CAST(zpp.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><ZnodeCategoryIds>'+CAST(ISNULL(ZPCP.PublishCategoryId,'')  AS VARCHAR(50))+'</ZnodeCategoryIds><Name>'+CAST(ISNULL((SELECT ''+ZPPDFG.ProductName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</Name>'+'<SKU>'+CAST(ISNULL((SELECT ''+ZPPDFG.SKU FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKU>'+'<SKULower>'+CAST(ISNULL((SELECT ''+LOWER(ZPPDFG.SKU) FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKULower>'+'<IsActive>'+CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50))+'</IsActive>' 
		+'<ZnodeCatalogId>'+CAST(ZPP.PublishCatalogId  AS VARCHAR(50))+'</ZnodeCatalogId><IsParentProducts>'+CASE WHEN ZPCD.PublishCategoryId IS NULL THEN '0' ELSE '1' END  +'</IsParentProducts><CategoryName>'+CAST(ISNULL((SELECT ''+PublishCategoryName FOR XML PATH ('')),'') AS NVARCHAR(2000)) +'</CategoryName><CatalogName>'+CAST(ISNULL((SELECT ''+CatalogName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</CatalogName><LocaleId>'+CAST( @LocaleId AS VARCHAR(50))+'</LocaleId>'
		+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
						FROM ZnodeProfileCatalog ZPFC 
						INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
						WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+
						'</TempProfileIds>
						 <ProductIndex>'+ CAST(ISNULL(ZPCP.ProductIndex,1) AS VARCHAR(200))+
						'</ProductIndex>
						<IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
		'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+
		ISNULL(STUFF(( SELECT '  '+ BrandXML  FROM #Cte_BrandData BD WHERE BD.PimProductId = ZPP.PimProductId   
				FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, ''),'')+
		STUFF(( SELECT '  '+ AttributeValue  FROM #Cte_GetData TY WHERE TY.PimProductId = ZPP.PimProductId AND TY.VersionId = ZPP.VersionId   
		FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</ProductEntity>' xmlvalue,1,@LocaleId,@UserId , @GetDate , @UserId,@GetDate
		,ZPCP.PublishCategoryId
		FROM  #TBL_PublishCatalogId zpp
		INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
		INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)
		LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT JOIN ZnodePublishCategory ZPC ON (ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId 
		AND ZPP.PublishCategoryId = ZPC.PublishCategoryId 
		)
		LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId
		)
		LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ISNULL(ZPCP.PublishCategoryId,0) AND ZPCD.LocaleId = @LocaleId )
		WHERE ZPPDFG.LocaleId = @LocaleId AND ZPP.LocaleId = @LocaleId AND  ZPC.PimCategoryId in (Select CategoryId from #TBL_CategoryCategoryHierarchyIds ) 
		and zpp.PublishCategoryId IS NOT NULL

		
	
	 --Publish only associate product 
	 INSERT INTO ZnodePublishedXml (PublishCatalogLogId,PublishedId,PublishedXML,IsProductXML,LocaleId
		,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PublishCategoryId)
		SELECT zpp.VersionId,zpp.PublishProductId,'<ProductEntity><VersionId>'+CAST(zpp.VersionId AS VARCHAR(50)) +'</VersionId><ZnodeProductId>'+CAST(zpp.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><ZnodeCategoryIds>'+CAST(ISNULL(ZPCP.PublishCategoryId,'')  AS VARCHAR(50))+'</ZnodeCategoryIds><Name>'+CAST(ISNULL((SELECT ''+ZPPDFG.ProductName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</Name>'+'<SKU>'+CAST(ISNULL((SELECT ''+ZPPDFG.SKU FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKU>'+'<SKULower>'+CAST(ISNULL((SELECT ''+LOWER(ZPPDFG.SKU) FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKULower>'+'<IsActive>'+CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50))+'</IsActive>' 
		+'<ZnodeCatalogId>'+CAST(ZPP.PublishCatalogId  AS VARCHAR(50))+'</ZnodeCatalogId><IsParentProducts>'+CASE WHEN ZPCD.PublishCategoryId IS NULL THEN '0' ELSE '1' END  +'</IsParentProducts><CategoryName>'+CAST(ISNULL((SELECT ''+PublishCategoryName FOR XML PATH ('')),'') AS NVARCHAR(2000)) +'</CategoryName><CatalogName>'+CAST(ISNULL((SELECT ''+CatalogName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</CatalogName><LocaleId>'+CAST( @LocaleId AS VARCHAR(50))+'</LocaleId>'
		+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
						FROM ZnodeProfileCatalog ZPFC 
						INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
						WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+
						'</TempProfileIds>
						 <ProductIndex>'+ CAST(ISNULL(ZPCP.ProductIndex,1) AS VARCHAr(200))+
						'</ProductIndex>
						<IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
		'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+
		STUFF(( SELECT '  '+ AttributeValue  FROM #Cte_GetData TY WHERE TY.PimProductId = ZPP.PimProductId   AND TY.VersionId= ZPP.VersionId
		FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</ProductEntity>' xmlvalue,1,@LocaleId,@UserId , @GetDate , @UserId,@GetDate
		,ZPCP.PublishCategoryId
		FROM  #TBL_PublishCatalogId zpp
		INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
		INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)
		LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT JOIN ZnodePublishCategory ZPC ON (ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId 
		AND ZPP.PublishCategoryId = ZPC.PublishCategoryId )
		AND ZPC.PimCategoryId in (Select CategoryId from #TBL_CategoryCategoryHierarchyIds )
		LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId
		AND ZPCCF.PimCategoryId in (Select CategoryId from #TBL_CategoryCategoryHierarchyIds ))
		LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ISNULL(ZPCP.PublishCategoryId,0) AND ZPCD.LocaleId = @LocaleId )
		WHERE ZPPDFG.LocaleId = @LocaleId AND ZPP.LocaleId = @LocaleId AND zpp.PublishCategoryId IS NULL
		
  END
  ELSE
  BEGIN

      INSERT INTO ZnodePublishedXml (PublishCatalogLogId
		,PublishedId
		,PublishedXML
		,IsProductXML
		,LocaleId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,PublishCategoryId)
		SELECT zpp.VersionId,zpp.PublishProductId,'<ProductEntity><VersionId>'+CAST(zpp.VersionId AS VARCHAR(50)) +'</VersionId><ZnodeProductId>'+CAST(zpp.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><ZnodeCategoryIds>'+CAST(ISNULL(ZPCP.PublishCategoryId,'')  AS VARCHAR(50))+'</ZnodeCategoryIds><Name>'+CAST(ISNULL((SELECT ''+ZPPDFG.ProductName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</Name>'+'<SKU>'+CAST(ISNULL((SELECT ''+ZPPDFG.SKU FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKU>'+'<SKULower>'+CAST(ISNULL((SELECT ''+LOWER(ZPPDFG.SKU) FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKULower>'+'<IsActive>'+CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50))+'</IsActive>' 
		+'<ZnodeCatalogId>'+CAST(ZPP.PublishCatalogId  AS VARCHAR(50))+'</ZnodeCatalogId><IsParentProducts>'+CASE WHEN ZPCD.PublishCategoryId IS NULL THEN '0' ELSE '1' END  +'</IsParentProducts><CategoryName>'+CAST(ISNULL((SELECT ''+PublishCategoryName FOR XML PATH ('')),'') AS NVARCHAR(2000)) +'</CategoryName><CatalogName>'+CAST(ISNULL((SELECT ''+CatalogName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</CatalogName><LocaleId>'+CAST( @LocaleId AS VARCHAR(50))+'</LocaleId>'
		+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
						FROM ZnodeProfileCatalog ZPFC 
						INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
						WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+'</TempProfileIds><ProductIndex>'+CAST(ROW_NUMBER()Over(Partition BY zpp.PublishProductId Order BY ISNULL(ZPC.PublishCategoryId,'0') ) AS VARCHAr(100))+'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
		'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+
		STUFF(( SELECT '  '+ AttributeValue  FROM #Cte_GetData TY WHERE TY.PimProductId = ZPP.PimProductId   AND TY.VersionId = ZPP.VersionId
		FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</ProductEntity>' xmlvalue,1,@LocaleId,@UserId , @GetDate , @UserId,@GetDate
		,ZPCP.PublishCategoryId
		
		FROM  #TBL_PublishCatalogId zpp
		INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
		INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)
		LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT JOIN ZnodePublishCategory ZPC ON (ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId )
		LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId)
		LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ISNULL(ZPCP.PublishCategoryId,0) AND ZPCD.LocaleId = @LocaleId )
		WHERE ZPPDFG.LocaleId = @LocaleId AND ZPP.LocaleId = @LocaleId

      
END 
 

DELETE FROM #TBL_CustomeFiled
DELETE FROM #PimDefaultValueLocale
 IF OBJECT_ID('tempdb..#PimProductAttributeXML') is not null
 BEGIN 
 DELETE FROM #PimProductAttributeXML
 END
 IF OBJECT_ID('tempdb..#Cte_GetData') is not null
 BEGIN 
 DROP TABLE #Cte_GetData
 END
   IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
 DROP TABLE #Cte_BrandData
 END
  IF OBJECT_ID('tempdb..#TBL_AttributeVAlue') is not null
 BEGIN 
 DROP TABLE #TBL_AttributeVAlue
 END
 IF OBJECT_ID('tempdb..#View_LoadManageProductInternal') is not null
 BEGIN 
 DROP TABLE #View_LoadManageProductInternal
 END
 IF OBJECT_ID('tempdb..#TBL_CustomeFiled') is not null
 BEGIN 
 DROP TABLE #TBL_CustomeFiled
 END
SET @Counter = @counter + 1 
END 
END TRY 
BEGIN CATCH 

 SELECT ERROR_MESSAGE()
 UPDATE ZnodePublishCatalogLog 
	    SET IsCatalogPublished = 0 
		,IsCategoryPublished = 0,IsProductPublished= 0  
		WHERE EXISTS (SELECT TOP 1 1 from #TBL_PublishCatalogId TR WHERE TR.VersionId = ZnodePublishCatalogLog.PublishCatalogLogId)
END CATCH 
END
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_ManageLinkProductList')
BEGIN 
	DROP PROCEDURE Znode_ManageLinkProductList
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageLinkProductList]
(   @WhereClause      XML,
    @Rows             INT          = 100,
    @PageNo           INT          = 1,
    @Order_BY         VARCHAR(100) = '',
    @RowsCount        INT OUT,
    @LocaleId         INT          = 1,
    @RelatedProductId INT          = 0,
    @PimAttributeId   INT          = 0)
AS
   /*  Summary :- This Procedure is used to find the link product Detail
     Unit Testing
     EXEC Znode_ManageLinkProductList '' , @RowsCount = 0 ,@RelatedProductId=128
   */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @PimProductIds TransferId, --VARCHAR(MAX),
					 @PimAttributeIds VARCHAR(MAX),
					 @OutPimProductIds VARCHAR(max);
             DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();
             DECLARE @TransferPimProductId TransferId
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

		     DECLARE @TBL_LinkProductDetail TABLE
             (PimProductId           INT,
              PimLinkProductDetailId INT,
              RelatedProductId       INT,
              PimAttributeId         INT,
			  DisplayOrder			 INT
             );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             DECLARE @DefaultAttributeFamily INT=
             (
                 SELECT PimAttributeFamilyId
                 FROM ZnodePimAttributeFamily
                 WHERE IsCategory = 0
                       AND IsDefaultFamily = 1
             );
             DECLARE @ProductIdTable TABLE
             (PimProductId INT,
              CountId      INT,
              RowId        INT IDENTITY(1,1)
             );
             INSERT INTO @TBL_LinkProductDetail
             (PimProductId,
              PimLinkProductDetailId,
              RelatedProductId,
              PimAttributeId,
			  DisplayOrder
             )
                    SELECT PimProductId,
                           PimLinkProductDetailId,
                           PimParentProductId,
                           PimAttributeId,
						   DisplayOrder
                    FROM ZnodePimLinkProductDetail
                    WHERE PimParentProductId = @RelatedProductId
                          AND PimAttributeId = @PimAttributeId;

				INSERT INTO @TransferPimProductId
                SELECT PimProductId
                FROM @TBL_LinkProductDetail

			 IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId)
			 BEGIN
			  INSERT INTO @TransferPimProductId
			  SELECT '-1'

             END
			 DECLARE @AttributeCode NVARCHAR(max)
			 SET @AttributeCode = SUBSTRING ((SELECT ','+AttributeCode FROM [dbo].[Fn_GetProductGridAttributes]()  WHERE AttributeCode NOT IN ('AttributeFamily') FOR XML PATH('') ),2,4000)

			 EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = @AttributeCode,
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = 0,
				  @OutProductId = @OutPimProductIds OUT;


			 INSERT INTO @ProductIdTable
             (PimProductId)
			 SELECT item
			 FROM dbo.split(@OutPimProductIds,',') SP

			 --SET @PimProductIds = SUBSTRING(
    --                                       (
    --                                           SELECT ','+CAST(PimProductId AS VARCHAR(100))
    --                                           FROM @ProductIdTable
    --                                           FOR XML PATH('')
    --                                       ), 2, 4000);

			INSERT INTO @PimProductIds ( Id )
			SELECT item
			FROM dbo.split(@OutPimProductIds,',') SP

             SET @PimAttributeIds = SUBSTRING( (SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000);

			 INSERT INTO @TBL_AttributeDefaultValue
             (PimAttributeId,
              AttributeDefaultValueCode,
              IsEditable,
              AttributeDefaultValue,
			  DisplayOrder
             )
             EXEC Znode_GetAttributeDefaultValueLocale
                  @PimAttributeIds,
                  @LocaleId;
             INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )
             EXEC [Znode_GetProductsAttributeValue]
                  @PimProductIds,
                  @PimAttributeIds,
                  @localeId;
             WITH Cte_UpdateDefaultAttributeValue
                  AS (SELECT PimProductId,
                             AttributeCode,
                             AttributeValue,
                             SUBSTRING(
                                      (
                                          SELECT ','+TBADV.AttributeDefaultValue
                                          FROM @TBL_AttributeDefaultValue TBADV
                                               INNER JOIN ZnodePimAttribute TBAC ON(TBADV.PimAttributeId = TBAC.PimAttributeId)
                                          WHERE TBAC.AttributeCode = TBAD.AttributeCode
                                                AND EXISTS
                                          (
                                              SELECT TOP 1 1
                                              FROM dbo.split(TBAD.AttributeValue, ',') SP
                                              WHERE Sp.item = TBADV.AttributeDefaultValueCode
                                          )
                                          FOR XML PATH('')
                                      ), 2, 4000) AttributeDefaultValue
                      FROM @TBL_AttributeDetails TBAD)
                  UPDATE TBAD
                    SET AttributeValue = CTUDAV.AttributeDefaultValue
                  FROM @TBL_AttributeDetails TBAD
                       INNER JOIN Cte_UpdateDefaultAttributeValue CTUDAV ON(CTUDAV.PimProductId = TBAD.PimProductId
                                                                            AND CTUDAV.AttributeCode = TBAD.AttributeCode)
                  WHERE AttributeDefaultValue IS NOT NULL;
             INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1;
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';

			 ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId
			  , SUBSTRING( ( SELECT ','+ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'+ zm.PATH  
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue
			   FROM @TBL_AttributeDetails AS TBA
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))

		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;



			INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT PimProductId ,FamilyName, 'AttributeFamily',NULL
			FROM @FamilyDetails

				-- LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
             --- Update the  product families name locale wise
        UPDATE  @TBL_AttributeDetails SET PimAttributeId = 0 WHERE PimAttributeId IS nULL
	     DECLARE @ProductXML XML

		--SELECT * FROM @TBL_AttributeDetails

	   	 SET @ProductXML =   '<MainProduct>'+ STUFF( (  SELECT '<Product>'
		                                                    +'<PimLinkProductDetailId>'+CAST(ISNULL(TBLPD.PimLinkProductDetailId,'') AS VARCHAR(50))+'</PimLinkProductDetailId>'
															+'<PimProductId>'+CAST(zpp.PimProductId AS VARCHAR(50))+'</PimProductId>'
															+'<RelatedProductId>'+CAST(ISNULL(TBLPD.RelatedProductId,'') AS VARCHAR(50))+'</RelatedProductId>'
															+'<DisplayOrder>'+CAST(ISNULL(TBLPD.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'
		 + STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST( (SELECT ''+TBADI.AttributeValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'
															FROM @TBL_AttributeDetails TBADI
															 WHERE TBADI.PimProductId = zpp.PimProductId
															 ORDER BY TBADI.PimProductId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Product>'

			 FROM @ProductIdTable AS zpp
             LEFT JOIN @TBL_LinkProductDetail AS TBLPD ON(TBLPD.PimProductId = ZPP.PimProductId)
             ORDER BY zpp.RowId
			FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainProduct>'
			--FOR XML PATH ('MainProduct'))


			SELECT  @ProductXML  ProductXMl

		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1
			 AND  IsCategory = 0
			 AND ZPA.IsShowOnGrid = 1
			 UNION ALL
			 SELECT 'PublishStatus','Publish Status'


			SELECT @RowsCount AS RowsCount;













			 --SELECT zpp.PimProductid AS ProductId,
    --                [ProductName],
    --                ProductType,
    --                ISNULL(zf.FamilyName, '') AS AttributeFamily,
    --                [SKU],
    --                [Price],
    --                [Quantity],
    --                CASE
    --                    WHEN [IsActive] IS NULL
    --                    THEN CAST(0 AS BIT)
    --                    ELSE CAST([IsActive] AS BIT)
    --                END AS [IsActive],
    --                PimLinkProductDetailId,
    --                RelatedProductId,
    --                TBLPD.PimAttributeId,
    --                [dbo].FN_GetMediaThumbnailMediaPath(zm.Path) AS ImagePath,
    --                [Assortment],
    --                @LocaleId AS LocaleId,
    --                [DisplayOrder]
    --         FROM @ProductIdTable AS zpp
    --              INNER JOIN @TBL_LinkProductDetail AS TBLPD ON(TBLPD.PimProductId = ZPP.PimProductId)
    --              LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
    --              INNER JOIN
    --         (
    --             SELECT PimProductId,
    --                    AttributeValue,
    --                    AttributeCode
    --             FROM @TBL_AttributeDetails
    --         ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
    --                                                             [SKU],
    --                                                             [Price],
    --                                                             [Quantity],
    --                                                             [IsActive],
    --                                                             [ProductType],
    --                                                             [ProductImage],
    --                                                             [Assortment],
    --                                                             [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
    --              LEFT JOIN ZnodeMedia AS zm ON(zm.MediaId = piv.[ProductImage])
    --         ORDER BY zpp.RowId;
         END TRY
         BEGIN CATCH

              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageLinkProductList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@RelatedProductId='+CAST(@RelatedProductId AS VARCHAR(50))+',@PimAttributeId='+CAST(@PimAttributeId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));

             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;

             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageLinkProductList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSWidgetProductId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PublishProductId</name>      <headertext>ID</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImagePath,ProductImage</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ProductName</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ProductType</name>      <headertext>Product Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>ModifiedDate</name>      <headertext>Modified Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditCMSAssociateProduct|/WebSite/UnassociateProduct</manageactionurl>      <manageparamfield>CMSWidgetProductId|CMSWidgetProductId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='AssociatedCMSOfferPageProduct'

GO
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSWidgetBrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>BrandId</name>      <headertext>ID</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditCMSWidgetBrand|/WebSite/RemoveAssociatedBrands</manageactionurl>      <manageparamfield>cmsWidgetBrandId|cmsWidgetBrandId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeCMSWidgetBrand'

GO


UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PimLinkProductDetailId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PimLinkProductDetailId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PimProductId</name>      <headertext>ID</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>PimLinkProductDetailId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>20</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ProductImage,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ProductName</name>      <headertext>Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ProductType</name>      <headertext>Product Type</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Assortment</name>      <headertext>Assortment</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/PIM/Products/EditAssignLinkProducts|/PIM/Products/UnAssignLinkProducts</manageactionurl>      <manageparamfield>PimLinkProductDetailId|PimLinkProductDetailId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='View_ManageLinkProductList'

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_DeleteTaxClass')
BEGIN 
	DROP PROCEDURE Znode_DeleteTaxClass
END
GO

CREATE PROCEDURE [dbo].[Znode_DeleteTaxClass]
( @TaxClassId VARCHAR(max),
  @Status     INT OUT,
  @IsForceFullyDelete BIT = 0 )
AS
/*
Summary: This Procedure is used to delete taxclass details or an order
Unit Testing:
EXEC Znode_DeleteTaxClass 

*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN A;
			  DECLARE @StatusOutINT Table (Id INT ,Message NVARCHAR(max), Status BIT )
			  DECLARE @DeletedIdsIN TransferId 
             DECLARE @DeletdAttributeId TABLE(TaxClassId INT);


            INSERT INTO @DeletdAttributeId			   
			SELECT Item
			FROM dbo.split(@TaxClassId, ',') AS a
			WHERE (NOT EXISTS (SELECT TOP 1 1 FROM ZnodeTaxClassSKU  asa  
			INNER JOIN ZnodeOmsOrderLineItems vf ON (vf.Sku = asa.SKU)   
			WHERE asa.TaxClassId = a.Item ) OR @IsForceFullyDelete =1 )


             DELETE FROM ZnodeTaxRule
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletdAttributeId AS a
                 WHERE a.TaxClassId = ZnodeTaxRule.TaxClassId
             );
             DELETE FROM ZnodeTaxClassSKU
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletdAttributeId AS a
                 WHERE a.TaxClassId = ZnodeTaxClassSKU.TaxClassId
             );	 
             DELETE FROM ZnodePortalTaxClass
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletdAttributeId AS a
                 WHERE a.TaxClassId = ZnodePortalTaxClass.TaxClassId
             );
			INSERT INTO @DeletedIdsIN 
			SELECT DISTINCT a.OmsOrderId 
			FROM ZnodeOmsOrder A 
			INNER JOIN ZnodeOMsOrderDetails b  ON (b.OmsOrderId = a.OmsOrderId )
			INNER JOIN 	ZnodeOmsOrderLineItems c ON (c.OmsOrderDetailsId = b.OmsOrderDetailsId)
			INNER JOIN ZnodeTaxClassSKU  vf ON (vf.Sku = c.SKU)
			WHERE  EXISTS (SELECT TOP 1 1 FROM @DeletdAttributeId DA WHERE DA.TaxClassId = VF.TaxClassId)
			
		    INSERT INTO @StatusOutINT (Id ,Status) 
			EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIdsIN , @status = 0 
			
			DELETE FROM ZnodeTaxClassSKU WHERE  EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletdAttributeId AS a
                 WHERE a.TaxClassId = ZnodeTaxClassSKU.TaxClassId
             );  
			 
             DELETE FROM ZnodeTaxClass
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletdAttributeId AS a
                 WHERE a.TaxClassId = ZnodeTaxClass.TaxClassId
             );
             IF
             (
                 SELECT COUNT(1)
                 FROM @DeletdAttributeId
             ) =
             (
                 SELECT COUNT(1)
                 FROM dbo.split(@TaxClassId, ',') AS a
             )
                 BEGIN
                     SELECT 1 AS ID,
                            CAST(1 AS BIT) AS Status;
							SET @Status = 1;
                 END;
             ELSE
                 BEGIN
                     SELECT 0 AS ID,
                            CAST(0 AS BIT) AS Status;
							SET @Status = 0;
                 END;
             
             COMMIT TRAN A;
         END TRY
         BEGIN CATCH
		 
            DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteTaxClass  @TaxClassId = '+@TaxClassId+',@Status='+CAST(@Status AS VARCHAR(200));
             SET @Status = 0;
             SELECT 0 AS ID,
                    CAST(0 AS BIT) AS Status;
			 ROLLBACK TRAN A;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_DeleteTaxClass ',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_DeleteOrderById')
BEGIN 
	DROP PROCEDURE Znode_DeleteOrderById
END
GO

CREATE PROCEDURE [dbo].[Znode_DeleteOrderById]
(@OrderDetailId INT = 0 ,
 @Status   BIT OUT,
 @OmsOrderIds TransferId READONLY 

)
AS

/*
begin tran
exec Znode_DeleteOrderById 6
rollback tran
*/
BEGIN
  SET NOCOUNT ON
   BEGIN  TRAN DeleteOrderById
  BEGIN TRY 
		   	DECLARE @OmsOrderId TABLE (OmsOrderId INT ) 
			DECLARE @OmsOrderDetailsId TABLE (OmsOrderDetailsId  INT ) 
			
			INSERT INTO  @OmsOrderId 
			SELECT Id 
			FROM  @OmsOrderIds

			INSERT INTO @OmsOrderDetailsId 
			SELECT OmsOrderDetailsId 
			FROM ZnodeOmsOrderDetails  ZP 
			WHERE (OmsOrderDetailsId = @OrderDetailId OR 
			EXISTS (SELECT TOP 1 1  FROM @OmsOrderIds WHERE id = ZP.OmsOrderId)  ) 

			
			DECLARE @TBL_OmsOrderLineItems TABLE (OmsOrderLineItemsId INT,OmsOrderShipmentId INT, OmsOrderDetailsId INT)
			INSERT INTO @TBL_OmsOrderLineItems
			SELECT OmsOrderLineItemsId,OmsOrderShipmentId, OmsOrderDetailsId 
			FROM ZnodeOmsOrderLineItems S 
			WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId TR WHERE TR.OmsOrderDetailsId = S.OmsOrderDetailsId )
			DELETE FROM ZnodeOmsOrderAttribute WHERE EXISTS (SELECT OmsOrderLineItemsId FROM @TBL_OmsOrderLineItems )
			DELETE FROM ZnodeOmsOrderDiscount WHERE EXISTS (SELECT OmsOrderLineItemsId FROM @TBL_OmsOrderLineItems TY WHERE TY.OmsOrderDetailsId = ZnodeOmsOrderDiscount.OmsOrderDetailsId   or TY.OmsOrderLineItemsId = ZnodeOmsOrderDiscount.OmsOrderLineItemId  )
			DELETE FROM ZnodeOmsOrderWarehouse WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderLineItemsId = ZnodeOmsOrderWarehouse.OmsOrderLineItemsId  )
			DELETE FROM ZnodeRmaRequestItem WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderLineItemsId = ZnodeRmaRequestItem.OmsOrderLineItemsId  )
			DELETE FROM ZnodeOmsOrderLineItemsAdditionalCost WHERE EXISTS ( SELECT TOP 1 1 FROM 
			ZnodeOmsOrderLineItems WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderDetailsId = ZnodeOmsOrderLineItems.OmsOrderDetailsId)
			AND ZnodeOmsOrderLineItems.OmsOrderLineItemsId = ZnodeOmsOrderLineItemsAdditionalCost.OmsOrderLineItemsId)

			DELETE FROM ZnodeOmsPersonalizeItem WHERE EXISTS (SELECT TOP 1 1  FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderLineItemsId = ZnodeOmsPersonalizeItem.OmsOrderLineItemsId)
		   	DELETE FROM ZnodeOmsTaxOrderLineDetails WHERE EXISTS (SELECT TOP 1 1  FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderLineItemsId = ZnodeOmsTaxOrderLineDetails.OmsOrderLineItemsId)
		   	DELETE FROM znodeGiftCardHistory WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =znodeGiftCardHistory.OmsOrderDetailsId)
		   	DELETE FROM znodeOmsEmailHistory WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =znodeOmsEmailHistory.OmsOrderDetailsId)
		   	DELETE FROM ZnodeOmsReferralCommission WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =ZnodeOmsReferralCommission.OmsOrderDetailsId)
		   	DELETE FROM ZnodeOmsTaxOrderDetails WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =ZnodeOmsTaxOrderDetails.OmsOrderDetailsId)
			DELETE FROM ZnodeOmsHistory   WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =ZnodeOmsHistory.OmsOrderDetailsId)
			DELETE FROM znodeOmsNotes WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =znodeOmsNotes.OmsOrderDetailsId)
			DELETE FROM ZnodeOmsOrderLineItems WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId TBLOLI WHERE TBLOLI.OmsOrderDetailsId = ZnodeOmsOrderLineItems.OmsOrderDetailsId)
			DELETE FROM ZnodeOmsOrderShipment WHERE EXISTS (SELECT TOP 1 1  FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderShipmentId = ZnodeOmsOrderShipment.OmsOrderShipmentId )
		   	DELETE FROM ZnodeOmsCustomerShipping WHERE EXISTS(SELECT TOP 1 1  FROM @TBL_OmsOrderLineItems TBLOLI WHERE TBLOLI.OmsOrderDetailsId =ZnodeOmsCustomerShipping.OmsOrderDetailsId)
			DELETE FROM ZnodeOmsOrderDetails  WHERE EXISTS (SELECT TOP 1 1 FROM @OmsOrderDetailsId rt WHERE rt.OmsOrderDetailsId =ZnodeOmsOrderDetails.OmsOrderDetailsId)
		   	DELETE FROM ZnodeOmsOrder WHERE EXISTS (SELECT TOP 1 1  FROM @OmsOrderId T WHERE T.OmsOrderId = ZnodeOmsOrder.OmsOrderId)
            









		SELECT 1 AS ID , CAST(1 AS BIT) AS Status;

        SET @Status = 1;    
		 COMMIT  TRAN DeleteOrderById
	END TRY
	BEGIN CATCH
	   SELECT ERROR_MESSAGE	()
	   SELECT 0 AS ID , CAST(0 AS BIT) AS Status;
	SET @Status = 0;
		ROLLBACK TRAN DeleteOrderById
	SELECT ERROR_MESSAGE()
	END CATCH

END

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_DeleteTaxClass')
BEGIN 
	DROP PROCEDURE Znode_DeleteTaxClass
END
GO

CREATE PROCEDURE [dbo].[Znode_DeleteTaxClass]
( @TaxClassId VARCHAR(max),
  @Status     INT OUT,
  @IsForceFullyDelete BIT = 0 )
AS
/*
Summary: This Procedure is used to delete taxclass details or an order
Unit Testing:
EXEC Znode_DeleteTaxClass 

*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN A;
			  DECLARE @StatusOutINT Table (Id INT ,Message NVARCHAR(max), Status BIT )
			  DECLARE @DeletedIdsIN TransferId 
             DECLARE @DeletedClassId TABLE(TaxClassId INT);


            INSERT INTO @DeletedClassId			   
			SELECT Item
			FROM dbo.split(@TaxClassId, ',') AS a
			WHERE (NOT EXISTS (SELECT TOP 1 1 FROM ZnodeTaxClassSKU  asa  
			INNER JOIN ZnodeOmsOrderLineItems vf ON (vf.Sku = asa.SKU)   
			WHERE asa.TaxClassId = a.Item ) OR @IsForceFullyDelete =1 )

			INSERT INTO @DeletedIdsIN 
			SELECT DISTINCT a.OmsOrderId 
			FROM ZnodeOmsOrder A 
			INNER JOIN ZnodeOMsOrderDetails b  ON (b.OmsOrderId = a.OmsOrderId )
			INNER JOIN 	ZnodeOmsOrderLineItems c ON (c.OmsOrderDetailsId = b.OmsOrderDetailsId)
			INNER JOIN ZnodeTaxClassSKU  vf ON (vf.Sku = c.SKU)
			WHERE  EXISTS (SELECT TOP 1 1 FROM @DeletedClassId DA WHERE DA.TaxClassId = VF.TaxClassId)
			
		    INSERT INTO @StatusOutINT (Id ,Status) 
			EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIdsIN , @status = 0 

             DELETE FROM ZnodeTaxRule
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletedClassId AS a
                 WHERE a.TaxClassId = ZnodeTaxRule.TaxClassId
             );
             --DELETE FROM ZnodeTaxClassSKU
             --WHERE EXISTS
             --(
             --    SELECT TOP 1 1
             --    FROM @DeletedClassId AS a
             --    WHERE a.TaxClassId = ZnodeTaxClassSKU.TaxClassId
             --);	 
             DELETE FROM ZnodePortalTaxClass
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletedClassId AS a
                 WHERE a.TaxClassId = ZnodePortalTaxClass.TaxClassId
             );
			
			
			DELETE FROM ZnodeTaxClassSKU WHERE  EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletedClassId AS a
                 WHERE a.TaxClassId = ZnodeTaxClassSKU.TaxClassId
             );  
			 
             DELETE FROM ZnodeTaxClass
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM @DeletedClassId AS a
                 WHERE a.TaxClassId = ZnodeTaxClass.TaxClassId
             );
             IF
             (
                 SELECT COUNT(1)
                 FROM @DeletedClassId
             ) =
             (
                 SELECT COUNT(1)
                 FROM dbo.split(@TaxClassId, ',') AS a
             )
                 BEGIN
                     SELECT 1 AS ID,
                            CAST(1 AS BIT) AS Status;
							SET @Status = 1;
                 END;
             ELSE
                 BEGIN
                     SELECT 0 AS ID,
                            CAST(0 AS BIT) AS Status;
							SET @Status = 0;
                 END;
             
             COMMIT TRAN A;
         END TRY
         BEGIN CATCH
		
            DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteTaxClass  @TaxClassId = '+@TaxClassId+',@Status='+CAST(@Status AS VARCHAR(200));
             SET @Status = 0;
             SELECT 0 AS ID,
                    CAST(0 AS BIT) AS Status;
			 ROLLBACK TRAN A;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_DeleteTaxClass ',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO
	 UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledWarning' 
	 GO
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledInfo' 
GO
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledDebug' 
GO
UPDATE ZnodeGlobalSetting set FeatureValues='True',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledError' 
GO
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledAll' 
GO
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledFatal' 
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetSkuListForInventoryAndPrice')
BEGIN 
	DROP PROCEDURE Znode_GetSkuListForInventoryAndPrice
END
GO
CREATE  PROCEDURE [dbo].[Znode_GetSkuListForInventoryAndPrice](
       @WhereClause VARCHAR(MAX) ,
       @Rows        INT           = 100 ,
       @PageNo      INT           = 1 ,
       @Order_BY    VARCHAR(1000) = '' ,
       @RowsCount   INT = 0  OUT ,
       @LocaleId    INT           = 1 ,
       @PriceListId INT           = 0)
AS 
   /* 
    Summary : this procedure is used to Get the inventory list by sku 
    Unit Testing 
     EXEC Znode_GetSkuListForInventoryAndPrice  '',@Order_BY = '',@RowsCount= 1 ,@Rows = 100,@PageNo= 1,@PriceListId = 26,@LocaleId =1 
     SELECT * FROM ZnodePublishProduct WHERE PimProductid  = 4
   */
     BEGIN
         BEGIN TRY
		 DECLARE @SQLqry NVARCHAR(MAX)=''
		     DECLARE @PimProductIds TransferId, --NVARCHAR(max)= '', 
					@OutPimProductIds NVARCHAR(max)= '',
					@PimAttributeId NVARCHAR(max)=''
			 DECLARE @pimSkuAttributeId VARCHAR(50) = [dbo].[Fn_GetProductSKUAttributeId] ()
			 DECLARE @PimProductNameAttributeId VARCHAR(50) = [dbo].[Fn_GetProductNameAttributeId]()
			 DECLARE @PimProductTypeAttributeId VARCHAR(50) = [dbo].[Fn_GetProductTypeAttributeId]()
			 DECLARE @PimIsDownlodableAttributeId VARCHAR(50) = [dbo].[Fn_GetIsDownloadableAttributeId]()
			 DECLARE @PimProductImageAttributeId VARCHAR(50) = [dbo].[Fn_GetProductImageAttributeId]()

			 DECLARE @DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleId()
			 DECLARE @TransferPimProductId TransferId 
			 DECLARE @IsProductNotIn BIT = 1 
			 DECLARE @IMamgePAth NVARCHAR(max) = [dbo].[Fn_GetServerThumbnailMediaPath]()

			 DECLARE @ProductIdTable TABLE
             (
				PimProductId INT,
				CountId      INT,
				RowId        INT IDENTITY(1,1)
             );

			 --DECLARE @TBL_AttributeDetails AS TABLE
    --         (
				--PimProductId   INT,
				--AttributeValue NVARCHAR(MAX),
				--AttributeCode  VARCHAR(600),
				--PimAttributeId INT
    --         );
			 CREATE TABLE #TBL_AttributeDetails
			 (
				PimProductId   INT,
				AttributeValue NVARCHAR(MAX),
				AttributeCode  VARCHAR(600),
				PimAttributeId INT
             );
             IF @PriceListId > 0
             BEGIN
				INSERT INTO @TransferPimProductId 
				SELECT Distinct PimProductId 
				FROM  [dbo].[View_PimProductAttributeValueLocale] VIMP
				INNER JOIN ZnodePrice  ZP ON (Zp.SKU = VIMP.AttributeValue )
				WHERE VIMP.PimAttributeid = @pimSkuAttributeId
				AND VIMP.LocaleId = @LocaleId
				AND ZP.PriceListId = @PriceListId
					
               SET @IsProductNotIn = 1 --CASE WHEN @PimProductIds IS NULL OR @PimProductIds = '' then 1 else 0 end 

			   IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId )
			   BEGIN 
					INSERT INTO @TransferPimProductId
					SELECT '-1'
			   END 
			 --  set @PimProductIds = CASE WHEN @PimProductIds IS NULL OR @PimProductIds = '' then  else @PimProductIds end 
		     END;
			-- SELECT * FROM ZnodePrice WHERE PriceListId = 21
			DECLARE @AttributeCode NVARCHAR(max)= '',@SQL NVARCHAR(max)=''
 DECLARE  @ProductListIdRTR TransferId
	 DECLARE @TAb Transferid 
	 DECLARE @tBL_mainList TABLE (Id INT,RowId INT)
	 --	IF @PimProductId <> ''  OR   @IsCallForAttribute=1
		--BEGIN 
	 --SET @IsProductNotIn = CASE WHEN @IsProductNotIn = 0 THEN 1  
		--			 WHEN @IsProductNotIn = 1 THEN 0 END 
		--END 
	 INSERT INTO @ProductListIdRTR
	 EXEC Znode_GetProductList  0,@TransferPimProductId
	 
	 IF CAST(@WhereClause AS NVARCHAR(max))<> N''
	 BEGIN 
	 
	  SET @SQL = 'SELECT PimProductId FROM ##Temp_PimProductId'+CAST(@@SPID AS VARCHAR(500))

	  EXEC Znode_GetFilterPimProductId @WhereClause,@ProductListIdRTR,@localeId
	  
      INSERT INTO @TAB 
	  EXEC (@SQL)
	 
	 END 

	 IF EXISTS (SELECT Top 1 1 FROM @TAb ) OR CAST(@WhereClause AS NVARCHAR(max)) <> N''
	 BEGIN 
	 
	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO @TBL_MainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @TAb ,@AttributeCode,@localeId
	 
	 END 
	 ELSE 
	 BEGIN
	  
	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO @TBL_MainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @ProductListIdRTR ,@AttributeCode,@localeId 
	 END 
	 --SELECT * 
		--	 FROM @TBL_MainList
		

			 INSERT INTO @ProductIdTable (PimProductId)              
			 SELECT Id 
			 FROM @TBL_MainList SP 
				  	           
             --SET @PimProductIds = SUBSTRING((SELECT ','+CAST(PimProductId AS VARCHAR(100)) FROM @ProductIdTable FOR XML PATH('')), 2, 4000);
			 INSERT INTO @PimProductIds ( Id )
			 SELECT PimProductId FROM @ProductIdTable

             SET @PimAttributeId = @pimSkuAttributeId  + ',' + @PimProductNameAttributeId + ',' +@PimProductTypeAttributeId + ',' + @PimIsDownlodableAttributeId + ',' + @PimProductImageAttributeId ;
			
			  DECLARE @FamilyDetails TABLE
             (
				PimProductId         INT,
				PimAttributeFamilyId INT,
				FamilyName           NVARCHAR(3000)
             );	


			 INSERT INTO @FamilyDetails ( PimAttributeFamilyId, PimProductId )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId] @PimProductIds, 1;

             UPDATE a
             SET  FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId AND LocaleId = @LocaleId);

             UPDATE a
             SET FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a 
			 INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL OR a.FamilyName = '';

			 
             --INSERT INTO @TBL_AttributeDetails ( PimProductId, AttributeValue, AttributeCode, PimAttributeId )
             INSERT INTO #TBL_AttributeDetails( PimProductId, AttributeValue, AttributeCode, PimAttributeId )
			 EXEC Znode_GetProductsAttributeValue @PimProductIds, @PimAttributeId, @localeId;
			 
			-- INSERT INTO @TBL_AttributeDetails ( PimProductId, AttributeValue, AttributeCode )
			INSERT INTO #TBL_AttributeDetails( PimProductId, AttributeValue, AttributeCode )
			 SELECT PimProductId,FamilyName ,'AttributeFamily' AttributeCode 
			 FROM @FamilyDetails 
		    
			IF @Order_BY=''
			BEGIN
			SET @Order_BY='PimProductId ASC'
			END

			SET @SQLqry =';With Cte_pimProductDetails1 AS
			(
			  SELECT PimProductId,AttributeValue,AttributeCode FROM #TBL_AttributeDetails
			)
			SELECT PimProductId,ProductName,SKU,Convert ( BIT, CASE when ISNULL(IsDownloadable,0)= ''true'' then 1 else 0 END )IsDownloadable,ZM.[Path] ProductImage, AttributeFamily,[ProductType]
			FROM Cte_pimProductDetails1 CTEPD
			PIVOT
			(
				Max(AttributeValue) FOR AttributeCode IN ([ProductName],[SKU],[IsDownloadable],[ProductImage],[AttributeFamily],[ProductType])
			) PIV
			LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = Piv.[ProductImage]) ORDER BY '+@Order_BY+''
			
			EXEC (@SQLqry)
			
			--;With Cte_pimProductDetails AS
			--(
			--  SELECT PimProductId,AttributeValue,AttributeCode FROM #TBL_AttributeDetails
			--)
			--SELECT PimProductId,ProductName,SKU,Convert ( BIT, CASE when ISNULL(IsDownloadable,0)= 'true' then 1 else 0 END )IsDownloadable,@IMamgePAth+ZM.[Path] ProductImage, AttributeFamily,[ProductType]
			--FROM Cte_pimProductDetails CTEPD
			--PIVOT
			--(
			--	Max(AttributeValue) FOR AttributeCode IN ([ProductName],[SKU],[IsDownloadable],[ProductImage],[AttributeFamily],[ProductType])
			--) PIV
			--LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = Piv.[ProductImage])
			--order by ProductName desc
			  
			
				  IF EXISTS (SELECT Top 1 1 FROM @TAb )
	 BEGIN 

		  SELECT @RowsCount= (SELECT COUNT(1) FROM @TAb)   
	 END 
	 ELSE 
	 BEGIN
	 		  SELECT  @RowsCount= (SELECT COUNT(1) FROM @ProductListIdRTR) 
	 END 
	 
	 
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			 @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetSkuListForInventoryAndPrice @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',
			@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''')+',@PriceListId='+ISNULL(CAST(@PriceListId AS VARCHAR(50)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetSkuListForInventoryAndPrice',
				@ErrorInProcedure = 'Znode_GetSkuListForInventoryAndPrice',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO

	 
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WebSite','EditCMSWidgetCategory',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WebSite' and ActionName = 'EditCMSWidgetCategory')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetCategory') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetCategory'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetCategory')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetCategory'))


GO


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WebSite','EditCMSAssociateProduct',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WebSite' and ActionName = 'EditCMSAssociateProduct')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSAssociateProduct') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSAssociateProduct'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSAssociateProduct')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSAssociateProduct'))


GO


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WebSite','EditCMSWidgetBrand',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WebSite' and ActionName = 'EditCMSWidgetBrand')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetBrand') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetBrand'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetBrand')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Banner Sliders' AND ControllerName = 'WebSite') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'EditCMSWidgetBrand'))


GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'PIM' ,'Products','EditAssignLinkProducts',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Products' and ActionName = 'EditAssignLinkProducts')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Products' AND ControllerName = 'Products')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Products' and ActionName= 'EditAssignLinkProducts') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Products' AND ControllerName = 'Products') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Products' and ActionName= 'EditAssignLinkProducts'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Products' AND ControllerName = 'Products'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Products' and ActionName= 'EditAssignLinkProducts')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Products' AND ControllerName = 'Products') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Products' and ActionName= 'EditAssignLinkProducts'))

GO
IF  EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'znodeomsorderdetails' AND COLUMN_NAME = 'TransactionId')
BEGIN 
	ALTER TABLE znodeomsorderdetails ALTER COLUMN TransactionId NVARCHAR(400)
END 
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetOmsOrderDetail')
BEGIN 
	DROP PROCEDURE Znode_GetOmsOrderDetail
END
GO

CREATE PROCEDURE [dbo].[Znode_GetOmsOrderDetail]
( @WhereClause NVARCHAR(MAx),
  @Rows        INT            = 100,
  @PageNo      INT            = 1,
  @Order_BY    VARCHAR(1000)  = '',
  @RowsCount   INT OUT			,
  @UserId	   INT = 0 ,
  @IsFromAdmin int=0
  )
AS
    /*
     Summary : This procedure is used to get the oms order detils
			   Records are fetched for those users who placed the order i.e UserId is Present in ZnodeUser and  ZnodeOmsOrderDetails tables
	 Unit Testing:

     EXEC Znode_GetOmsOrderDetail '',@Order_BY = '',@RowsCount= 0, @UserId = 0 ,@Rows = 80, @PageNo = 1

*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             DECLARE @SQL NVARCHAR(MAX), @ProcessType  varchar(50)='Order'

			 DECLARE @OrderLineItemRelationshipTypeId INT
			 SET @OrderLineItemRelationshipTypeId = ( SELECT top 1 OrderLineItemRelationshipTypeId  FROM ZnodeOmsOrderLineItemRelationshipType where Name = 'AddOns' )

             DECLARE @TBL_OrderList TABLE (OmsOrderId INT,OrderNumber VARCHAR(200),PortalId INT,StoreName NVARCHAR(MAX),CurrencyCode VARCHAR(100),OrderState NVARCHAR(MAX),ShippingId INT ,
				PaymentTypeId INT,PaymentSettingId INT,PaymentStatus NVARCHAR(MAX),PaymentType VARCHAR(100),ShippingStatus BIT ,OrderDate DATETIME,UserId INT,UserName VARCHAR(300),PaymentTransactionToken NVARCHAR(600),Total NUMERIC(28,6),
				OrderItem NVARCHAR(1000),OmsOrderDetailsId INT, ItemCount INT,PODocumentPath NVARCHAR(600),IsInRMA BIT,CreatedByName NVARCHAr(max),ModifiedByName NVARCHAR(max),RowId INT,CountNo INT,Email NVARCHAR(MAX),PhoneNumber NVARCHAR(MAX),
				SubTotal NUMERIC(28,6),TaxCost NUMERIC(28,6),ShippingCost NUMERIC(28,6),BillingPostalCode NVARCHAR(200),ShippingPostalCode NVARCHAR(200),OrderModifiedDate datetime, PaymentDisplayName nvarchar(1200), ExternalId nvarchar(1000)
				,CreditCardExpMonth	int,CreditCardExpYear	int,CardType	varchar(50),CreditCardNumber varchar(10),PaymentExternalId nvarchar(1000),CultureCode nvarchar(1000) ,PublishState nvarchar(600) 
				)

			if object_id('tempdb..#OrderList') is not null
				drop table #OrderList


			if object_id('tempdb..#Cte_OrderLineItem') is not null
				drop table #Cte_OrderLineItem

			SELECT Zoo.OmsOrderId,Zoo.OrderNumber, Zp.PortalId,Zp.StoreName ,ZODD.CurrencyCode,case when ZOS.IsShowToCustomer=0 and cast( @IsFromAdmin as varchar(50)) = 0 then ZOSC.Description else  ZOS.Description end  OrderState,ZODD.ShippingId,ZODD.PaymentTypeId,ZODD.PaymentSettingId
				,ZOPS.Name PaymentStatus,ZPS.Name PaymentType,CAST(1 AS BIT) ShippingStatus ,ZODD.OrderDate,ZODD.UserId,ISNULL(ZODD.FirstName,'')
						+' '+ISNULL(ZODD.LastName,'') UserName ,ZODD.PaymentTransactionToken ,ZODD.Total ,ZODD.OmsOrderDetailsId,ZODD.PoDocument,ZVGD.UserName CreatedBy , ZVGDI.UserName ModifiedBy
						,ZU.Email ,ZU.PhoneNumber ,ZODD.SubTotal ,ZODD.TaxCost ,ZODD.ShippingCost,ZODD.BillingPostalCode,
						ZODD.ModifiedDate AS OrderModifiedDate,  ZODD.PaymentDisplayName  ,isnull(Zoo.ExternalId,0) ExternalId,ZODD.CreditCardExpMonth,ZODD.CultureCode
						,ZODD.CreditCardExpYear,ZODD.CardType,ZODD.CreditCardNumber,ZODD.PaymentExternalId,ZODPS.DisplayName as PublishState
			  INTO #OrderList
			  FROM ZnodeOmsOrder ZOO
			  INNER JOIN ZnodeOmsOrderDetails ZODD ON (ZODD.OmsOrderId = ZOO.OmsOrderId)
			  INNER JOIN ZnodePortal ZP ON (ZP.PortalId = ZODD.portalId )
			  LEFT JOIN ZnodePublishState ZODPS ON (ZODPS.PublishStateId = ZOO.PublishStateId)
			  LEFT JOIN ZnodePaymentType ZPS ON (ZPS.PaymentTypeId = ZODD.PaymentTypeId )
			  LEFT JOIN  ZnodeOmsOrderStateShowToCustomer ZOSC ON (ZOSC.OmsOrderStateId = ZODD.OmsOrderStateId)
			  LEFT JOIN ZnodeOmsOrderState ZOS ON (ZOS.OmsOrderStateId = ZODD.OmsOrderStateId)
			  LEFT JOIN ZnodeOmsPaymentState ZOPS ON (ZOPS.OmsPaymentStateId = ZODD.OmsPaymentStateId)
			  LEFT JOIN ZnodeUser ZU ON (ZU.UserId = ZODD.UserId)
			  LEFT JOIN [dbo].[View_GetUserDetails]  ZVGD ON (ZVGD.UserId = ZODD.CreatedBy )
			  LEFT JOIN [dbo].[View_GetUserDetails]  ZVGDI ON (ZVGDI.UserId = ZODD.ModifiedBy)
			  LEFT JOIN ZnodeShipping ZS ON (ZS.ShippingId = ZODD.ShippingId)
			  LEFT OUTER JOIN ZnodePaymentSetting ZPSS ON (ZPSS.PaymentSettingId = ZODD.PaymentSettingId)
			  LEFT JOIN ZnodePortalPaymentSetting ZPPS ON (ZPPS.PaymentSettingId = ZPSS.PaymentSettingId  AND ZPPS.PortalId = ZODD.PortalId   )
			  WHERE  ZODD.IsActive = 1
		       AND (EXISTS (SELECT TOP 1 1 FROM dbo.Fn_GetRecurciveUserId (CAST(@UserId AS VARCHAR(50)),@ProcessType ) FNRU WHERE FNRU.UserId = ZU.UserId ) OR @UserId  =0 )
			  
			  ALTER TABLE #OrderList ADD ShippingPostalCode VARCHAR(50)

			  UPDATE OL set ol.ShippingPostalCode = sp.ShipToPostalCode
			  from #OrderList OL
			  cross apply (select top 1 ShipToPostalCode from ZnodeOmsOrderShipment where OmsOrderShipmentId in  (select OmsOrderShipmentId from ZnodeOmsOrderLineItems where OmsOrderDetailsId = OL.OmsOrderDetailsId))sp

			  SELECT ZOOLI.ProductName,ZOOLI.Price,Count(ZOOLI.OmsOrderLineItemsId)Over(PARTITION BY Ol.OmsOrderId Order by ZOOLI.OmsOrderDetailsId) CountId
			  ,Row_Number()Over( PARTITION BY Ol.OmsOrderId Order BY ZOOLI.Price DESC, ZOOLI.ProductName) RowId,Ol.OmsOrderId
			  ,CAST(Case when ZRRLI.RmaRequestItemId IS NULL THEN 0 ELSE 1 END AS BIT )  IsInRMA  ,OL.CreatedBy ,OL.ModifiedBy
			  into #Cte_OrderLineItem
			  FROM ZnodeOmsOrderLineItems  ZOOLI
			  LEFT JOIN #OrderList OL ON ( OL.OmsOrderDetailsId = ZOOLI.OmsOrderDetailsId )
			  LEFT JOIN ZnodeRmaRequestItem ZRRLI ON (ZRRLI.OmsOrderLineItemsId = ZOOLI.OmsOrderLineItemsId )
			  WHERE ZOOLI.Quantity > 0 AND ParentOmsOrderLineItemsId IS NOT NULL AND OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeId
			


             SET @SQL = '			  
		    ;with Cte_GetOrderData AS 
			(
				SELECT distinct OL.*, CTOLI.ProductName,CountId ,IsInRMA
				FROM #OrderList OL
				LEFT JOIN #Cte_OrderLineItem CTOLI ON (CTOLI.OmsOrderId = OL.OmsOrderId AND CTOLI.RowId = 1 )
			)
			, Cte_OrderLineDescribe AS 
			(
				SELECT distinct *,'+dbo.Fn_GetPagingRowId(@Order_BY,'OmsOrderId DESC,OmsOrderDetailsId DESC')+',Count(*)Over() CountNo
				FROM Cte_GetOrderData
				WHERE 1= 1 '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'
		    )
			SELECT OmsOrderId,OrderNumber,PortalId,StoreName,CurrencyCode,OrderState,ShippingId,
			PaymentTypeId,PaymentSettingId,PaymentStatus,PaymentType,ShippingStatus,OrderDate,UserId,UserName,PaymentTransactionToken,Total,
			ProductName OrderItem,OmsOrderDetailsId,CountId ItemCount, PoDocument AS PODocumentPath,IsInRMA ,CASE WHEN CreatedBy IS NULL THEN email  ELSE CreatedBy END AS CreatedByName ,ModifiedBy as ModifiedByName,RowId,CountNo,
			Email,PhoneNumber,SubTotal,TaxCost,ShippingCost,BillingPostalCode, ShippingPostalCode,OrderModifiedDate,PaymentDisplayName, ExternalId,CreditCardExpMonth
						,CreditCardExpYear,CardType,CreditCardNumber,PaymentExternalId,CultureCode,PublishState 
			FROM Cte_OrderLineDescribe
			'+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
			 

			INSERT INTO @TBL_OrderList(OmsOrderId,OrderNumber,PortalId,StoreName,CurrencyCode,OrderState,ShippingId,
			PaymentTypeId,PaymentSettingId,PaymentStatus,PaymentType,ShippingStatus,OrderDate,UserId,UserName,PaymentTransactionToken,Total,
			OrderItem,OmsOrderDetailsId, ItemCount, PODocumentPath,IsInRMA ,CreatedByName ,ModifiedByName,RowId,CountNo,Email,PhoneNumber,SubTotal,TaxCost,ShippingCost,BillingPostalCode,ShippingPostalCode,OrderModifiedDate,PaymentDisplayName ,ExternalId,CreditCardExpMonth
						,CreditCardExpYear,CardType,CreditCardNumber ,PaymentExternalId,CultureCode,PublishState)
		    EXEC(@SQL)

			SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_OrderList),0)

			SELECT OmsOrderId,OrderNumber,PortalId,StoreName,CurrencyCode,OrderState,ShippingId,
			PaymentTypeId,PaymentSettingId,PaymentStatus,PaymentType,ShippingStatus,OrderDate,UserId,UserName,PaymentTransactionToken,Total,
			OrderItem,OmsOrderDetailsId, ItemCount, PODocumentPath,IsInRMA ,CreatedByName ,ModifiedByName,Email,PhoneNumber,SubTotal,TaxCost,ShippingCost,BillingPostalCode,ShippingPostalCode,OrderModifiedDate,PaymentDisplayName,ExternalId,CreditCardExpMonth,CreditCardExpYear,CardType,CreditCardNumber,PaymentExternalId,CultureCode,PublishState
			FROM @TBL_OrderList
			ORDER BY RowId

			if object_id('tempdb..#OrderList') is not null
				drop table #OrderList


			if object_id('tempdb..#Cte_OrderLineItem') is not null
				drop table #Cte_OrderLineItem

          END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetOmsOrderDetail @WhereClause = '''+ISNULL(CAST(@WhereClause AS VARCHAR(max)),'''''')+''',@Rows='''+ISNULL(CAST(@Rows AS VARCHAR(50)),'''''')+''',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',
			 @Order_BY='+ISNULL(@Order_BY,'''''')+',@UserId = '+ISNULL(CAST(@UserId AS VARCHAR(50)),'''')+',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',@IsFromAdmin='+ISNULL(CAST(@IsFromAdmin AS VARCHAR(10)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetOmsOrderDetail',
				@ErrorInProcedure = 'Znode_GetOmsOrderDetail',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO

	 IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetCatalogCategoryProducts')
BEGIN 
	DROP PROCEDURE Znode_GetCatalogCategoryProducts
END
GO
CREATE PROCEDURE [dbo].[Znode_GetCatalogCategoryProducts]
( 
  @WhereClause      XML,
  @Rows             INT           = 100,
  @PageNo           INT           = 1,
  @Order_BY         VARCHAR(1000) = 'DisplayOrder asc',
  @RowsCount        INT OUT,
  @LocaleId         INT           = 1,
  @PimCategoryId    INT           = 0,
  @PimCatalogId     INT           = 0,
  @IsAssociated     BIT           = 0,
  @ProfileCatalogId INT           = 0,
  @AttributeCode   VARCHAR(max) = '',
  @PimCategoryHierarchyId INT =0,
  @PortalId INT=0
  )
AS
   
/*
	   Summary:  Get product List  Catalog / category / respective product list   		   
	   Unit Testing   
	   begin tran
	   declare @p7 int = 0  
	   EXEC Znode_GetCatalogCategoryProducts @WhereClause=N'',@Rows=10,@PageNo=1,@Order_By=N'',
	   @RowsCount=@p7 output,@PimCategoryId=11,@PimCatalogId = 1 ,@LocaleId=1 ,@ProfileCatalogId = 1 
	   rollback tran
	  
    */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @DefaultAttributeFamily INT= dbo.Fn_GetDefaultPimProductFamilyId(), @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @OrderId INT= 0;
             DECLARE @SQL VARCHAR(MAX), 
					 @PimProductId TransferId,--VARCHAR(MAX)= '', 
					 @PimAttributeId VARCHAR(MAX),
					 @OutPimProductIds VARCHAR(max);
             DECLARE @TransferPimProductId TransferId 

			 DECLARE @tbl_ProductPricingSku TABLE (sku nvarchar(200),RetailPrice numeric(28,6),SalesPrice numeric(28,6),TierPrice numeric(28,6),
			 TierQuantity numeric(28,6),CurrencyCode varchar(200),CurrencySuffix varchar(2000),CultureCode varchar(2000), ExternalId NVARCHAR(2000)
			 ,Custom1 NVARCHAR(MAX), Custom2 NVARCHAR(MAX), Custom3 NVARCHAR(MAX))				

			 CREATE TABLE #TBL_PimMediaAttributeId  (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO #TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

			 --DECLARE @TBL_ProfileCatalogCategory TABLE
    --         (
				--  ProfileCatalogId     INT,
				--  PimProductId         INT,
				--  PimCategoryId        INT,
				--  PimCatalogCategoryId INT,
				--  PimCategoryHierarchyId INT
    --         );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (
				  PimAttributeId            INT,
				  AttributeDefaultValueCode VARCHAR(100),
				  IsEditable                BIT,
				  AttributeDefaultValue     NVARCHAR(MAX),
				  DisplayOrder INT 
             );
             create TABLE #TBL_AttributeDetails 
             (
				  PimProductId   INT,
				  AttributeValue NVARCHAR(MAX),
				  AttributeCode  VARCHAR(600),
				  PimAttributeId INT
				  
             );
             DECLARE @FamilyDetails TABLE
             (
				  PimProductId         INT,
				  PimAttributeFamilyId INT,
				  FamilyName           NVARCHAR(3000)
             );
             DECLARE @TBL_AttributeValue TABLE
             (
				  PimCategoryAttributeValueId INT,
				  PimCategoryId               INT,
				  CategoryValue               NVARCHAR(MAX),
				  AttributeCode               VARCHAR(300),
				  PimAttributeId              INT
             );
             IF @Order_By = ''
                 BEGIN
                     SET @Order_By = 'DisplayOrder asc'
                 END;
             --IF @ProfileCatalogId > 0
             --    BEGIN
             --        INSERT INTO @TBL_ProfileCatalogCategory (ProfileCatalogId,PimProductId,PimCategoryId,PimCatalogCategoryId,PimCategoryHierarchyId)
             --        SELECT ZPC.ProfileCatalogId,PimProductId,PimCategoryId,ZCC.PimCatalogCategoryId,PimCategoryHierarchyId
             --        FROM ZnodePimCatalogCategory AS ZCC
             --        INNER JOIN ZnodeProfileCatalog AS ZPC ON(ZPC.PimCatalogId = ZCC.PimCatalogId)
             --        WHERE ZPC.ProfileCatalogId = @ProfileCatalogId

             --        AND NOT EXISTS
             --            (
             --               SELECT TOP 1 1
             --               FROM ZnodeProfileCatalogCategory AS ZPCC
             --               WHERE ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId
             --            );
             --    END;
			 
             IF @PimCatalogId = 0
                 BEGIN
					INSERT INTO @TransferPimProductId 
                    SELECT PimProductId 
                    FROM ZnodePimCategoryProduct AS ZCP
                    WHERE ZCP.PimCategoryId = @PimCategoryId
					AND PimProductId IS NOT NULL 
                                                   
                 END;
             ELSE
                 BEGIN
				 
                     IF @IsAssociated = 0
                        AND @ProfileCatalogId > 0
                         BEGIN
				INSERT INTO @TransferPimProductId 
                SELECT DISTINCT PimProductId 
                FROM ZnodePimCatalogCategory AS ZCP
                WHERE ZCP.PimCatalogId = @PimCatalogId
              --  AND ZCP.PimCategoryId = @PimCategoryId
				AND ZCP.PimCategoryHierarchyId = @PimCategoryHierarchyId 
                AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM ZnodeProfileCatalogCategory AS TBPCC
                    WHERE TBPCC.PimCatalogCategoryId = ZCP.PimCatalogCategoryId
                        AND TBPCC.ProfileCatalogId = @ProfileCatalogId
                )
               	AND PimProductId IS NOT NULL                                         
                        END;
                     ELSE
                         BEGIN
                             IF @IsAssociated = 1
                                AND @ProfileCatalogId > 0
                                 BEGIN
						INSERT INTO @TransferPimProductId 
                        SELECT PimProductId
                        FROM ZnodePimCatalogCategory AS ZCP
                        WHERE ZCP.PimCatalogId = @PimCatalogId
                            AND ZCP.PimCategoryHierarchyId = @PimCategoryHierarchyId
                            AND EXISTS
                        (
                            SELECT TOP 1 1
                            FROM ZnodeProfileCatalogCategory AS TBPCC
                            WHERE TBPCC.PimCatalogCategoryId = ZCP.PimCatalogCategoryId
                                AND TBPCC.ProfileCatalogId = @ProfileCatalogId
                        )
                       AND PimProductId IS NOT NULL                                             
                                     SET @IsAssociated = 0;
                                 END;
                             ELSE
                                 BEGIN
					INSERT INTO @TransferPimProductId 
                    SELECT DISTINCT PimProductId 
                    FROM ZnodePimCatalogCategory AS ZCP
                    WHERE ZCP.PimCatalogId = @PimCatalogId
                 --   AND ZCP.PimCategoryId = @PimCategoryId
					AND ZCP.PimCategoryHierarchyId = @PimCategoryHierarchyId 
				    AND PimProductId IS NOT NULL  
			
         --           ORDER BY CASE WHEN @OrderId = 0
         --                       THEN 1
         --                       ELSE ZCP.PimCatalogCategoryId
								 --END 
								 --DESC
                                   
                                 END;
                         END;
                 END;
				
				 IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId)
				 BEGIN 
                  INSERT INTO @TransferPimProductId
				  SELECT '0'

				 END 

				 
             DECLARE @ProductIdTable TABLE
             ([PimProductId] INT,
              [CountId]      INT,
              PimCategoryId  INT,
              RowId          INT IDENTITY(1,1)
             );
            DECLARE  @ProductListIdRTR TransferId
	 DECLARE @TAb Transferid 
	 DECLARE @tBL_mainList TABLE (Id INT,RowId INT)
	 --	IF @PimProductId <> ''  OR   @IsCallForAttribute=1
		--BEGIN 
	 SET @IsAssociated = CASE WHEN @IsAssociated = 0 THEN 1  
					 WHEN @IsAssociated = 1 THEN 0 END 
		--END 

		

	 INSERT INTO @ProductListIdRTR
	 EXEC Znode_GetProductList  @IsAssociated,@TransferPimProductId
	 


	 IF CAST(@WhereClause AS NVARCHAR(max))<> N''
	 BEGIN 
	 
	  SET @SQL = 'SELECT PimProductId FROM ##Temp_PimProductId'+CAST(@@SPID AS VARCHAR(500))

	  EXEC Znode_GetFilterPimProductId @WhereClause,@ProductListIdRTR,@localeId
	  
      INSERT INTO @TAB 
	  EXEC (@SQL)
	-- SELECT * FROM @TAB
	 END 
	 
	 
	 IF EXISTS (SELECT Top 1 1 FROM @TAb ) OR CAST(@WhereClause AS NVARCHAR(max)) <> N''
	 BEGIN 
	 
		 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
		 --SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
		 INSERT INTO @TBL_MainList(id,RowId)
		 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @TAb ,@AttributeCode,@localeId,
		 @PimCategoryHierarchyId=@PimCategoryHierarchyId ,@PortalId=@PortalId
	 
		 END 
	 ELSE 
	 BEGIN
	      
	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 --SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO @TBL_MainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @ProductListIdRTR ,@AttributeCode,@localeId,
	 @PimCategoryHierarchyId=@PimCategoryHierarchyId ,@PortalId=@PortalId 
	 
	 END 

	
	
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT id 
			 FROM @TBL_MainList 
            
			 UPDATE @ProductIdTable
               SET
                   PimCategoryId = @PimCategoryId;
             --SET @PimProductId = SUBSTRING(
             --                             (
             --                                 SELECT ','+CAST(PimProductId AS VARCHAR(100))
             --                                 FROM @ProductIdTable
             --                                 FOR XML PATH('')
             --                             ), 2, 4000);

			 INSERT INTO @PimProductId  ( Id )
			 SELECT PimProductId FROM @ProductIdTable

             SET @PimAttributeId = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetGridPimAttributes]() FOR XML PATH('')), 2, 4000);
             
			 DECLARE @PimAttributeIds TransferId  
			 INSERT INTO @PimAttributeIds
			 SELECT PimAttributeId  
			 FROM [dbo].[Fn_GetProductGridAttributes]()
		
			 
			
			 INSERT INTO @TBL_AttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)   
			 EXEC Znode_GetAttributeDefaultValueLocale @PimAttributeId,@LocaleId;
     
			 INSERT INTO #TBL_AttributeDetails (PimProductId,AttributeValue,AttributeCode,PimAttributeId)
             EXEC Znode_GetProductsAttributeValue @PimProductId,@PimAttributeId,@localeId;
			  
             SET @PimAttributeId = [dbo].[Fn_GetCategoryNameAttributeId]();
			 
             INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
             EXEC [dbo].[Znode_GetCategoryAttributeValue] @PimCategoryId,@PimAttributeId,@LocaleId;
         
				SELECT TBAI.PimProductId , FNMA.PimAttributeId ,ISNULL(CASE WHEN ZMC.CDNURL = '' THEN NULL ELSE ZMC.CDNURL END,ZMC.URL)+ZMSM.ThumbnailFolderName+'/'+ zm.PATH as AttributeValue
				INTO #ProductMedia
				FROM ZnodeMedia AS ZM
				INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
				INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
				INNER JOIN #TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
				INNER JOIN  #TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
				
				SELECT PimProductId, PimAttributeId,
					STUFF((SELECT ','+AttributeValue FROM #ProductMedia PM1 
					WHERE PM1.PimProductId = PM.PimProductId AND PM.PimAttributeId = PM1.PimAttributeId FOR XML PATH('')),1,1,'') AS AttributeValue 
				into #Cte_ProductMedia
				FROM #ProductMedia PM
			  
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM #TBL_AttributeDetails TBAV 
			  INNER JOIN #Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;
			    
             INSERT INTO @FamilyDetails (PimAttributeFamilyId,PimProductId)
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId] @PimProductId,1;

             UPDATE a
             SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                  AND LocaleId = @LocaleId);
             UPDATE a
             SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                  AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';

				

             SELECT zpp.PimProductid AS ProductId,zpp.PimProductId,@PimCatalogId AS PimCatalogId,zpp.PimCategoryId,[ProductName],
			 ProductType,ISNULL(zf.FamilyName, '') AS AttributeFamily,[SKU],[Price],[Quantity],
                    CASE
                        WHEN Piv.[IsActive] IS NULL
                        THEN CAST(0 AS BIT)
                        ELSE CAST(Piv.[IsActive] AS BIT)
                    END AS [IsActive],
                    piv.[ProductImage] ImagePath,
                    [Assortment],
                    TBAV.CategoryValue AS [CategoryName],
                    @LocaleId AS LocaleId,
                    ZCC.[DisplayOrder],
                    ZPCC.ProfileCatalogCategoryId,
                    zpp.RowId,
					ZCC.PimCategoryHierarchyId
			 INTO #temp_ProductDetails 
             FROM @ProductIdTable AS zpp
			 INNER JOIN @TBL_MainList TMM ON (TMM.Id = zpp.PimProductId)
                  LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
                  INNER JOIN
             (
                 SELECT PimProductId,
                        AttributeValue,
                        AttributeCode
                 FROM #TBL_AttributeDetails
             ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
                                                                 [SKU],
                                                                 [Price],
                                                                 [Quantity],
                                                                 [IsActive],
                                                                 [ProductType],
                                                                 [ProductImage],
                                                                 [Assortment],
                                                                 [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
                  LEFT JOIN @TBL_AttributeValue AS TBAV ON(TBAV.PimCategoryId = ZPP.PimCategoryId)
                  LEFT JOIN ZnodePimCategoryProduct AS ZPCP ON(ZPCP.PimProductId = Zpp.PimProductId
                                                               AND ZPCP.PimCategoryId = Zpp.PimCategoryId)
                  LEFT JOIN ZnodePimCatalogCategory AS ZCC ON(ZCC.PimProductId = Zpp.PimProductId
                                                             AND ZCC.PimCategoryHierarchyId = @PimCategoryHierarchyId
                                                              AND ZCC.PimCatalogId = @PimCatalogId)
                  LEFT JOIN ZnodeProfileCatalogCategory AS ZPCC ON(ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId
                                                                   AND ZPCC.ProfileCatalogId = @ProfileCatalogId)
                  
            ORDER BY zpp.RowId

			DECLARE @SKUS VARCHAR(max) 
			,@userId INT = 0,@Date DATETIME  = dbo.FN_getDate() 

			SELECT @SKUS = COALESCE(@SKUS+',' ,'') + SKU
			FROM #temp_ProductDetails
			 				
			INSERT INTO @tbl_ProductPricingSku		
			EXEC Znode_GetPublishProductPricingBySku 	@SKU=@SKUS, @PortalId= @PortalId,@Userid= @userid ,@currentUtcDate=	@Date
			
			SELECT DISTINCT ProductId, PimProductId	,PimCatalogId,	PimCategoryId,	ProductName	,ProductType,	
			AttributeFamily,	a.SKU	,dbo.Fn_GetPortalCurrencySymbol(@portalId)+CAST(Dbo.Fn_GetDefaultPriceRoundOff(RetailPrice) AS NVARCHAR(max)) Price,	Quantity,	
			IsActive,	ImagePath,	Assortment,	CategoryName,	LocaleId,	DisplayOrder	,ProfileCatalogCategoryId,	RowId,	PimCategoryHierarchyId	
			FROM #temp_ProductDetails a 
			LEFT JOIN @tbl_ProductPricingSku b ON (dbo.FN_TRIM(b.SKU) = a.SKU )
			ORDER BY RowId
					  
     IF EXISTS (SELECT Top 1 1 FROM @TAb )
	 BEGIN 

		  SELECT @RowsCount = (SELECT COUNT(1) FROM @TAb) 
	 END 
	 ELSE 
	 BEGIN
	 		  SELECT @RowsCount =(SELECT COUNT(1) FROM @ProductListIdRTR)   
	 END 
	

         END TRY
         BEGIN CATCH
		    SELECT ERROR_message()
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCatalogCategoryProducts @WhereClause = '''+ISNULL(CAST(@WhereClause AS VARCHAR(MAX)),'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',
			@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''')+',@PimCategoryId='+ISNULL(CAST(@PimCategoryId AS VARCHAR(50)),'''')+',@PimCatalogId='+ISNULL(CAST(@PimCatalogId AS VARCHAR(50)),'''')+',@IsAssociated='+ISNULL(CAST(@IsAssociated AS VARCHAR(50)),'''')+',
			@ProfileCatalogId='+ISNULL(CAST(@ProfileCatalogId AS VARCHAR(50)),'''')+',@AttributeCode='''+ISNULL(CAST(@AttributeCode AS VARCHAR(50)),'''''')+''',@PimCategoryHierarchyId='+ISNULL(CAST(@PimCategoryHierarchyId AS VARCHAR(10)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetCatalogCategoryProducts',
				@ErrorInProcedure = 'Znode_GetCatalogCategoryProducts',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetOrderByPagingProduct')
BEGIN 
	DROP PROCEDURE Znode_GetOrderByPagingProduct
END
GO
CREATE PROCEDURE [dbo].[Znode_GetOrderByPagingProduct]
(
 @Order_by  Nvarchar(max)
 ,@Rows     INT =10 
 ,@PageNo   INT =1 
 ,@PimProductId TransferId Readonly 
 ,@AttributeCode VARCHAR(max)= ''
 ,@localeId INT  
 ,@PimCategoryHierarchyId INT  = 0
 ,@PortalId INT = 0 
)
AS 
BEGIN 
 SET NOCOUNT ON 
 SET @AttributeCode = CASE WHEN @AttributeCode = '' OR  @AttributeCode IS NULL THEN REPLACE(REPLACE (@Order_by , ' DESC',''),' ASC','')

  ELSE @AttributeCode END 
 DECLARE @StartId INT =  CASE WHEN @PageNo = 1 OR @PageNo = 0 THEN 1 ELSE ((@PageNo-1)*@Rows)+1 END 
 DECLARE @EndId INT = CASE WHEN @PageNo = 0 THEN @Rows ELSE @PageNo*@Rows END
 ,@DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleID()   
 
 DECLARE @AttributeTypeName NVARCHAR(2000)= ''

 SELECT TOP 1 @AttributeTypeName = AttributeTypeName 
 FROM ZnodePimAttribute ZPA 
 INNER JOIN ZnodeAttributeType ZTY ON (ZTY.AttributeTypeId = ZPA.AttributeTypeId)
 WHERE ZPA.AttributeCode = @AttributeCode

 if object_id('tempdb..#PimProductId') is not null
	drop table #PimProductId

 SELECT * INTO #PimProductId FROM @PimProductId
 
 IF  @Order_by = '' 
 BEGIN 
  
  ;WIth Cte_getData AS ( 
  
  SELECT Id , ROW_NUMBER()Over(Order by ZPP.ModifiedDate DESC,ZPP.PimProductId) RowId  
  FROM #PimProductId TBLP
  INNER JOIN ZnodePimProduct ZPP ON (TBLP.Id= ZPP.PimProductId)
  
  ) 
  
  SELECT ID PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId
 
 END 

  IF @PimCategoryHierarchyId <> 0 AND  @Order_by LIKE 'DisplayOrder%'
 BEGIN 
    ;WIth Cte_getData AS (
  SELECT Id , CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by ZPP.DisplayOrder DESC) ELSE 
	  ROW_NUMBER()Over(Order by ZPP.DisplayOrder ASC) END  RowId 
  FROM #PimProductId TBLP
  LEFT JOIN ZnodePimCatalogCategory ZPP ON (TBLP.Id= ZPP.PimProductId AND ZPP.PimCategoryHierarchyId= @PimCategoryHierarchyId )
  ) 
  
  SELECT ID PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId

 END 
 ELSE 
  IF @PimCategoryHierarchyId <> 0 AND  @Order_by LIKE 'Price%'
 BEGIN 
         DECLARE @tbl_ProductPricingSkuOrderBy TABLE (sku nvarchar(200),RetailPrice numeric(28,6),SalesPrice numeric(28,6),TierPrice numeric(28,6),
						TierQuantity numeric(28,6),CurrencyCode varchar(200),CurrencySuffix varchar(2000),CultureCode varchar(2000), ExternalId NVARCHAR(2000))	
	     DECLARE @SKUS VARCHAR(max) 
				,@userId INT = 0,@Date DATETIME  = dbo.FN_getDate() 

				SELECT @SKUS = COALESCE(@SKUS+',' ,'') + SKU
				FROM ZnodePublishProductDetail a 
				INNER JOIN ZnodePublishProduct b ON ( a.PublishProductId =b.PublishProductId ) 
				INNER JOIN ZnodePimCatalogCategory f ON (f.PimProductId = b.PimProductId AND f.PimCategoryHierarchyId= @PimCategoryHierarchyId)
				INNER JOIN ZnodePortalCatalog c ON (c.PublishCatalogId = b.PublishCatalogId)
				WHERE c.PortalId = @PortalId 
				AND EXISTS (SELECT TOP 1  1 FROM #PimProductId R WHERE b.PimProductId = R.Id)
				AND a.LocaleId =dbo.Fn_GetDefaultLocaleId()

			DECLARE @Id TransferId 

			INSERT INTO @tbl_ProductPricingSkuOrderBy		
			SELECT * FROM [dbo].[FN_GetPublishProductPricingBySku]( @SKUS,  @PortalId ,@Date, @userid,@Id)

		

    ;WIth Cte_getData AS (
  SELECT Id , CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by ISNULL(b.RetailPrice,0) DESC) ELSE 
	  ROW_NUMBER()Over(Order by ISNULL(b.RetailPrice,0) ASC) END  RowId 
  FROM #PimProductId TBLP
  LEFT JOIN View_LoadManageProductInternal ZPP ON (TBLP.Id= ZPP.PimProductId AND ZPP.AttributeCode= 'SKU' )
  LEFT JOIN @tbl_ProductPricingSkuOrderBy b ON (b.SKU = ZPP.AttributeValue) 
  ) 
  
  SELECT ID PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId

 END 
 ELSE  
 IF  ( @Order_by LIKE 'PimProductId%'  OR @Order_by LIKE 'DisplayOrder%' ) AND @PimCategoryHierarchyId = 0 
 BEGIN 
  ;WIth Cte_getData AS (
  SELECT Id , CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by ZPP.PimProductId DESC) ELSE 
	  ROW_NUMBER()Over(Order by ZPP.PimProductId ASC) END  RowId 
  FROM #PimProductId TBLP
  INNER JOIN ZnodePimProduct ZPP ON (TBLP.Id= ZPP.PimProductId)
  ) 
  SELECT ID PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
 END 
 ELSE IF  @Order_by LIKE  'ModifiedDate%' 
 BEGIN 
  ;with Cte_GetData AS
  (
  SELECT Id , CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by ZPAV.ModifiedDate DESC ,ZPAV.PimProductId) ELSE 
	  ROW_NUMBER()Over(Order by ZPAV.ModifiedDate ASC ,ZPAV.PimProductId) END  RowId 
  FROM  #PimProductId TBLP
  INNER JOIN ZnodePimAttributeValue ZPAV ON (TBLP.Id = ZPAV.PimProductId)
  INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId) 
  WHERE ZPA.AttributeCode = CASE WHEN @AttributeCode = '' OR @AttributeCode = 'ModifiedDate'  THEN 'SKU' ELSE @AttributeCode END 
  )
  SELECT ID PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId
 END
  ELSE IF  @Order_by LIKE  'PublishStatus%' 
 BEGIN 
  
  ;With Cte_GetData AS
  (
    SELECT TBLP.Id ,CASE WHEN ZPP.IsProductPublish  IS NULL THEN 'Not Published' 
				WHEN ZPP.IsProductPublish = 0 THEN 'Draft'
				ELSE  'Published' END PublishStatus 
  FROM  #PimProductId TBLP
  INNER JOIN ZnodePimProduct ZPP oN (ZPP.PimProductId = TBLP.Id) 
  )
  , Cte_Attruyr AS 
  (
  SELECT Id , CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by PublishStatus DESC , Id ) ELSE 
	  ROW_NUMBER()Over(Order by PublishStatus ASC ,  Id ) END  RowId 
  FROM  Cte_GetData
  
  )
  SELECT ID PimProductId ,RowId
  FROM Cte_Attruyr CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  Order by RowId
 END
 ELSE IF  @Order_by LIKE  'AttributeFamily%' 
 BEGIN 
 ;With Cte_attributeValue AS 
   (
	 SELECT ZPAF.PimAttributeFamilyId,FamilyCode,AttributeFamilyName ,ZPFL.LocaleId
	 FROM ZnodePimAttributeFamily ZPAF
	 INNER JOIN ZnodePimFamilyLocale ZPFL ON (ZPFL.PimAttributeFamilyId = ZPAF.PimAttributeFamilyId) 
	 WHERE ZPFL.LocaleId IN (@DefaultLocaleId,@LocaleId)
	 ) 
   , Cte_AttributeValueAttribute AS (
	  SELECT PimAttributeFamilyId,FamilyCode,AttributeFamilyName
	   FROM Cte_attributeValue RTY 
	   WHERE LocaleId = @LocaleId
      )
   , Cte_AttributeValueTht AS (
      SELECT PimAttributeFamilyId,FamilyCode,AttributeFamilyName
	  FROM Cte_AttributeValueAttribute
	  UNION ALL 
	  SELECT PimAttributeFamilyId,FamilyCode,AttributeFamilyName
	  FROM Cte_attributeValue TYY  
	  WHERE NOT EXISTS (SELECT TOP 1 1 FROM Cte_AttributeValueAttribute THE WHERE THE.PimAttributeFamilyId = TYY.PimAttributeFamilyId )
	  AND TYY.LocaleId = @DefaultLocaleId
	  )
  
  SELECT PimAttributeFamilyId,FamilyCode,AttributeFamilyName
  INTO #TBL_FamilyLocale
  FROM Cte_AttributeValueTht 

 ;With Cte_GetData AS (
    SELECT  TBLAV.PimProductId ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by THY.AttributeFamilyName DESC ,TBLAV.PimProductId) ELSE 
	  ROW_NUMBER()Over(Order by THY.AttributeFamilyName ASC ,TBLAV.PimProductId) END  RowId 
	FROM ZnodePimProduct TBLAV 
	INNER JOIN #TBL_FamilyLocale THY ON (THY.PimAttributeFamilyId = TBLAV.PimAttributeFamilyId )
  )
  SELECT PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId
 
 END
 ELSE IF @AttributeTypeName IN ('Text','Number','Datetime','Yes/No')
 BEGIN 
  IF @DefaultLocaleId = @LocaleID 
  BEGIN 
  ;With Cte_getData AS ( 
  SELECT VPP.PimProductId  ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by VPP.AttributeValue DESC ,VPP.PimProductId) ELSE  
	  ROW_NUMBER()Over(Order by VPP.AttributeValue ASC ,VPP.PimProductId) END RowId 
  FROM #PimProductId TBLP 
  INNER JOIN View_PimProducttextValue VPP ON (TBLP.Id = VPP.PimProductId ) 
  WHERE AttributeCode = @AttributeCode 
  AND LocaleId = @LocaleID
  ) 
  SELECT PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId

  END 
  ELSE 
  BEGIN 
   ;With Cte_AttributeDetails AS 
	 (
	 SELECT TBLAV.ID PimProductId,ZPAVL.AttributeCode,ZPAVL.AttributeValue,ZPAVL.LocaleId,COUNT(*)Over(Partition By TBLAV.ID,ZPAVL.AttributeCode ORDER BY TBLAV.ID,ZPAVL.AttributeCode  ) RowIdIn
	 FROM #PimProductId   TBLAV 
	 INNER JOIN View_PimProducttextValue ZPAVL ON (ZPAVL.PimProductId = TBLAV.id )
	 WHERE (LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId  )
	 AND AttributeCode = @AttributeCode
	 ) 
	 ,Cte_DataLocale AS 
	 (
	 SELECT  TBLAV.PimProductId ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
       ROW_NUMBER()Over(Order by TBLAV.AttributeValue DESC ,TBLAV.PimProductId) ELSE  
	    ROW_NUMBER()Over(Order by TBLAV.AttributeValue ASC ,TBLAV.PimProductId) END RowId
  	 FROM Cte_AttributeDetails TBLAV 
	 WHERE LocaleId = CASE WHEN RowIdIn =2 THEN @localeId ELSE @DefaultLocaleId END 
	 ) 
	 SELECT PimProductId ,RowId
	 FROM Cte_DataLocale 
	 WHERE RowId BETWEEN @StartId AND @EndId
	 order by RowId
  END 
 END
 ELSE IF @AttributeTypeName IN ('Simple Select','Multi Select') 
  BEGIN 
 DECLARE @PimAttributeId TransferId 

 INSERT INTO @PimAttributeId 
 SELECT PimAttributeId
 FROM  ZnodePimAttribute 
 WHERE AttributeCode = @AttributeCode  
 CREATE TABLE #TBL_AttributeDefaultValue ( PimAttributeId INT ,
              AttributeDefaultValueCode VARCHAR(max),IsEditable INT,AttributeDefaultValue NVARCHAR(max),DisplayOrder INT,PimAttributeDefaultValueId INT  ) 
 
			 -- here collect the both locale data 
             SELECT   VIPDV.PimAttributeId,VIPDV.AttributeDefaultValueCode,VIPDV.IsEditable,VIPDVL.AttributeDefaultValue,VIPDVL.LocaleId,VIPDV.PimAttributeDefaultValueId,VIPDV.DisplayOrder
             
			 INTO #Cte_DefaultValueLocale
			 FROM [dbo].[ZnodePimAttributeDefaultValue] VIPDV
			 INNER JOIN [dbo].[ZnodePimAttributeDefaultValueLocale] VIPDVL ON (VIPDVL.PimAttributeDefaultValueId = VIPDV.PimAttributeDefaultValueId) 
             WHERE VIPDVL.LocaleId IN(@DefaultLocaleId, @LocaleId) 
             AND EXISTS
             (
                SELECT TOP 1 1
                FROM @PimAttributeId SP
                WHERE SP.id = VIPDV.PimAttributeId
             )

			 -- filter for first locale
             ;with Cte_DefaultValueFirstLocale
             AS (SELECT CTDVL.PimAttributeId,CTDVL.AttributeDefaultValueCode,CTDVL.IsEditable,CTDVL.AttributeDefaultValue,CTDVL.PimAttributeDefaultValueId,CTDVL.DisplayOrder
                 FROM #Cte_DefaultValueLocale CTDVL
                 WHERE LocaleId = @LocaleId	 
                ),

			 -- get data for second locale if not exists for firts locale 
             Cte_DefaultValueSecondLocale
             AS (SELECT CTDVFL.PimAttributeId,CTDVFL.AttributeDefaultValueCode,CTDVFL.IsEditable,CTDVFL.AttributeDefaultValue,CTDVFL.PimAttributeDefaultValueId,CTDVFL.DisplayOrder
                 FROM Cte_DefaultValueFirstLocale CTDVFL
                 UNION ALL
                 SELECT CTDVL.PimAttributeId,CTDVL.AttributeDefaultValueCode,CTDVL.IsEditable,CTDVL.AttributeDefaultValue,CTDVL.PimAttributeDefaultValueId,CTDVL.DisplayOrder
                 FROM #Cte_DefaultValueLocale CTDVL
                 WHERE LocaleId = @DefaultLocaleId 
                 AND NOT EXISTS
                  (
                      SELECT TOP 1 1
                      FROM Cte_DefaultValueFirstLocale CTDVFL
                      WHERE CTDVFL.PimAttributeDefaultValueId = CTDVL.PimAttributeDefaultValueId
                  ))

                 

    
 INSERT INTO #TBL_AttributeDefaultValue(PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder,PimAttributeDefaultValueId)
  SELECT PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder,PimAttributeDefaultValueId
                  FROM Cte_DefaultValueSecondLocale;


  IF @DefaultLocaleId = @LocaleID 
  BEGIN
    
      ;with Cte_AttributeValue AS 
	  (
	  SELECT  PimProductId , SUBSTRING((SELECT ','+AttributeDefaultValue 
											FROM #TBL_AttributeDefaultValue TTR 
											INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (TTR.PimAttributeDefaultValueId = ZPAVL.PimAttributeDefaultValueId )
											WHERE ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId  
											AND ZPAVL.LocaleId = @localeId 
											FOR XML PATH('') ),2,4000) AttributeValue
	  FROM #PimProductId TBLP  
	  INNER JOIN ZnodePimAttributeValue ZPAV  ON (TBLP.ID = ZPAV.PimProductId )
	  INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
	  WHERE AttributeCode = @AttributeCode
	 ) 
	 ,CTe_GetDataIn AS 
	 (
	 SELECT PimProductId  ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
       ROW_NUMBER()Over(Order by VPP.AttributeValue DESC ,VPP.PimProductId) ELSE  
	    ROW_NUMBER()Over(Order by VPP.AttributeValue ASC ,VPP.PimProductId) END RowId
	 FROM  Cte_AttributeValue  VPP
     ) 
	 SELECT PimProductId ,RowId
	 FROM CTe_GetDataIn 
	 WHERE RowId BETWEEN @StartId AND @EndId 
	 order by RowId
   END 
   ELSE 
   BEGIN
    SELECT ZPAV.PimAttributeValueId,ZPAVL.PimAttributeDefaultValueId , ZPAVL.LocaleId ,COUNT(*)Over(Partition By ZPAV.PimAttributeValueId ,ZPAV.PimProductId ORDER BY ZPAV.PimAttributeValueId ,ZPAV.PimProductId  ) RowId
			   INTO #temp_Table 
			   FROM #PimProductId TBLP  
	           INNER JOIN ZnodePimAttributeValue ZPAV  ON (TBLP.ID = ZPAV.PimProductId )
			   INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
			   WHERE (ZPAVL.LocaleId = @localeId  OR ZPAVL.LocaleId = @DefaultlocaleId )

   ;with Cte_AttributeValue AS 
	  (
	  SELECT  PimProductId ,SUBSTRING((SELECT ','+AttributeDefaultValue FROM #TBL_AttributeDefaultValue TTR 
				INNER JOIN #temp_Table  ZPAVL ON (TTR.PimAttributeDefaultValueId = ZPAVL.PimAttributeDefaultValueId )
				WHERE ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId  
				AND ZPAVL.LocaleId = CASE WHEN ZPAVL.RowId = 2 THEN @LocaleId  ELSE @DefaultLocaleId  END  
				FOR XML PATH('') ),2,4000) AttributeValue
	  FROM #PimProductId TBLP  
	  INNER JOIN ZnodePimAttributeValue ZPAV  ON (TBLP.ID = ZPAV.PimProductId )
	  INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
	  WHERE AttributeCode = @AttributeCode
	 ) 
	 ,CTe_GetDataIn AS 
	 (
	 SELECT PimProductId  ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
       ROW_NUMBER()Over(Order by VPP.AttributeValue DESC ,VPP.PimProductId) ELSE  
	    ROW_NUMBER()Over(Order by VPP.AttributeValue ASC ,VPP.PimProductId) END RowId
	 FROM  Cte_AttributeValue  VPP
     ) 
	 SELECT PimProductId ,RowId
	 FROM CTe_GetDataIn 
	 WHERE RowId BETWEEN @StartId AND @EndId 
	 order by RowId
   
   END 
    DROP TABLE #TBL_AttributeDefaultValue
  END 
  ELSE IF @AttributeTypeName IN ('Text Area') 
  BEGIN 
   IF @DefaultLocaleId = @LocaleID 
   BEGIN 
   ;With Cte_getData AS ( 
    SELECT VPP.PimProductId  ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
    ROW_NUMBER()Over(Order by VPP.AttributeValue DESC ,VPP.PimProductId) ELSE  
	  ROW_NUMBER()Over(Order by VPP.AttributeValue ASC ,VPP.PimProductId) END RowId 
  FROM #PimProductId TBLP 
  INNER JOIN View_PimProductTextAreaValue VPP ON (TBLP.Id = VPP.PimProductId ) 
  WHERE AttributeCode = @AttributeCode 
  AND LocaleId = @LocaleID
  ) 
  SELECT PimProductId ,RowId
  FROM Cte_GetData CTE
  WHERE RowId BETWEEN @StartId AND @EndId
  order by RowId
   END 
   ELSE 
   BEGIN 
   ;With Cte_AttributeDetails AS 
	 (
	 SELECT TBLAV.ID PimProductId,ZPAVL.AttributeCode,ZPAVL.AttributeValue,ZPAVL.LocaleId,COUNT(*)Over(Partition By ZPAVL.PimProductId,ZPAVL.AttributeCode ORDER BY ZPAVL.PimProductId,ZPAVL.AttributeCode  ) RowIdIn
	 FROM #PimProductId   TBLAV 
	 INNER JOIN View_PimProductTextAreaValue ZPAVL ON (ZPAVL.PimProductId = TBLAV.id )
	 WHERE (LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId  )
	 AND AttributeCode = @AttributeCode
	 ) 
	 ,Cte_DataLocale AS 
	 (
	 SELECT  TBLAV.PimProductId ,CASE WHEN @Order_by LIKE  '% DESC' THEN 
       ROW_NUMBER()Over(Order by TBLAV.AttributeValue DESC ,TBLAV.PimProductId) ELSE  
	    ROW_NUMBER()Over(Order by TBLAV.AttributeValue ASC ,TBLAV.PimProductId) END RowId
  	 FROM Cte_AttributeDetails TBLAV 
	 WHERE LocaleId = CASE WHEN RowIdIn = 2 THEN @localeId ELSE @DefaultLocaleId END 
	 ) 
	 SELECT PimProductId ,RowId
	 FROM Cte_DataLocale 
	 WHERE RowId BETWEEN @StartId AND @EndId
	 order by RowId

	 if object_id('tempdb..#PimProductId') is not null
		drop table #PimProductId
   END 
END 
END
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetProductsAttributeValue')
BEGIN 
	DROP PROCEDURE Znode_GetProductsAttributeValue
END
GO

CREATE PROCEDURE [dbo].[Znode_GetProductsAttributeValue]
(   @PimProductId   TransferId READONLY,
    @AttributeCode VARCHAR(MAX),
    @LocaleId      INT = 0,
	@IsPublish bit = 0  )
AS
/* 
    
     Summary:- This Procedure is used to get the product attribute values 
			   The result is fetched from all locale for ProductId provided
     Unit Testing 
     EXEC Znode_GetProductsAttributeValue_1 '2146','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',0
	 SELECT * FROM ZnodePIMProduct
	 
*/	
	 BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 	
				if object_id('tempdb..#TBL_PimProductId') is not null
					drop table #TBL_PimProductId	

				if object_id('tempdb..#TBL_AttributeValue_Internal') is not null
					drop table #TBL_AttributeValue_Internal

				CREATE TABLE #TBL_AttributeValue_Internal  (PimAttributeValueId INT,PimProductId INT,AttributeValue NVARCHAR(MAX),PimAttributeId INT)
				DECLARE @TBL_AttributeDefault TABLE (PimAttributeId INT,AttributeDefaultValueCode VARCHAR(100),IsEditable BIT,AttributeDefaultValue NVARCHAR(MAX),DisplayOrder INT)
				DECLARE @DefaultLocaleId INT = DBO.FN_GetDefaultLocaleId()
				DECLARE @TBL_MediaValue TABLE (PimAttributeValueId INT,PimProductId INT,MediaPath NVARCHAR(MAX),PimAttributeId INT ,LocaleId INT )
				
				CREATE TABLE #TBL_PimProductId  (PimProductId INT)
							
				INSERT INTO #TBL_PimProductId 
				SELECT Id FROM @PimProductId
				
				INSERT INTO @TBL_MediaValue
					SELECT ZPAV.PimAttributeValueId	
							,PimProductId
							,ZPPAM.MediaId MediaPath
							,ZPAV.PimAttributeId , ZPPAM.LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER JOIN ZnodePimProductAttributeMedia ZPPAM ON ( ZPPAM.PimAttributeValueId = ZPAV.PimAttributeValueId)
					LEFT JOIN ZnodeMedia ZM ON (Zm.MediaId = ZPPAM.MediaId)  
								
					SELECT ZPPADV.PimAttributeValueId ,ZPADVL.AttributeDefaultValue ,ZPADVL.LocaleId 
					INTO #Cte_GetDefaultData
					FROM ZnodePimProductAttributeDefaultValue ZPPADV 
					INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)
					INNER JOIN ZnodePimAttributeDefaultValueLocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )
					WHERE ZPADVL.LocaleID IN (@LocaleId,@DefaultLocaleId)
					AND EXISTS (SELECT TOP 1 1 FROM #TBL_PimProductId TBPP  WHERE TBPP.PimProductId = ZPAV.PimProductId)
				
				
				;WITH Cte_AttributeValueDefault AS 
				(
				 SELECT PimAttributeValueId ,AttributeDefaultValue ,@DefaultLocaleId LocaleId 
				 FROM #Cte_GetDefaultData 
				 WHERE LocaleId = @LocaleId 
				 UNION  
				 SELECT PimAttributeValueId ,AttributeDefaultValue ,@DefaultLocaleId LocaleId 
				 FROM #Cte_GetDefaultData a 
				 WHERE LocaleId = @DefaultLocaleId 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM #Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)
     			)
				
				SELECT DISTINCT PimAttributeValueId ,SUBSTRING ((SELECT ',' + AttributeDefaultValue 
													FROM Cte_AttributeValueDefault CTEAI 
													WHERE CTEAI.PimAttributeValueId = CTEA.PimAttributeValueId 
													FOR XML PATH ('')   ),2,4000) AttributeDefaultValue , LocaleId
				
				INTO #Cte_AttributeLocaleComma 
				FROM Cte_AttributeValueDefault  CTEA 
								
					SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,ZPPATV.AttributeValue,ZPAV.PimAttributeId,ZPPATV.LocaleId
					INTO #Cte_AllAttributeData
					FROM ZnodePimAttributeValue ZPAV
					INNER join ZnodePimProductAttributeTextAreaValue ZPPATV ON (ZPPATV.PimAttributeValueId= ZPAV.PimAttributeValueId)
					INNER JOIN #TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
					UNION ALL
					
					SELECT PimAttributeValueId,TBM.PimProductId
							,MediaPath
							,PimAttributeId,LocaleId
					from #TBL_PimProductId TBPP   
					INNER JOIN @TBL_MediaValue TBM ON (TBM.PimProductId = TBPP.PimProductId)

					UNION ALL 
					SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,ZPAVL.AttributeValue,ZPAV.PimAttributeId,ZPAVL.LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER JOIN ZnodePimAttributeValueLocale  ZPAVL ON ( ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
					INNER JOIN #TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
					WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@AttributeCode,',') SP WHERE (SP.Item = ZPA.AttributeCode  OR SP.Item = CAST(ZPA.PimATtributeId  AS VARCHAR(50)) )) 
					AND ZPAVL.LocaleId IN (@LocaleId,@DefaultLocaleId)
					 
					UNION ALL
					SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,CS.AttributeDefaultValue,ZPAV.PimAttributeId,LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER JOIN #Cte_AttributeLocaleComma CS ON (ZPAV.PimAttributeValueId = CS.PimAttributeValueId)
					INNER JOIN #TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
				
				;With Cte_AttributeFirstLocal AS 
				(
					SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
					FROM #Cte_AllAttributeData
					WHERE LocaleId = @LocaleId
				)
				,Cte_DefaultAttributeValue AS 
				(
					SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
					FROM Cte_AttributeFirstLocal
					UNION ALL 
					SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
					FROM #Cte_AllAttributeData CTAAD
					WHERE LocaleId = @DefaultLocaleId
					AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_AttributeFirstLocal CTRT WHERE CTRT.PimAttributeValueId = CTAAD.PimAttributeValueId   )
			 	)

				INSERT INTO #TBL_AttributeValue_Internal
				SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
				FROM  Cte_DefaultAttributeValue 
				
				If @IsPublish = 1 
				Begin
				
					DECLARE @Tlb_ReadMultiSelectValue TABLE ( AttributeDefaultValueCode NVARCHAR(300),PimAttributeId INT)
					INSERT INTO @Tlb_ReadMultiSelectValue ( AttributeDefaultValueCode ,PimAttributeId ) 
					SELECT zpav.AttributeDefaultValueCode,zpa.PimAttributeId 
					   FROM ZnodePimAttributeDefaultValue AS zpav 
					   RIGHT  OUTER JOIN dbo.ZnodePimAttribute AS zpa ON zpav.PimAttributeId = zpa.PimAttributeId
					   INNER JOIN dbo.ZnodeAttributeType AS zat ON zpa.AttributeTypeId = zat.AttributeTypeId
					   WHERE 
					   zat.AttributeTypeName IN ('Multi Select')
                    union All 
					 Select ZPA.AttributeCode,ZPA.PimAttributeId   from ZnodePimAttributeValidation ZPAV INNER JOIN ZnodeAttributeInputValidation ZAIV 
					ON ZPAV.InputValidationId = ZAIV.InputValidationId 
					INNER JOIN ZnodePimAttribute ZPA ON ZPAV.PimAttributeId = ZPA.PimAttributeId
					where ZAIV.Name  in ('IsAllowMultiUpload') and ltrim(rtrim(ZPAV.Name)) = 'true'
	
					SELECT PimProductId,AttributeValue,ZPA.AttributeCode,TBAV.PimAttributeId FROM #TBL_AttributeValue_Internal TBAV
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
					WHERE NOT Exists (Select TOP 1 1 FROM @Tlb_ReadMultiSelectValue where PimAttributeId = TBAV.PimAttributeId) 
					UNION ALL 
					Select PimProductId, SUBSTRING((Select ','+ CAST(ZPAXML.AttributeValue  AS VARCHAR(50)) from #TBL_AttributeValue_Internal ZPAXML where  
					ZPAXML.PimProductId = TBAV.PimProductId AND ZPAXML.PimAttributeId = TBAV.PimAttributeId FOR XML PATH('') ), 2, 4000) 
					AttributeValue, ZPA.AttributeCode,TBAV.PimAttributeId 
					FROM #TBL_AttributeValue_Internal TBAV
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
					WHERE Exists (Select TOP 1 1 FROM @Tlb_ReadMultiSelectValue where PimAttributeId = TBAV.PimAttributeId  ) 
					GROUP BY TBAV.PimProductId ,TBAV.PimAttributeId ,ZPA.AttributeCode
			
				End
				Else 
				Begin	
					SELECT PimProductId, AttributeValue,ZPA.AttributeCode,TBAV.PimAttributeId 
					FROM #TBL_AttributeValue_Internal TBAV
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
					WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@AttributeCode,',') SP WHERE (SP.Item = ZPA.AttributeCode  OR SP.Item = CAST(ZPA.PimATtributeId  AS VARCHAR(50)) )) 
				End

				if object_id('tempdb..#TBL_PimProductId') is not null
					drop table #TBL_PimProductId	

				if object_id('tempdb..#TBL_AttributeValue_Internal') is not null
					drop table #TBL_AttributeValue_Internal

		 END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			@ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductsAttributeValue 
			@AttributeCode='+@AttributeCode+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetProductsAttributeValue',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetMediaFolderDetails')
BEGIN 
	DROP PROCEDURE Znode_GetMediaFolderDetails
END
GO

CREATE PROCEDURE [dbo].[Znode_GetMediaFolderDetails]
( @WhereClause VARCHAR(1000),
  @MediaPathId INT,
  @Rows        INT           = 1000,
  @PageNo      INT           = 0,
  @Order_BY    VARCHAR(1000) = '',
  @RowsCount   INT OUT,
  @LocaleId    INT           = 1)
AS
/*
  Summary: This Procedure is Used to Get Details of Media Folder
  Unit Testing:
  begin tran
	DECLARE @RowsCount BIGINT  
	EXEC Znode_GetMediaFolderDetails @MediaPathId = -1 , @WhereClause='',@Rows=2147483647,@PageNo=1 ,@Order_By='', @RowsCount = @RowsCount OUT  
  rollback tran
  begin tran
	DECLARE @RowsCount BIGINT  
	EXEC Znode_GetMediaFolderDetails @MediaPathId = 1 , @WhereClause='' ,@Rows=10,@PageNo=1 ,@RowsCount =@RowsCount 
  rollback tran
*/
     BEGIN
         SET NOCOUNT ON;
		 BEGIN TRAN MediaFolderDetails
         BEGIN TRY

		 if object_id('tempdb..#View_GetMediaPathDetail') is not null
				drop table #View_GetMediaPathDetail

		if object_id('tempdb..##GetMediaPathHierarchy') is not null
			drop table ##GetMediaPathHierarchy

			 SELECT MediaCategoryId, MediaPathId, [Folder], [FileName], Size, Height, Width, Type, [MediaType], CreatedDate, ModifiedDate, MediaId, Path, MediaServerPath, 
					MediaThumbnailPath as MediaServerThumbnailPath, FamilyCode, CreatedBy, [DisplayName] [DisplayName], [Description] [ShortDescription],[PathName], Version
			 INTO #View_GetMediaPathDetail
			 FROM
			 (
				 SELECT Zmc.MediaCategoryId, ZMPL.MediaPathId, ZMPL.[PathName] [Folder], zM.[FileName], Zm.Size, Zm.Height, Zm.Width, Zm.Type, Zm.Type [MediaType], CONVERT( DATE, zm.CreatedDate) CreatedDate,
						CONVERT( DATE, zm.ModifiedDate) ModifiedDate, Zm.MediaId, zma.AttributeCode, Zmav.AttributeValue, ZMCF.URL+ZMSM.ThumbnailFolderName+'\'+zM.Path MediaThumbnailPath,
						ZMCF.URL+zM.Path  MediaServerPath, zM.Path,  zmafl.FamilyCode FamilyCode, Zm.CreatedBy, ZMPL.[PathName], Zm.Version 
				 FROM ZnodeMediaCategory ZMC
				 LEFT JOIN ZnodeMediaAttributeFamily zmafl ON(zmc.MediaAttributeFamilyId = zmafl.MediaAttributeFamilyId)
				 INNER JOIN ZnodeMediaPathLocale ZMPL ON(ZMC.MediaPathId = ZMPL.MediaPathId)
				 INNER JOIN ZnodeMedia zM ON(Zm.MediaId = Zmc.MediaId)
	  			 LEFT JOIN ZnodeMediaConfiguration ZMCF ON (ZMCF.MediaConfigurationId = ZM.MediaConfigurationId AND ZMCF.IsActive = 1)
				 LEFT JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMCF.MediaServerMasterId)
				 LEFT JOIN dbo.ZnodeMediaAttributeValue Zmav ON(zmav.MediaCategoryId = zmc.MediaCategoryId)
				 LEFT JOIN dbo.ZnodeMediaAttribute zma ON(zma.MediaAttributeId = Zmav.MediaAttributeId AND AttributeCode IN('DisplayName', 'Description'))      
			 ) v PIVOT
			 (
				MAX(AttributeValue) FOR AttributeCode IN([DisplayName], [Description])
			 ) PV;

             DECLARE @Rows_start VARCHAR(1000), @Rows_end VARCHAR(1000);
             SET @MediaPathId =  CASE WHEN @MediaPathId = -1 THEN 1 ELSE @MediaPathId END
			 
			 SET @Rows_start = CASE
                                   WHEN @Rows >= 1000000
                                   THEN 0
                                   ELSE(@Rows * (@PageNo - 1)) + 1
                               END;
             SET @Rows_end = CASE
                                 WHEN @Rows >= 1000000
                                 THEN @Rows
                                 ELSE @Rows * (@PageNo)
                             END;
             DECLARE @SQL NVARCHAR(MAX);
		

             SET @Order_BY = REPLACE(@Order_BY, 'MediaPathId', 'Convert(numeric,MediaPathId)');
             SET @Order_BY = REPLACE(@Order_BY, 'Size', 'Convert(numeric,Size)');
             SET @Order_BY = REPLACE(@Order_BY, 'MediaId', 'Convert(numeric,MediaId)');
             SET @Order_BY = REPLACE(@Order_BY, 'CreatedBy', 'Convert(numeric,CreatedBy)');
             SET @Order_BY = REPLACE(@Order_BY, 'MediaCategoryId', 'Convert(numeric,MediaCategoryId)');

			 SET @SQL = '
			 SELECT * INTO ##GetMediaPathHierarchy FROM DBO.FN_GetMediaPathHierarchy('+CAST( @MediaPathId  AS VARCHAR(1000))+')'

			 EXEC SP_executesql @SQL

             SET @SQL = ' DECLARE @V_MediaServerPath  VARCHAR(max) , @V_MediaServerThumbnailPath  VARCHAR(MAx)  


			 SELECT RANK()OVER(ORDER BY '+CASE
                                                 WHEN @Order_BY IS NULL
                                                      OR @Order_BY = ''
                                                 THEN ''
                                                 ELSE @Order_BY+' ,'
                                          END+'MediaId ) RowId, [MediaCategoryId],[MediaPathId],[Folder],[FileName],[Size],[Height],[Width],
			 [MediaType],[CreatedDate],[ModifiedDate],[MediaId],[Path],ISNULL(MediaServerPath,'''') AS MediaServerPath,
			  ISNULL(MediaServerThumbnailPath,'''') AS MediaServerThumbnailPath,[FamilyCode],[CreatedBy],[ShortDescription],[DisplayName], [Version] 
			 INTO #MediaPathDetail FROM '+CASE
                                                 WHEN @MediaPathId = -1
                                                 THEN ' View_GetAllMediaInRoot '
                                                 ELSE ' #View_GetMediaPathDetail ZMC '
                                          END+' WHERE 1=1 '+CASE
                                                                   WHEN @WhereClause = ''
                                                                        OR @WhereClause IS NULL
                                                                        OR @WhereClause = '-1' 
                                                                   THEN 'AND exists (select top 1 1 from ##GetMediaPathHierarchy Q 
			 where Q.MediaPathId = ZMC.MediaPathId )'
                                                                   ELSE CASE
                                                                            WHEN @MediaPathId = -1
                                                                            THEN ' AND '+@WhereClause
                                                                            ELSE ' AND exists (select top 1 1 from ##GetMediaPathHierarchy Q 
			 where Q.MediaPathId = ZMC.MediaPathId ) and  '+@WhereClause
                                                                        END
                                                               END+' Order BY '+CASE
                                                                                    WHEN @Order_BY IS NULL
                                                                                         OR @Order_BY = ''
                                                                                    THEN ' MediaCategoryId DESC'
                                                                                    ELSE @Order_BY
                                                                                END+' SELECT  @Count=ISNULL(Count(1),0) FROM  #MediaPathDetail  SELECT [MediaCategoryId],[MediaPathId],[Folder],[FileName],[Size],[Height],[Width],
			 [MediaType],[CreatedDate],[ModifiedDate],[MediaId],[Path],ISNULL(MediaServerPath,'''') AS MediaServerPath, ISNULL(MediaServerThumbnailPath,'''') AS MediaServerThumbnailPath,
			 [FamilyCode],[CreatedBy],[ShortDescription],[DisplayName],[Version] 
			 FROM #MediaPathDetail 
			 WHERE RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+' Order BY '+CASE
                                                                                   WHEN @Order_BY IS NULL
                                                                                        OR @Order_BY = ''
                                                                                   THEN ' MediaCategoryId DESC '
                                                                                   ELSE @Order_BY
                                                                              END;
           PRINT @SQL 
             EXEC SP_executesql
                  @SQL,
                  N'@Count INT OUT',
                  @Count = @RowsCount OUT;

			if object_id('tempdb..#View_GetMediaPathDetail') is not null
				drop table #View_GetMediaPathDetail

			if object_id('tempdb..##GetMediaPathHierarchy') is not null
				drop table ##GetMediaPathHierarchy
			
		 COMMIT TRAN MediaFolderDetails	 
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetMediaFolderDetails @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',@MediaPathId='+ISNULL(CAST(@WhereClause AS VARCHAR(100)),'''')+',@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  ROLLBACK TRAN MediaFolderDetails	 
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetMediaFolderDetails',
				@ErrorInProcedure = 'Znode_GetMediaFolderDetails',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;                                
         END CATCH;
     END;
GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>LogMessageId</name>      <headertext>Log Message Id</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>LogMessage</name>      <headertext>Log Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Component</name>      <headertext>Component</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>TraceLevel</name>      <headertext>Trace  Level</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StackTraceMessage</name>      <headertext>Stack Trace Message</headertext>      <width>80</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Button</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/LogMessage/GetDatabaseLogMessage</manageactionurl>      <manageparamfield>logMessageId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodeDatabaseLogMessage'

GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_UpdateAttributeValue')
BEGIN 
	DROP PROCEDURE Znode_UpdateAttributeValue
END
GO

CREATE PROCEDURE [dbo].[Znode_UpdateAttributeValue](@ProductId        VARCHAR(2000),      
                                                   @PimAttributeCode NVARCHAR(300),      
                                                   @LocaleId         INT,      
                                                   @AttributeValue   NVARCHAR(MAX),      
                                                   @UserId           INT,      
                                                   @Status           BIT OUT,      
                                                   @IsUnAssociated   BIT           = 0,      
                                                   @IsDebug          BIT           = 0)      
AS       
         
/* ---------------------------------------------------------------------------------------------------------------      
    --Summary : Update AttributeValue for specific product       
    --          Input parameter : @LocaleId , @PimAttributeCode,  @ProductId,@AttributeValue,@UserId      
    --Unit Testing :       
    BEGIN TRANSACTION       
    DECLARE @Status bit       
    EXEC [Znode_UpdateAttributeValue]      
    @ProductId        = 10637,      
    @PimAttributeCode = 'Brand' ,      
    @LocaleId         =1 ,      
    @AttributeValue   = 'Tropicana',      
    @UserId           =2,      
    @Status           =@Status OUT      
    SELECT @Status       
    --SELECT zpa.AttributeCode ,ZpAVL .AttributeValue  FROM ZnodePimAttributeValueLocale ZpAVL INNER JOIN ZnodePimAttributeValue zpav ON ZpAVL.PimAttributeValueId = zpav.PimAttributeValueId      
    --INNER JOIN dbo.ZnodePimAttribute zpa ON zpav.PimAttributeId = zpa.PimAttributeId      
    --WHERE zpav.PimProductId =12 AND ZpAVL.LocaleId = 1 AND zpa.AttributeCode = 'ProductName'       
    --ROLLBACK Transaction       
    ---------------------------------------------------------------------------------------------------------------      
*/      
      
     BEGIN    

		BEGIN TRAN UpdateAttributeValue;      
			BEGIN TRY      
				DECLARE @GetDate DATETIME= dbo.Fn_GetDate();      
				DECLARE @PimDefaultFamily INT= dbo.Fn_GetDefaultPimProductFamilyId();      
				DECLARE @TBL_PimProductId TABLE      
				(PimProductId               INT,      
				PimAttributeId             INT,      
				AttributeCode              VARCHAR(300),      
				AttributeValue             NVARCHAR(MAX),      
				PimAttributeDefaultValueId INT ,
				Attributetype VARCHAR(50)     
				); -- table holds the PimProductId   
				    
				DECLARE @TBL_DefaultAttributeId TABLE (PimAttributeId INT PRIMARY KEY , AttributeCode VARCHAR(600))      
      
				INSERT INTO @TBL_DefaultAttributeId (PimAttributeId,AttributeCode)      
				SELECT PimAttributeId,AttributeCode FROM  [dbo].[Fn_GetDefaultAttributeId] ()      
      
				DECLARE @TBL_PimAttributeValueId TABLE      
				(PimAttributeValueId INT,      
				PimAttributeId      INT,      
				PimProductId        INT,      
				PimAttributeDefaultValueId int       
				);      
	  
  
				INSERT INTO @TBL_PimProductId      
				(PimProductId,      
				PimAttributeId,      
				AttributeCode,      
				AttributeValue,      
				PimAttributeDefaultValueId      
				)      
				SELECT item,      
					ZPA.PimAttributeId,      
					@PimAttributeCode,      
					@AttributeValue,      
					ZPADV.PimAttributeDefaultValueId      
				FROM dbo.Split(@ProductId, ',') SP      
					LEFT JOIN ZnodePimAttribute ZPA ON(ZPA.AttributeCode = @PimAttributeCode)      
					LEFT JOIN ZnodePimAttributeDefaultValue ZPADV ON (ZPA.PimAttributeId = ZPADV.PimAttributeId AND ( ZPADV.AttributeDefaultValueCode = @AttributeValue OR ISNULL(@AttributeValue, '') = ''  ))      
					--WHERE NOT EXISTS (SELECT * FROM @TBL_PimProductId_Simple WHERE PimProductId = SP.item AND PimAttributeId = ZPA.pimattributeid)-- AND AttributeCode = @AttributeValue AND AttributeValue = @AttributeValue AND PimAttributeDefaultValueId= ZPADV.PimAttributeDefaultValueId)


					Update TBL 
					SET Attributetype = 'Simple Select'
					FROM @TBL_PimProductId TBL
					WHERE EXISTS (SELECT * FROM ZnodePimAttribute WHERE AttributeCode = @PimAttributeCode AND AttributeTypeId = (SELECT Top 1 AttributeTypeId from ZnodeAttributeType where AttributeTypeName = 'Simple Select'))
					--INNER JOIN ZnodePimAttribute ZPA ON(ZPA.AttributeCode = @PimAttributeCode and ZPA.AttributeTypeId = (SELECT AttributeTypeId from ZnodeAttributeType where AttributeTypeName = 'Simple Select'))      


		  
      
				IF @IsUnAssociated = 1      
				BEGIN      
				INSERT INTO @TBL_PimAttributeValueId      
				(PimAttributeValueId,      
				PimAttributeId,      
				PimProductId,      
				PimAttributeDefaultValueId     
				)      
					SELECT ZPAV.PimAttributeValueId,      
							ZPAV.PimAttributeId,      
							ZPAV.PimProductId,      
							ZPADV.PimAttributeDefaultValueId      
					FROM ZnodePimAttributeValue ZPAV      
							INNER JOIN @TBL_PimProductId TBLP ON(TBLP.PimProductId = ZPAV.PimProductId AND TBLP.PimAttributeId = ZPAV.PimAttributeId AND TBLP.AttributeValue = @AttributeValue)
							INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId)
							INNER JOIN ZnodePimAttributeDefaultValue ZADV ON (ZPADV.PimAttributeDefaultValueId = ZADV.PimAttributeDefaultValueId AND ZADV.AttributeDefaultValueCode =@AttributeValue )

      
				DELETE FROM ZnodePimProductAttributeDefaultValue 
				WHERE EXISTS      
				(      
					SELECT TOP 1 1      
					FROM @TBL_PimAttributeValueId TBLAP      
					WHERE TBLAP.PimAttributeValueId = ZnodePimProductAttributeDefaultValue.PimAttributeValueId      
					AND ZnodePimProductAttributeDefaultValue.PimAttributeDefaultValueId = TBLAP.PimAttributeDefaultValueId --@PimAttributeDefaultValueId      
				)      
				AND LocaleId = @LocaleId
					

				DELETE FROM ZnodePimAttributeValue    
				WHERE EXISTS      
				(      
					SELECT TOP 1 1      
					FROM @TBL_PimAttributeValueId TBLAP      
					WHERE TBLAP.PimAttributeValueId = ZnodePimAttributeValue.PimAttributeValueId      
						AND ZnodePimAttributeValue.PimAttributeDefaultValueId =TBLAP.PimAttributeDefaultValueId -- @PimAttributeDefaultValueId      
				)
				AND not exists (select * from   ZnodePimProductAttributeDefaultValue where PimAttributeValueId =ZnodePimAttributeValue.PimAttributeValueId )--AND PimAttributeDefaultValueId <>TBLAP.PimAttributeDefaultValueId ) 
				--AND LocaleId = @LocaleId     

				END;   

				---- here needs to handle which records will be updated and which records will be inserted 	

				--INSERT INTO @TBL_PimProductId 
				--(PimProductId,      
				--PimAttributeId,      
				--AttributeCode,      
				--AttributeValue,      
				--PimAttributeDefaultValueId      
				--)     
				--SELECT 	TBL.PimProductId,      
				--TBL.PimAttributeId,      
				--AttributeCode,      
				--TBL.AttributeValue,      
				--TBL.PimAttributeDefaultValueId 
				--FROM @TBL_PimProductId_Simple TBL 
				--INNER JOIN 	Znodepimattributevalue ZPA ON (ZPA.PimProductId = TBL.PimProductId AND ZPA.PimAttributeId = TBL.PimAttributeId)	 
			 

				UPDATE ZnodePimAttributeValue       
				SET  ModifiedBy = @UserId      
				, ModifiedDate = @GetDate      
				,PimAttributeDefaultValueId = ZAV.PimAttributeDefaultValueId      
				OUTPUT INSERTED.PimAttributeValueId,      
				INSERTED.PimAttributeId,      
				INSERTED.PimProductId,      
				INSERTED.PimAttributeDefaultValueId      
				INTO @TBL_PimAttributeValueId      
				FROM ZnodePimAttributeValue        
				INNER JOIN @TBL_PimProductId ZAV ON ( ZAV.PimProductId = ZnodePimAttributeValue.PimProductId      
						AND ZAV.PimAttributeId = ZnodePimAttributeValue.PimAttributeId)      
				WHERE @IsUnAssociated = 0  


				--INSERT INTO @TBL_PimProductId 
				--(PimProductId,      
				--PimAttributeId,      
				--AttributeCode,      
				--AttributeValue,      
				--PimAttributeDefaultValueId      
				--)     
				--SELECT 	PimProductId,      
				--PimAttributeId,      
				--AttributeCode,      
				--AttributeValue,      
				--PimAttributeDefaultValueId 
				--FROM @TBL_PimProductId_Simple TBL 
				--WHERE NOT EXISTS (SELECT * FROM Znodepimattributevalue WHERE PimAttributeId = TBL.pimattributeid AND PimProductId = TBL.PimProductId)
     
				INSERT INTO ZnodePimAttributeValue      
				(PimProductId,      
				PimAttributeId,      
				PimAttributeDefaultValueId,      
				AttributeValue,      
				CreatedBy,      
				CreatedDate,      
				ModifiedBy,      
				ModifiedDate,      
				PimAttributeFamilyId      
				)      
				OUTPUT INSERTED.PimAttributeValueId,      
				INSERTED.PimAttributeId,      
				INSERTED.PimProductId,      
				INSERTED.PimAttributeDefaultValueId      
				INTO @TBL_PimAttributeValueId      
				SELECT TBPP.PimProductId,      
					TBPP.PimAttributeId,      
					TBPP.PimAttributeDefaultValueId,      
					TBPP.AttributeValue,      
					@UserId,      
					@GetDate,      
					@UserId,      
					@GetDate,      
					@PimDefaultFamily      
				FROM @TBL_PimProductId TBPP      
				WHERE NOT EXISTS      
				(      
				SELECT TOP 1 1      
				FROM ZnodePimAttributeValue ZAV      
				WHERE ZAV.PimProductId = TBPP.PimProductId      
						AND ZAV.PimAttributeId = TBPP.PimAttributeId      
				)      
				AND @IsUnAssociated = 0;      
                   
				UPDATE A      
				SET      
				AttributeValue = C.AttributeValue      
				FROM ZnodePimAttributeValueLocale A      
				INNER JOIN ZnodePimAttributeValue B ON(B.PimAttributeValueId = A.PimAttributeValueId)      
				INNER JOIN @TBL_PimProductId C ON(B.PimAttributeId = C.PimAttributeId      
											AND B.PimProductId = C.PimProductId)      
				WHERE LocaleId = @LocaleId;  

 
				Declare @Pimattriutedefaultvalueid INT = 0
						 
				SELECT @Pimattriutedefaultvalueid =  A.PimAttributeDefaultValueId from ZnodePimAttributeDefaultValue A 
				INNER JOIN ZnodePimAttributeDefaultValueLocale B On (A.PimAttributeDefaultValueId = B.PimAttributeDefaultValueId AND A.PimAttributeId = (SELECT TOP 1 PimAttributeId from ZnodePimAttribute WHERE AttributeCode = @PimAttributeCode))
				WHERE A.AttributeDefaultValueCode = @AttributeValue AND B.LocaleId  = @LocaleId	


				-- UP ZnodePimProductAttributeDefaultValue 
				IF @Pimattriutedefaultvalueid <>0
				Update ZPDA
				SET ZPDA.ModifiedBy = @UserId,
				ZPDA.Modifieddate = @getdate,
				ZPDA.pimattributedefaultvalueid = ZPA.pimattributedefaultvalueid
				FROM @TBL_PimProductId TBL
				INNER JOIN @TBL_PimAttributeValueId ZPA ON (TBL.pimattributeid = ZPA.pimattributeid AND TBL.pimproductid = ZPA.PimProductId)
				INNER JOIN ZnodePimProductAttributeDefaultValue ZPDA ON (ZPDA.PimAttributeValueId = ZPA.pimattributevalueid)
				WHERE TBL.Attributetype = 'Simple Select'
				

				DELETE TBL
				FROM @TBL_PimAttributeValueId TBL
				INNER JOIN @TBL_PimProductId TBLP On (TBL.PimAttributeId = TBLP.PimAttributeId AND TBL.PimProductId = TBLP.pimproductid AND TBL.pimattributevalueid = TBLP.pimattributedefaultvalueid)
				WHERE TBLP.Attributetype = 'Simple Select'
				AND (EXISTS (SELECT * FROM ZnodePimProductAttributeDefaultValue WHERE PimAttributeValueId = TBL.pimattributevalueid )
				OR  EXISTS (SELECt * FROM ZnodePimAttributeValueLocale WHERE PimAttributeValueId = TBL.pimattributevalueid))
		   
				INSERT INTO ZnodePimProductAttributeDefaultValue      
				(PimAttributeValueId,      
				LocaleId,      
				PimAttributeDefaultValueId,      
				CreatedBy,      
				CreatedDate,      
				ModifiedBy,      
				ModifiedDate      
				)      
				SELECT DISTINCT TBPAV.PimAttributeValueId,      
					@LocaleId,      
					TBPAV.PimAttributeDefaultValueId,      
					@UserId,      
					@GetDate,      
					@UserId,      
					@GetDate      
				FROM @TBL_PimProductId TBPP      
					INNER JOIN @TBL_PimAttributeValueId TBPAV ON(TBPAV.PimProductId = TBPP.PimProductId      
																AND TBPAV.PimAttributeId = TBPP.PimAttributeId)      
																AND @IsUnAssociated = 0      
				AND EXISTS (SELECT TOP 1 1 FROM @TBL_DefaultAttributeId TBL WHERE TBL.PimAttributeId = TBPP.PimAttributeId)
				AND NOT EXISTS (SELECT * FROM ZnodePimProductAttributeDefaultValue WHERE PimAttributeValueId =TBPAV.PimAttributeValueId AND PimAttributeDefaultValueId = TBPP.PimAttributeDefaultValueId )
				  
				UPDATE ZPAVL      
				SET AttributeValue =@AttributeValue      
				FROM ZnodePimAttributeValueLocale ZPAVL       
				INNER JOIN @TBL_PimAttributeValueId TBPAV ON( TBPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId )      
																AND @IsUnAssociated = 0  
   
      
				INSERT INTO ZnodePimAttributeValueLocale      
				(PimAttributeValueId,      
				LocaleId,      
				AttributeValue,      
				CreatedBy,      
				CreatedDate,      
				ModifiedBy,      
				ModifiedDate      
				)      
				SELECT TBPAV.PimAttributeValueId,      
					@LocaleId,      
					TBPP.AttributeValue,      
					@UserId,      
					@GetDate,      
					@UserId,      
					@GetDate      
				FROM @TBL_PimProductId TBPP      
					INNER JOIN @TBL_PimAttributeValueId TBPAV ON(TBPAV.PimProductId = TBPP.PimProductId      
																AND TBPAV.PimAttributeId = TBPP.PimAttributeId)      
																WHERE @IsUnAssociated = 0      
				AND NOT EXISTS (SELECT TOP 1 1 FROM @TBL_DefaultAttributeId TBL WHERE TBL.PimAttributeId = TBPP.PimAttributeId)      
				AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeValueLocale TBH WHERE TBH.PimAttributeValueId = TBPAV.PimAttributeValueId);      
				  
				  
				SET @Status = 1;      
				SELECT 1 AS ID,      
				CAST(1 AS BIT) AS [Status];      
      
			COMMIT TRAN UpdateAttributeValue;      
		END TRY      
		BEGIN CATCH      
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),       
		@ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_UpdateAttributeValue @ProductId = '+      
		@ProductId+',@PimAttributeCode='+@PimAttributeCode+',@Status='+CAST(@Status AS VARCHAR(50))+      
		',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@AttributeValue='+CAST(@AttributeValue AS NVARCHAR(MAX))+',@UserId='+CAST(@UserId AS NVARCHAR(50));      
		SET @Status = 0;      
		SELECT 1 AS ID,      
		CAST(0 AS BIT) AS [Status],      
		@ErrorMessage;      
		ROLLBACK TRAN UpdateAttributeValue;      
		EXEC Znode_InsertProcedureErrorLog      
		@ProcedureName = 'Znode_UpdateAttributeValue',      
		@ErrorInProcedure = @Error_procedure,      
		@ErrorMessage = @ErrorMessage,      
		@ErrorLine = @ErrorLine,      
		@ErrorCall = @ErrorCall;      
		END CATCH;      
     END

	 GO
	 

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPublishSingleProduct')
BEGIN 
	DROP PROCEDURE Znode_GetPublishSingleProduct
END
GO
CREATE PROCEDURE [dbo].[Znode_GetPublishSingleProduct]
(
@PublishCatalogId INT = 0 
,@VersionId       VARCHAR(50) = 0 
,@PimProductId    TransferId Readonly 
,@UserId		  INT = 0 
,@TokenId nvarchar(max)= ''	
,@LocaleIds TransferId READONLY
,@PublishStateId INT = 0  
)
AS


--Declare @PimProductId TransferId 
--insert into @PimProductId  select 128 
-- EXEC [Znode_GetPublishSingleProduct]  @PublishCatalogId = 0 ,@VersionId= 0 ,@PimProductId =@PimProductId, @UserId=2 

BEGIN 
  
 SET NOCOUNT ON 

EXEC Znode_InsertUpdatePimAttributeXML 1 
EXEC Znode_InsertUpdateCustomeFieldXML 1
EXEC Znode_InsertUpdateAttributeDefaultValue 1 

 IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
 DROP TABLE #Cte_BrandData
 END 

DECLARE @PimProductAttributeXML TABLE(PimAttributeXMLId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
DECLARE @PimDefaultValueLocale  TABLE (PimAttributeDefaultXMLId INT  PRIMARY KEY ,PimAttributeDefaultValueId INT ,LocaleId INT ) 
DECLARE @ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
		,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
DECLARE @GetDate DATETIME =dbo.Fn_GetDate()
DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )

			INSERT INTO @TBL_LocaleId (LocaleId)
			SELECT  LocaleId
			FROM ZnodeLocale MT
			WHERE IsActive = 1
			AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
			OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) 


DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 

 DECLARE @TBL_PublishCatalogId TABLE(PublishCatalogId INT,PublishProductId INT,PimProductId  INT   , VersionId INT ,LocaleId INT  )

			 INSERT INTO @TBL_PublishCatalogId 
			 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId, MAX(PublishCatalogLogId) ,LocaleId
			 FROM ZnodePublishProduct ZPP 
			 INNER JOIN ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
			 WHERE (EXISTS (SELECT TOP 1 1 FROM @PimProductId SP WHERE SP.Id = ZPP.PimProductId  AND  (@PublishCatalogId IS NULL OR @PublishCatalogId = 0 ))
			 OR  (ZPP.PublishCatalogId = @PublishCatalogId ))
			 AND IsCatalogPublished =1
			 AND ZPCP.PublishStateId = @PublishStateId 
			 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,LocaleId
		
             DECLARE   @TBL_ZnodeTempPublish TABLE (PimProductId INT , AttributeCode VARCHAR(300) ,AttributeValue NVARCHAR(max) ) 			
			 DECLARE @TBL_AttributeVAlueLocale TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT,LocaleId INT ,AttributeValue Nvarchar(1000) )

			 INSERT INTO @TBL_AttributeVAlueLocale (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId ,LocaleId ,AttributeValue )
			 SELECT VIR.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId,VIR.LocaleId, ''
			 FROM View_LoadManageProductInternal VIR
			 INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = VIR.PimProductId)
			 UNION ALL 
			 SELECT VIR.PimProductId,PimAttributeId,PimProductAttributeMediaId,ZPDE.LocaleId , ''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimProductAttributeMedia ZPDE ON (ZPDE.PimAttributeValueId = VIR.PimAttributeValueId )
			 WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,ZPDVL.PimAttributeDefaultValueLocaleId,ZPDVL.LocaleId ,ZPDVL.AttributeDefaultValue
			   FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON ZPADV.PimAttributeId = D.PimAttributeId
			 INNER JOIN ZnodePimAttributeDefaultValueLocale ZPDVL   on (ZPADV.PimAttributeDefaultValueId = ZPDVL.PimAttributeDefaultValueId)
			 --INNER JOIN ZnodePimProductAttributeDefaultValue ZPDVP ON (ZPDVP.PimAttributeValueId = VIR.PimAttributeValueId AND ZPADV.PimAttributeDefaultValueId = ZPDVP.PimAttributeDefaultValueId )
			 WHERE ( ZPDVL.LocaleId = @DefaultLocaleId OR ZPDVL.LocaleId = @LocaleId )
			 AND EXISTS(SELECT TOP 1 1 FROM @TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,'','' ,''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 WHERE  EXISTS(SELECT TOP 1 1 FROM @TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )



	

WHILE @Counter <= @maxCountId
BEGIN
 SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId WHERE RowId = @Counter)
 
  INSERT INTO @PimProductAttributeXML 
  SELECT PimAttributeXMLId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeXML
  WHERE LocaleId = @LocaleId

  INSERT INTO @PimProductAttributeXML 
  SELECT PimAttributeXMLId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeXML ZPAX
  WHERE ZPAX.LocaleId = @DefaultLocaleId  
  AND NOT EXISTS (SELECT TOP 1 1 FROM @PimProductAttributeXML ZPAXI WHERE ZPAXI.PimAttributeId = ZPAX.PimAttributeId )

  INSERT INTO @PimDefaultValueLocale
  SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultXML
  WHERE localeId = @LocaleId

  INSERT INTO @PimDefaultValueLocale 
   SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultXML ZX
  WHERE localeId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM @PimDefaultValueLocale TRTR WHERE TRTR.PimAttributeDefaultValueId = ZX.PimAttributeDefaultValueId)
  
 
  DECLARE @TBL_AttributeVAlue TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )
  DECLARE @TBL_CustomeFiled TABLE (PimCustomeFieldXMLId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )

  INSERT INTO @TBL_CustomeFiled (PimCustomeFieldXMLId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldXMLId,RTR.PimProductId ,RTR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldXML RTR 
  INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = RTR.PimProductId)
  WHERE RTR.LocaleId = @LocaleId
 

  INSERT INTO @TBL_CustomeFiled (PimCustomeFieldXMLId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldXMLId,ITR.PimProductId ,ITR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldXML ITR
  INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ITR.PimProductId)
  WHERE ITR.LocaleId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM @TBL_CustomeFiled TBL  WHERE ITR.CustomCode = TBL.CustomCode AND ITR.PimProductId = TBL.PimProductId)
  

    INSERT INTO @TBL_AttributeVAlue (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
    SELECT PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
	FROM @TBL_AttributeVAlueLocale
    WHERE LocaleId = @LocaleId

    
	INSERT INTO @TBL_AttributeVAlue(PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
	SELECT VI.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
	FROM @TBL_AttributeVAlueLocale VI 
    WHERE VI.LocaleId = @DefaultLocaleId 
	AND NOT EXISTS (SELECT TOP 1 1 FROM @TBL_AttributeVAlue  CTE WHERE CTE.PimProductId = VI.PimProductId AND CTE.PimAttributeId = VI.PimAttributeId )
 
INSERT INTO @TBL_ZnodeTempPublish  
SELECT  a.PimProductId,a.AttributeCode , '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(a.AttributeValue,'')+'</AttributeValues> </AttributeEntity>  </Attributes>'  AttributeValue
FROM View_LoadManageProductInternal a 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = a.PimAttributeId )
INNER JOIN @PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN @TBL_AttributeValue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = a.ZnodePimAttributeValueLocaleId)
UNION ALL 
SELECT  a.PimProductId,c.AttributeCode , '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+TAVL.AttributeValue+'</AttributeValues> </AttributeEntity>  </Attributes>'  AttributeValue
FROM ZnodePimAttributeValue  a 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = a.PimAttributeId )
INNER JOIN @PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN ZnodePImAttribute ZPA  ON (ZPA.PimAttributeId = a.PimAttributeId)
INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = a.PimProductId)
Inner JOIN @TBL_AttributeVAlueLocale TAVL ON  (c.PimAttributeId = TAVL.PimAttributeId  and ZPP.PimProductId = TAVL.PimProductId )
WHERE ZPA.IsPersonalizable = 1 
AND NOT EXISTS ( SELECT TOP 1 1 FROM ZnodePimAttributeValueLocale q WHERE q.PimAttributeValueId = a.PimAttributeValueId) 



UNION ALL 
SELECT THB.PimProductId,THB.CustomCode,'<Attributes><AttributeEntity>'+CustomeFiledXML +'</AttributeEntity></Attributes>' 
FROM ZnodePimCustomeFieldXML THB 
INNER JOIN @TBL_CustomeFiled TRTE ON (TRTE.PimCustomeFieldXMLId = THB.PimCustomeFieldXMLId)
UNION ALL 
SELECT ZPAV.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues></AttributeValues>'+'<SelectValues>'+
			   STUFF((
                    SELECT '  '+ DefaultValueXML  FROM ZnodePimAttributeDefaultXML AA 
				 INNER JOIN @PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = AA.PimAttributeDefaultXMLId)
				 INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
				 WHERE (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId)
    FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues> </AttributeEntity></Attributes>' AttributeValue
 
FROM ZnodePimAttributeValue ZPAV  With (NoLock)
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN @PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
UNION ALL 
SELECT DISTINCT  ZPAV.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+SUBSTRING((SELECT DISTINCT ',' +MediaPath 
	FROM ZnodePimProductAttributeMedia ZPPG
	INNER JOIN  @TBL_AttributeVAlue TBLV ON (TBLV.PimProductId=  ZPAV.PimProductId AND TBLV.PimAttributeId = ZPAV.PimAttributeId )
    WHERE ZPPG.PimProductAttributeMediaId = TBLV.ZnodePimAttributeValueLocaleId
	FOR XML PATH ('')
 ),2,4000)+'</AttributeValues></AttributeEntity></Attributes>' AttributeValue
 	 
FROM ZnodePimAttributeValue ZPAV 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN @PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeMedia ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
UNION ALL 
SELECT ZPLP.PimParentProductId ,c.AttributeCode, '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50)) 
							 FROM ZnodePublishProduct ZPPI 
							 INNER JOIN ZnodePimLinkProductDetail ZPLPI ON (ZPLPI.PimProductId = ZPPI.PimProductId)
							 WHERE ZPLPI.PimParentProductId = ZPLP.PimParentProductId
							 AND ZPLPI.PimAttributeId   = ZPLP.PimAttributeId
							 AND ZPPI.PublishCatalogId = ZPP.PublishCatalogId
							 FOR XML PATH ('') ),2,4000),'')+'</AttributeValues></AttributeEntity></Attributes>'   AttributeValue 
							
FROM ZnodePimLinkProductDetail ZPLP 
INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPLP.PimParentProductId)
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPLP.PimAttributeId )
INNER JOIN @PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
GROUP BY ZPLP.PimParentProductId , ZPP.PublishProductId  ,ZPLP.PimAttributeId,c.AttributeCode,c.AttributeXML,ZPP.PublishCatalogId

UNION ALL 
SELECT ZPAV.PimProductId,'DefaultSkuForConfigurable' ,'<Attributes><AttributeEntity>'+REPLACE(REPLACE (c.AttributeXML,'ProductType','DefaultSkuForConfigurable'),'Product Type','Default Sku For Configurable')+'<AttributeValues>'+
 (SELECT TOP 1 AttributeValue FROM View_LoadManageProductInternal ad 
 INNER JOIN ZnodePimProductTypeAssociation yt ON (yt.PimProductId = ad.PimProductId)
 WHERE Ad.AttributeCode = 'SKU'
 AND yt.PimParentProductId = ZPAV.PimProductId
ORDER BY yt.DisplayOrder , yt.PimProductTypeAssociationId ASC)
+'</AttributeValues></AttributeEntity></Attributes>' AttributeValue 
FROM ZnodePimAttributeValue ZPAV  
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN @TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
INNER JOIN ZnodePimAttributeDefaultValue dr ON (dr.PimAttributeDefaultValueId = ZPADVL.PimAttributeDefaultValueId)
 WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId
 AND dr.AttributeDefaultValueCode= 'ConfigurableProduct' 
)
AND EXISTS (select * from @PimProductAttributeXML b where b.PimAttributeXMLId = c.PimAttributeXMLId)
AND c.AttributeCode = 'ProductType' 

---------brand details 
CREATE TABLE #Cte_BrandData (PimProductId int,BrandXML nvarchar(max))

INSERT INTO #Cte_BrandData ( PimProductId, BrandXML )
SELECT  DISTINCT ZBP.PimProductId,'<Brands><BrandEntity><BrandId>'+CAST(ZBD.BrandId AS VARCHAR(50))+'</BrandId><BrandCode>'+ZBD.BrandCode+'</BrandCode><BrandName>'+ZBDL.BrandName+'</BrandName></BrandEntity></Brands>' as BrandXML					   		   
FROM [ZnodeBrandDetails] AS ZBD
INNER JOIN ZnodeBrandDetaillocale ZBDL ON ZBD.BrandId = ZBDL.BrandId
INNER JOIN [ZnodeBrandProduct] AS ZBP ON ZBD.BrandId = ZBP.BrandId

 DELETE FROM ZnodePublishedXML WHERE  IsProductXML = 1  AND LocaleId = @localeId 
								AND  EXISTS ( SELECT TOP 1 1 FROM  @TBL_PublishCatalogId  TBL WHERE TBL.VersionId  = ZnodePublishedXML.PublishCatalogLogId AND TBL.PublishProductId = ZnodePublishedXML.PublishedId)


;WITH CTE AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY PimProductId	,AttributeCode
ORDER BY PimProductId	,AttributeCode) AS RN
FROM @TBL_ZnodeTempPublish
)

DELETE FROM CTE WHERE RN<>1


 

  
 MERGE INTO ZnodePublishedXML TARGET 
 USING (
 SELECT zpp.PublishProductId,zpp.VersionId ,'<ProductEntity><VersionId>'+CAST(zpp.VersionId AS VARCHAR(50)) +'</VersionId><ZnodeProductId>'+CAST(zpp.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><ZnodeCategoryIds>'+CAST(ISNULL(ZPC.PublishCategoryId,'')  AS VARCHAR(50))+'</ZnodeCategoryIds><Name>'+CAST(ISNULL((SELECT ''+ZPPDFG.ProductName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</Name>'+'<SKU>'+CAST(ISNULL((SELECT ''+ZPPDFG.SKU FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKU><SKULower>'+CAST(ISNULL((SELECT ''+Lower(ZPPDFG.SKU) FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKULower>'+'<IsActive>'+CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50))+'</IsActive>' 
+'<ZnodeCatalogId>'+CAST(ZPP.PublishCatalogId  AS VARCHAR(50))+'</ZnodeCatalogId><IsParentProducts>'+CASE WHEN ZPCD.PublishCategoryId IS NULL THEN '0' ELSE '1' END  +'</IsParentProducts><CategoryName>'+CAST(ISNULL((SELECT ''+PublishCategoryName FOR XML PATH ('')),'') AS NVARCHAR(2000)) +'</CategoryName><CatalogName>'+CAST(ISNULL((SELECT ''+CatalogName FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</CatalogName><LocaleId>'+CAST( @LocaleId AS VARCHAR(50))+'</LocaleId>'
+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
					FROM ZnodeProfileCatalog ZPFC 
					INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
					WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+'</TempProfileIds><ProductIndex>'+CAST(ISNULL(ZPCP.ProductIndex,1)  AS VARCHAr(100))+'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+
ISNULL(STUFF(( SELECT '  '+ BrandXML  FROM #Cte_BrandData BD WHERE BD.PimProductId = ZPP.PimProductId   
				FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, ''),'')+
STUFF(( SELECT '  '+ AttributeValue  FROM @TBL_ZnodeTempPublish TY WHERE TY.PimProductId = ZPP.PimProductId   
    FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</ProductEntity>' xmlvalue
FROM  @TBL_PublishCatalogId zpp
INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)
LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
LEFT JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId)
LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId)
LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ZPCP.PublishCategoryId AND ZPCD.LocaleId = @LocaleId )
WHERE ZPPDFG.LocaleId = @LocaleId
AND zpp.LocaleId = @LocaleId
) SOURCE 
ON (
     TARGET.PublishCatalogLogId = SOURCE.versionId 
	 AND TARGET.PublishedId = SOURCE.PublishProductId
	 AND TARGET.IsProductXML = 1 
	 AND TARGET.LocaleId = @localeId 
)
WHEN MATCHED THEN 
UPDATE 
SET  PublishedXML = xmlvalue
   , ModifiedBy = @userId 
   ,ModifiedDate = @GetDate
   ,ImportedGuId = @TokenId 
WHEN NOT MATCHED THEN 
INSERT (PublishCatalogLogId
,PublishedId
,PublishedXML
,IsProductXML
,LocaleId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate,ImportedGuId)

VALUES (SOURCE.versionid , Source.publishProductid,Source.xmlvalue,1,@localeid,@userId,@getDate,@userId,@getDate,@TokenId);

DELETE FROM @TBL_ZnodeTempPublish

DELETE FROM @PimProductAttributeXML
DELETE FROM @TBL_CustomeFiled
DELETE FROM @PimDefaultValueLocale
DELETE FROM @TBL_AttributeValue 

 IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
 DROP TABLE #Cte_BrandData
 END 

SET @Counter = @counter + 1 
END

END
GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PromotionId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PromoCode</name>      <headertext>Promotion Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Name</name>      <headertext>Promotion Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Discount</name>      <headertext>Discount</headertext>      <width>40</width>      <datatype>Decimal</datatype>      <columntype>Decimal</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PromotionTypeName</name>      <headertext>Discount Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>QuantityMinimum</name>      <headertext>Minimum Quantity</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>OrderMinimum</name>      <headertext>Minimum Order</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>StartDate</name>      <headertext>Start Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>EndDate</name>      <headertext>End Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete|View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>shippingId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete|View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Promotion/Edit|/Promotion/Delete</manageactionurl>      <manageparamfield>promotionId|promotionId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodePromotion'

GO

UPDATE ZnodeEmailTemplateLocale 
SET Content = '<!DOCTYPE html><html><body><p>&nbsp;</p>  <table style="display: table; border: 1px solid #af0604;" border="0" width="75%" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">  <tbody><!--Header-->  <tr>  <td align="left" valign="top" width="100%">  <table border="0" width="100%" cellspacing="0" cellpadding="0" align="center" bgcolor="#FFFFFF">  <tbody>  <tr style="border-bottom: 0;" bgcolor="#ffffff">  <td align="left" valign="top">  <table border="0" width="100%" cellspacing="0" cellpadding="0">  <tbody>  <tr style="background-color: #ffffff;">  <td style="padding-left: 10px; padding-top: 15px;" align="left" valign="top" width="300"><img class="CToWUd" style="display: block;" src="#StoreLogo#" width="200" height="70" border="0" /></td>  <td style="padding: 15px 10px 10px 0;" align="right" valign="top" width="350">  <p style="font-size: 17px; font-family: Arial,Helvetica; color: #af0604; font-weight: 800; padding: 10px 0 10px 0; margin: 0;">#CustomerServicePhoneNumber#</p>  <p style="font-size: 17px; font-family: Arial,Helvetica; font-weight: 800; padding: 5px 0; margin: 0;"><a style="color: #af0604; text-decoration: none; padding-bottom: 10px;" href="mailto:#CustomerServiceEmail#" target="_blank">#CustomerServiceEmail#</a></p>  </td>  </tr>  <tr style="background-color: #af0604;">  <td align="left" valign="top" width="350" height="5">&nbsp;</td>  <td align="right" valign="bottom" width="300" height="5">&nbsp;</td>  </tr>  </tbody>  </table>  </td>  </tr>  </tbody>  </table>  </td>  </tr>  <tr>  <td id="#ComparedProducts#" style="float: left; width: 25%;"><!--Product-Container-->  <div style="float: left; width: 100%; min-height: 300px; font-size: 12px; padding: 10px 5px;">  <div>#Image#</div>  <div style="padding: 5px; width: 100%;">  <div style="color: #af0604; font-weight: bold;">Product Name</div>  <div>#ProductName#</div>  </div>  <div style="padding: 5px; width: 100%;">  <div style="color: #af0604; font-weight: bold;">Price</div>  <div>#Price#</div>  </div>  <div style="padding: 5px; width: 100%;">  <div style="color: #af0604; font-weight: bold;">Variants</div>  <div>#Variants#</div>  </div>  DyanamicHtml</div>  </td>  </tr>  <!--Footer-->  <tr bgcolor="#ffffff">  <td style="padding: 10px 0 10px 0; background: #af0604;" align="center" valign="middle">  <p style="font-family: Arial,Helvetica; font-size: 14px; font-style: italic; text-align: center; color: #fff; margin: 0; padding: 0;"><span style="font-size: small;">Copyright @ 2019 Maxwell''s Inc. All Rights Reserved.</span></p>  </td>  </tr>  </tbody>  </table></body></html>'
WHERE EmailTemplateId = (SELECT TOP 1  EmailTemplateId 
FROM ZnodeEmailTemplate WHERE TemplateName = 'ProductCompare' ) 

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'User','IsUserNameAnExistingShopper',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'User' and ActionName = 'IsUserNameAnExistingShopper')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'IsUserNameAnExistingShopper') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'IsUserNameAnExistingShopper'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'IsUserNameAnExistingShopper')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Admin Users' AND ControllerName = 'User') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'User' and ActionName= 'IsUserNameAnExistingShopper'))

GO

UPDATE ZnodeApplicationSetting SET OrderByFields=null WHERE ItemName='View_GetMediaPathDetail'

GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPublishCategoryProducts')
BEGIN 
	DROP PROCEDURE Znode_GetPublishCategoryProducts
END
GO


CREATE PROCEDURE [dbo].[Znode_GetPublishCategoryProducts]
( @pimCatalogId int = 0,@pimCategoryHierarchyId int = 0,@userId int,@versionId int= 0,@status int = 0 OUT,@isDebug bit = 0 ,@LocaleId TransferId READONLY , @PublishStateId INT = 0   )  AS  /*
    Summary :	Publish Product on the basis of publish catalog and category
				Calling sp [Znode_InsertPublishProductIds] to retrive category and their child category with associated products 
				 
				1.	ZnodePublishedXml
				2.	ZnodePublishCategoryProduct
				3.	ZnodePublishProduct
				4.	ZnodePublishProductDetail

                Product details include all the type of products link, grouped, configure and bundel products (include addon) their associated products 
				collect their attributes and values into tables variables to process for publish.  
                
				Finally genrate XML for products with their attributes and inserted into ZnodePublishedXml Znode Admin process xml from sql server to mongodb
				one by one.
	
	Unit Testing
    ------------------------------------------------------------------------------------------------
	Declare @Status int 
	DECLARE @r transferid 
	INSERT INTO @r
	VALUES (1)
	,(24)
	EXEC [Znode_GetPublishCategoryProducts]  @PimCatalogId = 9
	, @PimCategoryHierarchyId = 48 
	, @UserId = 2 
	, @VersionId = 0
	, @IsDebug = 1
	, @Status  = @Status  out
	,@localeId = @r
	,@PublishStateId = 4
	Select @Status  

 */
	BEGIN   
		BEGIN TRY
			SET NOCOUNT ON;
			 DECLARE @IsCatalogPublishInProcess INT  = 0
			DECLARE @tBL_PublishIds table (PublishProductId int,PimProductId int,PublishCatalogId int)
			DECLARE @publishCatalogId int= isnull((SELECT TOP 1 PublishCatalogId FROM ZnodePublishCatalog ZPC WHERE ZPC.PimCatalogId = @pimCatalogId),0),@publishCataloglogId int= 0;
			DECLARE @tBL_CategoryCategoryHierarchyIds table (CategoryId int,ParentCategoryId int ,PimCategoryHierarchyId INT ,ParentPimCategoryHierarchyId INT  )
			DECLARE @pimProductId TransferId
			DECLARE @insertPublishProductIds table (PublishProductId int,PimProductId int,PublishCatalogId int )
			--DECLARE @TBL_CategoryXml TABLE ( CategoryXml XML);
				SELECT @versionId = max(PublishCataloglogId)
			FROM ZnodePublishCatalogLog 
			WHERE PublishCatalogId =@publishCatalogId

		
			INSERT INTO @tBL_CategoryCategoryHierarchyIds(CategoryId,ParentCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId ) 
			SELECT DISTINCT PimCategoryId, Null,PimCategoryHierarchyId,NULL  FROM ( SELECT PimCategoryId,ParentPimCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId
			FROM DBO.[Fn_GetRecurciveCategoryIds_PimCategoryHierarchy](@pimCategoryHierarchyId,@pimCatalogId) 
			UNION SELECT PimCategoryId, Null,PimCategoryHierarchyId,NULL FROM ZnodePimCategoryHierarchy WHERE PimCategoryHierarchyId = @pimCategoryHierarchyId 
			UNION SELECT PimCategoryId, Null,PimCategoryHierarchyId,NULL  FROM dbo.[Fn_GetRecurciveCategoryIds_PimCategoryHierarchyIdnew] (@pimCategoryHierarchyId,@pimCatalogId) ) Category

			
			IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimCatalogCategory ty 
			WHERE EXISTS (SELECT TOP 1 1 FROM ( SELECT PimCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId 
			FROM dbo.[Fn_GetRecurciveCategoryIds_ForChild](@pimCategoryHierarchyId,@pimCatalogId) UNION ALL SELECT NULL ,@pimCategoryHierarchyId,NULL  ) TN WHERE TN.PimCategoryHierarchyId = TY.PimCategoryHierarchyId  ) AND ty.PimProductId IS NOT NULL )
			BEGIN 
			  SET @IsCatalogPublishInProcess = 2 

			END 

			IF (isnull(@publishCatalogId,0) = 0 ) 
				BEGIN 
					SET @status = 1
					-- Catalog Not Published 
					RETURN 0;
				END
			
			IF @IsCatalogPublishInProcess =  0 
			BEGIN 
			

			-- Any other catalog was in process dont intitiate category publish	
			--If Exists ( SELECT TOP 1 1 FROM ZnodePublishcatalogLog  WHERE  IsCatalogPublished  IS NULL AND IsCategoryPublished IS NULL )
			--Begin
			--		SET @status = 2
			--		RETURN 0;
			--End

			
				EXEC [Znode_GetPublishCategoryGroup] @publishCatalogId = @PublishCatalogId,@VersionId = 0,@userId =2,@isDebug = 1,@PimCategoryHierarchyId = @PimCategoryHierarchyId,@localeId =@localeID,@PublishStateId=@PublishStateId
			
			BEGIN 
				INSERT INTO @insertPublishProductIds EXEC [Dbo].[Znode_InsertPublishProductIds] @publishCatalogId = @publishCatalogId,@userid = @userid,@pimProductId = @pimProductId,@pimCategoryHierarchyId = @pimCategoryHierarchyId
				INSERT INTO @pimProductId SELECT PimProductId FROM @insertPublishProductIds

				EXEC [Dbo].[Znode_GetPublishProductbulk] @publishCatalogId = @publishCatalogId,@versionId = @versionId,@pimProductId = @pimProductId,@userid = @userid,@pimCategoryHierarchyId = @pimCategoryHierarchyId,@pimCatalogId = @pimCatalogId,@localeIds = @localeId ,@publishstateId =@publishStateId 
				

			END
			DECLARE @tBL_PublishCatalogId table(PublishCatalogId int,PublishProductId int,PublishCategoryId int,PimProductId int,VersionId int,LocaleId INT  );
			
			INSERT INTO @tBL_PublishCatalogId (PublishCatalogId,PublishProductId,PublishCategoryId,PimProductId,VersionId ,Localeid)  
			SELECT DISTINCT ZPC.PublishCatalogId,ZPX.PublishProductId,ZPX.PublishCategoryId,ZPP.PimProductId,Max(TH.PublishCatalogLogId),TH.Localeid 
			FROM ZnodePublishCategory ZPC 
			INNER JOIN ZnodePublishCatalogLog TH ON (TH.PublishCatalogId = ZPC.PublishCatalogId)
			INNER JOIN @tBL_CategoryCategoryHierarchyIds CTC ON (ZPC.PimCategoryHierarchyId = CTC .PimCategoryHierarchyId )
			INNER JOIN ZnodePublishCategoryProduct ZPX  ON ZPC.PublishCategoryId = ZPX.PublishCategoryId AND ZPX.PublishCatalogId = ZPC.PublishCatalogId 
			INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishCatalogId = ZPC.PublishCatalogId AND ZPX.PublishProductId = ZPP.PublishProductId 
			WHERE ZPC.PublishCatalogId = @PublishCatalogId 
			AND  TH.PublishStateId = @PublishStateId
			AND EXISTS (SELECT TOP 1 1 FROM @LocaleId WHERE id = TH.LocaleId)
			GROUP BY ZPC.PublishCatalogId,ZPX.PublishProductId ,ZPX.PublishCategoryId,ZPP.PimProductId,TH.Localeid 
		
			INSERT INTO @tBL_PublishCatalogId (PublishCatalogId,PublishProductId,PublishCategoryId,PimProductId,VersionId,Localeid ) 
			SELECT IPP.PublishCatalogId,IPP.PublishProductId,0,IPP.PimProductId,max(PublishCatalogLogId) VersionId ,h.Localeid
			FROM @insertPublishProductIds IPP 
			LEFT JOIN ZnodePublishCatalogLog h ON (h.PublishCatalogId = IPP.PublishCatalogId )
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM @tBL_PublishCatalogId PCI WHERE IPP.PublishProductId = PCI.PublishProductId)
			AND EXISTS (SELECT TOP 1 1 FROM @LocaleId WHERE id = h.LocaleId)
			AND h.PublishStateId = @PublishStateId
			GROUP BY IPP.PublishCatalogId,IPP.PublishProductId,IPP.PimProductId,Localeid
			
			UPDATE ZnodePublishCatalogLog 
			SET IsProductPublished = 1,PublishProductId = (SELECT count(PublishProductId) FROM ZnodePublishProduct ZPP WHERE ZPP.PublishCatalogId = ZnodePublishCatalogLog.PublishCatalogId ) 
			WHERE PublishCatalogLogId IN (SELECT VersionId FROM @tBL_PublishCatalogId)
		

			UPDATE ZnodePimProduct 
			SET IsProductPublish = 1 ,PublishStateId = @PublishStateId	
			WHERE EXISTS (SELECT TOP 1 1 
				FROM @tBL_PublishCatalogId ZPP
				WHERE ZPP.PimProductId = ZnodePimProduct.PimProductId
				)
		
				SELECT PublishCatalogId
					,PublishProductId
					,PublishCategoryId
					,VersionId,LocaleId
			FROM @tBL_PublishCatalogId
			END 
			 IF @IsCatalogPublishInProcess = 1 
				BEGIN 
				SELECT 1 Id , 'Single category publish request cannot be processed as catalog or category publish is in progress. Please try after publish is complete.' MessageDetails,  CAST(0 AS BIT ) Status
				END 
				ELSE
				 IF @IsCatalogPublishInProcess = 2 
				BEGIN
				
				SELECT 1 Id , 'Please associate products to the category or to at least one child category to publish the category.' MessageDetails,  CAST(0 AS BIT ) Status
				END 
				ELSE 
				BEGIN 
				SELECT 1 Id , ' Publish Successfull' MessageDetails, CAST(1 AS BIT ) Status
				END 
		END TRY
		BEGIN CATCH
			
			UPDATE ZnodePublishCatalogLog 
			SET IsCatalogPublished = 0 
			WHERE PublishCatalogLogId = @versionId
			SET @status = 0;
			DECLARE @error_procedure varchar(1000)= error_procedure(),@errorMessage nvarchar(max)= error_message(),@errorLine varchar(100)= error_line(),@errorCall nvarchar(max)= 'EXEC Znode_GetPublishProducts @PimCatalogId = '+cast(@pimCatalogId AS varchar(max))+',@@PimCategoryHierarchyId='+@pimCategoryHierarchyId+',@UserId='+cast(@userId AS varchar(50))+',@UserId = '+cast(@userId AS varchar(50))+',@VersionId='+cast(@versionId AS varchar(50))+',@Status='+cast(@status AS varchar(10));
			SELECT 0 AS ID
				,cast(0 AS bit) AS Status;
			
			EXEC Znode_InsertProcedureErrorLog @procedureName = 'Znode_GetPublishCategoryProducts',@errorInProcedure = @error_procedure,@errorMessage = @errorMessage,@errorLine = @errorLine,@errorCall = @errorCall;
		END CATCH;
		END;

		GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'ZnodeDevExpressReport_GetAbandonedCart')
BEGIN 
	DROP PROCEDURE ZnodeDevExpressReport_GetAbandonedCart
END
GO

CREATE PROCEDURE [dbo].[ZnodeDevExpressReport_GetAbandonedCart]  
(
 @BeginDate    DATETIME        ,  
 @EndDate      DATETIME       ,  
 @StoreName   NVARCHAR(max) = '',  
 @ShowOnlyRegisteredUsers BIT = 1   
 
 )  
AS   
/*  
     Summary :- This Procedure is used to get frequently Appear users    
     Unit Testing   
     EXEC ZnodeDevExpressReport_GetAbandonedCart @BeginDate = '2019-02-20 17:34:03.953',@EndDate= '2019-02-20 17:34:03.953'  
	a.ModifiedDate,a.CreatedDate,
*/  
     BEGIN  
         BEGIN TRY  
         DECLARE @SQL NVARCHAR(MAX)  
         DECLARE @GetDate DATETIME = dbo.Fn_GetDate()
   DECLARE @TBL_ReportOrderDetails TABLE (OmsSavedCartId INT ,Quantity NUMERIC(28,6) 
   , CartCreatedAt datetime,CartUpdatedAt datetime,CustomerName VARCHAR(300),StoreName nvarchar(max),Email  VARCHAR(50),
   CustomerType  VARCHAR(50), SKU nvarchar(4000),PortalId INT
   );  
  
   DECLARE @TBL_PortalId TABLE (PortalId INT );  
   INSERT INTO @TBL_PortalId  
   SELECT PortalId   
   FROM ZnodePortal ZP   
   INNER JOIN dbo.split(@StoreName,'|') SP ON (SP.Item = ZP.StoreName)  
  
   INSERT INTO @TBL_ReportOrderDetails  
   select DISTINCT a.OmsSavedCartId,sum(Quantity) as Quantity,MAX(a.CreatedDate) AS CartCreatedAt,  
   MAX(a.ModifiedDate) as CartUpdatedAt, CASE WHEN REPLACE(ISNULL(FirstName,'')+' '+ISNULL(LastName,''),' ','') = ''   
   THEN f.UserName ELSE ISNULL(FirstName,'')+' '+ISNULL(LastName,'') END  CustomerName , p.StoreName ,d.Email AS Email
   ,CASE WHEN  d.AspNetUserId IS NULL THEN 'Guest User' ELSE 'Registered User' END  CustomerType, b.SKU, p.PortalId
   from ZnodeOmsSavedCart a  
   INNER JOIN ZnodeOmsSavedCartLineItem b on a.OmsSavedCartId = b.OmsSavedCartId  
   INNER JOIN ZnodeOmsCookieMapping c on a.OmsCookieMappingId = c.OmsCookieMappingId  
   INNER JOIN ZnodePortal p on c.PortalId = p.PortalId  
   LEFT JOIN ZnodeUser d on c.UserId = d.UserId  
   LEFT JOIN AspNetUsers e on d.AspNetUserId = e.Id  
   LEFT JOIN AspNetZnodeUser f on f.AspNetZnodeUserId = e.UserName  
   WHERE 
    (EXISTS (SELECT TOP 1 1 FROM @TBL_PortalId rt WHERE rt.PortalId = p.PortalId)
				      OR NOT EXISTS (SELECT TOP 1 1 FROM @TBL_PortalId )) 
	AND ((@ShowOnlyRegisteredUsers = 1 and d.AspNetUserId  IS NOT NULL) or (@ShowOnlyRegisteredUsers <> 1 ))
	AND CAST(b.ModifiedDate AS DATETIME) BETWEEN @BeginDate AND @EndDate 
   group by a.OmsSavedCartId,f.UserName, p.StoreName,FirstName, LastName  ,d.Email,d.AspNetUserId,b.SKU,p.PortalId
       

    select DISTINCT a.OmsSavedCartId,sum(Quantity) as Quantity,MAX(b.CreatedDate) AS CartCreatedAt,  
   MAX(b.ModifiedDate) as CartUpdatedAt, CASE WHEN REPLACE(ISNULL(FirstName,'')+' '+ISNULL(LastName,''),' ','') = ''   
   THEN f.UserName ELSE ISNULL(FirstName,'')+' '+ISNULL(LastName,'') END  CustomerName , p.StoreName ,d.Email AS Email
   ,CASE WHEN  d.AspNetUserId IS NULL THEN 'Guest User' ELSE 'Registered User' END  CustomerType, b.SKU, p.PortalId
   INTO #tempabandonedcart 
   from ZnodeOmsSavedCart a  
   INNER JOIN ZnodeOmsSavedCartLineItem b on a.OmsSavedCartId = b.OmsSavedCartId  
   INNER JOIN ZnodeOmsCookieMapping c on a.OmsCookieMappingId = c.OmsCookieMappingId  
   INNER JOIN ZnodePortal p on c.PortalId = p.PortalId  
   LEFT JOIN ZnodeUser d on c.UserId = d.UserId  
   LEFT JOIN AspNetUsers e on d.AspNetUserId = e.Id  
   LEFT JOIN AspNetZnodeUser f on f.AspNetZnodeUserId = e.UserName  
   WHERE 
    (EXISTS (SELECT TOP 1 1 FROM @TBL_PortalId rt WHERE rt.PortalId = p.PortalId)
				      OR NOT EXISTS (SELECT TOP 1 1 FROM @TBL_PortalId )) 
	AND ((@ShowOnlyRegisteredUsers = 1 and d.AspNetUserId  IS NOT NULL) or (@ShowOnlyRegisteredUsers <> 1 ))
	AND CAST(b.ModifiedDate AS DATETIME) BETWEEN @BeginDate AND @EndDate 
	AND b.OrderLineItemRelationshipTypeId NOT IN (SELECT OrderLineItemRelationshipTypeId FROM ZnodeOmsOrderLineItemRelationshipType
    WHERE Name = 'AddOns')
   group by a.OmsSavedCartId,f.UserName, p.StoreName,FirstName, LastName  ,d.Email,d.AspNetUserId,b.SKU,p.PortalId


	DECLARE @skuuu SelectColumnList, @PortalId TransferId
  
    INSERT INTO @skuuu
	SELECT SKU FROM @TBL_ReportOrderDetails

	INSERT INTO @PortalId
	SELECT DISTINCT PortalId FROM @TBL_ReportOrderDetails
	
	DECLARE @TBL_ProductPricing TABLE (SKU VARCHAR(1000),RetailPrice VARCHAR(1000) );
		 
	INSERT INTO @TBL_ProductPricing (SKU,RetailPrice)
	EXEC Znode_GetAbandonedProductPricingBySku  @skuuu, @PortalId, @GetDate
	 

   SELECT  DISTINCT A.OmsSavedCartId,MAx(A.CartCreatedAt) CartCreatedAt,MAX(A.CartUpdatedAt) CartUpdatedAt,A.CustomerName,A.StoreName,A.Email ,
   A.CustomerType , SUM(B.RetailPrice * A.Quantity) AS SubTotal 
   INTO #tempcarttt
   FROM @TBL_ReportOrderDetails  A
   INNER JOIN @TBL_ProductPricing B ON (A.SKU = B.SKU) -- addon
   GROUP BY A.OmsSavedCartId,A.CustomerName,A.StoreName,A.Email ,
   A.CustomerType
   ORDER BY A.StoreName DESC,CartUpdatedAt DESC,CustomerName DESC  
       
	  select c.OmsSavedCartId,a.CartCreatedAt, a.CartUpdatedAt,a.CustomerName,a.StoreName,a.Email
	  ,a.CustomerType,a.SubTotal, SUM(c.Quantity) Quantity ,COUNT(*) Products
	  from  #tempcarttt a
	  inner join #tempabandonedcart C on (a.OmsSavedCartId = c.OmsSavedCartId)
	  GROUP BY C.OmsSavedCartId ,a.CartCreatedAt, a.CartUpdatedAt,a.CustomerName,a.StoreName,a.Email
	  ,a.CustomerType,a.SubTotal

	                
         END TRY  
         BEGIN CATCH  
		
             DECLARE @Status BIT ;  
       SET @Status = 0;  
       DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),  
    @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeDevExpressReport_GetAbandonedCart @BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
             EXEC Znode_InsertProcedureErrorLog  
    @ProcedureName = 'ZnodeDevExpressReport_GetAbandonedCart',  
    @ErrorInProcedure = @Error_procedure,  
    @ErrorMessage = @ErrorMessage,  
    @ErrorLine = @ErrorLine,  
    @ErrorCall = @ErrorCall;  
         END CATCH;  
     END;

	 GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetAbandonedProductPricingBySku')
BEGIN 
	DROP PROCEDURE Znode_GetAbandonedProductPricingBySku
END
GO

CREATE PROCEDURE [dbo].[Znode_GetAbandonedProductPricingBySku]
(   
    @SKU              SelectColumnList READONLY,
    @PortalId         TransferId READONLY,
    @currentUtcDate   VARCHAR(100), -- this date is required for the user date r
    @UserId           INT          = 0 -- userid is optional 
    
	)
AS 
   /* 
    --Summary: Retrive Price of product from pricelist
    --Input Parameters:
    --UserId, SKU(Comma separated multiple), PortalId
    --Conditions :
    --1. If userId is null then check for PriceList having sku associated to profile which is associated to Portal having  PortalId and  having higher Precedence and valid ActivationDate and ExpirationDate for PriceList  and SKU also.
    --Unit Testing : 
    --EXEC Znode_GetPublishProductPricingBySku_2 @SKU = 'apple,apr234' , @PortalId = 34 , @currentUtcDate = '2016-09-17 00:00:00.000';
    --2. If There is no any PriceList having given sku associated to profile  then check for  
    --PriceList associated portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --Unit Testing : 
    --EXEC Znode_GetPublishProductPricingBySku_2 @SKU = 'apple,apr234' , @PortalId = 34 , @currentUtcDate = '2016-09-17 00:00:00.000';
    --3. If userId is not null then check for PriceList having sku associated to User having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --4. If There is no any PriceList having given sku associated to user  then check for  
    --PriceList associated Account having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --5. If There is no any PriceList having given sku associated to account  then check for  
    --PriceList associated Profile having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --6. If There is no any PriceList having given sku associated to Profile  then check for  
    --PriceList associated Portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
    --7. If in each case Precedence is same then get PriceList according to higher PriceListId ActivationDate and ExpirationDate for PriceList and SKU also.
    --8. Also get the Tier Price, Tier Quantity of given sku.
    --Unit Testing   
    --Exec Znode_GetPublishProductPricingBySku  @SKU = 'Levi''s T-Shirt & Jeans - Bundle Product',@PortalId = 1, @currentUtcDate = '2016-07-31 00:00:00.000'
	*/
    
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @Tlb_SKU TABLE
             (SKU        VARCHAR(100),
              SequenceNo INT IDENTITY
             );

			  DECLARE @DefaultLocaleId INT = dbo.FN_GETDEFAULTLocaleId()

			 --IF @SKU = '' 
			 --BEGIN 
			 -- INSERT INTO @Tlb_SKU(SKU)
			 -- 	SELECT (SELECT ''+SKU FOR XML PATH('')) 
				--	FROM ZnodePublishProductDetail a
				--	WHERE LocaleId = @DefaultLocaleId


			 --END 
			 --ELSE 
			 --BEGIN
			 --  INSERT INTO @Tlb_SKU(SKU)
    --                SELECT Item
    --                FROM Dbo.split(@SKU, ',');
			  

			 --END 

          
             DECLARE @TLB_SKUPRICELIST TABLE
             (SKU          VARCHAR(100),
              RetailPrice  NUMERIC(28, 6),
              SalesPrice   NUMERIC(28, 6),
              PriceListId  INT,
              TierPrice    NUMERIC(28, 6),
              TierQuantity NUMERIC(28, 6),
			  ExternalId NVARCHAR(2000),
			  Custom1 NVARCHAR(MAX),
			  Custom2 NVARCHAR(MAX),
			  Custom3 NVARCHAR(MAX)
             );
             DECLARE @PriceListId INT, @PriceRoundOff INT;
             SELECT @PriceRoundOff = CONVERT( INT, FeatureValues)
             FROM ZnodeGlobalSetting
             WHERE FeatureName = 'PriceRoundOff';
		
             --Retrive portal wise pricelist  
             DECLARE @Tbl_PortalWisePriceList TABLE
             (PriceListId    INT,
              ActivationDate DATETIME,
              ExpirationDate DATETIME NULL,
              Precedence     INT,
			  SKU NVARCHAR(300)
             );
             --Retrive price for respective pricelist   
             DECLARE @Tbl_PriceListWisePrice TABLE
             (
				  PriceListId    INT,
				  SKU            VARCHAR(300),
				  SalesPrice     NUMERIC(28, 6),
				  RetailPrice    NUMERIC(28, 6),
				  UomId          INT,
				  UnitSize       NUMERIC(28, 6),
				  ActivationDate DATETIME,
				  ExpirationDate DATETIME NULL,
				  TierPrice      NUMERIC(28, 6),
				  TierQuantity   NUMERIC(28, 6),
				  TierUomId      INT,
				  TierUnitSize   NUMERIC(28, 6), 
				  ExternalId NVARCHAR(2000),
				  Custom1 NVARCHAR(MAX),
				  Custom2 NVARCHAR(MAX),
				  Custom3 NVARCHAR(MAX)
             );
			 DECLARE @Tbl_SKUWisePriceList TABLE (PriceListId INT, SKU NVARCHAR(300))

			 insert into @Tbl_SKUWisePriceList(PriceListId,SKU) 
			 SELECT  PriceListId,SKU from ZnodePrice where (SELECT ''+SKU FOR XML PATH('')) in (Select StringColumn from @SKU )
			 Union
			 SELECT PriceListId,SKU  from ZnodePriceTier where (SELECT ''+SKU FOR XML PATH('')) in (Select StringColumn from @SKU )
			 
			 --1. If userId is null then check for PriceList having sku associated to profile which is associated to Portal having  PortalId and  having higher Precedence and valid ActivationDate and ExpirationDate for PriceList  and SKU also.
            IF @UserId = 0
                 BEGIN
					INSERT INTO @Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
					SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
					FROM ZnodePriceList AS a INNER JOIN ZnodePriceListProfile AS b ON a.PriceListId = b.PriceListId INNER JOIN ZnodePortalProfile AS c
						ON b.PortalProfileId = c.PortalProfileID AND  c.IsDefaultAnonymousProfile = 1 INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId 
						inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
					WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND 
					 EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = c.PortalId) -- c.PortalId = @PortalId
					ORDER BY b.Precedence;
		
			 
                     --2. If There is no any PriceList having given sku associated to profile  then check for PriceList associated portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
			IF Exists (Select top 1 1  FROM @Tbl_SKUWisePriceList tspl where NOT Exists (SELECT TOP 1 1 FROM @Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))
                         BEGIN
							INSERT INTO @Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
							SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
							FROM ZnodePriceList AS a INNER JOIN ZnodePriceListPortal AS b ON a.PriceListId = b.PriceListId
							INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId   
							inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
							AND NOT EXISTS (Select TOP 1 1 FROM  @Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
							WHERE @CurrentUtcDate BETWEEN a.ActivationDate 
							AND ISNULL(a.ExpirationDate, @GetDate) AND 
							 EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = b.PortalId) --b.PortalId = @PortalId
							ORDER BY b.Precedence
							;
							--Delete from @Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  @Tbl_PortalWisePriceList )
						
                         END;
                 END;
                     --3. If userId is not null then check for PriceList having sku associated to User having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
             ELSE
                 BEGIN
				 
                     INSERT INTO @Tbl_PortalWisePriceList (PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
                            SELECT a.PriceListId, ActivationDate,ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
                            FROM ZnodePriceList AS a INNER JOIN ZnodePriceListUser AS b ON a.PriceListId = b.PriceListId
                                 INNER JOIN ZnodePortalunit zupu ON (a.CultureId = zupu.CultureId 
								 AND EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = zupu.PortalId) )--zupu.PortalId = @PortalId  )
								 inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
								 AND NOT EXISTS (Select TOP 1 1 FROM  @Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
								 
                            WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND b.UserID = @UserId
							ORDER BY b.Precedence ;

                --4. If There is no any PriceList having given sku associated to user  then check for PriceList associated Account having UserId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
				IF Exists (Select top 1 1  FROM @Tbl_SKUWisePriceList tspl where NOT Exists (SELECT TOP 1 1 FROM @Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))
						BEGIN
							INSERT INTO @Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
								   SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), c.Precedence,tsw.SKU
								   FROM ZnodePriceList AS a INNER JOIN ZnodePriceListAccount AS c ON a.PriceListId = c.PriceListId
										INNER JOIN ZnodeUser AS d ON c.Accountid = d.Accountid INNER JOIN ZnodePortalunit AS zupu ON (a.CultureId = zupu.CultureId   
										AND EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = zupu.PortalId) )--AND zupu.PortalId = @PortalId
										inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
										AND NOT EXISTS (Select TOP 1 1 FROM  @Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
								   WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND d.UserID = @UserId
									ORDER BY c.Precedence
							--Delete from @Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  @Tbl_PortalWisePriceList )
						 END;
                     -- 5. If There is no any PriceList having given sku associated to account  then check for PriceList associated Profile having PortalId and having higher   Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
				IF Exists (Select top 1 1  FROM @Tbl_SKUWisePriceList tspl 
				where NOT Exists (SELECT TOP 1 1 FROM @Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))

                         BEGIN
                             INSERT INTO @Tbl_PortalWisePriceList(PriceListId,ActivationDate,ExpirationDate,Precedence,SKU)
                                    SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
                                    FROM ZnodePriceList AS a
                                         INNER JOIN ZnodePriceListProfile AS b ON a.PriceListId = b.PriceListId 
										 INNER JOIN ZnodePortalProfile AS c ON (b.PortalProfileId = c.PortalProfileId  
										 AND EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = c.PortalId) )--AND c.PortalId = @PortalId 
                                         INNER JOIN dbo.ZnodeUserProfile zup ON c.ProfileId = zup.ProfileId AND IsDefault = 1
                                         INNER JOIN ZnodePortalunit zupu ON (a.CultureId = zupu.CultureId 
										 AND EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = zupu.PortalId) )--AND zupu.PortalId = @PortalId 
										 inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
										 AND NOT EXISTS (Select TOP 1 1 FROM  @Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
                                    WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND zup.UserId = @UserId;
									--Delete from @Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  @Tbl_PortalWisePriceList )

					     END;
                   

                     ---6. If There is no any PriceList having given sku associated to Profile  then check for priceList associated Portal having PortalId and having higher Precedence ActivationDate and ExpirationDate for PriceList and SKU also.
                  				IF Exists (Select top 1 1  FROM @Tbl_SKUWisePriceList tspl 
								where NOT Exists (SELECT TOP 1 1 FROM @Tbl_PortalWisePriceList tpwl
				WHERE tspl.SKU = tpwl.SKU))

                         BEGIN
							INSERT INTO @Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
							SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
							FROM ZnodePriceList AS a INNER JOIN ZnodePriceListPortal AS b ON a.PriceListId = b.PriceListId
								INNER JOIN ZnodePortalunit AS zupu ON a.CultureId = zupu.CultureId AND  zupu.PortalId = b.PortalId    
								inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
								AND NOT EXISTS (Select TOP 1 1 FROM  @Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
								WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) 
								AND EXISTS (SELECT TOP 1 1 FROM @PortalId WHERE Id = b.PortalId) --AND b.PortalId = @PortalId
							    ORDER BY b.Precedence
								;
								--Delete from @Tbl_SKUWisePriceList where PriceListId in (Select PriceListId from  @Tbl_PortalWisePriceList )
                         END;
						 
				--IF Exists (Select top 1 1  FROM @Tbl_SKUWisePriceList tspl where NOT Exists (SELECT TOP 1 1 FROM @Tbl_PortalWisePriceList tpwl
				--WHERE tspl.SKU = tpwl.SKU))
				--BEGIN
				
				--	INSERT INTO @Tbl_PortalWisePriceList( PriceListId, ActivationDate, ExpirationDate, Precedence,SKU )
				--	SELECT a.PriceListId, ActivationDate, ISNULL(ExpirationDate, @GetDate), b.Precedence,tsw.SKU
				--	FROM ZnodePriceList AS a INNER JOIN ZnodePriceListProfile AS b ON a.PriceListId = b.PriceListId INNER JOIN ZnodePortalProfile AS c
				--	ON b.ProfileId = c.ProfileId AND  c.IsDefaultAnonymousProfile = 1 INNER JOIN ZnodePortalunit AS zupu ON a.CurrencyId = zupu.CurrencyId
				--	inner join @Tbl_SKUWisePriceList tsw  ON a.PriceListId = tsw.PriceListId
				--	AND NOT EXISTS (Select TOP 1 1 FROM  @Tbl_PortalWisePriceList tpwl WHERE tpwl.SKU = tsw.SKU )
				--	WHERE @CurrentUtcDate BETWEEN a.ActivationDate AND ISNULL(a.ExpirationDate, @GetDate) AND c.PortalId = @PortalId;
				--END

                 END;
			
             SET @PriceListId = 0;
             -- Check Activation date and expiry date 
             IF EXISTS( SELECT TOP 1 1 FROM @Tbl_PortalWisePriceList)
                 BEGIN
				
                     -- Declare  @d datetime
                     -- SET @d = @GetDate
                     -- Select ISNULL(ActivationDate,@d)  , ISNULL( ExpirationDate,@GetDate ),b.Precedence,* from ZnodePriceList  a inner join ZnodePriceListPortal b on a.PriceListId = b.PriceListId where @d between ISNULL(ActivationDate,@d) 
                     -- and ISNULL(ExpirationDate,@GetDate ) --and a.PriceListId <>  80
                     -- Order by ISNULL(ActivationDate,@d)  , ISNULL( ExpirationDate,@GetDate ) ,  b.Precedence DESC 
                     --	Retrive pricelist wise price
                   INSERT INTO @Tbl_PriceListWisePrice( PriceListId, SKU, SalesPrice, RetailPrice, UomId, UnitSize, ActivationDate, ExpirationDate, TierPrice, TierQuantity, TierUomId, TierUnitSize , ExternalId ,Custom1,Custom2,Custom3)
				   SELECT ZP.PriceListId, ZP.SKU, ZP.SalesPrice, ZP.RetailPrice, ZP.UomId, ZP.UnitSize, ISNULL(ZP.ActivationDate, @CurrentUtcDate), ISNULL(ZP.ExpirationDate, @GetDate), ZPT.Price, ZPT.Quantity, ZPT.UomId, ZPT.UnitSize, ZP.ExternalId,
				   ZPT.Custom1,ZPT.Custom2,ZPT.Custom3
				   FROM [ZnodePrice] AS ZP 
				   INNER JOIN @SKU AS TSKU ON (SELECT ''+ZP.SKU FOR XML PATH ('')) = TSKU.StringColumn 
				   LEFT OUTER JOIN ZnodePriceTier AS ZPT ON ZP.SKU = ZPT.SKU AND ZP.PriceListId = ZPT.PriceListId
				   WHERE ZP.PriceListId IN
				   (
					   SELECT TOP 1 PriceListId
					   FROM @Tbl_PortalWisePriceList AS TBPWPL
					   WHERE  TBPWPL.SKU = ZP.SKU
					   ORDER BY Precedence 
				   );
				  


                     -- Check Activation date and expiry date 
                    INSERT INTO @TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3 )
					   SELECT DISTINCT  PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					   FROM @Tbl_PriceListWisePrice
					   WHERE @currentUtcDate BETWEEN ActivationDate AND ISNULL(ExpirationDate, @GetDate);
					   
					  
					INSERT INTO @TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId ,Custom1,Custom2,Custom3)
					   SELECT PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					   FROM @Tbl_PriceListWisePrice
					   WHERE SKU NOT IN(SELECT SKU FROM @TLB_SKUPRICELIST) and ActivationDate is null 
				
                 END;
                     -- Retrive data as per precedance from ZnodePriceListPortal table  
					
             ELSE
                 BEGIN
                     SET @PriceListId =( SELECT TOP 1 PriceListId FROM @Tbl_PortalWisePriceList ORDER BY Precedence  );

                     --Retrive pricelist wise price  
                     INSERT INTO @Tbl_PriceListWisePrice( PriceListId, SKU, SalesPrice, RetailPrice, UomId, UnitSize, ActivationDate, ExpirationDate, TierPrice, TierQuantity, TierUomId, TierUnitSize, ExternalId ,Custom1,Custom2,Custom3)
					 SELECT ZP.PriceListId, ZP.SKU, ZP.SalesPrice, ZP.RetailPrice, ZP.UomId, ZP.UnitSize, ISNULL(ZP.ActivationDate, @CurrentUtcDate), 
							ISNULL(ZP.ExpirationDate, @GetDate), ZPT.Price, ZPT.Quantity, ZPT.UomId, ZPT.UnitSize, zp.ExternalId,Custom1,Custom2,Custom3
					 FROM [ZnodePrice] AS ZP INNER JOIN @SKU AS TSKU ON ZP.SKU = TSKU.StringColumn LEFT OUTER JOIN ZnodePriceTier AS ZPT ON ZP.SKU = ZPT.SKU AND 
							   ZP.PriceListId = ZPT.PriceListId WHERE ZP.PriceListId = @PriceListId; 

                     -- Check Activation date and expiry date 
					INSERT INTO @TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId ,Custom1,Custom2,Custom3)
					SELECT PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					FROM @Tbl_PriceListWisePrice WHERE @currentUtcDate BETWEEN ActivationDate AND ISNULL(ExpirationDate, @GetDate);
					
					INSERT INTO @TLB_SKUPRICELIST( PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId ,Custom1,Custom2,Custom3)
					SELECT PriceListId, SKU, RetailPrice, SalesPrice, TierPrice, TierQuantity, ExternalId,Custom1,Custom2,Custom3
					FROM @Tbl_PriceListWisePrice
					WHERE SKU NOT IN ( SELECT SKU FROM @TLB_SKUPRICELIST) and ActivationDate is null;

                 END;
             SELECT DISTINCT SKU,
                      ROUND(RetailPrice, @PriceRoundOff) AS RetailPrice
                    --ROUND(SalesPrice, @PriceRoundOff) AS SalesPrice,
                    --ROUND(TierPrice, @PriceRoundOff) AS TierPrice,
                    --ROUND(TierQuantity, @PriceRoundOff) AS TierQuantity
					--ZCC.CurrencyCode  AS CurrencyCode,    
                    --ZC.Symbol AS CurrencySuffix,  ZC.CultureCode,
					--TSPL.ExternalId,
					--Custom1,Custom2,Custom3
             FROM @TLB_SKUPRICELIST AS TSPL
                  INNER JOIN ZnodePriceList AS ZPL ON TSPL.PriceListId = ZPL.PriceListId
                  INNER JOIN ZnodeCulture AS ZC ON ZPL.CultureId = ZC.CultureId    
				  LEFT JOIN ZnodeCurrency AS ZCC ON ZC.CurrencyId = ZCC.CurrencyId   
				  --ORDER BY TierQuantity ASC;
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
			SET @Status = 0;
			SELECT ERROR_MESSAGE()
			--DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishProductPricingBySku @SKU = '+@SKU+',@PortalId = '+CAST(@PortalId AS VARCHAR(10))+',@currentUtcDate = '+@currentUtcDate+',@UserId='+CAST(@UserId AS VARCHAR(100))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			--SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			--EXEC Znode_InsertProcedureErrorLog
			--	@ProcedureName = 'Znode_GetPublishProductPricingBySku',
			--	@ErrorInProcedure = @Error_procedure,
			--	@ErrorMessage = @ErrorMessage,
			--	@ErrorLine = @ErrorLine,
			--	@ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetPimProductAttributeInventory')
BEGIN 
	DROP PROCEDURE Znode_GetPimProductAttributeInventory
END
GO

CREATE  PROCEDURE [dbo].[Znode_GetPimProductAttributeInventory]
(   @SKU    SelectColumnList READONLY
    --@IsMultipleProduct BIT          = 0
	)
AS
/*
     Summary : - This procedure is used to find the inventory of product 
     Unit Testing 
	 begin tran
     Exec Znode_GetPimProductAttributeInventory 7
	 rollback tran
*/
     BEGIN
	 BEGIN TRAN PimProductAttributeFamilyId
         BEGIN TRY
             SET NOCOUNT ON;
			
			 IF OBJECT_ID('tempdb.dbo.#TBL_PimProductId', 'U') IS NOT NULL 
		     DROP TABLE #TBL_PimProductId

             
			 DECLARE @TBL_InventoryDetails TABLE (QUANTITY INT,PimProductId INT)
            			 
			 SELECT StringColumn AS SKU INTO #TBL_PimProductId  FROM @SKU 

			 --INSERT INTO @TBL_InventoryDetails 
			 --SELECT DISTINCT sum(ZI.Quantity ) quantity  ,b.PimProductId 
			 --FROM ZnodeInventory ZI
				--INNER JOIN ZnodeWarehouse ZW on (ZI.WarehouseId = ZW.WarehouseId)
				--Inner join View_LoadManageProductInternal  b ON ZI.SKU = b.AttributeValue  AND b.AttributeCode = 'SKU'
				--WHERE EXISTS(SELECT TOP 1 1 FROM #TBL_PimProductId TBP WHERE ZI.SKU = TBP.SKU)
				--group by b.PimProductId 


				-- DontTrackInventory cant have inventory
			 INSERT INTO @TBL_InventoryDetails 
			 SELECT DISTINCT sum(ZI.Quantity ) quantity  ,b.PimProductId 
			 FROM 
			 View_LoadManageProductInternal  b 
			 LEFT JOIN  ZnodeInventory ZI ON ZI.SKU = b.AttributeValue  AND b.AttributeCode = 'SKU'
			 LEFT JOIN ZnodeWarehouse ZW on (ZI.WarehouseId = ZW.WarehouseId)
			 WHERE EXISTS(SELECT TOP 1 1 FROM #TBL_PimProductId TBP WHERE b.AttributeValue = TBP.SKU )
			 GROUP BY b.PimProductId 


			;WITH CTE_Getdetails AS (
			SELECT DISTINCT CASE WHEN  AttributeDefaultValueCode = 'DontTrackInventory' THEN 'DTI' 
			ELSE [dbo].[Fn_GetDefaultInventoryRoundOff](ISNULL(Quantity, 0))     END Quantity  ,tb.PimProductId 
			FROM @TBL_InventoryDetails tb
			INNER JOIN ZnodePimAttributeValue PAV ON (PAV.PimProductId = tb.PimProductId)
			INNER JOIN ZnodePimProductAttributeDefaultValue a on (a.PimAttributeValueId = pav.PimAttributeValueId)
			INNER JOIN ZnodePimAttributeDefaultValue dv on (a.PimAttributeDefaultValueId = dv.PimAttributeDefaultValueId)
			--inner join ZnodePimAttributeDefaultValuelocale dvl on (dv.PimAttributeDefaultValueId = dvl.PimAttributeDefaultValueId)
			INNER JOIN ZnodePimAttribute PA ON (PA.pimattributeId = PAV.pimAttributeid )
			--WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimProductId TBP WHERE ZI.SKU = TBP.SKU )
			--group by b.PimProductId
			WHERE  PA.Attributecode = 'OutOfStockOptions'
			)
		
			 SELECT   CAST(quantity AS NVARCHAR(MAX))  quantity ,PimProductId
			 FROM CTE_Getdetails

			IF OBJECT_ID('tempdb.dbo.#TBL_PimProductId', 'U') IS NOT NULL 
			DROP TABLE #TBL_PimProductId
	
		 COMMIT TRAN PimProductAttributeFamilyId;
         END TRY
         BEGIN CATCH
				
          DECLARE @Status BIT ;
		  SET @Status = 0;
		  --DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPimProductAttributeFamilyId @PimProductId = '+cast (@PimProductId AS VARCHAR(50))+',@IsMultipleProduct='+CAST(@IsMultipleProduct AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  ROLLBACK TRAN PimProductAttributeFamilyId;

          --EXEC Znode_InsertProcedureErrorLog
          --  @ProcedureName = 'Znode_GetPimProductAttributeFamilyId',
          --  @ErrorInProcedure = @Error_procedure,
          --  @ErrorMessage = @ErrorMessage,
          --  @ErrorLine = @ErrorLine,
          --  @ErrorCall = @ErrorCall;
         END CATCH;
     END;

	 GO

UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?> <columns>  <column>   <id>1</id>   <name>OmsOrderId</name>   <headertext>Checkbox</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>Int32</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>y</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>2</id>   <name>OrderNumber</name>   <headertext>Order No</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>y</isallowlink>   <islinkactionurl>/Order/Manage</islinkactionurl>   <islinkparamfield>OmsOrderId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>3</id>   <name>UserName</name>   <headertext>Customer Name</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>4</id>   <name>Email</name>   <headertext>Email</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>5</id>   <name>PhoneNumber</name>   <headertext>Phone Number</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>6</id>   <name>StoreName</name>   <headertext>Store Name</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>7</id>   <name>OrderState</name>   <headertext>Order Status</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>orderState</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>8</id>   <name>PaymentStatus</name>   <headertext>Payment Status</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>paymentStatus</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>9</id>   <name>PaymentDisplayName</name>   <headertext>Payment Name</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>paymentType</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>10</id>   <name>OrderTotalWithCurrency</name>   <headertext>Total</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>11</id>   <name>Total</name>   <headertext>Total</headertext>   <width>30</width>   <datatype>Decimal</datatype>   <columntype>Decimal</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>12</id>   <name>SubTotalAmount</name>   <headertext>SubTotal</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>13</id>   <name>Tax</name>   <headertext>Tax</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>14</id>   <name>Shipping</name>   <headertext>Shipping</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>15</id>   <name>BillingPostalCode</name>   <headertext>Billing Zip Code</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>16</id>   <name>ShippingPostalCode</name>   <headertext>Shipping Zip Code</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>17</id>   <name>OrderDateWithTime</name>   <headertext>Order Date</headertext>   <width>0</width>   <datatype>DateTime</datatype>   <columntype>DateTime</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>18</id>   <name>CreatedByName</name>   <headertext>Created By</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>Boolean</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>19</id>   <name>PublishState</name>   <headertext>Application Type</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>20</id>   <name>ModifiedByName</name>   <headertext>Modified By</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>Boolean</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>21</id>   <name>Manage</name>   <headertext>Action</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format>View|void-payment</format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext>View</displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl>/Order/Manage</manageactionurl>   <manageparamfield>OmsOrderId</manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column> </columns>'
, ModifiedDate = getdate()
WHERE ItemName ='ZnodeOrder'

	GO
