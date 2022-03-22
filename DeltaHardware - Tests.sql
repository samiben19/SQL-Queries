use DeltaHardware
go

------- Creare view-uri -------
create or alter view vw_view1 as
	select * from Vendori;

go

create or alter view vw_view2 as
	select P.Denumire, P.Vendor, V.Email, P.Pret 
	from Procesoare as P
	inner join Vendori as V
	on P.Vendor = V.Denumire
	where P.Pret > 750;

go

create or alter view vw_view3 as
	select P.Vendor, sum(WP.Cantitate) as CantitateVanduta
	from Procesoare as P
	inner join Wishlists_Procesoare as WP
	on P.IdProcesor = WP.IdProcesor
	group by P.Vendor;

go

select * from vw_view1
select * from vw_view2
select * from vw_view3

insert into Views (Name) values
('vw_view1'), ('vw_view2'), ('vw_view3')

insert into Tables (Name) values
('Vendori'), ('Procesoare'), ('Wishlists_Procesoare')

insert into Tests (Name) values
('delete_table'), ('insert_table'), ('select_view')

insert into TestTables(TestID, TableID, NoOfRows, Position) values
(1,1,1000,3),
(1,2,1000,2),
(1,3,1000,1),
(2,1,1000,1),
(2,2,1000,2),
(2,3,1000,3)

insert into TestViews(TestID, ViewID) values
(3, 1), (3, 2), (3, 3)
go
----------------------- Proceduri -----------------------
create or alter procedure delete_vendori
as
begin
	--declare @NoOfRows int
	--select top 1 @NoOfRows = NoOfRows
	--from TestTables
	--inner join Tables
	--on TestTables.TableID = Tables.TableID
	--inner join Tests
	--on Tests.TestID = TestTables.TestID and Tests.Name = 'delete_table'
	--where Tables.Name = 'Vendori'

	--delete from Vendori 
	--where IdVendor in (select top (@NoOfRows) IdVendor from Vendori order by IdVendor desc)

	--declare @IdMax int
	--select @IdMax = max(IdVendor) from Vendori
	--dbcc checkident('Vendori', reseed, @IdMax) WITH NO_INFOMSGS;
	delete from Vendori
	dbcc checkident('Vendori', reseed, 0) WITH NO_INFOMSGS;
end
go

create or alter procedure delete_procesoare
as
begin
	--declare @NoOfRows int
	--select top 1 @NoOfRows = NoOfRows
	--from TestTables
	--inner join Tables
	--on TestTables.TableID = Tables.TableID
	--inner join Tests
	--on Tests.TestID = TestTables.TestID and Tests.Name = 'delete_table'
	--where Tables.Name = 'Procesoare'

	--delete from Procesoare
	--where IdProcesor in (select top(@NoOfRows) IdProcesor from Procesoare order by IdProcesor desc)

	--declare @IdMax int
	--select @IdMax = max(IdProcesor) from Procesoare
	--dbcc checkident('Procesoare', reseed, @IdMax) WITH NO_INFOMSGS;
	delete from Procesoare
	dbcc checkident('Procesoare', reseed, 0) WITH NO_INFOMSGS;
end
go

create or alter procedure delete_wishlist
as
begin
	--declare @NoOfRows int
	--select top 1 @NoOfRows = NoOfRows
	--from TestTables
	--inner join Tables
	--on TestTables.TableID = Tables.TableID
	--inner join Tests
	--on Tests.TestID = TestTables.TestID and Tests.Name = 'delete_table'
	--where Tables.Name = 'Wishlists_Procesoare'

	--delete from Wishlists_Procesoare
	--where IdProcesor in (select top(@NoOfRows) IdProcesor from Procesoare order by IdProcesor desc)
	delete from Wishlists_Procesoare
end
go

