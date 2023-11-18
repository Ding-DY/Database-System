#实验题目1：定义视图反映学生学号、姓名以及选修的总学分。
CREATE VIEW StudentTotalCredits AS
SELECT Student.Sno,
       Student.Sname,
       SUM(Course.Ccredit) AS TotalCredits
FROM Student
         JOIN
     SC ON Student.Sno = SC.Sno
         JOIN
     Course ON SC.Cno = Course.Cno
GROUP BY Student.Sno,
         Student.Sname;


#实验题目2：定义“CS”系学生视图，并要求进行修改和插入操作时仍需保证视图只有“CS”系的学生。

#创建视图
CREATE VIEW CS_Students AS
SELECT *
FROM Student
WHERE Sdept = 'CS';

#创建触发器
-- 插入触发器
DELIMITER //
CREATE TRIGGER before_insert_student
    BEFORE INSERT
    ON Student
    FOR EACH ROW
BEGIN
    IF NEW.Sdept <> 'CS' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only CS department students can be inserted';
    END IF;
END//
DELIMITER ;

-- 更新触发器
DELIMITER //
CREATE TRIGGER before_update_student
    BEFORE UPDATE
    ON Student
    FOR EACH ROW
BEGIN
    IF NEW.Sdept <> 'CS' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Can only update CS department students';
    END IF;
END//
DELIMITER ;

#查看视图内容
SELECT *
FROM CS_Students;

#测试插入操作
-- 应该成功
INSERT INTO Student (Sno, Sname, Ssex, Sage, Sdept)
VALUES ('201215126', '张三', '男', 20, 'CS');

-- 应该失败
INSERT INTO Student (Sno, Sname, Ssex, Sage, Sdept)
VALUES ('201215127', '李四', '女', 21, 'MA');

#测试更新操作
-- 更新 CS 系学生的姓名，应该成功
UPDATE Student
SET Sname = '王五'
WHERE Sno = '201215121';

-- 尝试将 CS 系学生改为其他系，应该失败
UPDATE Student
SET Sdept = 'MA'
WHERE Sno = '201215121';


#实验题目3：在视图上查询“李勇”已选修的学分数。
SELECT SUM(Course.Ccredit) AS TotalCredits
FROM CS_Students
         JOIN SC ON CS_Students.Sno = SC.Sno
         JOIN Course ON SC.Cno = Course.Cno
WHERE CS_Students.Sname = '李勇';


#实验题目4：自行定义视图，并完成基于视图的查询以及更新视图

#定义视图
#建一个视图名为 StudentCourseScores，它将显示每位学生的姓名、所选课程及其成绩。
CREATE VIEW StudentCourseScores AS
SELECT Student.Sname, Course.Cname, SC.Grade
FROM Student
         JOIN SC ON Student.Sno = SC.Sno
         JOIN Course ON SC.Cno = Course.Cno;


#基于视图的查询
#查询“李勇”所选的所有课程以及对应的成绩
SELECT *
FROM StudentCourseScores
WHERE Sname = '李勇';


#更新视图
#更新 “李勇” 在指定课程上的成绩。
UPDATE SC
SET Grade = 100
WHERE Sno = (SELECT Sno FROM Student WHERE Sname = '李勇')
  AND Cno = (SELECT Cno FROM Course WHERE Cname = '数据库');
