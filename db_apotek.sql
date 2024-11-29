create database apotek
use apotek
drop database apotek

create table obat(
id_obat int not null,
id_pegawai int,
nama_obat varchar (30) not null,
keterangan_obat varchar (30),
stok_obat int,
harga int,
constraint PK_obat primary key (id_obat)
)
drop*table obat

create table pegawai(
id_pegawai int not null,
id_obat int,
id_transaksi int,
nama_pegawai varchar (30),
alamat_pegawai varchar (50),
gaji_pegawai int,
constraint PK_pegawai primary key (id_pegawai)
)

create table transaksi(
id_transaksi int not null,
id_pelanggan int,
id_pegawai int not null,
id_obat int,
jumlah int,
total_harga int,
constraint PK_transaksi primary key (id_transaksi)
)

create table pelanggan(
id_pelanggan int not null,
id_transaksi int,
nama_pelanggan varchar (30),
constraint PK_pelanggan primary key (id_pelanggan)
)

alter table pegawai
add constraint FK_pegawai_Relation_transaksi foreign
key (id_transaksi) references transaksi (id_transaksi)

alter table obat
add constraint FK_obat_Relation_pegawai foreign
key (id_pegawai) references pegawai (id_pegawai)

alter table transaksi
add constraint FK_transaksi_Relation_pelanggan foreign
key (id_pelanggan) references pelanggan (id_pelanggan)

insert into obat values
(101,0001,'paracetamol','demam',500,5000),
(102,0002,'amboxsol','batuk',350,3000),
(103,0003,'acarbose','diabetes',655,2000),
(104,0004,'analgesik','pereda nyeri',785,13000);
update obat set harga=6000 where id_obat= 101
delete from obat where id_obat= 102

insert into pegawai values
(0001,101,10010,'farel','purwokerto',1800000),
(0002,102,10025,'rani','purbalingga',1800000),
(0003,103,10016,'wahyu','sokaraja',1800000),
(0004,104,10005,'citra','banyumas',1800000);
update pegawai set nama_pegawai= 'farel' where id_pegawai= 0001
delete from pegawai where id_pegawai= 0002

insert into transaksi values
(10010,0050,0001,103,2,4000),
(10025,0053,0002,101,1,5000),
(10016,0052,0003,104,3,39000),
(10005,0051,0004,102,4,12000);
update transaksi set jumlah= 2 where id_transaksi= 10010
delete from transaksi where id_transaksi= 10025

insert into pelanggan values
(0050,10010,'karina'),
(0051,10025,'nia'),
(0052,10016,'veli'),
(0053,10005,'hendry');
update pelanggan set nama_pelanggan= 'karina' where id_pelanggan= 0050
delete from pelanggan where id_pelanggan= 0051

select*from obat
select*from pegawai
select*from transaksi
select*from pelanggan

create table transaksi_detail (
id_transaksi_detail int not null,
id_transaksi int default null,
id_obat int default null,
harga_satuan int default null,
primary key (id_transaksi_detail),
constraint fk_tb_transaksi_detail_tb_obat foreign key (id_obat) 
references obat (id_obat) on delete cascade on update cascade,
constraint fk_tb_transaksi_detail_tb_transaksi foreign key (id_transaksi)
references transaksi (id_transaksi) on delete cascade on update cascade
)
insert into transaksi_detail values	
(1,0003,101,5000),
(2,0002,102,3000),
(3,0004,103,2000),
(4,0001,104,13000)


/JOIN TABEL/
select pg.id_pelanggan, nama_pelanggan, ta.id_transaksi, nama_obat, ob.id_obat
from pelanggan pg
join transaksi ta on pg.id_pelanggan = ta.id_transaksi
join obat ob on ob.id_obat=ob.id_obat

/* TRIGGER INSERT DATA OBAT */
CREATE TRIGGER tambahstokobat
on obat for insert 
as 
print 'stok obat berhasil ditambah'
print 'dimodifikasi :' +convert (varchar, getdate () ) 
print ' nama host : ' +host_name ()
/*  TRIGGER TAMBAH BARANG TABEL TRANSAKSI */
 create trigger tambahstokobat on transaksi 
 for insert 
 as
 update b set b.stok = b.stok+ i.jml_transaksi 
 from barang b join inserted i on b.id_obat = i.id_obat;
 select * from obat 
 select * from transaksi 
/* TRIGGER UPDATE TRANSAKSI PENJUALAN*/
 create trigger UbahDataTransaksi on transaksi 
 after update 
 as
 update obat set 
 obat.stok_obat = (obat.stok_obat+deleted.total_harga) - inserted.total_harga
 from deleted, inserted where obat.id_obat = deleted.id_obat 
 update transaksi set total_harga= 10 where id_obat = 5 
 select * from obat 
 select * from transaksi 

  /* PROCEDURE */
create procedure tampilpelanggan
 as
 select * from pelanggan 

 create procedure tampilpelangganidd
 @id_pelanggan int 
 as
 select * from pelanggan where id_pelanggan = @id_pelanggan

 exec tampilpelanggan 
 exec tampilpelangganidd 50 

 create procedure insertcustumer
 @id_pelanggan int,
 @nama_pelanggan varchar (50),
 @id_transaksi int
 as
 insert into pelanggan (id_pelanggan, nama_pelanggan, id_transaksi)
 values (@id_pelanggan, @nama_pelanggan, @id_transaksi)
 exec insertcustumer 0050, 'karina', 10010 
 exec tampilpelanggan



 /FUNCTION*/
 create function hitung_pelanggan (@id_pelanggan int)
 returns int
 as
 begin
 declare @jumlah int
 select @jumlah=count (@id_pelanggan) from pelanggan
 return @jumlah
 end

 select dbo.hitung_pelanggan(1) as jumlah_pelanggan
 select*from pelanggan

 create function hitung_jumlah_pegawai (@id_pegawai int)
 returns int
 as
 begin
 declare @jumlah int
 select @jumlah=count (@id_pegawai) from pegawai
 return @jumlah
 end

 select dbo.hitung_jumlah_pegawai(1) as jumlah_jumlah_pegawai
 select*from pegawai
