-- 新建表，timestamp类型的话会自动更新
drop TABLE if exists testtime2
create table testtime2(
	id int,
	value char,
	ts timestamp,
	dt datetime
)
insert into `testtime2` values(2, 'a', null, null);
update testtime2 set value = 'b' where id = 1;


-- timestamp类型，修改表字段为，可以自动设置创建、自动更新时间
ALTER TABLE testtime modify dtimestamp timestamp
insert into `testtime` values(null, 100, null, null);
update `testtime` set val = 101 where id = 1;

-- datetime类型，修改表字段为，可以自动设置创建时间
ALTER TABLE testtime modify ddatetime datetime not null default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
-- insert into 'testtime' values(null, 'a', null, null) 插入失败，因为datetime类型，允许null值合法
insert into `testtime` (val) values('a');
update `testtime` set val = 'b' where id = 1;

-- 新建表，datetime类型，配置自动设置当前时间。
CREATE TABLE `testtime3` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8_bin,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
insert into `testtime3` (name) values('aaa');
update `testtime3` set name = 'c' where id = 1;
