--http://www.fil.univ-lille1.fr/~caronc/SGBD/TP_SQLXML.html

/*create table pays(
  ref_pays NUMBER(2) constraint pays_pkey primary key,
  nom VARCHAR2(30) not null,
  nb_habitants NUMBER(10) not null
) ;

create table ville(
  ref_ville NUMBER(3) constraint ville_pkey primary key,
  nom VARCHAR2(30) not null,
  nb_habitants NUMBER(10) not null,
  ref_pays NUMBER(2) not null constraint ville_pays_fkey references pays
);


insert into pays values (1,'france',61000000);
insert into pays values (2,'cameroun',15700000);
insert into pays values (3,'maroc',29600000);
insert into pays values (4,'royaume uni',59000000);
insert into pays values (5,'mexique',100000000);
insert into pays values (6,'canada',31000000);
insert into pays values (11,'Ã©tats unis',288000000);
insert into pays values (8,'turquie',70000000);
insert into pays values (9,'japon',127000000);
insert into pays values (10,'espagne',39500000);
insert into pays values (7,'chine',1280400000);
insert into pays values (12,'senegal',10000000);
insert into pays values (13,'allemagne',82000000);

insert into ville values(10,'guadalajara',1630000,5);
insert into ville values(15,'bordeaux',685000,1);
insert into ville values(20,'toronto',3400000,6);
insert into ville values (25,'san diego',1257000,11);
insert into ville values (30,'izmir',1700000,8);
insert into ville values (40,'houston',1600000,11);
insert into ville values(45,'sheffields',525600,4);
insert into ville values (50,'nagoya',2100000,9);
insert into ville values (60,'munich',1200000,13);
insert into ville values (65,'rabat',1300000,3);

insert into ville values (70,'douala',1500000,2);
insert into ville values(75,'los angeles',3500000,11);
insert into ville values (80,'shangai',7800000,7);
insert into ville values(90,'dakar',2500000,12);
insert into ville values(95,'nezahualcoyoti',260000,5);
insert into ville values(100,'montrÃ©al',2900000,6);
insert into ville values(110,'mexico',8250000,5);
insert into ville values (120,'fÃ¨s',735000,3);
insert into ville values (125,'detroit',1100000,11);
insert into ville values(130,'washington',3950000,11);

insert into ville values (140,'breme',540000,13);
insert into ville values(145,'monterrey',3664000,5);
insert into ville values(150,'thiÃ¨s',160000,12);
insert into ville values(155,'leeds',710000,4);
insert into ville values(160,'pÃ©kin',7000000,7);
insert into ville values (165,'garoua',357000,2);
insert into ville values (170,'madrid',3120000,10);
insert into ville values (175,'vancouver',1400000,6);
insert into ville values (180,'tokyo',8000000,9);
insert into ville values (185,'valence',760000,10);

insert into ville values (190,'liverpool',470000,4);
insert into ville values (195,'istambul',12000000,8);
insert into ville values (200,'osaka',2500000,9);
insert into ville values (205,'phoenix',1500000,11);
insert into ville values (210,'cologne',950000,13);
insert into ville values (220,'francfort',636000,13);
insert into ville values(230,'ottawa',820000,6);
insert into ville values (240,'paris',9000000,1);
insert into ville values (245,'philadelphie',1450000,11);
insert into ville values (250,'marseille',1087000,1);

insert into ville values (255,'bafoussam',347500,2);
insert into ville values(260,'chicago',2800000,11);
insert into ville values (270,'ankara',2600000,8);
insert into ville values (275,'tijuana',1484000,5);
insert into ville values (280,'yaoundÃ©',1000000,2);
insert into ville values (290,'lille',950000,1);
insert into ville values (295,'san josÃ©',950000,11);
insert into ville values (300,'lyon',1200000,1);
insert into ville values (310,'marrakech',635000,3);
insert into ville values (320,'londres',6750000,4);

insert into ville values (325,'yokohama',3200000,9);
insert into ville values (330,'berlin',3400000,13);
insert into ville values(340,'new york',7350000,11);
insert into ville values (345,'sÃ©ville',680000,10);
insert into ville values (350,'canton',3850000,7);
insert into ville values (360,'birmingham',990000,4);
insert into ville values (365,'dallas',1230000,11);
insert into ville values (370,'casablanca',3200000,3);
insert into ville values (375,'osaka',2500000,9);
insert into ville values (380,'barcelone',1710000,10);
*/
-- QUESTION 1

select xmlelement(name pays, nom) from pays;

-- QUESTION 2
select xmlelement(name pays, 
                    xmlforest(REF_PAYS, NOM, NB_HABITANTS))
from pays;

-- QUESTION 3

select xmlelement(name pays, 
                    XMLATTRIBUTES(REF_PAYS as id),
                    xmlforest( NOM, NB_HABITANTS))
from pays;

-- QUESTION 4

select XMLELEMENT(name les_pays, 
                    XMLAGG(
                      XMLELEMENT(name pays, 
                      XMLATTRIBUTES(REF_PAYS as id),
                      xmlforest( NOM, NB_HABITANTS))))
from pays;

--QUESTION 5

select XMLELEMENT(name ville, 
                    XMLFOREST(VILLE.nom, PAYS.nom as pays))
from VILLE join PAYS on VILLE.REF_PAYS = PAYS.REF_PAYS;

--QUESTION 6
-- JOINTURE
select XMLELEMENT(name pays,
                    XMLATTRIBUTES(PAYS.REF_PAYS as id, PAYS.NOM as NOM),
                    XMLAGG(
                      XMLELEMENT("ville", ville.nom)))
from VILLE join PAYS on VILLE.REF_PAYS = PAYS.REF_PAYS
group by PAYS.REF_PAYS, PAYS.NOM;

-- SOUS REQUÊTE

select 
XMLELEMENT (name "pays",
  XMLAttributes(pays.REF_PAYS as id, pays.NOM as nom),
  (select XMLAGG (XMLELEMENT(name "ville", ville.nom))
  from ville
  where REF_PAYS = pays.ref_Pays)
)
from pays
group by pays.REF_PAYS, pays.nom;

-- QUESTION 7
select 
XMLELEMENT(name "pays", 
  XMLATTRIBUTES(
    (select count(*)
    from ville
    where ville.REF_PAYS = pays.REF_PAYS
    ) as nb_villes
  ),
  pays.nom
)
from pays;

-- QUESTION 8

select 
XMLELEMENT(name "les_pays",
  XMLAGG(
    XMLELEMENT(name "pays",
      XMLATTRIBUTES(pays.REF_PAYS as id),
      XMLELEMENT(name "nom", pays.nom) ,
      XMLELEMENT(name "villes",
        (select XMLAGG(
          XMLELEMENT(name "ville",
          ville.nom,
          ville.nb_habitants
        ))
        from ville
        where ville.ref_pays = pays.ref_pays
      )
    )
  )
))
from pays;