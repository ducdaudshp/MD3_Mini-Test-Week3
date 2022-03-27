create database material;
use material;

create table supplies (
    id int primary key ,
    suppliesCode nvarchar(10),
    suppliesName nvarchar(50),
    suppliesUnit nvarchar(10),
    suppliesPrice int
);

create table inventory (
    id int primary key ,
    supplies_id int,
    quantity int,
    totalImport int,
    totalExport int,
    foreign key (supplies_id) references supplies(id)
);

create table producer (
    id int primary key ,
    producerCode nvarchar(10),
    producerName nvarchar(50),
    producerAddress nvarchar(100),
    producerPhone nvarchar(10)
);

create table supplies_order(
    id int primary key ,
    supplies_orderCode nvarchar(10),
    supplies_orderDate datetime,
    producer_id int,
    foreign key (producer_id) references producer(id)
);

create table goods_received(
    id int primary key ,
    receivedCode nvarchar(10),
    receivedDate datetime,
    supplies_order_id int,
    foreign key (supplies_order_id) references supplies_order(id)
);

create table goods_delivery(
   id int primary key ,
   deliveryCode nvarchar(10),
   deliveryDate datetime,
   delivery_customerName nvarchar(50)
);

create table order_detail(
    id int primary key ,
    supplies_order_id int,
    supplies_id int,
    orderQuantity int,
    foreign key (supplies_order_id)references supplies_order(id),
    foreign key (supplies_id) references supplies(id)
);

create table received_detail(
    id int primary key ,
    goods_received_id int,
    supplies_id int,
    receivedQuantity int,
    received_unitPrice int,
    receivedNote nvarchar(50),
    foreign key (goods_received_id)references goods_delivery(id),
    foreign key (supplies_id) references supplies(id)
);

create table delivery_detail(
    id int primary key ,
    goods_delivery_id int,
    supplies_id int,
    deliveryQuantity int,
    delivery_unitPrice int,
    deliveryNot nvarchar(50),
    foreign key (goods_delivery_id) references goods_delivery(id),
    foreign key (supplies_id) references supplies(id)
);

insert into supplies values (1,'s1','Chao','Cai',100000),
                            (2,'s2','Xoong','Cai',50000),
                            (3,'s3','Dao','Con',20000),
                            (4,'s4','Bep','Cai',300000),
                            (5,'s5','May hut mui','Chiec',700000);

insert into inventory values (1,1,30,15,10),
                             (2,2,30,12,14),
                             (3,3,50,20,25),
                             (4,4,20,5,7),
                             (5,5,15,5,8);

insert into producer values (1,'pd01','Cook Cu','Ha Noi','0331111111'),
                            (2,'pd02','Sun House','Ho Chi Minh','0332222222'),
                            (3,'pd03','Shang hai','Tung Cua','0335555555');

insert into supplies_order values (1,'so1','2022-2-28',3),
                                  (2,'so2','2022-1-14',2),
                                  (3,'so3','2022-3-05',1);

insert into goods_received values (1,'gr1','2022-3-10',3),
                                  (2,'gr2','2022-3-02',2),
                                  (3,'gr3','2022-3-26',1);

insert into goods_delivery values (1,'gd1','2022-3-25','Giang'),
                                  (2,'gd2','2022-3-20','Anh'),
                                  (3,'gd3','2022-4-05','Canh');

insert into order_detail values (1,1,5,5),
                                (2,1,4,3),
                                (3,2,3,10),
                                (4,2,2,4),
                                (5,3,1,5),
                                (6,3,1,10);

insert into received_detail values (1,3,1,10,100000,'hang de vo'),
                                   (2,3,2,8,50000,'hang de bi bop meo'),
                                   (3,2,3,10,20000,'hang sac nhon'),
                                   (4,2,4,5,300000,'hang de vo'),
                                   (5,1,5,5,700000,'hang cong kenh de vo'),
                                   (6,1,3,7,20000,'hang sac nhon');


create view vw_CTPNHAP as
select receivedCode,s.suppliesCode,rd.receivedQuantity,rd.received_unitPrice,
       rd.received_unitPrice*rd.receivedQuantity as 'thanh tien nhap'
from goods_received
         join received_detail rd on goods_received.id = rd.goods_received_id
         join supplies s on s.id = rd.supplies_id;

select *from vw_CTPNHAP;

create view vw_CTPNHAP_VT as
select receivedCode,s.suppliesCode,s.suppliesName,rd.receivedQuantity,
       rd.received_unitPrice,rd.received_unitPrice*rd.receivedQuantity
       as 'thanh tien nhap'
from goods_received
         join received_detail rd on goods_received.id = rd.goods_received_id
         join supplies s on s.id = rd.supplies_id;

select *from vw_CTPNHAP_VT;

create view vw_CTPNHAP_VT_PN as
select receivedCode,receivedDate,count(so.id),s.suppliesCode,s.suppliesName,rd.receivedQuantity,
       received_unitPrice,rd.received_unitPrice * rd.receivedQuantity as 'thanh tien nhap'
from goods_received
         join supplies_order so on goods_received.supplies_order_id = so.id
         join received_detail rd on goods_received.id = rd.goods_received_id
         join supplies s on s.id = rd.supplies_id
group by receivedCode,receivedDate,s.suppliesCode,suppliesName;

select *from vw_CTPNHAP_VT_PN;


