import module namespace mm="http://cyril/modules" at "module2.xq", "modules.xq", "module3.xq";

declare namespace foot="http://caronc/schema/foot";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare option output:method "xml";
declare option output:indent "yes";
declare option output:encoding "UTF-8";
declare option output:include-content-type "yes";
declare option output:omit-xml-declaration "no";

let $doc := fn:doc("foot_tp/journee3.html")
return mm:generateXML($doc/div, 3)
