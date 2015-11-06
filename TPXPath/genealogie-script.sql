/*create table personne(
  id_pers number(6) constraint personne_pkey primary key,
  nom varchar2(30) not null,
  prenom varchar2(50) not null,
  sexe char(1) not null,
  constraint verif_homme_femme check (sexe in ('H','F')),
  naissance number(4),
  deces number(4),
  id_pere number(6) constraint enfant_pere_fkey references personne,
  id_mere number(6) constraint enfant_mere_fkey references personne
);

insert into personne values(16,'BOUREL','Vincent','H',null,1677,null,null);
insert into personne values(17,'LANLOUP','Jeanne','F',1610,1662,null,null);
insert into personne values(161,'BERTHELOT','Pierre','H',1620,1678,null,null);

insert into personne values(18,'BOUREL','Guillaume','H',1638,1698,16,17);
insert into personne values(19,'BERTHELOT','Jacquette','F',1642,null,161,null);
insert into personne values(20,'BOUREL','Jeanne','F',1640,null,16,17);
insert into personne values(21,'BOUREL','Guillaume','H',1669,1669,18,19);
insert into personne values(22,'BOUREL','Jean','H',1678,null,18,19);
insert into personne values(26,'BOUREL','Auguste','H',1728,1752,22,null);
insert into personne values(23,'BOUREL','Guillaume','H',1680,1743,18,19);
insert into personne values(24,'BOSAY','Marguerite','F',1669,null,null,null);
insert into personne values(25,'BOUREL', 'Marie','F', 1691,1745,23,24);

insert into personne values(1,'OMNES','Pierre','H',1718,1785,null,null);
insert into personne values(2,'JOUIN','Marie','F',1712,1778,null,null);
insert into personne values(3,'OMNES','Guillaume','H',1743,1803,1,2);
insert into personne values(31,'OMNES','Henriette','F',1739,1790,1,2);
insert into personne values(4,'LUCAS','Henri','H',1704,1786,null,null);
insert into personne values(52,'CORNEC','Pierre','H',1688,null,null,null);

insert into personne values(5,'CORNEC','Marie','F',1710,1783,52,25);

insert into personne values(6,'LUCAS','Marie','F',1736,1818,4,5);
insert into personne values(7,'OMNES','Yves','H',1780,1818,3,6);
insert into personne values(71,'OMNES','Jean','H',1761,1820,3,6);
insert into personne values(72,'OMNES','Madeleine','F',1763,1815,3,6);

insert into personne values(8,'LE GUYADER','Guillaume','H',1693,null,null,null);
insert into personne values(9,'LE BONNIEC','Catherine','F',1695,1746,null,null);
insert into personne values(10,'LE GUYADER', 'Guillaume','H',1734,1778,8,9);
insert into personne values(101,'LE GUYADER', 'Henri','H',1725,1759,8,9);
insert into personne values(11,'LE GUIADER', 'Louis', 'H',null,null,null,null);
insert into personne values(12,'LE DEREAT','Jeanne','F',null,1780,null,null);
insert into personne values(13,'LE GUIADER', 'Françoise','F',1734,1799,11,12);
insert into personne values(14,'LE GUYADER', 'Marie-Jeanne','F',1776,1824,10,13);
insert into personne values(141,'LE GUYADER', 'Anne','F',1771,1822,10,13);

insert into personne values(15,'OMNES','Guillaume','H',1815,1856,7,14);
insert into personne values(151,'OMNES','Sophie','F',1810,1862,7,14);
insert into personne values(152,'OMNES','Françoise','F',1812,1871,7,14);

insert into personne values(27,'CORNEC','Paul','H',null,null,52,25);
insert into personne values(51,'CORNEC','Jeanne','F',1709,1775,52,25);*/

select XMLELEMENT(name "genealogies",
        XMLAGG(
          XMLELEMENT(
            name "personne",
            XMLATTRIBUTES(
              ID_PERS as "id",
              SEXE as "sexe"
            ),
            XMLFOREST(nom as "nom", prenom as "prenom", naissance as "naissance", deces as "deces", id_pere as "pere", id_mere as "mere"))
        )        
      )
from PERSONNE;
