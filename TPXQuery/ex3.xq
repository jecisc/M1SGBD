xquery version "3.0" encoding "utf-8";

(: Définir une fonction qui transforme 1 noeud bookmark passé en paramètre en 1 noeud élément div,tel que

    Le titre et l'url sont mis dans un premier paragraphe (élément p) qui contient un lien (élément a)ayant pour référence l'url et pour contenu textuel, le titre s'il existe et à défaut l'url.

    Si la description existe elle est mise dans un second paragraphe:)
    
declare function local:sortie_bookmark($bk as element(bookmark)) as element(div){
    <div>
     <p>
       {local:link_bookmark($bk)}
     </p> 
     { local:desc_bookmark($bk) }
    </div>
};

declare function local:desc_bookmark($bk as element(bookmark)) as element(p)?{
  let $descr := $bk/description/text()
       return
           if (not(empty($descr))) then
             <p>{$descr}</p>
             else()
};

declare function local:link_bookmark($bk as element(bookmark)) as element(a){
  let $url := $bk/@url, $title := $bk/title/text()
  return
  <a href="{$url}" >
    {
      if(empty($title)) then
        $url/string()
      else
        $title
    }
  </a>
};

(:for $b in //bookmark
return local:sortie_bookmark($b[1]):)

(:Définir une fonction qui transforme 1 noeud categorie passé en paramètre en 1 noeud div,tel que

    Le nom de la catégorie apparaît en titre h3
    La description est rangée dans un paragraphe
    Puis, on affiche récursivement les sous-catégories et les bookmarks (cf question précédente)
:)

declare function local:transform_cat($cat as element(categorie)) as element(div){
    <div>
      {local:cat_title($cat), local:cat_descr($cat), local:cat_sub($cat)}
    </div>
};

declare function local:cat_title($cat as element(categorie)) as element(h3){
  let $name := $cat/@nom/string()
      return
        <h3>{
          $name  
        }</h3>
};

declare function local:cat_descr($cat as element(categorie)) as element(p)?{
  let $desc := $cat/description/text()
      return
        if (not(empty($desc))) then
          <p> {$desc} </p>
        else()
};

declare function local:cat_sub($cat as element(categorie)) as element(ul){
    <ul>
      {
        for $subcat in $cat/categorie
      return
        <li>{local:transform_cat($subcat)}</li>,
      
      for $bk in $cat/bookmark
      return
        <li>{local:sortie_bookmark($bk)}</li>
      }
     </ul>     
};

(:for $c in //categorie
return local:transform_cat($c[1]):)


declare function local:all($bks as element(bookmarks)) as element(html){
  <html>
  <h1>Mes bookmarks</h1>{
  for $cat in $bks/categorie
  return
    local:transform_cat($cat)
  }
</html>
};

for $b in //bookmarks
return local:all($b[1])