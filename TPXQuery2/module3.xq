module namespace mm = "http://cyril/modules";
(: prefixe mm pour 'mes modules' :)

declare namespace foot="http://caronc/schema/foot";
declare default element namespace "http://www.w3.org/1999/xhtml";

declare function mm:generateXML($doc as element(div), $jour as xs:integer) as element(journée){
  <journée num="{$jour}">{
    for $tbody in ($doc/descendant::tbody)
    return mm:generateForTBody($tbody)
  }
  </journée>
};

declare function mm:generateForTBody($tbody as element(tbody)) as element(rencontre)*{
  for $tr in $tbody/tr
  return
    mm:generateRencontre($tr, $tbody/preceding::h4[1])
};

declare function mm:generateRencontre($tr as element(tr), $date as element(h4)) as element(rencontre){
  <rencontre>{
    mm:generateClubRec($tr/td[@class="domicile"]/a/@href), 
    mm:generateClubInv($tr/td[@class="exterieur"]/a/@href), 
    mm:generateDate($date/text()), 
    mm:generateScoreRec(substring($tr/td[@class="stats"]/a/text(),1,2)), 
    mm:generateScoreInv(substring($tr/td[@class="stats"]/a/text(),5,6))
  }
  </rencontre>
};

declare function mm:generateClubRec($uri as xs:string) as element (clubReceveur){
     <clubReceveur>{
       mm:clubForURI($uri)
     }</clubReceveur>
};

declare function mm:generateClubInv($uri as xs:string) as element (clubInvité){
    <clubInvité>{ mm:clubForURI($uri)}</clubInvité>  
};

declare function mm:generateDate($date as xs:string) as element (date){
    <date>{
      concat(tokenize($date, '\s+')[4], '-', mm:month(tokenize($date, '\s+')[3]) , '-', tokenize($date, '\s+')[2])
    }</date>
};

declare function mm:generateScoreRec($buts as xs:string) as element (scoreRec){
     <scoreRec>{$buts}</scoreRec>
};

declare function mm:generateScoreInv($buts as xs:string) as element (scoreInv){
    <scoreInv>{$buts}</scoreInv>
};

declare function mm:clubForURI($uri as xs:string) as xs:string{
 switch ($uri)
case "/club/evian-tg-fc" return "ETG"
case "/club/ogc-nice" return "OGCN"
case "/club/as-nancy-lorraine" return "ASNL"
case "/club/stade-de-reims" return "Rei"
case "/club/stade-rennais-fc" return "Ren"
case "/club/estac-troyes" return "ESTAC"
case "/club/valenciennes-fc" return "VA"
case "/club/montpellier-herault-sc" return "Mon"
case "/club/as-saint-etienne" return "ASSE"
case "/club/paris-saint-germain" return "PSG"
case "/club/olympique-lyonnais" return "OL"
case "/club/losc-lille" return "LOSC"
case "/club/toulouse-fc" return "Tou"
case "/club/fc-sochaux-montbeliard" return "Soc"
case "/club/sc-bastia" return "Bas"
case "/club/fc-lorient" return "Lor"
case "/club/ac-ajaccio" return "ACA"
case "/club/olympique-de-marseille" return "OM"
case "/club/stade-brestois-29" return "SB"
case "/club/girondins-de-bordeaux" return "Bdx"

default return "inconnu"
};

declare function mm:month($mois) as xs:string{
  switch ($mois)
case "janvier" return "1"
case "février" return "2"
case "mars" return "3"
case "avril" return "4"
case "mai" return "5"
case "juin" return "6"
case "juillet" return "7"
case "août" return "8"
case "septembre" return "9"
case "octobre" return "10"
case "novembre" return "11"
case "décembre" return "12"

default return "666"
};

