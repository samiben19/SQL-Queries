create database DeltaHardware
go
use DeltaHardware
go

create table Adrese(
	IdAdresa int primary key identity,
	Tara varchar(30) default 'Romania',
	Judet varchar(20),
	Oras varchar(30),
	Strada varchar(50),
	Numarul int,
	Bloc varchar(10),
	Apartament int,
	constraint cc_Numar check(Numarul>0),
	constraint cc_Apart check(Apartament>0),
	constraint cc_Judet check(Judet in ('Bihor', 'Cluj', 'Arad', 'Timis', 'Sibiu'))
)

create table Clienti(
	IdClient int primary key identity,
	Nume varchar(50),
	Prenume varchar(50),
	Telefon varchar(10),
	Email varchar(50),
	Adresa int foreign key references Adrese(IdAdresa)
)

create table Comenzi(
	IdComanda int primary key identity,
	IdClient int foreign key references Clienti(IdClient),
	Cantitate int,
	PretTotal float,
	DataComanda date default getdate(),
	constraint cc_Cantitate check(Cantitate>0),
	constraint cc_PretCom check(PretTotal>=0)
)

create table Wishlists(
	IdWishlist int primary key identity,
	Denumire varchar(50),
	PretTotal float
)

create table Vendori(
	Denumire varchar(50) primary key,
	Telefon varchar(10),
	Email varchar(50)
)

create table Procesoare(
	IdProcesor int primary key identity,
	Denumire varchar(50),
	Vendor varchar(50) foreign key references Vendori(Denumire),
	Frecventa float,
	Nuclee int,
	Arhitectura int,
	Unlocked bit,
	Pret float,
	constraint uc_DenumirePro unique(Denumire),
	constraint cc_FrecventaPro check(Frecventa>0 and Frecventa<7),
	constraint cc_NucleePro check(Nuclee>0 and Nuclee%2=0),
	constraint cc_ArhitecturaPro check(Arhitectura>0),
	constraint cc_PretPro check(Pret>=0)
)

create table PlaciVideo(
	IdPlacaVideo int primary key identity,
	Denumire varchar(50),
	Vendor varchar(50) foreign key references Vendori(Denumire),
	Frecventa float,
	Memorie int,
	Tip_Memorie varchar(50),
	Suport_DXR bit,
	Pret float,
	constraint uc_DenumireVid unique(Denumire),
	constraint cc_FrecventaVid check(Frecventa>0 and Frecventa<7),
	constraint cc_MemorieVid check(Memorie>0),
	constraint cc_Tip_MemorieVid check (Tip_Memorie in ('GDDR3', 'GDDR4', 'GDDR5', 'GDDR5X', 'GDDR6', 'GDDR6X')),
	constraint cc_PretVid check(Pret>=0)
)

create table Wishlists_Procesoare(
	IdWishlist int foreign key references Wishlists(IdWishlist),
	IdProcesor int foreign key references Procesoare(IdProcesor),
	Cantitate int,
	constraint pk_Wishlists_Procesoare primary key (IdWishlist, IdProcesor)
)

create table Wishlists_PlaciVideo(
	ID int primary key identity,
	IdWishlist int foreign key references Wishlists(IdWishlist),
	IdPlacaVideo int foreign key references PlaciVideo(IdPlacaVideo)
)

create table Comenzi_Wishlists(
	ID int primary key identity,
	IdComanda int foreign key references Comenzi(IdComanda),
	IdWishlist int foreign key references Wishlists(IdWishlist)
)

insert into Adrese(Judet,Oras,Strada,Numarul) values
('Bihor','Oradea','str1',1), ('Cluj','Cluj-Napoca','str2',2), ('Arad','Arad','str3',3),
('Timis','Timisoara','str4',4), ('Sibiu','Sibiu','str5',5);
select * from Adrese;

--delete from Adrese;
--dbcc checkident('Adrese', reseed, 0) 

insert into Clienti(Nume,Prenume,Telefon,Email,Adresa) values
('Duane' ,'Salinas', '111111','duanesalinas@yahoo.com',1),
('Sameer', 'Adamson', '222222', 'sameeradamson@gmail.com', 5),
('Cathy', 'Milne', '333333', 'cathymilne@gmail.com', 2),
('Bartosz', 'Milner', '444444','bartoszmilner@hotmail.com',3),
('Scarlett', 'Hawes', '555555','scarletthawes@yahoo.com', 4),
('Hana', 'Thornton', '666666', 'hanathornton@gmail.com', 1),
('Francesca', 'Mohammed', '777777', 'francescamohameed@yahoo.com',1),
('Astrid', 'Cotton', '888888', 'astridcotton@gmail.com', 3),
('Nazim', 'Bean', '999999', 'nazimbean@yahoo.com', 2),
('Cai', 'Landry', '101010', 'cailandry@yahoo.com', 2);
select * from Clienti;

