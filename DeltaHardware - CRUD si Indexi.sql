use DeltaHardware
-- Salvare date
select *
into #Vendori
from Vendori

select *
into #Procesoare
from Procesoare

select *
into #Wishlists_Procesoare
from Wishlists_Procesoare

select *
into #PlaciVideo
from PlaciVideo

select * 
into #Wishlists_PlaciVideo
from Wishlists_PlaciVideo

delete from Wishlists_PlaciVideo
delete from PlaciVideo
delete from Wishlists_Procesoare
delete from Procesoare
delete from Vendori

dbcc checkident ('Vendori', reseed, 0) WITH NO_INFOMSGS;
dbcc checkident ('Procesoare', reseed, 0) WITH NO_INFOMSGS;
dbcc checkident ('PlaciVideo', reseed, 0) WITH NO_INFOMSGS;

-- Reintroducere date
set identity_insert Vendori on
insert into Vendori(Denumire, Telefon, Email, IdVendor) select * from #Vendori
set identity_insert Vendori off
drop table #Vendori

set identity_insert Procesoare on
insert into Procesoare(IdProcesor, Denumire, Vendor, Frecventa, Nuclee, Arhitectura, Unlocked, Pret) select * from #Procesoare
set identity_insert Procesoare off
drop table #Procesoare

insert into Wishlists_Procesoare select * from #Wishlists_Procesoare
drop table #Wishlists_Procesoare

set identity_insert PlaciVideo on
insert into PlaciVideo(IdPlacaVideo, Denumire, Vendor, Frecventa, Memorie, Tip_Memorie, Suport_DXR, Pret) select * from #PlaciVideo
set identity_insert PlaciVideo off
drop table #PlaciVideo

set identity_insert Wishlists_PlaciVideo on
insert into Wishlists_PlaciVideo(ID, IdWishlist, IdPlacaVideo) select * from #Wishlists_PlaciVideo
set identity_insert Wishlists_PlaciVideo off
drop table #Wishlists_PlaciVideo

select * from Vendori
select * from Procesoare
select * from Wishlists_Procesoare
go


-------------- CRUD --------------
-- 1. Vendori
create or alter function validare_vendor(@denumire varchar(50), @telefon varchar(10), @email varchar(50))
returns int
begin
	if len(@denumire) = 0 or len(@telefon) = 0 or len(@email) = 0
		return 0
	if len(@telefon) != 0
		if isnumeric(@telefon) = 0
			return 0
	return 1
end
go

create or alter procedure CRUD_vendori
@denumire varchar(50),
@telefon varchar(10),
@email varchar(50),
@NoRows int
as
begin
	-- validare
	declare @validare_date int = (select dbo.validare_vendor(@denumire,@telefon,@email))
	if @validare_date = 0
	begin
		print 'Date invalide !'
		return
	end

	-- C
	declare @i int = 0
	while @i < @NoRows
	begin
		declare @denumire_cu_numar varchar(50)
		set @denumire_cu_numar = concat(@denumire, @i+1)
		insert into Vendori(Denumire, Telefon, Email)
		values (@denumire_cu_numar, @telefon, @email)
		set @i = @i + 1
	end

	-- R
	select * from Vendori
	where Telefon = @telefon and Email = @email

	-- U
	update Vendori
	set Telefon = '112800800'
	where Telefon = @telefon and Email = @email

	-- D
	delete from Vendori
	where Telefon = '112800800' and Email = @email

	print 'CRUD pentru Vendori realizat cu succes !'
end

dbcc checkident ('Vendori', reseed, 0);
exec CRUD_vendori 'denumire', '123456', 'mail@mail.com', 50
exec CRUD_vendori '', '123456', 'mail@mail.com', 50
exec CRUD_vendori 'denumire', '123a456', 'mail@mail.com', 50
exec CRUD_vendori 'denumire', '123456', '', 50
go


-- 2. Procesoare
--IdProcesor, Denumire, Vendor, Frecventa, Nuclee, 
 --Arhitectura, Unlocked, Pret

create or alter function validare_procesor
(@denumire varchar(50), @vendor varchar(50), @frecventa float,
@nuclee int, @arhitectura int, @unlocked bit, @pret float)
returns int
begin
	if len(@denumire) = 0 or len(@vendor) = 0 or
		@nuclee <= 0 or @arhitectura <= 0 or @pret <= 0
		return 0
	if not exists (select * from Vendori where Denumire = @vendor)
		return 0
	if @frecventa <= 0 or @frecventa >= 7
		return 0
	if @nuclee % 2 != 0
		return 0
	return 1
end
go

create or alter procedure CRUD_procesoare
@denumire varchar(50),
@vendor varchar(50), 
@frecventa float,
@nuclee int, 
@arhitectura int, 
@unlocked bit, 
@pret float,
@NoRows int
as
begin
	-- validare
	declare @validare_date int = (select dbo.validare_procesor(@denumire, @vendor, @frecventa,
				@nuclee, @arhitectura, @unlocked, @pret))
	if @validare_date = 0
	begin
		print 'Date invalide !'
		return
	end

	-- C
	declare @i int = 0
	while @i < @NoRows
	begin
		declare @denumire_cu_numar varchar(50)
		set @denumire_cu_numar = concat(@denumire, @i+1)
		insert into Procesoare(Denumire, Vendor, Frecventa,
								Nuclee, Arhitectura, Unlocked, Pret)
		values (@denumire_cu_numar, @vendor, @frecventa,
				@nuclee, @arhitectura, @unlocked, @pret)
		set @i = @i + 1
	end

	-- R
	select * from Procesoare
	where Vendor = @vendor and Frecventa = @frecventa
	and Nuclee = @nuclee and Arhitectura = @arhitectura
	and Unlocked = @unlocked and Pret = @pret

	-- U
	update Procesoare
	set Pret = 112800800
	where Vendor = @vendor and Frecventa = @frecventa
	and Nuclee = @nuclee and Arhitectura = @arhitectura
	and Unlocked = @unlocked and Pret = @pret

	-- D
	delete from Procesoare
	where Vendor = @vendor and Frecventa = @frecventa
	and Nuclee = @nuclee and Arhitectura = @arhitectura
	and Unlocked = @unlocked and Pret = 112800800

	print 'CRUD pentru Procesoare realizat cu succes !'
