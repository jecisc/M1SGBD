import module namespace mm="http://cyril/modules" at "modules.xq";

declare default element namespace "http://caronc/schema/foot";

let $clubs := //clubs, $j := //journée
return mm:nouvelle_journee($clubs, $j[1])
