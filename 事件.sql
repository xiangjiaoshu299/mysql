-- 查看事件执行器状态
show variables like '%event_scheduler%'

-- 开启
set global event_scheduler = ON

-- 查看事件
show events
select * from mysql.event;
select * from information_schema.events

-- 删除事件
drop event xxx

-- 禁用事件
alter event xxx enable

-- 启用事件
alter evenet xxx disable

-- 准备表
create table eve_tbl(
	timeline TIMESTAMP
)

-- 创建事件：每隔一秒钟，插入一条记录
create event insert_into_eve_tbl_second
on schedule every 1 second
do insert into eve_tbl values(current_timestamp);

-- 禁用事件
alter event insert_into_eve_tbl_second DISABLE;

-- 删除事件
drop event insert_into_eve_tbl_second;

-- 创建事件：在某个时间点，插入一条记录
create event insert_inton_eve_tbl_time
on schedule at TIMESTAMP '2019-09-05 08:01:00'
do insert into eve_tbl values(CURRENT_TIMESTAMP)


-- 创建事件：在某个时间点，清空一张表，执行完之后保存该事件
create event truncate_eve_tbl_time
on schedule at timestamp '2019-09-05 08:05:00'
on completion preserve
do truncate table eve_tbl

-- 创建事件：5天后每天清空表，1个月之后停止执行
create event truncate_eve_tbl_day
on schedule EVERY 1 DAY
STARTS current_timestamp + interval 5 DAY
ENDS CURRENT_TIMESTAMP + INTERVAL 30 DAY
on completion PRESERVE
do TRUNCATE TABLE eve_tbl

-- 创建事件：1分钟后每20秒清空表，2分钟停止执行
drop event if exists truncate_eve_tbl_day
select * from information_schema.events;

create event truncate_eve_tbl_day
on schedule EVERY 20 SECOND
STARTS current_timestamp + interval 1 MINUTE
ENDS CURRENT_TIMESTAMP + INTERVAL 2 MINUTE
on completion PRESERVE
do TRUNCATE TABLE eve_tbl


