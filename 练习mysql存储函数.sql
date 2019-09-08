
-- 创建
create function fun1(pname char(50))
returns varchar(50)
begin

	declare res varchar(50);
	select cn into res from tb_user
	where name = pname;
	return res;

end;

select fun1('guohf')

-- 查询
show create function db1.fun1;
select * from mysql.proc where name='fun1'

-- 修改
alter function fun1
reads SQL data
sql security invoker
comment '注释1'

select * from mysql.proc where name='fun1'


-- 删除
drop function if exists fun1

-- 创建，测试char不加括号、打印、用set赋值
CREATE FUNCTION FUN2(pid int)
RETURNS varchar(20)-- varchar必须要声明长度，char可以不声明长度，但是调用的话，长度不够会报错
begin

	-- 	select '测试打印' select，必须结合into，否则创建失败
	
	declare name varchar(20);
	select cn into name from tb_user where id = pid;
	
	-- 使用set，取不到cn的值
	-- select cn from tb_user where id = pid;
	-- set name = cn;
	
	set name = CONCAT('自定义前缀' ,name);
	
	return name;
	
end;

drop function if exists db1.fun2
select * from mysql.proc where name='fun2'
select fun2(25);

-- ghf分析存储函数的优缺点
create function fun3()
RETURNs varchar(50)
begin

	declare res varchar(50);
	
	-- select 'aaa'; --错误。select 必须结合 into使用
	
	
-- 	select name into res from tb_user where id = 25;
-- 	select cn into res from tb_user where id = 25;-- 正确可以有多个select，可以没有select

	select 'bbb' into res ;-- 正确
	set res = 'ccc';
	
	return res;
end;

drop function if exists db1.fun3;


-- ghf认为存储过程、存储函数谁更好用？
-- 存储过程好用。
-- 存储过程，可以用select打印，方便调试
-- 存储过程，可以返回多个值

create function selectDepartmentUserCount(uId integer)
returns long
begin

	DECLARE dId varchar(20);
	DECLARE res long;
	
	select departmentid into dId from tb_user where id = uId;
	select count(*) into res from tb_user where departmentid = dId;
	
	return res;

end;

drop function if exists db1.selectDepartmentUserCount
select selectDepartmentUserCount(129);



