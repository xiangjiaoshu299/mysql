-- 准备数据
create table product
(
pid int PRIMARY KEY AUTO_INCREMENT,
pname VARCHAR(10),
price DOUBLE,
pnum INT
);

create table orders
(
oid INT PRIMARY KEY AUTO_INCREMENT,
pid INT,
onum INT
);

create table personinfo
(
sname VARCHAR(5),
sex CHAR(1),
phone VARCHAR(11)
);

create table review(
	username varchar(20),
	action varchar(10),
	studentname varchar(20),
	actiontime TIMESTAMP
);

insert into product(pname, pnum, price)values('桃子', 100, 2);
insert into product(pname, pnum, price)values('苹果', 80, 8);
insert into product(pname, pnum, price)values('香蕉', 50, 5);

-- 创建：
-- 添加订单，减少库存
create trigger trigger_order 
AFTER INSERT ON orders FOR EACH ROW
begin

	update product set pnum = pnum - NEW.onum
	where pid = NEW.pid;

end;


-- 测试
insert into orders(oid, pid, onum) values(null, 1, 3);


-- 删除
drop trigger if exists trigger_order;

-- 查看触发器
show triggers from db1;
SELECT * FROM information_schema.triggers where trigger_name = 'trigger_order'

-- 创建：
-- 注意：变量名，不要用大小写的格式，否则会创建失败！
-- 库存不足，禁止插入订单

create trigger trigger_order 
before insert on orders for each row
begin

	DECLARE rest_num int;
	declare msg varchar(50);
	select pnum into rest_num from product where pid = new.pid;
	if rest_num < new.onum then
			select xxx into msg;
	else
			update product set pnum = pnum - new.onum 
			where pid = new.pid;
	end if;

end;

-- 测试
insert into orders(pid, onum) values(1, 200);
insert into orders(pid, onum) values(1, 10);

-- 这个报错类型：1054。如果触发器报错，也是这个报错码
set @p = '100';
select @p;
select xxx into @p;

-- 创建。18：00之后，不允许更新
create trigger trigger_limittime
before insert on orders for each row
begin
	declare msg varchar(20);
	if hour(now()) >= 18 then
		select time_err into msg;
	else
		set msg = '时间允许'; -- 注意：这个语句，不会出现在日志里面。
		select '时间允许' into msg;-- 打印日志的功能
	end if;
end;
-- 测试
drop trigger if exists trigger_limittime;
insert into orders (pid, onum) values(1, 5);-- flkasdjflkjfdlkjsdalfkjaslkdfjfalsdjflasjl;jsdalfkj




-- demo: 周六周日，禁止插入记录
create trigger trigger_limitdate
before insert on orders for each row
begin

	DECLARE msg varchar(20);
	if DAYNAME(now()) = 'sunday' or DAYNAME(now()) = 'saturday' then
-- 	if DAYNAME(now()) = 'friday' or DAYNAME(now()) = 'saturday' then
		select xxx into msg;
	else
		set msg = '允许插入订单';
	end if;

end;

-- 测试
insert into orders(pid, onum) values(1, 10);
drop trigger if exists trigger_limitdate;

-- 创建-限制数据更改范围
create trigger trigger_limistincreateprice
before update on product for each row
begin

	DECLARE msg varchar(20);
	if (new.price - old.price) * 100 / old.price  > 20 then
		select xxx into msg;
	else 
		set msg = '允许更新';
	end if;

end;
-- 测试
update product set price = 12 where pid = 2;
update product set price = 9 where pid = 2;
drop trigger if exists trigger_limistincreateprice;

-- 创建-验证数据是否正确：周系好1开头，并且是11位
create trigger trigger_validphone 
before insert on personinfo for each row
begin

	declare msg varchar(20);
	if new.phone REGEXP '[1][0-9]{10}' then
		set msg = '手机号格式正确';
	else
		select err into msg;
	end if;

end;

-- 测试。不正确则报错1054
insert into personinfo values('张三', '男', '13700');
-- insert into personinfo values('张三', '男', '13700002222');
drop trigger if exists trigger_validphone;

-- 创建。审计操作
-- 注意：事实证明，一张表，可以有多个insert类型的触发器


create trigger trigger_review
before insert on personinfo for each row
begin
	insert into review values(user(), 'insert', new.sname, now());
end;

create trigger trigger_review_delete
after delete on personinfo for each row
begin
	insert into review values(user(), 'delete', old.sname, now());
end;

create trigger trigger_review_update
after update on personinfo for each row
begin
	insert into review values(user(), 'update', new.sname, now());
end;

-- 测试
select * from information_schema.triggers where trigger_schema = 'db1'
insert into personinfo values('李四', '男', '13700002222');
delete from personinfo where sname = '李四';
update personinfo set sex = '女' where sname = '张三'

-- 删掉那些触发器
show triggers from db1;
drop trigger if exists trigger_order
drop trigger if exists trigger_limitdate