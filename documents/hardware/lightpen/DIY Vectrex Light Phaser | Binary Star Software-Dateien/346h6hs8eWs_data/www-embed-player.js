(function(){var g,aa=aa||{},l=this;function p(a){return void 0!==a}
function q(a,b,c){a=a.split(".");c=c||l;a[0]in c||!c.execScript||c.execScript("var "+a[0]);for(var d;a.length&&(d=a.shift());)!a.length&&p(b)?c[d]=b:c[d]?c=c[d]:c=c[d]={}}
function r(a,b){for(var c=a.split("."),d=b||l,e;e=c.shift();)if(null!=d[e])d=d[e];else return null;return d}
function t(){}
function ba(a){a.getInstance=function(){return a.R?a.R:a.R=new a}}
function ca(a){var b=typeof a;if("object"==b)if(a){if(a instanceof Array)return"array";if(a instanceof Object)return b;var c=Object.prototype.toString.call(a);if("[object Window]"==c)return"object";if("[object Array]"==c||"number"==typeof a.length&&"undefined"!=typeof a.splice&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("splice"))return"array";if("[object Function]"==c||"undefined"!=typeof a.call&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("call"))return"function"}else return"null";
else if("function"==b&&"undefined"==typeof a.call)return"object";return b}
function u(a){return"array"==ca(a)}
function da(a){var b=ca(a);return"array"==b||"object"==b&&"number"==typeof a.length}
function v(a){return"string"==typeof a}
function ea(a){return"number"==typeof a}
function fa(a){return"function"==ca(a)}
function ga(a){var b=typeof a;return"object"==b&&null!=a||"function"==b}
function ha(a){return a[ia]||(a[ia]=++ja)}
var ia="closure_uid_"+(1E9*Math.random()>>>0),ja=0;function ka(a,b,c){return a.call.apply(a.bind,arguments)}
function la(a,b,c){if(!a)throw Error();if(2<arguments.length){var d=Array.prototype.slice.call(arguments,2);return function(){var c=Array.prototype.slice.call(arguments);Array.prototype.unshift.apply(c,d);return a.apply(b,c)}}return function(){return a.apply(b,arguments)}}
function w(a,b,c){w=Function.prototype.bind&&-1!=Function.prototype.bind.toString().indexOf("native code")?ka:la;return w.apply(null,arguments)}
function ma(a,b){var c=Array.prototype.slice.call(arguments,1);return function(){var b=c.slice();b.push.apply(b,arguments);return a.apply(this,b)}}
var x=Date.now||function(){return+new Date};
function y(a,b){function c(){}
c.prototype=b.prototype;a.B=b.prototype;a.prototype=new c;a.prototype.constructor=a;a.Me=function(a,c,f){for(var h=Array(arguments.length-2),k=2;k<arguments.length;k++)h[k-2]=arguments[k];return b.prototype[c].apply(a,h)}}
;function na(a){if(Error.captureStackTrace)Error.captureStackTrace(this,na);else{var b=Error().stack;b&&(this.stack=b)}a&&(this.message=String(a))}
y(na,Error);na.prototype.name="CustomError";var oa;var pa=String.prototype.trim?function(a){return a.trim()}:function(a){return a.replace(/^[\s\xa0]+|[\s\xa0]+$/g,"")};
function qa(a){return decodeURIComponent(a.replace(/\+/g," "))}
var ra=/&/g,sa=/</g,ta=/>/g,va=/"/g,wa=/'/g,xa=/\x00/g,ya=/[\x00&<>"']/;function za(a){var b={"&amp;":"&","&lt;":"<","&gt;":">","&quot;":'"'},c;c=l.document.createElement("div");return a.replace(Aa,function(a,e){var f=b[a];if(f)return f;if("#"==e.charAt(0)){var h=Number("0"+e.substr(1));isNaN(h)||(f=String.fromCharCode(h))}f||(c.innerHTML=a+" ",f=c.firstChild.nodeValue.slice(0,-1));return b[a]=f})}
function Ba(a){return a.replace(/&([^;]+);/g,function(a,c){switch(c){case "amp":return"&";case "lt":return"<";case "gt":return">";case "quot":return'"';default:if("#"==c.charAt(0)){var d=Number("0"+c.substr(1));if(!isNaN(d))return String.fromCharCode(d)}return a}})}
var Aa=/&([^;\s<&]+);?/g,Ca={"\x00":"\\0","\b":"\\b","\f":"\\f","\n":"\\n","\r":"\\r","\t":"\\t","\x0B":"\\x0B",'"':'\\"',"\\":"\\\\","<":"<"},Da={"'":"\\'"};
function Ea(a,b){for(var c=0,d=pa(String(a)).split("."),e=pa(String(b)).split("."),f=Math.max(d.length,e.length),h=0;0==c&&h<f;h++){var k=d[h]||"",m=e[h]||"",n=RegExp("(\\d*)(\\D*)","g"),Z=RegExp("(\\d*)(\\D*)","g");do{var ua=n.exec(k)||["","",""],Jc=Z.exec(m)||["","",""];if(0==ua[0].length&&0==Jc[0].length)break;c=Fa(0==ua[1].length?0:parseInt(ua[1],10),0==Jc[1].length?0:parseInt(Jc[1],10))||Fa(0==ua[2].length,0==Jc[2].length)||Fa(ua[2],Jc[2])}while(0==c)}return c}
function Fa(a,b){return a<b?-1:a>b?1:0}
function Ga(a){for(var b=0,c=0;c<a.length;++c)b=31*b+a.charCodeAt(c)>>>0;return b}
;var Ha=Array.prototype.indexOf?function(a,b,c){return Array.prototype.indexOf.call(a,b,c)}:function(a,b,c){c=null==c?0:0>c?Math.max(0,a.length+c):c;
if(v(a))return v(b)&&1==b.length?a.indexOf(b,c):-1;for(;c<a.length;c++)if(c in a&&a[c]===b)return c;return-1},z=Array.prototype.forEach?function(a,b,c){Array.prototype.forEach.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=v(a)?a.split(""):a,f=0;f<d;f++)f in e&&b.call(c,e[f],f,a)},Ia=Array.prototype.filter?function(a,b,c){return Array.prototype.filter.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=[],f=0,h=v(a)?a.split(""):a,k=0;k<d;k++)if(k in h){var m=h[k];
b.call(c,m,k,a)&&(e[f++]=m)}return e},Ja=Array.prototype.map?function(a,b,c){return Array.prototype.map.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=Array(d),f=v(a)?a.split(""):a,h=0;h<d;h++)h in f&&(e[h]=b.call(c,f[h],h,a));
return e},Ka=Array.prototype.some?function(a,b,c){return Array.prototype.some.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=v(a)?a.split(""):a,f=0;f<d;f++)if(f in e&&b.call(c,e[f],f,a))return!0;
return!1},La=Array.prototype.every?function(a,b,c){return Array.prototype.every.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=v(a)?a.split(""):a,f=0;f<d;f++)if(f in e&&!b.call(c,e[f],f,a))return!1;
return!0};
function Ma(a,b,c){b=Na(a,b,c);return 0>b?null:v(a)?a.charAt(b):a[b]}
function Na(a,b,c){for(var d=a.length,e=v(a)?a.split(""):a,f=0;f<d;f++)if(f in e&&b.call(c,e[f],f,a))return f;return-1}
function A(a,b){return 0<=Ha(a,b)}
function Oa(a,b){A(a,b)||a.push(b)}
function Pa(a,b){var c=Ha(a,b),d;(d=0<=c)&&Array.prototype.splice.call(a,c,1);return d}
function Qa(a,b){var c=Na(a,b,void 0);0<=c&&Array.prototype.splice.call(a,c,1)}
function Ra(a){return Array.prototype.concat.apply(Array.prototype,arguments)}
function Sa(a){var b=a.length;if(0<b){for(var c=Array(b),d=0;d<b;d++)c[d]=a[d];return c}return[]}
function Ta(a,b){for(var c=1;c<arguments.length;c++){var d=arguments[c];if(da(d)){var e=a.length||0,f=d.length||0;a.length=e+f;for(var h=0;h<f;h++)a[e+h]=d[h]}else a.push(d)}}
function Ua(a,b,c,d){return Array.prototype.splice.apply(a,Va(arguments,1))}
function Va(a,b,c){return 2>=arguments.length?Array.prototype.slice.call(a,b):Array.prototype.slice.call(a,b,c)}
function Wa(a,b){return a>b?1:a<b?-1:0}
;function Xa(a,b,c){for(var d in a)b.call(c,a[d],d,a)}
function Ya(a,b,c){var d={},e;for(e in a)b.call(c,a[e],e,a)&&(d[e]=a[e]);return d}
function Za(a){var b=0,c;for(c in a)b++;return b}
function $a(a,b){return ab(a,b)}
function bb(a){var b=[],c=0,d;for(d in a)b[c++]=a[d];return b}
function cb(a){var b=[],c=0,d;for(d in a)b[c++]=d;return b}
function ab(a,b){for(var c in a)if(a[c]==b)return!0;return!1}
function db(a){var b=eb,c;for(c in b)if(a.call(void 0,b[c],c,b))return c}
function fb(a){for(var b in a)return!1;return!0}
function gb(a,b){if(null!==a&&b in a)throw Error('The object already contains the key "'+b+'"');a[b]=!0}
function hb(a){var b={},c;for(c in a)b[c]=a[c];return b}
function ib(a){var b=ca(a);if("object"==b||"array"==b){if(fa(a.clone))return a.clone();var b="array"==b?[]:{},c;for(c in a)b[c]=ib(a[c]);return b}return a}
var jb="constructor hasOwnProperty isPrototypeOf propertyIsEnumerable toLocaleString toString valueOf".split(" ");function kb(a,b){for(var c,d,e=1;e<arguments.length;e++){d=arguments[e];for(c in d)a[c]=d[c];for(var f=0;f<jb.length;f++)c=jb[f],Object.prototype.hasOwnProperty.call(d,c)&&(a[c]=d[c])}}
;var lb;a:{var mb=l.navigator;if(mb){var nb=mb.userAgent;if(nb){lb=nb;break a}}lb=""}function B(a){return-1!=lb.indexOf(a)}
;function ob(){return(B("Chrome")||B("CriOS"))&&!B("Edge")}
;function pb(){this.b=""}
pb.prototype.Kb=!0;pb.prototype.Fb=function(){return this.b};
pb.prototype.toString=function(){return"Const{"+this.b+"}"};
function qb(a){var b=new pb;b.b=a;return b}
;function rb(){this.b="";this.f=sb}
rb.prototype.Kb=!0;rb.prototype.Fb=function(){return this.b};
function tb(a){if(a instanceof rb&&a.constructor===rb&&a.f===sb)return a.b;ca(a);return"type_error:SafeUrl"}
var ub=/^(?:(?:https?|mailto|ftp):|[^&:/?#]*(?:[/?#]|$))/i;function vb(a){if(a instanceof rb)return a;a=a.Kb?a.Fb():String(a);ub.test(a)||(a="about:invalid#zClosurez");return wb(a)}
var sb={};function wb(a){var b=new rb;b.b=a;return b}
wb("about:blank");function xb(){this.b="";this.f=yb;this.g=null}
xb.prototype.Kb=!0;xb.prototype.Fb=function(){return this.b};
function zb(a){if(a instanceof xb&&a.constructor===xb&&a.f===yb)return a.b;ca(a);return"type_error:SafeHtml"}
var yb={};function Ab(a,b){var c=new xb;c.b=a;c.g=b;return c}
Ab("<!DOCTYPE html>",0);Ab("",0);Ab("<br>",0);function Bb(a,b){var c;c=b instanceof rb?b:vb(b);a.href=tb(c)}
;function Cb(a,b,c){a&&(a.dataset?a.dataset[Db(b)]=c:a.setAttribute("data-"+b,c))}
function C(a,b){return a?a.dataset?a.dataset[Db(b)]:a.getAttribute("data-"+b):null}
function Eb(a,b){a&&(a.dataset?delete a.dataset[Db(b)]:a.removeAttribute("data-"+b))}
var Fb={};function Db(a){return Fb[a]||(Fb[a]=String(a).replace(/\-([a-z])/g,function(a,c){return c.toUpperCase()}))}
;function Gb(a){l.setTimeout(function(){throw a;},0)}
var Hb;
function Ib(){var a=l.MessageChannel;"undefined"===typeof a&&"undefined"!==typeof window&&window.postMessage&&window.addEventListener&&!B("Presto")&&(a=function(){var a=document.createElement("IFRAME");a.style.display="none";a.src="";document.documentElement.appendChild(a);var b=a.contentWindow,a=b.document;a.open();a.write("");a.close();var c="callImmediate"+Math.random(),d="file:"==b.location.protocol?"*":b.location.protocol+"//"+b.location.host,a=w(function(a){if(("*"==d||a.origin==d)&&a.data==
c)this.port1.onmessage()},this);
b.addEventListener("message",a,!1);this.port1={};this.port2={postMessage:function(){b.postMessage(c,d)}}});
if("undefined"!==typeof a&&!B("Trident")&&!B("MSIE")){var b=new a,c={},d=c;b.port1.onmessage=function(){if(p(c.next)){c=c.next;var a=c.ac;c.ac=null;a()}};
return function(a){d.next={ac:a};d=d.next;b.port2.postMessage(0)}}return"undefined"!==typeof document&&"onreadystatechange"in document.createElement("SCRIPT")?function(a){var b=document.createElement("SCRIPT");
b.onreadystatechange=function(){b.onreadystatechange=null;b.parentNode.removeChild(b);b=null;a();a=null};
document.documentElement.appendChild(b)}:function(a){l.setTimeout(a,0)}}
;function Jb(a,b,c){this.i=c;this.g=a;this.j=b;this.f=0;this.b=null}
Jb.prototype.get=function(){var a;0<this.f?(this.f--,a=this.b,this.b=a.next,a.next=null):a=this.g();return a};
function Kb(a,b){a.j(b);a.f<a.i&&(a.f++,b.next=a.b,a.b=b)}
;function Lb(){this.f=this.b=null}
var Nb=new Jb(function(){return new Mb},function(a){a.reset()},100);
Lb.prototype.remove=function(){var a=null;this.b&&(a=this.b,this.b=this.b.next,this.b||(this.f=null),a.next=null);return a};
function Mb(){this.next=this.scope=this.b=null}
Mb.prototype.set=function(a,b){this.b=a;this.scope=b;this.next=null};
Mb.prototype.reset=function(){this.next=this.scope=this.b=null};function Ob(a,b){Pb||Qb();Rb||(Pb(),Rb=!0);var c=Sb,d=Nb.get();d.set(a,b);c.f?c.f.next=d:c.b=d;c.f=d}
var Pb;function Qb(){if(l.Promise&&l.Promise.resolve){var a=l.Promise.resolve(void 0);Pb=function(){a.then(Tb)}}else Pb=function(){var a=Tb;
!fa(l.setImmediate)||l.Window&&l.Window.prototype&&!B("Edge")&&l.Window.prototype.setImmediate==l.setImmediate?(Hb||(Hb=Ib()),Hb(a)):l.setImmediate(a)}}
var Rb=!1,Sb=new Lb;function Tb(){for(var a;a=Sb.remove();){try{a.b.call(a.scope)}catch(b){Gb(b)}Kb(Nb,a)}Rb=!1}
;function D(){this.Fa=this.Fa;this.N=this.N}
D.prototype.Fa=!1;D.prototype.isDisposed=function(){return this.Fa};
D.prototype.dispose=function(){this.Fa||(this.Fa=!0,this.A())};
function Ub(a,b){a.Fa?p(void 0)?b.call(void 0):b():(a.N||(a.N=[]),a.N.push(p(void 0)?w(b,void 0):b))}
D.prototype.A=function(){if(this.N)for(;this.N.length;)this.N.shift()()};
function E(a){a&&"function"==typeof a.dispose&&a.dispose()}
function Vb(a){for(var b=0,c=arguments.length;b<c;++b){var d=arguments[b];da(d)?Vb.apply(null,d):E(d)}}
;function F(a){D.call(this);this.i=1;this.f=[];this.g=0;this.b=[];this.aa={};this.j=!!a}
y(F,D);g=F.prototype;g.subscribe=function(a,b,c){var d=this.aa[a];d||(d=this.aa[a]=[]);var e=this.i;this.b[e]=a;this.b[e+1]=b;this.b[e+2]=c;this.i=e+3;d.push(e);return e};
g.unsubscribe=function(a,b,c){if(a=this.aa[a]){var d=this.b;if(a=Ma(a,function(a){return d[a+1]==b&&d[a+2]==c}))return this.ha(a)}return!1};
g.ha=function(a){var b=this.b[a];if(b){var c=this.aa[b];0!=this.g?(this.f.push(a),this.b[a+1]=t):(c&&Pa(c,a),delete this.b[a],delete this.b[a+1],delete this.b[a+2])}return!!b};
g.w=function(a,b){var c=this.aa[a];if(c){for(var d=Array(arguments.length-1),e=1,f=arguments.length;e<f;e++)d[e-1]=arguments[e];if(this.j)for(e=0;e<c.length;e++){var h=c[e];Wb(this.b[h+1],this.b[h+2],d)}else{this.g++;try{for(e=0,f=c.length;e<f;e++)h=c[e],this.b[h+1].apply(this.b[h+2],d)}finally{if(this.g--,0<this.f.length&&0==this.g)for(;c=this.f.pop();)this.ha(c)}}return 0!=e}return!1};
function Wb(a,b,c){Ob(function(){a.apply(b,c)})}
g.clear=function(a){if(a){var b=this.aa[a];b&&(z(b,this.ha,this),delete this.aa[a])}else this.b.length=0,this.aa={}};
g.O=function(a){if(a){var b=this.aa[a];return b?b.length:0}a=0;for(b in this.aa)a+=this.O(b);return a};
g.A=function(){F.B.A.call(this);this.clear();this.f.length=0};var Xb=window.yt&&window.yt.config_||window.ytcfg&&window.ytcfg.data_||{};q("yt.config_",Xb,void 0);q("yt.tokens_",window.yt&&window.yt.tokens_||{},void 0);var Yb=window.yt&&window.yt.msgs_||r("window.ytcfg.msgs")||{};q("yt.msgs_",Yb,void 0);function Zb(a){$b(Xb,arguments)}
function G(a,b){return a in Xb?Xb[a]:b}
function H(a,b){fa(a)&&(a=ac(a));return window.setTimeout(a,b)}
function I(a){window.clearTimeout(a)}
function ac(a){return a&&window.yterr?function(){try{return a.apply(this,arguments)}catch(b){throw bc(b),b;}}:a}
function bc(a,b){var c=r("yt.logging.errors.log");c?c(a,b,void 0,void 0,void 0):(c=G("ERRORS",[]),c.push([a,b,void 0,void 0,void 0]),Zb("ERRORS",c))}
function cc(){var a={},b="FLASH_UPGRADE"in Yb?Yb.FLASH_UPGRADE:'You need to upgrade your Adobe Flash Player to watchthis video. <br> <a href="https://get.adobe.com/flashplayer/">Download it from Adobe.</a>';if(b)for(var c in a)b=b.replace(new RegExp("\\$"+c,"gi"),function(){return a[c]});
return b}
function $b(a,b){if(1<b.length){var c=b[0];a[c]=b[1]}else{var d=b[0];for(c in d)a[c]=d[c]}}
var dc=window.performance&&window.performance.timing&&window.performance.now?function(){return window.performance.timing.navigationStart+window.performance.now()}:function(){return(new Date).getTime()},ec="Microsoft Internet Explorer"==navigator.appName;var fc=r("yt.pubsub.instance_")||new F;F.prototype.subscribe=F.prototype.subscribe;F.prototype.unsubscribeByKey=F.prototype.ha;F.prototype.publish=F.prototype.w;F.prototype.clear=F.prototype.clear;q("yt.pubsub.instance_",fc,void 0);var gc=r("yt.pubsub.subscribedKeys_")||{};q("yt.pubsub.subscribedKeys_",gc,void 0);var hc=r("yt.pubsub.topicToKeys_")||{};q("yt.pubsub.topicToKeys_",hc,void 0);var ic=r("yt.pubsub.isSynchronous_")||{};q("yt.pubsub.isSynchronous_",ic,void 0);
var jc=r("yt.pubsub.skipSubId_")||null;q("yt.pubsub.skipSubId_",jc,void 0);function kc(a,b,c){var d=lc();if(d){var e=d.subscribe(a,function(){if(!jc||jc!=e){var d=arguments,h;h=function(){gc[e]&&b.apply(c||window,d)};
try{ic[a]?h():H(h,0)}catch(k){bc(k)}}},c);
gc[e]=!0;hc[a]||(hc[a]=[]);hc[a].push(e);return e}return 0}
function mc(a){var b=lc();b&&("number"==typeof a?a=[a]:"string"==typeof a&&(a=[parseInt(a,10)]),z(a,function(a){b.unsubscribeByKey(a);delete gc[a]}))}
function J(a,b){var c=lc();return c?c.publish.apply(c,arguments):!1}
function nc(a,b){ic[a]=!0;var c=lc();c&&c.publish.apply(c,arguments);ic[a]=!1}
function oc(a){hc[a]&&(a=hc[a],z(a,function(a){gc[a]&&delete gc[a]}),a.length=0)}
function pc(a){var b=lc();if(b)if(b.clear(a),a)oc(a);else for(var c in hc)oc(c)}
function lc(){return r("yt.pubsub.instance_")}
;function qc(a,b){if(window.spf){var c="";if(a){var d=a.indexOf("jsbin/"),e=a.lastIndexOf(".js"),f=d+6;-1<d&&-1<e&&e>f&&(c=a.substring(f,e),c=c.replace(rc,""),c=c.replace(sc,""),c=c.replace("debug-",""),c=c.replace("tracing-",""))}spf.script.load(a,c,b)}else tc(a,b)}
function tc(a,b){var c=uc(a),d=document.getElementById(c),e=d&&C(d,"loaded"),f=d&&!e;if(e){b&&b();return}if(b){var e=kc(c,b),h=""+ha(b);vc[h]=e}if(f)return;d=wc(a,c,function(){C(d,"loaded")||(Cb(d,"loaded","true"),J(c),H(ma(pc,c),0))})}
function wc(a,b,c){var d=document.createElement("script");d.id=b;d.onload=function(){c&&setTimeout(c,0)};
d.onreadystatechange=function(){switch(d.readyState){case "loaded":case "complete":d.onload()}};
d.src=a;a=document.getElementsByTagName("head")[0]||document.body;a.insertBefore(d,a.firstChild);return d}
function xc(a,b){if(a&&b){var c=""+ha(b);(c=vc[c])&&mc(c)}}
function uc(a){var b=document.createElement("a");Bb(b,a);a=b.href.replace(/^[a-zA-Z]+:\/\//,"//");return"js-"+Ga(a)}
var rc=/\.vflset|-vfl[a-zA-Z0-9_+=-]+/,sc=/-[a-zA-Z]{2,3}_[a-zA-Z]{2,3}(?=(\/|$))/,vc={};var yc=null;function zc(){var a=G("BG_I",null),b=G("BG_IU",null),c=G("BG_P",void 0);b?qc(b,function(){yc=new botguard.bg(c)}):a&&(eval(a),yc=new botguard.bg(c))}
function Ac(){return null!=yc}
function Bc(){return yc?yc.invoke():null}
;function Cc(a,b){return Ab(b,null)}
;var Dc="StopIteration"in l?l.StopIteration:{message:"StopIteration",stack:""};function Ec(){}
Ec.prototype.next=function(){throw Dc;};
Ec.prototype.ma=function(){return this};
function Fc(a){if(a instanceof Ec)return a;if("function"==typeof a.ma)return a.ma(!1);if(da(a)){var b=0,c=new Ec;c.next=function(){for(;;){if(b>=a.length)throw Dc;if(b in a)return a[b++];b++}};
return c}throw Error("Not implemented");}
function Gc(a,b,c){if(da(a))try{z(a,b,c)}catch(d){if(d!==Dc)throw d;}else{a=Fc(a);try{for(;;)b.call(c,a.next(),void 0,a)}catch(d){if(d!==Dc)throw d;}}}
function Hc(a){if(da(a))return Sa(a);a=Fc(a);var b=[];Gc(a,function(a){b.push(a)});
return b}
;function Ic(a,b){this.f={};this.b=[];this.va=this.g=0;var c=arguments.length;if(1<c){if(c%2)throw Error("Uneven number of arguments");for(var d=0;d<c;d+=2)this.set(arguments[d],arguments[d+1])}else if(a){a instanceof Ic?(c=a.ja(),d=a.P()):(c=cb(a),d=bb(a));for(var e=0;e<c.length;e++)this.set(c[e],d[e])}}
g=Ic.prototype;g.O=function(){return this.g};
g.P=function(){Kc(this);for(var a=[],b=0;b<this.b.length;b++)a.push(this.f[this.b[b]]);return a};
g.ja=function(){Kc(this);return this.b.concat()};
g.Ra=function(a){for(var b=0;b<this.b.length;b++){var c=this.b[b];if(Lc(this.f,c)&&this.f[c]==a)return!0}return!1};
g.equals=function(a,b){if(this===a)return!0;if(this.g!=a.O())return!1;var c=b||Mc;Kc(this);for(var d,e=0;d=this.b[e];e++)if(!c(this.get(d),a.get(d)))return!1;return!0};
function Mc(a,b){return a===b}
g.isEmpty=function(){return 0==this.g};
g.clear=function(){this.f={};this.va=this.g=this.b.length=0};
g.remove=function(a){return Lc(this.f,a)?(delete this.f[a],this.g--,this.va++,this.b.length>2*this.g&&Kc(this),!0):!1};
function Kc(a){if(a.g!=a.b.length){for(var b=0,c=0;b<a.b.length;){var d=a.b[b];Lc(a.f,d)&&(a.b[c++]=d);b++}a.b.length=c}if(a.g!=a.b.length){for(var e={},c=b=0;b<a.b.length;)d=a.b[b],Lc(e,d)||(a.b[c++]=d,e[d]=1),b++;a.b.length=c}}
g.get=function(a,b){return Lc(this.f,a)?this.f[a]:b};
g.set=function(a,b){Lc(this.f,a)||(this.g++,this.b.push(a),this.va++);this.f[a]=b};
g.forEach=function(a,b){for(var c=this.ja(),d=0;d<c.length;d++){var e=c[d],f=this.get(e);a.call(b,f,e,this)}};
g.clone=function(){return new Ic(this)};
g.ma=function(a){Kc(this);var b=0,c=this.va,d=this,e=new Ec;e.next=function(){if(c!=d.va)throw Error("The map has changed since the iterator was created");if(b>=d.b.length)throw Dc;var e=d.b[b++];return a?e:d.f[e]};
return e};
function Lc(a,b){return Object.prototype.hasOwnProperty.call(a,b)}
;function Nc(a){return a.O&&"function"==typeof a.O?a.O():da(a)||v(a)?a.length:Za(a)}
function Oc(a){if(a.P&&"function"==typeof a.P)return a.P();if(v(a))return a.split("");if(da(a)){for(var b=[],c=a.length,d=0;d<c;d++)b.push(a[d]);return b}return bb(a)}
function Pc(a){if(a.ja&&"function"==typeof a.ja)return a.ja();if(!a.P||"function"!=typeof a.P){if(da(a)||v(a)){var b=[];a=a.length;for(var c=0;c<a;c++)b.push(c);return b}return cb(a)}}
function Qc(a,b,c){if(a.forEach&&"function"==typeof a.forEach)a.forEach(b,c);else if(da(a)||v(a))z(a,b,c);else for(var d=Pc(a),e=Oc(a),f=e.length,h=0;h<f;h++)b.call(c,e[h],d&&d[h],a)}
function Rc(a,b){if("function"==typeof a.every)return a.every(b,void 0);if(da(a)||v(a))return La(a,b,void 0);for(var c=Pc(a),d=Oc(a),e=d.length,f=0;f<e;f++)if(!b.call(void 0,d[f],c&&c[f],a))return!1;return!0}
;function Sc(a){this.b=new Ic;a&&Tc(this,a)}
function Uc(a){var b=typeof a;return"object"==b&&a||"function"==b?"o"+ha(a):b.substr(0,1)+a}
g=Sc.prototype;g.O=function(){return this.b.O()};
function Tc(a,b){for(var c=Oc(b),d=c.length,e=0;e<d;e++){var f=c[e];a.b.set(Uc(f),f)}}
g.remove=function(a){return this.b.remove(Uc(a))};
g.clear=function(){this.b.clear()};
g.isEmpty=function(){return this.b.isEmpty()};
g.contains=function(a){a=Uc(a);return Lc(this.b.f,a)};
g.P=function(){return this.b.P()};
g.clone=function(){return new Sc(this)};
g.equals=function(a){return this.O()==Nc(a)&&Vc(this,a)};
function Vc(a,b){var c=Nc(b);if(a.O()>c)return!1;!(b instanceof Sc)&&5<c&&(b=new Sc(b));return Rc(a,function(a){var c=b;return c.contains&&"function"==typeof c.contains?c.contains(a):c.Ra&&"function"==typeof c.Ra?c.Ra(a):da(c)||v(c)?A(c,a):ab(c,a)})}
g.ma=function(){return this.b.ma(!1)};function Wc(){return B("iPhone")&&!B("iPod")&&!B("iPad")}
;var Xc=B("Opera"),K=B("Trident")||B("MSIE"),Yc=B("Edge"),Zc=B("Gecko")&&!(-1!=lb.toLowerCase().indexOf("webkit")&&!B("Edge"))&&!(B("Trident")||B("MSIE"))&&!B("Edge"),$c=-1!=lb.toLowerCase().indexOf("webkit")&&!B("Edge"),ad=B("Macintosh"),bd=B("Windows");function cd(){var a=l.document;return a?a.documentMode:void 0}
var dd;a:{var ed="",fd=function(){var a=lb;if(Zc)return/rv\:([^\);]+)(\)|;)/.exec(a);if(Yc)return/Edge\/([\d\.]+)/.exec(a);if(K)return/\b(?:MSIE|rv)[: ]([^\);]+)(\)|;)/.exec(a);if($c)return/WebKit\/(\S+)/.exec(a);if(Xc)return/(?:Version)[ \/]?(\S+)/.exec(a)}();
fd&&(ed=fd?fd[1]:"");if(K){var gd=cd();if(null!=gd&&gd>parseFloat(ed)){dd=String(gd);break a}}dd=ed}var hd=dd,id={};function jd(a){return id[a]||(id[a]=0<=Ea(hd,a))}
function kd(a){return Number(ld)>=a}
var md=l.document,ld=md&&K?cd()||("CSS1Compat"==md.compatMode?parseInt(hd,10):5):void 0;function nd(a){a=String(a);if(/^\s*$/.test(a)?0:/^[\],:{}\s\u2028\u2029]*$/.test(a.replace(/\\["\\\/bfnrtu]/g,"@").replace(/(?:"[^"\\\n\r\u2028\u2029\x00-\x08\x0a-\x1f]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)[\s\u2028\u2029]*(?=:|,|]|}|$)/g,"]").replace(/(?:^|:|,)(?:[\s\u2028\u2029]*\[)+/g,"")))try{return eval("("+a+")")}catch(b){}throw Error("Invalid JSON string: "+a);}
function od(a){return eval("("+a+")")}
function L(a){return pd(new qd(void 0),a)}
function qd(a){this.b=a}
function pd(a,b){var c=[];rd(a,b,c);return c.join("")}
function rd(a,b,c){if(null==b)c.push("null");else{if("object"==typeof b){if(u(b)){var d=b;b=d.length;c.push("[");for(var e="",f=0;f<b;f++)c.push(e),e=d[f],rd(a,a.b?a.b.call(d,String(f),e):e,c),e=",";c.push("]");return}if(b instanceof String||b instanceof Number||b instanceof Boolean)b=b.valueOf();else{c.push("{");f="";for(d in b)Object.prototype.hasOwnProperty.call(b,d)&&(e=b[d],"function"!=typeof e&&(c.push(f),sd(d,c),c.push(":"),rd(a,a.b?a.b.call(b,d,e):e,c),f=","));c.push("}");return}}switch(typeof b){case "string":sd(b,
c);break;case "number":c.push(isFinite(b)&&!isNaN(b)?String(b):"null");break;case "boolean":c.push(String(b));break;case "function":c.push("null");break;default:throw Error("Unknown type: "+typeof b);}}}
var td={'"':'\\"',"\\":"\\\\","/":"\\/","\b":"\\b","\f":"\\f","\n":"\\n","\r":"\\r","\t":"\\t","\x0B":"\\u000b"},ud=/\uffff/.test("\uffff")?/[\\\"\x00-\x1f\x7f-\uffff]/g:/[\\\"\x00-\x1f\x7f-\xff]/g;function sd(a,b){b.push('"',a.replace(ud,function(a){var b=td[a];b||(b="\\u"+(a.charCodeAt(0)|65536).toString(16).substr(1),td[a]=b);return b}),'"')}
;var vd=/^(?:([^:/?#.]+):)?(?:\/\/(?:([^/?#]*)@)?([^/#?]*?)(?::([0-9]+))?(?=[/#?]|$))?([^?#]+)?(?:\?([^#]*))?(?:#(.*))?$/;function wd(a){return(a=a.match(vd)[3]||null)?decodeURI(a):a}
function xd(a,b){if(a)for(var c=a.split("&"),d=0;d<c.length;d++){var e=c[d].indexOf("="),f,h=null;0<=e?(f=c[d].substring(0,e),h=c[d].substring(e+1)):f=c[d];b(f,h?qa(h):"")}}
function yd(a){if(a[1]){var b=a[0],c=b.indexOf("#");0<=c&&(a.push(b.substr(c)),a[0]=b=b.substr(0,c));c=b.indexOf("?");0>c?a[1]="?":c==b.length-1&&(a[1]=void 0)}return a.join("")}
function zd(a,b,c){if(u(b))for(var d=0;d<b.length;d++)zd(a,String(b[d]),c);else null!=b&&c.push("&",a,""===b?"":"=",encodeURIComponent(String(b)))}
function Ad(a,b,c){for(c=c||0;c<b.length;c+=2)zd(b[c],b[c+1],a);return a}
function Bd(a,b){for(var c in b)zd(c,b[c],a);return a}
function Cd(a){a=Bd([],a);a[0]="";return a.join("")}
function Dd(a,b){return yd(2==arguments.length?Ad([a],arguments[1],0):Ad([a],arguments,1))}
function Ed(a,b){return yd(Bd([a],b))}
;function Fd(a){"?"==a.charAt(0)&&(a=a.substr(1));a=a.split("&");for(var b={},c=0,d=a.length;c<d;c++){var e=a[c].split("=");if(1==e.length&&e[0]||2==e.length){var f=qa(e[0]||""),e=qa(e[1]||"");f in b?u(b[f])?Ta(b[f],e):b[f]=[b[f],e]:b[f]=e}}return b}
function Gd(a,b){var c=a.split("#",2);a=c[0];var c=1<c.length?"#"+c[1]:"",d=a.split("?",2);a=d[0];var d=Fd(d[1]||""),e;for(e in b)d[e]=b[e];return Ed(a,d)+c}
function Hd(a){a=wd(a);a=null===a?null:a.split(".").reverse();return(null===a?!1:"com"==a[0]&&a[1].match(/^youtube(?:-nocookie)?$/)?!0:!1)||(null===a?!1:"google"==a[1]?!0:"google"==a[2]?"au"==a[0]&&"com"==a[1]?!0:"uk"==a[0]&&"co"==a[1]?!0:!1:!1)}
;var Id=null;"undefined"!=typeof XMLHttpRequest?Id=function(){return new XMLHttpRequest}:"undefined"!=typeof ActiveXObject&&(Id=function(){return new ActiveXObject("Microsoft.XMLHTTP")});
function Jd(a){switch(a&&"status"in a?a.status:-1){case 200:case 201:case 202:case 203:case 204:case 205:case 206:case 304:return!0;default:return!1}}
;function Kd(a,b,c,d,e,f,h){function k(){4==(m&&"readyState"in m?m.readyState:0)&&b&&ac(b)(m)}
var m=Id&&Id();if(!("open"in m))return null;"onloadend"in m?m.addEventListener("loadend",k,!1):m.onreadystatechange=k;c=(c||"GET").toUpperCase();d=d||"";m.open(c,a,!0);f&&(m.responseType=f);h&&(m.withCredentials=!0);f="POST"==c;if(e=Ld(a,e))for(var n in e)m.setRequestHeader(n,e[n]),"content-type"==n.toLowerCase()&&(f=!1);f&&m.setRequestHeader("Content-Type","application/x-www-form-urlencoded");m.send(d);return m}
function Ld(a,b){b=b||{};var c;c||(c=window.location.href);var d=a.match(vd)[1]||null,e=wd(a);d&&e?(d=c,c=a.match(vd),d=d.match(vd),c=c[3]==d[3]&&c[1]==d[1]&&c[4]==d[4]):c=e?wd(c)==e&&(Number(c.match(vd)[4]||null)||null)==(Number(a.match(vd)[4]||null)||null):!0;for(var f in Md){if((e=d=G(Md[f]))&&!(e=c)){var e=f,h=G("CORS_HEADER_WHITELIST")||{},k=wd(a);e=k?(h=h[k])?A(h,e):!1:!0}e&&(b[f]=d)}return b}
function Nd(a,b){var c=G("XSRF_FIELD_NAME",void 0),d;b.headers&&(d=b.headers["Content-Type"]);return!b.Oe&&(!wd(a)||b.withCredentials||wd(a)==document.location.hostname)&&"POST"==b.method&&(!d||"application/x-www-form-urlencoded"==d)&&!(b.S&&b.S[c])}
function Od(a,b){var c=b.format||"JSON";b.Pe&&(a=document.location.protocol+"//"+document.location.hostname+(document.location.port?":"+document.location.port:"")+a);var d=G("XSRF_FIELD_NAME",void 0),e=G("XSRF_TOKEN",void 0),f=b.Rb;f&&(f[d]&&delete f[d],a=Gd(a,f||{}));var h=b.postBody||"",f=b.S;Nd(a,b)&&(f||(f={}),f[d]=e);f&&v(h)&&(d=Fd(h),kb(d,f),h=b.Zd&&"JSON"==b.Zd?JSON.stringify(d):Cd(d));var k=!1,m,n=Kd(a,function(a){if(!k){k=!0;m&&I(m);var d=Jd(a),e=null;if(d||400<=a.status&&500>a.status)e=
Pd(c,a,b.Ne);if(d)a:{switch(c){case "XML":d=0==parseInt(e&&e.return_code,10);break a;case "RAW":d=!0;break a}d=!!e}var e=e||{},f=b.context||l;d?b.$&&b.$.call(f,a,e):b.onError&&b.onError.call(f,a,e);b.Nb&&b.Nb.call(f,a,e)}},b.method,h,b.headers,b.responseType,b.withCredentials);
b.Da&&0<b.timeout&&(m=H(function(){k||(k=!0,n.abort(),I(m),b.Da.call(b.context||l,n))},b.timeout));
return n}
function Pd(a,b,c){var d=null;switch(a){case "JSON":a=b.responseText;b=b.getResponseHeader("Content-Type")||"";a&&0<=b.indexOf("json")&&(d=od(a));break;case "XML":if(b=(b=b.responseXML)?Qd(b):null)d={},z(b.getElementsByTagName("*"),function(a){d[a.tagName]=Rd(a)})}c&&Sd(d);
return d}
function Sd(a){if(ga(a))for(var b in a){var c;(c="html_content"==b)||(c=b.length-5,c=0<=c&&b.indexOf("_html",c)==c);c?a[b]=Cc(qb("HTML that is escaped and sanitized server-side and passed through yt.net.ajax"),a[b]):Sd(a[b])}}
function Qd(a){return a?(a=("responseXML"in a?a.responseXML:a).getElementsByTagName("root"))&&0<a.length?a[0]:null:null}
function Rd(a){var b="";z(a.childNodes,function(a){b+=a.nodeValue});
return b}
var Md={"X-YouTube-Client-Name":"INNERTUBE_CONTEXT_CLIENT_NAME","X-YouTube-Client-Version":"INNERTUBE_CONTEXT_CLIENT_VERSION","X-Youtube-Identity-Token":"ID_TOKEN","X-YouTube-Page-CL":"PAGE_CL","X-YouTube-Page-Label":"PAGE_BUILD_LABEL","X-YouTube-Variants-Checksum":"VARIANTS_CHECKSUM"};var Td={},Ud=0;function Vd(a,b){isNaN(b)&&(b=void 0);var c=r("yt.scheduler.instance.addJob");return c?c(a,1,b):void 0===b?(a(),NaN):H(a,b||0)}
;var Wd=[],Xd=!1;function Yd(){function a(){Xd=!0;"google_ad_status"in window?Zb("DCLKSTAT",1):Zb("DCLKSTAT",2)}
qc("//static.doubleclick.net/instream/ad_status.js",a);Wd.push(Vd(function(){Xd||"google_ad_status"in window||(xc("//static.doubleclick.net/instream/ad_status.js",a),Zb("DCLKSTAT",3))},5E3))}
function Zd(){return parseInt(G("DCLKSTAT",0),10)}
;function $d(a){if(a.classList)return a.classList;a=a.className;return v(a)&&a.match(/\S+/g)||[]}
function ae(a,b){return a.classList?a.classList.contains(b):A($d(a),b)}
function be(a,b){a.classList?a.classList.add(b):ae(a,b)||(a.className+=0<a.className.length?" "+b:b)}
function ce(a,b){a.classList?a.classList.remove(b):ae(a,b)&&(a.className=Ia($d(a),function(a){return a!=b}).join(" "))}
function de(a,b,c){c?be(a,b):ce(a,b)}
;function ee(a,b){this.x=p(a)?a:0;this.y=p(b)?b:0}
ee.prototype.clone=function(){return new ee(this.x,this.y)};
ee.prototype.ceil=function(){this.x=Math.ceil(this.x);this.y=Math.ceil(this.y);return this};
ee.prototype.floor=function(){this.x=Math.floor(this.x);this.y=Math.floor(this.y);return this};
ee.prototype.round=function(){this.x=Math.round(this.x);this.y=Math.round(this.y);return this};function fe(a,b){this.width=a;this.height=b}
g=fe.prototype;g.clone=function(){return new fe(this.width,this.height)};
g.Yc=function(){return this.width*this.height};
g.aspectRatio=function(){return this.width/this.height};
g.isEmpty=function(){return!this.Yc()};
g.ceil=function(){this.width=Math.ceil(this.width);this.height=Math.ceil(this.height);return this};
g.floor=function(){this.width=Math.floor(this.width);this.height=Math.floor(this.height);return this};
g.round=function(){this.width=Math.round(this.width);this.height=Math.round(this.height);return this};!Zc&&!K||K&&kd(9)||Zc&&jd("1.9.1");var ge=K&&!jd("9");function he(a){return a?new ie(je(a)):oa||(oa=new ie)}
function ke(a){var b=document;return v(a)?b.getElementById(a):a}
function le(a){var b=document;return b.querySelectorAll&&b.querySelector?b.querySelectorAll("."+a):me(a)}
function me(a){var b,c,d,e;b=document;if(b.querySelectorAll&&b.querySelector&&a)return b.querySelectorAll(""+(a?"."+a:""));if(a&&b.getElementsByClassName){var f=b.getElementsByClassName(a);return f}f=b.getElementsByTagName("*");if(a){e={};for(c=d=0;b=f[c];c++){var h=b.className;"function"==typeof h.split&&A(h.split(/\s+/),a)&&(e[d++]=b)}e.length=d;return e}return f}
function ne(a){var b=a.scrollingElement?a.scrollingElement:!$c&&oe(a)?a.documentElement:a.body||a.documentElement;a=a.parentWindow||a.defaultView;return K&&jd("10")&&a.pageYOffset!=b.scrollTop?new ee(b.scrollLeft,b.scrollTop):new ee(a.pageXOffset||b.scrollLeft,a.pageYOffset||b.scrollTop)}
function oe(a){return"CSS1Compat"==a.compatMode}
function pe(a){for(var b;b=a.firstChild;)a.removeChild(b)}
function qe(a){if(!a)return null;if(a.firstChild)return a.firstChild;for(;a&&!a.nextSibling;)a=a.parentNode;return a?a.nextSibling:null}
function re(a){if(!a)return null;if(!a.previousSibling)return a.parentNode;for(a=a.previousSibling;a&&a.lastChild;)a=a.lastChild;return a}
function je(a){return 9==a.nodeType?a:a.ownerDocument||a.document}
function se(a,b){if("textContent"in a)a.textContent=b;else if(3==a.nodeType)a.data=b;else if(a.firstChild&&3==a.firstChild.nodeType){for(;a.lastChild!=a.firstChild;)a.removeChild(a.lastChild);a.firstChild.data=b}else{pe(a);var c=je(a);a.appendChild(c.createTextNode(String(b)))}}
var te={SCRIPT:1,STYLE:1,HEAD:1,IFRAME:1,OBJECT:1},ue={IMG:" ",BR:"\n"};function ve(a){if(ge&&null!==a&&"innerText"in a)a=a.innerText.replace(/(\r\n|\r|\n)/g,"\n");else{var b=[];we(a,b,!0);a=b.join("")}a=a.replace(/ \xAD /g," ").replace(/\xAD/g,"");a=a.replace(/\u200B/g,"");ge||(a=a.replace(/ +/g," "));" "!=a&&(a=a.replace(/^\s*/,""));return a}
function we(a,b,c){if(!(a.nodeName in te))if(3==a.nodeType)c?b.push(String(a.nodeValue).replace(/(\r\n|\r|\n)/g,"")):b.push(a.nodeValue);else if(a.nodeName in ue)b.push(ue[a.nodeName]);else for(a=a.firstChild;a;)we(a,b,c),a=a.nextSibling}
function xe(a){var b=ye.Oc;return b?ze(a,function(a){return!b||v(a.className)&&A(a.className.split(/\s+/),b)},!0,void 0):null}
function ze(a,b,c,d){c||(a=a.parentNode);for(c=0;a&&(null==d||c<=d);){if(b(a))return a;a=a.parentNode;c++}return null}
function ie(a){this.b=a||l.document||document}
ie.prototype.createElement=function(a){return this.b.createElement(String(a))};
ie.prototype.appendChild=function(a,b){a.appendChild(b)};
ie.prototype.isElement=function(a){return ga(a)&&1==a.nodeType};
ie.prototype.contains=function(a,b){if(!a||!b)return!1;if(a.contains&&1==b.nodeType)return a==b||a.contains(b);if("undefined"!=typeof a.compareDocumentPosition)return a==b||!!(a.compareDocumentPosition(b)&16);for(;b&&a!=b;)b=b.parentNode;return b==a};var Ae=r("yt.dom.getNextId_");if(!Ae){Ae=function(){return++Be};
q("yt.dom.getNextId_",Ae,void 0);var Be=0}function Ce(){var a=document,b;Ka(["fullscreenElement","webkitFullscreenElement","mozFullScreenElement","msFullscreenElement"],function(c){b=a[c];return!!b});
return b}
;function De(a){this.type="";this.state=this.source=this.data=this.currentTarget=this.relatedTarget=this.target=null;this.charCode=this.keyCode=0;this.shiftKey=this.ctrlKey=this.altKey=!1;this.clientY=this.clientX=0;this.changedTouches=null;if(a=a||window.event){this.event=a;for(var b in a)b in Ee||(this[b]=a[b]);(b=a.target||a.srcElement)&&3==b.nodeType&&(b=b.parentNode);this.target=b;if(b=a.relatedTarget)try{b=b.nodeName?b:null}catch(c){b=null}else"mouseover"==this.type?b=a.fromElement:"mouseout"==
this.type&&(b=a.toElement);this.relatedTarget=b;this.clientX=void 0!=a.clientX?a.clientX:a.pageX;this.clientY=void 0!=a.clientY?a.clientY:a.pageY;this.keyCode=a.keyCode?a.keyCode:a.which;this.charCode=a.charCode||("keypress"==this.type?this.keyCode:0);this.altKey=a.altKey;this.ctrlKey=a.ctrlKey;this.shiftKey=a.shiftKey}}
De.prototype.preventDefault=function(){this.event&&(this.event.returnValue=!1,this.event.preventDefault&&this.event.preventDefault())};
De.prototype.stopPropagation=function(){this.event&&(this.event.cancelBubble=!0,this.event.stopPropagation&&this.event.stopPropagation())};
De.prototype.stopImmediatePropagation=function(){this.event&&(this.event.cancelBubble=!0,this.event.stopImmediatePropagation&&this.event.stopImmediatePropagation())};
var Ee={stopImmediatePropagation:1,stopPropagation:1,preventMouseEvent:1,preventManipulation:1,preventDefault:1,layerX:1,layerY:1,scale:1,rotation:1,webkitMovementX:1,webkitMovementY:1};var eb=r("yt.events.listeners_")||{};q("yt.events.listeners_",eb,void 0);var Fe=r("yt.events.counter_")||{count:0};q("yt.events.counter_",Fe,void 0);function Ge(a,b,c,d){a.addEventListener&&("mouseenter"!=b||"onmouseenter"in document?"mouseleave"!=b||"onmouseenter"in document?"mousewheel"==b&&"MozBoxSizing"in document.documentElement.style&&(b="MozMousePixelScroll"):b="mouseout":b="mouseover");return db(function(e){return e[0]==a&&e[1]==b&&e[2]==c&&e[4]==!!d})}
function M(a,b,c,d){if(!a||!a.addEventListener&&!a.attachEvent)return"";d=!!d;var e=Ge(a,b,c,d);if(e)return e;var e=++Fe.count+"",f=!("mouseenter"!=b&&"mouseleave"!=b||!a.addEventListener||"onmouseenter"in document),h;h=f?function(d){d=new De(d);if(!ze(d.relatedTarget,function(b){return b==a},!0))return d.currentTarget=a,d.type=b,c.call(a,d)}:function(b){b=new De(b);
b.currentTarget=a;return c.call(a,b)};
h=ac(h);a.addEventListener?("mouseenter"==b&&f?b="mouseover":"mouseleave"==b&&f?b="mouseout":"mousewheel"==b&&"MozBoxSizing"in document.documentElement.style&&(b="MozMousePixelScroll"),a.addEventListener(b,h,d)):a.attachEvent("on"+b,h);eb[e]=[a,b,c,h,d];return e}
function He(a){a&&("string"==typeof a&&(a=[a]),z(a,function(a){if(a in eb){var c=eb[a],d=c[0],e=c[1],f=c[3],c=c[4];d.removeEventListener?d.removeEventListener(e,f,c):d.detachEvent&&d.detachEvent("on"+e,f);delete eb[a]}}))}
;function Ie(){if(null==r("_lact",window)){var a=parseInt(G("LACT"),10),a=isFinite(a)?x()-Math.max(a,0):-1;q("_lact",a,window);-1==a&&Je();M(document,"keydown",Je);M(document,"keyup",Je);M(document,"mousedown",Je);M(document,"mouseup",Je);kc("page-mouse",Je);kc("page-scroll",Je);kc("page-resize",Je)}}
function Je(){null==r("_lact",window)&&(Ie(),r("_lact",window));var a=x();q("_lact",a,window);J("USER_ACTIVE")}
function Ke(){var a=r("_lact",window);return null==a?-1:Math.max(x()-a,0)}
;function Le(){}
;function Me(a){this.b=a||{cookie:""}}
var Ne=/\s*;\s*/;g=Me.prototype;g.isEnabled=function(){return navigator.cookieEnabled};
g.set=function(a,b,c,d,e,f){if(/[;=\s]/.test(a))throw Error('Invalid cookie name "'+a+'"');if(/[;\r\n]/.test(b))throw Error('Invalid cookie value "'+b+'"');p(c)||(c=-1);e=e?";domain="+e:"";d=d?";path="+d:"";f=f?";secure":"";c=0>c?"":0==c?";expires="+(new Date(1970,1,1)).toUTCString():";expires="+(new Date(x()+1E3*c)).toUTCString();this.b.cookie=a+"="+b+e+d+c+f};
g.get=function(a,b){for(var c=a+"=",d=(this.b.cookie||"").split(Ne),e=0,f;f=d[e];e++){if(0==f.lastIndexOf(c,0))return f.substr(c.length);if(f==a)return""}return b};
g.remove=function(a,b,c){var d=p(this.get(a));this.set(a,"",0,b,c);return d};
g.ja=function(){return Oe(this).keys};
g.P=function(){return Oe(this).values};
g.isEmpty=function(){return!this.b.cookie};
g.O=function(){return this.b.cookie?(this.b.cookie||"").split(Ne).length:0};
g.Ra=function(a){for(var b=Oe(this).values,c=0;c<b.length;c++)if(b[c]==a)return!0;return!1};
g.clear=function(){for(var a=Oe(this).keys,b=a.length-1;0<=b;b--)this.remove(a[b])};
function Oe(a){a=(a.b.cookie||"").split(Ne);for(var b=[],c=[],d,e,f=0;e=a[f];f++)d=e.indexOf("="),-1==d?(b.push(""),c.push(e)):(b.push(e.substring(0,d)),c.push(e.substring(d+1)));return{keys:b,values:c}}
var Pe=new Me("undefined"==typeof document?null:document);Pe.f=3950;function Qe(a,b,c){Pe.set(""+a,b,c,"/","youtube.com")}
;function Re(a,b,c){var d=G("EVENT_ID");d&&(b||(b={}),b.ei||(b.ei=d));if(b){var d=G("VALID_SESSION_TEMPDATA_DOMAINS",[]),e=wd(window.location.href);e&&d.push(e);e=wd(a);if(A(d,e)||!e&&0==a.lastIndexOf("/",0)){var f=a.match(vd),d=f[5],e=f[6],f=f[7],h="";d&&(h+=d);e&&(h+="?"+e);f&&(h+="#"+f);d=h;e=d.indexOf("#");if(d=0>e?d:d.substr(0,e))d="ST-"+Ga(d).toString(36),e=b?Cd(b):"",Qe(d,e,5),b&&(b=b.itct||b.ved,d=r("yt.logging.screenreporter.storeParentElement"),b&&d&&d(new Le))}}if(c)return!1;(window.ytspf||
{}).enabled?spf.navigate(a):(c=window.location,a=Ed(a,{})+"",a=a instanceof rb?a:vb(a),c.href=tb(a));return!0}
;function Se(a){a=a||{};this.url=a.url||"";this.urlV9As2=a.url_v9as2||"";this.args=a.args||hb(Te);this.assets=a.assets||{};this.attrs=a.attrs||hb(Ue);this.params=a.params||hb(Ve);this.minVersion=a.min_version||"8.0.0";this.fallback=a.fallback||null;this.fallbackMessage=a.fallbackMessage||null;this.html5=!!a.html5;this.disable=a.disable||{};this.loaded=!!a.loaded;this.messages=a.messages||{}}
var Te={enablejsapi:1},Ue={},Ve={allowscriptaccess:"always",allowfullscreen:"true",bgcolor:"#000000"};function We(a){a instanceof Se||(a=new Se(a));return a}
Se.prototype.clone=function(){var a=new Se,b;for(b in this)if(this.hasOwnProperty(b)){var c=this[b];"object"==ca(c)?a[b]=hb(c):a[b]=c}return a};function Xe(a,b,c,d){this.top=a;this.right=b;this.bottom=c;this.left=d}
g=Xe.prototype;g.getHeight=function(){return this.bottom-this.top};
g.clone=function(){return new Xe(this.top,this.right,this.bottom,this.left)};
g.contains=function(a){return this&&a?a instanceof Xe?a.left>=this.left&&a.right<=this.right&&a.top>=this.top&&a.bottom<=this.bottom:a.x>=this.left&&a.x<=this.right&&a.y>=this.top&&a.y<=this.bottom:!1};
g.ceil=function(){this.top=Math.ceil(this.top);this.right=Math.ceil(this.right);this.bottom=Math.ceil(this.bottom);this.left=Math.ceil(this.left);return this};
g.floor=function(){this.top=Math.floor(this.top);this.right=Math.floor(this.right);this.bottom=Math.floor(this.bottom);this.left=Math.floor(this.left);return this};
g.round=function(){this.top=Math.round(this.top);this.right=Math.round(this.right);this.bottom=Math.round(this.bottom);this.left=Math.round(this.left);return this};function Ye(a,b,c,d){this.left=a;this.top=b;this.width=c;this.height=d}
g=Ye.prototype;g.clone=function(){return new Ye(this.left,this.top,this.width,this.height)};
g.contains=function(a){return a instanceof ee?a.x>=this.left&&a.x<=this.left+this.width&&a.y>=this.top&&a.y<=this.top+this.height:this.left<=a.left&&this.left+this.width>=a.left+a.width&&this.top<=a.top&&this.top+this.height>=a.top+a.height};
g.ceil=function(){this.left=Math.ceil(this.left);this.top=Math.ceil(this.top);this.width=Math.ceil(this.width);this.height=Math.ceil(this.height);return this};
g.floor=function(){this.left=Math.floor(this.left);this.top=Math.floor(this.top);this.width=Math.floor(this.width);this.height=Math.floor(this.height);return this};
g.round=function(){this.left=Math.round(this.left);this.top=Math.round(this.top);this.width=Math.round(this.width);this.height=Math.round(this.height);return this};function Ze(a){Ze[" "](a);return a}
Ze[" "]=t;function $e(a,b){var c=je(a);return c.defaultView&&c.defaultView.getComputedStyle&&(c=c.defaultView.getComputedStyle(a,null))?c[b]||c.getPropertyValue(b)||"":""}
function af(a,b){return $e(a,b)||(a.currentStyle?a.currentStyle[b]:null)||a.style&&a.style[b]}
function bf(a){var b;try{b=a.getBoundingClientRect()}catch(c){return{left:0,top:0,right:0,bottom:0}}K&&a.ownerDocument.body&&(a=a.ownerDocument,b.left-=a.documentElement.clientLeft+a.body.clientLeft,b.top-=a.documentElement.clientTop+a.body.clientTop);return b}
function cf(a,b){"number"==typeof a&&(a=(b?Math.round(a):a)+"px");return a}
function df(a){var b=ef;if("none"!=af(a,"display"))return b(a);var c=a.style,d=c.display,e=c.visibility,f=c.position;c.visibility="hidden";c.position="absolute";c.display="inline";a=b(a);c.display=d;c.position=f;c.visibility=e;return a}
function ef(a){var b=a.offsetWidth,c=a.offsetHeight,d=$c&&!b&&!c;return p(b)&&!d||!a.getBoundingClientRect?new fe(b,c):(a=bf(a),new fe(a.right-a.left,a.bottom-a.top))}
function ff(a,b){if(/^\d+px?$/.test(b))return parseInt(b,10);var c=a.style.left,d=a.runtimeStyle.left;a.runtimeStyle.left=a.currentStyle.left;a.style.left=b;var e=a.style.pixelLeft;a.style.left=c;a.runtimeStyle.left=d;return e}
function gf(a,b){var c=a.currentStyle?a.currentStyle[b]:null;return c?ff(a,c):0}
var hf={thin:2,medium:4,thick:6};function jf(a,b){if("none"==(a.currentStyle?a.currentStyle[b+"Style"]:null))return 0;var c=a.currentStyle?a.currentStyle[b+"Width"]:null;return c in hf?hf[c]:ff(a,c)}
;var kf=B("Firefox"),lf=Wc()||B("iPod"),mf=B("iPad"),nf=B("Android")&&!(ob()||B("Firefox")||B("Opera")||B("Silk")),of=ob(),pf=B("Safari")&&!(ob()||B("Coast")||B("Opera")||B("Edge")||B("Silk")||B("Android"))&&!(Wc()||B("iPad")||B("iPod"));function qf(){var a;if(a=Pe.get("PREF",void 0)){a=unescape(a).split("&");for(var b=0;b<a.length;b++){var c=a[b].split("="),d=c[0];(c=c[1])&&(rf[d]=c.toString())}}}
ba(qf);var rf=r("yt.prefs.UserPrefs.prefs_")||{};q("yt.prefs.UserPrefs.prefs_",rf,void 0);function sf(a){if(/^f([1-9][0-9]*)$/.test(a))throw"ExpectedRegexMatch: "+a;}
function tf(a){if(!/^\w+$/.test(a))throw"ExpectedRegexMismatch: "+a;}
function uf(a){a=void 0!==rf[a]?rf[a].toString():null;return null!=a&&/^[A-Fa-f0-9]+$/.test(a)?parseInt(a,16):null}
qf.prototype.get=function(a,b){tf(a);sf(a);var c=void 0!==rf[a]?rf[a].toString():null;return null!=c?c:b?b:""};
qf.prototype.set=function(a,b){tf(a);sf(a);if(null==b)throw"ExpectedNotNull";rf[a]=b.toString()};
function vf(a,b){return!!((uf("f"+(Math.floor(b/31)+1))||0)&1<<b%31)}
qf.prototype.remove=function(a){tf(a);sf(a);delete rf[a]};
qf.prototype.clear=function(){rf={}};function wf(a,b){(a=ke(a))&&a.style&&(a.style.display=b?"":"none",de(a,"hid",!b))}
function xf(a){z(arguments,function(a){!da(a)||a instanceof Element?wf(a,!0):z(a,function(a){xf(a)})})}
function yf(a){z(arguments,function(a){!da(a)||a instanceof Element?wf(a,!1):z(a,function(a){yf(a)})})}
;function zf(){this.g=this.f=this.b=0;this.i="";var a=r("window.navigator.plugins"),b=r("window.navigator.mimeTypes"),a=a&&a["Shockwave Flash"],b=b&&b["application/x-shockwave-flash"],b=a&&b&&b.enabledPlugin&&a.description||"";if(a=b){var c=a.indexOf("Shockwave Flash");0<=c&&(a=a.substr(c+15));for(var c=a.split(" "),d="",a="",e=0,f=c.length;e<f;e++)if(d)if(a)break;else a=c[e];else d=c[e];d=d.split(".");c=parseInt(d[0],10)||0;d=parseInt(d[1],10)||0;e=0;if("r"==a.charAt(0)||"d"==a.charAt(0))e=parseInt(a.substr(1),
10)||0;a=[c,d,e]}else a=[0,0,0];this.i=b;b=a;this.b=b[0];this.f=b[1];this.g=b[2];if(0>=this.b){var h,k,m,n;if(ec)try{h=new ActiveXObject("ShockwaveFlash.ShockwaveFlash")}catch(Z){h=null}else m=document.body,n=document.createElement("object"),n.setAttribute("type","application/x-shockwave-flash"),h=m.appendChild(n);if(h&&"GetVariable"in h)try{k=h.GetVariable("$version")}catch(Z){k=""}m&&n&&m.removeChild(n);(h=k||"")?(h=h.split(" ")[1].split(","),h=[parseInt(h[0],10)||0,parseInt(h[1],10)||0,parseInt(h[2],
10)||0]):h=[0,0,0];this.b=h[0];this.f=h[1];this.g=h[2]}}
ba(zf);function Af(a,b,c,d){b="string"==typeof b?b.split("."):[b,c,d];b[0]=parseInt(b[0],10)||0;b[1]=parseInt(b[1],10)||0;b[2]=parseInt(b[2],10)||0;return a.b>b[0]||a.b==b[0]&&a.f>b[1]||a.b==b[0]&&a.f==b[1]&&a.g>=b[2]}
function Bf(a){return-1<a.i.indexOf("Gnash")&&-1==a.i.indexOf("AVM2")||9==a.b&&1==a.f||9==a.b&&0==a.f&&1==a.g?!1:9<=a.b}
function Cf(a){return bd?!Af(a,11,2):ad?!Af(a,11,3):!Bf(a)}
;function Df(a,b,c){if(b){a=v(a)?ke(a):a;var d=hb(c.attrs);d.tabindex=0;var e=hb(c.params);e.flashvars=Cd(c.args);if(ec){d.classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000";e.movie=b;b=document.createElement("object");for(var f in d)b.setAttribute(f,d[f]);for(f in e)d=document.createElement("param"),d.setAttribute("name",f),d.setAttribute("value",e[f]),b.appendChild(d)}else{d.type="application/x-shockwave-flash";d.src=b;b=document.createElement("embed");b.setAttribute("name",d.id);for(f in d)b.setAttribute(f,
d[f]);for(f in e)b.setAttribute(f,e[f])}e=document.createElement("div");e.appendChild(b);a.innerHTML=e.innerHTML}}
function Ef(a,b,c){if(a&&a.attrs&&a.attrs.id){a=We(a);var d=!!b,e=ke(a.attrs.id),f=e?e.parentNode:null;if(e&&f){if(window!=window.top){var h=null;if(document.referrer){var k=document.referrer.substring(0,128);Hd(k)||(h=k)}else h="unknown";h&&(d=!0,a.args.framer=h)}h=zf.getInstance();if(Af(h,a.minVersion)){var k=Ff(a,h),m="";-1<navigator.userAgent.indexOf("Sony/COM2")||(m=e.getAttribute("src")||e.movie);(m!=k||d)&&Df(f,k,a);Cf(h)&&Gf()}else Hf(f,a,h);c&&c()}else H(function(){Ef(a,b,c)},50)}}
function Hf(a,b,c){0==c.b&&b.fallback?b.fallback():0==c.b&&b.fallbackMessage?b.fallbackMessage():a.innerHTML='<div id="flash-upgrade">'+cc()+"</div>"}
function Ff(a,b){return Bf(b)&&a.url||(-1<navigator.userAgent.indexOf("Sony/COM2")&&!Af(b,9,1,58)?!1:!0)&&a.urlV9As2||a.url}
function Gf(){var a=ke("flash10-promo-div"),b=vf(qf.getInstance(),107);a&&!b&&xf(a)}
;function If(a){if(window.spf){var b=a.match(Jf);spf.style.load(a,b?b[1]:"",void 0)}else Kf(a)}
function Kf(a){var b=Lf(a),c=document.getElementById(b),d=c&&C(c,"loaded");d||c&&!d||(c=Mf(a,b,function(){C(c,"loaded")||(Cb(c,"loaded","true"),J(b),H(ma(pc,b),0))}))}
function Mf(a,b,c){var d=document.createElement("link");d.id=b;d.rel="stylesheet";d.onload=function(){c&&setTimeout(c,0)};
Bb(d,a);(document.getElementsByTagName("head")[0]||document.body).appendChild(d);return d}
function Lf(a){var b=document.createElement("a");Bb(b,a);a=b.href.replace(/^[a-zA-Z]+:\/\//,"//");return"css-"+Ga(a)}
var Jf=/cssbin\/(?:debug-)?([a-zA-Z0-9_-]+?)(?:-2x|-web|-rtl|-vfl|.css)/;var Nf;var Of=lb,Of=Of.toLowerCase();if(-1!=Of.indexOf("android")){var Pf=Of.match(/android\D*(\d\.\d)[^\;|\)]*[\;\)]/);if(Pf)Nf=Number(Pf[1]);else{var Qf={cupcake:1.5,donut:1.6,eclair:2,froyo:2.2,gingerbread:2.3,honeycomb:3,"ice cream sandwich":4,jellybean:4.1},Rf=Of.match("("+cb(Qf).join("|")+")");Nf=Rf?Qf[Rf[0]]:0}}else Nf=void 0;var Sf=lf||mf;var Tf=['video/mp4; codecs="avc1.42001E, mp4a.40.2"','video/webm; codecs="vp8.0, vorbis"'],Uf=['audio/mp4; codecs="mp4a.40.2"'];function Vf(a){D.call(this);this.b=[];this.f=a||this}
y(Vf,D);function Wf(a,b,c,d){d=ac(w(d,a.f));b.addEventListener(c,d);a.b.push({target:b,name:c,zb:d})}
Vf.prototype.qb=function(a){for(var b=0;b<this.b.length;b++)if(this.b[b]==a){this.b.splice(b,1);a.target.removeEventListener(a.name,a.zb);break}};
function Xf(a){for(;a.b.length;){var b=a.b.pop();b.target.removeEventListener(b.name,b.zb)}}
Vf.prototype.A=function(){Xf(this);Vf.B.A.call(this)};function Yf(a){return G("EXPERIMENT_FLAGS",{})[a]}
;function Zf(a){a.prototype.then=a.prototype.then;a.prototype.$goog_Thenable=!0}
;function $f(a,b){this.b=0;this.l=void 0;this.i=this.f=this.g=null;this.j=this.o=!1;if(a!=t)try{var c=this;a.call(b,function(a){ag(c,2,a)},function(a){ag(c,3,a)})}catch(d){ag(this,3,d)}}
function bg(){this.next=this.context=this.f=this.g=this.b=null;this.i=!1}
bg.prototype.reset=function(){this.context=this.f=this.g=this.b=null;this.i=!1};
var cg=new Jb(function(){return new bg},function(a){a.reset()},100);
function dg(a,b,c){var d=cg.get();d.g=a;d.f=b;d.context=c;return d}
function eg(a){if(a instanceof $f)return a;var b=new $f(t);ag(b,2,a);return b}
function fg(a){return new $f(function(b,c){c(a)})}
$f.prototype.then=function(a,b,c){return gg(this,fa(a)?a:null,fa(b)?b:null,c)};
Zf($f);$f.prototype.cancel=function(a){0==this.b&&Ob(function(){var b=new hg(a);ig(this,b)},this)};
function ig(a,b){if(0==a.b)if(a.g){var c=a.g;if(c.f){for(var d=0,e=null,f=null,h=c.f;h&&(h.i||(d++,h.b==a&&(e=h),!(e&&1<d)));h=h.next)e||(f=h);e&&(0==c.b&&1==d?ig(c,b):(f?(d=f,d.next==c.i&&(c.i=d),d.next=d.next.next):jg(c),kg(c,e,3,b)))}a.g=null}else ag(a,3,b)}
function lg(a,b){a.f||2!=a.b&&3!=a.b||mg(a);a.i?a.i.next=b:a.f=b;a.i=b}
function gg(a,b,c,d){var e=dg(null,null,null);e.b=new $f(function(a,h){e.g=b?function(c){try{var e=b.call(d,c);a(e)}catch(n){h(n)}}:a;
e.f=c?function(b){try{var e=c.call(d,b);!p(e)&&b instanceof hg?h(b):a(e)}catch(n){h(n)}}:h});
e.b.g=a;lg(a,e);return e.b}
$f.prototype.N=function(a){this.b=0;ag(this,2,a)};
$f.prototype.D=function(a){this.b=0;ag(this,3,a)};
function ag(a,b,c){if(0==a.b){a===c&&(b=3,c=new TypeError("Promise cannot resolve to itself"));a.b=1;var d;a:{var e=c,f=a.N,h=a.D;if(e instanceof $f)lg(e,dg(f||t,h||null,a)),d=!0;else{var k;if(e)try{k=!!e.$goog_Thenable}catch(n){k=!1}else k=!1;if(k)e.then(f,h,a),d=!0;else{if(ga(e))try{var m=e.then;if(fa(m)){ng(e,m,f,h,a);d=!0;break a}}catch(n){h.call(a,n);d=!0;break a}d=!1}}}d||(a.l=c,a.b=b,a.g=null,mg(a),3!=b||c instanceof hg||og(a,c))}}
function ng(a,b,c,d,e){function f(a){k||(k=!0,d.call(e,a))}
function h(a){k||(k=!0,c.call(e,a))}
var k=!1;try{b.call(a,h,f)}catch(m){f(m)}}
function mg(a){a.o||(a.o=!0,Ob(a.u,a))}
function jg(a){var b=null;a.f&&(b=a.f,a.f=b.next,b.next=null);a.f||(a.i=null);return b}
$f.prototype.u=function(){for(var a;a=jg(this);)kg(this,a,this.b,this.l);this.o=!1};
function kg(a,b,c,d){if(3==c&&b.f&&!b.i)for(;a&&a.j;a=a.g)a.j=!1;if(b.b)b.b.g=null,pg(b,c,d);else try{b.i?b.g.call(b.context):pg(b,c,d)}catch(e){qg.call(null,e)}Kb(cg,b)}
function pg(a,b,c){2==b?a.g.call(a.context,c):a.f&&a.f.call(a.context,c)}
function og(a,b){a.j=!0;Ob(function(){a.j&&qg.call(null,b)})}
var qg=Gb;function hg(a){na.call(this,a)}
y(hg,na);hg.prototype.name="cancel";function rg(){this.b={apiaryHost:G("APIARY_HOST",void 0),Wc:G("APIARY_HOST_FIRSTPARTY",void 0),gapiHintOverride:G("GAPI_HINT_OVERRIDE"),gapiHintParams:G("GAPI_HINT_PARAMS",void 0),innertubeApiKey:G("INNERTUBE_API_KEY",void 0),innertubeApiVersion:G("INNERTUBE_API_VERSION",void 0),od:G("INNERTUBE_CONTEXT_CLIENT_NAME","WEB"),innertubeContextClientVersion:G("INNERTUBE_CONTEXT_CLIENT_VERSION",void 0),qd:G("INNERTUBE_CONTEXT_HL",void 0),pd:G("INNERTUBE_CONTEXT_GL",void 0),Re:G("XHR_APIARY_HOST",void 0)};
sg||(sg=tg(this.b))}
var sg=null;function tg(a){return(new $f(function(b){qc(G("GAPI_LOADER_URL",void 0),function(){try{r("yt.gapi.load")("client",{gapiHintOverride:a.gapiHintOverride,_c:{jsl:{h:a.gapiHintParams}},callback:b})}catch(c){bc(c)}})})).then(function(){})}
rg.prototype.f=function(){var a=r("gapi.config.update");a("googleapis.config/auth/useFirstPartyAuth",!0);var b=this.b.apiaryHost;/^[\s\xa0]*$/.test(null==b?"":String(b))||a("googleapis.config/root",(-1==b.indexOf("://")?"//":"")+b);b=this.b.Wc;/^[\s\xa0]*$/.test(null==b?"":String(b))||a("googleapis.config/root-1p",(-1==b.indexOf("://")?"//":"")+b);a("googleapis.config/sessionIndex",G("SESSION_INDEX"));r("gapi.client.setApiKey")(this.b.innertubeApiKey)};
function ug(a,b,c){var d={},e,f=!1;0<d.timeout&&(e=H(function(){f||(f=!0,d.Da&&d.Da())},d.timeout));
vg(a,b,c,function(a){if(!f)if(f=!0,e&&I(e),a)d.$&&d.$(a);else if(d.onError)d.onError()})}
function vg(a,b,c,d){var e={path:"/youtubei/"+a.b.innertubeApiVersion+"/"+b,headers:{"X-Goog-Visitor-Id":G("VISITOR_DATA")},method:"POST",body:L(c)},f=w(a.f,a);sg.then(function(){f();r("gapi.client.request")(e).execute(d||t)})}
;var wg={log_event:"events",log_interaction:"interactions"},xg={},yg={},zg=0,Ag=r("yt.logging.transport.logsQueue_")||{};q("yt.logging.transport.logsQueue_",Ag,void 0);
function Bg(){I(zg);if(!fb(Ag)){for(var a in Ag){var b=xg[a];if(!b){b=yg[a];if(!b)continue;b=new b;xg[a]=b}var c=b.b,c={client:{hl:c.qd,gl:c.pd,clientName:c.od,clientVersion:c.innertubeContextClientVersion}};G("DELEGATED_SESSION_ID")&&(c.user={onBehalfOfUser:G("DELEGATED_SESSION_ID")});c={context:c};c.requestTimeMs=Math.round(dc());c[wg[a]]=Ag[a];ug(b,a,c);delete Ag[a]}fb(Ag)||Cg()}}
function Cg(){I(zg);zg=H(Bg,G("VISIBILITY_TIMEOUT",1E4))}
;function Dg(a,b,c){var d={};d.eventTimeMs=Math.round(c||dc());d[a]=b;Ag.log_event=Ag.log_event||[];a=Ag.log_event;a.push(d);yg.log_event=rg;20<=a.length?Bg():Cg()}
;function Eg(a,b){this.f=this.u=this.i="";this.l=null;this.j=this.b="";this.o=!1;var c;a instanceof Eg?(this.o=p(b)?b:a.o,Fg(this,a.i),this.u=a.u,Gg(this,a.f),Hg(this,a.l),this.b=a.b,Ig(this,a.g.clone()),this.j=a.j):a&&(c=String(a).match(vd))?(this.o=!!b,Fg(this,c[1]||"",!0),this.u=Jg(c[2]||""),Gg(this,c[3]||"",!0),Hg(this,c[4]),this.b=Jg(c[5]||"",!0),Ig(this,c[6]||"",!0),this.j=Jg(c[7]||"")):(this.o=!!b,this.g=new Kg(null,0,this.o))}
Eg.prototype.toString=function(){var a=[],b=this.i;b&&a.push(Lg(b,Mg,!0),":");var c=this.f;if(c||"file"==b)a.push("//"),(b=this.u)&&a.push(Lg(b,Mg,!0),"@"),a.push(encodeURIComponent(String(c)).replace(/%25([0-9a-fA-F]{2})/g,"%$1")),c=this.l,null!=c&&a.push(":",String(c));if(c=this.b)this.f&&"/"!=c.charAt(0)&&a.push("/"),a.push(Lg(c,"/"==c.charAt(0)?Ng:Og,!0));(c=this.g.toString())&&a.push("?",c);(c=this.j)&&a.push("#",Lg(c,Pg));return a.join("")};
Eg.prototype.resolve=function(a){var b=this.clone(),c=!!a.i;c?Fg(b,a.i):c=!!a.u;c?b.u=a.u:c=!!a.f;c?Gg(b,a.f):c=null!=a.l;var d=a.b;if(c)Hg(b,a.l);else if(c=!!a.b){if("/"!=d.charAt(0))if(this.f&&!this.b)d="/"+d;else{var e=b.b.lastIndexOf("/");-1!=e&&(d=b.b.substr(0,e+1)+d)}e=d;if(".."==e||"."==e)d="";else if(-1!=e.indexOf("./")||-1!=e.indexOf("/.")){for(var d=0==e.lastIndexOf("/",0),e=e.split("/"),f=[],h=0;h<e.length;){var k=e[h++];"."==k?d&&h==e.length&&f.push(""):".."==k?((1<f.length||1==f.length&&
""!=f[0])&&f.pop(),d&&h==e.length&&f.push("")):(f.push(k),d=!0)}d=f.join("/")}else d=e}c?b.b=d:c=""!==a.g.toString();c?Ig(b,Jg(a.g.toString())):c=!!a.j;c&&(b.j=a.j);return b};
Eg.prototype.clone=function(){return new Eg(this)};
function Fg(a,b,c){a.i=c?Jg(b,!0):b;a.i&&(a.i=a.i.replace(/:$/,""))}
function Gg(a,b,c){a.f=c?Jg(b,!0):b}
function Hg(a,b){if(b){b=Number(b);if(isNaN(b)||0>b)throw Error("Bad port number "+b);a.l=b}else a.l=null}
function Ig(a,b,c){b instanceof Kg?(a.g=b,Qg(a.g,a.o)):(c||(b=Lg(b,Rg)),a.g=new Kg(b,0,a.o))}
function N(a,b,c){a.g.set(b,c)}
function Sg(a,b,c){u(c)||(c=[String(c)]);Tg(a.g,b,c)}
function Ug(a){N(a,"zx",Math.floor(2147483648*Math.random()).toString(36)+Math.abs(Math.floor(2147483648*Math.random())^x()).toString(36));return a}
function Vg(a){return a instanceof Eg?a.clone():new Eg(a,void 0)}
function Wg(a,b,c,d){var e=new Eg(null,void 0);a&&Fg(e,a);b&&Gg(e,b);c&&Hg(e,c);d&&(e.b=d);return e}
function Jg(a,b){return a?b?decodeURI(a.replace(/%25/g,"%2525")):decodeURIComponent(a):""}
function Lg(a,b,c){return v(a)?(a=encodeURI(a).replace(b,Xg),c&&(a=a.replace(/%25([0-9a-fA-F]{2})/g,"%$1")),a):null}
function Xg(a){a=a.charCodeAt(0);return"%"+(a>>4&15).toString(16)+(a&15).toString(16)}
var Mg=/[#\/\?@]/g,Og=/[\#\?:]/g,Ng=/[\#\?]/g,Rg=/[\#\?@]/g,Pg=/#/g;function Kg(a,b,c){this.f=this.b=null;this.g=a||null;this.i=!!c}
function Yg(a){a.b||(a.b=new Ic,a.f=0,a.g&&xd(a.g,function(b,c){Zg(a,qa(b),c)}))}
g=Kg.prototype;g.O=function(){Yg(this);return this.f};
function Zg(a,b,c){Yg(a);a.g=null;b=$g(a,b);var d=a.b.get(b);d||a.b.set(b,d=[]);d.push(c);a.f=a.f+1}
g.remove=function(a){Yg(this);a=$g(this,a);return Lc(this.b.f,a)?(this.g=null,this.f=this.f-this.b.get(a).length,this.b.remove(a)):!1};
g.clear=function(){this.b=this.g=null;this.f=0};
g.isEmpty=function(){Yg(this);return 0==this.f};
function ah(a,b){Yg(a);b=$g(a,b);return Lc(a.b.f,b)}
g.Ra=function(a){var b=this.P();return A(b,a)};
g.ja=function(){Yg(this);for(var a=this.b.P(),b=this.b.ja(),c=[],d=0;d<b.length;d++)for(var e=a[d],f=0;f<e.length;f++)c.push(b[d]);return c};
g.P=function(a){Yg(this);var b=[];if(v(a))ah(this,a)&&(b=Ra(b,this.b.get($g(this,a))));else{a=this.b.P();for(var c=0;c<a.length;c++)b=Ra(b,a[c])}return b};
g.set=function(a,b){Yg(this);this.g=null;a=$g(this,a);ah(this,a)&&(this.f=this.f-this.b.get(a).length);this.b.set(a,[b]);this.f=this.f+1;return this};
g.get=function(a,b){var c=a?this.P(a):[];return 0<c.length?String(c[0]):b};
function Tg(a,b,c){a.remove(b);0<c.length&&(a.g=null,a.b.set($g(a,b),Sa(c)),a.f=a.f+c.length)}
g.toString=function(){if(this.g)return this.g;if(!this.b)return"";for(var a=[],b=this.b.ja(),c=0;c<b.length;c++)for(var d=b[c],e=encodeURIComponent(String(d)),d=this.P(d),f=0;f<d.length;f++){var h=e;""!==d[f]&&(h+="="+encodeURIComponent(String(d[f])));a.push(h)}return this.g=a.join("&")};
g.clone=function(){var a=new Kg;a.g=this.g;this.b&&(a.b=this.b.clone(),a.f=this.f);return a};
function $g(a,b){var c=String(b);a.i&&(c=c.toLowerCase());return c}
function Qg(a,b){b&&!a.i&&(Yg(a),a.g=null,a.b.forEach(function(a,b){var e=b.toLowerCase();b!=e&&(this.remove(b),Tg(this,e,a))},a));
a.i=b}
g.extend=function(a){for(var b=0;b<arguments.length;b++)Qc(arguments[b],function(a,b){Zg(this,b,a)},this)};var bh="corp.google.com googleplex.com youtube.com youtube-nocookie.com youtubeeducation.com borg.google.com prod.google.com sandbox.google.com books.googleusercontent.com docs.google.com drive.google.com mail.google.com photos.google.com plus.google.com lh2.google.com picasaweb.google.com play.google.com googlevideo.com talkgadget.google.com survey.g.doubleclick.net youtube.googleapis.com vevo.com".split(" "),ch="";
function dh(a){return a&&a==ch?!0:(new RegExp("^(https?:)?//([a-z0-9-]{1,63}\\.)*("+bh.join("|").replace(/\./g,".")+")(:[0-9]+)?([/?#]|$)","i")).test(a)?(ch=a,!0):!1}
;var eh={},fh=0;function gh(a){var b=new Image,c=""+fh++;eh[c]=b;b.onload=b.onerror=function(){delete eh[c]};
b.src=a}
;function O(a,b){this.version=a;this.args=b}
function hh(a){if(!a.va){var b={};a.call(b);a.va=b.version}return a.va}
function ih(a,b){function c(){a.apply(this,b.args)}
if(!b.args||!b.version)throw Error("yt.pubsub2.Data.deserialize(): serializedData is incomplete.");var d;try{d=hh(a)}catch(e){}if(!d||b.version!=d)throw Error("yt.pubsub2.Data.deserialize(): serializedData version is incompatible.");c.prototype=a.prototype;try{return new c}catch(e){throw e.message="yt.pubsub2.Data.deserialize(): "+e.message,e;}}
function P(a,b){this.topic=a;this.b=b}
P.prototype.toString=function(){return this.topic};var jh=r("yt.pubsub2.instance_")||new F;F.prototype.subscribe=F.prototype.subscribe;F.prototype.unsubscribeByKey=F.prototype.ha;F.prototype.publish=F.prototype.w;F.prototype.clear=F.prototype.clear;q("yt.pubsub2.instance_",jh,void 0);var kh=r("yt.pubsub2.subscribedKeys_")||{};q("yt.pubsub2.subscribedKeys_",kh,void 0);var lh=r("yt.pubsub2.topicToKeys_")||{};q("yt.pubsub2.topicToKeys_",lh,void 0);var mh=r("yt.pubsub2.isAsync_")||{};q("yt.pubsub2.isAsync_",mh,void 0);
q("yt.pubsub2.skipSubKey_",null,void 0);function Q(a,b){var c=nh();c&&c.publish.call(c,a.toString(),a,b)}
function oh(a,b,c){var d=nh();if(!d)return 0;var e=d.subscribe(a.toString(),function(d,h){if(!window.yt.pubsub2.skipSubKey_||window.yt.pubsub2.skipSubKey_!=e){var k=function(){if(kh[e])try{if(h&&a instanceof P&&a!=d)try{h=ih(a.b,h)}catch(k){throw k.message="yt.pubsub2 cross-binary conversion error for "+a.toString()+": "+k.message,k;}b.call(c||window,h)}catch(k){bc(k)}};
mh[a.toString()]?r("yt.scheduler.instance")?Vd(k,void 0):H(k,0):k()}});
kh[e]=!0;lh[a.toString()]||(lh[a.toString()]=[]);lh[a.toString()].push(e);return e}
function ph(a){var b=nh();b&&(ea(a)&&(a=[a]),z(a,function(a){b.unsubscribeByKey(a);delete kh[a]}))}
function nh(){return r("yt.pubsub2.instance_")}
;var qh=x().toString();var rh=window.performance||window.mozPerformance||window.msPerformance||window.webkitPerformance||{};function sh(a){O.call(this,1,arguments)}
y(sh,O);var th=new P("timing-sent",sh);var uh={vc:!0},vh=/^mark_/i,wh={ad_at:"adType",cpn:"clientPlaybackNonce",csn:"clientScreenNonce",yt_lt:"loadType",yt_ad:"isMonetized",yt_ad_pr:"prerollAllowed",yt_red:"isRedSubscriber",yt_vis:"isVisible"},xh=["isMonetized","prerollAllowed","isRedSubscriber","isVisible"],yh=w(rh.clearResourceTimings||rh.webkitClearResourceTimings||rh.mozClearResourceTimings||rh.msClearResourceTimings||rh.oClearResourceTimings||t,rh);
function zh(a){if("_"!=a[0]){var b=a;rh.mark&&(vh.test(b)||(b="mark_"+b),rh.mark(b))}var b=Ah(),c=dc();b[a]&&(b["_"+a]=b["_"+a]||[b[a]],b["_"+a].push(c));b[a]=c;Bh()["tick_"+a]=void 0;Yf("csi_on_gel")?(b=Ch(),"_start"==a?Dg("latencyActionBaselined",{clientActionNonce:b},void 0):Dg("latencyActionTicked",{tickName:a,clientActionNonce:b},void 0),a=!0):a=!1;a||(a=!!r("yt.timing.pingSent_")&&!!Yf("navigation_only_csi_reset"));if(!a&&(b=G("TIMING_ACTION",void 0),a=Ah(),r("yt.timing.ready_")&&b&&a._start&&
Dh())){b=!0;c=G("TIMING_WAIT",[]);if(c.length)for(var d=0,e=c.length;d<e;++d)if(!(c[d]in a)){b=!1;break}b&&Eh()}}
function Fh(){var a=Gh().info.yt_lt="hot_bg";Bh().info_yt_lt=a;if(Yf("csi_on_gel"))if("yt_lt"in wh){var b={},c=wh.yt_lt;c in xh&&(a=!!a);b[c]=a;a=Ch();b.clientActionNonce=a;Dg("latencyActionInfo",b)}else bc(Error("Unknown label yt_lt logged with GEL CSI."))}
function Dh(){var a=Ah();if(a.aft)return a.aft;for(var b=G("TIMING_AFT_KEYS",["ol"]),c=b.length,d=0;d<c;d++){var e=a[b[d]];if(e)return e}return NaN}
function Eh(){var a=Ah(),b=Gh().info,c=a._start,d;for(d in a)if(0==d.lastIndexOf("_",0)&&u(a[d])){var e=d.slice(1);if(e in uh){var f=Ja(a[d],function(a){return Math.round(a-c)});
b["all_"+e]=f.join()}delete a[d]}e=!!b.ap;if(f=r("yt.timing.reportbuilder_")){if(f=f(a,b,void 0))Hh(f,e),Ih(),yh(),Jh(!1,void 0)}else{var h=G("CSI_SERVICE_NAME","youtube"),f={v:2,s:h,action:G("TIMING_ACTION",void 0)},k=b.srt;delete b.srt;void 0===a.srt&&(k||0===k||(k=rh.timing||{},k=Math.max(0,k.responseStart-k.navigationStart),isNaN(k)&&b.pt&&(k=b.pt)),k||0===k)&&(b.srt=Math.round(k));if(b.h5jse){var m=window.location.protocol+r("ytplayer.config.assets.js");(m=rh.getEntriesByName?rh.getEntriesByName(m)[0]:
null)?b.h5jse=Math.round(b.h5jse-m.responseEnd):delete b.h5jse}a.aft=Dh();Kh()&&"youtube"==h&&(Fh(),h=a.vc,m=a.pbs,delete a.aft,b.aft=Math.round(m-h));for(var n in b)"_"!=n.charAt(0)&&(f[n]=b[n]);a.ps=dc();b={};n=[];for(d in a)"_"!=d.charAt(0)&&(h=Math.round(a[d]-c),Yf("enable_negative_ticks")||(h=Math.max(h,0)),b[d]=h,n.push(d+"."+h));f.rt=n.join(",");(a=r("ytdebug.logTiming"))&&a(f,b);Yf("navigation_only_csi_reset")||(Ih(),yh(),Jh(!1,void 0));Hh(f,e,void 0);Q(th,new sh(b.aft+(k||0)))}}
function Hh(a,b,c){if(Yf("debug_csi_data")){var d=r("yt.timing.csiData");d||(d=[],q("yt.timing.csiData",d,void 0));d.push({page:location.href,time:new Date,args:a})}var d="",e;for(e in a)d+="&"+e+"="+a[e];a="/csi_204?"+d.substring(1);if(window.navigator&&window.navigator.sendBeacon&&(!Yf("beacon_abandoned_only")||b))try{window.navigator&&window.navigator.sendBeacon&&window.navigator.sendBeacon(a,"")||a&&gh(a)}catch(f){a&&gh(a)}else a&&gh(a);Jh(!0,c)}
function Ch(){var a=Gh().nonce;if(!a){var b;a:{if(window.crypto&&window.crypto.getRandomValues)try{var c=Array(16),d=new Uint8Array(16);window.crypto.getRandomValues(d);for(a=0;a<c.length;a++)c[a]=d[a];b=c;break a}catch(e){}b=Array(16);for(c=0;16>c;c++){d=x();for(a=0;a<d%23;a++)b[c]=Math.random();b[c]=Math.floor(256*Math.random())}if(qh)for(c=1,d=0;d<qh.length;d++)b[c%16]=b[c%16]^b[(c-1)%16]/4^qh.charCodeAt(d),c++}c=[];for(d=0;d<b.length;d++)c.push("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_".charAt(b[d]&
63));a=c.join("");Gh().nonce=a}return a}
function Ah(){return Gh().tick}
function Bh(){var a=Gh();"gel"in a||(a.gel={});return a.gel}
function Gh(){return r("ytcsi.data_")||Ih()}
function Ih(){var a={tick:{},info:{}};q("ytcsi.data_",a,void 0);return a}
function Jh(a,b){q("yt.timing."+(b||"")+"pingSent_",a,void 0)}
function Kh(){var a=Ah(),b=a.pbr,c=a.vc,a=a.pbs;return b&&c&&a&&b<c&&c<a&&1==Gh().info.yt_vis}
;var Lh={"api.invalidparam":2,auth:150,"drm.auth":150,heartbeat:150,"html5.unsupportedads":5,"fmt.noneavailable":5,"fmt.decode":5,"fmt.unplayable":5,"html5.missingapi":5,"html5.unsupportedlive":5,"drm.unavailable":5};function Mh(a,b){D.call(this);this.o=this.j=a;this.ba=b;this.u=!1;this.f={};this.qa=this.X=null;this.ca=new F;Ub(this,ma(E,this.ca));this.i={};this.D=this.Ga=this.g=this.xb=this.b=null;this.ia=!1;this.F=this.l=this.K=this.L=null;this.ab={};this.Uc=["onReady"];this.ka=new Vf(this);Ub(this,ma(E,this.ka));this.yb=null;this.Xb=NaN;this.la={};Nh(this);this.na("onDetailedError",w(this.Ed,this));this.na("onTabOrderChange",w(this.Zc,this));this.na("onTabAnnounce",w(this.Yb,this));this.na("WATCH_LATER_VIDEO_ADDED",
w(this.Fd,this));this.na("WATCH_LATER_VIDEO_REMOVED",w(this.Gd,this));kf||(this.na("onMouseWheelCapture",w(this.Bd,this)),this.na("onMouseWheelRelease",w(this.Cd,this)));this.na("onAdAnnounce",w(this.Yb,this));this.H=new Vf(this);Ub(this,ma(E,this.H));this.wb=!1;this.vb=null}
y(Mh,D);var Oh=["drm.unavailable","fmt.noneavailable","html5.missingapi","html5.unsupportedads","html5.unsupportedlive"];g=Mh.prototype;g.Tb=function(a,b){this.isDisposed()||(Ph(this,a),Qh(this,b),this.u&&Rh(this))};
function Ph(a,b){a.xb=b;a.b=b.clone();a.g=a.b.attrs.id||a.g;"video-player"==a.g&&(a.g=a.ba,a.b.attrs.id=a.ba);a.o.id==a.g&&(a.g+="-player",a.b.attrs.id=a.g);a.b.args.enablejsapi="1";a.b.args.playerapiid=a.ba;a.Ga||(a.Ga=Sh(a,a.b.args.jsapicallback||"onYouTubePlayerReady"));a.b.args.jsapicallback=null;var c=a.b.attrs.width;c&&(a.o.style.width=cf(Number(c)||c,!0));if(c=a.b.attrs.height)a.o.style.height=cf(Number(c)||c,!0)}
g.fd=function(){return this.xb};
function Rh(a){a.b.loaded||(a.b.loaded=!0,"0"!=a.b.args.autoplay?a.f.loadVideoByPlayerVars(a.b.args):a.f.cueVideoByPlayerVars(a.b.args))}
function Th(a){if(!p(a.b.disable.flash)){var b=a.b.disable,c;c=Af(zf.getInstance(),a.b.minVersion);b.flash=!c}return!a.b.disable.flash}
function Uh(a,b){if((!b||(5!=(Lh[b.errorCode]||5)?0:-1!=Oh.indexOf(b.errorCode)))&&Th(a)){var c=Vh(a);c&&c.stopVideo&&c.stopVideo();var d=a.b;c&&c.getUpdatedConfigurationData&&(c=c.getUpdatedConfigurationData(),d=We(c));d.args.autoplay=1;d.args.html5_unavailable="1";Ph(a,d);Qh(a,"flash")}}
function Qh(a,b){if(!a.isDisposed()){if(!b){var c;if(!(c=!a.b.html5&&Th(a))){if(!p(a.b.disable.html5)){var d;c=!0;void 0!=a.b.args.deviceHasDisplay&&(c=a.b.args.deviceHasDisplay);if(2.2==Nf)d=!0;else{a:{var e=c;c=r("yt.player.utils.videoElement_");c||(c=document.createElement("video"),q("yt.player.utils.videoElement_",c,void 0));try{if(c.canPlayType)for(var e=e?Tf:Uf,f=0;f<e.length;f++)if(c.canPlayType(e[f])){d=null;break a}d="fmt.noneavailable"}catch(h){d="html5.missingapi"}}d=!d}d&&(d=Wh(a)||a.b.assets.js);
a.b.disable.html5=!d;d||(a.b.args.html5_unavailable="1")}c=!!a.b.disable.html5}b=c?Th(a)?"flash":"unsupported":"html5"}("flash"==b?a.oe:a.pe).call(a)}}
function Wh(a){var b=!0,c=Vh(a);c&&a.b&&(a=a.b,b=C(c,"version")==a.assets.js);return b&&!!r("yt.player.Application.create")}
g.pe=function(){if(!this.ia){var a=Wh(this);a&&"html5"==Xh(this)?(this.D="html5",this.u||this.La()):(Yh(this),this.D="html5",a&&this.K?(this.j.appendChild(this.K),this.La()):(this.b.loaded=!0,this.L=w(function(){var a=this.j,c=this.b.clone();r("yt.player.Application.create")(a,c);this.La()},this),this.ia=!0,a?this.L():(qc(this.b.assets.js,this.L),If(this.b.assets.css))))}};
g.oe=function(){var a=this.b.clone();if(!this.l){var b=Vh(this);b&&(this.l=document.createElement("span"),this.l.tabIndex=0,Wf(this.ka,this.l,"focus",this.kc),this.F=document.createElement("span"),this.F.tabIndex=0,Wf(this.ka,this.F,"focus",this.kc),b.parentNode&&b.parentNode.insertBefore(this.l,b),b.parentNode&&b.parentNode.insertBefore(this.F,b.nextSibling))}a.attrs.width=a.attrs.width||"100%";a.attrs.height=a.attrs.height||"100%";if("flash"==Xh(this))this.D="flash",this.u||Ef(a,!1,w(this.La,this));
else{Yh(this);this.D="flash";this.b.loaded=!0;b=this.j;b=v(b)?ke(b):b;a=We(a);if(window!=window.top){var c=null;document.referrer&&(c=document.referrer.substring(0,128));a.args.framer=c}c=zf.getInstance();Af(c,a.minVersion)?(c=Ff(a,c),Df(b,c,a)):Hf(b,a,c);this.La()}};
g.kc=function(){Vh(this).focus()};
function Vh(a){var b=ke(a.g);!b&&a.o&&a.o.querySelector&&(b=a.o.querySelector("#"+a.g));return b}
g.La=function(){if(!this.isDisposed()){var a=Vh(this),b=!1;try{a&&a.getApiInterface&&a.getApiInterface()&&(b=!0)}catch(f){}if(b)if(this.ia=!1,a.isNotServable&&a.isNotServable(this.b.args.video_id))Uh(this);else{Nh(this);this.u=!0;a=Vh(this);a.addEventListener&&(this.X=Zh(this,a,"addEventListener"));a.removeEventListener&&(this.qa=Zh(this,a,"removeEventListener"));for(var b=a.getApiInterface(),b=b.concat(a.getInternalApiInterface()),c=0;c<b.length;c++){var d=b[c];this.f[d]||(this.f[d]=Zh(this,a,d))}for(var e in this.i)this.X(e,
this.i[e]);Rh(this);this.Ga&&this.Ga(this.f);this.ca.w("onReady",this.f)}else this.Xb=H(w(this.La,this),50)}};
function Zh(a,b,c){var d=b[c];return function(){try{return a.yb=null,d.apply(b,arguments)}catch(e){"Bad NPObject as private data!"!=e.message&&"sendAbandonmentPing"!=c&&(e.message+=" ("+c+")",a.yb=e,bc(e,"WARNING"))}}}
function Nh(a){a.u=!1;if(a.qa)for(var b in a.i)a.qa(b,a.i[b]);for(var c in a.la)I(parseInt(c,10));a.la={};a.X=null;a.qa=null;for(var d in a.f)a.f[d]=null;a.f.addEventListener=w(a.na,a);a.f.removeEventListener=w(a.be,a);a.f.destroy=w(a.dispose,a);a.f.getLastError=w(a.gd,a);a.f.getPlayerType=w(a.hd,a);a.f.getCurrentVideoConfig=w(a.fd,a);a.f.loadNewVideoConfig=w(a.Tb,a);a.f.isReady=w(a.Ae,a)}
g.Ae=function(){return this.u};
g.na=function(a,b){if(!this.isDisposed()){var c=Sh(this,b);if(c){if(!A(this.Uc,a)&&!this.i[a]){var d=$h(this,a);this.X&&this.X(a,d)}this.ca.subscribe(a,c);"onReady"==a&&this.u&&H(ma(c,this.f),0)}}};
g.be=function(a,b){if(!this.isDisposed()){var c=Sh(this,b);c&&this.ca.unsubscribe(a,c)}};
function Sh(a,b){var c=b;if("string"==typeof b){if(a.ab[b])return a.ab[b];c=function(){var a=r(b);a&&a.apply(l,arguments)};
a.ab[b]=c}return c?c:null}
function $h(a,b){var c="ytPlayer"+b+a.ba;a.i[b]=c;l[c]=function(c){var e=H(function(){if(!a.isDisposed()){a.ca.w(b,c);var f=a.la,h=String(e);h in f&&delete f[h]}},0);
gb(a.la,String(e))};
return c}
g.Zc=function(a){a=a?re:qe;for(var b=a(document.activeElement);b&&(1!=b.nodeType||b==this.l||b==this.F||(b.focus(),b!=document.activeElement));)b=a(b)};
g.Yb=function(a){J("a11y-announce",a)};
g.Ed=function(a){Uh(this,a)};
g.Fd=function(a){J("WATCH_LATER_VIDEO_ADDED",a)};
g.Gd=function(a){J("WATCH_LATER_VIDEO_REMOVED",a)};
g.Bd=function(){this.wb||(of?(this.vb=ne(document),Wf(this.H,window,"scroll",this.Wd),Wf(this.H,this.j,"touchmove",this.Qd)):(Wf(this.H,this.j,"mousewheel",this.nc),Wf(this.H,this.j,"wheel",this.nc)),this.wb=!0)};
g.Cd=function(){Xf(this.H);this.wb=!1};
g.nc=function(a){a=a||window.event;a.returnValue=!1;a.preventDefault&&a.preventDefault()};
g.Wd=function(){window.scrollTo(this.vb.x,this.vb.y)};
g.Qd=function(a){a.preventDefault()};
g.hd=function(){return this.D||Xh(this)};
g.gd=function(){return this.yb};
function Xh(a){return(a=Vh(a))?"div"==a.tagName.toLowerCase()?"html5":"flash":null}
function Yh(a){zh("dcp");a.cancel();Nh(a);a.D=null;a.b&&(a.b.loaded=!1);var b=Vh(a);"html5"==Xh(a)?a.K=b:b&&b.destroy&&b.destroy();pe(a.j);Xf(a.ka);a.l=null;a.F=null}
g.cancel=function(){this.L&&xc(this.b.assets.js,this.L);I(this.Xb);this.ia=!1};
g.A=function(){Yh(this);if(this.K&&this.b)try{this.K.destroy()}catch(b){bc(b)}this.ab=null;for(var a in this.i)l[this.i[a]]=null;this.xb=this.b=this.f=null;delete this.j;delete this.o;Mh.B.A.call(this)};var ai={},bi="player_uid_"+(1E9*Math.random()>>>0);function ci(a,b){a=v(a)?ke(a):a;b=We(b);var c=bi+"_"+ha(a),d=ai[c];if(d)return d.Tb(b),d.f;d=new Mh(a,c);ai[c]=d;J("player-added",d.f);Ub(d,ma(di,d));H(function(){d.Tb(b)},0);
return d.f}
function di(a){ai[a.ba]=null}
function ei(a){a=ke(a);if(!a)return null;var b=bi+"_"+ha(a),c=ai[b];c||(c=new Mh(a,b),ai[b]=c);return c.f}
;var fi=r("yt.abuse.botguardInitialized")||Ac;q("yt.abuse.botguardInitialized",fi,void 0);var gi=r("yt.abuse.invokeBotguard")||Bc;q("yt.abuse.invokeBotguard",gi,void 0);var hi=r("yt.abuse.dclkstatus.checkDclkStatus")||Zd;q("yt.abuse.dclkstatus.checkDclkStatus",hi,void 0);var ii=r("yt.player.exports.navigate")||Re;q("yt.player.exports.navigate",ii,void 0);var ji=r("yt.player.embed")||ci;q("yt.player.embed",ji,void 0);var ki=r("yt.player.getPlayerByElement")||ei;q("yt.player.getPlayerByElement",ki,void 0);
var li=r("yt.util.activity.init")||Ie;q("yt.util.activity.init",li,void 0);var mi=r("yt.util.activity.getTimeSinceActive")||Ke;q("yt.util.activity.getTimeSinceActive",mi,void 0);var ni=r("yt.util.activity.setTimestamp")||Je;q("yt.util.activity.setTimestamp",ni,void 0);function oi(a){O.call(this,1,arguments);this.b=a}
y(oi,O);function pi(a){O.call(this,1,arguments);this.b=a}
y(pi,O);function qi(a,b){O.call(this,1,arguments);this.b=a;this.isEnabled=b}
y(qi,O);function ri(a,b,c,d,e){O.call(this,2,arguments);this.f=a;this.b=b;this.i=c||null;this.g=d||null;this.source=e||null}
y(ri,O);function si(a,b,c){O.call(this,1,arguments);this.b=a;this.subscriptionId=b}
y(si,O);function ti(a,b,c,d,e,f,h){O.call(this,1,arguments);this.f=a;this.subscriptionId=b;this.b=c;this.j=d||null;this.i=e||null;this.g=f||null;this.source=h||null}
y(ti,O);
var ui=new P("subscription-batch-subscribe",oi),vi=new P("subscription-batch-unsubscribe",oi),wi=new P("subscription-pref-email",qi),xi=new P("subscription-subscribe",ri),yi=new P("subscription-subscribe-loading",pi),zi=new P("subscription-subscribe-loaded",pi),Ai=new P("subscription-subscribe-success",si),Bi=new P("subscription-subscribe-external",ri),Ci=new P("subscription-unsubscribe",ti),Di=new P("subscription-unsubscirbe-loading",pi),Ei=new P("subscription-unsubscribe-loaded",pi),Fi=new P("subscription-unsubscribe-success",
pi),Gi=new P("subscription-external-unsubscribe",ti),Hi=new P("subscription-enable-ypc",pi),Ii=new P("subscription-disable-ypc",pi);function Ji(a,b){var c=document.location.protocol+"//"+document.domain+"/post_login";b&&(c=Dd(c,"mode",b));c=Dd("/signin?context=popup","next",c);c=Dd(c,"feature","sub_button");if(c=window.open(c,"loginPopup","width=375,height=440,resizable=yes,scrollbars=yes",!0)){var d=kc("LOGGED_IN",function(b){mc(G("LOGGED_IN_PUBSUB_KEY",void 0));Zb("LOGGED_IN",!0);a(b)});
Zb("LOGGED_IN_PUBSUB_KEY",d);c.moveTo((screen.width-375)/2,(screen.height-440)/2)}}
q("yt.pubsub.publish",J,void 0);function Ki(){var a=G("PLAYER_CONFIG");return a&&a.args&&void 0!==a.args.authuser?!0:!(!G("SESSION_INDEX")&&!G("LOGGED_IN"))}
;function Li(){var a=Ce();return a?a:null}
;var Mi={},Ni="ontouchstart"in document;function Oi(a,b,c){var d;switch(a){case "mouseover":case "mouseout":d=3;break;case "mouseenter":case "mouseleave":d=9}return ze(c,function(a){return ae(a,b)},!0,d)}
function Pi(a){var b="mouseover"==a.type&&"mouseenter"in Mi||"mouseout"==a.type&&"mouseleave"in Mi,c=a.type in Mi||b;if("HTML"!=a.target.tagName&&c){if(b){var b="mouseover"==a.type?"mouseenter":"mouseleave",c=Mi[b],d;for(d in c.aa){var e=Oi(b,d,a.target);e&&!ze(a.relatedTarget,function(a){return a==e},!0)&&c.w(d,e,b,a)}}if(b=Mi[a.type])for(d in b.aa)(e=Oi(a.type,d,a.target))&&b.w(d,e,a.type,a)}}
M(document,"blur",Pi,!0);M(document,"change",Pi,!0);M(document,"click",Pi);M(document,"focus",Pi,!0);M(document,"mouseover",Pi);M(document,"mouseout",Pi);M(document,"mousedown",Pi);M(document,"keydown",Pi);M(document,"keyup",Pi);M(document,"keypress",Pi);M(document,"cut",Pi);M(document,"paste",Pi);Ni&&(M(document,"touchstart",Pi),M(document,"touchend",Pi),M(document,"touchcancel",Pi));function Qi(a){this.j=a;this.g={};this.mb=[];this.i=[]}
function R(a,b){return"yt-uix"+(a.j?"-"+a.j:"")+(b?"-"+b:"")}
Qi.prototype.unregister=function(){mc(this.mb);this.mb.length=0;ph(this.i);this.i.length=0};
Qi.prototype.init=t;Qi.prototype.dispose=t;function Ri(a,b,c){a.i.push(oh(b,c,a))}
function Si(a,b,c){var d=R(a,void 0),e=w(c,a);b in Mi||(Mi[b]=new F);Mi[b].subscribe(d,e);a.g[c]=e}
function Ti(a,b,c){if(b in Mi){var d=Mi[b];d.unsubscribe(R(a,void 0),a.g[c]);0>=d.O()&&(d.dispose(),delete Mi[b])}delete a.g[c]}
function Ui(a,b){Cb(a,"tooltip-text",b)}
;function Vi(){Qi.call(this,"tooltip");this.b=0;this.f={}}
y(Vi,Qi);ba(Vi);g=Vi.prototype;g.register=function(){Si(this,"mouseover",this.jb);Si(this,"mouseout",this.Ca);Si(this,"focus",this.ec);Si(this,"blur",this.$b);Si(this,"click",this.Ca);Si(this,"touchstart",this.Ec);Si(this,"touchend",this.pb);Si(this,"touchcancel",this.pb)};
g.unregister=function(){Ti(this,"mouseover",this.jb);Ti(this,"mouseout",this.Ca);Ti(this,"focus",this.ec);Ti(this,"blur",this.$b);Ti(this,"click",this.Ca);Ti(this,"touchstart",this.Ec);Ti(this,"touchend",this.pb);Ti(this,"touchcancel",this.pb);this.dispose();Vi.B.unregister.call(this)};
g.dispose=function(){for(var a in this.f)this.Ca(this.f[a]);this.f={}};
g.jb=function(a){if(!(this.b&&1E3>x()-this.b)){var b=parseInt(C(a,"tooltip-hide-timer"),10);b&&(Eb(a,"tooltip-hide-timer"),I(b));var b=w(function(){Wi(this,a);Eb(a,"tooltip-show-timer")},this),c=parseInt(C(a,"tooltip-show-delay"),10)||0,b=H(b,c);
Cb(a,"tooltip-show-timer",b.toString());a.title&&(Ui(a,Xi(a)),a.title="");b=ha(a).toString();this.f[b]=a}};
g.Ca=function(a){var b=parseInt(C(a,"tooltip-show-timer"),10);b&&(I(b),Eb(a,"tooltip-show-timer"));b=w(function(){if(a){var b=ke(Yi(this,a));b&&(Zi(b),b&&b.parentNode&&b.parentNode.removeChild(b),Eb(a,"content-id"));(b=ke(Yi(this,a,"arialabel")))&&b.parentNode&&b.parentNode.removeChild(b)}Eb(a,"tooltip-hide-timer")},this);
b=H(b,50);Cb(a,"tooltip-hide-timer",b.toString());if(b=C(a,"tooltip-text"))a.title=b;b=ha(a).toString();delete this.f[b]};
g.ec=function(a){this.b=0;this.jb(a)};
g.$b=function(a){this.b=0;this.Ca(a)};
g.Ec=function(a,b,c){c.changedTouches&&(this.b=0,a=Oi(b,R(this),c.changedTouches[0].target),this.jb(a))};
g.pb=function(a,b,c){c.changedTouches&&(this.b=x(),a=Oi(b,R(this),c.changedTouches[0].target),this.Ca(a))};
function $i(a,b){Ui(a,b);var c=C(a,"content-id");(c=ke(c))&&se(c,b)}
function Xi(a){return C(a,"tooltip-text")||a.title}
function Wi(a,b){if(b){var c=Xi(b);if(c){var d=ke(Yi(a,b));if(!d){d=document.createElement("div");d.id=Yi(a,b);d.className=R(a,"tip");var e=document.createElement("div");e.className=R(a,"tip-body");var f=document.createElement("div");f.className=R(a,"tip-arrow");var h=document.createElement("div");h.setAttribute("aria-hidden","true");h.className=R(a,"tip-content");var k=aj(a,b),m=Yi(a,b,"content");h.id=m;Cb(b,"content-id",m);e.appendChild(h);k&&d.appendChild(k);d.appendChild(e);d.appendChild(f);var m=
ve(b),n=Yi(a,b,"arialabel"),f=document.createElement("div");be(f,R(a,"arialabel"));f.id=n;"rtl"==document.body.getAttribute("dir")?se(f,c+" "+m):se(f,m+" "+c);b.setAttribute("aria-labelledby",n);m=Li()||document.body;m.appendChild(f);m.appendChild(d);$i(b,c);(c=parseInt(C(b,"tooltip-max-width"),10))&&e.offsetWidth>c&&(e.style.width=c+"px",be(h,R(a,"normal-wrap")));h=ae(b,R(a,"reverse"));bj(a,b,d,e,k,h)||bj(a,b,d,e,k,!h);var Z=R(a,"tip-visible");H(function(){be(d,Z)},0)}}}}
function bj(a,b,c,d,e,f){de(c,R(a,"tip-reverse"),f);var h=0;f&&(h=1);a=df(b);f=new ee((a.width-10)/2,f?a.height:0);var k=je(b),m=new ee(0,0),n;n=k?je(k):document;n=!K||kd(9)||oe(he(n).b)?n.documentElement:n.body;b!=n&&(n=bf(b),k=ne(he(k).b),m.x=n.left+k.x,m.y=n.top+k.y);f=new ee(m.x+f.x,m.y+f.y);f=f.clone();m=(h&8&&"rtl"==af(c,"direction")?h^4:h)&-9;h=df(c);k=h.clone();n=f.clone();k=k.clone();0!=m&&(m&4?n.x-=k.width+0:m&2&&(n.x-=k.width/2),m&1&&(n.y-=k.height+0));f=new Ye(0,0,0,0);f.left=n.x;f.top=
n.y;f.width=k.width;f.height=k.height;k=new ee(f.left,f.top);k instanceof ee?(m=k.x,k=k.y):(m=k,k=void 0);c.style.left=cf(m,!1);c.style.top=cf(k,!1);k=new fe(f.width,f.height);if(!(h==k||h&&k&&h.width==k.width&&h.height==k.height))if(h=k,f=je(c),m=oe(he(f).b),!K||jd("10")||m&&jd("8"))f=c.style,Zc?f.MozBoxSizing="border-box":$c?f.WebkitBoxSizing="border-box":f.boxSizing="border-box",f.width=Math.max(h.width,0)+"px",f.height=Math.max(h.height,0)+"px";else if(f=c.style,m){if(K){m=gf(c,"paddingLeft");
k=gf(c,"paddingRight");n=gf(c,"paddingTop");var Z=gf(c,"paddingBottom"),m=new Xe(n,k,Z,m)}else m=$e(c,"paddingLeft"),k=$e(c,"paddingRight"),n=$e(c,"paddingTop"),Z=$e(c,"paddingBottom"),m=new Xe(parseFloat(n),parseFloat(k),parseFloat(Z),parseFloat(m));if(K&&!kd(9)){k=jf(c,"borderLeft");n=jf(c,"borderRight");var Z=jf(c,"borderTop"),ua=jf(c,"borderBottom"),k=new Xe(Z,n,ua,k)}else k=$e(c,"borderLeftWidth"),n=$e(c,"borderRightWidth"),Z=$e(c,"borderTopWidth"),ua=$e(c,"borderBottomWidth"),k=new Xe(parseFloat(Z),
parseFloat(n),parseFloat(ua),parseFloat(k));f.pixelWidth=h.width-k.left-m.left-m.right-k.right;f.pixelHeight=h.height-k.top-m.top-m.bottom-k.bottom}else f.pixelWidth=h.width,f.pixelHeight=h.height;h=window.document;h=oe(h)?h.documentElement:h.body;f=new fe(h.clientWidth,h.clientHeight);1==c.nodeType?(c=bf(c),k=new ee(c.left,c.top)):(c=c.changedTouches?c.changedTouches[0]:c,k=new ee(c.clientX,c.clientY));c=df(d);n=Math.floor(c.width/2);h=!!(f.height<k.y+a.height);a=!!(k.y<a.height);m=!!(k.x<n);f=!!(f.width<
k.x+n);k=(c.width+3)/-2- -5;b=C(b,"force-tooltip-direction");if("left"==b||m)k=-5;else if("right"==b||f)k=20-c.width-3;b=Math.floor(k)+"px";d.style.left=b;e&&(e.style.left=b,e.style.height=c.height+"px",e.style.width=c.width+"px");return!(h||a)}
function Yi(a,b,c){a=R(a);var d=b.__yt_uid_key;d||(d=Ae(),b.__yt_uid_key=d);b=a+d;c&&(b+="-"+c);return b}
function aj(a,b){var c=null;bd&&ae(b,R(a,"masked"))&&((c=ke("yt-uix-tooltip-shared-mask"))?(c.parentNode.removeChild(c),xf(c)):(c=document.createElement("iframe"),c.src='javascript:""',c.id="yt-uix-tooltip-shared-mask",c.className=R(a,"tip-mask")));return c}
function Zi(a){var b=ke("yt-uix-tooltip-shared-mask"),c=b&&ze(b,function(b){return b==a},!1,2);
b&&c&&(b.parentNode.removeChild(b),yf(b),document.body.appendChild(b))}
;function cj(){Qi.call(this,"subscription-button")}
y(cj,Qi);ba(cj);cj.prototype.register=function(){Si(this,"click",this.Bb);Ri(this,yi,this.mc);Ri(this,zi,this.lc);Ri(this,Ai,this.Od);Ri(this,Di,this.mc);Ri(this,Ei,this.lc);Ri(this,Fi,this.Ud);Ri(this,Hi,this.Ad);Ri(this,Ii,this.zd)};
cj.prototype.unregister=function(){Ti(this,"click",this.Bb);cj.B.unregister.call(this)};
var ye={Ub:"hover-enabled",Mc:"yt-uix-button-subscribe",Nc:"yt-uix-button-subscribed",Ce:"ypc-enabled",Oc:"yt-uix-button-subscription-container",Pc:"yt-subscription-button-disabled-mask-container"},dj={De:"channel-external-id",Qc:"subscriber-count-show-when-subscribed",Rc:"subscriber-count-tooltip",Sc:"subscriber-count-title",Ee:"href",Vb:"is-subscribed",Ge:"parent-url",Ie:"clicktracking",Tc:"style-type",Wb:"subscription-id",Le:"target",Vc:"ypc-enabled"};g=cj.prototype;
g.Bb=function(a){var b=C(a,"href"),c=Ki();if(b)a=C(a,"target")||"_self",window.open(b,a);else if(c){var b=C(a,"channel-external-id"),c=C(a,"clicktracking"),d;if(C(a,"ypc-enabled")){d=C(a,"ypc-item-type");var e=C(a,"ypc-item-id");d={itemType:d,itemId:e,subscriptionElement:a}}else d=null;e=C(a,"parent-url");if(C(a,"is-subscribed")){var f=C(a,"subscription-id");Q(Ci,new ti(b,f,d,a,c,e))}else Q(xi,new ri(b,d,c,e))}else ej(this,a)};
g.mc=function(a){this.Ha(a.b,this.Bc,!0)};
g.lc=function(a){this.Ha(a.b,this.Bc,!1)};
g.Od=function(a){this.Ha(a.b,this.Cc,!0,a.subscriptionId)};
g.Ud=function(a){this.Ha(a.b,this.Cc,!1)};
g.Ad=function(a){this.Ha(a.b,this.bd)};
g.zd=function(a){this.Ha(a.b,this.ad)};
g.Cc=function(a,b,c){b?(Cb(a,dj.Vb,"true"),c&&Cb(a,dj.Wb,c)):(Eb(a,dj.Vb),Eb(a,dj.Wb));fj(a)};
g.Bc=function(a,b){var c;c=xe(a);de(c,ye.Pc,b);a.setAttribute("aria-busy",b?"true":"false");a.disabled=b};
function fj(a){var b=C(a,dj.Tc),c=!!C(a,"is-subscribed"),b="-"+b,d=ye.Nc+b;de(a,ye.Mc+b,!c);de(a,d,c);C(a,dj.Rc)&&!C(a,dj.Qc)&&(b=R(Vi.getInstance()),de(a,b,!c),a.title=c?"":C(a,dj.Sc));c?H(function(){be(a,ye.Ub)},1E3):ce(a,ye.Ub)}
g.bd=function(a){var b=!!C(a,"ypc-item-type"),c=!!C(a,"ypc-item-id");!C(a,"ypc-enabled")&&b&&c&&(be(a,"ypc-enabled"),Cb(a,dj.Vc,"true"))};
g.ad=function(a){C(a,"ypc-enabled")&&(ce(a,"ypc-enabled"),Eb(a,"ypc-enabled"))};
function gj(a,b){var c=le(R(a));return Ia(c,function(a){return b==C(a,"channel-external-id")},a)}
g.Xc=function(a,b,c){var d=Va(arguments,2);z(a,function(a){b.apply(this,Ra(a,d))},this)};
g.Ha=function(a,b,c){var d=gj(this,a),d=Ra([d],Va(arguments,1));this.Xc.apply(this,d)};
function ej(a,b){var c=w(function(a){a.discoverable_subscriptions&&Zb("SUBSCRIBE_EMBED_DISCOVERABLE_SUBSCRIPTIONS",a.discoverable_subscriptions);this.Bb(b)},a);
Ji(c,"subscribe")}
;var hj=window.yt&&window.yt.uix&&window.yt.uix.widgets_||{};q("yt.uix.widgets_",hj,void 0);function ij(a,b){this.source=null;this.j=a||null;this.origin="*";this.u=window.document.location.protocol+"//"+window.document.location.hostname;this.o=b;this.g=this.b=this.f=this.channel=this.i=null;M(window,"message",w(this.l,this))}
ij.prototype.l=function(a){var b=this.o||G("POST_MESSAGE_ORIGIN",void 0)||this.u;if("*"!=b&&a.origin!=b)window.console&&window.console.warn("Untrusted origin: "+a.origin);else if(!this.j||a.source==this.j)if(this.source=a.source,this.origin="null"==a.origin?this.origin:a.origin,a=a.data,v(a)){try{a=nd(a)}catch(c){return}this.i=a.id;switch(a.event){case "listening":this.b&&(this.b(),this.b=null);break;case "command":this.f&&(this.g&&!A(this.g,a.func)||this.f(a.func,a.args))}}};
ij.prototype.sendMessage=function(a){this.source&&(a.id=this.i,this.channel&&(a.channel=this.channel),a=L(a),this.source.postMessage(a,this.origin))};function jj(){}
;function kj(){}
y(kj,jj);kj.prototype.O=function(){var a=0;Gc(this.ma(!0),function(){a++});
return a};
kj.prototype.clear=function(){var a=Hc(this.ma(!0)),b=this;z(a,function(a){b.remove(a)})};function lj(a){this.b=a}
y(lj,kj);g=lj.prototype;g.isAvailable=function(){if(!this.b)return!1;try{return this.b.setItem("__sak","1"),this.b.removeItem("__sak"),!0}catch(a){return!1}};
g.set=function(a,b){try{this.b.setItem(a,b)}catch(c){if(0==this.b.length)throw"Storage mechanism: Storage disabled";throw"Storage mechanism: Quota exceeded";}};
g.get=function(a){a=this.b.getItem(a);if(!v(a)&&null!==a)throw"Storage mechanism: Invalid value was encountered";return a};
g.remove=function(a){this.b.removeItem(a)};
g.O=function(){return this.b.length};
g.ma=function(a){var b=0,c=this.b,d=new Ec;d.next=function(){if(b>=c.length)throw Dc;var d=c.key(b++);if(a)return d;d=c.getItem(d);if(!v(d))throw"Storage mechanism: Invalid value was encountered";return d};
return d};
g.clear=function(){this.b.clear()};
g.key=function(a){return this.b.key(a)};function mj(){var a=null;try{a=window.localStorage||null}catch(b){}this.b=a}
y(mj,lj);function nj(){var a=null;try{a=window.sessionStorage||null}catch(b){}this.b=a}
y(nj,lj);function oj(a){this.b=a}
oj.prototype.set=function(a,b){p(b)?this.b.set(a,L(b)):this.b.remove(a)};
oj.prototype.get=function(a){var b;try{b=this.b.get(a)}catch(c){return}if(null!==b)try{return nd(b)}catch(c){throw"Storage: Invalid value was encountered";}};
oj.prototype.remove=function(a){this.b.remove(a)};function pj(a){this.b=a}
y(pj,oj);function qj(a){this.data=a}
function rj(a){return!p(a)||a instanceof qj?a:new qj(a)}
pj.prototype.set=function(a,b){pj.B.set.call(this,a,rj(b))};
pj.prototype.f=function(a){a=pj.B.get.call(this,a);if(!p(a)||a instanceof Object)return a;throw"Storage: Invalid value was encountered";};
pj.prototype.get=function(a){if(a=this.f(a)){if(a=a.data,!p(a))throw"Storage: Invalid value was encountered";}else a=void 0;return a};function sj(a){this.b=a}
y(sj,pj);function tj(a){var b=a.creation;a=a.expiration;return!!a&&a<x()||!!b&&b>x()}
sj.prototype.set=function(a,b,c){if(b=rj(b)){if(c){if(c<x()){sj.prototype.remove.call(this,a);return}b.expiration=c}b.creation=x()}sj.B.set.call(this,a,b)};
sj.prototype.f=function(a,b){var c=sj.B.f.call(this,a);if(c)if(!b&&tj(c))sj.prototype.remove.call(this,a);else return c};function uj(a){this.b=a}
y(uj,sj);function vj(a,b){var c=[];Gc(b,function(a){var b;try{b=uj.prototype.f.call(this,a,!0)}catch(f){if("Storage: Invalid value was encountered"==f)return;throw f;}p(b)?tj(b)&&c.push(a):c.push(a)},a);
return c}
function wj(a,b){var c=vj(a,b);z(c,function(a){uj.prototype.remove.call(this,a)},a)}
function xj(){var a=yj;wj(a,a.b.ma(!0))}
;function S(a,b,c){var d=c&&0<c?c:0;c=d?x()+1E3*d:0;if((d=d?yj:zj)&&window.JSON){v(b)||(b=JSON.stringify(b,void 0));try{d.set(a,b,c)}catch(e){d.remove(a)}}}
function T(a){if(!zj&&!yj||!window.JSON)return null;var b;try{b=zj.get(a)}catch(c){}if(!v(b))try{b=yj.get(a)}catch(c){}if(!v(b))return null;try{b=JSON.parse(b,void 0)}catch(c){}return b}
function Aj(a){zj&&zj.remove(a);yj&&yj.remove(a)}
var yj,Bj=new mj;yj=Bj.isAvailable()?new uj(Bj):null;var zj,Cj=new nj;zj=Cj.isAvailable()?new uj(Cj):null;function Dj(a){return(0==a.search("cue")||0==a.search("load"))&&"loadModule"!=a}
function Ej(a,b,c){v(a)&&(a={mediaContentUrl:a,startSeconds:b,suggestedQuality:c});b=a;c=/\/([ve]|embed)\/([^#?]+)/.exec(a.mediaContentUrl);b.videoId=c&&c[2]?c[2]:null;return Fj(a)}
function Fj(a,b,c){if(ga(a)){b="endSeconds startSeconds mediaContentUrl suggestedQuality videoId two_stage_token".split(" ");c={};for(var d=0;d<b.length;d++){var e=b[d];a[e]&&(c[e]=a[e])}return c}return{videoId:a,startSeconds:b,suggestedQuality:c}}
function Gj(a,b,c,d){if(ga(a)&&!u(a)){b="playlist list listType index startSeconds suggestedQuality".split(" ");c={};for(d=0;d<b.length;d++){var e=b[d];a[e]&&(c[e]=a[e])}return c}c={index:b,startSeconds:c,suggestedQuality:d};v(a)&&16==a.length?c.list="PL"+a:c.playlist=a;return c}
function Hj(a){var b=a.video_id||a.videoId;if(v(b)){var c=T("yt-player-two-stage-token")||{},d=T("yt-player-two-stage-token")||{};p(void 0)?d[b]=void 0:delete d[b];S("yt-player-two-stage-token",d,300);(b=c[b])&&(a.two_stage_token=b)}}
;function Ij(){var a=window.navigator.userAgent.match(/Chrome\/([0-9]+)/);return a?50<=parseInt(a[1],10):!1}
var Jj=document.currentScript&&-1!=document.currentScript.src.indexOf("?loadGamesSDK")?"/cast_game_sender.js":"/cast_sender.js",Kj=["boadgeojelhgndaghljhdicfkmllpafd","dliochdbjfkdbacpmhlcpmleaejidimm","enhhojjnijigcajfphajepfemndkmdlo","fmfcbgogabcbclcofgocippekhfcmgfj"],Lj=["pkedcjkdefgpdelpbcmbmeomcjbeemfm","fjhoaacokmgbjemoflkofnenfaiekifl"],Mj=Ij()?Lj.concat(Kj):Kj.concat(Lj);function Nj(a,b){var c=new XMLHttpRequest;c.onreadystatechange=function(){4==c.readyState&&200==c.status&&b(!0)};
c.onerror=function(){b(!1)};
try{c.open("GET",a,!0),c.send()}catch(d){b(!1)}}
function Oj(a){if(a>=Mj.length)Pj();else{var b=Mj[a],c="chrome-extension://"+b+Jj;0<=Kj.indexOf(b)?Nj(c,function(d){d?(window.chrome.cast=window.chrome.cast||{},window.chrome.cast.extensionId=b,Qj(c,Pj)):Oj(a+1)}):Qj(c,function(){Oj(a+1)})}}
function Qj(a,b){var c=document.createElement("script");c.onerror=b;c.src=a;(document.head||document.documentElement).appendChild(c)}
function Pj(){var a=window.__onGCastApiAvailable;a&&"function"==typeof a&&a(!1,"No cast extension found")}
function Rj(){if(0<=window.navigator.userAgent.indexOf("CriOS")){var a=window.__gCrWeb&&window.__gCrWeb.message&&window.__gCrWeb.message.invokeOnHost;if(a){a({command:"cast.sender.init"});return}}window.chrome?(a=window.navigator.userAgent,0<=a.indexOf("Android")&&0<=a.indexOf("Chrome/")&&window.navigator.presentation?(a=Ij()?"50":"",Qj("//www.gstatic.com/eureka/clank"+a+Jj,Pj)):Oj(0)):Pj()}
;var Sj=x(),Tj=null,Uj=Array(50),Vj=-1,Wj=!1;function Xj(){var a=Yj;Zj();Tj.push(a);ak(Tj)}
function bk(a,b){Zj();var c=Tj,d=ck(a,String(b));0==c.length?dk(d):(ak(c),z(c,function(a){a(d)}))}
function Zj(){Tj||(Tj=r("yt.mdx.remote.debug.handlers_")||[],q("yt.mdx.remote.debug.handlers_",Tj,void 0))}
function dk(a){var b=(Vj+1)%50;Vj=b;Uj[b]=a;Wj||(Wj=49==b)}
function ak(a){var b=Uj;if(b[0]){var c=Vj,d=Wj?c:-1;do{var d=(d+1)%50,e=b[d];z(a,function(a){a(e)})}while(d!=c);
Uj=Array(50);Vj=-1;Wj=!1}}
function ck(a,b){var c=(x()-Sj)/1E3;c.toFixed&&(c=c.toFixed(3));var d=[];d.push("[",c+"s","] ");d.push("[","yt.mdx.remote","] ");d.push(a+": "+b,"\n");return d.join("")}
;function ek(a){a=a||{};this.name=a.name||"";this.id=a.id||a.screenId||"";this.token=a.token||a.loungeToken||"";this.uuid=a.uuid||a.dialId||""}
function fk(a,b){return!!b&&(a.id==b||a.uuid==b)}
function gk(a){return{name:a.name,screenId:a.id,loungeToken:a.token,dialId:a.uuid}}
function hk(a){return new ek(a)}
function ik(a){return u(a)?Ja(a,hk):[]}
function jk(a){return a?'{name:"'+a.name+'",id:'+a.id.substr(0,6)+"..,token:"+(a.token?".."+a.token.slice(-6):"-")+",uuid:"+(a.uuid?".."+a.uuid.slice(-6):"-")+"}":"null"}
function kk(a){return u(a)?"["+Ja(a,jk).join(",")+"]":"null"}
;var lk={Be:"atp",Ke:"ska",He:"que",Fe:"mus",Je:"sus"};function mk(a){this.i=this.g="";this.b="/api/lounge";this.f=!0;a=a||document.location.href;var b=Number(a.match(vd)[4]||null)||null||"";b&&(this.i=":"+b);this.g=wd(a)||"";a=lb;0<=a.search("MSIE")&&(a=a.match(/MSIE ([\d.]+)/)[1],0>Ea(a,"10.0")&&(this.f=!1))}
function nk(a,b,c,d){var e=a.b;if(p(d)?d:a.f)e="https://"+a.g+a.i+a.b;return Ed(e+b,c||{})}
function ok(a,b,c,d,e){a={format:"JSON",method:"POST",context:a,timeout:5E3,withCredentials:!1,$:ma(a.o,d,!0),onError:ma(a.j,e),Da:ma(a.l,e)};c&&(a.S=c,a.headers={"Content-Type":"application/x-www-form-urlencoded"});return Od(b,a)}
mk.prototype.o=function(a,b,c,d){b?a(d):a({text:c.responseText})};
mk.prototype.j=function(a,b){a(Error("Request error: "+b.status))};
mk.prototype.l=function(a){a(Error("request timed out"))};function pk(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(a){var b=16*Math.random()|0;return("x"==a?b:b&3|8).toString(16)})}
function qk(a,b){return Ma(a,function(a){return a.key==b})}
function rk(a){return Ja(a,function(a){return{key:a.id,name:a.name}})}
function sk(a,b){return Ma(a,function(a){return a||b?!a!=!b?!1:a.id==b.id:!0})}
function tk(a,b){return Ma(a,function(a){return fk(a,b)})}
;function U(){D.call(this);this.o=new F;Ub(this,ma(E,this.o))}
y(U,D);U.prototype.subscribe=function(a,b,c){return this.isDisposed()?0:this.o.subscribe(a,b,c)};
U.prototype.unsubscribe=function(a,b,c){return this.isDisposed()?!1:this.o.unsubscribe(a,b,c)};
U.prototype.ha=function(a){return this.isDisposed()?!1:this.o.ha(a)};
U.prototype.w=function(a,b){return this.isDisposed()?!1:this.o.w.apply(this.o,arguments)};function uk(a){U.call(this);this.l=a;this.screens=[]}
y(uk,U);uk.prototype.U=function(){return this.screens};
uk.prototype.contains=function(a){return!!sk(this.screens,a)};
uk.prototype.get=function(a){return a?tk(this.screens,a):null};
function vk(a,b){var c=a.get(b.uuid)||a.get(b.id);if(c){var d=c.name;c.id=b.id||c.id;c.name=b.name;c.token=b.token;c.uuid=b.uuid||c.uuid;return c.name!=d}a.screens.push(b);return!0}
function wk(a,b){var c=a.screens.length!=b.length;a.screens=Ia(a.screens,function(a){return!!sk(b,a)});
for(var d=0,e=b.length;d<e;d++)c=vk(a,b[d])||c;return c}
function xk(a,b){var c=a.screens.length;a.screens=Ia(a.screens,function(a){return!(a||b?!a!=!b?0:a.id==b.id:1)});
return a.screens.length<c}
uk.prototype.info=function(a){bk(this.l,a)};function yk(a,b,c,d){U.call(this);this.u=a;this.l=b;this.i=c;this.j=d;this.g=0;this.b=null;this.f=NaN}
y(yk,U);var zk=[2E3,2E3,1E3,1E3,1E3,2E3,2E3,5E3,5E3,1E4];g=yk.prototype;g.start=function(){!this.b&&isNaN(this.f)&&this.xc()};
g.stop=function(){this.b&&(this.b.abort(),this.b=null);isNaN(this.f)||(I(this.f),this.f=NaN)};
g.A=function(){this.stop();yk.B.A.call(this)};
g.xc=function(){this.f=NaN;this.b=Od(nk(this.u,"/pairing/get_screen"),{method:"POST",S:{pairing_code:this.l},timeout:5E3,$:w(this.se,this),onError:w(this.re,this),Da:w(this.te,this)})};
g.se=function(a,b){this.b=null;var c=b.screen||{};c.dialId=this.i;c.name=this.j;this.w("pairingComplete",new ek(c))};
g.re=function(a){this.b=null;a.status&&404==a.status?this.g>=zk.length?this.w("pairingFailed",Error("DIAL polling timed out")):(a=zk[this.g],this.f=H(w(this.xc,this),a),this.g++):this.w("pairingFailed",Error("Server error "+a.status))};
g.te=function(){this.b=null;this.w("pairingFailed",Error("Server not responding"))};function Ak(a){this.app=this.name=this.id="";this.type="REMOTE_CONTROL";this.avatar=this.username="";this.capabilities=new Sc;this.experiments=new Sc;this.theme="u";if(a){this.id=a.id||a.name;this.name=a.name;this.app=a.app;this.type=a.type||"REMOTE_CONTROL";this.username=a.user||"";this.avatar=a.userAvatarUri||"";this.theme=a.theme||"u";var b=a.capabilities||"";this.capabilities.clear();Tc(this.capabilities,Ia(b.split(","),ma($a,lk)));a=a.experiments||"";this.experiments.clear();Tc(this.experiments,
a.split(","))}}
Ak.prototype.equals=function(a){return a?this.id==a.id:!1};var Bk;function Ck(){var a=Dk(),b=Ek();A(a,b);if(Fk()){var c=a,d;d=0;for(var e=c.length,f;d<e;){var h=d+e>>1,k;k=Wa(b,c[h]);0<k?d=h+1:(e=h,f=!k)}d=f?d:~d;0>d&&Ua(c,-(d+1),0,b)}a=Gk(a);if(0==a.length)try{Pe.remove("remote_sid","/","youtube.com")}catch(m){}else try{Qe("remote_sid",a.join(","),-1)}catch(m){}}
function Dk(){var a=T("yt-remote-connected-devices")||[];a.sort(Wa);return a}
function Gk(a){if(0==a.length)return[];var b=a[0].indexOf("#"),c=-1==b?a[0]:a[0].substring(0,b);return Ja(a,function(a,b){return 0==b?a:a.substring(c.length)})}
function Hk(a){S("yt-remote-connected-devices",a,86400)}
function Ek(){if(Ik)return Ik;var a=T("yt-remote-device-id");a||(a=pk(),S("yt-remote-device-id",a,31536E3));for(var b=Dk(),c=1,d=a;A(b,d);)c++,d=a+"#"+c;return Ik=d}
function Jk(){return T("yt-remote-session-browser-channel")}
function Fk(){return T("yt-remote-session-screen-id")}
function Kk(a){5<a.length&&(a=a.slice(a.length-5));var b=Ja(Lk(),function(a){return a.loungeToken}),c=Ja(a,function(a){return a.loungeToken});
La(c,function(a){return!A(b,a)})&&Mk();
S("yt-remote-local-screens",a,31536E3)}
function Lk(){return T("yt-remote-local-screens")||[]}
function Mk(){S("yt-remote-lounge-token-expiration",!0,86400)}
function Nk(a,b){S("yt-remote-session-browser-channel",a);S("yt-remote-session-screen-id",b);var c=Dk(),d=Ek();A(c,d)||c.push(d);Hk(c);Ck()}
function Ok(a){a||(Aj("yt-remote-session-screen-id"),Aj("yt-remote-session-video-id"));Ck();a=Dk();Pa(a,Ek());Hk(a)}
function Pk(){if(!Bk){var a;a=new mj;(a=a.isAvailable()?a:null)&&(Bk=new oj(a))}return Bk?!!Bk.get("yt-remote-use-staging-server"):!1}
var Ik="";function Qk(a){uk.call(this,"LocalScreenService");this.f=a;this.b=NaN;Rk(this);this.info("Initializing with "+kk(this.screens))}
y(Qk,uk);g=Qk.prototype;g.start=function(){Rk(this)&&this.w("screenChange");!T("yt-remote-lounge-token-expiration")&&Sk(this);I(this.b);this.b=H(w(this.start,this),1E4)};
g.ub=function(a,b){Rk(this);vk(this,a);Tk(this,!1);this.w("screenChange");b(a);a.token||Sk(this)};
g.remove=function(a,b){var c=Rk(this);xk(this,a)&&(Tk(this,!1),c=!0);b(a);c&&this.w("screenChange")};
g.rb=function(a,b,c,d){var e=Rk(this),f=this.get(a.id);f?(f.name!=b&&(f.name=b,Tk(this,!1),e=!0),c(a)):d(Error("no such local screen."));e&&this.w("screenChange")};
g.A=function(){I(this.b);Qk.B.A.call(this)};
function Sk(a){if(a.screens.length){var b=Ja(a.screens,function(a){return a.id}),c=nk(a.f,"/pairing/get_lounge_token_batch");
ok(a.f,c,{screen_ids:b.join(",")},w(a.ld,a),w(a.kd,a))}}
g.ld=function(a){Rk(this);var b=this.screens.length;a=a&&a.screens||[];for(var c=0,d=a.length;c<d;++c){var e=a[c],f=this.get(e.screenId);f&&(f.token=e.loungeToken,--b)}Tk(this,!b);b&&bk(this.l,"Missed "+b+" lounge tokens.")};
g.kd=function(a){bk(this.l,"Requesting lounge tokens failed: "+a)};
function Rk(a){var b=ik(Lk()),b=Ia(b,function(a){return!a.uuid});
return wk(a,b)}
function Tk(a,b){Kk(Ja(a.screens,gk));b&&Mk()}
;function Uk(a,b){U.call(this);this.l=b;for(var c=T("yt-remote-online-screen-ids")||"",c=c?c.split(","):[],d={},e=this.l(),f=0,h=e.length;f<h;++f){var k=e[f].id;d[k]=A(c,k)}this.b=d;this.j=a;this.g=this.i=NaN;this.f=null;Vk("Initialized with "+L(this.b))}
y(Uk,U);g=Uk.prototype;g.start=function(){var a=parseInt(T("yt-remote-fast-check-period")||"0",10);(this.i=x()-144E5<a?0:a)?Wk(this):(this.i=x()+3E5,S("yt-remote-fast-check-period",this.i),this.Ob())};
g.isEmpty=function(){return fb(this.b)};
g.update=function(){Vk("Updating availability on schedule.");var a=this.l(),b=Ya(this.b,function(b,d){return b&&!!tk(a,d)},this);
Xk(this,b)};
function Yk(a,b,c){var d=nk(a.j,"/pairing/get_screen_availability");ok(a.j,d,{lounge_token:b.token},w(function(a){a=a.screens||[];for(var d=0,h=a.length;d<h;++d)if(a[d].loungeToken==b.token){c("online"==a[d].status);return}c(!1)},a),w(function(){c(!1)},a))}
g.A=function(){I(this.g);this.g=NaN;this.f&&(this.f.abort(),this.f=null);Uk.B.A.call(this)};
function Xk(a,b){var c;a:if(Za(b)!=Za(a.b))c=!1;else{c=cb(b);for(var d=0,e=c.length;d<e;++d)if(!a.b[c[d]]){c=!1;break a}c=!0}c||(Vk("Updated online screens: "+L(a.b)),a.b=b,a.w("screenChange"));Zk(a)}
function Wk(a){isNaN(a.g)||I(a.g);a.g=H(w(a.Ob,a),0<a.i&&a.i<x()?2E4:1E4)}
g.Ob=function(){I(this.g);this.g=NaN;this.f&&this.f.abort();var a=$k(this);if(Za(a)){var b=nk(this.j,"/pairing/get_screen_availability");this.f=ok(this.j,b,{lounge_token:cb(a).join(",")},w(this.Md,this,a),w(this.Ld,this))}else Xk(this,{}),Wk(this)};
g.Md=function(a,b){this.f=null;var c;a:{c=cb($k(this));var d=cb(a);if(da(c)&&da(d)&&c.length==d.length){for(var e=c.length,f=0;f<e;f++)if(c[f]!==d[f]){c=!1;break a}c=!0}else c=!1}if(c){c=b.screens||[];d={};e=0;for(f=c.length;e<f;++e)d[a[c[e].loungeToken]]="online"==c[e].status;Xk(this,d);Wk(this)}else this.I("Changing Screen set during request."),this.Ob()};
g.Ld=function(a){this.I("Screen availability failed: "+a);this.f=null;Wk(this)};
function Vk(a){bk("OnlineScreenService",a)}
g.I=function(a){bk("OnlineScreenService",a)};
function $k(a){var b={};z(a.l(),function(a){a.token?b[a.token]=a.id:this.I("Requesting availability of screen w/o lounge token.")});
return b}
function Zk(a){a=cb(Ya(a.b,function(a){return a}));
a.sort(Wa);a.length?S("yt-remote-online-screen-ids",a.join(","),60):Aj("yt-remote-online-screen-ids")}
;function V(a){uk.call(this,"ScreenService");this.j=a;this.b=this.f=null;this.g=[];this.i={};al(this)}
y(V,uk);g=V.prototype;g.start=function(){this.f.start();this.b.start();this.screens.length&&(this.w("screenChange"),this.b.isEmpty()||this.w("onlineScreenChange"))};
g.ub=function(a,b,c){this.f.ub(a,b,c)};
g.remove=function(a,b,c){this.f.remove(a,b,c);this.b.update()};
g.rb=function(a,b,c,d){this.f.contains(a)?this.f.rb(a,b,c,d):(a="Updating name of unknown screen: "+a.name,bk(this.l,a),d(Error(a)))};
g.U=function(a){return a?this.screens:Ra(this.screens,Ia(this.g,function(a){return!this.contains(a)},this))};
g.Gc=function(){return Ia(this.U(!0),function(a){return!!this.b.b[a.id]},this)};
function bl(a,b,c,d,e,f){a.info("getAutomaticScreenByIds "+c+" / "+b);c||(c=a.i[b]);var h=a.U();if(h=(c?tk(h,c):null)||tk(h,b)){h.uuid=b;var k=cl(a,h);Yk(a.b,k,function(a){e(a?k:null)})}else c?dl(a,c,w(function(a){var f=cl(this,new ek({name:d,
screenId:c,loungeToken:a,dialId:b||""}));Yk(this.b,f,function(a){e(a?f:null)})},a),f):e(null)}
g.Hc=function(a,b,c,d,e){this.info("getDialScreenByPairingCode "+a+" / "+b);var f=new yk(this.j,a,b,c);f.subscribe("pairingComplete",w(function(a){E(f);d(cl(this,a))},this));
f.subscribe("pairingFailed",function(a){E(f);e(a)});
f.start();return w(f.stop,f)};
function el(a,b){for(var c=0,d=a.screens.length;c<d;++c)if(a.screens[c].name==b)return a.screens[c];return null}
g.ve=function(a,b,c,d){Od(nk(this.j,"/pairing/get_screen"),{method:"POST",S:{pairing_code:a},timeout:5E3,$:w(function(a,d){var h=new ek(d.screen||{});if(!h.name||el(this,h.name)){var k;a:{k=h.name;for(var m=2,n=b(k,m);el(this,n);){m++;if(20<m)break a;n=b(k,m)}k=n}h.name=k}c(cl(this,h))},this),
onError:w(function(a){d(Error("pairing request failed: "+a.status))},this),
Da:w(function(){d(Error("pairing request timed out."))},this)})};
g.A=function(){E(this.f);E(this.b);V.B.A.call(this)};
function dl(a,b,c,d){a.info("requestLoungeToken_ for "+b);var e={S:{screen_ids:b},method:"POST",context:a,$:function(a,e){var k=e&&e.screens||[];k[0]&&k[0].screenId==b?c(k[0].loungeToken):d(Error("Missing lounge token in token response"))},
onError:function(){d(Error("Request screen lounge token failed"))}};
Od(nk(a.j,"/pairing/get_lounge_token_batch"),e)}
function fl(a){a.screens=a.f.U();var b=a.i,c={},d;for(d in b)c[b[d]]=d;b=0;for(d=a.screens.length;b<d;++b){var e=a.screens[b];e.uuid=c[e.id]||""}a.info("Updated manual screens: "+kk(a.screens))}
g.md=function(){fl(this);this.w("screenChange");this.b.update()};
function al(a){gl(a);a.f=new Qk(a.j);a.f.subscribe("screenChange",w(a.md,a));fl(a);a.g=ik(T("yt-remote-automatic-screen-cache")||[]);gl(a);a.info("Initializing automatic screens: "+kk(a.g));a.b=new Uk(a.j,w(a.U,a,!0));a.b.subscribe("screenChange",w(function(){this.w("onlineScreenChange")},a))}
function cl(a,b){var c=a.get(b.id);c?(c.uuid=b.uuid,b=c):((c=tk(a.g,b.uuid))?(c.id=b.id,c.token=b.token,b=c):a.g.push(b),S("yt-remote-automatic-screen-cache",Ja(a.g,gk)));gl(a);a.i[b.uuid]=b.id;S("yt-remote-device-id-map",a.i,31536E3);return b}
function gl(a){a.i=T("yt-remote-device-id-map")||{}}
V.prototype.dispose=V.prototype.dispose;function hl(a,b,c){U.call(this);this.L=c;this.F=a;this.f=b;this.g=null}
y(hl,U);g=hl.prototype;g.lb=function(a){this.g=a;this.w("sessionScreen",this.g)};
g.V=function(a){this.isDisposed()||(a&&il(this,""+a),this.g=null,this.w("sessionScreen",null))};
g.info=function(a){bk(this.L,a)};
function il(a,b){bk(a.L,b)}
g.Jc=function(){return null};
g.Qb=function(a){var b=this.f;a?(b.displayStatus=new chrome.cast.ReceiverDisplayStatus(a,[]),b.displayStatus.showStop=!0):b.displayStatus=null;chrome.cast.setReceiverDisplayStatus(b,w(function(){this.info("Updated receiver status for "+b.friendlyName+": "+a)},this),w(function(){il(this,"Failed to update receiver status for: "+b.friendlyName)},this))};
g.A=function(){this.Qb("");hl.B.A.call(this)};function jl(a,b){hl.call(this,a,b,"CastSession");this.b=null;this.j=0;this.i=null;this.u=w(this.we,this);this.l=w(this.Xd,this);this.j=H(w(function(){kl(this,null)},this),12E4)}
y(jl,hl);g=jl.prototype;g.Pb=function(a){if(this.b){if(this.b==a)return;il(this,"Overriding cast sesison with new session object");this.b.removeUpdateListener(this.u);this.b.removeMessageListener("urn:x-cast:com.google.youtube.mdx",this.l)}this.b=a;this.b.addUpdateListener(this.u);this.b.addMessageListener("urn:x-cast:com.google.youtube.mdx",this.l);this.i&&ll(this);ml(this,"getMdxSessionStatus")};
g.Ka=function(a){this.info("launchWithParams: "+L(a));this.i=a;this.b&&ll(this)};
g.stop=function(){this.b?this.b.stop(w(function(){this.V()},this),w(function(){this.V(Error("Failed to stop receiver app."))},this)):this.V(Error("Stopping cast device witout session."))};
g.Qb=t;g.A=function(){this.info("disposeInternal");I(this.j);this.j=0;this.b&&(this.b.removeUpdateListener(this.u),this.b.removeMessageListener("urn:x-cast:com.google.youtube.mdx",this.l));this.b=null;jl.B.A.call(this)};
function ll(a){var b=a.i.videoId;b&&ml(a,"flingVideo",{videoId:b,currentTime:a.i.currentTime||0});a.i=null}
function ml(a,b,c){a.info("sendYoutubeMessage_: "+b+" "+L(c));var d={};d.type=b;c&&(d.data=c);a.b?a.b.sendMessage("urn:x-cast:com.google.youtube.mdx",d,t,w(function(){il(this,"Failed to send message: "+b+".")},a)):il(a,"Sending yt message without session: "+L(d))}
g.Xd=function(a,b){if(!this.isDisposed())if(b){var c=od(b);if(c){var d=""+c.type,c=c.data||{};this.info("onYoutubeMessage_: "+d+" "+L(c));switch(d){case "mdxSessionStatus":kl(this,c.screenId);break;default:il(this,"Unknown youtube message: "+d)}}else il(this,"Unable to parse message.")}else il(this,"No data in message.")};
function kl(a,b){I(a.j);if(b){if(a.info("onConnectedScreenId_: Received screenId: "+b),!a.g||a.g.id!=b){var c=w(a.lb,a),d=w(a.V,a);a.gc(b,c,d,5)}}else a.V(Error("Waiting for session status timed out."))}
g.gc=function(a,b,c,d){bl(this.F,this.f.label,a,this.f.friendlyName,w(function(e){e?b(e):0<=d?(il(this,"Screen "+a+" appears to be offline. "+d+" retries left."),H(w(this.gc,this,a,b,c,d-1),300)):c(Error("Unable to fetch screen."))},this),c)};
g.Jc=function(){return this.b};
g.we=function(a){this.isDisposed()||a||(il(this,"Cast session died."),this.V())};function nl(a,b){hl.call(this,a,b,"DialSession");this.i=this.D=null;this.H="";this.j=null;this.u=t;this.l=NaN;this.K=w(this.ze,this);this.b=t}
y(nl,hl);g=nl.prototype;g.Pb=function(a){this.i=a;this.i.addUpdateListener(this.K)};
g.Ka=function(a){this.j=a;this.u()};
g.stop=function(){this.b();this.b=t;I(this.l);this.i?this.i.stop(w(this.V,this,null),w(this.V,this,"Failed to stop DIAL device.")):this.V()};
g.A=function(){this.b();this.b=t;I(this.l);this.i&&this.i.removeUpdateListener(this.K);this.i=null;nl.B.A.call(this)};
function ol(a){a.b=a.F.Hc(a.H,a.f.label,a.f.friendlyName,w(function(a){this.b=t;this.lb(a)},a),w(function(a){this.b=t;
this.V(a)},a))}
g.ze=function(a){this.isDisposed()||a||(il(this,"DIAL session died."),this.b(),this.b=t,this.V())};
function pl(a){var b={};b.pairingCode=a.H;if(a.j){var c=a.j.currentTime||0;b.v=a.j.videoId;b.t=c}Pk()&&(b.env_useStageMdx=1);return Cd(b)}
g.Lb=function(a){this.H=pk();if(this.j){var b=new chrome.cast.DialLaunchResponse(!0,pl(this));a(b);ol(this)}else this.u=w(function(){I(this.l);this.u=t;this.l=NaN;var b=new chrome.cast.DialLaunchResponse(!0,pl(this));a(b);ol(this)},this),this.l=H(w(function(){this.u()},this),100)};
g.nd=function(a,b){bl(this.F,this.D.receiver.label,a,this.f.friendlyName,w(function(a){a&&a.token?(this.lb(a),b(new chrome.cast.DialLaunchResponse(!1))):this.Lb(b)},this),w(function(a){il(this,"Failed to get DIAL screen: "+a);
this.Lb(b)},this))};function ql(a,b){hl.call(this,a,b,"ManualSession");this.b=H(w(this.Ka,this,null),150)}
y(ql,hl);ql.prototype.stop=function(){this.V()};
ql.prototype.Pb=t;ql.prototype.Ka=function(){I(this.b);this.b=NaN;var a=tk(this.F.U(),this.f.label);a?this.lb(a):this.V(Error("No such screen"))};
ql.prototype.A=function(){I(this.b);this.b=NaN;ql.B.A.call(this)};function W(a){U.call(this);this.f=a;this.b=null;this.j=!1;this.g=[];this.i=w(this.Jd,this)}
y(W,U);g=W.prototype;
g.init=function(a,b){chrome.cast.timeout.requestSession=3E4;var c=new chrome.cast.SessionRequest("233637DE");c.dialRequest=new chrome.cast.DialRequest("YouTube");var d=chrome.cast.AutoJoinPolicy.TAB_AND_ORIGIN_SCOPED,e=a?chrome.cast.DefaultActionPolicy.CAST_THIS_TAB:chrome.cast.DefaultActionPolicy.CREATE_SESSION,c=new chrome.cast.ApiConfig(c,w(this.qc,this),w(this.Kd,this),d,e);c.customDialLaunchCallback=w(this.yd,this);chrome.cast.initialize(c,w(function(){this.isDisposed()||(chrome.cast.addReceiverActionListener(this.i),
Xj(),this.f.subscribe("onlineScreenChange",w(this.Ic,this)),this.g=rl(this),chrome.cast.setCustomReceivers(this.g,t,w(function(a){this.I("Failed to set initial custom receivers: "+L(a))},this)),this.w("yt-remote-cast2-availability-change",sl(this)),b(!0))},this),w(function(a){this.I("Failed to initialize API: "+L(a));
b(!1)},this))};
g.ke=function(a,b){tl("Setting connected screen ID: "+a+" -> "+b);if(this.b){var c=this.b.g;if(!a||c&&c.id!=a)tl("Unsetting old screen status: "+this.b.f.friendlyName),E(this.b),this.b=null}if(a&&b){if(!this.b){c=tk(this.f.U(),a);if(!c){tl("setConnectedScreenStatus: Unknown screen.");return}var d=ul(this,c);d||(tl("setConnectedScreenStatus: Connected receiver not custom..."),d=new chrome.cast.Receiver(c.uuid?c.uuid:c.id,c.name),d.receiverType=chrome.cast.ReceiverType.CUSTOM,this.g.push(d),chrome.cast.setCustomReceivers(this.g,
t,w(function(a){this.I("Failed to set initial custom receivers: "+L(a))},this)));
tl("setConnectedScreenStatus: new active receiver: "+d.friendlyName);vl(this,new ql(this.f,d),!0)}this.b.Qb(b)}else tl("setConnectedScreenStatus: no screen.")};
function ul(a,b){return b?Ma(a.g,function(a){return fk(b,a.label)},a):null}
g.le=function(a){this.isDisposed()?this.I("Setting connection data on disposed cast v2"):this.b?this.b.Ka(a):this.I("Setting connection data without a session")};
g.ye=function(){this.isDisposed()?this.I("Stopping session on disposed cast v2"):this.b?(this.b.stop(),E(this.b),this.b=null):tl("Stopping non-existing session")};
g.requestSession=function(){chrome.cast.requestSession(w(this.qc,this),w(this.Nd,this))};
g.A=function(){this.f.unsubscribe("onlineScreenChange",w(this.Ic,this));window.chrome&&chrome.cast&&chrome.cast.removeReceiverActionListener(this.i);var a=Yj,b=r("yt.mdx.remote.debug.handlers_");Pa(b||[],a);E(this.b);W.B.A.call(this)};
function tl(a){bk("Controller",a)}
g.I=function(a){bk("Controller",a)};
function Yj(a){window.chrome&&chrome.cast&&chrome.cast.logMessage&&chrome.cast.logMessage(a)}
function sl(a){return a.j||!!a.g.length||!!a.b}
function vl(a,b,c){E(a.b);(a.b=b)?(c?a.w("yt-remote-cast2-receiver-resumed",b.f):a.w("yt-remote-cast2-receiver-selected",b.f),b.subscribe("sessionScreen",w(a.sc,a,b)),b.g?a.w("yt-remote-cast2-session-change",b.g):c&&a.b.Ka(null)):a.w("yt-remote-cast2-session-change",null)}
g.sc=function(a,b){this.b==a&&(b||vl(this,null),this.w("yt-remote-cast2-session-change",b))};
g.Jd=function(a,b){if(!this.isDisposed())if(a)switch(tl("onReceiverAction_ "+a.label+" / "+a.friendlyName+"-- "+b),b){case chrome.cast.ReceiverAction.CAST:if(this.b)if(this.b.f.label!=a.label)tl("onReceiverAction_: Stopping active receiver: "+this.b.f.friendlyName),this.b.stop();else{tl("onReceiverAction_: Casting to active receiver.");this.b.g&&this.w("yt-remote-cast2-session-change",this.b.g);break}switch(a.receiverType){case chrome.cast.ReceiverType.CUSTOM:vl(this,new ql(this.f,a));break;case chrome.cast.ReceiverType.DIAL:vl(this,
new nl(this.f,a));break;case chrome.cast.ReceiverType.CAST:vl(this,new jl(this.f,a));break;default:this.I("Unknown receiver type: "+a.receiverType)}break;case chrome.cast.ReceiverAction.STOP:this.b&&this.b.f.label==a.label?this.b.stop():this.I("Stopping receiver w/o session: "+a.friendlyName)}else this.I("onReceiverAction_ called without receiver.")};
g.yd=function(a){if(this.isDisposed())return Promise.reject(Error("disposed"));var b=a.receiver;b.receiverType!=chrome.cast.ReceiverType.DIAL&&(this.I("Not DIAL receiver: "+b.friendlyName),b.receiverType=chrome.cast.ReceiverType.DIAL);var c=this.b?this.b.f:null;if(!c||c.label!=b.label)return this.I("Receiving DIAL launch request for non-clicked DIAL receiver: "+b.friendlyName),Promise.reject(Error("illegal DIAL launch"));if(c&&c.label==b.label&&c.receiverType!=chrome.cast.ReceiverType.DIAL){if(this.b.g)return tl("Reselecting dial screen."),
this.w("yt-remote-cast2-session-change",this.b.g),Promise.resolve(new chrome.cast.DialLaunchResponse(!1));this.I('Changing CAST intent from "'+c.receiverType+'" to "dial" for '+b.friendlyName);vl(this,new nl(this.f,b))}b=this.b;b.D=a;return b.D.appState==chrome.cast.DialAppState.RUNNING?new Promise(w(b.nd,b,(b.D.extraData||{}).screenId||null)):new Promise(w(b.Lb,b))};
g.qc=function(a){if(!this.isDisposed()){tl("New cast session ID: "+a.sessionId);var b=a.receiver;if(b.receiverType!=chrome.cast.ReceiverType.CUSTOM){if(!this.b)if(b.receiverType==chrome.cast.ReceiverType.CAST)tl("Got resumed cast session before resumed mdx connection."),vl(this,new jl(this.f,b),!0);else{this.I("Got non-cast session without previous mdx receiver event, or mdx resume.");return}var c=this.b.f,d=tk(this.f.U(),c.label);d&&fk(d,b.label)&&c.receiverType!=chrome.cast.ReceiverType.CAST&&b.receiverType==
chrome.cast.ReceiverType.CAST&&(tl("onSessionEstablished_: manual to cast session change "+b.friendlyName),E(this.b),this.b=new jl(this.f,b),this.b.subscribe("sessionScreen",w(this.sc,this,this.b)),this.b.Ka(null));this.b.Pb(a)}}};
g.xe=function(){return this.b?this.b.Jc():null};
g.Nd=function(a){this.isDisposed()||(this.I("Failed to estabilish a session: "+L(a)),a.code!=chrome.cast.ErrorCode.CANCEL&&vl(this,null))};
g.Kd=function(a){tl("Receiver availability updated: "+a);if(!this.isDisposed()){var b=sl(this);this.j=a==chrome.cast.ReceiverAvailability.AVAILABLE;sl(this)!=b&&this.w("yt-remote-cast2-availability-change",sl(this))}};
function rl(a){var b=a.f.Gc(),c=a.b&&a.b.f;a=Ja(b,function(a){c&&fk(a,c.label)&&(c=null);var b=a.uuid?a.uuid:a.id,f=ul(this,a);f?(f.label=b,f.friendlyName=a.name):(f=new chrome.cast.Receiver(b,a.name),f.receiverType=chrome.cast.ReceiverType.CUSTOM);return f},a);
c&&(c.receiverType!=chrome.cast.ReceiverType.CUSTOM&&(c=new chrome.cast.Receiver(c.label,c.friendlyName),c.receiverType=chrome.cast.ReceiverType.CUSTOM),a.push(c));return a}
g.Ic=function(){if(!this.isDisposed()){var a=sl(this);this.g=rl(this);tl("Updating custom receivers: "+L(this.g));chrome.cast.setCustomReceivers(this.g,t,w(function(){this.I("Failed to set custom receivers.")},this));
var b=sl(this);b!=a&&this.w("yt-remote-cast2-availability-change",b)}};
W.prototype.setLaunchParams=W.prototype.le;W.prototype.setConnectedScreenStatus=W.prototype.ke;W.prototype.stopSession=W.prototype.ye;W.prototype.getCastSession=W.prototype.xe;W.prototype.requestSession=W.prototype.requestSession;W.prototype.init=W.prototype.init;W.prototype.dispose=W.prototype.dispose;function wl(a,b,c){xl()?zl(a)&&(Al(!0),window.chrome&&chrome.cast&&chrome.cast.isAvailable?Bl(b):(window.__onGCastApiAvailable=function(a,c){a?Bl(b):(Cl("Failed to load cast API: "+c),Dl(!1),Al(!1),Aj("yt-remote-cast-available"),Aj("yt-remote-cast-receiver"),El(),b(!1))},c?qc("https://www.gstatic.com/cv/js/sender/v1/cast_sender.js"):Rj())):yl("Cannot initialize because not running Chrome")}
function El(){yl("dispose");var a=Fl();a&&a.dispose();Gl=null;q("yt.mdx.remote.cloudview.instance_",null,void 0);Hl(!1);mc(Il);Il.length=0}
function Jl(){return!!T("yt-remote-cast-installed")}
function Kl(){var a=T("yt-remote-cast-receiver");a?(a=a.friendlyName,a=-1!=a.indexOf("&")?"document"in l?za(a):Ba(a):a):a=null;return a}
function Ll(){yl("clearCurrentReciever");Aj("yt-remote-cast-receiver")}
function Ml(){Jl()?Fl()?Nl()?(yl("Requesting cast selector."),Gl.requestSession()):(yl("Wait for cast API to be ready to request the session."),Il.push(kc("yt-remote-cast2-api-ready",Ml))):Cl("requestCastSelector: Cast is not initialized."):Cl("requestCastSelector: Cast API is not installed!")}
function Ol(a){Nl()?Fl().setLaunchParams(a):Cl("setLaunchParams called before ready.")}
function Pl(a,b){Nl()?Fl().setConnectedScreenStatus(a,b):Cl("setConnectedScreenStatus called before ready.")}
var Gl=null;function xl(){var a;a=0<=lb.search(/\ (CrMo|Chrome|CriOS)\//);return of||a}
function zl(a){var b=!1;if(!Gl){var c=r("yt.mdx.remote.cloudview.instance_");c||(c=new W(a),c.subscribe("yt-remote-cast2-availability-change",function(a){S("yt-remote-cast-available",a);J("yt-remote-cast2-availability-change",a)}),c.subscribe("yt-remote-cast2-receiver-selected",function(a){yl("onReceiverSelected: "+a.friendlyName);
S("yt-remote-cast-receiver",a);J("yt-remote-cast2-receiver-selected",a)}),c.subscribe("yt-remote-cast2-receiver-resumed",function(a){yl("onReceiverResumed: "+a.friendlyName);
S("yt-remote-cast-receiver",a)}),c.subscribe("yt-remote-cast2-session-change",function(a){yl("onSessionChange: "+jk(a));
a||Aj("yt-remote-cast-receiver");J("yt-remote-cast2-session-change",a)}),q("yt.mdx.remote.cloudview.instance_",c,void 0),b=!0);
Gl=c}yl("cloudview.createSingleton_: "+b);return b}
function Fl(){Gl||(Gl=r("yt.mdx.remote.cloudview.instance_"));return Gl}
function Bl(a){Dl(!0);Al(!1);Gl.init(!0,function(b){b?(Hl(!0),J("yt-remote-cast2-api-ready")):(Cl("Failed to initialize cast API."),Dl(!1),Aj("yt-remote-cast-available"),Aj("yt-remote-cast-receiver"),El());a(b)})}
function yl(a){bk("cloudview",a)}
function Cl(a){bk("cloudview",a)}
function Dl(a){yl("setCastInstalled_ "+a);S("yt-remote-cast-installed",a)}
function Nl(){return!!r("yt.mdx.remote.cloudview.apiReady_")}
function Hl(a){yl("setApiReady_ "+a);q("yt.mdx.remote.cloudview.apiReady_",a,void 0)}
function Al(a){q("yt.mdx.remote.cloudview.initializing_",a,void 0)}
var Il=[];function Ql(){}
;function Rl(a,b){this.action=a;this.params=b||null}
;function Sl(){this.b=x()}
new Sl;Sl.prototype.set=function(a){this.b=a};
Sl.prototype.reset=function(){this.set(x())};
Sl.prototype.get=function(){return this.b};function Tl(a,b){this.type=a;this.currentTarget=this.target=b;this.defaultPrevented=this.b=!1;this.zc=!0}
Tl.prototype.stopPropagation=function(){this.b=!0};
Tl.prototype.preventDefault=function(){this.defaultPrevented=!0;this.zc=!1};var Ul=!K||kd(9),Vl=K&&!jd("9");!$c||jd("528");Zc&&jd("1.9b")||K&&jd("8")||Xc&&jd("9.5")||$c&&jd("528");Zc&&!jd("8")||K&&jd("9");function Wl(a,b){Tl.call(this,a?a.type:"");this.relatedTarget=this.currentTarget=this.target=null;this.charCode=this.keyCode=this.button=this.screenY=this.screenX=this.clientY=this.clientX=0;this.metaKey=this.shiftKey=this.altKey=this.ctrlKey=!1;this.f=this.state=null;a&&this.init(a,b)}
y(Wl,Tl);
Wl.prototype.init=function(a,b){var c=this.type=a.type,d=a.changedTouches?a.changedTouches[0]:null;this.target=a.target||a.srcElement;this.currentTarget=b;var e=a.relatedTarget;if(e){if(Zc){var f;a:{try{Ze(e.nodeName);f=!0;break a}catch(h){}f=!1}f||(e=null)}}else"mouseover"==c?e=a.fromElement:"mouseout"==c&&(e=a.toElement);this.relatedTarget=e;null===d?(this.clientX=void 0!==a.clientX?a.clientX:a.pageX,this.clientY=void 0!==a.clientY?a.clientY:a.pageY,this.screenX=a.screenX||0,this.screenY=a.screenY||
0):(this.clientX=void 0!==d.clientX?d.clientX:d.pageX,this.clientY=void 0!==d.clientY?d.clientY:d.pageY,this.screenX=d.screenX||0,this.screenY=d.screenY||0);this.button=a.button;this.keyCode=a.keyCode||0;this.charCode=a.charCode||("keypress"==c?a.keyCode:0);this.ctrlKey=a.ctrlKey;this.altKey=a.altKey;this.shiftKey=a.shiftKey;this.metaKey=a.metaKey;this.state=a.state;this.f=a;a.defaultPrevented&&this.preventDefault()};
Wl.prototype.stopPropagation=function(){Wl.B.stopPropagation.call(this);this.f.stopPropagation?this.f.stopPropagation():this.f.cancelBubble=!0};
Wl.prototype.preventDefault=function(){Wl.B.preventDefault.call(this);var a=this.f;if(a.preventDefault)a.preventDefault();else if(a.returnValue=!1,Vl)try{if(a.ctrlKey||112<=a.keyCode&&123>=a.keyCode)a.keyCode=-1}catch(b){}};var Xl="closure_listenable_"+(1E6*Math.random()|0),Yl=0;function Zl(a,b,c,d,e){this.listener=a;this.b=null;this.src=b;this.type=c;this.cb=!!d;this.hb=e;this.key=++Yl;this.Ma=this.bb=!1}
function $l(a){a.Ma=!0;a.listener=null;a.b=null;a.src=null;a.hb=null}
;function am(a){this.src=a;this.b={};this.f=0}
function bm(a,b,c,d,e){var f=b.toString();b=a.b[f];b||(b=a.b[f]=[],a.f++);var h=cm(b,c,d,e);-1<h?(a=b[h],a.bb=!1):(a=new Zl(c,a.src,f,!!d,e),a.bb=!1,b.push(a));return a}
am.prototype.remove=function(a,b,c,d){a=a.toString();if(!(a in this.b))return!1;var e=this.b[a];b=cm(e,b,c,d);return-1<b?($l(e[b]),Array.prototype.splice.call(e,b,1),0==e.length&&(delete this.b[a],this.f--),!0):!1};
function dm(a,b){var c=b.type;c in a.b&&Pa(a.b[c],b)&&($l(b),0==a.b[c].length&&(delete a.b[c],a.f--))}
function em(a,b,c,d,e){a=a.b[b.toString()];b=-1;a&&(b=cm(a,c,d,e));return-1<b?a[b]:null}
function cm(a,b,c,d){for(var e=0;e<a.length;++e){var f=a[e];if(!f.Ma&&f.listener==b&&f.cb==!!c&&f.hb==d)return e}return-1}
;var fm="closure_lm_"+(1E6*Math.random()|0),gm={},hm=0;
function im(a,b,c,d,e){if(u(b)){for(var f=0;f<b.length;f++)im(a,b[f],c,d,e);return null}c=jm(c);if(a&&a[Xl])a=a.ib(b,c,d,e);else{if(!b)throw Error("Invalid event type");var f=!!d,h=km(a);h||(a[fm]=h=new am(a));c=bm(h,b,c,d,e);if(!c.b){d=lm();c.b=d;d.src=a;d.listener=c;if(a.addEventListener)a.addEventListener(b.toString(),d,f);else if(a.attachEvent)a.attachEvent(mm(b.toString()),d);else throw Error("addEventListener and attachEvent are unavailable.");hm++}a=c}return a}
function lm(){var a=nm,b=Ul?function(c){return a.call(b.src,b.listener,c)}:function(c){c=a.call(b.src,b.listener,c);
if(!c)return c};
return b}
function om(a,b,c,d,e){if(u(b))for(var f=0;f<b.length;f++)om(a,b[f],c,d,e);else c=jm(c),a&&a[Xl]?a.qb(b,c,d,e):a&&(a=km(a))&&(b=em(a,b,c,!!d,e))&&pm(b)}
function pm(a){if(!ea(a)&&a&&!a.Ma){var b=a.src;if(b&&b[Xl])dm(b.g,a);else{var c=a.type,d=a.b;b.removeEventListener?b.removeEventListener(c,d,a.cb):b.detachEvent&&b.detachEvent(mm(c),d);hm--;(c=km(b))?(dm(c,a),0==c.f&&(c.src=null,b[fm]=null)):$l(a)}}}
function mm(a){return a in gm?gm[a]:gm[a]="on"+a}
function qm(a,b,c,d){var e=!0;if(a=km(a))if(b=a.b[b.toString()])for(b=b.concat(),a=0;a<b.length;a++){var f=b[a];f&&f.cb==c&&!f.Ma&&(f=rm(f,d),e=e&&!1!==f)}return e}
function rm(a,b){var c=a.listener,d=a.hb||a.src;a.bb&&pm(a);return c.call(d,b)}
function nm(a,b){if(a.Ma)return!0;if(!Ul){var c=b||r("window.event"),d=new Wl(c,this),e=!0;if(!(0>c.keyCode||void 0!=c.returnValue)){a:{var f=!1;if(0==c.keyCode)try{c.keyCode=-1;break a}catch(m){f=!0}if(f||void 0==c.returnValue)c.returnValue=!0}c=[];for(f=d.currentTarget;f;f=f.parentNode)c.push(f);for(var f=a.type,h=c.length-1;!d.b&&0<=h;h--){d.currentTarget=c[h];var k=qm(c[h],f,!0,d),e=e&&k}for(h=0;!d.b&&h<c.length;h++)d.currentTarget=c[h],k=qm(c[h],f,!1,d),e=e&&k}return e}return rm(a,new Wl(b,this))}
function km(a){a=a[fm];return a instanceof am?a:null}
var sm="__closure_events_fn_"+(1E9*Math.random()>>>0);function jm(a){if(fa(a))return a;a[sm]||(a[sm]=function(b){return a.handleEvent(b)});
return a[sm]}
;function tm(){D.call(this);this.g=new am(this);this.qa=this;this.ca=null}
y(tm,D);tm.prototype[Xl]=!0;g=tm.prototype;g.addEventListener=function(a,b,c,d){im(this,a,b,c,d)};
g.removeEventListener=function(a,b,c,d){om(this,a,b,c,d)};
function um(a,b){var c,d=a.ca;if(d){c=[];for(var e=1;d;d=d.ca)c.push(d),++e}var d=a.qa,e=b,f=e.type||e;if(v(e))e=new Tl(e,d);else if(e instanceof Tl)e.target=e.target||d;else{var h=e,e=new Tl(f,d);kb(e,h)}var h=!0,k;if(c)for(var m=c.length-1;!e.b&&0<=m;m--)k=e.currentTarget=c[m],h=vm(k,f,!0,e)&&h;e.b||(k=e.currentTarget=d,h=vm(k,f,!0,e)&&h,e.b||(h=vm(k,f,!1,e)&&h));if(c)for(m=0;!e.b&&m<c.length;m++)k=e.currentTarget=c[m],h=vm(k,f,!1,e)&&h}
g.A=function(){tm.B.A.call(this);if(this.g){var a=this.g,b=0,c;for(c in a.b){for(var d=a.b[c],e=0;e<d.length;e++)++b,$l(d[e]);delete a.b[c];a.f--}}this.ca=null};
g.ib=function(a,b,c,d){return bm(this.g,String(a),b,c,d)};
g.qb=function(a,b,c,d){return this.g.remove(String(a),b,c,d)};
function vm(a,b,c,d){b=a.g.b[String(b)];if(!b)return!0;b=b.concat();for(var e=!0,f=0;f<b.length;++f){var h=b[f];if(h&&!h.Ma&&h.cb==c){var k=h.listener,m=h.hb||h.src;h.bb&&dm(a.g,h);e=!1!==k.call(m,d)&&e}}return e&&0!=d.zc}
;function wm(a,b){this.f=new qd(a);this.b=b?od:nd}
wm.prototype.stringify=function(a){return pd(this.f,a)};
wm.prototype.parse=function(a){return this.b(a)};function xm(a,b){tm.call(this);this.b=a||1;this.f=b||l;this.i=w(this.ne,this);this.j=x()}
y(xm,tm);g=xm.prototype;g.enabled=!1;g.Y=null;function ym(a,b){a.b=b;a.Y&&a.enabled?(a.stop(),a.start()):a.Y&&a.stop()}
g.ne=function(){if(this.enabled){var a=x()-this.j;0<a&&a<.8*this.b?this.Y=this.f.setTimeout(this.i,this.b-a):(this.Y&&(this.f.clearTimeout(this.Y),this.Y=null),um(this,"tick"),this.enabled&&(this.Y=this.f.setTimeout(this.i,this.b),this.j=x()))}};
g.start=function(){this.enabled=!0;this.Y||(this.Y=this.f.setTimeout(this.i,this.b),this.j=x())};
g.stop=function(){this.enabled=!1;this.Y&&(this.f.clearTimeout(this.Y),this.Y=null)};
g.A=function(){xm.B.A.call(this);this.stop();delete this.f};
function zm(a,b,c){if(fa(a))c&&(a=w(a,c));else if(a&&"function"==typeof a.handleEvent)a=w(a.handleEvent,a);else throw Error("Invalid listener argument");return 2147483647<Number(b)?-1:l.setTimeout(a,b||0)}
;function Am(a,b,c){D.call(this);this.i=null!=c?w(a,c):a;this.g=b;this.f=w(this.Pd,this);this.b=[]}
y(Am,D);g=Am.prototype;g.Na=!1;g.Xa=0;g.za=null;g.dd=function(a){this.b=arguments;this.za||this.Xa?this.Na=!0:Bm(this)};
g.stop=function(){this.za&&(l.clearTimeout(this.za),this.za=null,this.Na=!1,this.b=[])};
g.pause=function(){this.Xa++};
g.resume=function(){this.Xa--;this.Xa||!this.Na||this.za||(this.Na=!1,Bm(this))};
g.A=function(){Am.B.A.call(this);this.stop()};
g.Pd=function(){this.za=null;this.Na&&!this.Xa&&(this.Na=!1,Bm(this))};
function Bm(a){a.za=zm(a.f,a.g);a.i.apply(null,a.b)}
;function Cm(a){D.call(this);this.f=a;this.b={}}
y(Cm,D);var Dm=[];Cm.prototype.ib=function(a,b,c,d){u(b)||(b&&(Dm[0]=b.toString()),b=Dm);for(var e=0;e<b.length;e++){var f=im(a,b[e],c||this.handleEvent,d||!1,this.f||this);if(!f)break;this.b[f.key]=f}return this};
Cm.prototype.qb=function(a,b,c,d,e){if(u(b))for(var f=0;f<b.length;f++)this.qb(a,b[f],c,d,e);else c=c||this.handleEvent,e=e||this.f||this,c=jm(c),d=!!d,b=a&&a[Xl]?em(a.g,String(b),c,d,e):a?(a=km(a))?em(a,b,c,d,e):null:null,b&&(pm(b),delete this.b[b.key]);return this};
function Em(a){Xa(a.b,function(a,c){this.b.hasOwnProperty(c)&&pm(a)},a);
a.b={}}
Cm.prototype.A=function(){Cm.B.A.call(this);Em(this)};
Cm.prototype.handleEvent=function(){throw Error("EventHandler.handleEvent not implemented");};function Fm(){}
Fm.prototype.b=null;function Gm(a){var b;(b=a.b)||(b={},Hm(a)&&(b[0]=!0,b[1]=!0),b=a.b=b);return b}
;var Im;function Jm(){}
y(Jm,Fm);function Km(a){return(a=Hm(a))?new ActiveXObject(a):new XMLHttpRequest}
function Hm(a){if(!a.f&&"undefined"==typeof XMLHttpRequest&&"undefined"!=typeof ActiveXObject){for(var b=["MSXML2.XMLHTTP.6.0","MSXML2.XMLHTTP.3.0","MSXML2.XMLHTTP","Microsoft.XMLHTTP"],c=0;c<b.length;c++){var d=b[c];try{return new ActiveXObject(d),a.f=d}catch(e){}}throw Error("Could not create ActiveXObject. ActiveX might be disabled, or MSXML might not be installed");}return a.f}
Im=new Jm;function Lm(a,b,c,d,e){this.b=a;this.g=c;this.u=d;this.l=e||1;this.j=45E3;this.i=new Cm(this);this.f=new xm;ym(this.f,250)}
g=Lm.prototype;g.Aa=null;g.fa=!1;g.Pa=null;g.Sb=null;g.Ya=null;g.Oa=null;g.ra=null;g.ua=null;g.Ea=null;g.J=null;g.$a=0;g.ga=null;g.tb=null;g.Ba=null;g.Va=-1;g.Ac=!0;g.wa=!1;g.Jb=0;g.nb=null;var Mm={},Nm={};g=Lm.prototype;g.setTimeout=function(a){this.j=a};
function Om(a,b,c){a.Oa=1;a.ra=Ug(b.clone());a.Ea=c;a.o=!0;Pm(a,null)}
function Qm(a,b,c,d,e){a.Oa=1;a.ra=Ug(b.clone());a.Ea=null;a.o=c;e&&(a.Ac=!1);Pm(a,d)}
function Pm(a,b){a.Ya=x();Rm(a);a.ua=a.ra.clone();Sg(a.ua,"t",a.l);a.$a=0;a.J=a.b.Cb(a.b.Za()?b:null);0<a.Jb&&(a.nb=new Am(w(a.Fc,a,a.J),a.Jb));a.i.ib(a.J,"readystatechange",a.$d);var c=a.Aa?hb(a.Aa):{};a.Ea?(a.tb="POST",c["Content-Type"]="application/x-www-form-urlencoded",a.J.send(a.ua,a.tb,a.Ea,c)):(a.tb="GET",a.Ac&&!$c&&(c.Connection="close"),a.J.send(a.ua,a.tb,null,c));a.b.ea(1)}
g.$d=function(a){a=a.target;var b=this.nb;b&&3==Sm(a)?b.dd():this.Fc(a)};
g.Fc=function(a){try{if(a==this.J)a:{var b=Sm(this.J),c=this.J.j,d=this.J.getStatus();if(K&&!kd(10)||$c&&!jd("420+")){if(4>b)break a}else if(3>b||3==b&&!Xc&&!Tm(this.J))break a;this.wa||4!=b||7==c||(8==c||0>=d?this.b.ea(3):this.b.ea(2));Um(this);var e=this.J.getStatus();this.Va=e;var f=Tm(this.J);(this.fa=200==e)?(4==b&&Vm(this),this.o?(Wm(this,b,f),Xc&&this.fa&&3==b&&(this.i.ib(this.f,"tick",this.Yd),this.f.start())):Xm(this,f),this.fa&&!this.wa&&(4==b?this.b.kb(this):(this.fa=!1,Rm(this)))):(this.Ba=
400==e&&0<f.indexOf("Unknown SID")?3:0,X(),Vm(this),Ym(this))}}catch(h){this.J&&Tm(this.J)}finally{}};
function Wm(a,b,c){for(var d=!0;!a.wa&&a.$a<c.length;){var e=Zm(a,c);if(e==Nm){4==b&&(a.Ba=4,X(),d=!1);break}else if(e==Mm){a.Ba=4;X();d=!1;break}else Xm(a,e)}4==b&&0==c.length&&(a.Ba=1,X(),d=!1);a.fa=a.fa&&d;d||(Vm(a),Ym(a))}
g.Yd=function(){var a=Sm(this.J),b=Tm(this.J);this.$a<b.length&&(Um(this),Wm(this,a,b),this.fa&&4!=a&&Rm(this))};
function Zm(a,b){var c=a.$a,d=b.indexOf("\n",c);if(-1==d)return Nm;c=Number(b.substring(c,d));if(isNaN(c))return Mm;d+=1;if(d+c>b.length)return Nm;var e=b.substr(d,c);a.$a=d+c;return e}
function $m(a,b){a.Ya=x();Rm(a);var c=b?window.location.hostname:"";a.ua=a.ra.clone();N(a.ua,"DOMAIN",c);N(a.ua,"t",a.l);try{a.ga=new ActiveXObject("htmlfile")}catch(n){Vm(a);a.Ba=7;X();Ym(a);return}var d="<html><body>";if(b){for(var e="",f=0;f<c.length;f++){var h=c.charAt(f);if("<"==h)e+="\\x3c";else if(">"==h)e+="\\x3e";else{if(h in Da)h=Da[h];else if(h in Ca)h=Da[h]=Ca[h];else{var k,m=h.charCodeAt(0);if(31<m&&127>m)k=h;else{if(256>m){if(k="\\x",16>m||256<m)k+="0"}else k="\\u",4096>m&&(k+="0");
k+=m.toString(16).toUpperCase()}h=Da[h]=k}e+=h}}d+='<script>document.domain="'+e+'"\x3c/script>'}d+="</body></html>";c=Cc(qb("b/12014412"),d);a.ga.open();a.ga.write(zb(c));a.ga.close();a.ga.parentWindow.m=w(a.Td,a);a.ga.parentWindow.d=w(a.wc,a,!0);a.ga.parentWindow.rpcClose=w(a.wc,a,!1);c=a.ga.createElement("DIV");a.ga.parentWindow.document.body.appendChild(c);d=vb(a.ua.toString());d=tb(d);ya.test(d)&&(-1!=d.indexOf("&")&&(d=d.replace(ra,"&amp;")),-1!=d.indexOf("<")&&(d=d.replace(sa,"&lt;")),-1!=
d.indexOf(">")&&(d=d.replace(ta,"&gt;")),-1!=d.indexOf('"')&&(d=d.replace(va,"&quot;")),-1!=d.indexOf("'")&&(d=d.replace(wa,"&#39;")),-1!=d.indexOf("\x00")&&(d=d.replace(xa,"&#0;")));d=Cc(qb("b/12014412"),'<iframe src="'+d+'"></iframe>');c.innerHTML=zb(d);a.b.ea(1)}
g.Td=function(a){an(w(this.Sd,this,a),0)};
g.Sd=function(a){this.wa||(Um(this),Xm(this,a),Rm(this))};
g.wc=function(a){an(w(this.Rd,this,a),0)};
g.Rd=function(a){this.wa||(Vm(this),this.fa=a,this.b.kb(this),this.b.ea(4))};
g.cancel=function(){this.wa=!0;Vm(this)};
function Rm(a){a.Sb=x()+a.j;bn(a,a.j)}
function bn(a,b){if(null!=a.Pa)throw Error("WatchDog timer not null");a.Pa=an(w(a.Vd,a),b)}
function Um(a){a.Pa&&(l.clearTimeout(a.Pa),a.Pa=null)}
g.Vd=function(){this.Pa=null;var a=x();0<=a-this.Sb?(2!=this.Oa&&this.b.ea(3),Vm(this),this.Ba=2,X(),Ym(this)):bn(this,this.Sb-a)};
function Ym(a){a.b.ic()||a.wa||a.b.kb(a)}
function Vm(a){Um(a);E(a.nb);a.nb=null;a.f.stop();Em(a.i);if(a.J){var b=a.J;a.J=null;cn(b);b.dispose()}a.ga&&(a.ga=null)}
function Xm(a,b){try{a.b.pc(a,b),a.b.ea(4)}catch(c){}}
;function dn(a,b,c,d,e){if(0==d)c(!1);else{var f=e||0;d--;en(a,b,function(e){e?c(!0):l.setTimeout(function(){dn(a,b,c,d,f)},f)})}}
function en(a,b,c){var d=new Image;d.onload=function(){try{fn(d),c(!0)}catch(a){}};
d.onerror=function(){try{fn(d),c(!1)}catch(a){}};
d.onabort=function(){try{fn(d),c(!1)}catch(a){}};
d.ontimeout=function(){try{fn(d),c(!1)}catch(a){}};
l.setTimeout(function(){if(d.ontimeout)d.ontimeout()},b);
d.src=a}
function fn(a){a.onload=null;a.onerror=null;a.onabort=null;a.ontimeout=null}
;function gn(a){this.b=a;this.f=new wm(null,!0)}
g=gn.prototype;g.Hb=null;g.W=null;g.ob=!1;g.Dc=null;g.eb=null;g.Mb=null;g.Ib=null;g.Z=null;g.pa=-1;g.Ua=null;g.Qa=null;g.connect=function(a){this.Ib=a;a=hn(this.b,null,this.Ib);X();this.Dc=x();var b=this.b.u;null!=b?(this.Ua=b[0],(this.Qa=b[1])?(this.Z=1,jn(this)):(this.Z=2,kn(this))):(Sg(a,"MODE","init"),this.W=new Lm(this,0,void 0,void 0,void 0),this.W.Aa=this.Hb,Qm(this.W,a,!1,null,!0),this.Z=0)};
function jn(a){var b=hn(a.b,a.Qa,"/mail/images/cleardot.gif");Ug(b);dn(b.toString(),5E3,w(a.$c,a),3,2E3);a.ea(1)}
g.$c=function(a){if(a)this.Z=2,kn(this);else{X();var b=this.b;b.da=b.sa.pa;ln(b,9)}a&&this.ea(2)};
function kn(a){var b=a.b.N;if(null!=b)X(),b?(X(),mn(a.b,a,!1)):(X(),mn(a.b,a,!0));else if(a.W=new Lm(a,0,void 0,void 0,void 0),a.W.Aa=a.Hb,b=a.b,b=hn(b,b.Za()?a.Ua:null,a.Ib),X(),!K||kd(10))Sg(b,"TYPE","xmlhttp"),Qm(a.W,b,!1,a.Ua,!1);else{Sg(b,"TYPE","html");var c=a.W;a=!!a.Ua;c.Oa=3;c.ra=Ug(b.clone());$m(c,a)}}
g.Cb=function(a){return this.b.Cb(a)};
g.ic=function(){return!1};
g.pc=function(a,b){this.pa=a.Va;if(0==this.Z)if(b){try{var c=this.f.parse(b)}catch(d){c=this.b;c.da=this.pa;ln(c,2);return}this.Ua=c[0];this.Qa=c[1]}else c=this.b,c.da=this.pa,ln(c,2);else if(2==this.Z)if(this.ob)X(),this.Mb=x();else if("11111"==b){if(X(),this.ob=!0,this.eb=x(),c=this.eb-this.Dc,!K||kd(10)||500>c)this.pa=200,this.W.cancel(),X(),mn(this.b,this,!0)}else X(),this.eb=this.Mb=x(),this.ob=!1};
g.kb=function(){this.pa=this.W.Va;if(this.W.fa)0==this.Z?this.Qa?(this.Z=1,jn(this)):(this.Z=2,kn(this)):2==this.Z&&((!K||kd(10)?!this.ob:200>this.Mb-this.eb)?(X(),mn(this.b,this,!1)):(X(),mn(this.b,this,!0)));else{0==this.Z?X():2==this.Z&&X();var a=this.b;a.da=this.pa;ln(a,2)}};
g.Za=function(){return this.b.Za()};
g.isActive=function(){return this.b.isActive()};
g.ea=function(a){this.b.ea(a)};function nn(a){tm.call(this);this.headers=new Ic;this.L=a||null;this.f=!1;this.K=this.b=null;this.ka=this.D="";this.j=0;this.o="";this.i=this.ba=this.u=this.X=!1;this.l=0;this.F=null;this.la="";this.H=this.ia=!1}
y(nn,tm);var on=/^https?$/i,pn=["POST","PUT"];g=nn.prototype;
g.send=function(a,b,c,d){if(this.b)throw Error("[goog.net.XhrIo] Object is active with another request="+this.D+"; newUri="+a);b=b?b.toUpperCase():"GET";this.D=a;this.o="";this.j=0;this.ka=b;this.X=!1;this.f=!0;this.b=this.L?Km(this.L):Km(Im);this.K=this.L?Gm(this.L):Gm(Im);this.b.onreadystatechange=w(this.oc,this);try{Ql(qn(this,"Opening Xhr")),this.ba=!0,this.b.open(b,String(a),!0),this.ba=!1}catch(f){Ql(qn(this,"Error opening Xhr: "+f.message));rn(this,f);return}a=c||"";var e=this.headers.clone();
d&&Qc(d,function(a,b){e.set(b,a)});
d=Ma(e.ja(),sn);c=l.FormData&&a instanceof l.FormData;!A(pn,b)||d||c||e.set("Content-Type","application/x-www-form-urlencoded;charset=utf-8");e.forEach(function(a,b){this.b.setRequestHeader(b,a)},this);
this.la&&(this.b.responseType=this.la);"withCredentials"in this.b&&this.b.withCredentials!==this.ia&&(this.b.withCredentials=this.ia);try{tn(this),0<this.l&&(this.H=un(this.b),Ql(qn(this,"Will abort after "+this.l+"ms if incomplete, xhr2 "+this.H)),this.H?(this.b.timeout=this.l,this.b.ontimeout=w(this.hc,this)):this.F=zm(this.hc,this.l,this)),Ql(qn(this,"Sending request")),this.u=!0,this.b.send(a),this.u=!1}catch(f){Ql(qn(this,"Send error: "+f.message)),rn(this,f)}};
function un(a){return K&&jd(9)&&ea(a.timeout)&&p(a.ontimeout)}
function sn(a){return"content-type"==a.toLowerCase()}
g.hc=function(){"undefined"!=typeof aa&&this.b&&(this.o="Timed out after "+this.l+"ms, aborting",this.j=8,qn(this,this.o),um(this,"timeout"),cn(this,8))};
function rn(a,b){a.f=!1;a.b&&(a.i=!0,a.b.abort(),a.i=!1);a.o=b;a.j=5;vn(a);wn(a)}
function vn(a){a.X||(a.X=!0,um(a,"complete"),um(a,"error"))}
function cn(a,b){a.b&&a.f&&(qn(a,"Aborting"),a.f=!1,a.i=!0,a.b.abort(),a.i=!1,a.j=b||7,um(a,"complete"),um(a,"abort"),wn(a))}
g.A=function(){this.b&&(this.f&&(this.f=!1,this.i=!0,this.b.abort(),this.i=!1),wn(this,!0));nn.B.A.call(this)};
g.oc=function(){this.isDisposed()||(this.ba||this.u||this.i?xn(this):this.Hd())};
g.Hd=function(){xn(this)};
function xn(a){if(a.f&&"undefined"!=typeof aa)if(a.K[1]&&4==Sm(a)&&2==a.getStatus())qn(a,"Local request error detected and ignored");else if(a.u&&4==Sm(a))zm(a.oc,0,a);else if(um(a,"readystatechange"),4==Sm(a)){qn(a,"Request complete");a.f=!1;try{var b=a.getStatus(),c;a:switch(b){case 200:case 201:case 202:case 204:case 206:case 304:case 1223:c=!0;break a;default:c=!1}var d;if(!(d=c)){var e;if(e=0===b){var f=String(a.D).match(vd)[1]||null;if(!f&&l.self&&l.self.location)var h=l.self.location.protocol,
f=h.substr(0,h.length-1);e=!on.test(f?f.toLowerCase():"")}d=e}if(d)um(a,"complete"),um(a,"success");else{a.j=6;var k;try{k=2<Sm(a)?a.b.statusText:""}catch(m){k=""}a.o=k+" ["+a.getStatus()+"]";vn(a)}}finally{wn(a)}}}
function wn(a,b){if(a.b){tn(a);var c=a.b,d=a.K[0]?t:null;a.b=null;a.K=null;b||um(a,"ready");try{c.onreadystatechange=d}catch(e){}}}
function tn(a){a.b&&a.H&&(a.b.ontimeout=null);ea(a.F)&&(l.clearTimeout(a.F),a.F=null)}
g.isActive=function(){return!!this.b};
function Sm(a){return a.b?a.b.readyState:0}
g.getStatus=function(){try{return 2<Sm(this)?this.b.status:-1}catch(a){return-1}};
function Tm(a){try{return a.b?a.b.responseText:""}catch(b){return""}}
function qn(a,b){return b+" ["+a.ka+" "+a.D+" "+a.getStatus()+"]"}
;function yn(a,b,c){this.l=a||null;this.b=1;this.f=[];this.i=[];this.j=new wm(null,!0);this.u=b||null;this.N=null!=c?c:null}
function zn(a,b){this.b=a;this.map=b;this.context=null}
g=yn.prototype;g.Sa=null;g.T=null;g.G=null;g.Gb=null;g.fb=null;g.Zb=null;g.gb=null;g.Wa=0;g.sd=0;g.M=null;g.ta=null;g.oa=null;g.ya=null;g.sa=null;g.sb=null;g.Ja=-1;g.jc=-1;g.da=-1;g.Ta=0;g.Ia=0;g.xa=8;var An=new tm;function Bn(a){Tl.call(this,"statevent",a)}
y(Bn,Tl);function Cn(a,b){Tl.call(this,"timingevent",a);this.size=b}
y(Cn,Tl);function Dn(a){Tl.call(this,"serverreachability",a)}
y(Dn,Tl);g=yn.prototype;g.connect=function(a,b,c,d,e){X();this.Gb=b;this.Sa=c||{};d&&p(e)&&(this.Sa.OSID=d,this.Sa.OAID=e);this.sa=new gn(this);this.sa.Hb=null;this.sa.f=this.j;this.sa.connect(a)};
function En(a){Fn(a);if(3==a.b){var b=a.Wa++,c=a.fb.clone();N(c,"SID",a.g);N(c,"RID",b);N(c,"TYPE","terminate");Gn(a,c);b=new Lm(a,0,a.g,b,void 0);b.Oa=2;b.ra=Ug(c.clone());(new Image).src=b.ra;b.Ya=x();Rm(b)}Hn(a)}
function Fn(a){if(a.sa){var b=a.sa;b.W&&(b.W.cancel(),b.W=null);b.pa=-1;a.sa=null}a.G&&(a.G.cancel(),a.G=null);a.oa&&(l.clearTimeout(a.oa),a.oa=null);In(a);a.T&&(a.T.cancel(),a.T=null);a.ta&&(l.clearTimeout(a.ta),a.ta=null)}
function Jn(a,b){if(0==a.b)throw Error("Invalid operation: sending map when state is closed");a.f.push(new zn(a.sd++,b));2!=a.b&&3!=a.b||Kn(a)}
g.ic=function(){return 0==this.b};
function Kn(a){a.T||a.ta||(a.ta=an(w(a.uc,a),0),a.Ta=0)}
g.uc=function(a){this.ta=null;Ln(this,a)};
function Ln(a,b){if(1==a.b){if(!b){a.Wa=Math.floor(1E5*Math.random());var c=a.Wa++,d=new Lm(a,0,"",c,void 0);d.Aa=null;var e=Mn(a),f=a.fb.clone();N(f,"RID",c);a.l&&N(f,"CVER",a.l);Gn(a,f);Om(d,f,e);a.T=d;a.b=2}}else 3==a.b&&(b?Nn(a,b):0!=a.f.length&&(a.T||Nn(a)))}
function Nn(a,b){var c,d;b?6<a.xa?(a.f=a.i.concat(a.f),a.i.length=0,c=a.Wa-1,d=Mn(a)):(c=b.u,d=b.Ea):(c=a.Wa++,d=Mn(a));var e=a.fb.clone();N(e,"SID",a.g);N(e,"RID",c);N(e,"AID",a.Ja);Gn(a,e);c=new Lm(a,0,a.g,c,a.Ta+1);c.Aa=null;c.setTimeout(Math.round(1E4)+Math.round(1E4*Math.random()));a.T=c;Om(c,e,d)}
function Gn(a,b){if(a.M){var c=a.M.fc(a);c&&Xa(c,function(a,c){N(b,c,a)})}}
function Mn(a){var b=Math.min(a.f.length,1E3),c=["count="+b],d;6<a.xa&&0<b?(d=a.f[0].b,c.push("ofs="+d)):d=0;for(var e=0;e<b;e++){var f=a.f[e].b,h=a.f[e].map,f=6>=a.xa?e:f-d;try{Qc(h,function(a,b){c.push("req"+f+"_"+b+"="+encodeURIComponent(a))})}catch(k){c.push("req"+f+"_type="+encodeURIComponent("_badmap"))}}a.i=a.i.concat(a.f.splice(0,b));
return c.join("&")}
function On(a){a.G||a.oa||(a.o=1,a.oa=an(w(a.tc,a),0),a.Ia=0)}
function Pn(a){if(a.G||a.oa||3<=a.Ia)return!1;a.o++;a.oa=an(w(a.tc,a),Qn(a,a.Ia));a.Ia++;return!0}
g.tc=function(){this.oa=null;this.G=new Lm(this,0,this.g,"rpc",this.o);this.G.Aa=null;this.G.Jb=0;var a=this.Zb.clone();N(a,"RID","rpc");N(a,"SID",this.g);N(a,"CI",this.sb?"0":"1");N(a,"AID",this.Ja);Gn(this,a);if(!K||kd(10))N(a,"TYPE","xmlhttp"),Qm(this.G,a,!0,this.gb,!1);else{N(a,"TYPE","html");var b=this.G,c=!!this.gb;b.Oa=3;b.ra=Ug(a.clone());$m(b,c)}};
function mn(a,b,c){a.sb=c;a.da=b.pa;a.cd(1,0);a.fb=hn(a,null,a.Gb);Kn(a)}
g.pc=function(a,b){if(0!=this.b&&(this.G==a||this.T==a))if(this.da=a.Va,this.T==a&&3==this.b)if(7<this.xa){var c;try{c=this.j.parse(b)}catch(f){c=null}if(u(c)&&3==c.length)if(0==c[0])a:{if(!this.oa){if(this.G)if(this.G.Ya+3E3<this.T.Ya)In(this),this.G.cancel(),this.G=null;else break a;Pn(this);X()}}else this.jc=c[1],0<this.jc-this.Ja&&37500>c[2]&&this.sb&&0==this.Ia&&!this.ya&&(this.ya=an(w(this.td,this),6E3));else ln(this,11)}else"y2f%"!=b&&ln(this,11);else if(this.G==a&&In(this),!/^[\s\xa0]*$/.test(b)){c=
this.j.parse(b);u(c);for(var d=0;d<c.length;d++){var e=c[d];this.Ja=e[0];e=e[1];2==this.b?"c"==e[0]?(this.g=e[1],this.gb=e[2],e=e[3],null!=e?this.xa=e:this.xa=6,this.b=3,this.M&&this.M.dc(this),this.Zb=hn(this,this.Za()?this.gb:null,this.Gb),On(this)):"stop"==e[0]&&ln(this,7):3==this.b&&("stop"==e[0]?ln(this,7):"noop"!=e[0]&&this.M&&this.M.cc(this,e),this.Ia=0)}}};
g.td=function(){null!=this.ya&&(this.ya=null,this.G.cancel(),this.G=null,Pn(this),X())};
function In(a){null!=a.ya&&(l.clearTimeout(a.ya),a.ya=null)}
g.kb=function(a){var b;if(this.G==a)In(this),this.G=null,b=2;else if(this.T==a)this.T=null,b=1;else return;this.da=a.Va;if(0!=this.b)if(a.fa)1==b?(x(),um(An,new Cn(An,a.Ea?a.Ea.length:0)),Kn(this),this.i.length=0):On(this);else{var c=a.Ba,d;if(!(d=3==c||7==c||0==c&&0<this.da)){if(d=1==b)this.T||this.ta||1==this.b||2<=this.Ta?d=!1:(this.ta=an(w(this.uc,this,a),Qn(this,this.Ta)),this.Ta++,d=!0);d=!(d||2==b&&Pn(this))}if(d)switch(c){case 1:ln(this,5);break;case 4:ln(this,10);break;case 3:ln(this,6);
break;case 7:ln(this,12);break;default:ln(this,2)}}};
function Qn(a,b){var c=5E3+Math.floor(1E4*Math.random());a.isActive()||(c*=2);return c*b}
g.cd=function(a){if(!A(arguments,this.b))throw Error("Unexpected channel state: "+this.b);};
function ln(a,b){if(2==b||9==b){var c=null;a.M&&(c=null);var d=w(a.me,a);c||(c=new Eg("//www.google.com/images/cleardot.gif"),Ug(c));en(c.toString(),1E4,d)}else X();Rn(a,b)}
g.me=function(a){a?X():(X(),Rn(this,8))};
function Rn(a,b){a.b=0;a.M&&a.M.bc(a,b);Hn(a);Fn(a)}
function Hn(a){a.b=0;a.da=-1;if(a.M)if(0==a.i.length&&0==a.f.length)a.M.Ab(a);else{var b=Sa(a.i),c=Sa(a.f);a.i.length=0;a.f.length=0;a.M.Ab(a,b,c)}}
function hn(a,b,c){var d=Vg(c);if(""!=d.f)b&&Gg(d,b+"."+d.f),Hg(d,d.l);else var e=window.location,d=Wg(e.protocol,b?b+"."+e.hostname:e.hostname,e.port,c);a.Sa&&Xa(a.Sa,function(a,b){N(d,b,a)});
N(d,"VER",a.xa);Gn(a,d);return d}
g.Cb=function(a){if(a)throw Error("Can't create secondary domain capable XhrIo object.");a=new nn;a.ia=!1;return a};
g.isActive=function(){return!!this.M&&this.M.isActive(this)};
function an(a,b){if(!fa(a))throw Error("Fn must not be null and must be a function");return l.setTimeout(function(){a()},b)}
g.ea=function(){um(An,new Dn(An))};
function X(){um(An,new Bn(An))}
g.Za=function(){return!(!K||kd(10))};
function Sn(){}
g=Sn.prototype;g.dc=function(){};
g.cc=function(){};
g.bc=function(){};
g.Ab=function(){};
g.fc=function(){return{}};
g.isActive=function(){return!0};function Tn(a,b){xm.call(this);this.o=0;if(fa(a))b&&(a=w(a,b));else if(a&&fa(a.handleEvent))a=w(a.handleEvent,a);else throw Error("Invalid listener argument");this.u=a;im(this,"tick",w(this.l,this));Un(this)}
y(Tn,xm);Tn.prototype.l=function(){if(500<this.b){var a=this.b;24E4>2*a&&(a*=2);ym(this,a)}this.u()};
Tn.prototype.start=function(){Tn.B.start.call(this);this.o=x()+this.b};
Tn.prototype.stop=function(){this.o=0;Tn.B.stop.call(this)};
function Un(a){a.stop();ym(a,5E3+2E4*Math.random())}
;function Vn(a,b){this.F=a;this.o=b;this.g=new F;this.f=new Tn(this.qe,this);this.b=null;this.D=!1;this.j=null;this.N="";this.u=this.i=0;this.l=[]}
y(Vn,Sn);g=Vn.prototype;g.subscribe=function(a,b,c){return this.g.subscribe(a,b,c)};
g.unsubscribe=function(a,b,c){return this.g.unsubscribe(a,b,c)};
g.ha=function(a){return this.g.ha(a)};
g.w=function(a,b){return this.g.w.apply(this.g,arguments)};
g.dispose=function(){this.D||(this.D=!0,this.g.clear(),Wn(this),E(this.g))};
g.isDisposed=function(){return this.D};
function Xn(a){return{firstTestResults:[""],secondTestResults:!a.b.sb,sessionId:a.b.g,arrayId:a.b.Ja}}
g.connect=function(a,b,c){if(!this.b||2!=this.b.b){this.N="";this.f.stop();this.j=a||null;this.i=b||0;a=this.F+"/test";b=this.F+"/bind";var d=new yn("1",c?c.firstTestResults:null,c?c.secondTestResults:null),e=this.b;e&&(e.M=null);d.M=this;this.b=d;e?this.b.connect(a,b,this.o,e.g,e.Ja):c?this.b.connect(a,b,this.o,c.sessionId,c.arrayId):this.b.connect(a,b,this.o)}};
function Wn(a,b){a.u=b||0;a.f.stop();a.b&&(3==a.b.b&&Ln(a.b),En(a.b));a.u=0}
g.sendMessage=function(a,b){var c={_sc:a};b&&kb(c,b);this.f.enabled||2==(this.b?this.b.b:0)?this.l.push(c):Yn(this)&&Jn(this.b,c)};
g.dc=function(){Un(this.f);this.j=null;this.i=0;if(this.l.length){var a=this.l;this.l=[];for(var b=0,c=a.length;b<c;++b)Jn(this.b,a[b])}this.w("handlerOpened")};
g.bc=function(a,b){var c=2==b&&401==this.b.da;if(4!=b&&!c){if(6==b||410==this.b.da)c=this.f,c.stop(),ym(c,500);this.f.start()}this.w("handlerError",b)};
g.Ab=function(a,b,c){if(!this.f.enabled)this.w("handlerClosed");else if(c)for(a=0,b=c.length;a<b;++a){var d=c[a].map;d&&this.l.push(d)}};
g.fc=function(){var a={v:2};this.N&&(a.gsessionid=this.N);0!=this.i&&(a.ui=""+this.i);0!=this.u&&(a.ui=""+this.u);this.j&&kb(a,this.j);return a};
g.cc=function(a,b){"S"==b[0]?this.N=b[1]:"gracefulReconnect"==b[0]?(Un(this.f),this.f.start(),En(this.b)):this.w("handlerMessage",new Rl(b[0],b[1]))};
function Yn(a){return!!a.b&&3==a.b.b}
function Zn(a,b){(a.o.loungeIdToken=b)||a.f.stop()}
g.qe=function(){this.f.stop();var a=this.b,b=0;a.G&&b++;a.T&&b++;0!=b?this.f.start():this.connect(this.j,this.i)};function $n(a){this.index=-1;this.videoId=this.f="";this.volume=this.b=-1;this.o=!1;this.audioTrackId=null;this.j=this.g=0;this.i=null;this.reset(a)}
function ao(a){a.audioTrackId=null;a.i=null;a.b=-1;a.g=0;a.j=x()}
$n.prototype.reset=function(a){this.f="";this.index=-1;this.videoId="";ao(this);this.volume=-1;this.o=!1;a&&(this.index=a.index,this.f=a.listId,this.videoId=a.videoId,this.b=a.playerState,this.volume=a.volume,this.o=a.muted,this.audioTrackId=a.audioTrackId,this.i=a.trackData,this.g=a.playerTime,this.j=a.playerTimeAt)};
function bo(a){switch(a.b){case 1:return(x()-a.j)/1E3+a.g;case -1E3:return 0}return a.g}
function co(a){var b={};b.index=a.index;b.listId=a.f;b.videoId=a.videoId;b.playerState=a.b;b.volume=a.volume;b.muted=a.o;b.audioTrackId=a.audioTrackId;b.trackData=ib(a.i);b.playerTime=a.g;b.playerTimeAt=a.j;return b}
$n.prototype.clone=function(){return new $n(co(this))};function Y(a,b,c){U.call(this);this.i=NaN;this.K=!1;this.D=this.u=this.F=this.H=NaN;this.L=[];this.g=this.C=this.b=null;this.qa=a;this.L.push(M(window,"beforeunload",w(this.jd,this)));this.f=[];this.C=new $n;this.ba=b.id;this.b=eo(this,c);this.b.subscribe("handlerOpened",this.xd,this);this.b.subscribe("handlerClosed",this.ud,this);this.b.subscribe("handlerError",this.vd,this);this.b.subscribe("handlerMessage",this.wd,this);Zn(this.b,b.token);this.subscribe("remoteQueueChange",function(){var a=this.C.videoId;
Fk()&&S("yt-remote-session-video-id",a)},this)}
y(Y,U);g=Y.prototype;g.connect=function(a,b){if(b){var c=b.listId,d=b.videoId,e=b.index,f=b.currentTime||0;5>=f&&(f=0);var h={videoId:d,currentTime:f};c&&(h.listId=c);p(e)&&(h.currentIndex=e);c&&(this.C.f=c);this.C.videoId=d;this.C.index=e||0;this.C.state=3;c=this.C;c.g=f;c.j=x();fo("Connecting with setPlaylist and params: "+L(h));this.b.connect({method:"setPlaylist",params:L(h)},a,Jk())}else fo("Connecting without params"),this.b.connect({},a,Jk());go(this)};
g.dispose=function(){this.isDisposed()||(this.w("beforeDispose"),ho(this,3));Y.B.dispose.call(this)};
g.A=function(){io(this);jo(this);ko(this);I(this.u);this.u=NaN;I(this.D);this.D=NaN;this.g=null;He(this.L);this.L.length=0;this.b.dispose();Y.B.A.call(this);this.f=this.C=this.b=null};
function fo(a){bk("conn",a)}
g.jd=function(){this.j(2)};
function eo(a,b){return new Vn(nk(a.qa,"/bc",void 0,!1),b)}
function ho(a,b){a.w("proxyStateChange",b)}
function go(a){a.i=H(w(function(){fo("Connecting timeout");this.j(1)},a),2E4)}
function io(a){I(a.i);a.i=NaN}
function ko(a){I(a.H);a.H=NaN}
function lo(a){jo(a);a.F=H(w(function(){mo(this,"getNowPlaying")},a),2E4)}
function jo(a){I(a.F);a.F=NaN}
g.xd=function(){fo("Channel opened");this.K&&(this.K=!1,ko(this),this.H=H(w(function(){fo("Timing out waiting for a screen.");this.j(1)},this),15E3));
Nk(Xn(this.b),this.ba)};
g.ud=function(){fo("Channel closed");isNaN(this.i)?Ok(!0):Ok();this.dispose()};
g.vd=function(a){Ok();isNaN(this.l())?(fo("Channel error: "+a+" without reconnection"),this.dispose()):(this.K=!0,fo("Channel error: "+a+" with reconnection in "+this.l()+" ms"),ho(this,2))};
function no(a,b){b&&(io(a),ko(a));b==(Yn(a.b)&&isNaN(a.i))?b&&(ho(a,1),mo(a,"getSubtitlesTrack")):b?(a.X()&&a.C.reset(),ho(a,1),mo(a,"getNowPlaying"),oo(a)):a.j(1)}
function po(a,b){var c=b.params.videoId;delete b.params.videoId;c==a.C.videoId&&(fb(b.params)?a.C.i=null:a.C.i=b.params,a.w("remotePlayerChange"))}
function qo(a,b){var c=b.params.videoId||b.params.video_id,d=parseInt(b.params.currentIndex,10);a.C.f=b.params.listId||a.C.f;var e=a.C,f=e.videoId;e.videoId=c;e.index=d;c!=f&&ao(e);a.w("remoteQueueChange")}
function ro(a,b){b.params=b.params||{};qo(a,b);so(a,b)}
function so(a,b){var c=parseInt(b.params.currentTime||b.params.current_time,10),d=a.C;d.g=isNaN(c)?0:c;d.j=x();c=parseInt(b.params.state,10);c=isNaN(c)?-1:c;-1==c&&-1E3==a.C.b&&(c=-1E3);a.C.b=c;1==a.C.b?lo(a):jo(a);a.w("remotePlayerChange")}
function to(a,b){var c="true"==b.params.muted;a.C.volume=parseInt(b.params.volume,10);a.C.o=c;a.w("remotePlayerChange")}
g.wd=function(a){a.params?fo("Received: action="+a.action+", params="+L(a.params)):fo("Received: action="+a.action+" {}");switch(a.action){case "loungeStatus":a=nd(a.params.devices);this.f=Ja(a,function(a){return new Ak(a)});
a=!!Ma(this.f,function(a){return"LOUNGE_SCREEN"==a.type});
no(this,a);break;case "loungeScreenConnected":no(this,!0);break;case "loungeScreenDisconnected":Qa(this.f,function(a){return"LOUNGE_SCREEN"==a.type});
no(this,!1);break;case "remoteConnected":var b=new Ak(nd(a.params.device));Ma(this.f,function(a){return a.equals(b)})||Oa(this.f,b);
break;case "remoteDisconnected":b=new Ak(nd(a.params.device));Qa(this.f,function(a){return a.equals(b)});
break;case "gracefulDisconnect":break;case "playlistModified":qo(this,a);break;case "nowPlaying":ro(this,a);break;case "onStateChange":so(this,a);break;case "onVolumeChanged":to(this,a);break;case "onSubtitlesTrackChanged":po(this,a);break;default:fo("Unrecognized action: "+a.action)}};
g.ce=function(){if(this.g){var a=this.g;this.g=null;this.C.videoId!=a&&mo(this,"getNowPlaying")}};
Y.prototype.subscribe=Y.prototype.subscribe;Y.prototype.unsubscribeByKey=Y.prototype.ha;Y.prototype.ia=function(){var a=3;this.isDisposed()||(a=0,isNaN(this.l())?Yn(this.b)&&isNaN(this.i)&&(a=1):a=2);return a};
Y.prototype.getProxyState=Y.prototype.ia;Y.prototype.j=function(a){fo("Disconnecting with "+a);io(this);this.w("beforeDisconnect",a);1==a&&Ok();Wn(this.b,a);this.dispose()};
Y.prototype.disconnect=Y.prototype.j;Y.prototype.ca=function(){var a=this.C;if(this.g){var b=a=this.C.clone(),c=this.g,d=a.index,e=b.videoId;b.videoId=c;b.index=d;c!=e&&ao(b)}return co(a)};
Y.prototype.getPlayerContextData=Y.prototype.ca;Y.prototype.la=function(a){var b=new $n(a);b.videoId&&b.videoId!=this.C.videoId&&(this.g=b.videoId,I(this.u),this.u=H(w(this.ce,this),5E3));var c=[];this.C.f==b.f&&this.C.videoId==b.videoId&&this.C.index==b.index||c.push("remoteQueueChange");this.C.b==b.b&&this.C.volume==b.volume&&this.C.o==b.o&&bo(this.C)==bo(b)&&L(this.C.i)==L(b.i)||c.push("remotePlayerChange");this.C.reset(a);z(c,function(a){this.w(a)},this)};
Y.prototype.setPlayerContextData=Y.prototype.la;Y.prototype.X=function(){var a=this.b.o.id,b=Ma(this.f,function(b){return"REMOTE_CONTROL"==b.type&&b.id!=a});
return b?b.id:""};
Y.prototype.getOtherConnectedRemoteId=Y.prototype.X;Y.prototype.l=function(){var a=this.b;return a.f.enabled?a.f.o-x():NaN};
Y.prototype.getReconnectTimeout=Y.prototype.l;Y.prototype.Ga=function(){if(!isNaN(this.l())){var a=this.b.f;a.enabled&&(a.stop(),a.start(),a.l())}};
Y.prototype.reconnect=Y.prototype.Ga;function oo(a){I(a.D);a.D=H(w(a.j,a,1),864E5)}
function mo(a,b,c){c?fo("Sending: action="+b+", params="+L(c)):fo("Sending: action="+b);a.b.sendMessage(b,c)}
Y.prototype.ka=function(a,b){mo(this,a,b);oo(this)};
Y.prototype.sendMessage=Y.prototype.ka;function uo(a){uk.call(this,"ScreenServiceProxy");this.R=a;this.b=[];this.b.push(this.R.$_s("screenChange",w(this.ue,this)));this.b.push(this.R.$_s("onlineScreenChange",w(this.Dd,this)))}
y(uo,uk);g=uo.prototype;g.U=function(a){return this.R.$_gs(a)};
g.contains=function(a){return!!this.R.$_c(a)};
g.get=function(a){return this.R.$_g(a)};
g.start=function(){this.R.$_st()};
g.ub=function(a,b,c){this.R.$_a(a,b,c)};
g.remove=function(a,b,c){this.R.$_r(a,b,c)};
g.rb=function(a,b,c,d){this.R.$_un(a,b,c,d)};
g.A=function(){for(var a=0,b=this.b.length;a<b;++a)this.R.$_ubk(this.b[a]);this.b.length=0;this.R=null;uo.B.A.call(this)};
g.ue=function(){this.w("screenChange")};
g.Dd=function(){this.w("onlineScreenChange")};
V.prototype.$_st=V.prototype.start;V.prototype.$_gspc=V.prototype.ve;V.prototype.$_gsppc=V.prototype.Hc;V.prototype.$_c=V.prototype.contains;V.prototype.$_g=V.prototype.get;V.prototype.$_a=V.prototype.ub;V.prototype.$_un=V.prototype.rb;V.prototype.$_r=V.prototype.remove;V.prototype.$_gs=V.prototype.U;V.prototype.$_gos=V.prototype.Gc;V.prototype.$_s=V.prototype.subscribe;V.prototype.$_ubk=V.prototype.ha;function vo(){var a={device:"Desktop",app:"youtube-desktop"};yj&&xj();Ck();wo||(wo=new mk,Pk()&&(wo.b="/api/loungedev"));xo||(xo=r("yt.mdx.remote.deferredProxies_")||[],q("yt.mdx.remote.deferredProxies_",xo,void 0));yo();var b=zo();if(!b){var c=new V(wo);q("yt.mdx.remote.screenService_",c,void 0);b=zo();wl(c,function(a){a?Ao()&&Pl(Ao(),"YouTube TV"):c.subscribe("onlineScreenChange",function(){J("yt-remote-receiver-availability-change")})},!(!a||!a.loadCastApiSetupScript))}if(a&&!r("yt.mdx.remote.initialized_")){q("yt.mdx.remote.initialized_",
!0,void 0);
Bo("Initializing: "+L(a));Co.push(kc("yt-remote-cast2-availability-change",function(){J("yt-remote-receiver-availability-change")}));
Co.push(kc("yt-remote-cast2-receiver-selected",function(){Do(null);J("yt-remote-auto-connect","cast-selector-receiver")}));
Co.push(kc("yt-remote-cast2-session-change",Eo));Co.push(kc("yt-remote-connection-change",function(a){a?Pl(Ao(),"YouTube TV"):Fo()||(Pl(null,null),Ll())}));
var d=Go();a.isAuto&&(d.id+="#dial");d.name=a.device;d.app=a.app;Bo(" -- with channel params: "+L(d));Ho(d);b.start();Ao()||Io()}}
function Jo(){mc(Co);Co.length=0;E(Ko);Ko=null;xo&&(z(xo,function(a){a(null)}),xo.length=0,xo=null,q("yt.mdx.remote.deferredProxies_",null,void 0));
wo=null}
function Lo(){if(Jl()){var a=[];if(T("yt-remote-cast-available")||r("yt.mdx.remote.cloudview.castButtonShown_")||Mo())a.push({key:"cast-selector-receiver",name:No()}),q("yt.mdx.remote.cloudview.castButtonShown_",!0,void 0);return a}return r("yt.mdx.remote.cloudview.initializing_")?[]:Oo()}
function Oo(){var a;a=zo().R.$_gos();var b=Po();b&&Mo()&&(sk(a,b)||a.push(b));return rk(a)}
function Qo(){if(Jl()){var a=Kl();return a?{key:"cast-selector-receiver",name:a}:null}return Ro()}
function Ro(){var a=Oo(),b=Po();b||(b=Fo());return Ma(a,function(a){return b&&fk(b,a.key)?!0:!1})}
function No(){if(Jl())return Kl();var a=Po();return a?a.name:null}
function Po(){var a=Ao();if(!a)return null;var b=zo().U();return tk(b,a)}
function Eo(a){Bo("remote.onCastSessionChange_: "+jk(a));if(a){var b=Po();b&&b.id==a.id?Pl(b.id,"YouTube TV"):(b&&So(),To(a,1))}else So()}
function Uo(a,b){Bo("Connecting to: "+L(a));if("cast-selector-receiver"==a.key)Do(b||null),Ol(b||null);else{So();Do(b||null);var c=zo().U();(c=tk(c,a.key))?To(c,1):H(function(){Vo(null)},0)}}
function So(){Nl()?Fl().stopSession():Cl("stopSession called before API ready.");var a=Mo();a?a.disconnect(1):(nc("yt-remote-before-disconnect",1),nc("yt-remote-connection-change",!1));Vo(null)}
function Bo(a){bk("remote",a)}
function zo(){if(!Ko){var a=r("yt.mdx.remote.screenService_");Ko=a?new uo(a):null}return Ko}
function Ao(){return r("yt.mdx.remote.currentScreenId_")}
function Wo(a){q("yt.mdx.remote.currentScreenId_",a,void 0)}
function Do(a){q("yt.mdx.remote.connectData_",a,void 0)}
function Mo(){return r("yt.mdx.remote.connection_")}
function Vo(a){var b=Mo();Do(null);a?Mo():Wo("");q("yt.mdx.remote.connection_",a,void 0);xo&&(z(xo,function(b){b(a)}),xo.length=0);
b&&!a?nc("yt-remote-connection-change",!1):!b&&a&&J("yt-remote-connection-change",!0)}
function Fo(){var a=Fk();if(!a)return null;var b=zo().U();return tk(b,a)}
function To(a,b){Ao();Wo(a.id);var c=new Y(wo,a,Go());c.connect(b,r("yt.mdx.remote.connectData_"));c.subscribe("beforeDisconnect",function(a){nc("yt-remote-before-disconnect",a)});
c.subscribe("beforeDispose",function(){Mo()&&(Mo(),Vo(null))});
Vo(c)}
function Io(){var a=Fo();a?(Bo("Resume connection to: "+jk(a)),To(a,0)):(Ok(),Ll(),Bo("Skipping connecting because no session screen found."))}
var wo=null,xo=null,Ko=null;function yo(){var a=Go();if(fb(a)){var a=Ek(),b=T("yt-remote-session-name")||"",c=T("yt-remote-session-app")||"",a={device:"REMOTE_CONTROL",id:a,name:b,app:c,"mdx-version":3};q("yt.mdx.remote.channelParams_",a,void 0)}}
function Go(){return r("yt.mdx.remote.channelParams_")||{}}
function Ho(a){a?(S("yt-remote-session-app",a.app),S("yt-remote-session-name",a.name)):(Aj("yt-remote-session-app"),Aj("yt-remote-session-name"));q("yt.mdx.remote.channelParams_",a,void 0)}
var Co=[];var Xo=null,Yo=[];function Zo(){$o();if(Qo()){var a=Xo;"html5"!=a.getPlayerType()&&a.loadNewVideoConfig(a.getCurrentVideoConfig(),"html5")}}
function ap(a){"cast-selector-receiver"==a?Ml():bp(a)}
function bp(a){var b=Lo();if(a=qk(b,a)){var c=Xo;Uo(a,{listId:c.getVideoData().list,videoId:c.getVideoData().video_id,currentTime:c.getCurrentTime()});"html5"!=c.getPlayerType()?c.loadNewVideoConfig(c.getCurrentVideoConfig(),"html5"):c.updateRemoteReceivers&&c.updateRemoteReceivers(b,a)}}
function $o(){var a=Xo;a&&a.updateRemoteReceivers&&a.updateRemoteReceivers(Lo(),Qo())}
;var cp=null,dp=[];function ep(a){return{externalChannelId:a.externalChannelId,rd:!!a.isChannelPaid,source:a.source,subscriptionId:a.subscriptionId}}
function fp(a){gp(ep(a))}
function gp(a){Ki()?(Q(xi,new ri(a.externalChannelId,a.rd?{itemType:"U",itemId:a.externalChannelId}:null)),(a="/gen_204?"+Cd({event:"subscribe",source:a.source}))&&gh(a)):hp(a)}
function hp(a){Ji(function(b){b.subscription_ajax&&gp(a)},null)}
function ip(a){a=ep(a);Q(Ci,new ti(a.externalChannelId,a.subscriptionId,null));(a="/gen_204?"+Cd({event:"unsubscribe",source:a.source}))&&gh(a)}
function jp(a){cp&&cp.channelSubscribed(a.b,a.subscriptionId)}
function kp(a){cp&&cp.channelUnsubscribed(a.b)}
;function lp(a){D.call(this);this.f=a;this.f.subscribe("command",this.yc,this);this.g={};this.i=!1}
y(lp,D);g=lp.prototype;g.start=function(){this.i||this.isDisposed()||(this.i=!0,mp(this.f,"RECEIVING"))};
g.yc=function(a,b){if(this.i&&!this.isDisposed()){var c=b||{};switch(a){case "addEventListener":if(v(c.event)&&(c=c.event,!(c in this.g))){var d=w(this.ee,this,c);this.g[c]=d;this.addEventListener(c,d)}break;case "removeEventListener":v(c.event)&&np(this,c.event);break;default:this.b.isReady()&&this.b[a]&&(c=op(a,b||{}),c=this.b[a].apply(this.b,c),(c=pp(a,c))&&this.i&&!this.isDisposed()&&mp(this.f,a,c))}}};
g.ee=function(a,b){this.i&&!this.isDisposed()&&mp(this.f,a,this.Db(a,b))};
g.Db=function(a,b){if(null!=b)return{value:b}};
function np(a,b){b in a.g&&(a.removeEventListener(b,a.g[b]),delete a.g[b])}
g.A=function(){this.f.unsubscribe("command",this.yc,this);this.f=null;for(var a in this.g)np(this,a);lp.B.A.call(this)};function qp(a,b){lp.call(this,b);this.b=a;this.start()}
y(qp,lp);qp.prototype.addEventListener=function(a,b){this.b.addEventListener(a,b)};
qp.prototype.removeEventListener=function(a,b){this.b.removeEventListener(a,b)};
function op(a,b){switch(a){case "loadVideoById":return b=Fj(b),Hj(b),[b];case "cueVideoById":return b=Fj(b),Hj(b),[b];case "loadVideoByPlayerVars":return Hj(b),[b];case "cueVideoByPlayerVars":return Hj(b),[b];case "loadPlaylist":return b=Gj(b),Hj(b),[b];case "cuePlaylist":return b=Gj(b),Hj(b),[b];case "seekTo":return[b.seconds,b.allowSeekAhead];case "playVideoAt":return[b.index];case "setVolume":return[b.volume];case "setPlaybackQuality":return[b.suggestedQuality];case "setPlaybackRate":return[b.suggestedRate];
case "setLoop":return[b.loopPlaylists];case "setShuffle":return[b.shufflePlaylist];case "getOptions":return[b.module];case "getOption":return[b.module,b.option];case "setOption":return[b.module,b.option,b.value];case "handleGlobalKeyDown":return[b.keyCode,b.shiftKey]}return[]}
function pp(a,b){switch(a){case "isMuted":return{muted:b};case "getVolume":return{volume:b};case "getPlaybackRate":return{playbackRate:b};case "getAvailablePlaybackRates":return{availablePlaybackRates:b};case "getVideoLoadedFraction":return{videoLoadedFraction:b};case "getPlayerState":return{playerState:b};case "getCurrentTime":return{currentTime:b};case "getPlaybackQuality":return{playbackQuality:b};case "getAvailableQualityLevels":return{availableQualityLevels:b};case "getDuration":return{duration:b};
case "getVideoUrl":return{videoUrl:b};case "getVideoEmbedCode":return{videoEmbedCode:b};case "getPlaylist":return{playlist:b};case "getPlaylistIndex":return{playlistIndex:b};case "getOptions":return{options:b};case "getOption":return{option:b}}}
qp.prototype.Db=function(a,b){switch(a){case "onReady":return;case "onStateChange":return{playerState:b};case "onPlaybackQualityChange":return{playbackQuality:b};case "onPlaybackRateChange":return{playbackRate:b};case "onError":return{errorCode:b}}return qp.B.Db.call(this,a,b)};
qp.prototype.A=function(){qp.B.A.call(this);delete this.b};function rp(){var a=this.f=new ij,b=w(this.ae,this);a.f=b;a.g=null;this.f.channel="widget";if(a=G("WIDGET_ID"))this.f.i=a;this.i=[];this.o=!1;this.j={}}
g=rp.prototype;g.ae=function(a,b){if("addEventListener"==a&&b){var c=b[0];this.j[c]||"onReady"==c||(this.addEventListener(c,sp(this,c)),this.j[c]=!0)}else this.Kc(a,b)};
g.Kc=function(){};
function sp(a,b){return w(function(a){this.sendMessage(b,a)},a)}
g.addEventListener=function(){};
g.ed=function(){this.o=!0;this.sendMessage("initialDelivery",this.Eb());this.sendMessage("onReady");z(this.i,this.Lc,this);this.i=[]};
g.Eb=function(){return null};
function tp(a,b){a.sendMessage("infoDelivery",b)}
g.Lc=function(a){this.o?this.f.sendMessage(a):this.i.push(a)};
g.sendMessage=function(a,b){this.Lc({event:a,info:void 0==b?null:b})};
g.dispose=function(){this.f=null};function up(a){rp.call(this);this.b=a;this.g=[];this.addEventListener("onReady",w(this.Id,this));this.addEventListener("onVideoProgress",w(this.ie,this));this.addEventListener("onVolumeChange",w(this.je,this));this.addEventListener("onApiChange",w(this.de,this));this.addEventListener("onPlaybackQualityChange",w(this.fe,this));this.addEventListener("onPlaybackRateChange",w(this.ge,this));this.addEventListener("onStateChange",w(this.he,this))}
y(up,rp);g=up.prototype;g.Kc=function(a,b){if(this.b[a]){b=b||[];if(0<b.length&&Dj(a)){var c;c=b;if(ga(c[0])&&!u(c[0]))c=c[0];else{var d={};switch(a){case "loadVideoById":case "cueVideoById":d=Fj.apply(window,c);break;case "loadVideoByUrl":case "cueVideoByUrl":d=Ej.apply(window,c);break;case "loadPlaylist":case "cuePlaylist":d=Gj.apply(window,c)}c=d}Hj(c);b.length=1;b[0]=c}this.b[a].apply(this.b,b);Dj(a)&&tp(this,this.Eb())}};
g.Id=function(){var a=w(this.ed,this);this.f.b=a};
g.addEventListener=function(a,b){this.g.push({eventType:a,listener:b});this.b.addEventListener(a,b)};
g.Eb=function(){if(!this.b)return null;var a=this.b.getApiInterface();Pa(a,"getVideoData");for(var b={apiInterface:a},c=0,d=a.length;c<d;c++){var e=a[c],f=e;if(0==f.search("get")||0==f.search("is")){var f=e,h=0;0==f.search("get")?h=3:0==f.search("is")&&(h=2);f=f.charAt(h).toLowerCase()+f.substr(h+1);try{var k=this.b[e]();b[f]=k}catch(m){}}}b.videoData=this.b.getVideoData();return b};
g.he=function(a){a={playerState:a,currentTime:this.b.getCurrentTime(),duration:this.b.getDuration(),videoData:this.b.getVideoData(),videoStartBytes:0,videoBytesTotal:this.b.getVideoBytesTotal(),videoLoadedFraction:this.b.getVideoLoadedFraction(),playbackQuality:this.b.getPlaybackQuality(),availableQualityLevels:this.b.getAvailableQualityLevels(),videoUrl:this.b.getVideoUrl(),playlist:this.b.getPlaylist(),playlistIndex:this.b.getPlaylistIndex()};this.b.getProgressState&&(a.progressState=this.b.getProgressState());
this.b.getStoryboardFormat&&(a.storyboardFormat=this.b.getStoryboardFormat());tp(this,a)};
g.fe=function(a){tp(this,{playbackQuality:a})};
g.ge=function(a){tp(this,{playbackRate:a})};
g.de=function(){for(var a=this.b.getOptions(),b={namespaces:a},c=0,d=a.length;c<d;c++){var e=a[c],f=this.b.getOptions(e);b[e]={options:f};for(var h=0,k=f.length;h<k;h++){var m=f[h],n=this.b.getOption(e,m);b[e][m]=n}}this.sendMessage("apiInfoDelivery",b)};
g.je=function(){tp(this,{muted:this.b.isMuted(),volume:this.b.getVolume()})};
g.ie=function(a){a={currentTime:a,videoBytesLoaded:this.b.getVideoBytesLoaded(),videoLoadedFraction:this.b.getVideoLoadedFraction()};this.b.getProgressState&&(a.progressState=this.b.getProgressState());tp(this,a)};
g.dispose=function(){up.B.dispose.call(this);for(var a=0;a<this.g.length;a++){var b=this.g[a];this.b.removeEventListener(b.eventType,b.listener)}this.g=[]};function vp(a,b,c){U.call(this);this.b=a;this.f=b;this.g=c}
y(vp,U);function mp(a,b,c){if(!a.isDisposed()){var d=a.b,e=a.f;a=a.g;d.isDisposed()||e!=d.b||(b={id:a,command:b},c&&(b.data=c),d.b.postMessage(L(b),d.g))}}
vp.prototype.A=function(){this.f=this.b=null;vp.B.A.call(this)};function wp(a,b,c){D.call(this);this.b=a;this.g=c;this.i=M(window,"message",w(this.j,this));this.f=new vp(this,a,b);Ub(this,ma(E,this.f))}
y(wp,D);wp.prototype.j=function(a){var b;if(b=!this.isDisposed())if(b=a.origin==this.g)a:{b=this.b;do{var c;b:{c=a.source;do{if(c==b){c=!0;break b}if(c==c.parent)break;c=c.parent}while(null!=c);c=!1}if(c){b=!0;break a}b=b.opener}while(null!=b);b=!1}if(b&&(c=a.data,v(c))){try{c=nd(c)}catch(d){return}c.command&&(a=this.f,b=c.command,c=c.data,a.isDisposed()||a.w("command",b,c))}};
wp.prototype.A=function(){He(this.i);this.b=null;wp.B.A.call(this)};var xp=!1;function yp(a){if(a=a.match(/[\d]+/g))a.length=3}
(function(){if(navigator.plugins&&navigator.plugins.length){var a=navigator.plugins["Shockwave Flash"];if(a&&(xp=!0,a.description)){yp(a.description);return}if(navigator.plugins["Shockwave Flash 2.0"]){xp=!0;return}}if(navigator.mimeTypes&&navigator.mimeTypes.length&&(a=navigator.mimeTypes["application/x-shockwave-flash"],xp=!(!a||!a.enabledPlugin))){yp(a.enabledPlugin.description);return}try{var b=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");xp=!0;yp(b.GetVariable("$version"));return}catch(c){}try{b=
new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");xp=!0;return}catch(c){}try{b=new ActiveXObject("ShockwaveFlash.ShockwaveFlash"),xp=!0,yp(b.GetVariable("$version"))}catch(c){}})();function zp(a){return(a=a.exec(lb))?a[1]:""}
(function(){if(kf)return zp(/Firefox\/([0-9.]+)/);if(K||Yc||Xc)return hd;if(of)return zp(/Chrome\/([0-9.]+)/);if(pf&&!(Wc()||B("iPad")||B("iPod")))return zp(/Version\/([0-9.]+)/);if(lf||mf){var a=/Version\/(\S+).*Mobile\/(\S+)/.exec(lb);if(a)return a[1]+"."+a[2]}else if(nf)return(a=zp(/Android\s+([0-9.]+)/))?a:zp(/Version\/([0-9.]+)/);return""})();function Ap(){var a=Bp;return new $f(function(b,c){a.$=function(a){Jd(a)?b(a):c(a)};
a.onError=c;a.Da=c;Od("//googleads.g.doubleclick.net/pagead/id",a)})}
;function Cp(a,b){this.f=a;this.b=b}
Cp.prototype.then=function(a,b,c){try{if(p(this.f))return a?eg(a.call(c,this.f)):eg(this.f);if(p(this.b)){if(!b)return fg(this.b);var d=b.call(c,this.b);return!p(d)&&this.b instanceof hg?fg(this.b):eg(d)}throw Error("Invalid Result_ state");}catch(e){return fg(e)}};
Zf(Cp);var Bp={format:"RAW",method:"GET",timeout:5E3,withCredentials:!0},Dp=null;function Ep(a){a=a.responseText;if(0!=a.lastIndexOf(")]}'",0))return Fp(""),Dp=new Cp(""),"";a=JSON.parse(a.substr(4)).id;Fp(a);Dp=new Cp(a);Gp(18E5,2);return a}
function Hp(a){var b=Error("Unable to load /pagead/id");Fp("");Dp=new Cp(void 0,b);0<a&&Gp(12E4,a-1);throw b;}
function Gp(a,b){H(function(){var a=w(Hp,l,b);Ap().then(Ep,a)},a)}
function Fp(a){q("yt.www.ads.biscotti.lastId_",a,void 0)}
;function Ip(){}
;function Jp(a){for(var b=0;b<a.length;b++){var c=a[b];"send_follow_on_ping_action"==c.name&&c.data&&c.data.follow_on_url&&(c=c.data.follow_on_url)&&gh(c)}}
;function Kp(a){O.call(this,1,arguments);this.zb=a}
y(Kp,O);function Lp(a,b){O.call(this,2,arguments);this.f=a;this.b=b}
y(Lp,O);function Mp(a,b,c,d){O.call(this,1,arguments);this.b=b;this.f=c||null;this.itemId=d||null}
y(Mp,O);function Np(a,b){O.call(this,1,arguments);this.f=a;this.b=b||null}
y(Np,O);function Op(a){O.call(this,1,arguments)}
y(Op,O);var Pp=new P("ypc-core-load",Kp),Qp=new P("ypc-guide-sync-success",Lp),Rp=new P("ypc-purchase-success",Mp),Sp=new P("ypc-subscription-cancel",Op),Tp=new P("ypc-subscription-cancel-success",Np),Up=new P("ypc-init-subscription",Op);var Vp=!1,Wp=[],Xp=[];function Yp(a){a.b?Vp?Q(Bi,a):Q(Pp,new Kp(function(){Q(Up,new Op(a.b))})):Zp(a.f,a.i,a.g,a.source)}
function $p(a){a.b?Vp?Q(Gi,a):Q(Pp,new Kp(function(){Q(Sp,new Op(a.b))})):aq(a.f,a.subscriptionId,a.i,a.g,a.source)}
function bq(a){cq(Sa(a.b))}
function dq(a){eq(Sa(a.b))}
function fq(a){gq(a.b,a.isEnabled,null)}
function hq(a,b,c,d){gq(a,b,c,d)}
function iq(a){var b=a.itemId,c=a.b.subscriptionId;b&&c&&Q(Ai,new si(b,c,a.b.channelInfo))}
function jq(a){var b=a.b;Xa(a.f,function(a,d){Q(Ai,new si(d,a,b[d]))})}
function kq(a){Q(Fi,new pi(a.f.itemId));a.b&&a.b.length&&(lq(a.b,Fi),lq(a.b,Hi))}
function Zp(a,b,c,d){var e=new pi(a);Q(yi,e);var f={};f.c=a;c&&(f.eurl=c);d&&(f.source=d);c={};(d=G("PLAYBACK_ID"))&&(c.plid=d);(d=G("EVENT_ID"))&&(c.ei=d);b&&mq(b,c);Od("/subscription_ajax?action_create_subscription_to_channel=1",{method:"POST",Rb:f,S:c,$:function(b,c){var d=c.response;Q(Ai,new si(a,d.id,d.channel_info));d.show_feed_privacy_dialog&&J("SHOW-FEED-PRIVACY-SUBSCRIBE-DIALOG",a);d.actions&&Jp(d.actions)},
Nb:function(){Q(zi,e)}})}
function aq(a,b,c,d,e){var f=new pi(a);Q(Di,f);var h={};d&&(h.eurl=d);e&&(h.source=e);d={};d.c=a;d.s=b;(a=G("PLAYBACK_ID"))&&(d.plid=a);(a=G("EVENT_ID"))&&(d.ei=a);c&&mq(c,d);Od("/subscription_ajax?action_remove_subscriptions=1",{method:"POST",Rb:h,S:d,$:function(a,b){var c=b.response;Q(Fi,f);c.actions&&Jp(c.actions)},
Nb:function(){Q(Ei,f)}})}
function gq(a,b,c,d){if(null!==b||null!==c){var e={};a&&(e.channel_id=a);null===b||(e.email_on_upload=b);null===c||(e.receive_no_updates=c);Od("/subscription_ajax?action_update_subscription_preferences=1",{method:"POST",S:e,onError:function(){d&&d()}})}}
function cq(a){if(a.length){var b=Ua(a,0,40);Q("subscription-batch-subscribe-loading");lq(b,yi);var c={};c.a=b.join(",");var d=function(){Q("subscription-batch-subscribe-loaded");lq(b,zi)};
Od("/subscription_ajax?action_create_subscription_to_all=1",{method:"POST",S:c,$:function(c,f){d();var h=f.response,k=h.id;if(u(k)&&k.length==b.length){var m=h.channel_info_map;z(k,function(a,c){var d=b[c];Q(Ai,new si(d,a,m[d]))});
a.length?cq(a):Q("subscription-batch-subscribe-finished")}},
onError:function(){d();Q("subscription-batch-subscribe-failure")}})}}
function eq(a){if(a.length){var b=Ua(a,0,40);Q("subscription-batch-unsubscribe-loading");lq(b,Di);var c={};c.c=b.join(",");var d=function(){Q("subscription-batch-unsubscribe-loaded");lq(b,Ei)};
Od("/subscription_ajax?action_remove_subscriptions=1",{method:"POST",S:c,$:function(){d();lq(b,Fi);a.length&&eq(a)},
onError:function(){d()}})}}
function lq(a,b){z(a,function(a){Q(b,new pi(a))})}
function mq(a,b){var c=Fd(a),d;for(d in c)b[d]=c[d]}
;var nq,oq=null,pq=null,qq=null,rq=!1;
function sq(){var a=G("PLAYER_CONFIG",void 0),b=G("REVERSE_MOBIUS_PERCENT",void 0);if("1"!=a.privembed&&Sf&&100*Math.random()<b||Yf("enable_server_side_ad_request_for_embeds"))try{var c;try{var d=r("yt.www.ads.biscotti.getId_"),e;if(d)e=d();else{if(!Dp){var f=w(Hp,l,2);Dp=Ap().then(Ep,f)}e=Dp}c=e}catch(h){c=fg(h)}gg(c,null,Ip,void 0)}catch(h){bc(h)}if(G("REQUEST_POST_MESSAGE_ORIGIN")){if(!nq){nq=new ij;nq.b=sq;return}nq.origin&&"*"!=nq.origin&&(a.args.post_message_origin=nq.origin)}d=document.referrer;
b=G("POST_MESSAGE_ORIGIN");c=!1;Yf("legacy_cast2")&&v(d)&&v(b)&&-1<d.indexOf(b)&&dh(b)&&dh(d)&&(c=!0);window!=window.top&&d&&d!=document.URL&&(a.args.loaderUrl=d);G("LIGHTWEIGHT_AUTOPLAY")&&(a.args.autoplay="1");a.args.autoplay&&Hj(a.args);oq=ci("player",a);d=G("POST_MESSAGE_ID","player");G("ENABLE_JS_API")?qq=new up(oq):G("ENABLE_POST_API")&&v(d)&&v(b)&&(pq=new wp(window.parent,d,b),qq=new qp(oq,pq.f));Yf("legacy_cast2")&&((rq=c&&!G("ENABLE_CAST_API"))?a.args.disableCast="1":(a=oq,vo(),Xo=a,Xo.addEventListener("onReady",
Zo),Xo.addEventListener("onRemoteReceiverSelected",ap),Yo.push(kc("yt-remote-receiver-availability-change",$o)),Yo.push(kc("yt-remote-auto-connect",bp))));G("BG_P")&&(G("BG_I")||G("BG_IU"))&&zc();Yd();cp=oq;cp.addEventListener("SUBSCRIBE",fp);cp.addEventListener("UNSUBSCRIBE",ip);dp.push(oh(Ai,jp),oh(Fi,kp))}
;q("yt.setConfig",Zb,void 0);q("yt.setMsg",function(a){$b(Yb,arguments)},void 0);
q("yt.logging.errors.log",function(a,b,c,d,e){c={name:c||G("INNERTUBE_CONTEXT_CLIENT_NAME","WEB"),version:d||G("INNERTUBE_CONTEXT_CLIENT_VERSION",void 0)};e=window&&window.yterr||e;if(a&&e&&!(5<=Ud)){e=a.stacktrace;d=a.columnNumber;var f=r("window.location.href");if(v(a))a={message:a,name:"Unknown error",lineNumber:"Not available",fileName:f,stack:"Not available"};else{var h,k,m=!1;try{h=a.lineNumber||a.Qe||"Not available"}catch(ua){h="Not available",m=!0}try{k=a.fileName||a.filename||a.sourceURL||
l.$googDebugFname||f}catch(ua){k="Not available",m=!0}a=!m&&a.lineNumber&&a.fileName&&a.stack&&a.message&&a.name?a:{message:a.message||"Not available",name:a.name||"UnknownError",lineNumber:h,fileName:k,stack:a.stack||"Not available"}}e=e||a.stack;h=a.lineNumber.toString();isNaN(h)||isNaN(d)||(h=h+":"+d);if(!(Td[a.message]||0<=e.indexOf("/YouTubeCenter.js")||0<=e.indexOf("/mytube.js"))){b={Rb:{a:"logerror",t:"jserror",type:a.name,msg:a.message.substr(0,1E3),line:h,level:b||"ERROR"},S:{url:G("PAGE_NAME",
window.location.href),file:a.fileName},method:"POST"};e&&(b.S.stack=e);for(var n in c)b.S["client."+n]=c[n];if(n=G("LATEST_ECATCHER_SERVICE_TRACKING_PARAMS",void 0))for(var Z in n)b.S[Z]=n[Z];Od("/error_204",b);Td[a.message]=!0;Ud++}}},void 0);
q("writeEmbed",sq,void 0);q("yt.www.watch.ads.restrictioncookie.spr",function(a){(a+="mac_204?action_fcts=1")&&gh(a);return!0},void 0);
var tq=ac(function(){zh("ol");Vp=!0;Xp.push(oh(xi,Yp),oh(Ci,$p));Vp||(Xp.push(oh(Bi,Yp),oh(Gi,$p),oh(ui,bq),oh(vi,dq),oh(wi,fq)),Wp.push(kc("subscription-prefs",hq)),Xp.push(oh(Rp,iq),oh(Tp,kq),oh(Qp,jq)));qf.getInstance();var a=1<window.devicePixelRatio;if(vf(0,119)!=a){var b="f"+(Math.floor(119/31)+1),c=uf(b)||0,c=a?c|67108864:c&-67108865;0==c?delete rf[b]:(a=c.toString(16),rf[b]=a.toString());var b=[],d;for(d in rf)b.push(d+"="+escape(rf[d]));Qe("PREF",b.join("&"),63072E3)}}),uq=ac(function(){var a=
oq;
a&&a.sendAbandonmentPing&&a.sendAbandonmentPing();G("PL_ATT")&&(yc=null);for(var a=0,b=Wd.length;a<b;a++){var c=Wd[a];if(!isNaN(c)){var d=r("yt.scheduler.instance.cancelJob");d?d(c):I(c)}}Wd.length=0;a=uc("//static.doubleclick.net/instream/ad_status.js");if(b=document.getElementById(a))pc(a),b.parentNode.removeChild(b);Xd=!1;Zb("DCLKSTAT",0);mc(Wp);Wp.length=0;ph(Xp);Xp.length=0;Vp=!1;cp&&(cp.removeEventListener("SUBSCRIBE",gp),cp.removeEventListener("UNSUBSCRIBE",ip));cp=null;ph(dp);dp.length=0;
Yf("legacy_cast2")&&!rq&&(mc(Yo),Yo.length=0,Xo&&(Xo.removeEventListener("onRemoteReceiverSelected",ap),Xo.removeEventListener("onReady",Zo),Xo=null),Jo());Vb(qq,pq);oq&&oq.destroy()});
window.addEventListener?(window.addEventListener("load",tq),window.addEventListener("unload",uq)):window.attachEvent&&(window.attachEvent("onload",tq),window.attachEvent("onunload",uq));var vq=cj.getInstance(),wq=R(vq);wq in hj||(vq.register(),vq.mb.push(kc("yt-uix-init-"+wq,vq.init,vq)),vq.mb.push(kc("yt-uix-dispose-"+wq,vq.dispose,vq)),hj[wq]=vq);})();