insert into Vendori(Denumire,Email,Telefon) values
('Intel', 'intel@yahoo.com', '35464356'),
('AMD', 'amd@yahoo.com', '54677564'),
('NVIDIA', 'nvidia@yahoo.com', '34658856');
select * from Vendori;

insert into Procesoare(Denumire, Vendor, Frecventa, Nuclee, Arhitectura, Unlocked, Pret) values
('I3 8300', 'Intel', 3.7, 4, 14, 0, 599.99),
('I5 6400', 'Intel', 3.3, 4, 14, 0, 799.99),
('R5 3600', 'AMD', 4.2, 6, 7, 1, 899.99),
('I7 7700K', 'Intel', 4.5, 4, 14, 1, 1399.99),
('I9 10900K', 'Intel', 5.3, 10, 14, 1, 2399.99),
('R7 5800X', 'AMD', 4.7, 8, 7, 1, 2099.99),
('R9 5950X', 'AMD', 4.9, 16, 7, 1, 3899.99);
delete from Procesoare;
dbcc checkident('Procesoare', reseed, 0);
select * from Procesoare;

insert into PlaciVideo(Denumire, Vendor, Frecventa, Memorie, Tip_Memorie, Suport_DXR, Pret) values
('GTX 1060', 'NVIDIA', 1.8, 6, 'GDDR5', 0, 1399.99),
('GTX 1050', 'NVIDIA', 1.5, 4, 'GDDR5', 0, 699.99),
('GTX 1050Ti', 'NVIDIA', 1.6, 4, 'GDDR5', 0, 899.99),
('GTX 1080', 'NVIDIA', 1.8, 8, 'GDDR5', 0, 2599.99),
('GTX 1070', 'NVIDIA', 1.9, 8, 'GDDR5', 0, 1899.99),
('GTX 1080Ti', 'NVIDIA', 1.9, 11, 'GDDR5X', 0, 3499.99),
('RX 480', 'AMD', 1.3, 8, 'GDDR5', 0, 1399.99),
('RX 470', 'AMD', 1.4, 8, 'GDDR5', 0, 1199.99),
('RX 580', 'AMD', 1.4, 8, 'GDDR5', 0, 1499.99),
('RX 5700', 'AMD', 1.7, 8, 'GDDR6', 0, 1799.99),
('RTX 2060', 'NVIDIA', 2.1, 6, 'GDDR6', 1, 1999.99),
('RTX 2070', 'NVIDIA', 2.0, 8, 'GDDR6', 1, 2499.99),
('RTX 2080', 'NVIDIA', 1.9, 8, 'GDDR6', 1, 3599.99),
('RTX 3060', 'NVIDIA', 2.0, 6, 'GDDR6', 1, 2199.99),
('RTX 3070', 'NVIDIA', 1.9, 8, 'GDDR6', 1, 3599.99),
('RTX 3080', 'NVIDIA', 1.8, 10, 'GDDR6X', 1, 3499.99),
('RTX 3090', 'NVIDIA', 1.9, 24, 'GDDR6X', 1, 7599.99),
('RX 6800', 'AMD', 2.1, 16, 'GDDR6', 1, 2899.99),
('RX 6700XT', 'AMD', 2.6, 12, 'GDDR6', 1, 2399.99),
('RX 6600', 'AMD', 2.6, 8, 'GDDR6', 1, 1699.99),
('RTX 3080Ti', 'NVIDIA', 1.7, 12, 'GDDR6X', 1, 4999.99),
('RX 6600XT', 'AMD', 2.6, 8, 'GDDR6', 1, 2099.99),
('RX 6800XT', 'AMD', 2.4, 16, 'GDDR6', 1, 3299.99);
delete from PlaciVideo;
dbcc checkident('PlaciVideo', reseed, 0);
select * from PlaciVideo;

insert into Wishlists(Denumire) values
('Delta'),
('Toxic'),
('Dragonix'),
('Nightmare'),
('Venom'),
('Viper'),
('Lucifer');
select * from Wishlists;

insert into Wishlists_Procesoare(IdWishlist, IdProcesor, Cantitate) values
(1, 5, 2),
(2, 2, 1),
(3, 4, 1),
(4, 7, 1),
(5, 6, 1),
(6, 1, 1),
(7, 3, 1);

insert into Wishlists_PlaciVideo(IdWishlist, IdPlacaVideo) values
(1, 17),
(1, 17),
(2, 1),
(3, 11),
(4, 16),
(4, 16),
(5, 23),
(6, 2),
(7, 22);

insert into Comenzi(IdClient, Cantitate, DataComanda) values
(1, 10, '2020-12-25'),
(1, 4, '2020-6-2'),
(1, 6, '2020-12-28'),
(1, 2, '2020-6-16'),
(3, 20, '2020-12-15'),
(5, 12, '2020-5-5'),
(8, 3, '2020-6-21');
delete from Comenzi;
dbcc checkident('Comenzi', reseed, 0);
select * from Comenzi;

