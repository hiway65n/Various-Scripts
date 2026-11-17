-- Source: Computer Monitor Inventory Data Query
-- Blog: https://hiway65nblog.blogspot.com/2016/09/computer-monitor-inventory-data-query.html
-- Published: September 28, 2016
-- Labels: Hardware Inventory, Reporting, SQL, System Center Configuration Manager, System Center Configuration Manager 2012

set nocount on

declare @ADSite varchar(56)
set @ADSite = 'AD Site'

-- split and conversion logic
declare @convCode nvarchar(1023)
set @convCode = N'declare @indx int; declare @valToConvert varchar(4);'
+ CHAR(13) + N'set @result='''''
+ CHAR(13) + N'while LEN(@input) > 0 begin'
+ CHAR(13) + N'select @indx = CHARINDEX('','', @input)'
+ CHAR(13) + N'select @valToConvert = SUBSTRING(@input, 0, @indx)'
+ CHAR(13) + N'if (@valToConvert = ''0'') OR (@valToConvert = '''') break'
+ CHAR(13) + N'select @result = @result + CHAR(@valToConvert)'
+ CHAR(13) + N'select @input = SUBSTRING(@input, @indx+2, LEN(@input) - @indx) end'
declare @params nvarchar(500)
set @params = N'@input varchar(255), @result varchar(255) OUTPUT'

-- table variable
declare @convertTab table (
    ResourceID int,
    UserFriendlyName0 nvarchar(255),
    UserFriendlyNameLength0 int,
    UserFriendlyNameConv varchar(255),
 ManufacturerName0 nvarchar(255),
    ProductCodeID0 nvarchar(255),
    SerialNumberID0 nvarchar(255),
 WeekOfManufacture0 int,
    YearOfManufacture0 int
)
-- select data to report on, into the table variable
insert @convertTab
    (ResourceID, ManufacturerName0, ProductCodeID0, SerialNumberID0, WeekOfManufacture0, YearOfManufacture0,
    UserFriendlyName0, UserFriendlyNameLength0)
select
    ResourceID, ManufacturerName0, ProductCodeID0, SerialNumberID0, WeekOfManufacture0, YearOfManufacture0,
    UserFriendlyName0, UserFriendlyNameLength0
from v_GS_WMIMONITORID
where ResourceID in
    (select ResourceID from v_r_system where AD_Site_Name0 = @ADSite)

-- cursor to iterate through table variable and convert
declare convert_cursor cursor for
select UserFriendlyName0 from @convertTab
declare @resId varchar(255), @fname varchar(255)
declare @out varchar(255)

open convert_cursor
fetch next from convert_cursor into @fname
while @@FETCH_STATUS = 0
begin

    exec sp_executesql @convCode, @params, @input=@fname, @result=@out OUTPUT
    update @convertTab set UserFriendlyNameConv = @out where UserFriendlyName0 = @fname

 fetch next from convert_cursor into @fname
end
close convert_cursor
deallocate convert_cursor

set nocount off

--return converted data
select
syst.Name0, syst.AD_Site_Name0, cnvt.UserFriendlyNameConv, cnvt.UserFriendlyNameLength0,
cnvt.ManufacturerName0, cnvt.ProductCodeID0, cnvt.SerialNumberID0,
cnvt.YearOfManufacture0, cnvt.WeekOfManufacture0,
CurrentHorizontalResolution0, CurrentVerticalResolution0,VideoModeDescription0
from @convertTab cnvt join v_R_System syst
right join v_GS_VIDEO_CONTROLLER on syst.ResourceID = v_GS_VIDEO_CONTROLLER.ResourceID
on cnvt.ResourceID = syst.ResourceID

---------------------------------------------------------------------------------------------------
