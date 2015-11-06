create table T(
  a number(3) constraint t_pkey primary key,
  b number(3) constraint valeur_b check (b between 1 and 5)
);

-- Désactive les contrainte
alter table t disable constraint t_pkey disable constraint valeur_b;

insert into t values (4,2);
insert into t values (1,6);
insert into t values (1,3);
insert into t values (4,9);
insert into t values (3,3);
commit;

-- Question 1.1:

create table exceptions(row_id rowid, 
    owner varchar2(30),
    table_name varchar2(30),
    constraint varchar2(30));


-- Essaye d,activer les contraintes sur la clé primaire et vérifie la table.
alter table t ENABLE VALIDATE constraint t_pkey EXCEPTIONS INTO exceptions;

/*

      Cela lève une erreur car on a désactivé les contraintes sur les clef primaires et on a donc pas vérifié qu'elles étaient bonne. 

      On se retrouve avec deux clef primaires identiques ce qui n'est pas bon. Les lignes (1,6) et (1,3) sont en cause.

*/

-- Question 1.2

-- Idem sur valeur_b
ALTER TABLE t ENABLE VALIDATE CONSTRAINT valeur_b EXCEPTIONS INTO exceptions;

/*

    On a également une erreur puisque B doit être entre 1 et 5 et que l'on a (1,6) et (4,9).

*/

-- Question 1.3
-- Active la contrainte sans vérifier la table déjà existante
ALTER TABLE t ENABLE NOVALIDATE CONSTRAINT valeur_b;

--ok
insert into t values (1,1);
--ko 
insert into t values (1,6);

--Question 1.4

ALTER TABLE t ENABLE NOVALIDATE PRIMARY KEY;

/* ERREUR */

-- EXERCICE 2

-- Question 2.1
create table x(a1 varchar2(5) not null);

create or replace trigger tt1
before insert on x
for each row
begin
   if :new.a1 is null then
      raise_application_error(-20000,'erreur tt1');
   end if;
end;

insert into x values(null);

/*

    Le trigger léve une erreur.

*/

-- Question 2.2

create or replace trigger tt1
after insert on x
for each row
begin
   if :new.a1 is null then
      raise_application_error(-20000,'erreur tt1');
   end if;
end;

insert into x values(null);

/*

    Erreur ORACLE puisque Null n'est pas une valeur.

    Trigger USELESS !

*/


-- EXERCICE 3

create table primaire ( x number(2) primary key, y number(2) );
create table etrange ( x number(2) references primaire, z number(2) );

insert into primaire values (1,1);
commit;

create or replace trigger tt2
after insert on etrange
for each row
begin

    delete from primaire where x=:new.z;

end;

-- Question 3.1

insert into etrange values(1,1);

/*
   Le trigger empêche la suppression de la clé primaire si elle est référencée dans une clé secondaire.
   Le trigger fait un rollback de l'insert.
*/

-- Question 3.2

create or replace trigger tt2
before insert on etrange
for each row
begin

    delete from primaire where x=:new.z;

end;


insert into etrange values(1,1);

/*
   Impossible de créer une clé étrangère qui pointe vers aucune clé primaire
   Le trigger bloque l'insert
*/

drop trigger tt2;

insert into primaire values(2,2);
insert into etrange values(1,2);
commit;

create or replace trigger tt3
after update on etrange
for each row
begin

    delete from primaire where primaire.x = :new.x;

end;

-- Question 3.3

update etrange set x=2 where x=1;

/*
 attempted to delete a parent key value that had a foreign dependency.
 Le contenu des tables est inchangé
*/

drop table etrange;

create table etrange(x number(2) references primaire on delete cascade, z number(2));

create or replace trigger tt2
after insert on etrange
for each row
begin

    delete from primaire where primaire.x=:new.x;

end;

-- Question 3.4

insert into etrange values(2,8);

/*

    A cause de la cascade il cherche à se supprimer lui meme mais comme il est en train de s’insérer il ne peut pas se lire pour se supprimer.

*/

-- EXERCICE 4 

create table Fonction(

    fonc_id number(2) constraint fonc_pkey primary key,

    fonc_lib varchar2(20) not null,

    fonc_sal_min number(6), --plus bas salaire pour cette fonction

    fonc_sal_max number(6), --plus haut salaire pour cette fonction

    constraint coherence_min_max check (fonc_sal_min <= fonc_sal_max)    

);

Create table emp(
    emp_id number(3) constraint emp_key primary key,
    emp_nom varchar(20) not null,
    emp_prenom varchar2(20) not null,
    emp_salaire number(6), -- salaire brut annuel
    emp_fonction number(2) not null constraint emp_fonction_fkey references fonction);


-- Question 4.1

/*
trace salaire
 ________________
|                |
|  fonction_id   |
|________________|
|                |
|       ...      |


insert --> trigger ligne

delete    |  --> trigger ligne 
update   |        insertion d'une ligne dans trace_salaire quand je détecte un problème
                         trigger instruction after

trigger after/before insert on emp for each row :new
select fonc_sal_max, fonc_sal_min
into smax, smin
from fonction
where fonc_id= :new.id_fonction;


select ... into ...
  0 ligne resultat -> NO_DATA_FOUND
  n lignes resultat -> TOO_MANY_ROWS
  

*/

create or replace trigger calcul_min_max
after insert on emp
for each row
declare
   smin fonction.fonc_sal_min%type;
   smax fonction.fonc_sal_max%type;
begin
   select FONC_SAL_MAX, FONC_SAL_MIN into smax, smin
   from fonction
   where :new.emp_fonction = fonc_id;
   if( :new.emp_salaire < smin or smin is null) then
      update fonction set fonc_sal_min = :new.emp_salaire
      where fonc_id= :new.emp_fonction;
   end if;
   if( :new.emp_salaire > smax or smax is null) then
      update fonction set fonc_sal_max = :new.emp_salaire
      where fonc_id= :new.emp_fonction;
   end if;
end;

create or replace trigger calcul_min_max_delete_update
after 


insert into fonction values
(1,"boulanger", null, null);

-- EXERCICE 5




