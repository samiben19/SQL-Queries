-- Version table
use DeltaHardware
go
create table VersionDB(ver int);
insert into VersionDB values (0);
go

---------------DO---------------
-- 1. Modify the type of the column
create or alter procedure do_proc_1
as
begin
alter table Procesoare
alter column Unlocked int;
update VersionDB set ver = 1;
print 'Upgraded to 1';
end

go

-- 2. Add a default constraint
create or alter procedure do_proc_2
as
begin
alter table Procesoare
add constraint d_Arhitectura default 14 for Arhitectura;
update VersionDB set ver = 2;
print 'Upgraded to 2';
end

go

-- 3. Create a new table 
create or alter procedure do_proc_3
as
begin
create table RAM(id int);
update VersionDB set ver = 3;
print 'Upgraded to 3';
end

go

-- 4. Add a column
create or alter procedure do_proc_4
as
begin
alter table RAM
add Vendor varchar(50);
update VersionDB set ver = 4;
print 'Upgraded to 4';
end

go

-- 5. Create a foreign key constraint
create or alter procedure do_proc_5
as
begin
alter table RAM
add constraint fk_RAM_Vendori foreign key(Vendor)
references Vendori(Denumire);
update VersionDB set ver = 5;
print 'Upgraded to 5';
end

go

---------------UNDO---------------
-- 1. Modify the type of the column (back)
create or alter procedure undo_proc_1
as
begin
alter table Procesoare
alter column Unlocked bit;
update VersionDB set ver = 0;
print 'Downgraded to 0';
end

go

-- 2. Remove a default constraint 
create or alter procedure undo_proc_2
as
begin
alter table Procesoare
drop constraint d_Arhitectura;
update VersionDB set ver = 1;
print 'Downgraded to 1';
end

go

-- 3. Remove a table 
create or alter procedure undo_proc_3
as
begin
drop table RAM;
update VersionDB set ver = 2;
print 'Downgraded to 2';
end

go

-- 4. Remove a column
create or alter procedure undo_proc_4
as
begin
alter table RAM
drop column Vendor;
update VersionDB set ver = 3;
print 'Downgraded to 3';
end

go

-- 5. Remove a foreign key constraint
create or alter procedure undo_proc_5
as
begin
alter table RAM
drop constraint fk_RAM_Vendori;
update VersionDB set ver = 4;
print 'Downgraded to 4';
end

go

---------------MAIN PROGRAM---------------
create or alter procedure main
@vers int
as
begin
	declare @actual int;
	declare @old int;

	set @actual = (select top 1 ver from VersionDB);
	set @old = @actual;

	if @vers > 5 or @vers < 0
		throw 50001, 'EROARE ! Versiune inexistenta ! Incearca in intervalul [0, 5].' , 1;
	if @vers = @actual
		throw 50002, 'EROARE ! Versiunea inserata este chiar cea curenta !', 2;

	set nocount on;

	while @vers != @actual
	begin
		declare @comanda varchar(50);
		if @vers > @actual -- Upgrade
		begin
			set @comanda = 'do_proc_' + convert(varchar(50), @actual + 1);
			exec @comanda;
		end
		if @vers < @actual -- Downgrade
		begin
			set @comanda = 'undo_proc_' + convert(varchar(50), @actual);
			exec @comanda;
		end
		set @actual = (select top 1 ver from VersionDB);
	end
	print concat('Baza de date a fost actualizata de la ', @old, ' la ', @vers, ' cu succes !:)');
	set nocount off;
end

---------------Comenzile care se ruleaza---------------
declare @versiune int = (select top 1 ver from VersionDB);
print concat('Versiunea initiala: ', @versiune);
begin try
	exec main 0;
end try
begin catch
	print error_message();
end catch
set @versiune = (select top 1 ver from VersionDB);
print concat('Versiunea curenta: ', @versiune);
--------------------------------------------------------