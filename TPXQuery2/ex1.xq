import module namespace mm="http://cyril/modules" at "modules.xq";

declare default element namespace "http://caronc/schema/foot";

let $clubs := //clubs, $j := //journée
return mm:toutes_les_journees($clubs, $j)