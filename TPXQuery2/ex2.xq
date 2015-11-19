import module namespace mm="http://cyril/modules" at "module2.xq", "modules.xq";

declare namespace foot="http://caronc/schema/foot";
declare option output:method "xhtml";
declare option output:indent "yes";
declare option output:encoding "UTF-8";
declare option output:include-content-type "yes";
declare option output:omit-xml-declaration "no";

let $clubs := //foot:clubs, $j := //foot:journée
return mm:generateHTML(mm:toutes_les_journees($clubs, $j))