create or alter procedure insert_vendori
as
begin
	declare @NoOfRows int
	select top 1 @NoOfRows = NoOfRows
	from TestTables
	inner join Tables
	on TestTables.TableID = Tables.TableID
	inner join Tests
	on Tests.TestID = TestTables.TestID and Tests.Name = 'insert_table'
	where Tables.Name = 'Vendori'

	declare @introdusi int = 1
	declare @id int
	
	select @id = max(IdVendor) + 1 from Vendori
	if @id is null
		set @id = 1
		

	while @introdusi <= @NoOfRows
	begin
		declare @denumire varchar(20)
		set @denumire = concat('Denumire', convert(varchar(20), @id))

		declare @email varchar(20)
		set @email = concat(convert(varchar(20), @id), '@yahoo.com')

		insert into Vendori(Denumire, Telefon, Email)
		values (@denumire, @id, @email)

		set @id = @id + 1
		set @introdusi = @introdusi + 1
	end
end
go

create or alter procedure insert_procesoare
as
begin
	declare @NoOfRows int
	select top 1 @NoOfRows = NoOfRows
	from TestTables
	inner join Tables
	on TestTables.TableID = Tables.TableID
	inner join Tests
	on Tests.TestID = TestTables.TestID and Tests.Name = 'insert_table'
	where Tables.Name = 'Procesoare'

	declare @introdusi int = 1
	declare @id int
	
	select @id = max(IdProcesor) + 1 from Procesoare
	if @id is null
		set @id = 1

	while @introdusi <= @NoOfRows
	begin
		declare @denumire varchar(20)
		set @denumire = concat('TestProcesor', convert(varchar(20), @id))

		declare @fk varchar(50)
		select top 1 @fk = Denumire from Vendori where Vendori.IdVendor = (select max(IdVendor) from Vendori)

		declare @nuclee int
		set @nuclee = floor(RAND()*127+1)
		if @nuclee%2 != 0
			set @nuclee = @nuclee + 1

		declare @arhitectura int
		set @arhitectura = floor(RAND()*31+1)
		if @arhitectura%2 != 0
			set @arhitectura = @arhitectura + 1

		insert into Procesoare(Denumire, Vendor, Frecventa, Nuclee, Arhitectura, Unlocked, Pret)
		values (@denumire, @fk ,RAND()*(7-1)+1, @nuclee, @arhitectura, floor(rand()*2),rand()*10000+1)

		set @id = @id + 1
		set @introdusi = @introdusi + 1
	end
end
go

create or alter procedure insert_wishlist
as
begin
	declare @NoOfRows int
	select top 1 @NoOfRows = NoOfRows
	from TestTables
	inner join Tables
	on TestTables.TableID = Tables.TableID
	inner join Tests
	on Tests.TestID = TestTables.TestID and Tests.Name = 'insert_table'
	where Tables.Name = 'Wishlists_Procesoare'

	declare @exista int
	select top 1 @exista = IdWishlist from Wishlists
	if @exista is null
		insert into Wishlists(Denumire) values ('TestWishlist')

	select IdWishlist, IdProcesor, IdProcesor as Cantitate
	into #Temp
	from Procesoare cross join Wishlists where IdProcesor < @NoOfRows

	insert into Wishlists_Procesoare
	select top (@NoOfRows) IdWishlist, IdProcesor, Cantitate
	from #Temp

	drop table #Temp
end
go

create or alter procedure delete_table
(@position int)
as
begin
	if @position >= 1
		exec delete_wishlist
	if @position >= 2
		exec delete_procesoare
	if @position >= 3
		exec delete_vendori
end
go

create or alter procedure insert_table
(@position int)
as
begin
	if @position >= 1
		exec insert_vendori
	if @position >= 2
		exec insert_procesoare
	if @position >= 3
		exec insert_wishlist
end
go

create or alter procedure view_table
(@position int)
as
begin
	if @position = 1
		select * from vw_view1
	if @position = 2
		select * from vw_view2
	if @position = 3
		select * from vw_view3
end
go

