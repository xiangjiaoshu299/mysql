-- 显示索引
show index from smdevice2.tb_user;

-- 准备数据
select rand();-- 生成一个0~1的随机数，精确到小数点后很多位，ghf见过16、17位
select rand(1), rand(1), rand(2);

-- 创建一个随机生成名字的函数
CREATE DEFINER=`root`@`localhost` FUNCTION `create_name`() RETURNS varchar(10) CHARSET utf8
BEGIN
	
	DECLARE xing varchar(2056) DEFAULT '赵钱孙李周郑王冯陈楮卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶姜戚谢喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮齐康伍余元卜顾孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈项祝董梁杜阮蓝闽席季麻强贾路娄危江童颜郭梅盛林刁锺徐丘骆高夏蔡田樊胡凌霍虞万支柯昝管卢莫经裘缪干解应宗丁宣贲邓郁单杭洪包诸左石崔吉钮龚程嵇邢滑裴陆荣翁';
	
	DECLARE ming varchar(2056) DEFAULT '嘉懿煜城懿轩烨伟苑博伟泽熠彤鸿煊博涛烨霖烨华煜祺智宸正豪昊然明杰诚立轩立辉峻熙弘文熠彤鸿煊烨霖哲瀚鑫鹏致远俊驰雨泽烨磊晟睿天佑文昊修洁黎昕远航旭尧鸿涛伟祺轩越泽浩宇瑾瑜皓轩擎苍擎宇志泽睿渊楷瑞轩弘文哲瀚雨泽鑫磊梦琪忆之桃慕青问兰尔岚元香初夏沛菡傲珊曼文乐菱痴珊恨玉惜文香寒新柔语蓉海安夜蓉涵柏水桃醉蓝春儿语琴从彤傲晴语兰又菱碧彤元霜怜梦紫寒妙彤曼易南莲紫翠雨寒易烟如萱若南寻真晓亦向珊慕灵以蕊寻雁映易雪柳孤岚笑霜海云凝天沛珊寒云冰旋宛儿绿真盼儿晓霜碧凡夏菡曼香若烟半梦雅绿冰蓝灵槐平安书翠翠风香巧代云梦曼幼翠友巧听寒梦柏醉易访旋亦玉凌萱访卉怀亦笑蓝春翠靖柏夜蕾冰夏梦松书雪乐枫念薇靖雁寻春恨山从寒忆香觅波静曼凡旋以亦念露芷蕾千兰新波代真新蕾雁玉冷卉紫山千琴恨天傲芙盼山怀蝶冰兰山柏翠萱乐丹翠柔谷山之瑶冰露尔珍谷雪乐萱涵菡海莲傲蕾青槐冬儿易梦惜雪宛海之柔夏青亦瑶妙菡春竹修杰伟诚建辉晋鹏天磊绍辉泽洋明轩健柏煊昊强伟宸博超君浩子骞明辉鹏涛炎彬鹤轩越彬风华靖琪明诚高格光华国源宇晗昱涵润翰飞翰海昊乾浩博和安弘博鸿朗华奥华灿嘉慕坚秉建明金鑫锦程瑾瑜鹏经赋景同靖琪君昊俊明季同开济凯安康成乐语力勤良哲理群茂彦敏博明达朋义彭泽鹏举濮存溥心璞瑜浦泽奇邃祥荣轩';
	
	DECLARE len_xing int DEFAULT LENGTH(xing) / 3; -- 这里的长度不是字符串的字数,而是此字符串的占的容量大小,一个汉字占3个字节
	
	DECLARE len_ming int DEFAULT LENGTH(ming) / 3;
	DECLARE res varchar(255) DEFAULT '';

	# 先选出姓
	SET res = CONCAT(res, SUBSTRING(xing, FLOOR(1 + RAND() * len_xing), 1));
	#再选出名
	SET res = CONCAT(res, SUBSTRING(ming, FLOOR(1 + RAND() * len_ming), 1));
  #再选出名
	IF RAND()>0.400 THEN	
		SET res = CONCAT(res, SUBSTRING(ming, FLOOR(1 + RAND() * len_ming), 1));
	END IF;

	RETURN res;
END

select SUBSTRING('abcdefg',2,3);-- 函数下标，从1开始
select LENGTH('abcde');
select LENGTH('你好啊中国');-- 一个汉字，占长度3

-- 测试
select create_name();

-- 中文转拼音
CREATE FUNCTION `fristPinyin`(P_NAME VARCHAR(255)) RETURNS varchar(255) CHARSET utf8
BEGIN
    DECLARE V_RETURN VARCHAR(255);
    SET V_RETURN = ELT(INTERVAL(CONV(HEX(left(CONVERT(P_NAME USING gbk),1)),16,10), 
        0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7, 
        0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,
        0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),    
    'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z');
    RETURN V_RETURN;
