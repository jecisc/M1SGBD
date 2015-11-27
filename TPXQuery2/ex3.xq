import module namespace mm="http://cyril/modules" at "module2.xq", "modules.xq", "module3.xq";

declare namespace foot="http://caronc/schema/foot";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare option output:method "xml";

let $doc := fn:doc("foot_tp/journee3.html")
return mm:generateXML($doc/div, 3)
