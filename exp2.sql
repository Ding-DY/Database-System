#实验二：利用SQL语言完成数据库维护


#实验题目1：修改学生的年龄加1岁
update student
set Sage=Sage + 1;

#实验题目2：对课程表中每门课的学分加一
update course
set Ccredit=Ccredit + 1;

#实验题目3：删除某个学生的选课记录
delete
from sc
where Sno = 201215123;

#实验题目4：修改“CS”的学生成绩，不及格学生的成绩增加5分
update sc
set Grade = Grade + 5
where Sno in (select Sno
              from Student
              where Sdept = 'CS')
  and Grade < 60;

#实验题目5：删除“IS”系学生的成绩记录。
delete
from sc
where Sno in (select Sno
              from Student
              where Sdept = 'IS');

#实验题目6：修改“数据库”课程的学分为3。
update course
set Ccredit=3
where Cname = '数据库';