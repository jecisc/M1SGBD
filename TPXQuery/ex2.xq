(:Donner une requête qui permet de calculer la surface totale de chaque maison. Quand deux éléments sont imbriqués, alors seule la surface de l'élément externe est comptée. Par exemple, pour <chambre surface-m2="28" fenetre="3"><alcove surface-m2="8"/></chambre>, on n'utilise que la surface de la chambre.:)


for $m in //maison
return 
  <maison>{
    $m/@id,
    <surface-total>{
      let $p := sum($m/descendant::*[count(ancestor::*/@surface-m2) = 0]/@surface-m2)
      return $p
    }</surface-total>    
  }</maison>