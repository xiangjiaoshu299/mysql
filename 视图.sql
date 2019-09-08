-- 创建视图
create view v_fault_acceptor
as
select t1.cn, t2.id, t2.suppliername from tb_user t1
join tb_form_fault t2
on t1.`name` = t2.acceptor

-- 查询
select * from v_fault_acceptor;

-- 创建用户
create user 'pro1'@'%' identified by 'pro1'

-- 查看用户
select host, user, authentication_string from mysql.user;

-- 授权
grant select on db1.v_accept_fault to 'pro1'@'%' IDENTIFIED by 'pro1';

-- 查看权限
show grants;
show grants for 'pro1'@'%'

-- 再次练习操作一次
create view v_inspect_acceptor
as
select t1.cn, t2.id, t2.accepttime from
(
select name, cn from tb_user 
)
t1
join
(
	select id, acceptor, accepttime from tb_form_inspect 
)t2
on t1.name = t2.acceptor

create user 'inspect_pro'@'%' identified by 'inspect_pro';
grant select on db1.v_inspect_acceptor to 'inspect_pro'@'%' identified by 'inspect_pro';-- ？？？这里要密码？？？
show grants;
show grants for 'inspect_pro'@'%';

-- 看看索引。执行计划，与普通看执行计划是一样的
explain select * from v_accept_fault
explain select t1.cn, t2.id, t2.suppliername from tb_user t1
join tb_form_fault t2
on t1.`name` = t2.acceptor

-- 创建简单的视图
create view userCnView
as
select name, cn from tb_user;

select * from userCnView;

-- 删除视图
drop view if exists v_accept_fault

-- ghf的总结，视图作用：
.提供更加安全的查询
.简化我们的查询
.为数据库重构，提供逻辑独立性

-- 通过视图，插入数据。注意：如果有字段是非空，则会报错
insert into userCnView values('v_user1', '视图用户1');
insert into fault_acceptor values('视图用户1', '1QX20190906', '测试公司1');

-- 通过视图，更新数据。
update userCnView set cn = CONCAT(name, '—中文')
where name = 'zhengtao';

-- 查看视图的列
describe v_fault_acceptor; -- 法1
desc v_fault_acceptor; -- 法2
show fields from v_fault_acceptor; -- 法3

-- 查看所有的视图和表
show tables;

-- 修改视图
create or replace view v_fault_acceptor
as
select t1.cn, t2.id from tb_user t1, tb_form_fault t2
where t1.name = t2.acceptor

-- 验证
select * from v_fault_acceptor;


-- 利用视图，创建视图
create view v_inspect_acceptor_simple
as 
select cn, id from v_inspect_acceptor;

-- 验证
select * from v_inspect_acceptor_simple

-- 创建视图：查学生的成绩
create view v_score
as
select t1.studentid, t1.sname, t3.subjectname , t2.mark
from tstudent t1
join tscore t2 on t1.studentid = t2.studentid
join tsubject t3 on t2.subjectid = t3.subjectid;

-- 验证
select * from v_score;

-- 创建视图：基表为v_score，查询课程为 数据结构、算法、英语这3门课程的成绩
create view v_score_3s
as
select studentid 学号
, sname 姓名
, avg(case subjectname when '数据结构' then mark end) 数据结构
, avg(case subjectname when '算法' then mark end) 算法
, avg(case subjectname when '英语' then mark end) 英语
from v_score
group by studentid

-- 测试
select * from v_score_3s;

-- 创建带 check option的视图
create or replace view v_user_liu
as
select * from tb_user
where cn like '刘%'
with check option

-- 查询视图
select * from v_user_liu

-- check option的视图，插入视图
insert into v_user_liu (id, name, cn) values(150, 'zhangsan', '张三'); -- 不符合视图的where条件，失败
insert into v_user_liu (id, name, cn) values(150, 'liumazi', '刘麻子');

-- check option的视图，更新视图
update v_user_liu set cn = '张麻子'
where id = 150; -- 更新失败，因为更新后，不符合视图的where条件

update v_user_liu set cn = '刘麻子2'
where id = 150;

-- check option的视图，删除记录
delete from v_user_liu
where id = 38; -- with check option，不影响删除