module namespace mm = "http://cyril/modules";
(: prefixe mm pour 'mes modules' :)

declare default element namespace "http://caronc/schema/foot";

declare function mm:nouvelle_journee($clubs as element(clubs) ,$journee as element(journée)) as element(clubs) {
  <clubs xmlns="http://caronc/schema/foot"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xsi:schemaLocation="http://caronc/schema/foot 
  http://www.fil.univ-lille1.fr/~caronc/SGBD/foot/clubs_scores.xsd">
    {
      for $club in $clubs/club
      order by  mm:classement_num($club, $journee) ascending
      return mm:nouvelle_journee_club($club, $journee)
    }
  </clubs>
};

declare function mm:nouvelle_journee_club($club as element(club) ,$journee as element(journée)) as element(club) {
      <club>
        {
          $club/@id, $club/nom, $club/ville, mm:score($club, $journee)
        }
      </club>
};

declare function mm:score($club as element(club) ,$journee as element(journée)) as element(scores) {
      let $scores := $club/scores
      return 
        <scores nb_journees="{mm:nb_journees($scores, $journee)}">
          {
            mm:nb_but_marq($club, $journee), mm:nb_but_encaisses($club, $journee), mm:nb_points($club, $journee), mm:classement($club, $journee)
          }
        </scores>
};

declare function mm:nb_journees($scores as element(scores) ,$journee as element(journée)) as xs:integer {
     xs:integer($scores/@nb_journees) + xs:integer($journee/@num)
};

declare function mm:nb_but_marq($club as element(club) ,$journee as element(journée)) as element(nb_buts_marques) {
    <nb_buts_marques>{
      mm:nb_but_marq_num($club, $journee)
    }</nb_buts_marques>
};

declare function mm:nb_but_marq_num($club as element(club) ,$journee as element(journée)) as xs:double {
      let $marqueRec := sum($journee/rencontre[clubReceveur = $club/@id]/scoreRec),
          $marqueInv := sum($journee/rencontre[clubInvité = $club/@id]/scoreInv)
      return $club/scores/nb_buts_marques + $marqueRec + $marqueInv
};

declare function mm:nb_but_encaisses($club as element(club) ,$journee as element(journée)) as element(nb_buts_encaisses) {
    <nb_buts_encaisses>{
      mm:nb_but_encaisses_num($club, $journee)
    }</nb_buts_encaisses>
};


declare function mm:nb_but_encaisses_num($club as element(club) ,$journee as element(journée)) as xs:double {
      let $marqueRec := sum($journee/rencontre[clubReceveur = $club/@id]/scoreInv),
          $marqueInv := sum($journee/rencontre[clubInvité = $club/@id]/scoreRec)
      return $club/scores/nb_buts_marques + $marqueRec + $marqueInv
};

declare function mm:nb_points($club as element(club) ,$journee as element(journée)) as element(nb_points) {
    <nb_points>{
      mm:nb_points_num($club, $journee)
    }</nb_points>
};

declare function mm:nb_points_num($club as element(club) ,$journee as element(journée)) as xs:double {
       let $marq := mm:nb_but_marq_num($club, $journee),
           $recu := mm:nb_but_encaisses_num($club, $journee)
       return
         if($marq > $recu) then 
           3 + $club/scores/nb_points
         else if ($marq = $recu) then
           1 + $club/scores/nb_points
         else
           0 + $club/scores/nb_points
};

declare function mm:classement($club as element(club) ,$journee as element(journée)) as element(classement) {
    <classement>{
      mm:classement_num($club, $journee)
    }</classement>
};

declare function mm:classement_num($club as element(club) ,$journee as element(journée)) as xs:double {
      for $result at $pos in  mm:classement_tot($club, $journee)
      return
        if ($result = $club) then
          $pos
        else()
};

declare function mm:classement_tot($club as element(club) ,$journee as element(journée)) as element(club)* {
        for $club2 in $club/ancestor::clubs/club
        order by mm:nb_points_num($club2, $journee) descending
        return 
           $club2
};