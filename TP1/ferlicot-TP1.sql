create synonym T for rousseaou.T

--Question 2

UPDATE T set A = A+1;
commit;


-- Question 3
INSERT INTO T values (3, 7);
select * FROM T;
DELETE FROM T WHERE A=2;
DELETE FROM T WHERE A=1;
commit

-- Question 4
UPDATE T set B=2 WHERE B=3;
select * from T
update T set A=3 where A=2;
commit

-- Question 5
update T set B=10 where B=0;
select * from T;
update T set A=5 where A=3;
commit
select * from T

-- Question 6

select * from T;
update T set A=A+1;
commit

select * from T
update T set A=A+1
commit

-- Question 7
set transaction isolation level serializable;
select * from T;
update T set B=9 where B=10;

select * from T;

select * from T;
update T set B=3 where B=2;
select * from T;

rollback;
select * from T;

--Question 8

select * from T;
select * from T for update;
commit;

-- Question 9

select * from T;
lock table T in exclusive mode nowait;
commit;

-- Question 10
select * from rousseau.S;
select * from rousseau.S;

-- Question 11
SET SERVEROUTPUT ON;

create or replace procedure p(i1 NUMBER, i2 NUMBER) is
begin
  insert into T values (i1,i2);
  insert into T values (i1,i2+1);
  insert into T values (i1+1, i2+1);
  commit;
exception when others then dbms_output.put_line('pb insertion'); commit;
end;


-- Question 18 
exec rousseau.lock_ligne_t(90,91);
exec rousseau.lock_ligne_t(82,81);
commit