insert into Comenzi_Wishlists(IdComanda,IdWishlist) values
(1,1),
(2,1),
(3,2),
(4,5),
(5,6),
(6,7),
(7,7);
select * from Comenzi_Wishlists;

--Procesoarele din fiecare wishlist care au mai mult de 4 nuclee
select distinct W.Denumire as [Denumire Wishlist], P.Denumire [Denumire Procesor], P.Nuclee
from Wishlists W inner join Wishlists_Procesoare WP
	on W.IdWishlist = WP.IdWishlist inner join Procesoare P
	on WP.IdProcesor = P.IdProcesor
where P.Nuclee > 4;

--Placile video din fiecare wishlish si cantitatea
select W.Denumire as [Denumire Wishlist], Pv.Denumire as [Denumire Placa Video], 
	count(Pv.Denumire) as [Cantitate]
from Wishlists W inner join Wishlists_PlaciVideo WPv 
	on W.IdWishlist = WPv.IdWishlist left outer join PlaciVideo Pv
	on WPv.IdPlacaVideo = Pv.IdPlacaVideo
group by W.Denumire, Pv.Denumire;

--Placile video care nu apar in niciun wishlist si care au pretul mai mare decat 2500
select Pv.Denumire as [Denumire Placa Video], Pv.Pret
from Wishlists W left outer join Wishlists_PlaciVideo WPv 
	on W.IdWishlist = WPv.IdWishlist right outer join PlaciVideo Pv
	on WPv.IdPlacaVideo = Pv.IdPlacaVideo
where Pv.IdPlacaVideo not in (select IdPlacaVideo from Wishlists_PlaciVideo)
	and Pv.Pret > 2500;

--Pretul mediu per cantitatea de memorie de tip GDDR5 in ordine descrescatoare dupa pret, avand pretul mai mare decat 2000
select Memorie, avg(Pret) as [Pret mediu]
from PlaciVideo
where Tip_Memorie = 'GDDR6'
group by Memorie
having avg(Pret) > 2000
order by [Pret mediu] desc;

--Afis clientii si cate placi video a cumparat un client in total, daca acestia au peste 5 placi cumparate
select A.Nume, A.Prenume, A.Denumire, sum(A.[Total cumparate]) as [Total cumparate]
from(
select Cl.Nume, Cl.Prenume, Pv.Denumire, count(Pv.Denumire)*Com.Cantitate as [Total cumparate]
from Clienti Cl inner join Comenzi Com
	on Cl.IdClient = Com.IdClient inner join Comenzi_Wishlists CW
	on CW.IdComanda = Com.IdComanda inner join Wishlists W
	on W.IdWishlist = CW.IdWishlist inner join Wishlists_PlaciVideo WP
	on WP.IdWishlist = W.IdWishlist inner join PlaciVideo Pv
	on Pv.IdPlacaVideo = WP.IdPlacaVideo
group by Cl.Nume, Cl.Prenume, Pv.Denumire, Com.Cantitate) A
group by A.Nume, A.Prenume, A.Denumire
having sum(A.[Total cumparate]) > 5;

--Afis toti clientii care au comenzi si nu is din Cluj
select distinct Nume, Prenume
from Clienti 
where IdClient in (select IdClient from Comenzi) and Adresa in (select IdAdresa from Adrese where Judet != 'Cluj');

--Afis profitul total per producator la nivel de placi video
select V.Denumire, sum(Pv.Pret*C.Cantitate) as [Pret total]
from Vendori V, PlaciVideo Pv inner join Wishlists_PlaciVideo WPv
	on WPv.IdPlacaVideo = Pv.IdPlacaVideo inner join Wishlists W
	on W.IdWishlist = WPv.IdWishlist inner join Comenzi_Wishlists CW
	on CW.IdWishlist = W.IdWishlist inner join Comenzi C
	on C.IdComanda = CW.IdComanda
where Pv.Vendor = V.Denumire 
group by V.Denumire;

--Afis profitul total per producator la nivel de procesoare
select V.Denumire, sum(P.Pret*C.Cantitate) as [Pret total]
from Vendori V, Procesoare P inner join Wishlists_Procesoare WP
	on WP.IdProcesor = P.IdProcesor inner join Wishlists W
	on W.IdWishlist = WP.IdWishlist inner join Comenzi_Wishlists CW
	on CW.IdWishlist = W.IdWishlist inner join Comenzi C
	on C.IdComanda = CW.IdComanda
where P.Vendor = V.Denumire 
group by V.Denumire;

--select *
--from Clienti, Adrese
--where Clienti.Adresa = Adrese.IdAdresa;

select *
from PlaciVideo
where Memorie=8 and Denumire like 'R%X%';

select Vendor, count(Vendor) as [Procesoare detinute]
from Procesoare
group by Vendor;

select Vendor, avg(Pret) as [Pret mediu]
from PlaciVideo
group by Vendor;