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


-- # 索引失效的情况6，or的几个条件中，有1个没有用索引
-- 不走索引。因为address这个字段没有加索引
explain
select * from tb_station
where createdate < STR_TO_DATE('2016-10-18 10:24:15', '%Y-%m-%d %H:%i:%s')
or address in('深圳市福田区福田街道', '地址aaa') 
-- 走索引。createdate、code都走了索引，整条语句才走索引
explain
select * from tb_station
where createdate < STR_TO_DATE('2016-10-18 10:24:15', '%Y-%m-%d %H:%i:%s')
or code in('T0001', 'T10101') 

-- # 索引失效的情况7。组合索引的表，查询不适用最左依赖原则
-- 走索引。符合最左依赖原则

explain

select * from t_score

where sid in(102, 103)



explain

select * from t_score

where sid in(102, 103) and cid >= 90



-- tip: 这里虽然顺序反了，但是仍然可以

explain

select * from t_score

where cid >= 90 and sid in(102, 103)




-- 不走索引。因为不符合最左依赖原则

explain

select * from t_score

where cid >= 90



-- =====================================================可能使你的索引失效的情况



-- 情况1：负向索引，非主键的索引，使用 not、<> 和 !=，因为数据量的问题，可能会导致索引失效，也可能不失效



-- 不走索引

-- 非主键索引，使用 not in，失效的情况

explain

select * from tb_station

where code not in('4')



-- 非主键索引，使用 != ，失效的情况

explain

select * from tb_station

where code != '4'



-- 非主键索引，使用 <>，失效的情况

EXPLAIN 

select * from tb_station

where code <> 'G1120'





-- 非主键索引，索引使用  or 加范围 （!=，失效时的替代方案），索引也无效

explain

select * from tb_station

where code < 'G1120' or code > 'G1120'





-- 走索引

-- 主键索引，使用!=，有效的情况

explain

select * from tb_station

where id != 1523



-- 主键索引，使用not in，有效的情况

explain

select * from tb_station

where id not in(1523)


-- 非主键索引，使用!=，索引有效的情况

explain

select * from t_score

where score != 90