create or alter procedure test_all
as
begin
	set nocount on
	delete from TestRunTables
	delete from TestRunViews
	delete from TestRuns
	dbcc checkident ('TestRuns', reseed, 0) WITH NO_INFOMSGS;

	-- Salvam inregistrarile existente
	select *
	into #OldVendori
	from Vendori

	select *
	into #OldProcesoare
	from Procesoare

	select *
	into #OldWish
	from Wishlists_Procesoare

	select *
	into #OldWishGpu
	from Wishlists_PlaciVideo

	select *
	into #OldGpu
	from PlaciVideo

	delete from Wishlists_Procesoare
	delete from Procesoare
	delete from Wishlists_PlaciVideo
	delete from PlaciVideo
	delete from Vendori

	dbcc checkident ('Procesoare', reseed, 0) WITH NO_INFOMSGS;
	dbcc checkident ('PlaciVideo', reseed, 0) WITH NO_INFOMSGS;
	dbcc checkident ('Wishlists_PlaciVideo', reseed, 0) WITH NO_INFOMSGS;
	dbcc checkident ('Vendori', reseed, 0) WITH NO_INFOMSGS;

	-- Se introduc date din toate tabelele pentru a avea de unde sterge
	exec insert_table 3

	declare @nrTabele int
	select @nrTabele = count(TableID) from Tables
	declare @i int
	declare @j int
	set @i = 1
	set @j = @nrTabele

	while @i <= @nrTabele
	begin
		--select * from TestTables order by TableID asc, TestID desc

		DECLARE @start DATETIME	-- start time test
		DECLARE @inter DATETIME	-- intermediate time test
		DECLARE @final DATETIME	-- end time test

		SET @start = GETDATE()
		exec delete_table @j	-- delete from table
		exec insert_table @i	-- insert into table

		SET @inter = GETDATE()
		exec view_table @i		-- evaluate (select from) view

		SET @final = GETDATE()
		-- if you want to see the difference of these 2 times, you can use DATEDIFF
		
		declare @description varchar(50)
		declare @nume varchar(50)
		select @nume = Name from Tables where TableID = @i
		set @description = 'Test tabela ' + @nume + ' si view' + convert(varchar(50),@i) 
		
		insert into TestRuns(Description, StartAt, EndAt)
		values (@description, @start, @final)

		insert into TestRunTables(TestRunID, TableID, StartAt, EndAt)
		values (@i, @i, @start, @inter)

		insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt)
		values (@i, @i, @inter, @final)

		print('Testul ' + convert(varchar(10), @i) + ' a durat ' + convert(varchar(10), datediff(millisecond, @start, @final)))

		set @i = @i + 1
		set @j = @j - 1
	end

	-- Curatarea de dupa teste
	exec delete_table 3

	-- Inserarea inapoi a vechilor inregistrari
	set identity_insert Vendori on
	insert into Vendori(Denumire, Telefon, Email, IdVendor) select * from #OldVendori
	set identity_insert Vendori off
	drop table #OldVendori

	set identity_insert Procesoare on
	insert into Procesoare(IdProcesor, Denumire, Vendor, Frecventa, Nuclee, Arhitectura, Unlocked, Pret) select * from #OldProcesoare
	set identity_insert Procesoare off
	drop table #OldProcesoare

	set identity_insert PlaciVideo on
	insert into PlaciVideo(IdPlacaVideo, Denumire, Vendor, Frecventa, Memorie, Tip_Memorie, Suport_DXR, Pret) select * from #OldGpu
	set identity_insert PlaciVideo off
	drop table #OldGpu

	set identity_insert Wishlists_PlaciVideo on
	insert into Wishlists_PlaciVideo(ID, IdWishlist, IdPlacaVideo) select * from #OldWishGpu
	set identity_insert Wishlists_PlaciVideo off
	drop table #OldWishGpu

	insert into Wishlists_Procesoare select * from #OldWish
	drop table #OldWish
	set nocount off
end
go

exec insert_vendori
exec insert_procesoare
exec insert_wishlist

exec delete_wishlist
exec delete_procesoare
exec delete_vendori

exec test_all
select * from TestRunTables
select * from TestRunViews
select * from TestRuns

use master

select * from Vendori order by IdVendor
select * from Procesoare
select * from Wishlists_Procesoare

select * from Tests
select * from Tables
select * from Views
select * from TestTables
select * from TestViews
select * from TestRunTables
select * from TestRunViews
select * from TestRuns

select Tests.TestID, Tests.Name, Tables.Name, TestTables.Position from Tests
inner join TestTables
on Tests.TestID = TestTables.TestID
inner join Tables
on Tables.TableID = TestTables.TableID
order by Tables.TableID, Tests.TestID

--dbcc checkident('Procesoare', reseed, 0);

use master

use DeltaHardware