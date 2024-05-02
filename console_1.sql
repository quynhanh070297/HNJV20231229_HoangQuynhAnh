
create database QUANLYBANHANG;
use QUANLYBANHANG;

create table if not exists CUSTOMERS
(
    customerId varchar(4) primary key not null,
    name       varchar(100)           not null,
    email      varchar(100)           not null unique,
    phone      varchar(25)            not null unique,
    address    varchar(255)           not null

);


create table if not exists ORDERS
(
    order_Id     varchar(4) primary key not null,
    customer_Id  varchar(4)             not null,
    order_date   date                   not null,
    total_amount double                 not null,
    foreign key (customer_Id) references CUSTOMERS (customerId)

);

create table if not exists PRODUCTS
(
    product_Id  varchar(4) primary key not null,
    name        varchar(255)           not null,
    description text,
    price       double                 not null,
    status      bit(1)                 not null

);

create table if not exists ORDERS_DETAILS
(
    order_Id   varchar(4) not null,
    product_Id varchar(4) not null,
    quantity   int(11)    not null,
    price      double     not null,
    primary key (order_Id, product_Id),
    foreign key (order_Id) references ORDERS (order_Id),
    foreign key (product_Id) references PRODUCTS (product_Id)
);

insert into CUSTOMERS (customerId, name, email, phone, address)
values ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Môc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

