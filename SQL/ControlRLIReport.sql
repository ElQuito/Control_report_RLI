set ansi_nulls on
go

set quoted_identifier on
go


	----------------------------------------------------------------------------
	--#region Вспомогательные функции
	----------------------------------------------------------------------------

if  object_id('ddm_udf_rpt_GetBusinessCalendar') is null
	exec ('create function [dbo].[ddm_udf_rpt_GetBusinessCalendar] (@CardCalendarID uniqueidentifier, @iBeginDate datetime, @iEndDate datetime)
	returns @BusinessCalendar table (CalendarDate date, StartTime time, EndTime time)
as
begin
 
	with Calendar 
	as (
		select	cast(@iBeginDate as date) AS tDate
		union all
		select	dateadd(day , 1, tDate) AS tDate
		from	Calendar
		where	dateadd(day, 1, tDate) <= @iEndDate
	   ),
	BusinessCalendar as
	(

		select	distinct Calendar.tDate as CalendarDate
			,	isnull(CardCalendar_WorkTime.StartTime, CardCalendar_DefaultWorkTime.StartTime) as StartTime
			,	isnull(CardCalendar_WorkTime.EndTime, CardCalendar_DefaultWorkTime.EndTime) as EndTime
		from	Calendar
				left  join [dbo].[dvtable_{D8B0DEB3-FAE7-4C06-8728-B495985183C9}] CardCalendar_DefaultYears
						on CardCalendar_DefaultYears.InstanceID = @CardCalendarID
						and CardCalendar_DefaultYears.year = 1796
				left  join [dbo].[dvtable_{D8B0DEB3-FAE7-4C06-8728-B495985183C9}] CardCalendar_Years
						on CardCalendar_Years.InstanceID = @CardCalendarID
						and year(Calendar.tDate) = CardCalendar_Years.year
				left  join [dbo].[dvtable_{F12C1136-B351-4037-9DC9-21C042A238AF}] CardCalendar_DefaultDays
						on CardCalendar_DefaultYears.RowID = CardCalendar_DefaultDays.ParentRowID
						and Calendar.tDate = dateadd(day, CardCalendar_DefaultDays.DayNumber-1, cast(cast(CardCalendar_Years.[Year] as nvarchar(4)) + ''0101'' as datetime))
				left  join [dbo].[dvtable_{F12C1136-B351-4037-9DC9-21C042A238AF}] CardCalendar_Days
						on CardCalendar_Years.RowID = CardCalendar_Days.ParentRowID
						and Calendar.tDate = dateadd(day, CardCalendar_Days.DayNumber-1, cast(cast(CardCalendar_Years.[Year] as nvarchar(4)) + ''0101'' as datetime))
				left  join [dbo].[dvtable_{BF6C7A87-F8F5-4707-98E0-A33E10AE7EF2}] as CardCalendar_DefaultWorkTime
						on CardCalendar_DefaultDays.RowID = CardCalendar_DefaultWorkTime.ParentRowID
				left  join [dbo].[dvtable_{BF6C7A87-F8F5-4707-98E0-A33E10AE7EF2}] as CardCalendar_WorkTime
						on CardCalendar_Days.RowID = CardCalendar_WorkTime.ParentRowID
		 where ((@@datefirst+datepart(weekday,tdate)-2)%7+1 not in (6,7) or isnull(CardCalendar_Days.Type, CardCalendar_DefaultDays.Type) = 0)
		   and coalesce(CardCalendar_Days.Type, CardCalendar_DefaultDays.Type, 0) = 0
	),
	BuisnessCalendarWithDefaultWorkDays as 
	(
		select	BusinessCalendar.CalendarDate
			,	isnull(CardCalendar_DefaultWorkTime.StartTime, cast(''00:00:00'' as time)) as StartTime
			,	isnull(CardCalendar_DefaultWorkTime.EndTime, cast(''23:59:59.9999999'' as time)) as EndTime
		from	BusinessCalendar 
				left  join [dbo].[dvtable_{6A95F4B5-E86D-4464-99DA-BAFF7264453C}] as CardCalendar_DefaultWorkTime
						on CardCalendar_DefaultWorkTime.InstanceID = @CardCalendarID
		where	BusinessCalendar.StartTime is null
			and BusinessCalendar.EndTime is null
	)
	insert into @BusinessCalendar (CalendarDate, StartTime, EndTime)
	select	CalendarDate
		,	isnull(BusinessCalendar.StartTime, cast(''00:00:00'' as time)) as StartTime
		,	isnull(BusinessCalendar.EndTime, cast(''23:59:59.9999999'' as time)) as EndTime
	from BusinessCalendar where BusinessCalendar.StartTime is not null or BusinessCalendar.EndTime is not null
	union all
	select	CalendarDate, StartTime, EndTime
	from	BuisnessCalendarWithDefaultWorkDays
	order by 1, 2, 3
	option (maxrecursion 0);

	return;

end;')
go

if object_id('ddm_udf_rpt_IterGUIDSInStr_To_Table_Extend') is not null
	drop function dbo.ddm_udf_rpt_IterGUIDSInStr_To_Table_Extend;
go

create function dbo.ddm_udf_rpt_IterGUIDSInStr_To_Table_Extend
(
	@list      nvarchar(max), 
	@Delimiter nvarchar(20)
)
returns @splittedvalues table
(
	RowNum int not null	identity (1, 1),
	Id uniqueidentifier not null
)
as
begin
	
	declare @SplitLength int;
	
    if isnull(@delimiter, N'') = N''
      set @delimiter = N'}{';
    
    declare @uidPattern  nvarchar(300)
		,	@uidString nvarchar(200)
		,	@posDelim int
		,	@list_len int;
		
    set @uidPattern = N'[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]-[0-9A-F][0-9A-F][0-9A-F][0-9A-F]-[0-9A-F][0-9A-F][0-9A-F][0-9A-F]-[0-9A-F][0-9A-F][0-9A-F][0-9A-F]-[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]';
    
    set @list_len = len(@list);
    
    while len(@list) > 35
	begin
		set @SplitLength = patindex(N'%' + @delimiter + N'%', @list);

		select
		  @SplitLength = case @SplitLength
						 when 0 then @list_len
						 else @SplitLength - 1 end;
		-----
		set @uidString = replace(replace(substring(@list, 1, @SplitLength), '{', ''), '}', '');

		if @uidString LIKE @uidPattern --or @uidString like @uidPattern1
		  insert into @SplittedValues
		  select convert(uniqueidentifier, @uidString);
		-----
		select
		  @list = case (@list_len - @SplitLength)
				  when 0 then N''
				  else right(@list, @list_len - @SplitLength - 1) end;
		set @list_len = len(@list);
	end;
	
	return;
end;
go

if object_id('dbo.ddm_rpt_GetSearchList') is not null
  drop procedure dbo.ddm_rpt_GetSearchList;

go

create procedure dbo.ddm_rpt_GetSearchList
	@searchTerm nvarchar(100),
	@typedata nvarchar(50)
as
begin

	set transaction isolation level read uncommitted;

	set dateformat dmy;

	set nocount on;

	declare @resultlimit int = 10;

	if 	@typedata = 'Employees'
	begin

		select	top (@resultlimit) RowID, DisplayString as Name 
		from	[dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}]
		where	NotAvailable = 0 
			and DisplayString like @searchTerm+'%'
		order by DisplayString;

	end;
	
	if 	@typedata = 'EmployeesWithGroups'
	begin

		select top (@resultlimit) RefStaff_AlternateHierarchy.RowID, RefStaff_AlternateHierarchy.Name as Name 
		from [dbo].[dvtable_{5B607FFC-7EA2-47B1-90D4-BB72A0FE7280}] RefStaff_AlternateHierarchy
		where RefStaff_AlternateHierarchy.Name like @searchTerm+'%'
		union
		select	top (@resultlimit) RowID, DisplayString as Name 
		from	[dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}]
		where	NotAvailable = 0 
			and DisplayString like @searchTerm+'%'
		

	end;


	if 	@typedata = 'Units'
	begin

		select	top (@resultlimit) RowID, Name 
		from	[dvtable_{7473F07F-11ED-4762-9F1E-7FF10808DDD1}]
		where	NotAvailable = 0
			and Name like @searchTerm+'%'
		order by Name;

	end;
	
	if 	@typedata = 'CardKinds'
	begin
		
		with DT as 
		(
			select	RowID
				,	ParentTreeRowID
				,	cast(Name as nvarchar(300)) as Name
				,	1 as lvl 
			from	[dvtable_{C7BA000C-6203-4D7F-8C6B-5CB6F1E6F851}] DT
			where	NotAvailable = 0 
				and ParentRowID='E5962DFF-01D3-497B-9C3C-FBA1CEC27309'
				and ParentTreeRowID	!=	'00000000-0000-0000-0000-000000000000'
				and not exists (
								select 1 
								from	[dvtable_{C7BA000C-6203-4D7F-8C6B-5CB6F1E6F851}] DTT
								where	DTT.ParentTreeRowID=DT.RowID
								)
			union all
			select	DT.RowID
				,	DTT.ParentTreeRowID
				,	cast(DTT.Name+ ' - ' +DT.Name as nvarchar(300)) as Name
				,	dt.lvl+1 as lvl 
			from	DT
					inner join [dvtable_{C7BA000C-6203-4D7F-8C6B-5CB6F1E6F851}] DTT
							on DT.ParentTreeRowID=DTT.RowID
			where	DT.ParentTreeRowID!='00000000-0000-0000-0000-000000000000'
		)
		select	top (@resultlimit) RowID
			,	Name 
		from	DT
		where	ParentTreeRowID='00000000-0000-0000-0000-000000000000'
			and Name like @searchTerm+'%'
		order by Name;

	end;
	
	if 	@typedata = 'Companies'
	begin

		select	top (@resultlimit) RowID
			,	Name 
		from	[dvtable_{C78ABDED-DB1C-4217-AE0D-51A400546923}]
		where	NotAvailable = 0 
			and Name like @searchTerm+'%'
		order by Name;

	end;
	
	if 	@typedata = 'CompaniesEmployees'
	begin

		select	top (@resultlimit) PodrEmpl.RowID
			,	FIO + ' - ' +Podr.Name as Name
		from	[dbo].[dvtable_{1A46BF0F-2D02-4AC9-8866-5ADF245921E8}] PodrEmpl
				inner join [dbo].[dvtable_{C78ABDED-DB1C-4217-AE0D-51A400546923}] Podr
						on PodrEmpl.ParentRowID = Podr.RowID
				cross apply (
								select  LastName +
										isnull(' '+FirstName,'')+
										isnull(' '+MiddleName,'') FIO) FIO
		where	PodrEmpl.NotAvailable = 0 
			and Podr.NotAvailable = 0 
			and LastName is not null
			and FIO like @searchTerm+'%'
		order by 2;
		 		
	end;
	
	if 	@typedata = 'RefUniversalItem'
	begin
		
		with ItemType
		as
		(
			select  RowID
				,	cast(Name as nvarchar(3000)) ItemTypePath
			from	[dbo].[dvtable_{5E3ED23A-2B5E-47F2-887C-E154ACEAFB97}]
			union all
			select  ItemTypeUnChild.RowID
				,	cast(ItemType.ItemTypePath +'\'+ ItemTypeUnChild.Name as nvarchar(3000)) ItemTypePath 
			from	ItemType 
					inner join [dbo].[dvtable_{5E3ED23A-2B5E-47F2-887C-E154ACEAFB97}] ItemTypeUnChild
							on ItemTypeUnChild.ParentTreeRowID=ItemType.RowID
		)
		select	top (@resultlimit) RefUniversalItem.RowID
			,	Name +' - '+ItemTypePath as Name
		from	[dbo].[dvtable_{DD20BF9B-90F8-4D9A-9553-5B5F17AD724E}] RefUniversalItem
				inner join ItemType
						on RefUniversalItem.ParentRowID=ItemType.RowID
						and ItemTypePath like '%Способ выбора контрагента'
		where	NotAvailable = 0 
			and Name like @searchTerm+'%'
		order by Name;

	end;
	
	if 	@typedata = 'Categories'
	begin

		select	top (@resultlimit) RowID
			,	Name 
		from	[dbo].[dvtable_{899C1470-9ADF-4D33-8E69-9944EB44DBE7}]
		where	NotAvailable = 0 
			and Name like @searchTerm+'%'
		order by Name;

	end;

end;
go

	----------------------------------------------------------------------------
	--#endregion Вспомогательные функции
	--#region Основная хранимая процедура
	----------------------------------------------------------------------------
if object_id(N'[dbo].[ddm_rpt_ExpertiseSLAReport]') is not null
	drop procedure [dbo].[ddm_rpt_ExpertiseSLAReport];
go

create procedure [dbo].[ddm_rpt_ExpertiseSLAReport] 
	 @startRegDate date = null
	,@endRegDate date = null
	,@salesManIDs nvarchar(max) = null
	,@customerIDs nvarchar(max) = null
	,@expertIDs nvarchar(max) = null
	,@executionState int = 0
	,@groupingSet int = 3
	,@debug bit = 0
	,@documentType int = 0
	,@AppointedType int = 0
	,@counterpartyException int = 0
as
begin

	set transaction isolation level read uncommitted;

	set nocount on;
	
	create table #SalesMen (RowID uniqueidentifier);

	create table #Customers (RowID uniqueidentifier);
	
	create table #Experts (RowID uniqueidentifier);

	create table #resulttable
	(
		InstanceID uniqueidentifier,
		SalesMan nvarchar(max),
		Customer nvarchar(max),
		Signatory nvarchar(max),
		SignatoryContractor nvarchar(max),
		RegistrationNumber nvarchar(max),
		SystemNumber nvarchar(max),
		RegistrationDate date,
		Content nvarchar(max),
		CardTaskID uniqueidentifier,
		--IsNeededTask bit,
		Expert nvarchar(max),
		TaskText nvarchar(max),
		ControlTerm date,
		DaysToPerform nvarchar(max),
		PursuanceDocument uniqueidentifier,
		PursRegistrationNumber nvarchar(max),
		PursSystemNumber nvarchar(max),
		PursRegistrationDate date,
		PursStateName nvarchar(max),
		Reports nvarchar(max)
	);

	declare @WorkCalendar uniqueidentifier,
			@MaxDate datetime,
			@MinDate datetime;

	select	@WorkCalendar = convert(uniqueidentifier, Value)
	from	dbo.[dvtable_{641F6AFF-1187-491A-98D5-A735A6F97204}] SettingsCard_Extensions
			inner join dbo.[dvtable_{C9185C66-5104-45C2-A0A0-18787E69DC50}] SettingsCard_SettingGroups
					on SettingsCard_Extensions.RowID = SettingsCard_SettingGroups.ParentRowID
					and SettingsCard_SettingGroups.Name = 'CommonSettings'
			inner join dbo.[dvtable_{42BFBCAD-0407-4452-B60D-D1195CE035A1}] SettingsCard_Settings
					on SettingsCard_SettingGroups.RowID = SettingsCard_Settings.ParentRowID
					and SettingsCard_Settings.Name = 'WorkCalendar'
	where	SettingsCard_Extensions.name = 'DocsVision.DDM.Cards.SettingsCard.AddIn.DDMExtension';

	insert	into #SalesMen (RowID)
	select	Id
	from	dbo.ddm_udf_rpt_IterGUIDSInStr_To_Table_Extend(@salesManIDs, ';');
	
	insert	into #SalesMen (RowID)
	select	RefStaff_Employees.RowID
	from	#SalesMen sm_1
	INNER JOIN [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] RefStaff_Employees 
		ON RefStaff_Employees.ActiveEmployee = sm_1.RowID
	WHERE 	RefStaff_Employees.LastName NOT LIKE '%Арм_%';
	
	insert	into #Customers (RowID)
	select	Id
	from	dbo.ddm_udf_rpt_IterGUIDSInStr_To_Table_Extend(@customerIDs, ';');

	insert	into #Experts (RowID)
	select	Id
	from	dbo.ddm_udf_rpt_IterGUIDSInStr_To_Table_Extend(@expertIDs, ';');
	
	INSERT	INTO #Experts (RowID)
	SELECT RefStaff_Employees.RowID 
	FROM [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] RefStaff_Employees
		INNER JOIN  [dbo].[dvtable_{A960E37B-F1BD-4981-858D-AE9706E0571E}] RefStaff_Group
			ON  RefStaff_Group.EmployeeID = RefStaff_Employees.RowID
		INNER JOIN #Experts ExecGroup
			ON ExecGroup.RowID = RefStaff_Group.ParentRowID
	WHERE	RefStaff_Employees.NotAvailable = 0
	
	

	set @endRegDate = dateadd(day, 1, @endRegDate);

	insert into #resulttable
	(InstanceID,SalesMan,Customer,Signatory,SignatoryContractor,RegistrationNumber,SystemNumber,RegistrationDate,Content
	,CardTaskID,Expert,TaskText,ControlTerm,PursuanceDocument,PursRegistrationNumber
	,PursSystemNumber,PursRegistrationDate,PursStateName,Reports)
	select	DISTINCT CardRegistration_RegistrationData.InstanceID
		,	isnull(nullif(RefStaff_Employees_Performer.LastName, '') + ' ', '') + 
			isnull(left(nullif(RefStaff_Employees_Performer.FirstName, ''), 1) + '.', '') +
			isnull(left(nullif(RefStaff_Employees_Performer.MiddleName, ''), 1) + '.', '') as SalesMan
		,	RefPartners_Companies.Name as Customer
		,   RefStaff_Employees.DisplayString as Signatory
		,	isnull(nullif(RefPartners_Employees.LastName, '') + ' ', '') + 
			isnull(left(nullif(RefPartners_Employees.FirstName, ''), 1) + '.', '') +
			isnull(left(nullif(RefPartners_Employees.MiddleName, ''), 1) + '.', '') as SignatoryContractor
		,	CardRegistration_DDMSystem.RegistrationNumber
		,	CardRegistration_DDMSystem.SystemNumber
		,	CardRegistration_RegistrationData.RegistrationDate
		,	replace(CardRegistration_RegistrationData.Content, char(10), '#TPFS#') as Content
		,	CardTask_TaskData.InstanceID as CardTaskID
		--,	case when CardTask_System.RowID is null then 0
		--		 when CardTask_TaskData.InstanceID = CardTask_TaskData.RootTask and 
		--			  CardTask_DDMExecutionHierarchyData.RowID is null then 1
		--		 when CardTask_DDMExecutionHierarchyData.TreeLevel = 2 
		--			then 1
		--		 when CardTask_DDMExecutionHierarchyData.TreeLevel < 2 and
		--				  CardTask_DDMExecutionHierarchyData.IsLastTaskInBranch = 1
		--			then 1 
		--			else 0 end as IsNeededTask
		,	isnull(nullif(RefStaff_Employees_Executor.LastName, '') + ' ', '') + 
			isnull(left(nullif(RefStaff_Employees_Executor.FirstName, ''), 1) + '.', '') +
			isnull(left(nullif(RefStaff_Employees_Executor.MiddleName, ''), 1) + '.', '') as Expert
		,	replace(CardTask_TaskData.TaskText, char(10), '#TPFS#')				as TaskText
		,	CardTask_TaskData.ControlTerm
		,	CardTask_TaskData.PursuanceDocument
		,	CardRegistration_DDMSystem_Purs.RegistrationNumber as PursRegistrationNumber
		,	CardRegistration_DDMSystem_Purs.SystemNumber as PursSystemNumber
		,	CardRegistration_RegistrationData_Purs.RegistrationDate as PursRegistrationDate
		,	RefRoleModel_StateNames.Name as PursStateName
		,	stuff((	select	'#TPFS#' + 
							isnull(convert(nvarchar(10), CardTask_ExecutionHistory.CommentDate, 104), '') + ' ' +
							isnull(replace(CardTask_ExecutionHistory.Comment, char(10), '#TPFS#'), '') as 'data()'
					from	[dbo].[dvtable_{979FCE78-F6A7-46B0-A991-BD46D23C4EB9}] as CardTask_ExecutionHistory
					where	CardTask_TaskData.InstanceID = CardTask_ExecutionHistory.InstanceID
						and CardTask_ExecutionHistory.CommentType = 1
					order by CardTask_ExecutionHistory.CommentDate desc
					for xml path('')
				), 1, 6, '') as Reports
	from	[dbo].[dvtable_{F9D3EF11-A060-415A-BE69-DA9EFD3CA436}] as CardRegistration_RegistrationData
			inner join [dbo].[dvtable_{88E884FD-5FD2-4F8F-A8CF-53CB50A8C085}] as CardRegistration_DDMSystem
					on CardRegistration_RegistrationData.InstanceID = CardRegistration_DDMSystem.InstanceID
			inner join [dbo].[dvtable_{C7BA000C-6203-4D7F-8C6B-5CB6F1E6F851}] as RefKinds_CardKinds
					on CardRegistration_RegistrationData.Kind = RefKinds_CardKinds.RowID
			/*inner  join [dbo].[dvtable_{794E3A56-36F4-4A48-AC56-4CE21C794E26}] as CardTask_TaskData_1
					on CardRegistration_RegistrationData.InstanceID = CardTask_TaskData_1.RegCard*/
			left  join [dbo].[dvtable_{5A296B39-B9F1-406E-9CBC-1123067923C5}] as CardRegistration_Addressees
					on CardRegistration_RegistrationData.InstanceID = CardRegistration_Addressees.InstanceID
					and CardRegistration_Addressees.AddresseeType = 1 
					and (CardRegistration_Addressees.Type = 3 
						or CardRegistration_Addressees.Type = 0
						or CardRegistration_Addressees.Type = 2)
			left  join [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] as RefStaff_Employees
					on CardRegistration_Addressees.StaffEmpl = RefStaff_Employees.RowID
			left  join [dbo].[dvtable_{1A46BF0F-2D02-4AC9-8866-5ADF245921E8}] as RefPartners_Employees
					on CardRegistration_Addressees.PartnerEmpl = RefPartners_Employees.RowID
			left  join [dbo].[dvtable_{C78ABDED-DB1C-4217-AE0D-51A400546923}] as RefPartners_Companies
					on CardRegistration_Addressees.PartnerOrg = RefPartners_Companies.RowID
			left  join #Customers cm
					on CardRegistration_Addressees.PartnerOrg = cm.RowID
			left  join [dbo].[dvtable_{794E3A56-36F4-4A48-AC56-4CE21C794E26}] as CardTask_TaskData
					on CardRegistration_RegistrationData.InstanceID = CardTask_TaskData.RegCard
				--	and CardTask_TaskData.AppointedType = 0
			left  join [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] as RefStaff_Employees_Performer
					on CardTask_TaskData.Author = RefStaff_Employees_Performer.RoWID
			left  join #SalesMen sm
					on CardTask_TaskData.Author = sm.RowID
			left  join [dbo].[dvtable_{45b77db4-f692-46ee-86e4-1e3dac177d7c}] as CardTask_System
					on CardTask_TaskData.InstanceID = CardTask_System.InstanceID
					and CardTask_System.State not in ('{4f4a7f13-5f9f-457b-86fa-7aaee4efa31a}','{569a4281-6e78-4bba-b06e-a0a9117cb003}', '{53b0e1da-a55b-4677-9fdc-9e614ef61d69}') --Аннулировано
			--left  join [dbo].[dvtable_{676384FB-D96F-41E3-893F-00CCFF4A00B9}] as CardTask_DDMExecutionHierarchyData
			--		on CardTask_TaskData.InstanceID = CardTask_DDMExecutionHierarchyData.InstanceID
			left  join [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] as RefStaff_Employees_Executor
					on CardTask_TaskData.Executes = RefStaff_Employees_Executor.RowID
			left  join #Experts exs
					on CardTask_TaskData.Executes = exs.RowID
			left  join [dbo].[dvtable_{F9D3EF11-A060-415A-BE69-DA9EFD3CA436}] as CardRegistration_RegistrationData_Purs
					on CardTask_TaskData.PursuanceDocument = CardRegistration_RegistrationData_Purs.InstanceID
			left  join [dbo].[dvtable_{88E884FD-5FD2-4F8F-A8CF-53CB50A8C085}] as CardRegistration_DDMSystem_Purs
					on CardRegistration_RegistrationData_Purs.InstanceID = CardRegistration_DDMSystem_Purs.InstanceID
			left  join [dbo].[dvtable_{BE963903-8360-4020-A2E0-016C74CBFB02}] as CardRegistration_System_Purs
					on CardRegistration_RegistrationData_Purs.InstanceID = CardRegistration_System_Purs.InstanceID
			left  join [dbo].[dvtable_{DA37CA71-A977-48E9-A4FD-A2B30479E824}] as RefRoleModel_StateNames
					on CardRegistration_System_Purs.State = RefRoleModel_StateNames.ParentRowID
					and RefRoleModel_StateNames.LocaleID = 1049
	where  CardRegistration_DDMSystem.RegistrationNumber is not null
	--and (RefStaff_Employees_Performer.ActiveEmployee=sm.RowID)
	--and ( sm.RowID=@salesManIDs)
	
		and ((@AppointedType = 0 and CardTask_TaskData.AppointedType = 0)
			or
			(@AppointedType = 1 and CardTask_TaskData.AppointedType between 0 and 2))
		and ((@documentType = 1 and CardRegistration_DDMSystem.Type = 0)
			or
			(@documentType = 2 and CardRegistration_DDMSystem.Type = 2)
			or
			(@documentType = 0 and (CardRegistration_DDMSystem.Type = 2 or CardRegistration_DDMSystem.Type = 0)))
		and (@startRegDate is null or cast(CardTask_TaskData.ControlTerm as date) >= @startRegDate)
		and (@endRegDate is null or cast(CardTask_TaskData.ControlTerm as date) < @endRegDate)
		and ((@counterpartyException = 0 and CardRegistration_Addressees.PartnerOrg not in (select RowID from #Customers)) or 
		(@counterpartyException = 1 and (not exists(select 1 from #Customers) or cm.RowID is not null)))
		and (not exists(select 1 from #SalesMen) or sm.RowID is not null)
		--and (not exists(select 1 from #Customers) or cm.RowID is not null)
		and (not exists(select 1 from #Experts) or (exs.RowID is not null))
--		and (CardTask_DDMExecutionHierarchyData.TreeLevel = 2 or
												--	 (CardTask_DDMExecutionHierarchyData.TreeLevel < 2 and
												--	  CardTask_DDMExecutionHierarchyData.IsLastTaskInBranch = 1))))
													 
		and (
			(@executionState = 0 and 
			CardTask_System.State not in ('{4f4a7f13-5f9f-457b-86fa-7aaee4efa31a}','{569a4281-6e78-4bba-b06e-a0a9117cb003}', '{53b0e1da-a55b-4677-9fdc-9e614ef61d69}'))
			or
			(@executionState = 1 and 
			CardTask_System.State not in ('{4f4a7f13-5f9f-457b-86fa-7aaee4efa31a}','{569a4281-6e78-4bba-b06e-a0a9117cb003}', '{53b0e1da-a55b-4677-9fdc-9e614ef61d69}')
			and
			cast(CardTask_TaskData.ControlTerm as date) < cast(getdate() as date)
			)
		);
		
	--delete 
	--from	rt
	--from	#resulttable rt
	--where	IsNeededTask = 0
	--	and exists (select * from #resulttable rt1 where rt.InstanceID = rt1.InstanceID and rt1.IsNeededTask = 1);

	select	@MaxDate = max(ControlTerm)
	from	#resultTable;
	
	select	@MinDate = min(ControlTerm)
	from	#resultTable;

	if (@MaxDate is not null)
	begin
		
	with pretable as
	(	select	CardTaskID
			, 'Осталось ' + cast(count(bc.CalendarDate) as nvarchar(max)) + 
							case	when count(bc.CalendarDate) % 100 between 11 and 19 then N' дней'
									when count(bc.CalendarDate) % 10 = 1 then N' день'
									when count(bc.CalendarDate) % 10 between 2 and 4 then N' дня'
									else ' дней'
								end	 as DaysToPerform
		from	#resultTable 
				left  join [dbo].[ddm_udf_rpt_GetBusinessCalendar] (@WorkCalendar, getdate(), @MaxDate) bc
						on cast(ControlTerm as date) >= bc.CalendarDate
						and cast(getdate() as date)  <= bc.CalendarDate
		where	cast(ControlTerm as date) >= cast(getdate() as date) 
		group by CardTaskID
	)
	update	rt
	set		DaysToPerform = pt.DaysToPerform
	from	#resultTable rt
			inner join pretable pt
					on rt.CardTaskID = pt.CardTaskID;
					
	

	end;
	
	if (@MinDate is not null)
	begin
		
	with pretable as
	(	select	CardTaskID
			, 'Просрочено на '+cast(count(bc.CalendarDate) as nvarchar(max)) + 
							case	when count(bc.CalendarDate) % 100 between 11 and 19 then N' дней'
									when count(bc.CalendarDate) % 10 = 1 then N' день'
									when count(bc.CalendarDate) % 10 between 2 and 4 then N' дня'
									else ' дней'
								end	 as DaysToPerform
		from	#resultTable 
				left  join [dbo].[ddm_udf_rpt_GetBusinessCalendar] (@WorkCalendar, @MinDate, getdate()) bc
						on cast(ControlTerm as date) <= bc.CalendarDate
						and cast(getdate() as date)  > bc.CalendarDate
		where	cast(ControlTerm as date) < cast(getdate() as date)
		group by CardTaskID
	)
	update	rt
	set		DaysToPerform = pt.DaysToPerform
	from	#resultTable rt
			inner join pretable pt
					on rt.CardTaskID = pt.CardTaskID;
					
	

	end;

	insert into #resulttable
	(SalesMan)
	select	isnull(nullif(RefStaff_Employees_Performer.LastName, '') + ' ', '') + 
			isnull(left(nullif(RefStaff_Employees_Performer.FirstName, ''), 1) + '.', '') +
			isnull(left(nullif(RefStaff_Employees_Performer.MiddleName, ''), 1) + '.', '') as SalesMan
	from	#SalesMen sm
			inner join [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] as RefStaff_Employees_Performer
					on sm.RowID = RefStaff_Employees_Performer.RowID
	where	not exists (select * from #resulttable rt 
						where rt.SalesMan = isnull(nullif(RefStaff_Employees_Performer.LastName, '') + ' ', '') + 
											isnull(left(nullif(RefStaff_Employees_Performer.FirstName, ''), 1) + '.', '') +
											isnull(left(nullif(RefStaff_Employees_Performer.MiddleName, ''), 1) + '.', '') collate Cyrillic_General_CI_AS
						);
						

		
	insert into #resulttable
	(Customer)
	select	RefPartners_Companies.Name as Customer
	from	#Customers cm
			inner join [dbo].[dvtable_{C78ABDED-DB1C-4217-AE0D-51A400546923}] as RefPartners_Companies
					on cm.RowID = RefPartners_Companies.RowID
	where	not exists (select * from #resulttable rt 
						where rt.Customer = RefPartners_Companies.Name collate Cyrillic_General_CI_AS
						);

	insert into #resulttable
	(Expert)
	select	isnull(nullif(RefStaff_Employees_Performer.LastName, '') + ' ', '') + 
			isnull(left(nullif(RefStaff_Employees_Performer.FirstName, ''), 1) + '.', '') +
			isnull(left(nullif(RefStaff_Employees_Performer.MiddleName, ''), 1) + '.', '') as Expert
	from	#Experts sm
			inner join [dbo].[dvtable_{DBC8AE9D-C1D2-4D5E-978B-339D22B32482}] as RefStaff_Employees_Performer
					on sm.RowID = RefStaff_Employees_Performer.RowID
	where	not exists (select * from #resulttable rt 
						where rt.Expert = isnull(nullif(RefStaff_Employees_Performer.LastName, '') + ' ', '') + 
											isnull(left(nullif(RefStaff_Employees_Performer.FirstName, ''), 1) + '.', '') +
											isnull(left(nullif(RefStaff_Employees_Performer.MiddleName, ''), 1) + '.', '') collate Cyrillic_General_CI_AS
						);
	
	select	rt.InstanceID, rt.SalesMan, isnull(rt.Customer, isnull(rt.Signatory, rt.SignatoryContractor)) as Customer, rt.RegistrationNumber, rt.SystemNumber
		,	convert(nvarchar(10), rt.RegistrationDate, 104) as RegistrationDate
		,	rt.Content,rt.CardTaskID, rt.Expert, rt.TaskText, convert(nvarchar(10), rt.ControlTerm, 104) as ControlTerm
		,	rt.PursuanceDocument, rt.PursRegistrationNumber, rt.PursSystemNumber
		,	convert(nvarchar(10), rt.PursRegistrationDate, 104) as PursRegistrationDate, rt.PursStateName, rt.Reports
		,	case @groupingSet	when 0 then rt.SalesMan
								when 1 then isnull(rt.Customer, isnull(rt.Signatory, rt.SignatoryContractor))
								when 2 then rt.Expert
								else N'' end as groupingSet
		,	rt.DaysToPerform as ExpCategory
		, CONVERT(nvarchar(10),GETDATE(),104) as today
	from	#resulttable as rt
	order by groupingSet, rt.RegistrationDate, rt.RegistrationNumber, rt.SystemNumber;

end;

go

	----------------------------------------------------------------------------
	--#endregion Основная хранимая процедура
	----------------------------------------------------------------------------

--------------------------------------------------------------------------------
--#endregion	Хранимые процедуры и функции
--------------------------------------------------------------------------------