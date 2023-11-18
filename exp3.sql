#实验三 利用SQL语句完成数据库查询

#实验题目1：查询平均成绩大于80的学生姓名
SELECT Sname
FROM student
         JOIN sc ON student.Sno = sc.Sno
GROUP BY student.Sno
HAVING AVG(sc.Grade) > 80;

#实验题目2：查询课程成绩大于课程平均成绩的选课信息，显示学生姓名、课程名称和成绩

/*SELECT S.Sname, C.Cname, SC.Grade
FROM student S
         JOIN sc ON S.Sno = sc.Sno
         JOIN course C ON sc.Cno = C.Cno
WHERE sc.Grade > (SELECT AVG(Grade)
                  FROM sc
                  WHERE Cno = sc.Cno);*/


SELECT S.Sname, C.Cname, SC.Grade
FROM Student S
         JOIN SC ON S.Sno = SC.Sno
         JOIN Course C ON SC.Cno = C.Cno
         JOIN (SELECT Cno, AVG(Grade) AS AvgGrade
               FROM SC
               GROUP BY Cno) AS CourseAvg ON SC.Cno = CourseAvg.Cno
WHERE SC.Grade > CourseAvg.AvgGrade;

#实验题目3：查询至少选修了C1和C2课程的学生名单。
SELECT DISTINCT s.Sname
FROM Student s
         JOIN SC sc1 ON s.Sno = sc1.Sno
         JOIN SC sc2 ON s.Sno = sc2.Sno
WHERE sc1.Cno = '1'
  AND sc2.Cno = '2';


#实验题目4:查询选修了C1课程而没有选修C2课程的学生名单。
SELECT S.Sname
FROM Student S
WHERE S.Sno IN (SELECT SC.Sno
                FROM SC
                WHERE SC.Cno = '1')
  AND S.Sno NOT IN (SELECT SC.Sno
                    FROM SC
                    WHERE SC.Cno = '2');


#实验题目5：统计每门课程成绩大于80分的学生数。
SELECT Course.Cno, Course.Cname, COUNT(*) AS NumberOfStudents
FROM SC
         JOIN Course ON SC.Cno = Course.Cno
WHERE SC.Grade > 80
GROUP BY Course.Cno, Course.Cname;


#实验题目6：统计计算机系“CS”学生的平均分
SELECT AVG(SC.Grade) AS AvgGrade
FROM Student
         JOIN SC ON Student.Sno = SC.Sno
WHERE Student.Sdept = 'CS';

#实验题目7：统计至少选修了两门课程的学生数
SELECT COUNT(*) AS Sub
FROM (SELECT Sno
      FROM SC
      GROUP BY Sno
      HAVING COUNT(Cno) >= 2) AS SubQuery;

#实验题目8：查询至少选修了两门课程的学生名单
SELECT Student.Sname
FROM SC
         JOIN Student ON SC.Sno = Student.Sno
GROUP BY Student.Sno
HAVING COUNT(SC.Cno) >= 2;

#实验题目9：查询没有被选修的课程信息
SELECT Course.Cno, Course.Cname
FROM Course
         LEFT JOIN SC ON Course.Cno = SC.Cno
WHERE SC.Cno IS NULL;

#实验题目10:查询没有选修C1课程的学生信息
SELECT Student.*
FROM Student
         LEFT JOIN SC ON Student.Sno = SC.Sno AND SC.Cno = '1'
WHERE SC.Sno IS NULL;
