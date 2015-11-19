module namespace mm = "http://cyril/modules";
(: prefixe mm pour 'mes modules' :)

declare namespace foot="http://caronc/schema/foot";
declare default element namespace "http://www.w3.org/1999/xhtml";

declare function mm:generateHTML($clubs as element(foot:clubs)) as element(html){
  <html> 
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <link href="cours.css" rel="stylesheet" type="text/css" />
      <title>Championnat de football</title>
    </head>
    <body>
      <h1>Saison 2012-2013</h1>
      <p>Classement du championnat de France de football, ligue 1, après { $clubs/foot:club[1]/foot:scores/@nb_journees/string() } journées</p>
      <table>
        <thead>
          <td>Classmt</td>
          <td>Sigle</td>
          <td>Club</td>
          <td>Points</td>
          <td>Diff</td>
          <td>Buts marqués</td>
        </thead>
        <tbody>{
          for $club in $clubs/foot:club
          return mm:lineFor($club)
        }</tbody>
      </table>
    </body>
  </html>
};

declare function mm:lineFor($club as element(foot:club)) as element(tr){
  <tr>
    <td>{ $club/foot:scores/foot:classement/text() }</td>
    <td>{ $club/@id }</td>
    <td>{ $club/foot:nom/text() }</td>
    <td>{ $club/foot:scores/foot:nb_points/text() }</td>
    <td>{ mm:diff($club) }</td>
    <td>{ $club/foot:scores/foot:nb_buts_marques/text() }</td>
  </tr>
};

declare function mm:diff($club as element(foot:club)) as xs:double{
   $club/foot:scores/foot:nb_buts_marques -  $club/foot:scores/foot:nb_buts_encaisses
};