end

insert into Vendori(Denumire)
values ('AMD')
delete from Vendori
dbcc checkident ('Vendori', reseed, 0);

dbcc checkident ('Procesoare', reseed, 0);
exec CRUD_procesoare 'denumire', 'AMD', 4.7, 8, 7, 1, 1200, 50 
exec CRUD_procesoare '', 'AMD', 4.7, 8, 7, 1, 1200, 50
exec CRUD_procesoare 'denumire', 'Intel', 4.7, 8, 7, 1, 1200, 50 
exec CRUD_procesoare 'denumire', 'AMD', 9.7, 8, 7, 1, 1200, 50 
exec CRUD_procesoare 'denumire', 'AMD', 4.7, 11, 7, 1, 1200, 50 
exec CRUD_procesoare 'denumire', 'AMD', 4.7, 8, -1, 1, 1200, 50 
exec CRUD_procesoare 'denumire', 'AMD', 4.7, 8, 7, 1, -100, 50 

go


-- 3. Wishlist_Procesoare
create or alter function validare_wish_procesor 
(@idWishlist int, @idProcesor INT, @cantiate int, @noRows int)
returns int
begin
	if not exists (select * from Wishlists where IdWishlist = @idWishlist)
		return 0
	if not exists (select * from Procesoare where IdProcesor = @idProcesor)
		return 0
	if @idProcesor + @noRows - 1 > (select max(IdProcesor) from Procesoare)
		return 0
	if @cantiate <= 0
		return 0
	RETURN 1
end

go

create or alter procedure CRUD_wish_procesoare
@idWishlist int,
@idProcesor INT,
@cantiate int,
@NoRows int
as
begin
-- validare
	declare @validare_date int = 
	(select dbo.validare_wish_procesor(@idWishlist, @idProcesor, @cantiate, @NoRows))
	if @validare_date = 0
	begin
		print 'Date invalide !'
		return
	end

	-- C
	declare @i int = 0
	while @i < @NoRows
	begin
		insert into Wishlists_Procesoare(IdWishlist, IdProcesor, Cantitate)
		values (@idWishlist, @idProcesor + @i, @cantiate)
		set @i = @i + 1
	end

	-- R
	select * from Wishlists_Procesoare
	where IdWishlist = @idWishlist and Cantitate = @cantiate
	and IdProcesor >= @idProcesor and IdProcesor <= @idProcesor + @NoRows - 1

	-- U
	update Wishlists_Procesoare
	set Cantitate = 112800800
	where IdWishlist = @idWishlist and Cantitate = @cantiate
	and IdProcesor >= @idProcesor and IdProcesor <= @idProcesor + @NoRows - 1

	-- D
	delete from Wishlists_Procesoare
	where IdWishlist = @idWishlist and Cantitate = 112800800
	and IdProcesor >= @idProcesor and IdProcesor <= @idProcesor + @NoRows - 1

	print 'CRUD pentru Wishlists_Procesoare realizat cu succes !'
END

-- testele
go
create or alter procedure Insert_Procesoare
@nr int
as
begin
declare @i int = 0
	while @i < @nr
	begin
		declare @denumire_cu_numar varchar(50)
		set @denumire_cu_numar = concat('procesor', @i+1)
		insert into Procesoare(Denumire, Vendor, Frecventa,
								Nuclee, Arhitectura, Unlocked, Pret)
		values (@denumire_cu_numar, 'AMD', 4.9, 
				16, 7, 1, 3899.99);
		set @i = @i + 1
	end
end


insert into Vendori(Denumire)
values ('AMD')
delete from Vendori
dbcc checkident ('Vendori', reseed, 0);

exec Insert_Procesoare 50
delete from Procesoare
dbcc checkident ('Procesoare', reseed, 0);

select * from Vendori
select * from Procesoare
select * from Wishlists_Procesoare

exec CRUD_wish_procesoare 1, 1, 12, 50
exec CRUD_wish_procesoare 10000, 1, 12, 50
exec CRUD_wish_procesoare 1, 5, 12, 50
exec CRUD_wish_procesoare 1, 1, -5, 50


-------------- Indexi --------------
create nonclustered index IX_Vendori_ID on
Vendori (IdVendor)

create nonclustered index IX_Vendori_Denumire on
Vendori (Denumire)


drop index IX_Vendori_ID on Vendori
drop index IX_Vendori_Denumire on Vendori

go

-------------- View-uri --------------
create or alter view vw_Vendori as
	select top 50 *
	from Vendori as V
	order by IdVendor;
go

create or alter view vw_VendoriProcesoare as
	select top 50 P.Denumire, P. Vendor, P.Nuclee, P.Pret 
	from Procesoare as P
	inner join Vendori as V
	on V.Denumire = P.Vendor
	order by V.Denumire;
go

select * from vw_Vendori
select * from vw_VendoriProcesoare




declare @input as varchar(1000)
set @input = 'masina'
set @input = CONCAT(@input, 1)
print(@input)
select substring(@input, 3, 1)
select len(@input)