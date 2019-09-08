
select * from tb_user where name = 'guohf';
select count(*) from tb_user where name = 'guohf';

-- select * from tb_user where name = uname;
-- select count(*) from tb_user where name = uname;

delimiter $$
create procedure delUser(in uid integer)
begin 
delete from tb_user where id = uid;
delete from tb_user where id = uid + 1;
end$$
delimiter;

call delUser(33);


-- 查询存储过程
select * from mysql.proc
where name = 'delUser'

show create PROCEDURE delUser

select * from information_schema.routines;

-- 删除
drop procedure if exists delUser

-- 测试in参数
delimiter $$
create procedure in_param(in p INTEGER)
	begin
	select p;
	set p = 2;
	select p;
end$$
delimiter ;

call in_param(1)

drop procedure if exists in_param

-- 测试out参数
delimiter //
create procedure out_param(out p INTEGER)
	begin
	select p;
	set p = 3;
	select p;
end//
delimiter ;

set @p = 10;
call out_param(@P); 

-- 测试in_out参数
delimiter //
create procedure inout_param(INOUT p INTEGER)
	begin
	select p;
	set p = 3;
	select p;
end//
delimiter ;

show create procedure inout_param

call inout_param(@p);

-- 变量
-- DEALLOCATE l_date date default '2019-01-01';

select '2019-01-01' into @p;
select @P;

set @p2 = 'hello world';
select @p2;

set @p3 = 1+2+3;
select @p3;


-- 存储过程中使用变量
create PROCEDURE greetWorld() select CONCAT(@greet, 'hello');
set @greet = '世界';
call greetWorld();

-- 存储过程之间，传递全局变量
create procedure p1() set @p = 1;
create procedure p2() select @p;

call p1();
call p2();

-- 注释
create procedure proc_zhushi(in num int) -- 这是名称
begin 

declare name char(10);
if num <= 17 then 
set name = '未成年';
else
set name = '成年';
end if;
select name;

end;

call proc_zhushi(15);

-- 查询数据库下面有哪些表
show tables;


-- 查看存储过程
select * from mysql.proc where db = 'db1'
select routine_name from information_schema.routines where routine_schema = 'db1'
show procedure status where db = 'db1'
show create procedure db1.delUser;

-- 修改
select * from mysql.proc where name = 'delUser'

alter procedure delUser
MODIFIES sql data
sql SECURITY invoker
comment '第一个存储过程'

alter procedure delUser
comment '测试存储过程'

-- 删除
drop procedure delUser;

-- 变量作用域
delimiter $$
create procedure prop3()
begin

	declare x varchar(5) default 'outer';
	begin
		declare x varchar(5) default 'inner';
		select x;
	end;
	select x;

end$$
delimiter ;

call prop3();
show create procedure db1.prop3
drop procedure db1.prop3

-- 条件语句
create procedure proc3(in p int)
begin

	declare pa int;
	set pa = p + 1;

	if pa = 0 then
		select '结果为0';
	ELSEIF pa = 1 then
		select '结果为1';
	else
		select '结果为其它';
	end if;

end

drop procedure if exists db1.proc3
select * from mysql.proc where name = 'proc3'
show create procedure  db1.proc3
call proc3(1);

-- case 语句

create procedure proc4(in p int)
begin

	declare pa int;
	set pa = p + 1;
	case pa
		when 0 then
			select '结果为0';
		when 1 then
			select '结果为1';
		else
			select '结果为其它';
	end case;
end

call proc4(-1);


-- 循环语句 while

create procedure proc5()
begin

	declare n int;
	set n = 0;
	while n<6 do
 		select concat('当前的n:', n);
		set n = n + 1;
	end while;

end;

drop procedure if exists db1.proc5
call proc5()

-- 循环语句 repeat

create procedure proc6()
begin

	declare n int;
	set n = 0;
	repeat 
 		select concat('当前的n:', n);
		set n = n + 1;
	until n > 5
	end repeat;

end;
drop procedure if exists db1.proc6
call proc6()


-- 循环语句 loop

create procedure proc7()
begin
	declare n int;
	set n = 0;
	loop_labelaaa: loop
 		select concat('当前的n:', n);
		set n = n + 1;
		if n > 5 then
			leave loop_labelaaa;
		end if;
	end loop;
end;
drop procedure if exists db1.proc7
call proc7()

-- 循环语句 itrate。ghf认为，就是相当于 有continue的用法
CREATE PROCEDURE proc10()
begin
	declare v int;
	set v=0;
	LOOP_LABLE:loop
		if v=3 or v = 5 then
			select '跳过';
			set v=v+1;
			ITERATE LOOP_LABLE;
		end if;
		select concat('v: ', v);
		set v=v+1;
		
		if v>=10 then
			leave LOOP_LABLE;
		end if;
	end loop;
end;

drop procedure if exists db1.proc10
call proc10();


-- 测试 while 用continue
create procedure proc11()
begin
	declare n int;
	set n = 0;
	label_while: while n<10 do
		if n = 2 or n = 4 then
			select '跳过';
			set n = n + 1;
			iterate label_while;
		end if;
 		select concat('当前的n:', n);
		set n = n + 1;
	end while;
end;

drop procedure if exists db1.proc11
call proc11()

-- springboot 测试调用存储函数
create procedure changeUser(in departmentName1 varchar(50) , in departmentName2 varchar(50) 
	, out size1 integer, out size2 integer)
begin

-- 部门1，状态改为 当班/休息
declare res integer; -- 注意，声明一定要放在 我们的正式语句之前，比如select、update等语句之前

select departmentName1;

select count(*) into res from tb_user where departmentname = departmentName1;
set size1 = res;
select CONCAT('部门1要修改的数量：',size1);

update tb_user set workstatus = '当班中' where departmentname = departmentName1;

-- 部门2，状态改为 休息/当班
select departmentName2;

select count(*) into size2 from tb_user where departmentname = departmentName2;
select CONCAT('部门2要修改的数量：',size2);

update tb_user set workstatus = '休息中' where departmentname = departmentName2;

end;

show create procedure db1.changeUser
drop procedure if exists db1.changeUser;

set @p = 0;
set @p2 = 0;
call changeUser('深圳市国家气候观象台', '深圳市气象局', @p, @p2);
call changeUser('深圳市气象局', '深圳市国家气候观象台', @p, @p2);


-- 测试java 调用存储过程，返回对象
-- ghf结论：可能不会有参数为表记录对象的存储函数。原因：参数xxx，select xxx from、select yyy from t where xxx = ，xxx会多次重名; 
-- 可能不会有返回结果也为表对象的存储函数，原因：返回设置返回值 select xxx into xxx，重名了
create procdure getbyuser(in id INTEGER, in name char(20), out nextuser char(20))
begin
	
	select name from tb_user where id = xxx;

end;

set @p = null;
select * into @p from tb_user where id = 4;



