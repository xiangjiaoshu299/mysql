-- 创建索引
alter table tb_station add index idx_createdate(createdate);
alter table tb_station add index idx_name(name);


-- 走索引查询
explain
select * from tb_station
where code = 'G1120'

explain
select * from tb_station
where createdate = '2016-10-18 10:24:15'


-- ===================================================索引失效的情况

-- # 索引失效情况1：索引上使用函数

-- ## date_fromat()函数导致失效

-- ### 索引失效
explain
select * from tb_station
where DATE_FORMAT(createdate,'%Y-%m-%d %H:%i:%s') = '2016-10-18 10:24:15'

-- ### 优化：日期转字符串->字符串转日期，索引有效
explain
select * from tb_station
where createdate = STR_TO_DATE('2016-10-18 10:24:15','%Y-%m-%d %H:%i:%s')

-- ## substr() 函数导致失效
-- 索引失效
explain
select * from tb_station
where INSTR(name, '基地')  > 0

-- 索引失效
explain
select * from tb_station
where locate('基地', name)  > 0

-- 索引失效
explain
select * from tb_station
where POSITION('基地' in name)  > 0

-- 尝试优化1，失败，仍然走索引
explain
select * from(
	select t1.*, INSTR(name, '基地') strPos from tb_station t1
)t2
where t2.strPos > 1


-- # 索引失效情况2：like条件中%放在左边

-- 不走索引
explain
select * from tb_station
where code like '%1120'
-- 走索引
explain
select * from tb_station
where code like 'G11%'


-- # 不走索引的情况3: not like
-- 不走索引
explain
select * from tb_station
where code not like 'G11%'


-- # 索引失效的情况4：索引和运算结合在了一起
-- 不走索引的情况
explain
select * from tb_station
where id / 2 > 10

-- 优化，走了主键索引
explain
select * from tb_station
where id > 20


-- # 不走索引的情况5：字符串出现隐式转换
-- 不走索引
explain
select * from tb_station
where code = 4

-- 走索引
explain
select * from tb_station
where code = '4'


-- # 索引失效的情况6，查询记录数超过 1/5
-- 不走索引。此时有458条记录，查询结果133条
explain
select * from tb_station
where createdate > STR_TO_DATE('2019-01-01 00:00:00', '%Y-%m-%d %H:%i:%s')

-- 不走索引。此时有458条记录，查询结果133条
explain
select * from tb_station
where createdate >= '2019-01-01 00:00:00'

-- 走索引。此时有3条查询结果，共400+条记录
explain
select * from tb_station
where createdate > STR_TO_DATE('2020-05-17 00:00:00', '%Y-%m-%d %H:%i:%s')

-- 走索引。此时有3条查询结果，共400+条记录
explain
select * from tb_station
where createdate >= '2020-05-17 00:00:00'


-- # 索引失效的情况6，or的几个条件中，有1个没有用索引？？？？？？？？？？？？？？


-- =========================================================可能不走索引的情况

-- # 可能不走索引的情况1：非主键字段不等于。负向索引的话，这个看你的数据量，用不用，是优化器说了算
-- 不走索引
explain
select * from tb_station
where code != '4'

-- 走索引
explain
select * from tb_station
where id != 1523


-- # 可能不走索引的情况2：非主键字段不包含
-- 不走索引
explain
select * from tb_station
where code not in('4')

-- 走索引
explain
select * from tb_station
where id not in(1523)