insert into PRODUCTS (product_Id, name, description, price, status)
values ('P001', 'iPhone 13 Pro Max', 'Bộ nhớ 512 GB, màu xanh lá', 22999999, 1),
       ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999, 1),
       ('P003', 'Macbook Pro M2', '8 CPU 10 GPU, RAM 8GB, bộ nhớ 256GB', 28999999, 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
       ('P005', 'AirPods 2 2022', 'Âm thanh không gian', 4090000, 1);


## Thêm thông tin đơn hàng vào bảng ORDERS
insert into ORDERS (order_Id, customer_Id, total_amount, order_date)
values ('H001', 'C001', 52999997, '2023-02-22'),
       ('H002', 'C001', 80999997, '2023-03-11'),
       ('H003', 'C002', 54359998, '2023-01-22'),
       ('H004', 'C003', 102999995, '2023-03-14'),
       ('H005', 'C003', 80999997, '2022-03-12'),
       ('H006', 'C004', 110449994, '2023-02-01'),
       ('H007', 'C004', 79999996, '2023-03-29'),
       ('H008', 'C005', 29999998, '2023-02-14'),
       ('H009', 'C005', 28999999, '2023-01-10'),
       ('H010', 'C005', 149999994, '2023-04-01');

## Thêm thông tin chi tiết đơn hàng vào bảng ORDERS_DETAILS
insert into ORDERS_DETAILS (order_Id, product_Id, price, quantity)
values ('H001', 'P002', 14999999, 1),
       ('H001', 'P004', 18999999, 2),
       ('H002', 'P001', 22999999, 1),
       ('H002', 'P003', 28999999, 2),
       ('H003', 'P004', 18999999, 2),
       ('H003', 'P005', 4090000, 4),
       ('H004', 'P002', 14999999, 3),
       ('H004', 'P003', 28999999, 2),
       ('H005', 'P001', 22999999, 1),
       ('H005', 'P003', 28999999, 2),
       ('H006', 'P005', 4090000, 5),
       ('H006', 'P002', 14999999, 6),
       ('H007', 'P004', 18999999, 3),
       ('H007', 'P001', 22999999, 1),
       ('H008', 'P002', 14999999, 2),
       ('H009', 'P003', 28999999, 1),
       ('H010', 'P003', 28999999, 2),
       ('H010', 'P001', 22999999, 4);

#Bài 3: Truy vấn dữ liệu [30 điểm]:
# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
# [4 điểm]

select name, email, phone, address
from CUSTOMERS;

# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
# thoại và địa chỉ khách hàng). [4 điểm]

select distinct c.name, c.phone, c.address
from CUSTOMERS c
         join ORDERS o on c.customerId = o.customer_Id
where o.order_date between '2023-03-01' and '2023-03-31';

# 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
# tháng và tổng doanh thu ). [4 điểm]

select MONTH(order_date) Thang, SUM(total_amount) DoanhThu
from ORDERS
where YEAR(order_date) = 2023
group by MONTH(order_date);

# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
# hàng, địa chỉ , email và số điên thoại). [4 điểm]

select c.name, c.address, c.email, c.phone
from CUSTOMERS c
         left join ORDERS o on c.customerId = o.customer_Id and MONTH(o.order_date) = 2 and YEAR(o.order_date) = 2023
where o.order_Id is null;

# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
# sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]

select od.product_Id, p.name TenSanPham, SUM(od.quantity) TongSoSanPham
from ORDERS_DETAILS od
         join PRODUCTS p on od.product_Id = p.product_Id
         join ORDERS o on od.order_Id = o.order_Id
where MONTH(o.order_date) = 3
  and YEAR(o.order_date) = 2023
group by od.product_Id, p.name;

# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
# tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]


select c.customerId, c.name TenKHachHang, SUM(o.total_amount) TongChiTieu
from CUSTOMERS c
         left join ORDERS o on c.customerId = o.customer_Id and YEAR(o.order_date) = 2023
group by c.customerId, c.name
order by TongChiTieu DESC;


# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
# tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]

select c.name as customer_name, o.total_amount, o.order_date, SUM(od.quantity) TongSoLuongSanPham
from CUSTOMERS c
         join ORDERS o on c.customerId = o.customer_Id
         join ORDERS_DETAILS od on o.order_Id = od.order_Id
group by o.order_Id, c.name, o.total_amount, o.order_date
having TongSoLuongSanPham >= 5;


# Bài 4: Tạo View, Procedure [30 điểm]:
# 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
# tiền và ngày tạo hoá đơn . [3 điểm]

create view order_Info as
select c.name TenKhachHang, c.phone, c.address, o.total_amount, o.order_date
from CUSTOMERS c
         join ORDERS o on c.customerId = o.customer_Id;



# 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
# số đơn đã đặt. [3 điểm]
create view Customer_Info as
select c.name TenKhachHang, c.address, c.phone, COUNT(o.order_Id) TongDonhang
from CUSTOMERS c
         left join ORDERS o on c.customerId = o.customer_Id
group by c.name, c.address, c.phone;



# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
# bán ra của mỗi sản phẩm.

create view Product_Info as
select p.name TenSanPham, p.description, p.price, SUM(od.quantity) SoLuongBanRa
from ORDERS_DETAILS od
         join PRODUCTS p on p.product_Id = od.product_Id
group by p.name, p.description, p.price;


# 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]

create index index_phone on CUSTOMERS (phone);
create index index_email on CUSTOMERS (email);


# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
delimiter //
create procedure GetCustomerInfo_ByCustomerId(customerId_in varchar(4))
begin
    select *
    from CUSTOMERS
    where customerId = customerId_in;
end;
//
delimiter ;

#Call GetCustomerInfo_ByCustomerId('C001');


# 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
delimiter //
create procedure products_infoAll()
begin
    select *
    from PRODUCTS;
end;
//
delimiter ;

call products_infoAll();


# 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]

delimiter //
create procedure getOrders_ByCustomerId(customer_Id_in varchar(4))
begin
    select *
    from ORDERS
    where customer_Id = customer_Id_in;
end;
//
delimiter ;

call getOrders_ByCustomerId('C001');



# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
# # tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]

# delimiter //
# create procedure getOrders_ByCustomerId(customer_Id_in varchar(4))
# begin
# end;
# //
# delimiter ;
#
# call getOrders_ByCustomerId('C001');

# 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
# thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]



delimiter //
create procedure productSale_ByDate(startDate_in date, endDate_in date)
begin
    select p.product_Id, p.name TenSanPham, SUM(od.quantity) TongSoHoaDon
    from ORDERS_DETAILS od
             join PRODUCTS p on p.product_Id = od.product_Id
             join ORDERS o on od.order_Id = o.order_Id
    where o.order_date between startDate_in and endDate_in
    group by p.product_Id, p.name;
end;
//
delimiter ;

call productSale_ByDate('2023-2-1','2023-5-29');


# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
# giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]

delimiter //
create procedure productOrder_ByMonthYear(month_in int, year_in int)
begin
    select p.product_Id, p.name TenSanPham, SUM(od.quantity) SanPhamBanRa
    from ORDERS_DETAILS od
             join PRODUCTS p on p.product_Id = od.product_Id
             join ORDERS o on od.order_Id = o.order_Id
    where YEAR(o.order_date) = year_in
      and MONTH(o.order_date) = month_in
    group by p.product_Id, p.name
    order by SanPhamBanRa desc;
end;
//
delimiter ;

call productOrder_ByMonthYear(2,2023);
