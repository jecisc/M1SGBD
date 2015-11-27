module namespace mm = "http://cyril/modules";
(: prefixe mm pour 'mes modules' :)

declare namespace foot="http://caronc/schema/foot";
declare default element namespace "http://www.w3.org/1999/xhtml";

declare function mm:generateXML($doc as element(div), $jour as xs:integer) as element(journée){
  <journée num="{$jour}">{
    for $tr in ($doc/descendant::tbody/tr)
    return mm:generateRencontre($tr)
  }
  </journée>
};

declare function mm:generateRencontre($tr as element(tr)) as element(rencontre){
  <rencontre>{
    mm:generateClubRec(), 
    mm:generateClubInv(), 
    mm:generateDate(), 
    mm:generateScoreRec(), 
    mm:generateScoreInv()
  }
  </rencontre>
};

declare function mm:generateClubRec() as element (clubReceveur){
     <clubReceveur>Mon</clubReceveur>
};

declare function mm:generateClubInv() as element (clubInvité){
    <clubInvité>Tou</clubInvité>  
};

declare function mm:generateDate() as element (date){
    <date>2012-08-10</date>
};

declare function mm:generateScoreRec() as element (scoreRec){
     <scoreRec>1</scoreRec>
};

declare function mm:generateScoreInv() as element (scoreInv){
    <scoreInv>1</scoreInv>
};