END
--
CREATE FUNCTION `pinyin`(P_NAME VARCHAR(255)) RETURNS varchar(255) CHARSET utf8
BEGIN
    DECLARE V_COMPARE VARCHAR(255);
    DECLARE V_RETURN VARCHAR(255);
    DECLARE I INT;
    SET I = 1;
    SET V_RETURN = '';
    while I < LENGTH(P_NAME) do
        SET V_COMPARE = SUBSTR(P_NAME, I, 1);
        IF (V_COMPARE != '') THEN
            #SET V_RETURN = CONCAT(V_RETURN, ',', V_COMPARE);
            SET V_RETURN = CONCAT(V_RETURN, fristPinyin(V_COMPARE));
            #SET V_RETURN = fristPinyin(V_COMPARE);
        END IF;
        SET I = I + 1;
    end while;
    IF (ISNULL(V_RETURN) or V_RETURN = '') THEN
        SET V_RETURN = P_NAME;
    END IF;
    RETURN V_RETURN;
END
-- 测试
select pinyin('郭厚发');


-- 建立测试数据表
drop table if exists tstudent;
create table tstudent(
	studentid varchar(10),
	sname varchar(10),
	sex varchar(2),
	cardid varchar(18),
	birthday varchar(20),
	email varchar(20),
	course varchar(20),
	createtime timestamp
)

-- 插入测试数据
select  LPAD(CEIL(rand() * 500000) ,10,'0')
select if(CEIL(rand() * 10) % 2 = 0 , '男', '女');
select RPAD(floor(rand() * 1000000000000000000),18,'0');
select CONCAT(ceil(rand() * 10) + 1980,'-', LPAD(ceil(rand() * 12),2,'0'), '-', LPAD(ceil(rand() * 28),2,'0'));
select case ceil(rand() * 3) when 1 then '网站开发' when 2 then '游戏开发' else '.NET' end

insert into tstudent values(
	LPAD(CEIL(rand() * 500000) ,10,'0'),
	create_name(),
	if(CEIL(rand() * 10) % 2 = 0 , '男', '女'),
	RPAD(floor(rand() * 1000000000000000000),18,'0'),
	CONCAT(ceil(rand() * 10) + 1980,'-', LPAD(ceil(rand() * 12),2,'0'), '-', LPAD(ceil(rand() * 28),2,'0')),
	pinyin(sname),
	case ceil(rand() * 3) when 1 then '网站开发' when 2 then '游戏开发' else '.NET' end,
	now()
)

-- 创建添加学生的存储函数
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_student`(in num int)
BEGIN
	declare i int;

	delete from tstudent;

	set i = 1;

	while num >= i do
		insert into tstudent values(
				LPAD(CEIL(rand() * num) ,10,'0'),
				create_name(),
				if(CEIL(rand() * 10) % 2 = 0 , '男', '女'),
				RPAD(floor(rand() * 1000000000000000000),18,'0'),
				CONCAT(ceil(rand() * 10) + 1980,'-', LPAD(ceil(rand() * 12),2,'0'), '-', LPAD(ceil(rand() * 28),2,'0')),
				pinyin(sname),
				case ceil(rand() * 3) when 1 then '网站开发' when 2 then '游戏开发' else '.NET' end,
				now()
			);
			
		set i = i + 1;
	end while;

END

-- 调用存储函数
call add_student(500000);-- 花费1600s左右

-- 查询cardId 是12345开头的记录
select * from tstudent where cardid like '12345%';-- 0.3s，加了索引之后，0.02s

-- 加索引。
alter table tstudent add index cardid_index(cardid);

-- 查询姓名是刘开头的
select * from tstudent where sname like '赵%'; -- 0.4s，加索引后0.04s
explain select * from tstudent where sname like '赵%';
-- 加索引
alter TABLE tstudent add index sname_index(sname);

-- 查看索引所占的磁盘空间
select * from information_schema.tables 
where table_schema like 'db1';

select CONCAT(round(sum(index_length) / (1024 * 2014), 2),'MB') as index_total_size from information_schema.tables 
where table_schema like 'db1';

-- 查看数据所占磁盘空间
select CONCAT(round(sum(data_length) / (1024 * 1014), 2),'MB') as data_total_size from information_schema.tables 
where table_schema like 'db1';

-- 查看是否使用了索引
explain select * from tstudent where cardid like '12345%';

-- 看排序的结果
select email from tstudent order by email;-- 不加索引 1.16s、0.8s; 加了索引之后：0.43s
explain select email from tstudent order by email;-- 不加索引 extra: using filesort 文件排序;  加索引extra：Using Index索引排序

-- 加索引
alter table tstudent add index email_index(email);