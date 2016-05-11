(function(){var g,aa=aa||{},m=this;function p(a){return void 0!==a}
function q(a,b,c){a=a.split(".");c=c||m;a[0]in c||!c.execScript||c.execScript("var "+a[0]);for(var d;a.length&&(d=a.shift());)!a.length&&p(b)?c[d]=b:c[d]?c=c[d]:c=c[d]={}}
function r(a,b){for(var c=a.split("."),d=b||m,e;e=c.shift();)if(null!=d[e])d=d[e];else return null;return d}
function t(){}
function ba(a){a.getInstance=function(){return a.W?a.W:a.W=new a}}
function da(a){var b=typeof a;if("object"==b)if(a){if(a instanceof Array)return"array";if(a instanceof Object)return b;var c=Object.prototype.toString.call(a);if("[object Window]"==c)return"object";if("[object Array]"==c||"number"==typeof a.length&&"undefined"!=typeof a.splice&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("splice"))return"array";if("[object Function]"==c||"undefined"!=typeof a.call&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("call"))return"function"}else return"null";
else if("function"==b&&"undefined"==typeof a.call)return"object";return b}
function ea(a){return"array"==da(a)}
function fa(a){var b=da(a);return"array"==b||"object"==b&&"number"==typeof a.length}
function u(a){return"string"==typeof a}
function ga(a){return"number"==typeof a}
function ha(a){return"function"==da(a)}
function ia(a){var b=typeof a;return"object"==b&&null!=a||"function"==b}
function ka(a){return a[la]||(a[la]=++ma)}
var la="closure_uid_"+(1E9*Math.random()>>>0),ma=0;function na(a,b,c){return a.call.apply(a.bind,arguments)}
function oa(a,b,c){if(!a)throw Error();if(2<arguments.length){var d=Array.prototype.slice.call(arguments,2);return function(){var c=Array.prototype.slice.call(arguments);Array.prototype.unshift.apply(c,d);return a.apply(b,c)}}return function(){return a.apply(b,arguments)}}
function v(a,b,c){v=Function.prototype.bind&&-1!=Function.prototype.bind.toString().indexOf("native code")?na:oa;return v.apply(null,arguments)}
function pa(a,b){var c=Array.prototype.slice.call(arguments,1);return function(){var b=c.slice();b.push.apply(b,arguments);return a.apply(this,b)}}
var w=Date.now||function(){return+new Date};
function x(a,b){function c(){}
c.prototype=b.prototype;a.I=b.prototype;a.prototype=new c;a.prototype.constructor=a;a.base=function(a,c,f){for(var h=Array(arguments.length-2),k=2;k<arguments.length;k++)h[k-2]=arguments[k];return b.prototype[c].apply(a,h)}}
;function qa(a){if(Error.captureStackTrace)Error.captureStackTrace(this,qa);else{var b=Error().stack;b&&(this.stack=b)}a&&(this.message=String(a))}
x(qa,Error);qa.prototype.name="CustomError";var ra;var ta=String.prototype.trim?function(a){return a.trim()}:function(a){return a.replace(/^[\s\xa0]+|[\s\xa0]+$/g,"")};
function ua(a){return decodeURIComponent(a.replace(/\+/g," "))}
var va=/&/g,wa=/</g,xa=/>/g,ya=/"/g,za=/'/g,Aa=/\x00/g,Ba=/[\x00&<>"']/;function Ca(a){return-1!=a.indexOf("&")?"document"in m?Da(a):Ea(a):a}
function Da(a){var b={"&amp;":"&","&lt;":"<","&gt;":">","&quot;":'"'},c;c=m.document.createElement("div");return a.replace(Fa,function(a,e){var f=b[a];if(f)return f;if("#"==e.charAt(0)){var h=Number("0"+e.substr(1));isNaN(h)||(f=String.fromCharCode(h))}f||(c.innerHTML=a+" ",f=c.firstChild.nodeValue.slice(0,-1));return b[a]=f})}
function Ea(a){return a.replace(/&([^;]+);/g,function(a,c){switch(c){case "amp":return"&";case "lt":return"<";case "gt":return">";case "quot":return'"';default:if("#"==c.charAt(0)){var d=Number("0"+c.substr(1));if(!isNaN(d))return String.fromCharCode(d)}return a}})}
var Fa=/&([^;\s<&]+);?/g,Ga={"\x00":"\\0","\b":"\\b","\f":"\\f","\n":"\\n","\r":"\\r","\t":"\\t","\x0B":"\\x0B",'"':'\\"',"\\":"\\\\","<":"<"},Ha={"'":"\\'"};
function Ia(a,b){for(var c=0,d=ta(String(a)).split("."),e=ta(String(b)).split("."),f=Math.max(d.length,e.length),h=0;0==c&&h<f;h++){var k=d[h]||"",l=e[h]||"",n=RegExp("(\\d*)(\\D*)","g"),H=RegExp("(\\d*)(\\D*)","g");do{var ca=n.exec(k)||["","",""],sa=H.exec(l)||["","",""];if(0==ca[0].length&&0==sa[0].length)break;c=Ja(0==ca[1].length?0:parseInt(ca[1],10),0==sa[1].length?0:parseInt(sa[1],10))||Ja(0==ca[2].length,0==sa[2].length)||Ja(ca[2],sa[2])}while(0==c)}return c}
function Ja(a,b){return a<b?-1:a>b?1:0}
function Ka(a){for(var b=0,c=0;c<a.length;++c)b=31*b+a.charCodeAt(c)>>>0;return b}
;function La(){}
;var Ma=Array.prototype.indexOf?function(a,b,c){return Array.prototype.indexOf.call(a,b,c)}:function(a,b,c){c=null==c?0:0>c?Math.max(0,a.length+c):c;
if(u(a))return u(b)&&1==b.length?a.indexOf(b,c):-1;for(;c<a.length;c++)if(c in a&&a[c]===b)return c;return-1},y=Array.prototype.forEach?function(a,b,c){Array.prototype.forEach.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=u(a)?a.split(""):a,f=0;f<d;f++)f in e&&b.call(c,e[f],f,a)},Na=Array.prototype.filter?function(a,b,c){return Array.prototype.filter.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=[],f=0,h=u(a)?a.split(""):a,k=0;k<d;k++)if(k in h){var l=h[k];
b.call(c,l,k,a)&&(e[f++]=l)}return e},z=Array.prototype.map?function(a,b,c){return Array.prototype.map.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=Array(d),f=u(a)?a.split(""):a,h=0;h<d;h++)h in f&&(e[h]=b.call(c,f[h],h,a));
return e},Oa=Array.prototype.some?function(a,b,c){return Array.prototype.some.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=u(a)?a.split(""):a,f=0;f<d;f++)if(f in e&&b.call(c,e[f],f,a))return!0;
return!1},Pa=Array.prototype.every?function(a,b,c){return Array.prototype.every.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=u(a)?a.split(""):a,f=0;f<d;f++)if(f in e&&!b.call(c,e[f],f,a))return!1;
return!0};
function Qa(a,b,c){b=Ra(a,b,c);return 0>b?null:u(a)?a.charAt(b):a[b]}
function Ra(a,b,c){for(var d=a.length,e=u(a)?a.split(""):a,f=0;f<d;f++)if(f in e&&b.call(c,e[f],f,a))return f;return-1}
function A(a,b){return 0<=Ma(a,b)}
function Sa(){var a=Ta;if(!ea(a))for(var b=a.length-1;0<=b;b--)delete a[b];a.length=0}
function Ua(a,b){A(a,b)||a.push(b)}
function Va(a,b){var c=Ma(a,b),d;(d=0<=c)&&Array.prototype.splice.call(a,c,1);return d}
function Wa(a,b){var c=Ra(a,b,void 0);0<=c&&Array.prototype.splice.call(a,c,1)}
function Xa(a){return Array.prototype.concat.apply(Array.prototype,arguments)}
function Ya(a){var b=a.length;if(0<b){for(var c=Array(b),d=0;d<b;d++)c[d]=a[d];return c}return[]}
function Za(a,b){for(var c=1;c<arguments.length;c++){var d=arguments[c];if(fa(d)){var e=a.length||0,f=d.length||0;a.length=e+f;for(var h=0;h<f;h++)a[e+h]=d[h]}else a.push(d)}}
function $a(a,b,c,d){return Array.prototype.splice.apply(a,ab(arguments,1))}
function ab(a,b,c){return 2>=arguments.length?Array.prototype.slice.call(a,b):Array.prototype.slice.call(a,b,c)}
function bb(a,b,c){if(!fa(a)||!fa(b)||a.length!=b.length)return!1;var d=a.length;c=c||cb;for(var e=0;e<d;e++)if(!c(a[e],b[e]))return!1;return!0}
function db(a,b){return a>b?1:a<b?-1:0}
function cb(a,b){return a===b}
;function eb(a,b,c){for(var d in a)b.call(c,a[d],d,a)}
function fb(a,b,c){var d={},e;for(e in a)b.call(c,a[e],e,a)&&(d[e]=a[e]);return d}
function gb(a){var b=0,c;for(c in a)b++;return b}
function ib(a,b){return jb(a,b)}
function kb(a){var b=[],c=0,d;for(d in a)b[c++]=a[d];return b}
function lb(a){var b=[],c=0,d;for(d in a)b[c++]=d;return b}
function nb(a){return null!==a&&"withCredentials"in a}
function jb(a,b){for(var c in a)if(a[c]==b)return!0;return!1}
function ob(a){var b=pb,c;for(c in b)if(a.call(void 0,b[c],c,b))return c}
function qb(a){for(var b in a)return!1;return!0}
function sb(a,b){if(null!==a&&b in a)throw Error('The object already contains the key "'+b+'"');a[b]=!0}
function tb(a){var b={},c;for(c in a)b[c]=a[c];return b}
function ub(a){var b=da(a);if("object"==b||"array"==b){if(ha(a.clone))return a.clone();var b="array"==b?[]:{},c;for(c in a)b[c]=ub(a[c]);return b}return a}
var vb="constructor hasOwnProperty isPrototypeOf propertyIsEnumerable toLocaleString toString valueOf".split(" ");function wb(a,b){for(var c,d,e=1;e<arguments.length;e++){d=arguments[e];for(c in d)a[c]=d[c];for(var f=0;f<vb.length;f++)c=vb[f],Object.prototype.hasOwnProperty.call(d,c)&&(a[c]=d[c])}}
;var xb;a:{var yb=m.navigator;if(yb){var zb=yb.userAgent;if(zb){xb=zb;break a}}xb=""}function B(a){return-1!=xb.indexOf(a)}
;function Ab(){return B("Opera")||B("OPR")}
function Bb(){return(B("Chrome")||B("CriOS"))&&!Ab()&&!B("Edge")}
;function Cb(){this.f=""}
Cb.prototype.Sb=!0;Cb.prototype.Nb=function(){return this.f};
Cb.prototype.toString=function(){return"Const{"+this.f+"}"};
function Db(a){var b=new Cb;b.f=a;return b}
;function Eb(){this.f="";this.h=Fb}
Eb.prototype.Sb=!0;Eb.prototype.Nb=function(){return this.f};
function Gb(a){if(a instanceof Eb&&a.constructor===Eb&&a.h===Fb)return a.f;da(a);return"type_error:SafeUrl"}
var Hb=/^(?:(?:https?|mailto|ftp):|[^&:/?#]*(?:[/?#]|$))/i;function Ib(a){if(a instanceof Eb)return a;a=a.Sb?a.Nb():String(a);Hb.test(a)||(a="about:invalid#zClosurez");return Jb(a)}
var Fb={};function Jb(a){var b=new Eb;b.f=a;return b}
Jb("about:blank");function Kb(){this.f="";this.h=Lb;this.j=null}
Kb.prototype.Sb=!0;Kb.prototype.Nb=function(){return this.f};
function Mb(a){if(a instanceof Kb&&a.constructor===Kb&&a.h===Lb)return a.f;da(a);return"type_error:SafeHtml"}
var Lb={};function Nb(a,b){var c=new Kb;c.f=a;c.j=b;return c}
Nb("<!DOCTYPE html>",0);Nb("",0);Nb("<br>",0);function Ob(a,b){var c;c=b instanceof Eb?b:Ib(b);a.href=Gb(c)}
;function Pb(a,b,c){a&&(a.dataset?a.dataset[Qb(b)]=c:a.setAttribute("data-"+b,c))}
function C(a,b){return a?a.dataset?a.dataset[Qb(b)]:a.getAttribute("data-"+b):null}
function Rb(a,b){a&&(a.dataset?delete a.dataset[Qb(b)]:a.removeAttribute("data-"+b))}
var Sb={};function Qb(a){return Sb[a]||(Sb[a]=String(a).replace(/\-([a-z])/g,function(a,c){return c.toUpperCase()}))}
;function Tb(a){m.setTimeout(function(){throw a;},0)}
var Ub;
function Vb(){var a=m.MessageChannel;"undefined"===typeof a&&"undefined"!==typeof window&&window.postMessage&&window.addEventListener&&!B("Presto")&&(a=function(){var a=document.createElement("IFRAME");a.style.display="none";a.src="";document.documentElement.appendChild(a);var b=a.contentWindow,a=b.document;a.open();a.write("");a.close();var c="callImmediate"+Math.random(),d="file:"==b.location.protocol?"*":b.location.protocol+"//"+b.location.host,a=v(function(a){if(("*"==d||a.origin==d)&&a.data==
c)this.port1.onmessage()},this);
b.addEventListener("message",a,!1);this.port1={};this.port2={postMessage:function(){b.postMessage(c,d)}}});
if("undefined"!==typeof a&&!B("Trident")&&!B("MSIE")){var b=new a,c={},d=c;b.port1.onmessage=function(){if(p(c.next)){c=c.next;var a=c.ic;c.ic=null;a()}};
return function(a){d.next={ic:a};d=d.next;b.port2.postMessage(0)}}return"undefined"!==typeof document&&"onreadystatechange"in document.createElement("SCRIPT")?function(a){var b=document.createElement("SCRIPT");
b.onreadystatechange=function(){b.onreadystatechange=null;b.parentNode.removeChild(b);b=null;a();a=null};
document.documentElement.appendChild(b)}:function(a){m.setTimeout(a,0)}}
;function Wb(a,b,c){this.l=c;this.j=a;this.o=b;this.h=0;this.f=null}
Wb.prototype.get=function(){var a;0<this.h?(this.h--,a=this.f,this.f=a.next,a.next=null):a=this.j();return a};
function Xb(a,b){a.o(b);a.h<a.l&&(a.h++,b.next=a.f,a.f=b)}
;function Yb(){this.h=this.f=null}
var $b=new Wb(function(){return new Zb},function(a){a.reset()},100);
Yb.prototype.remove=function(){var a=null;this.f&&(a=this.f,this.f=this.f.next,this.f||(this.h=null),a.next=null);return a};
function Zb(){this.next=this.scope=this.f=null}
Zb.prototype.reset=function(){this.next=this.scope=this.f=null};function ac(a,b){bc||cc();dc||(bc(),dc=!0);var c=ec,d=$b.get();d.f=a;d.scope=b;d.next=null;c.h?c.h.next=d:c.f=d;c.h=d}
var bc;function cc(){if(m.Promise&&m.Promise.resolve){var a=m.Promise.resolve(void 0);bc=function(){a.then(fc)}}else bc=function(){var a=fc;
!ha(m.setImmediate)||m.Window&&m.Window.prototype&&!B("Edge")&&m.Window.prototype.setImmediate==m.setImmediate?(Ub||(Ub=Vb()),Ub(a)):m.setImmediate(a)}}
var dc=!1,ec=new Yb;function fc(){for(var a=null;a=ec.remove();){try{a.f.call(a.scope)}catch(b){Tb(b)}Xb($b,a)}dc=!1}
;function D(){this.sa=this.sa;this.T=this.T}
D.prototype.sa=!1;D.prototype.isDisposed=function(){return this.sa};
D.prototype.dispose=function(){this.sa||(this.sa=!0,this.G())};
function gc(a,b){a.sa?b.call(void 0):(a.T||(a.T=[]),a.T.push(p(void 0)?v(b,void 0):b))}
D.prototype.G=function(){if(this.T)for(;this.T.length;)this.T.shift()()};
function E(a){a&&"function"==typeof a.dispose&&a.dispose()}
function hc(a){for(var b=0,c=arguments.length;b<c;++b){var d=arguments[b];fa(d)?hc.apply(null,d):E(d)}}
;function F(a){D.call(this);this.l=1;this.h=[];this.j=0;this.f=[];this.ga={};this.o=!!a}
x(F,D);g=F.prototype;g.subscribe=function(a,b,c){var d=this.ga[a];d||(d=this.ga[a]=[]);var e=this.l;this.f[e]=a;this.f[e+1]=b;this.f[e+2]=c;this.l=e+3;d.push(e);return e};
g.unsubscribe=function(a,b,c){if(a=this.ga[a]){var d=this.f;if(a=Qa(a,function(a){return d[a+1]==b&&d[a+2]==c}))return this.oa(a)}return!1};
g.oa=function(a){var b=this.f[a];if(b){var c=this.ga[b];0!=this.j?(this.h.push(a),this.f[a+1]=t):(c&&Va(c,a),delete this.f[a],delete this.f[a+1],delete this.f[a+2])}return!!b};
g.D=function(a,b){var c=this.ga[a];if(c){for(var d=Array(arguments.length-1),e=1,f=arguments.length;e<f;e++)d[e-1]=arguments[e];if(this.o)for(e=0;e<c.length;e++){var h=c[e];ic(this.f[h+1],this.f[h+2],d)}else{this.j++;try{for(e=0,f=c.length;e<f;e++)h=c[e],this.f[h+1].apply(this.f[h+2],d)}finally{if(this.j--,0<this.h.length&&0==this.j)for(;c=this.h.pop();)this.oa(c)}}return 0!=e}return!1};
function ic(a,b,c){ac(function(){a.apply(b,c)})}
g.clear=function(a){if(a){var b=this.ga[a];b&&(y(b,this.oa,this),delete this.ga[a])}else this.f.length=0,this.ga={}};
g.Y=function(a){if(a){var b=this.ga[a];return b?b.length:0}a=0;for(b in this.ga)a+=this.Y(b);return a};
g.G=function(){F.I.G.call(this);this.clear();this.h.length=0};var jc=window.yt&&window.yt.config_||window.ytcfg&&window.ytcfg.data_||{};q("yt.config_",jc,void 0);q("yt.tokens_",window.yt&&window.yt.tokens_||{},void 0);var kc=window.yt&&window.yt.msgs_||r("window.ytcfg.msgs")||{};q("yt.msgs_",kc,void 0);function lc(a){mc(jc,arguments)}
function G(a,b){return a in jc?jc[a]:b}
function I(a,b){ha(a)&&(a=nc(a));return window.setTimeout(a,b)}
function oc(a,b){ha(a)&&(a=nc(a));window.setInterval(a,b)}
function J(a){window.clearTimeout(a)}
function nc(a){return a&&window.yterr?function(){try{return a.apply(this,arguments)}catch(b){throw pc(b),b;}}:a}
function pc(a,b){var c=r("yt.logging.errors.log");c?c(a,b):(c=G("ERRORS",[]),c.push([a,b]),lc("ERRORS",c))}
function qc(){var a={},b="FLASH_UPGRADE"in kc?kc.FLASH_UPGRADE:'You need to upgrade your Adobe Flash Player to watchthis video. <br> <a href="http://get.adobe.com/flashplayer/">Download it from Adobe.</a>';if(b)for(var c in a)b=b.replace(new RegExp("\\$"+c,"gi"),function(){return a[c]});
return b}
function mc(a,b){if(1<b.length){var c=b[0];a[c]=b[1]}else{var d=b[0];for(c in d)a[c]=d[c]}}
var rc="Microsoft Internet Explorer"==navigator.appName;var sc=r("yt.pubsub.instance_")||new F;F.prototype.subscribe=F.prototype.subscribe;F.prototype.unsubscribeByKey=F.prototype.oa;F.prototype.publish=F.prototype.D;F.prototype.clear=F.prototype.clear;q("yt.pubsub.instance_",sc,void 0);var tc=r("yt.pubsub.subscribedKeys_")||{};q("yt.pubsub.subscribedKeys_",tc,void 0);var uc=r("yt.pubsub.topicToKeys_")||{};q("yt.pubsub.topicToKeys_",uc,void 0);var vc=r("yt.pubsub.isSynchronous_")||{};q("yt.pubsub.isSynchronous_",vc,void 0);
var wc=r("yt.pubsub.skipSubId_")||null;q("yt.pubsub.skipSubId_",wc,void 0);function xc(a,b,c){var d=yc();if(d){var e=d.subscribe(a,function(){if(!wc||wc!=e){var d=arguments,h=function(){tc[e]&&b.apply(c||window,d)};
try{vc[a]?h():I(h,0)}catch(k){pc(k)}}},c);
tc[e]=!0;uc[a]||(uc[a]=[]);uc[a].push(e);return e}return 0}
function zc(a){var b=yc();b&&("number"==typeof a?a=[a]:"string"==typeof a&&(a=[parseInt(a,10)]),y(a,function(a){b.unsubscribeByKey(a);delete tc[a]}))}
function K(a,b){var c=yc();return c?c.publish.apply(c,arguments):!1}
function Ac(a,b){vc[a]=!0;var c=yc();c&&c.publish.apply(c,arguments);vc[a]=!1}
function Bc(a){uc[a]&&(a=uc[a],y(a,function(a){tc[a]&&delete tc[a]}),a.length=0)}
function Cc(a){var b=yc();if(b)if(b.clear(a),a)Bc(a);else for(var c in uc)Bc(c)}
function yc(){return r("yt.pubsub.instance_")}
;function Dc(a,b){if(window.spf){var c="";if(a){var d=a.indexOf("jsbin/"),e=a.lastIndexOf(".js"),f=d+6;-1<d&&-1<e&&e>f&&(c=a.substring(f,e),c=c.replace(Ec,""),c=c.replace(Fc,""),c=c.replace("debug-",""),c=c.replace("tracing-",""))}spf.script.load(a,c,b)}else Gc(a,b)}
function Gc(a,b){var c=Hc(a),d=document.getElementById(c),e=d&&C(d,"loaded"),f=d&&!e;if(e)b&&b();else{if(b){var e=xc(c,b),h=""+ka(b);Ic[h]=e}f||(d=Jc(a,c,function(){C(d,"loaded")||(Pb(d,"loaded","true"),K(c),I(pa(Cc,c),0))}))}}
function Jc(a,b,c){var d=document.createElement("script");d.id=b;d.onload=function(){c&&setTimeout(c,0)};
d.onreadystatechange=function(){switch(d.readyState){case "loaded":case "complete":d.onload()}};
d.src=a;a=document.getElementsByTagName("head")[0]||document.body;a.insertBefore(d,a.firstChild);return d}
function Kc(a,b){if(a&&b){var c=""+ka(b);(c=Ic[c])&&zc(c)}}
function Hc(a){var b=document.createElement("a");Ob(b,a);a=b.href.replace(/^[a-zA-Z]+:\/\//,"//");return"js-"+Ka(a)}
var Ec=/\.vflset|-vfl[a-zA-Z0-9_+=-]+/,Fc=/-[a-zA-Z]{2,3}_[a-zA-Z]{2,3}(?=(\/|$))/,Ic={};var Lc=null;function Mc(){var a=G("BG_I",null),b=G("BG_IU",null),c=G("BG_P",void 0);b?Dc(b,function(){Lc=new botguard.bg(c)}):a&&(eval(a),Lc=new botguard.bg(c))}
function Nc(){return null!=Lc}
function Oc(){return Lc?Lc.invoke():null}
;function Pc(a,b){return Nb(b,null)}
;var Qc="StopIteration"in m?m.StopIteration:{message:"StopIteration",stack:""};function Rc(){}
Rc.prototype.next=function(){throw Qc;};
Rc.prototype.wa=function(){return this};
function Sc(a){if(a instanceof Rc)return a;if("function"==typeof a.wa)return a.wa(!1);if(fa(a)){var b=0,c=new Rc;c.next=function(){for(;;){if(b>=a.length)throw Qc;if(b in a)return a[b++];b++}};
return c}throw Error("Not implemented");}
function Tc(a,b,c){if(fa(a))try{y(a,b,c)}catch(d){if(d!==Qc)throw d;}else{a=Sc(a);try{for(;;)b.call(c,a.next(),void 0,a)}catch(d){if(d!==Qc)throw d;}}}
function Uc(a){if(fa(a))return Ya(a);a=Sc(a);var b=[];Tc(a,function(a){b.push(a)});
return b}
;function Vc(a,b){this.h={};this.f=[];this.Fa=this.j=0;var c=arguments.length;if(1<c){if(c%2)throw Error("Uneven number of arguments");for(var d=0;d<c;d+=2)Wc(this,arguments[d],arguments[d+1])}else if(a){a instanceof Vc?(c=a.ra(),d=a.V()):(c=lb(a),d=kb(a));for(var e=0;e<c.length;e++)Wc(this,c[e],d[e])}}
g=Vc.prototype;g.Y=function(){return this.j};
g.V=function(){Xc(this);for(var a=[],b=0;b<this.f.length;b++)a.push(this.h[this.f[b]]);return a};
g.ra=function(){Xc(this);return this.f.concat()};
g.Ya=function(a){for(var b=0;b<this.f.length;b++){var c=this.f[b];if(Yc(this.h,c)&&this.h[c]==a)return!0}return!1};
g.equals=function(a,b){if(this===a)return!0;if(this.j!=a.Y())return!1;var c=b||Zc;Xc(this);for(var d,e=0;d=this.f[e];e++)if(!c(this.get(d),a.get(d)))return!1;return!0};
function Zc(a,b){return a===b}
g.isEmpty=function(){return 0==this.j};
g.clear=function(){this.h={};this.Fa=this.j=this.f.length=0};
g.remove=function(a){return Yc(this.h,a)?(delete this.h[a],this.j--,this.Fa++,this.f.length>2*this.j&&Xc(this),!0):!1};
function Xc(a){if(a.j!=a.f.length){for(var b=0,c=0;b<a.f.length;){var d=a.f[b];Yc(a.h,d)&&(a.f[c++]=d);b++}a.f.length=c}if(a.j!=a.f.length){for(var e={},c=b=0;b<a.f.length;)d=a.f[b],Yc(e,d)||(a.f[c++]=d,e[d]=1),b++;a.f.length=c}}
g.get=function(a,b){return Yc(this.h,a)?this.h[a]:b};
function Wc(a,b,c){Yc(a.h,b)||(a.j++,a.f.push(b),a.Fa++);a.h[b]=c}
g.forEach=function(a,b){for(var c=this.ra(),d=0;d<c.length;d++){var e=c[d],f=this.get(e);a.call(b,f,e,this)}};
g.clone=function(){return new Vc(this)};
g.wa=function(a){Xc(this);var b=0,c=this.Fa,d=this,e=new Rc;e.next=function(){if(c!=d.Fa)throw Error("The map has changed since the iterator was created");if(b>=d.f.length)throw Qc;var e=d.f[b++];return a?e:d.h[e]};
return e};
function Yc(a,b){return Object.prototype.hasOwnProperty.call(a,b)}
;function $c(a){return a.Y&&"function"==typeof a.Y?a.Y():fa(a)||u(a)?a.length:gb(a)}
function ad(a){if(a.V&&"function"==typeof a.V)return a.V();if(u(a))return a.split("");if(fa(a)){for(var b=[],c=a.length,d=0;d<c;d++)b.push(a[d]);return b}return kb(a)}
function bd(a){if(a.ra&&"function"==typeof a.ra)return a.ra();if(!a.V||"function"!=typeof a.V){if(fa(a)||u(a)){var b=[];a=a.length;for(var c=0;c<a;c++)b.push(c);return b}return lb(a)}}
function cd(a,b){if(a.forEach&&"function"==typeof a.forEach)a.forEach(b,void 0);else if(fa(a)||u(a))y(a,b,void 0);else for(var c=bd(a),d=ad(a),e=d.length,f=0;f<e;f++)b.call(void 0,d[f],c&&c[f],a)}
function dd(a,b){if("function"==typeof a.every)return a.every(b,void 0);if(fa(a)||u(a))return Pa(a,b,void 0);for(var c=bd(a),d=ad(a),e=d.length,f=0;f<e;f++)if(!b.call(void 0,d[f],c&&c[f],a))return!1;return!0}
;function ed(a){this.f=new Vc;if(a){a=ad(a);for(var b=a.length,c=0;c<b;c++){var d=a[c];Wc(this.f,fd(d),d)}}}
function fd(a){var b=typeof a;return"object"==b&&a||"function"==b?"o"+ka(a):b.substr(0,1)+a}
g=ed.prototype;g.Y=function(){return this.f.Y()};
g.removeAll=function(a){a=ad(a);for(var b=a.length,c=0;c<b;c++)this.remove(a[c])};
g.remove=function(a){return this.f.remove(fd(a))};
g.clear=function(){this.f.clear()};
g.isEmpty=function(){return this.f.isEmpty()};
g.contains=function(a){a=fd(a);return Yc(this.f.h,a)};
g.V=function(){return this.f.V()};
g.clone=function(){return new ed(this)};
g.equals=function(a){return this.Y()==$c(a)&&gd(this,a)};
function gd(a,b){var c=$c(b);if(a.Y()>c)return!1;!(b instanceof ed)&&5<c&&(b=new ed(b));return dd(a,function(a){var c=b;return c.contains&&"function"==typeof c.contains?c.contains(a):c.Ya&&"function"==typeof c.Ya?c.Ya(a):fa(c)||u(c)?A(c,a):jb(c,a)})}
g.wa=function(){return this.f.wa(!1)};function hd(){return B("iPhone")&&!B("iPod")&&!B("iPad")}
;var id=Ab(),L=B("Trident")||B("MSIE"),jd=B("Edge"),kd=B("Gecko")&&!(-1!=xb.toLowerCase().indexOf("webkit")&&!B("Edge"))&&!(B("Trident")||B("MSIE"))&&!B("Edge"),ld=-1!=xb.toLowerCase().indexOf("webkit")&&!B("Edge"),md=B("Macintosh"),nd=B("Windows");function od(){var a=m.document;return a?a.documentMode:void 0}
var pd;a:{var qd="",rd=function(){var a=xb;if(kd)return/rv\:([^\);]+)(\)|;)/.exec(a);if(jd)return/Edge\/([\d\.]+)/.exec(a);if(L)return/\b(?:MSIE|rv)[: ]([^\);]+)(\)|;)/.exec(a);if(ld)return/WebKit\/(\S+)/.exec(a);if(id)return/(?:Version)[ \/]?(\S+)/.exec(a)}();
rd&&(qd=rd?rd[1]:"");if(L){var sd=od();if(null!=sd&&sd>parseFloat(qd)){pd=String(sd);break a}}pd=qd}var td=pd,ud={};function vd(a){return ud[a]||(ud[a]=0<=Ia(td,a))}
function wd(a){return Number(xd)>=a}
var yd=m.document,xd=yd&&L?od()||("CSS1Compat"==yd.compatMode?parseInt(td,10):5):void 0;function zd(a){a=String(a);if(/^\s*$/.test(a)?0:/^[\],:{}\s\u2028\u2029]*$/.test(a.replace(/\\["\\\/bfnrtu]/g,"@").replace(/(?:"[^"\\\n\r\u2028\u2029\x00-\x08\x0a-\x1f]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)[\s\u2028\u2029]*(?=:|,|]|}|$)/g,"]").replace(/(?:^|:|,)(?:[\s\u2028\u2029]*\[)+/g,"")))try{return eval("("+a+")")}catch(b){}throw Error("Invalid JSON string: "+a);}
function Ad(a){return eval("("+a+")")}
function M(a){return Bd(new Cd(void 0),a)}
function Cd(a){this.f=a}
function Bd(a,b){var c=[];Dd(a,b,c);return c.join("")}
function Dd(a,b,c){if(null==b)c.push("null");else{if("object"==typeof b){if(ea(b)){var d=b;b=d.length;c.push("[");for(var e="",f=0;f<b;f++)c.push(e),e=d[f],Dd(a,a.f?a.f.call(d,String(f),e):e,c),e=",";c.push("]");return}if(b instanceof String||b instanceof Number||b instanceof Boolean)b=b.valueOf();else{c.push("{");f="";for(d in b)Object.prototype.hasOwnProperty.call(b,d)&&(e=b[d],"function"!=typeof e&&(c.push(f),Ed(d,c),c.push(":"),Dd(a,a.f?a.f.call(b,d,e):e,c),f=","));c.push("}");return}}switch(typeof b){case "string":Ed(b,
c);break;case "number":c.push(isFinite(b)&&!isNaN(b)?String(b):"null");break;case "boolean":c.push(String(b));break;case "function":c.push("null");break;default:throw Error("Unknown type: "+typeof b);}}}
var Fd={'"':'\\"',"\\":"\\\\","/":"\\/","\b":"\\b","\f":"\\f","\n":"\\n","\r":"\\r","\t":"\\t","\x0B":"\\u000b"},Gd=/\uffff/.test("\uffff")?/[\\\"\x00-\x1f\x7f-\uffff]/g:/[\\\"\x00-\x1f\x7f-\xff]/g;function Ed(a,b){b.push('"',a.replace(Gd,function(a){var b=Fd[a];b||(b="\\u"+(a.charCodeAt(0)|65536).toString(16).substr(1),Fd[a]=b);return b}),'"')}
;var Hd=/^(?:([^:/?#.]+):)?(?:\/\/(?:([^/?#]*)@)?([^/#?]*?)(?::([0-9]+))?(?=[/#?]|$))?([^?#]+)?(?:\?([^#]*))?(?:#(.*))?$/;function Id(a){return(a=a.match(Hd)[3]||null)?decodeURI(a):a}
function Jd(a,b){if(a)for(var c=a.split("&"),d=0;d<c.length;d++){var e=c[d].indexOf("="),f=null,h=null;0<=e?(f=c[d].substring(0,e),h=c[d].substring(e+1)):f=c[d];b(f,h?ua(h):"")}}
function Kd(a){if(a[1]){var b=a[0],c=b.indexOf("#");0<=c&&(a.push(b.substr(c)),a[0]=b=b.substr(0,c));c=b.indexOf("?");0>c?a[1]="?":c==b.length-1&&(a[1]=void 0)}return a.join("")}
function Ld(a,b,c){if(ea(b))for(var d=0;d<b.length;d++)Ld(a,String(b[d]),c);else null!=b&&c.push("&",a,""===b?"":"=",encodeURIComponent(String(b)))}
function Md(a,b,c){for(c=c||0;c<b.length;c+=2)Ld(b[c],b[c+1],a);return a}
function Nd(a,b){for(var c in b)Ld(c,b[c],a);return a}
function Od(a){a=Nd([],a);a[0]="";return a.join("")}
function Pd(a,b){return Kd(2==arguments.length?Md([a],arguments[1],0):Md([a],arguments,1))}
function Qd(a,b){return Kd(Nd([a],b))}
;function Rd(a){"?"==a.charAt(0)&&(a=a.substr(1));a=a.split("&");for(var b={},c=0,d=a.length;c<d;c++){var e=a[c].split("=");if(1==e.length&&e[0]||2==e.length){var f=ua(e[0]||""),e=ua(e[1]||"");f in b?ea(b[f])?Za(b[f],e):b[f]=[b[f],e]:b[f]=e}}return b}
function Sd(a,b){var c=a.split("#",2);a=c[0];var c=1<c.length?"#"+c[1]:"",d=a.split("?",2);a=d[0];var d=Rd(d[1]||""),e;for(e in b)d[e]=b[e];return Qd(a,d)+c}
function Td(a){a=Id(a);a=null===a?null:a.split(".").reverse();return(null===a?!1:"com"==a[0]&&a[1].match(/^youtube(?:-nocookie)?$/)?!0:!1)||(null===a?!1:"google"==a[1]?!0:"google"==a[2]?"au"==a[0]&&"com"==a[1]?!0:"uk"==a[0]&&"co"==a[1]?!0:!1:!1)}
;var Ud=null;"undefined"!=typeof XMLHttpRequest?Ud=function(){return new XMLHttpRequest}:"undefined"!=typeof ActiveXObject&&(Ud=function(){return new ActiveXObject("Microsoft.XMLHTTP")});
function Vd(a){switch(a&&"status"in a?a.status:-1){case 200:case 201:case 202:case 203:case 204:case 205:case 206:case 304:return!0;default:return!1}}
;function Wd(a,b,c,d,e,f,h){function k(){4==(l&&"readyState"in l?l.readyState:0)&&b&&nc(b)(l)}
var l=Ud&&Ud();if(!("open"in l))return null;"onloadend"in l?l.addEventListener("loadend",k,!1):l.onreadystatechange=k;c=(c||"GET").toUpperCase();d=d||"";l.open(c,a,!0);f&&(l.responseType=f);h&&(l.withCredentials=!0);f="POST"==c;if(e=Xd(a,e))for(var n in e)l.setRequestHeader(n,e[n]),"content-type"==n.toLowerCase()&&(f=!1);f&&l.setRequestHeader("Content-Type","application/x-www-form-urlencoded");l.send(d);return l}
function Xd(a,b){b=b||{};var c;c||(c=window.location.href);var d=a.match(Hd)[1]||null,e=Id(a);d&&e?(d=c,c=a.match(Hd),d=d.match(Hd),c=c[3]==d[3]&&c[1]==d[1]&&c[4]==d[4]):c=e?Id(c)==e&&(Number(c.match(Hd)[4]||null)||null)==(Number(a.match(Hd)[4]||null)||null):!0;for(var f in Yd){if((e=d=G(Yd[f]))&&!(e=c)){var e=f,h=G("CORS_HEADER_WHITELIST")||{},k=Id(a);e=k?(h=h[k])?A(h,e):!1:!0}e&&(b[f]=d)}return b}
function Zd(a,b){var c=G("XSRF_FIELD_NAME",void 0),d;b.headers&&(d=b.headers["Content-Type"]);return!b.ef&&(!Id(a)||b.withCredentials||Id(a)==document.location.hostname)&&"POST"==b.method&&(!d||"application/x-www-form-urlencoded"==d)&&!(b.S&&b.S[c])}
function $d(a,b){var c=b.format||"JSON";b.ff&&(a=document.location.protocol+"//"+document.location.hostname+(document.location.port?":"+document.location.port:"")+a);var d=G("XSRF_FIELD_NAME",void 0),e=G("XSRF_TOKEN",void 0),f=b.$b;f&&(f[d]&&delete f[d],a=Sd(a,f||{}));var h=b.postBody||"",f=b.S;Zd(a,b)&&(f||(f={}),f[d]=e);f&&u(h)&&(d=Rd(h),wb(d,f),h=Od(d));var k=!1,l,n=Wd(a,function(a){if(!k){k=!0;l&&J(l);var d=Vd(a),e=null;if(d||400<=a.status&&500>a.status)e=ae(c,a,b.df);if(d)a:{switch(c){case "XML":d=
0==parseInt(e&&e.return_code,10);break a;case "RAW":d=!0;break a}d=!!e}var e=e||{},f=b.context||m;d?b.ca&&b.ca.call(f,a,e):b.onError&&b.onError.call(f,a,e);b.Wb&&b.Wb.call(f,a,e)}},b.method,h,b.headers,b.responseType,b.withCredentials);
b.gb&&0<b.timeout&&(l=I(function(){k||(k=!0,n.abort(),J(l),b.gb.call(b.context||m,n))},b.timeout));
return n}
function ae(a,b,c){var d=null;switch(a){case "JSON":a=b.responseText;b=b.getResponseHeader("Content-Type")||"";a&&0<=b.indexOf("json")&&(d=Ad(a));break;case "XML":if(b=(b=b.responseXML)?be(b):null)d={},y(b.getElementsByTagName("*"),function(a){d[a.tagName]=ce(a)})}c&&de(d);
return d}
function de(a){if(ia(a))for(var b in a){var c;(c="html_content"==b)||(c=b.length-5,c=0<=c&&b.indexOf("_html",c)==c);c?a[b]=Pc(Db("HTML that is escaped and sanitized server-side and passed through yt.net.ajax"),a[b]):de(a[b])}}
function be(a){return a?(a=("responseXML"in a?a.responseXML:a).getElementsByTagName("root"))&&0<a.length?a[0]:null:null}
function ce(a){var b="";y(a.childNodes,function(a){b+=a.nodeValue});
return b}
var Yd={"X-YouTube-Client-Name":"INNERTUBE_CONTEXT_CLIENT_NAME","X-YouTube-Client-Version":"INNERTUBE_CONTEXT_CLIENT_VERSION","X-YouTube-Page-CL":"PAGE_CL","X-YouTube-Page-Label":"PAGE_BUILD_LABEL","X-YouTube-Variants-Checksum":"VARIANTS_CHECKSUM"};var ee={},fe=0;function ge(a,b){isNaN(b)&&(b=void 0);var c=r("yt.scheduler.instance.addJob");return c?c(a,0,b):void 0===b?(a(),NaN):I(a,b||0)}
function he(a){return ge(a,5E3)}
;var ie=[],je=!1;function ke(){function a(){je=!0;"google_ad_status"in window?lc("DCLKSTAT",1):lc("DCLKSTAT",2)}
Dc("//static.doubleclick.net/instream/ad_status.js",a);ie.push(he(function(){je||"google_ad_status"in window||(Kc("//static.doubleclick.net/instream/ad_status.js",a),lc("DCLKSTAT",3))}))}
function le(){return parseInt(G("DCLKSTAT",0),10)}
;function me(a){if(a.classList)return a.classList;a=a.className;return u(a)&&a.match(/\S+/g)||[]}
function ne(a,b){return a.classList?a.classList.contains(b):A(me(a),b)}
function oe(a,b){a.classList?a.classList.add(b):ne(a,b)||(a.className+=0<a.className.length?" "+b:b)}
function pe(a,b){a.classList?a.classList.remove(b):ne(a,b)&&(a.className=Na(me(a),function(a){return a!=b}).join(" "))}
function qe(a,b,c){c?oe(a,b):pe(a,b)}
;function re(a,b){this.x=p(a)?a:0;this.y=p(b)?b:0}
re.prototype.clone=function(){return new re(this.x,this.y)};
re.prototype.floor=function(){this.x=Math.floor(this.x);this.y=Math.floor(this.y);return this};
re.prototype.round=function(){this.x=Math.round(this.x);this.y=Math.round(this.y);return this};function se(a,b){this.width=a;this.height=b}
se.prototype.clone=function(){return new se(this.width,this.height)};
se.prototype.isEmpty=function(){return!(this.width*this.height)};
se.prototype.floor=function(){this.width=Math.floor(this.width);this.height=Math.floor(this.height);return this};
se.prototype.round=function(){this.width=Math.round(this.width);this.height=Math.round(this.height);return this};!kd&&!L||L&&wd(9)||kd&&vd("1.9.1");var te=L&&!vd("9");function ue(a){return a?new ve(we(a)):ra||(ra=new ve)}
function xe(a){return u(a)?document.getElementById(a):a}
function ye(a){var b=document;return u(a)?b.getElementById(a):a}
function ze(a){var b=document;return b.querySelectorAll&&b.querySelector?b.querySelectorAll("."+a):Ae(a,void 0)}
function Ae(a,b){var c,d,e,f;c=document;c=b||c;if(c.querySelectorAll&&c.querySelector&&a)return c.querySelectorAll(""+(a?"."+a:""));if(a&&c.getElementsByClassName){var h=c.getElementsByClassName(a);return h}h=c.getElementsByTagName("*");if(a){f={};for(d=e=0;c=h[d];d++){var k=c.className;"function"==typeof k.split&&A(k.split(/\s+/),a)&&(f[e++]=c)}f.length=e;return f}return h}
function Be(a){var b=a.scrollingElement?a.scrollingElement:!ld&&Ce(a)?a.documentElement:a.body||a.documentElement;a=a.parentWindow||a.defaultView;return L&&vd("10")&&a.pageYOffset!=b.scrollTop?new re(b.scrollLeft,b.scrollTop):new re(a.pageXOffset||b.scrollLeft,a.pageYOffset||b.scrollTop)}
function Ce(a){return"CSS1Compat"==a.compatMode}
function De(a){for(var b;b=a.firstChild;)a.removeChild(b)}
function Ee(a){if(!a)return null;if(a.firstChild)return a.firstChild;for(;a&&!a.nextSibling;)a=a.parentNode;return a?a.nextSibling:null}
function Fe(a){if(!a)return null;if(!a.previousSibling)return a.parentNode;for(a=a.previousSibling;a&&a.lastChild;)a=a.lastChild;return a}
function we(a){return 9==a.nodeType?a:a.ownerDocument||a.document}
function Ge(a,b){if("textContent"in a)a.textContent=b;else if(3==a.nodeType)a.data=b;else if(a.firstChild&&3==a.firstChild.nodeType){for(;a.lastChild!=a.firstChild;)a.removeChild(a.lastChild);a.firstChild.data=b}else{De(a);var c=we(a);a.appendChild(c.createTextNode(String(b)))}}
var He={SCRIPT:1,STYLE:1,HEAD:1,IFRAME:1,OBJECT:1},Ie={IMG:" ",BR:"\n"};function Je(a){if(te&&null!==a&&"innerText"in a)a=a.innerText.replace(/(\r\n|\r|\n)/g,"\n");else{var b=[];Ke(a,b,!0);a=b.join("")}a=a.replace(/ \xAD /g," ").replace(/\xAD/g,"");a=a.replace(/\u200B/g,"");te||(a=a.replace(/ +/g," "));" "!=a&&(a=a.replace(/^\s*/,""));return a}
function Ke(a,b,c){if(!(a.nodeName in He))if(3==a.nodeType)c?b.push(String(a.nodeValue).replace(/(\r\n|\r|\n)/g,"")):b.push(a.nodeValue);else if(a.nodeName in Ie)b.push(Ie[a.nodeName]);else for(a=a.firstChild;a;)Ke(a,b,c),a=a.nextSibling}
function Le(a){var b=Me.$c;return b?Ne(a,function(a){return!b||u(a.className)&&A(a.className.split(/\s+/),b)},!0,void 0):null}
function Ne(a,b,c,d){c||(a=a.parentNode);for(c=0;a&&(null==d||c<=d);){if(b(a))return a;a=a.parentNode;c++}return null}
function ve(a){this.f=a||m.document||document}
ve.prototype.createElement=function(a){return this.f.createElement(a)};
ve.prototype.appendChild=function(a,b){a.appendChild(b)};
ve.prototype.contains=function(a,b){if(!a||!b)return!1;if(a.contains&&1==b.nodeType)return a==b||a.contains(b);if("undefined"!=typeof a.compareDocumentPosition)return a==b||!!(a.compareDocumentPosition(b)&16);for(;b&&a!=b;)b=b.parentNode;return b==a};var Oe=ld?"webkit":kd?"moz":L?"ms":id?"o":"",Pe=r("yt.dom.getNextId_");if(!Pe){Pe=function(){return++Qe};
q("yt.dom.getNextId_",Pe,void 0);var Qe=0}function Re(){var a=document,b;Oa(["fullscreenElement","fullScreenElement"],function(c){c in a?b=a[c]:(c=Oe+c.charAt(0).toUpperCase()+c.substr(1),b=c in a?a[c]:void 0);return!!b});
return b}
;function Se(a){this.type="";this.state=this.source=this.data=this.currentTarget=this.relatedTarget=this.target=null;this.charCode=this.keyCode=0;this.shiftKey=this.ctrlKey=this.altKey=!1;this.clientY=this.clientX=0;this.changedTouches=null;if(a=a||window.event){this.event=a;for(var b in a)b in Te||(this[b]=a[b]);(b=a.target||a.srcElement)&&3==b.nodeType&&(b=b.parentNode);this.target=b;if(b=a.relatedTarget)try{b=b.nodeName?b:null}catch(c){b=null}else"mouseover"==this.type?b=a.fromElement:"mouseout"==
this.type&&(b=a.toElement);this.relatedTarget=b;this.clientX=void 0!=a.clientX?a.clientX:a.pageX;this.clientY=void 0!=a.clientY?a.clientY:a.pageY;this.keyCode=a.keyCode?a.keyCode:a.which;this.charCode=a.charCode||("keypress"==this.type?this.keyCode:0);this.altKey=a.altKey;this.ctrlKey=a.ctrlKey;this.shiftKey=a.shiftKey}}
Se.prototype.preventDefault=function(){this.event&&(this.event.returnValue=!1,this.event.preventDefault&&this.event.preventDefault())};
var Te={stopImmediatePropagation:1,stopPropagation:1,preventMouseEvent:1,preventManipulation:1,preventDefault:1,layerX:1,layerY:1,scale:1,rotation:1,webkitMovementX:1,webkitMovementY:1};var pb=r("yt.events.listeners_")||{};q("yt.events.listeners_",pb,void 0);var Ue=r("yt.events.counter_")||{count:0};q("yt.events.counter_",Ue,void 0);function Ve(a,b,c,d){return ob(function(e){return e[0]==a&&e[1]==b&&e[2]==c&&e[4]==!!d})}
function N(a,b,c,d){if(!a||!a.addEventListener&&!a.attachEvent)return"";d=!!d;var e=Ve(a,b,c,d);if(e)return e;var e=++Ue.count+"",f=!("mouseenter"!=b&&"mouseleave"!=b||!a.addEventListener||"onmouseenter"in document),h;h=f?function(d){d=new Se(d);if(!Ne(d.relatedTarget,function(b){return b==a},!0))return d.currentTarget=a,d.type=b,c.call(a,d)}:function(b){b=new Se(b);
b.currentTarget=a;return c.call(a,b)};
h=nc(h);pb[e]=[a,b,c,h,d];a.addEventListener?"mouseenter"==b&&f?a.addEventListener("mouseover",h,d):"mouseleave"==b&&f?a.addEventListener("mouseout",h,d):"mousewheel"==b&&"MozBoxSizing"in document.documentElement.style?a.addEventListener("MozMousePixelScroll",h,d):a.addEventListener(b,h,d):a.attachEvent("on"+b,h);return e}
function We(a){a&&("string"==typeof a&&(a=[a]),y(a,function(a){if(a in pb){var c=pb[a],d=c[0],e=c[1],f=c[3],c=c[4];d.removeEventListener?d.removeEventListener(e,f,c):d.detachEvent&&d.detachEvent("on"+e,f);delete pb[a]}}))}
;function Xe(){if(null==r("_lact",window)){var a=parseInt(G("LACT"),10),a=isFinite(a)?w()-Math.max(a,0):-1;q("_lact",a,window);-1==a&&Ye();N(document,"keydown",Ye);N(document,"keyup",Ye);N(document,"mousedown",Ye);N(document,"mouseup",Ye);xc("page-mouse",Ye);xc("page-scroll",Ye);xc("page-resize",Ye)}}
function Ye(){null==r("_lact",window)&&(Xe(),r("_lact",window));var a=w();q("_lact",a,window);K("USER_ACTIVE")}
function Ze(){var a=r("_lact",window);return null==a?-1:Math.max(w()-a,0)}
;function $e(){}
;function af(a){this.f=a}
var bf=/\s*;\s*/;g=af.prototype;g.isEnabled=function(){return navigator.cookieEnabled};
function cf(a,b,c,d,e,f){if(/[;=\s]/.test(b))throw Error('Invalid cookie name "'+b+'"');if(/[;\r\n]/.test(c))throw Error('Invalid cookie value "'+c+'"');p(d)||(d=-1);f=f?";domain="+f:"";e=e?";path="+e:"";d=0>d?"":0==d?";expires="+(new Date(1970,1,1)).toUTCString():";expires="+(new Date(w()+1E3*d)).toUTCString();a.f.cookie=b+"="+c+f+e+d+""}
g.get=function(a,b){for(var c=a+"=",d=(this.f.cookie||"").split(bf),e=0,f;f=d[e];e++){if(0==f.lastIndexOf(c,0))return f.substr(c.length);if(f==a)return""}return b};
g.remove=function(a,b,c){var d=p(this.get(a));cf(this,a,"",0,b,c);return d};
g.ra=function(){return df(this).keys};
g.V=function(){return df(this).values};
g.isEmpty=function(){return!this.f.cookie};
g.Y=function(){return this.f.cookie?(this.f.cookie||"").split(bf).length:0};
g.Ya=function(a){for(var b=df(this).values,c=0;c<b.length;c++)if(b[c]==a)return!0;return!1};
g.clear=function(){for(var a=df(this).keys,b=a.length-1;0<=b;b--)this.remove(a[b])};
function df(a){a=(a.f.cookie||"").split(bf);for(var b=[],c=[],d,e,f=0;e=a[f];f++)d=e.indexOf("="),-1==d?(b.push(""),c.push(e)):(b.push(e.substring(0,d)),c.push(e.substring(d+1)));return{keys:b,values:c}}
var ef=new af(document);ef.h=3950;function ff(a,b,c){cf(ef,""+a,b,c,"/","youtube.com")}
;function gf(a,b,c){var d=G("EVENT_ID");d&&(b||(b={}),b.ei||(b.ei=d));if(b){var d=G("VALID_SESSION_TEMPDATA_DOMAINS",[]),e=Id(window.location.href);e&&d.push(e);e=Id(a);if(A(d,e)||!e&&0==a.lastIndexOf("/",0)){var f=a.match(Hd),d=f[5],e=f[6],f=f[7],h="";d&&(h+=d);e&&(h+="?"+e);f&&(h+="#"+f);d=h;e=d.indexOf("#");if(d=0>e?d:d.substr(0,e))e=G("ST_BASE36",!0),f=G("ST_SHORT",!0)?"ST-":"s_tempdata-",d=f=e?f+Ka(d).toString(36):f+Ka(d),e=b?Od(b):"",ff(d,e,5),b&&(b=b.itct||b.ved,d=r("yt.logging.screenreporter.storeParentElement"),
b&&d&&d(new $e))}}if(c)return!1;(window.ytspf||{}).enabled?spf.navigate(a):(c=window.location,a=Qd(a,{})+"",a=a instanceof Eb?a:Ib(a),c.href=Gb(a));return!0}
;function hf(a){a=a||{};this.url=a.url||"";this.urlV9As2=a.url_v9as2||"";this.args=a.args||tb(jf);this.assets=a.assets||{};this.attrs=a.attrs||tb(kf);this.params=a.params||tb(lf);this.minVersion=a.min_version||"8.0.0";this.fallback=a.fallback||null;this.fallbackMessage=a.fallbackMessage||null;this.html5=!!a.html5;this.disable=a.disable||{};this.loaded=!!a.loaded;this.messages=a.messages||{}}
var jf={enablejsapi:1},kf={},lf={allowscriptaccess:"always",allowfullscreen:"true",bgcolor:"#000000"};function mf(a){a instanceof hf||(a=new hf(a));return a}
hf.prototype.clone=function(){var a=new hf,b;for(b in this)if(this.hasOwnProperty(b)){var c=this[b];"object"==da(c)?a[b]=tb(c):a[b]=c}return a};function nf(a,b,c,d){this.top=a;this.right=b;this.bottom=c;this.left=d}
nf.prototype.clone=function(){return new nf(this.top,this.right,this.bottom,this.left)};
nf.prototype.contains=function(a){return this&&a?a instanceof nf?a.left>=this.left&&a.right<=this.right&&a.top>=this.top&&a.bottom<=this.bottom:a.x>=this.left&&a.x<=this.right&&a.y>=this.top&&a.y<=this.bottom:!1};
nf.prototype.floor=function(){this.top=Math.floor(this.top);this.right=Math.floor(this.right);this.bottom=Math.floor(this.bottom);this.left=Math.floor(this.left);return this};
nf.prototype.round=function(){this.top=Math.round(this.top);this.right=Math.round(this.right);this.bottom=Math.round(this.bottom);this.left=Math.round(this.left);return this};function of(a,b,c,d){this.left=a;this.top=b;this.width=c;this.height=d}
of.prototype.clone=function(){return new of(this.left,this.top,this.width,this.height)};
of.prototype.contains=function(a){return a instanceof of?this.left<=a.left&&this.left+this.width>=a.left+a.width&&this.top<=a.top&&this.top+this.height>=a.top+a.height:a.x>=this.left&&a.x<=this.left+this.width&&a.y>=this.top&&a.y<=this.top+this.height};
of.prototype.floor=function(){this.left=Math.floor(this.left);this.top=Math.floor(this.top);this.width=Math.floor(this.width);this.height=Math.floor(this.height);return this};
of.prototype.round=function(){this.left=Math.round(this.left);this.top=Math.round(this.top);this.width=Math.round(this.width);this.height=Math.round(this.height);return this};function pf(a){pf[" "](a);return a}
pf[" "]=t;function qf(a,b){var c=we(a);return c.defaultView&&c.defaultView.getComputedStyle&&(c=c.defaultView.getComputedStyle(a,null))?c[b]||c.getPropertyValue(b)||"":""}
function rf(a,b){return qf(a,b)||(a.currentStyle?a.currentStyle[b]:null)||a.style&&a.style[b]}
function sf(a){var b;try{b=a.getBoundingClientRect()}catch(c){return{left:0,top:0,right:0,bottom:0}}L&&a.ownerDocument.body&&(a=a.ownerDocument,b.left-=a.documentElement.clientLeft+a.body.clientLeft,b.top-=a.documentElement.clientTop+a.body.clientTop);return b}
function tf(a,b){"number"==typeof a&&(a=(b?Math.round(a):a)+"px");return a}
function uf(a){var b=vf;if("none"!=rf(a,"display"))return b(a);var c=a.style,d=c.display,e=c.visibility,f=c.position;c.visibility="hidden";c.position="absolute";c.display="inline";a=b(a);c.display=d;c.position=f;c.visibility=e;return a}
function vf(a){var b=a.offsetWidth,c=a.offsetHeight,d=ld&&!b&&!c;return p(b)&&!d||!a.getBoundingClientRect?new se(b,c):(a=sf(a),new se(a.right-a.left,a.bottom-a.top))}
function wf(a,b){if(/^\d+px?$/.test(b))return parseInt(b,10);var c=a.style.left,d=a.runtimeStyle.left;a.runtimeStyle.left=a.currentStyle.left;a.style.left=b;var e=a.style.pixelLeft;a.style.left=c;a.runtimeStyle.left=d;return e}
function xf(a,b){var c=a.currentStyle?a.currentStyle[b]:null;return c?wf(a,c):0}
var yf={thin:2,medium:4,thick:6};function zf(a,b){if("none"==(a.currentStyle?a.currentStyle[b+"Style"]:null))return 0;var c=a.currentStyle?a.currentStyle[b+"Width"]:null;return c in yf?yf[c]:wf(a,c)}
;var Af=B("Firefox"),Bf=hd()||B("iPod"),Cf=B("iPad"),Df=B("Android")&&!(Bb()||B("Firefox")||Ab()||B("Silk")),Ef=Bb(),Ff=B("Safari")&&!(Bb()||B("Coast")||Ab()||B("Edge")||B("Silk")||B("Android"))&&!(hd()||B("iPad")||B("iPod"));function Gf(){var a;if(a=ef.get("PREF",void 0)){a=unescape(a).split("&");for(var b=0;b<a.length;b++){var c=a[b].split("="),d=c[0];(c=c[1])&&(Hf[d]=c.toString())}}}
ba(Gf);var Hf=r("yt.prefs.UserPrefs.prefs_")||{};q("yt.prefs.UserPrefs.prefs_",Hf,void 0);function If(a){if(/^f([1-9][0-9]*)$/.test(a))throw"ExpectedRegexMatch: "+a;}
function Jf(a){if(!/^\w+$/.test(a))throw"ExpectedRegexMismatch: "+a;}
function Kf(a){a=void 0!==Hf[a]?Hf[a].toString():null;return null!=a&&/^[A-Fa-f0-9]+$/.test(a)?parseInt(a,16):null}
Gf.prototype.get=function(a,b){Jf(a);If(a);var c=void 0!==Hf[a]?Hf[a].toString():null;return null!=c?c:b?b:""};
function Lf(a,b){return!!((Kf("f"+(Math.floor(b/31)+1))||0)&1<<b%31)}
Gf.prototype.remove=function(a){Jf(a);If(a);delete Hf[a]};
Gf.prototype.clear=function(){Hf={}};function Mf(a,b){(a=xe(a))&&a.style&&(a.style.display=b?"":"none",qe(a,"hid",!b))}
function Nf(a){y(arguments,function(a){!fa(a)||a instanceof Element?Mf(a,!0):y(a,function(a){Nf(a)})})}
function Of(a){y(arguments,function(a){!fa(a)||a instanceof Element?Mf(a,!1):y(a,function(a){Of(a)})})}
;function Pf(){this.j=this.h=this.f=0;this.l="";var a=r("window.navigator.plugins"),b=r("window.navigator.mimeTypes"),a=a&&a["Shockwave Flash"],b=b&&b["application/x-shockwave-flash"],b=a&&b&&b.enabledPlugin&&a.description||"";if(a=b){var c=a.indexOf("Shockwave Flash");0<=c&&(a=a.substr(c+15));for(var c=a.split(" "),d="",a="",e=0,f=c.length;e<f;e++)if(d)if(a)break;else a=c[e];else d=c[e];d=d.split(".");c=parseInt(d[0],10)||0;d=parseInt(d[1],10)||0;e=0;if("r"==a.charAt(0)||"d"==a.charAt(0))e=parseInt(a.substr(1),
10)||0;a=[c,d,e]}else a=[0,0,0];this.l=b;b=a;this.f=b[0];this.h=b[1];this.j=b[2];if(0>=this.f){var h,k,l,n;if(rc)try{h=new ActiveXObject("ShockwaveFlash.ShockwaveFlash")}catch(H){h=null}else l=document.body,n=document.createElement("object"),n.setAttribute("type","application/x-shockwave-flash"),h=l.appendChild(n);if(h&&"GetVariable"in h)try{k=h.GetVariable("$version")}catch(H){k=""}l&&n&&l.removeChild(n);(h=k||"")?(h=h.split(" ")[1].split(","),h=[parseInt(h[0],10)||0,parseInt(h[1],10)||0,parseInt(h[2],
10)||0]):h=[0,0,0];this.f=h[0];this.h=h[1];this.j=h[2]}}
ba(Pf);function Qf(a,b,c,d){b="string"==typeof b?b.split("."):[b,c,d];b[0]=parseInt(b[0],10)||0;b[1]=parseInt(b[1],10)||0;b[2]=parseInt(b[2],10)||0;return a.f>b[0]||a.f==b[0]&&a.h>b[1]||a.f==b[0]&&a.h==b[1]&&a.j>=b[2]}
function Rf(a){return-1<a.l.indexOf("Gnash")&&-1==a.l.indexOf("AVM2")||9==a.f&&1==a.h||9==a.f&&0==a.h&&1==a.j?!1:9<=a.f}
function Sf(a){return nd?!Qf(a,11,2):md?!Qf(a,11,3):!Rf(a)}
;function Tf(a,b,c){if(b){a=u(a)?ye(a):a;var d=tb(c.attrs);d.tabindex=0;var e=tb(c.params);e.flashvars=Od(c.args);if(rc){d.classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000";e.movie=b;b=document.createElement("object");for(var f in d)b.setAttribute(f,d[f]);for(f in e)d=document.createElement("param"),d.setAttribute("name",f),d.setAttribute("value",e[f]),b.appendChild(d)}else{d.type="application/x-shockwave-flash";d.src=b;b=document.createElement("embed");b.setAttribute("name",d.id);for(f in d)b.setAttribute(f,
d[f]);for(f in e)b.setAttribute(f,e[f])}e=document.createElement("div");e.appendChild(b);a.innerHTML=e.innerHTML}}
function Uf(a,b,c){if(a&&a.attrs&&a.attrs.id){a=mf(a);var d=!!b,e=xe(a.attrs.id),f=e?e.parentNode:null;if(e&&f){if(window!=window.top){var h=null;if(document.referrer){var k=document.referrer.substring(0,128);Td(k)||(h=k)}else h="unknown";h&&(d=!0,a.args.framer=h)}h=Pf.getInstance();if(Qf(h,a.minVersion)){var k=Vf(a,h),l="";-1<navigator.userAgent.indexOf("Sony/COM2")||(l=e.getAttribute("src")||e.movie);(l!=k||d)&&Tf(f,k,a);Sf(h)&&Wf()}else Xf(f,a,h);c&&c()}else I(function(){Uf(a,b,c)},50)}}
function Xf(a,b,c){0==c.f&&b.fallback?b.fallback():0==c.f&&b.fallbackMessage?b.fallbackMessage():a.innerHTML='<div id="flash-upgrade">'+qc()+"</div>"}
function Vf(a,b){return Rf(b)&&a.url||(-1<navigator.userAgent.indexOf("Sony/COM2")&&!Qf(b,9,1,58)?!1:!0)&&a.urlV9As2||a.url}
function Wf(){var a=xe("flash10-promo-div"),b=Lf(Gf.getInstance(),107);a&&!b&&Nf(a)}
;function Yf(a){if(window.spf){var b=a.match(Zf);spf.style.load(a,b?b[1]:"",void 0)}else $f(a)}
function $f(a){var b=ag(a),c=document.getElementById(b),d=c&&C(c,"loaded");d||c&&!d||(c=bg(a,b,function(){C(c,"loaded")||(Pb(c,"loaded","true"),K(b),I(pa(Cc,b),0))}))}
function bg(a,b,c){var d=document.createElement("link");d.id=b;d.rel="stylesheet";d.onload=function(){c&&setTimeout(c,0)};
Ob(d,a);(document.getElementsByTagName("head")[0]||document.body).appendChild(d);return d}
function ag(a){var b=document.createElement("a");Ob(b,a);a=b.href.replace(/^[a-zA-Z]+:\/\//,"//");return"css-"+Ka(a)}
var Zf=/cssbin\/(?:debug-)?([a-zA-Z0-9_-]+?)(?:-2x|-web|-rtl|-vfl|.css)/;var cg;var dg=xb,dg=dg.toLowerCase();if(-1!=dg.indexOf("android")){var eg=dg.match(/android\D*(\d\.\d)[^\;|\)]*[\;\)]/);if(eg)cg=Number(eg[1]);else{var fg={cupcake:1.5,donut:1.6,eclair:2,froyo:2.2,gingerbread:2.3,honeycomb:3,"ice cream sandwich":4,jellybean:4.1},gg=dg.match("("+lb(fg).join("|")+")");cg=gg?fg[gg[0]]:0}}else cg=void 0;var hg=Bf||Cf;var ig=['video/mp4; codecs="avc1.42001E, mp4a.40.2"','video/webm; codecs="vp8.0, vorbis"'],jg=['audio/mp4; codecs="mp4a.40.2"'];function kg(a){D.call(this);this.f=[];this.h=a||this}
x(kg,D);function lg(a,b,c,d){d=nc(v(d,a.h));b.addEventListener(c,d);a.f.push({target:b,name:c,Hb:d})}
kg.prototype.zb=function(a){for(var b=0;b<this.f.length;b++)if(this.f[b]==a){this.f.splice(b,1);a.target.removeEventListener(a.name,a.Hb);break}};
function mg(a){for(;a.f.length;){var b=a.f.pop();b.target.removeEventListener(b.name,b.Hb)}}
kg.prototype.G=function(){mg(this);kg.I.G.call(this)};function ng(a,b){this.h=this.F=this.l="";this.B=null;this.o=this.f="";this.A=!1;var c;a instanceof ng?(this.A=p(b)?b:a.A,og(this,a.l),this.F=a.F,pg(this,a.h),qg(this,a.B),this.f=a.f,rg(this,a.j.clone()),this.o=a.o):a&&(c=String(a).match(Hd))?(this.A=!!b,og(this,c[1]||"",!0),this.F=sg(c[2]||""),pg(this,c[3]||"",!0),qg(this,c[4]),this.f=sg(c[5]||"",!0),rg(this,c[6]||"",!0),this.o=sg(c[7]||"")):(this.A=!!b,this.j=new tg(null,0,this.A))}
ng.prototype.toString=function(){var a=[],b=this.l;b&&a.push(ug(b,vg,!0),":");var c=this.h;if(c||"file"==b)a.push("//"),(b=this.F)&&a.push(ug(b,vg,!0),"@"),a.push(encodeURIComponent(String(c)).replace(/%25([0-9a-fA-F]{2})/g,"%$1")),c=this.B,null!=c&&a.push(":",String(c));if(c=this.f)this.h&&"/"!=c.charAt(0)&&a.push("/"),a.push(ug(c,"/"==c.charAt(0)?wg:xg,!0));(c=this.j.toString())&&a.push("?",c);(c=this.o)&&a.push("#",ug(c,yg));return a.join("")};
ng.prototype.resolve=function(a){var b=this.clone(),c=!!a.l;c?og(b,a.l):c=!!a.F;c?b.F=a.F:c=!!a.h;c?pg(b,a.h):c=null!=a.B;var d=a.f;if(c)qg(b,a.B);else if(c=!!a.f){if("/"!=d.charAt(0))if(this.h&&!this.f)d="/"+d;else{var e=b.f.lastIndexOf("/");-1!=e&&(d=b.f.substr(0,e+1)+d)}e=d;if(".."==e||"."==e)d="";else if(-1!=e.indexOf("./")||-1!=e.indexOf("/.")){for(var d=0==e.lastIndexOf("/",0),e=e.split("/"),f=[],h=0;h<e.length;){var k=e[h++];"."==k?d&&h==e.length&&f.push(""):".."==k?((1<f.length||1==f.length&&
""!=f[0])&&f.pop(),d&&h==e.length&&f.push("")):(f.push(k),d=!0)}d=f.join("/")}else d=e}c?b.f=d:c=""!==a.j.toString();c?rg(b,sg(a.j.toString())):c=!!a.o;c&&(b.o=a.o);return b};
ng.prototype.clone=function(){return new ng(this)};
function og(a,b,c){a.l=c?sg(b,!0):b;a.l&&(a.l=a.l.replace(/:$/,""))}
function pg(a,b,c){a.h=c?sg(b,!0):b}
function qg(a,b){if(b){b=Number(b);if(isNaN(b)||0>b)throw Error("Bad port number "+b);a.B=b}else a.B=null}
function rg(a,b,c){b instanceof tg?(a.j=b,zg(a.j,a.A)):(c||(b=ug(b,Ag)),a.j=new tg(b,0,a.A))}
function O(a,b,c){a=a.j;Bg(a);a.j=null;b=Cg(a,b);Dg(a,b)&&(a.h=a.h-a.f.get(b).length);Wc(a.f,b,[c]);a.h=a.h+1}
function Eg(a,b,c){ea(c)||(c=[String(c)]);Fg(a.j,b,c)}
function Gg(a){O(a,"zx",Math.floor(2147483648*Math.random()).toString(36)+Math.abs(Math.floor(2147483648*Math.random())^w()).toString(36));return a}
function Hg(a){return a instanceof ng?a.clone():new ng(a,void 0)}
function Ig(a,b,c,d){var e=new ng(null,void 0);a&&og(e,a);b&&pg(e,b);c&&qg(e,c);d&&(e.f=d);return e}
function sg(a,b){return a?b?decodeURI(a.replace(/%25/g,"%2525")):decodeURIComponent(a):""}
function ug(a,b,c){return u(a)?(a=encodeURI(a).replace(b,Jg),c&&(a=a.replace(/%25([0-9a-fA-F]{2})/g,"%$1")),a):null}
function Jg(a){a=a.charCodeAt(0);return"%"+(a>>4&15).toString(16)+(a&15).toString(16)}
var vg=/[#\/\?@]/g,xg=/[\#\?:]/g,wg=/[\#\?]/g,Ag=/[\#\?@]/g,yg=/#/g;function tg(a,b,c){this.h=this.f=null;this.j=a||null;this.l=!!c}
function Bg(a){a.f||(a.f=new Vc,a.h=0,a.j&&Jd(a.j,function(b,c){var d=ua(b);Bg(a);a.j=null;var d=Cg(a,d),e=a.f.get(d);e||Wc(a.f,d,e=[]);e.push(c);a.h=a.h+1}))}
g=tg.prototype;g.Y=function(){Bg(this);return this.h};
g.remove=function(a){Bg(this);a=Cg(this,a);return Yc(this.f.h,a)?(this.j=null,this.h=this.h-this.f.get(a).length,this.f.remove(a)):!1};
g.clear=function(){this.f=this.j=null;this.h=0};
g.isEmpty=function(){Bg(this);return 0==this.h};
function Dg(a,b){Bg(a);b=Cg(a,b);return Yc(a.f.h,b)}
g.Ya=function(a){var b=this.V();return A(b,a)};
g.ra=function(){Bg(this);for(var a=this.f.V(),b=this.f.ra(),c=[],d=0;d<b.length;d++)for(var e=a[d],f=0;f<e.length;f++)c.push(b[d]);return c};
g.V=function(a){Bg(this);var b=[];if(u(a))Dg(this,a)&&(b=Xa(b,this.f.get(Cg(this,a))));else{a=this.f.V();for(var c=0;c<a.length;c++)b=Xa(b,a[c])}return b};
g.get=function(a,b){var c=a?this.V(a):[];return 0<c.length?String(c[0]):b};
function Fg(a,b,c){a.remove(b);0<c.length&&(a.j=null,Wc(a.f,Cg(a,b),Ya(c)),a.h=a.h+c.length)}
g.toString=function(){if(this.j)return this.j;if(!this.f)return"";for(var a=[],b=this.f.ra(),c=0;c<b.length;c++)for(var d=b[c],e=encodeURIComponent(String(d)),d=this.V(d),f=0;f<d.length;f++){var h=e;""!==d[f]&&(h+="="+encodeURIComponent(String(d[f])));a.push(h)}return this.j=a.join("&")};
g.clone=function(){var a=new tg;a.j=this.j;this.f&&(a.f=this.f.clone(),a.h=this.h);return a};
function Cg(a,b){var c=String(b);a.l&&(c=c.toLowerCase());return c}
function zg(a,b){b&&!a.l&&(Bg(a),a.j=null,a.f.forEach(function(a,b){var e=b.toLowerCase();b!=e&&(this.remove(b),Fg(this,e,a))},a));
a.l=b}
;var Kg="corp.google.com googleplex.com youtube.com youtube-nocookie.com youtubeeducation.com borg.google.com prod.google.com sandbox.google.com books.googleusercontent.com docs.google.com drive.google.com mail.google.com photos.google.com plus.google.com lh2.google.com picasaweb.google.com play.google.com googlevideo.com talkgadget.google.com survey.g.doubleclick.net youtube.googleapis.com vevo.com".split(" "),Lg="";
function Mg(a){return a&&a==Lg?!0:(new RegExp("^(https?:)?//([a-z0-9-]{1,63}\\.)*("+Kg.join("|").replace(/\./g,".")+")(:[0-9]+)?([/?#]|$)","i")).test(a)?(Lg=a,!0):!1}
;var Ng={},Og=0,Pg=r("yt.net.ping.workerUrl_")||null;q("yt.net.ping.workerUrl_",Pg,void 0);function Qg(a){try{window.navigator&&window.navigator.sendBeacon&&window.navigator.sendBeacon(a,"")||a&&Rg(a)}catch(b){a&&Rg(a)}}
function Rg(a){var b=new Image,c=""+Og++;Ng[c]=b;b.onload=b.onerror=function(){delete Ng[c]};
b.src=a}
;function P(a,b){this.version=a;this.args=b}
function Sg(a){if(!a.Fa){var b={};a.call(b);a.Fa=b.version}return a.Fa}
function Tg(a,b){function c(){a.apply(this,b.args)}
if(!b.args||!b.version)throw Error("yt.pubsub2.Data.deserialize(): serializedData is incomplete.");var d;try{d=Sg(a)}catch(e){}if(!d||b.version!=d)throw Error("yt.pubsub2.Data.deserialize(): serializedData version is incompatible.");c.prototype=a.prototype;try{return new c}catch(e){throw e.message="yt.pubsub2.Data.deserialize(): "+e.message,e;}}
function Q(a,b){this.topic=a;this.f=b}
Q.prototype.toString=function(){return this.topic};var Ug=r("yt.pubsub2.instance_")||new F;F.prototype.subscribe=F.prototype.subscribe;F.prototype.unsubscribeByKey=F.prototype.oa;F.prototype.publish=F.prototype.D;F.prototype.clear=F.prototype.clear;q("yt.pubsub2.instance_",Ug,void 0);var Vg=r("yt.pubsub2.subscribedKeys_")||{};q("yt.pubsub2.subscribedKeys_",Vg,void 0);var Wg=r("yt.pubsub2.topicToKeys_")||{};q("yt.pubsub2.topicToKeys_",Wg,void 0);var Xg=r("yt.pubsub2.isAsync_")||{};q("yt.pubsub2.isAsync_",Xg,void 0);
q("yt.pubsub2.skipSubKey_",null,void 0);function R(a,b){var c=Yg();c&&c.publish.call(c,a.toString(),a,b)}
function Zg(a,b,c){var d=Yg();if(!d)return 0;var e=d.subscribe(a.toString(),function(d,h){if(!window.yt.pubsub2.skipSubKey_||window.yt.pubsub2.skipSubKey_!=e){var k=function(){if(Vg[e])try{if(h&&a instanceof Q&&a!=d)try{h=Tg(a.f,h)}catch(k){throw k.message="yt.pubsub2 cross-binary conversion error for "+a.toString()+": "+k.message,k;}b.call(c||window,h)}catch(k){pc(k)}};
Xg[a.toString()]?r("yt.scheduler.instance")?ge(k,void 0):I(k,0):k()}});
Vg[e]=!0;Wg[a.toString()]||(Wg[a.toString()]=[]);Wg[a.toString()].push(e);return e}
function $g(a){var b=Yg();b&&(ga(a)&&(a=[a]),y(a,function(a){b.unsubscribeByKey(a);delete Vg[a]}))}
function Yg(){return r("yt.pubsub2.instance_")}
;function ah(a){P.call(this,1,arguments)}
x(ah,P);var bh=new Q("timing-sent",ah);var S=window.performance||window.mozPerformance||window.msPerformance||window.webkitPerformance||{},ch=v(S.clearResourceTimings||S.webkitClearResourceTimings||S.mozClearResourceTimings||S.msClearResourceTimings||S.oClearResourceTimings||t,S),dh=S.mark?function(a){S.mark(a)}:t;
function eh(a){fh()[a]=w();dh(a);var b=G("TIMING_ACTION",void 0);a=fh();if(r("yt.timing.ready_")&&b&&a._start&&gh()){var b=!0,c=G("TIMING_WAIT",[]);if(c.length)for(var d=0,e=c.length;d<e;++d)if(!(c[d]in a)){b=!1;break}if(b)if(c=fh(),a=hh().span,d=hh().info,b=r("yt.timing.reportbuilder_")){if(b=b(c,a,d,void 0))ih(b),jh()}else{e=G("CSI_SERVICE_NAME","youtube");b={v:2,s:e,action:G("TIMING_ACTION",void 0)};if(S.now&&S.timing){var f=S.timing.navigationStart+S.now(),f=Math.round(w()-f);d.yt_hrd=f}var f=
G("TIMING_INFO",{}),h;for(h in f)d[h]=f[h];h=d.srt;delete d.srt;var k;h||0===h||(k=S.timing||{},h=Math.max(0,k.responseStart-k.navigationStart),isNaN(h)&&d.pt&&(h=d.pt));if(h||0===h)d.srt=h;d.h5jse&&(f=window.location.protocol+r("ytplayer.config.assets.js"),(f=S.getEntriesByName?S.getEntriesByName(f)[0]:null)?d.h5jse=Math.round(d.h5jse-f.responseEnd):delete d.h5jse);c.aft=gh();f=c._start;if("cold"==d.yt_lt){k||(k=S.timing||{});var l;a:if(l=k,l.msFirstPaint)l=Math.max(0,l.msFirstPaint);else{var n=
window.chrome;if(n&&(n=n.loadTimes,ha(n))){var n=n(),H=1E3*Math.min(n.requestTime||Infinity,n.startLoadTime||Infinity),H=Infinity===H?0:l.navigationStart-H;l=Math.max(0,Math.round(1E3*n.firstPaintTime+H)||0);break a}l=0}0<l&&l>f&&(c.fpt=l);l=a||hh().span;n=k.redirectEnd-k.redirectStart;0<n&&(l.rtime_=n);n=k.domainLookupEnd-k.domainLookupStart;0<n&&(l.dns_=n);n=k.connectEnd-k.connectStart;0<n&&(l.tcp_=n);n=k.connectEnd-k.secureConnectionStart;k.secureConnectionStart>=k.navigationStart&&0<n&&(l.stcp_=
n);n=k.responseStart-k.requestStart;0<n&&(l.req_=n);n=k.responseEnd-k.responseStart;0<n&&(l.rcv_=n);S.getEntriesByType&&kh(c)}n=fh();k=n.pbr;l=n.vc;n=n.pbs;k&&l&&n&&k<l&&l<n&&1==hh().info.yt_vis&&"youtube"==e&&(hh().info.yt_lt="hot_bg",k=c.vc,e=c.pbs,delete c.aft,a.aft=Math.round(e-k));(k=G("PREVIOUS_ACTION"))&&(d.pa=k);d.p=G("CLIENT_PROTOCOL")||"unknown";d.t=G("CLIENT_TRANSPORT")||"unknown";window.navigator&&window.navigator.sendBeacon&&(d.ba=1);for(var ca in d)"_"!=ca.charAt(0)&&(b[ca]=d[ca]);c.ps=
w();ca={};var d=[],sa;for(sa in c)"_"!=sa.charAt(0)&&(l=Math.round(c[sa]-f),ca[sa]=l,d.push(sa+"."+l));b.rt=d.join(",");sa=b;var c=[],rb;for(rb in a)"_"!=rb.charAt(0)&&c.push(rb+"."+a[rb]);sa.it=c.join(",");(rb=r("ytdebug.logTiming"))&&rb(b,ca,a);jh();G("EXP_DEFER_CSI_PING")?(lh(),q("yt.timing.deferredPingArgs_",b,void 0),rb=I(lh,0),q("yt.timing.deferredPingTimer_",rb,void 0)):ih(b);R(bh,new ah(ca.aft+(h||0)))}}}
function jh(){mh();ch();q("yt.timing.pingSent_",!1,void 0)}
function gh(){var a=fh();if(a.aft)return a.aft;for(var b=G("TIMING_AFT_KEYS",["ol"]),c=b.length,d=0;d<c;d++){var e=a[b[d]];if(e)return e}return NaN}
function nh(a){return Math.round(S.timing.navigationStart+a)}
function kh(a){var b=window.location.protocol,c=S.getEntriesByType("resource"),d=c.filter(function(a){return 0==a.name.indexOf(b+"//fonts.googleapis.com/css?family=")})[0],c=c.filter(function(a){return 0==a.name.indexOf(b+"//fonts.gstatic.com/s/")}).reduce(function(a,b){return b.duration>a.duration?b:a},{duration:0});
d&&0<d.startTime&&0<d.responseEnd&&(a.wfcs=nh(d.startTime),a.wfce=nh(d.responseEnd));c&&0<c.startTime&&0<c.responseEnd&&(a.wffs=nh(c.startTime),a.wffe=nh(c.responseEnd))}
function ih(a){if(G("DEBUG_CSI_DATA")){var b=r("yt.timing.csiData");b||(b=[],q("yt.timing.csiData",b,void 0));b.push({page:location.href,time:new Date,args:a})}G("EXP_DEFER_CSI_PING")&&(J(r("yt.timing.deferredPingTimer_")),q("yt.timing.deferredPingArgs_",null,void 0));var c="https:"==window.location.protocol?"https://gg.google.com/csi":"http://csi.gstatic.com/csi",c=G("CSI_LOG_WITH_YT")?"/csi_204":c,b="",d;for(d in a)b+="&"+d+"="+a[d];a=c+"?"+b.substring(1);b=G("DOUBLE_LOG_CSI")?"/csi_204?"+b.substring(1):
null;window.navigator&&window.navigator.sendBeacon?(Qg(a),b&&Qg(b)):(a&&Rg(a),b&&b&&Rg(b));q("yt.timing.pingSent_",!0,void 0)}
function lh(a){if(G("EXP_DEFER_CSI_PING")){var b=r("yt.timing.deferredPingArgs_");b&&(a&&(b.yt_fss=a),ih(b))}}
function fh(){return hh().tick}
function hh(){return r("ytcsi.data_")||mh()}
function mh(){var a={tick:{},span:{},info:{}};q("ytcsi.data_",a,void 0);return a}
;var oh={"api.invalidparam":2,auth:150,"drm.auth":150,heartbeat:150,"html5.unsupportedads":5,"fmt.noneavailable":5,"fmt.decode":5,"fmt.unplayable":5,"html5.missingapi":5,"drm.unavailable":5};function ph(a,b){D.call(this);this.o=this.l=a;this.Z=b;this.F=!1;this.api={};this.va=this.R=null;this.ha=new F;gc(this,pa(E,this.ha));this.j={};this.A=this.Aa=this.h=this.Fb=this.f=null;this.qa=!1;this.J=this.B=this.O=this.P=null;this.Ma={};this.hd=["onReady"];this.ta=new kg(this);gc(this,pa(E,this.ta));this.Gb=null;this.fc=NaN;this.ua={};qh(this);this.xa("onDetailedError",v(this.Ud,this));this.xa("onTabOrderChange",v(this.ld,this));this.xa("onTabAnnounce",v(this.gc,this));this.xa("WATCH_LATER_VIDEO_ADDED",
v(this.Vd,this));this.xa("WATCH_LATER_VIDEO_REMOVED",v(this.Wd,this));Af||(this.xa("onMouseWheelCapture",v(this.Rd,this)),this.xa("onMouseWheelRelease",v(this.Sd,this)));this.xa("onAdAnnounce",v(this.gc,this));this.K=new kg(this);gc(this,pa(E,this.K));this.Eb=!1;this.Wa=null}
x(ph,D);var rh=["drm.unavailable","fmt.noneavailable","html5.missingapi","html5.unsupportedads","html5.unsupportedlive"];g=ph.prototype;g.bc=function(a,b){this.isDisposed()||(sh(this,a),b||th(this),uh(this,b),this.F&&vh(this))};
function sh(a,b){a.Fb=b;a.f=b.clone();a.h=a.f.attrs.id||a.h;"video-player"==a.h&&(a.h=a.Z,a.f.attrs.id=a.Z);a.o.id==a.h&&(a.h+="-player",a.f.attrs.id=a.h);a.f.args.enablejsapi="1";a.f.args.playerapiid=a.Z;a.Aa||(a.Aa=wh(a,a.f.args.jsapicallback||"onYouTubePlayerReady"));a.f.args.jsapicallback=null;var c=a.f.attrs.width;c&&(a.o.style.width=tf(Number(c)||c,!0));if(c=a.f.attrs.height)a.o.style.height=tf(Number(c)||c,!0)}
g.vd=function(){return this.Fb};
function vh(a){a.f.loaded||(a.f.loaded=!0,"0"!=a.f.args.autoplay?a.api.loadVideoByPlayerVars(a.f.args):a.api.cueVideoByPlayerVars(a.f.args))}
function xh(a){if(!p(a.f.disable.flash)){var b=a.f.disable,c;c=Qf(Pf.getInstance(),a.f.minVersion);b.flash=!c}return!a.f.disable.flash}
function th(a){var b;if(!(b=!a.f.html5&&xh(a))){if(!p(a.f.disable.html5)){var c;b=!0;void 0!=a.f.args.deviceHasDisplay&&(b=a.f.args.deviceHasDisplay);if(2.2==cg)c=!0;else{a:{var d=b;b=r("yt.player.utils.videoElement_");b||(b=document.createElement("video"),q("yt.player.utils.videoElement_",b,void 0));try{if(b.canPlayType)for(var d=d?ig:jg,e=0;e<d.length;e++)if(b.canPlayType(d[e])){c=null;break a}c="fmt.noneavailable"}catch(f){c="html5.missingapi"}}c=!c}c&&(c=yh(a)||a.f.assets.js);a.f.disable.html5=
!c;c||(a.f.args.html5_unavailable="1")}b=!!a.f.disable.html5}return b?xh(a)?"flash":"unsupported":"html5"}
function zh(a,b){if(!b||(5!=(oh[b.errorCode]||5)?0:-1!=rh.indexOf(b.errorCode))){var c=Ah(a);c&&c.stopVideo&&c.stopVideo();if(xh(a)){var d=a.f;c&&c.getUpdatedConfigurationData&&(c=c.getUpdatedConfigurationData(),d=mf(c));d.args.autoplay=1;d.args.html5_unavailable="1";sh(a,d);uh(a,"flash")}}}
function uh(a,b){a.isDisposed()||(b||(b=th(a)),("flash"==b?a.Fe:"html5"==b?a.Ge:a.He).call(a))}
function yh(a){var b=!0,c=Ah(a);c&&a.f&&(a=a.f,b=C(c,"version")==a.assets.js);return b&&!!r("yt.player.Application.create")}
g.Ge=function(){if(!this.qa){var a=yh(this);a&&"html5"==Bh(this)?(this.A="html5",this.F||this.Sa()):(Ch(this),this.A="html5",a&&this.O?(this.l.appendChild(this.O),this.Sa()):(this.f.loaded=!0,this.P=v(function(){var a=this.l,c=this.f.clone();r("yt.player.Application.create")(a,c);this.Sa()},this),this.qa=!0,a?this.P():(Dc(this.f.assets.js,this.P),Yf(this.f.assets.css))))}};
g.Fe=function(){var a=this.f.clone();if(!this.B){var b=Ah(this);b&&(this.B=document.createElement("span"),this.B.tabIndex=0,lg(this.ta,this.B,"focus",this.uc),this.J=document.createElement("span"),this.J.tabIndex=0,lg(this.ta,this.J,"focus",this.uc),b.parentNode&&b.parentNode.insertBefore(this.B,b),b.parentNode&&b.parentNode.insertBefore(this.J,b.nextSibling))}a.attrs.width=a.attrs.width||"100%";a.attrs.height=a.attrs.height||"100%";if("flash"==Bh(this))this.A="flash",this.F||Uf(a,!1,v(this.Sa,this));
else{Ch(this);this.A="flash";this.f.loaded=!0;b=this.l;b=u(b)?ye(b):b;a=mf(a);if(window!=window.top){var c=null;document.referrer&&(c=document.referrer.substring(0,128));a.args.framer=c}c=Pf.getInstance();Qf(c,a.minVersion)?(c=Vf(a,c),Tf(b,c,a)):Xf(b,a,c);this.Sa()}};
g.uc=function(){Ah(this).focus()};
function Ah(a){var b=xe(a.h);!b&&a.o&&a.o.querySelector&&(b=a.o.querySelector("#"+a.h));return b}
g.Sa=function(){if(!this.isDisposed()){var a=Ah(this),b=!1;try{a&&a.getApiInterface&&a.getApiInterface()&&(b=!0)}catch(f){}if(b)if(this.qa=!1,a.isNotServable&&a.isNotServable(this.f.args.video_id))zh(this);else{qh(this);this.F=!0;a=Ah(this);a.addEventListener&&(this.R=Dh(this,a,"addEventListener"));a.removeEventListener&&(this.va=Dh(this,a,"removeEventListener"));for(var b=a.getApiInterface(),b=b.concat(a.getInternalApiInterface()),c=0;c<b.length;c++){var d=b[c];this.api[d]||(this.api[d]=Dh(this,
a,d))}for(var e in this.j)this.R(e,this.j[e]);vh(this);this.Aa&&this.Aa(this.api);this.ha.D("onReady",this.api)}else this.fc=I(v(this.Sa,this),50)}};
function Dh(a,b,c){var d=b[c];return function(){try{return a.Gb=null,d.apply(b,arguments)}catch(e){"Bad NPObject as private data!"!=e.message&&"sendAbandonmentPing"!=c&&(e.message+=" ("+c+")",a.Gb=e,pc(e,"WARNING"))}}}
function qh(a){a.F=!1;if(a.va)for(var b in a.j)a.va(b,a.j[b]);for(var c in a.ua)J(parseInt(c,10));a.ua={};a.R=null;a.va=null;for(var d in a.api)a.api[d]=null;a.api.addEventListener=v(a.xa,a);a.api.removeEventListener=v(a.qe,a);a.api.destroy=v(a.dispose,a);a.api.getLastError=v(a.wd,a);a.api.getPlayerType=v(a.xd,a);a.api.getCurrentVideoConfig=v(a.vd,a);a.api.loadNewVideoConfig=v(a.bc,a);a.api.isReady=v(a.Se,a)}
g.Se=function(){return this.F};
g.xa=function(a,b){if(!this.isDisposed()){var c=wh(this,b);if(c){if(!A(this.hd,a)&&!this.j[a]){var d=Eh(this,a);this.R&&this.R(a,d)}this.ha.subscribe(a,c);"onReady"==a&&this.F&&I(pa(c,this.api),0)}}};
g.qe=function(a,b){if(!this.isDisposed()){var c=wh(this,b);c&&this.ha.unsubscribe(a,c)}};
function wh(a,b){var c=b;if("string"==typeof b){if(a.Ma[b])return a.Ma[b];c=function(){var a=r(b);a&&a.apply(m,arguments)};
a.Ma[b]=c}return c?c:null}
function Eh(a,b){var c="ytPlayer"+b+a.Z;a.j[b]=c;m[c]=function(c){var e=I(function(){if(!a.isDisposed()){a.ha.D(b,c);var f=a.ua,h=String(e);h in f&&delete f[h]}},0);
sb(a.ua,String(e))};
return c}
g.ld=function(a){a=a?Fe:Ee;for(var b=a(document.activeElement);b&&(1!=b.nodeType||b==this.B||b==this.J||(b.focus(),b!=document.activeElement));)b=a(b)};
g.gc=function(a){K("a11y-announce",a)};
g.Ud=function(a){zh(this,a)};
g.Vd=function(a){K("WATCH_LATER_VIDEO_ADDED",a)};
g.Wd=function(a){K("WATCH_LATER_VIDEO_REMOVED",a)};
g.Rd=function(){this.Eb||(Ef?(this.Wa=Be(document),lg(this.K,window,"scroll",this.le),lg(this.K,this.l,"touchmove",this.fe)):(lg(this.K,this.l,"mousewheel",this.yc),lg(this.K,this.l,"wheel",this.yc)),this.Eb=!0)};
g.Sd=function(){mg(this.K);this.Eb=!1};
g.yc=function(a){a=a||window.event;a.returnValue=!1;a.preventDefault&&a.preventDefault()};
g.le=function(){window.scrollTo(this.Wa.x,this.Wa.y)};
g.fe=function(a){a.preventDefault()};
g.He=function(){Ch(this);this.A="unsupported";var a='Adobe Flash Player or an HTML5 supported browser is required for video playback. <br> <a href="http://get.adobe.com/flashplayer/">Get the latest Flash Player</a> <br> <a href="/html5">Learn more about upgrading to an HTML5 browser</a>',b=navigator.userAgent.match(/Version\/(\d).*Safari/);b&&5<=parseInt(b[1],10)&&(a='Adobe Flash Player or QuickTime is required for video playback. <br> <a href="http://get.adobe.com/flashplayer/"> Get the latest Flash Player</a> <br> <a href="http://www.apple.com/quicktime/download/">Get the latest version of QuickTime</a>');
b=this.f.messages.player_fallback||a;a=xe("player-unavailable");if(xe("unavailable-submessage")&&a){xe("unavailable-submessage").innerHTML=b;var b=a||document,c=null;b.getElementsByClassName?c=b.getElementsByClassName("icon")[0]:b.querySelectorAll&&b.querySelector?c=b.querySelector(".icon"):c=Ae("icon",a)[0];if(c=b=c||null)c=b?b.dataset?Qb("icon")in b.dataset:b.hasAttribute?!!b.hasAttribute("data-icon"):!!b.getAttribute("data-icon"):!1;c&&(b.src=C(b,"icon"));a.style.display="";oe(xe("player"),"off-screen-trigger")}};
g.xd=function(){return this.A||Bh(this)};
g.wd=function(){return this.Gb};
function Bh(a){return(a=Ah(a))?"div"==a.tagName.toLowerCase()?"html5":"flash":null}
function Ch(a){eh("dcp");a.cancel();qh(a);a.A=null;a.f&&(a.f.loaded=!1);var b=Ah(a);"html5"==Bh(a)?a.O=b:b&&b.destroy&&b.destroy();De(a.l);mg(a.ta);a.B=null;a.J=null}
g.cancel=function(){this.P&&Kc(this.f.assets.js,this.P);J(this.fc);this.qa=!1};
g.G=function(){Ch(this);if(this.O&&this.f)try{this.O.destroy()}catch(b){pc(b)}this.Ma=null;for(var a in this.j)m[this.j[a]]=null;this.Fb=this.f=this.api=null;delete this.l;delete this.o;ph.I.G.call(this)};var Fh={},Gh="player_uid_"+(1E9*Math.random()>>>0);function Hh(a,b){a=u(a)?ye(a):a;b=mf(b);var c=Gh+"_"+ka(a),d=Fh[c];if(d)return d.bc(b),d.api;d=new ph(a,c);Fh[c]=d;K("player-added",d.api);gc(d,pa(Ih,d));I(function(){d.bc(b)},0);
return d.api}
function Ih(a){Fh[a.Z]=null}
function Jh(a){a=xe(a);if(!a)return null;var b=Gh+"_"+ka(a),c=Fh[b];c||(c=new ph(a,b),Fh[b]=c);return c.api}
;var Kh=r("yt.abuse.botguardInitialized")||Nc;q("yt.abuse.botguardInitialized",Kh,void 0);var Lh=r("yt.abuse.invokeBotguard")||Oc;q("yt.abuse.invokeBotguard",Lh,void 0);var Mh=r("yt.abuse.dclkstatus.checkDclkStatus")||le;q("yt.abuse.dclkstatus.checkDclkStatus",Mh,void 0);var Nh=r("yt.player.exports.navigate")||gf;q("yt.player.exports.navigate",Nh,void 0);var Oh=r("yt.player.embed")||Hh;q("yt.player.embed",Oh,void 0);var Ph=r("yt.player.getPlayerByElement")||Jh;q("yt.player.getPlayerByElement",Ph,void 0);
var Qh=r("yt.util.activity.init")||Xe;q("yt.util.activity.init",Qh,void 0);var Rh=r("yt.util.activity.getTimeSinceActive")||Ze;q("yt.util.activity.getTimeSinceActive",Rh,void 0);var Sh=r("yt.util.activity.setTimestamp")||Ye;q("yt.util.activity.setTimestamp",Sh,void 0);function Th(a){P.call(this,1,arguments);this.f=a}
x(Th,P);function Uh(a){P.call(this,1,arguments);this.f=a}
x(Uh,P);function Vh(a,b){P.call(this,1,arguments);this.f=a;this.isEnabled=b}
x(Vh,P);function Wh(a,b,c,d,e){P.call(this,2,arguments);this.h=a;this.f=b;this.l=c||null;this.j=d||null;this.source=e||null}
x(Wh,P);function Xh(a,b,c){P.call(this,1,arguments);this.f=a;this.subscriptionId=b}
x(Xh,P);function Yh(a,b,c,d,e,f,h){P.call(this,1,arguments);this.h=a;this.subscriptionId=b;this.f=c;this.o=d||null;this.l=e||null;this.j=f||null;this.source=h||null}
x(Yh,P);
var Zh=new Q("subscription-batch-subscribe",Th),$h=new Q("subscription-batch-unsubscribe",Th),ai=new Q("subscription-pref-email",Vh),bi=new Q("subscription-subscribe",Wh),ci=new Q("subscription-subscribe-loading",Uh),di=new Q("subscription-subscribe-loaded",Uh),ei=new Q("subscription-subscribe-success",Xh),fi=new Q("subscription-subscribe-external",Wh),gi=new Q("subscription-unsubscribe",Yh),hi=new Q("subscription-unsubscirbe-loading",Uh),ii=new Q("subscription-unsubscribe-loaded",Uh),ji=new Q("subscription-unsubscribe-success",
Uh),ki=new Q("subscription-external-unsubscribe",Yh),li=new Q("subscription-enable-ypc",Uh),mi=new Q("subscription-disable-ypc",Uh);function ni(a,b){var c=document.location.protocol+"//"+document.domain+"/post_login";b&&(c=Pd(c,"mode",b));c=Pd("/signin?context=popup","next",c);c=Pd(c,"feature","sub_button");if(c=window.open(c,"loginPopup","width=375,height=440,resizable=yes,scrollbars=yes",!0)){var d=xc("LOGGED_IN",function(b){zc(G("LOGGED_IN_PUBSUB_KEY",void 0));lc("LOGGED_IN",!0);a(b)});
lc("LOGGED_IN_PUBSUB_KEY",d);c.moveTo((screen.width-375)/2,(screen.height-440)/2)}}
q("yt.pubsub.publish",K,void 0);function oi(){var a=G("PLAYER_CONFIG");return a&&a.args&&void 0!==a.args.authuser?!0:!(!G("SESSION_INDEX")&&!G("LOGGED_IN"))}
;var pi={},qi="ontouchstart"in document;function ri(a,b,c){var d;switch(a){case "mouseover":case "mouseout":d=3;break;case "mouseenter":case "mouseleave":d=9}return Ne(c,function(a){return ne(a,b)},!0,d)}
function si(a){var b="mouseover"==a.type&&"mouseenter"in pi||"mouseout"==a.type&&"mouseleave"in pi,c=a.type in pi||b;if("HTML"!=a.target.tagName&&c){if(b){var b="mouseover"==a.type?"mouseenter":"mouseleave",c=pi[b],d;for(d in c.ga){var e=ri(b,d,a.target);e&&!Ne(a.relatedTarget,function(a){return a==e},!0)&&c.D(d,e,b,a)}}if(b=pi[a.type])for(d in b.ga)(e=ri(a.type,d,a.target))&&b.D(d,e,a.type,a)}}
N(document,"blur",si,!0);N(document,"change",si,!0);N(document,"click",si);N(document,"focus",si,!0);N(document,"mouseover",si);N(document,"mouseout",si);N(document,"mousedown",si);N(document,"keydown",si);N(document,"keyup",si);N(document,"keypress",si);N(document,"cut",si);N(document,"paste",si);qi&&(N(document,"touchstart",si),N(document,"touchend",si),N(document,"touchcancel",si));function ti(a){this.j=a;this.l={};this.Ic=[];this.o=[]}
function ui(a,b){return"yt-uix"+(a.j?"-"+a.j:"")+(b?"-"+b:"")}
ti.prototype.init=t;ti.prototype.dispose=t;function vi(a,b,c){a.o.push(Zg(b,c,a))}
function wi(a,b,c){var d=ui(a,void 0),e=v(c,a);b in pi||(pi[b]=new F);pi[b].subscribe(d,e);a.l[c]=e}
function xi(a,b){Pb(a,"tooltip-text",b)}
;function yi(){ti.call(this,"tooltip");this.f=0;this.h={}}
x(yi,ti);ba(yi);g=yi.prototype;g.register=function(){wi(this,"mouseover",this.Vb);wi(this,"mouseout",this.eb);wi(this,"focus",this.ud);wi(this,"blur",this.kd);wi(this,"click",this.eb);wi(this,"touchstart",this.De);wi(this,"touchend",this.Qc);wi(this,"touchcancel",this.Qc)};
g.dispose=function(){for(var a in this.h)this.eb(this.h[a]);this.h={}};
g.Vb=function(a){if(!(this.f&&1E3>w()-this.f)){var b=parseInt(C(a,"tooltip-hide-timer"),10);b&&(Rb(a,"tooltip-hide-timer"),J(b));var b=v(function(){zi(this,a);Rb(a,"tooltip-show-timer")},this),c=parseInt(C(a,"tooltip-show-delay"),10)||0,b=I(b,c);
Pb(a,"tooltip-show-timer",b.toString());a.title&&(xi(a,Ai(a)),a.title="");b=ka(a).toString();this.h[b]=a}};
g.eb=function(a){var b=parseInt(C(a,"tooltip-show-timer"),10);b&&(J(b),Rb(a,"tooltip-show-timer"));b=v(function(){if(a){var b=xe(Bi(this,a));b&&(Ci(b),b&&b.parentNode&&b.parentNode.removeChild(b),Rb(a,"content-id"));(b=xe(Bi(this,a,"arialabel")))&&b.parentNode&&b.parentNode.removeChild(b)}Rb(a,"tooltip-hide-timer")},this);
b=I(b,50);Pb(a,"tooltip-hide-timer",b.toString());if(b=C(a,"tooltip-text"))a.title=b;b=ka(a).toString();delete this.h[b]};
g.ud=function(a){this.f=0;this.Vb(a)};
g.kd=function(a){this.f=0;this.eb(a)};
g.De=function(a,b,c){c.changedTouches&&(this.f=0,a=ri(b,ui(this),c.changedTouches[0].target),this.Vb(a))};
g.Qc=function(a,b,c){c.changedTouches&&(this.f=w(),a=ri(b,ui(this),c.changedTouches[0].target),this.eb(a))};
function Di(a,b){xi(a,b);var c=C(a,"content-id");(c=xe(c))&&Ge(c,b)}
function Ai(a){return C(a,"tooltip-text")||a.title}
function zi(a,b){if(b){var c=Ai(b);if(c){var d=xe(Bi(a,b));if(!d){d=document.createElement("div");d.id=Bi(a,b);d.className=ui(a,"tip");var e=document.createElement("div");e.className=ui(a,"tip-body");var f=document.createElement("div");f.className=ui(a,"tip-arrow");var h=document.createElement("div");h.setAttribute("aria-hidden","true");h.className=ui(a,"tip-content");var k=Ei(a,b),l=Bi(a,b,"content");h.id=l;Pb(b,"content-id",l);e.appendChild(h);k&&d.appendChild(k);d.appendChild(e);d.appendChild(f);
var l=Je(b),n=Bi(a,b,"arialabel"),f=document.createElement("div");oe(f,ui(a,"arialabel"));f.id=n;"rtl"==document.body.getAttribute("dir")?Ge(f,c+" "+l):Ge(f,l+" "+c);b.setAttribute("aria-labelledby",n);l=Re()||document.body;l.appendChild(f);l.appendChild(d);Di(b,c);(c=parseInt(C(b,"tooltip-max-width"),10))&&e.offsetWidth>c&&(e.style.width=c+"px",oe(h,ui(a,"normal-wrap")));h=ne(b,ui(a,"reverse"));Fi(a,b,d,e,k,h)||Fi(a,b,d,e,k,!h);var H=ui(a,"tip-visible");I(function(){oe(d,H)},0)}}}}
function Fi(a,b,c,d,e,f){qe(c,ui(a,"tip-reverse"),f);var h=0;f&&(h=1);a=uf(b);f=new re((a.width-10)/2,f?a.height:0);var k=we(b),l=new re(0,0),n;n=k?we(k):document;var H;(H=!L||wd(9))||(H=ue(n),H=Ce(H.f));b!=(H?n.documentElement:n.body)&&(n=sf(b),k=ue(k),k=Be(k.f),l.x=n.left+k.x,l.y=n.top+k.y);f=new re(l.x+f.x,l.y+f.y);f=f.clone();l=(h&8&&"rtl"==rf(c,"direction")?h^4:h)&-9;h=uf(c);k=h.clone();n=f.clone();k=k.clone();0!=l&&(l&4?n.x-=k.width+0:l&2&&(n.x-=k.width/2),l&1&&(n.y-=k.height+0));f=new of(0,
0,0,0);f.left=n.x;f.top=n.y;f.width=k.width;f.height=k.height;k=new re(f.left,f.top);k instanceof re?(l=k.x,k=k.y):(l=k,k=void 0);c.style.left=tf(l,!1);c.style.top=tf(k,!1);k=new se(f.width,f.height);if(!(h==k||h&&k&&h.width==k.width&&h.height==k.height))if(h=k,f=we(c),f=ue(f),l=Ce(f.f),!L||vd("10")||l&&vd("8"))f=c.style,kd?f.MozBoxSizing="border-box":ld?f.WebkitBoxSizing="border-box":f.boxSizing="border-box",f.width=Math.max(h.width,0)+"px",f.height=Math.max(h.height,0)+"px";else if(f=c.style,l){L?
(l=xf(c,"paddingLeft"),k=xf(c,"paddingRight"),n=xf(c,"paddingTop"),H=xf(c,"paddingBottom"),l=new nf(n,k,H,l)):(l=qf(c,"paddingLeft"),k=qf(c,"paddingRight"),n=qf(c,"paddingTop"),H=qf(c,"paddingBottom"),l=new nf(parseFloat(n),parseFloat(k),parseFloat(H),parseFloat(l)));if(L&&!wd(9)){k=zf(c,"borderLeft");n=zf(c,"borderRight");H=zf(c,"borderTop");var ca=zf(c,"borderBottom"),k=new nf(H,n,ca,k)}else k=qf(c,"borderLeftWidth"),n=qf(c,"borderRightWidth"),H=qf(c,"borderTopWidth"),ca=qf(c,"borderBottomWidth"),
k=new nf(parseFloat(H),parseFloat(n),parseFloat(ca),parseFloat(k));f.pixelWidth=h.width-k.left-l.left-l.right-k.right;f.pixelHeight=h.height-k.top-l.top-l.bottom-k.bottom}else f.pixelWidth=h.width,f.pixelHeight=h.height;h=window.document;h=Ce(h)?h.documentElement:h.body;f=new se(h.clientWidth,h.clientHeight);1==c.nodeType?(c=sf(c),k=new re(c.left,c.top)):(c=c.changedTouches?c.changedTouches[0]:c,k=new re(c.clientX,c.clientY));c=uf(d);n=Math.floor(c.width/2);h=!!(f.height<k.y+a.height);a=!!(k.y<a.height);
l=!!(k.x<n);f=!!(f.width<k.x+n);k=(c.width+3)/-2- -5;b=C(b,"force-tooltip-direction");if("left"==b||l)k=-5;else if("right"==b||f)k=20-c.width-3;b=Math.floor(k)+"px";d.style.left=b;e&&(e.style.left=b,e.style.height=c.height+"px",e.style.width=c.width+"px");return!(h||a)}
function Bi(a,b,c){a=ui(a);var d=b.__yt_uid_key;d||(d=Pe(),b.__yt_uid_key=d);b=a+d;c&&(b+="-"+c);return b}
function Ei(a,b){var c=null;nd&&ne(b,ui(a,"masked"))&&((c=xe("yt-uix-tooltip-shared-mask"))?(c.parentNode.removeChild(c),Nf(c)):(c=document.createElement("iframe"),c.src='javascript:""',c.id="yt-uix-tooltip-shared-mask",c.className=ui(a,"tip-mask")));return c}
function Ci(a){var b=xe("yt-uix-tooltip-shared-mask"),c=b&&Ne(b,function(b){return b==a},!1,2);
b&&c&&(b.parentNode.removeChild(b),Of(b),document.body.appendChild(b))}
;function Gi(){ti.call(this,"subscription-button")}
x(Gi,ti);ba(Gi);Gi.prototype.register=function(){wi(this,"click",this.mc);vi(this,ci,this.xc);vi(this,di,this.wc);vi(this,ei,this.de);vi(this,hi,this.xc);vi(this,ii,this.wc);vi(this,ji,this.je);vi(this,li,this.Qd);vi(this,mi,this.Pd)};
var Me={cc:"hover-enabled",Yc:"yt-uix-button-subscribe",Zc:"yt-uix-button-subscribed",Ue:"ypc-enabled",$c:"yt-uix-button-subscription-container",ad:"yt-subscription-button-disabled-mask-container"},Hi={Ve:"channel-external-id",bd:"subscriber-count-show-when-subscribed",cd:"subscriber-count-tooltip",ed:"subscriber-count-title",We:"href",dc:"is-subscribed",Ye:"parent-url",$e:"clicktracking",fd:"style-type",ec:"subscription-id",cf:"target",gd:"ypc-enabled"};g=Gi.prototype;
g.mc=function(a){var b=C(a,"href"),c=oi();if(b)a=C(a,"target")||"_self",window.open(b,a);else if(c){var b=C(a,"channel-external-id"),c=C(a,"clicktracking"),d;if(C(a,"ypc-enabled")){d=C(a,"ypc-item-type");var e=C(a,"ypc-item-id");d={itemType:d,itemId:e,subscriptionElement:a}}else d=null;e=C(a,"parent-url");if(C(a,"is-subscribed")){var f=C(a,"subscription-id");R(gi,new Yh(b,f,d,a,c,e))}else R(bi,new Wh(b,d,c,e))}else Ii(this,a)};
g.xc=function(a){this.Na(a.f,this.Nc,!0)};
g.wc=function(a){this.Na(a.f,this.Nc,!1)};
g.de=function(a){this.Na(a.f,this.Oc,!0,a.subscriptionId)};
g.je=function(a){this.Na(a.f,this.Oc,!1)};
g.Qd=function(a){this.Na(a.f,this.od)};
g.Pd=function(a){this.Na(a.f,this.nd)};
g.Oc=function(a,b,c){b?(Pb(a,Hi.dc,"true"),c&&Pb(a,Hi.ec,c)):(Rb(a,Hi.dc),Rb(a,Hi.ec));Ji(a)};
g.Nc=function(a,b){var c;c=Le(a);qe(c,Me.ad,b);a.setAttribute("aria-busy",b?"true":"false");a.disabled=b};
function Ji(a){var b=C(a,Hi.fd),c=!!C(a,"is-subscribed"),b="-"+b,d=Me.Zc+b;qe(a,Me.Yc+b,!c);qe(a,d,c);C(a,Hi.cd)&&!C(a,Hi.bd)&&(b=ui(yi.getInstance()),qe(a,b,!c),a.title=c?"":C(a,Hi.ed));c?I(function(){oe(a,Me.cc)},1E3):pe(a,Me.cc)}
g.od=function(a){var b=!!C(a,"ypc-item-type"),c=!!C(a,"ypc-item-id");!C(a,"ypc-enabled")&&b&&c&&(oe(a,"ypc-enabled"),Pb(a,Hi.gd,"true"))};
g.nd=function(a){C(a,"ypc-enabled")&&(pe(a,"ypc-enabled"),Rb(a,"ypc-enabled"))};
function Ki(a,b){var c=ze(ui(a));return Na(c,function(a){return b==C(a,"channel-external-id")},a)}
g.jd=function(a,b,c){var d=ab(arguments,2);y(a,function(a){b.apply(this,Xa(a,d))},this)};
g.Na=function(a,b,c){var d=Ki(this,a),d=Xa([d],ab(arguments,1));this.jd.apply(this,d)};
function Ii(a,b){var c=v(function(a){a.discoverable_subscriptions&&lc("SUBSCRIBE_EMBED_DISCOVERABLE_SUBSCRIPTIONS",a.discoverable_subscriptions);this.mc(b)},a);
ni(c,"subscribe")}
;var Li=window.yt&&window.yt.uix&&window.yt.uix.widgets_||{};q("yt.uix.widgets_",Li,void 0);function Mi(a,b){this.source=null;this.l=a||null;this.origin="*";this.B=window.document.location.protocol+"//"+window.document.location.hostname;this.o=b;this.j=this.f=this.h=this.sourceId=null;N(window,"message",v(this.A,this))}
Mi.prototype.A=function(a){var b=this.o||G("POST_MESSAGE_ORIGIN",void 0)||this.B;if("*"!=b&&a.origin!=b)window.console&&window.console.warn("Untrusted origin: "+a.origin);else if(!this.l||a.source==this.l)if(this.source=a.source,this.origin="null"==a.origin?this.origin:a.origin,a=a.data,u(a)){try{a=zd(a)}catch(c){return}this.sourceId=a.id;switch(a.event){case "listening":this.f&&(this.f(),this.f=null);break;case "command":this.h&&(this.j&&!A(this.j,a.func)||this.h(a.func,a.args))}}};
Mi.prototype.sendMessage=function(a){this.source&&(a.id=this.sourceId,a=M(a),this.source.postMessage(a,this.origin))};function Ni(){}
;function Oi(){}
x(Oi,Ni);Oi.prototype.Y=function(){var a=0;Tc(this.wa(!0),function(){a++});
return a};
Oi.prototype.clear=function(){var a=Uc(this.wa(!0)),b=this;y(a,function(a){b.remove(a)})};function Pi(a){this.f=a}
x(Pi,Oi);g=Pi.prototype;g.isAvailable=function(){if(!this.f)return!1;try{return this.f.setItem("__sak","1"),this.f.removeItem("__sak"),!0}catch(a){return!1}};
g.yd=function(a,b){try{this.f.setItem(a,b)}catch(c){if(0==this.f.length)throw"Storage mechanism: Storage disabled";throw"Storage mechanism: Quota exceeded";}};
g.get=function(a){a=this.f.getItem(a);if(!u(a)&&null!==a)throw"Storage mechanism: Invalid value was encountered";return a};
g.remove=function(a){this.f.removeItem(a)};
g.Y=function(){return this.f.length};
g.wa=function(a){var b=0,c=this.f,d=new Rc;d.next=function(){if(b>=c.length)throw Qc;var d;d=c.key(b++);if(a)return d;d=c.getItem(d);if(!u(d))throw"Storage mechanism: Invalid value was encountered";return d};
return d};
g.clear=function(){this.f.clear()};
g.key=function(a){return this.f.key(a)};function Qi(){var a=null;try{a=window.localStorage||null}catch(b){}this.f=a}
x(Qi,Pi);function Ri(){var a=null;try{a=window.sessionStorage||null}catch(b){}this.f=a}
x(Ri,Pi);function Si(a){this.f=a}
Si.prototype.h=function(a,b){p(b)?this.f.yd(a,M(b)):this.f.remove(a)};
Si.prototype.get=function(a){var b;try{b=this.f.get(a)}catch(c){return}if(null!==b)try{return zd(b)}catch(c){throw"Storage: Invalid value was encountered";}};
Si.prototype.remove=function(a){this.f.remove(a)};function Ti(a){this.f=a}
x(Ti,Si);function Ui(a){this.data=a}
function Vi(a){return!p(a)||a instanceof Ui?a:new Ui(a)}
Ti.prototype.h=function(a,b){Ti.I.h.call(this,a,Vi(b))};
Ti.prototype.j=function(a){a=Ti.I.get.call(this,a);if(!p(a)||a instanceof Object)return a;throw"Storage: Invalid value was encountered";};
Ti.prototype.get=function(a){if(a=this.j(a)){if(a=a.data,!p(a))throw"Storage: Invalid value was encountered";}else a=void 0;return a};function Wi(a){this.f=a}
x(Wi,Ti);function Xi(a){var b=a.creation;a=a.expiration;return!!a&&a<w()||!!b&&b>w()}
Wi.prototype.h=function(a,b,c){if(b=Vi(b)){if(c){if(c<w()){Wi.prototype.remove.call(this,a);return}b.expiration=c}b.creation=w()}Wi.I.h.call(this,a,b)};
Wi.prototype.j=function(a,b){var c=Wi.I.j.call(this,a);if(c)if(!b&&Xi(c))Wi.prototype.remove.call(this,a);else return c};function Yi(a){this.f=a}
x(Yi,Wi);function Zi(a,b){var c=[];Tc(b,function(a){var b;try{b=Yi.prototype.j.call(this,a,!0)}catch(f){if("Storage: Invalid value was encountered"==f)return;throw f;}p(b)?Xi(b)&&c.push(a):c.push(a)},a);
return c}
function $i(a,b){var c=Zi(a,b);y(c,function(a){Yi.prototype.remove.call(this,a)},a)}
function aj(){var a=bj;$i(a,a.f.wa(!0))}
;function T(a,b,c){var d=c&&0<c?c:0;c=d?w()+1E3*d:0;if((d=d?bj:cj)&&window.JSON){u(b)||(b=JSON.stringify(b,void 0));try{d.h(a,b,c)}catch(e){d.remove(a)}}}
function U(a){if(!cj&&!bj||!window.JSON)return null;var b;try{b=cj.get(a)}catch(c){}if(!u(b))try{b=bj.get(a)}catch(c){}if(!u(b))return null;try{b=JSON.parse(b,void 0)}catch(c){}return b}
function dj(a){cj&&cj.remove(a);bj&&bj.remove(a)}
var bj,ej=new Qi;bj=ej.isAvailable()?new Yi(ej):null;var cj,fj=new Ri;cj=fj.isAvailable()?new Yi(fj):null;function gj(a){return(0==a.search("cue")||0==a.search("load"))&&"loadModule"!=a}
function hj(a,b,c){u(a)&&(a={mediaContentUrl:a,startSeconds:b,suggestedQuality:c});b=a;c=/\/([ve]|embed)\/([^#?]+)/.exec(a.mediaContentUrl);b.videoId=c&&c[2]?c[2]:null;return ij(a)}
function ij(a,b,c){if(ia(a)){b="endSeconds startSeconds mediaContentUrl suggestedQuality videoId two_stage_token".split(" ");c={};for(var d=0;d<b.length;d++){var e=b[d];a[e]&&(c[e]=a[e])}return c}return{videoId:a,startSeconds:b,suggestedQuality:c}}
function jj(a,b,c,d){if(ia(a)&&!ea(a)){b="playlist list listType index startSeconds suggestedQuality".split(" ");c={};for(d=0;d<b.length;d++){var e=b[d];a[e]&&(c[e]=a[e])}return c}c={index:b,startSeconds:c,suggestedQuality:d};u(a)&&16==a.length?c.list="PL"+a:c.playlist=a;return c}
function kj(a){var b=a.video_id||a.videoId;if(u(b)){var c=U("yt-player-two-stage-token")||{},d=U("yt-player-two-stage-token")||{};p(void 0)?d[b]=void 0:delete d[b];T("yt-player-two-stage-token",d,300);(b=c[b])&&(a.two_stage_token=b)}}
;function lj(){var a=window.navigator.userAgent.match(/Chrome\/([0-9]+)/);return a?50<=parseInt(a[1],10):!1}
var mj=document.currentScript&&-1!=document.currentScript.src.indexOf("?loadGamesSDK")?"/cast_game_sender.js":"/cast_sender.js",nj=["boadgeojelhgndaghljhdicfkmllpafd","dliochdbjfkdbacpmhlcpmleaejidimm","enhhojjnijigcajfphajepfemndkmdlo","fmfcbgogabcbclcofgocippekhfcmgfj"],oj=["pkedcjkdefgpdelpbcmbmeomcjbeemfm","fjhoaacokmgbjemoflkofnenfaiekifl"],pj=lj()?oj.concat(nj):nj.concat(oj);function qj(a,b){var c=new XMLHttpRequest;c.onreadystatechange=function(){4==c.readyState&&200==c.status&&b(!0)};
c.onerror=function(){b(!1)};
try{c.open("GET",a,!0),c.send()}catch(d){b(!1)}}
function rj(a){if(a>=pj.length)sj();else{var b=pj[a],c="chrome-extension://"+b+mj;0<=nj.indexOf(b)?qj(c,function(d){d?(window.chrome.cast=window.chrome.cast||{},window.chrome.cast.extensionId=b,tj(c,sj)):rj(a+1)}):tj(c,function(){rj(a+1)})}}
function tj(a,b){var c=document.createElement("script");c.onerror=b;c.src=a;(document.head||document.documentElement).appendChild(c)}
function sj(){var a=window.__onGCastApiAvailable;a&&"function"==typeof a&&a(!1,"No cast extension found")}
function uj(){if(window.chrome){var a=window.navigator.userAgent;if(0<=a.indexOf("Android")&&0<=a.indexOf("Chrome/")&&window.navigator.presentation)a=lj()?"50":"",tj("//www.gstatic.com/eureka/clank"+a+mj,sj);else{if(0<=window.navigator.userAgent.indexOf("CriOS")&&(a=window.__gCrWeb&&window.__gCrWeb.message&&window.__gCrWeb.message.invokeOnHost)){a({command:"cast.sender.init"});return}rj(0)}}else sj()}
;var vj=w(),wj=null,xj=Array(50),yj=-1,zj=!1;function Aj(a){Bj();wj.push(a);Cj(wj)}
function Dj(a){var b=r("yt.mdx.remote.debug.handlers_");Va(b||[],a)}
function Ej(a,b){Bj();var c=wj,d=Fj(a,String(b));0==c.length?Gj(d):(Cj(c),y(c,function(a){a(d)}))}
function Bj(){wj||(wj=r("yt.mdx.remote.debug.handlers_")||[],q("yt.mdx.remote.debug.handlers_",wj,void 0))}
function Gj(a){var b=(yj+1)%50;yj=b;xj[b]=a;zj||(zj=49==b)}
function Cj(a){var b=xj;if(b[0]){var c=yj,d=zj?c:-1;do{var d=(d+1)%50,e=b[d];y(a,function(a){a(e)})}while(d!=c);
xj=Array(50);yj=-1;zj=!1}}
function Fj(a,b){var c=(w()-vj)/1E3;c.toFixed&&(c=c.toFixed(3));var d=[];d.push("[",c+"s","] ");d.push("[","yt.mdx.remote","] ");d.push(a+": "+b,"\n");return d.join("")}
;function Hj(a){a=a||{};this.name=a.name||"";this.id=a.id||a.screenId||"";this.token=a.token||a.loungeToken||"";this.f=a.uuid||a.dialId||""}
function Ij(a,b){return!!b&&(a.id==b||a.f==b)}
function Jj(a,b){return a||b?!a!=!b?!1:a.id==b.id:!0}
function Kj(a,b){return a||b?!a!=!b?!1:a.id==b.id&&a.token==b.token&&a.name==b.name&&a.f==b.f:!0}
function Lj(a){return{name:a.name,screenId:a.id,loungeToken:a.token,dialId:a.f}}
function Mj(a){return new Hj(a)}
function Nj(a){return ea(a)?z(a,Mj):[]}
function Oj(a){return a?'{name:"'+a.name+'",id:'+a.id.substr(0,6)+"..,token:"+(a.token?".."+a.token.slice(-6):"-")+",uuid:"+(a.f?".."+a.f.slice(-6):"-")+"}":"null"}
function Pj(a){return ea(a)?"["+z(a,Oj).join(",")+"]":"null"}
;var Qj={Te:"atp",bf:"ska",Ze:"que",Xe:"mus",af:"sus"};function Rj(a){this.l=this.j="";this.f="/api/lounge";this.h=!0;a=a||document.location.href;var b=Number(a.match(Hd)[4]||null)||null||"";b&&(this.l=":"+b);this.j=Id(a)||"";a=xb;0<=a.search("MSIE")&&(a=a.match(/MSIE ([\d.]+)/)[1],0>Ia(a,"10.0")&&(this.h=!1))}
function Sj(a,b,c,d){var e=a.f;if(p(d)?d:a.h)e="https://"+a.j+a.l+a.f;return Qd(e+b,c||{})}
function Tj(a,b,c,d,e){a={format:"JSON",method:"POST",context:a,timeout:5E3,withCredentials:!1,ca:pa(a.A,d,!0),onError:pa(a.o,e),gb:pa(a.B,e)};c&&(a.S=c,a.headers={"Content-Type":"application/x-www-form-urlencoded"});return $d(b,a)}
Rj.prototype.A=function(a,b,c,d){b?a(d):a({text:c.responseText})};
Rj.prototype.o=function(a,b){a(Error("Request error: "+b.status))};
Rj.prototype.B=function(a){a(Error("request timed out"))};function Uj(a){this.f=this.name=this.id="";this.status="UNKNOWN";a&&(this.id=a.id||"",this.name=a.name||"",this.f=a.activityId||"",this.status=a.status||"UNKNOWN")}
function Vj(a){return{id:a.id,name:a.name,activityId:a.f,status:a.status}}
Uj.prototype.toString=function(){return"{id:"+this.id+",name:"+this.name+",activityId:"+this.f+",status:"+this.status+"}"};
function Wj(a){a=a||[];return"["+z(a,function(a){return a?a.toString():"null"}).join(",")+"]"}
;function Xj(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(a){var b=16*Math.random()|0;return("x"==a?b:b&3|8).toString(16)})}
function Yj(a,b){return Qa(a,function(a){return a.key==b})}
function Zj(a){return z(a,function(a){return{key:a.id,name:a.name}})}
function ak(a){return z(a,function(a){return Vj(a)})}
function bk(a){return z(a,function(a){return new Uj(a)})}
function ck(a,b){return a||b?a&&b?a.id==b.id&&a.name==b.name:!1:!0}
function dk(a,b){return Qa(a,function(a){return a.id==b})}
function ek(a,b){return Qa(a,function(a){return Jj(a,b)})}
function fk(a,b){return Qa(a,function(a){return Ij(a,b)})}
;function V(){D.call(this);this.l=new F;gc(this,pa(E,this.l))}
x(V,D);V.prototype.subscribe=function(a,b,c){return this.isDisposed()?0:this.l.subscribe(a,b,c)};
V.prototype.unsubscribe=function(a,b,c){return this.isDisposed()?!1:this.l.unsubscribe(a,b,c)};
V.prototype.oa=function(a){return this.isDisposed()?!1:this.l.oa(a)};
V.prototype.D=function(a,b){return this.isDisposed()?!1:this.l.D.apply(this.l,arguments)};function gk(a){V.call(this);this.B=a;this.screens=[]}
x(gk,V);gk.prototype.$=function(){return this.screens};
gk.prototype.contains=function(a){return!!ek(this.screens,a)};
gk.prototype.get=function(a){return a?fk(this.screens,a):null};
function hk(a,b){var c=a.get(b.f)||a.get(b.id);if(c){var d=c.name;c.id=b.id||c.id;c.name=b.name;c.token=b.token;c.f=b.f||c.f;return c.name!=d}a.screens.push(b);return!0}
function ik(a,b){var c=a.screens.length!=b.length;a.screens=Na(a.screens,function(a){return!!ek(b,a)});
for(var d=0,e=b.length;d<e;d++)c=hk(a,b[d])||c;return c}
function jk(a,b){var c=a.screens.length;a.screens=Na(a.screens,function(a){return!Jj(a,b)});
return a.screens.length<c}
gk.prototype.info=function(a){Ej(this.B,a)};function kk(a,b,c,d){V.call(this);this.F=a;this.B=b;this.o=c;this.A=d;this.j=0;this.f=null;this.h=NaN}
x(kk,V);var lk=[2E3,2E3,1E3,1E3,1E3,2E3,2E3,5E3,5E3,1E4];g=kk.prototype;g.start=function(){!this.f&&isNaN(this.h)&&this.Hc()};
g.stop=function(){this.f&&(this.f.abort(),this.f=null);isNaN(this.h)||(J(this.h),this.h=NaN)};
g.G=function(){this.stop();kk.I.G.call(this)};
g.Hc=function(){this.h=NaN;this.f=$d(Sj(this.F,"/pairing/get_screen"),{method:"POST",S:{pairing_code:this.B},timeout:5E3,ca:v(this.Ke,this),onError:v(this.Je,this),gb:v(this.Le,this)})};
g.Ke=function(a,b){this.f=null;var c=b.screen||{};c.dialId=this.o;c.name=this.A;this.D("pairingComplete",new Hj(c))};
g.Je=function(a){this.f=null;a.status&&404==a.status?this.j>=lk.length?this.D("pairingFailed",Error("DIAL polling timed out")):(a=lk[this.j],this.h=I(v(this.Hc,this),a),this.j++):this.D("pairingFailed",Error("Server error "+a.status))};
g.Le=function(){this.f=null;this.D("pairingFailed",Error("Server not responding"))};function mk(a){this.app=this.name=this.id="";this.type="REMOTE_CONTROL";this.avatar=this.username="";this.capabilities=new ed;this.theme="u";a&&(this.id=a.id||a.name,this.name=a.name,this.app=a.app,this.type=a.type||"REMOTE_CONTROL",this.username=a.user||"",this.avatar=a.userAvatarUri||"",this.theme=a.theme||"u",this.capabilities=new ed(Na((a.capabilities||"").split(","),pa(ib,Qj))))}
mk.prototype.equals=function(a){return a?this.id==a.id:!1};var nk;function ok(){var a=pk(),b=qk();A(a,b);if(rk()){var c=a,d;d=0;for(var e=c.length,f;d<e;){var h=d+e>>1,k;k=db(b,c[h]);0<k?d=h+1:(e=h,f=!k)}d=f?d:~d;0>d&&$a(c,-(d+1),0,b)}a=sk(a);if(0==a.length)try{a="remote_sid",ef.remove(""+a,"/","youtube.com")}catch(l){}else try{ff("remote_sid",a.join(","),-1)}catch(l){}}
function pk(){var a=U("yt-remote-connected-devices")||[];a.sort(db);return a}
function sk(a){if(0==a.length)return[];var b=a[0].indexOf("#"),c=-1==b?a[0]:a[0].substring(0,b);return z(a,function(a,b){return 0==b?a:a.substring(c.length)})}
function tk(a){T("yt-remote-connected-devices",a,86400)}
function qk(){if(uk)return uk;var a=U("yt-remote-device-id");a||(a=Xj(),T("yt-remote-device-id",a,31536E3));for(var b=pk(),c=1,d=a;A(b,d);)c++,d=a+"#"+c;return uk=d}
function vk(){return U("yt-remote-session-browser-channel")}
function rk(){return U("yt-remote-session-screen-id")}
function wk(a){5<a.length&&(a=a.slice(a.length-5));var b=z(xk(),function(a){return a.loungeToken}),c=z(a,function(a){return a.loungeToken});
Pa(c,function(a){return!A(b,a)})&&yk();
T("yt-remote-local-screens",a,31536E3)}
function xk(){return U("yt-remote-local-screens")||[]}
function yk(){T("yt-remote-lounge-token-expiration",!0,86400)}
function zk(){return!U("yt-remote-lounge-token-expiration")}
function Ak(a){T("yt-remote-online-screens",a,60)}
function Bk(){return U("yt-remote-online-screens")||[]}
function Ck(a){T("yt-remote-online-dial-devices",a,30)}
function Dk(){return U("yt-remote-online-dial-devices")||[]}
function Ek(a,b){T("yt-remote-session-browser-channel",a);T("yt-remote-session-screen-id",b);var c=pk(),d=qk();A(c,d)||c.push(d);tk(c);ok()}
function Fk(a){a||(dj("yt-remote-session-screen-id"),dj("yt-remote-session-video-id"));ok();a=pk();Va(a,qk());tk(a)}
function Gk(){if(!nk){var a;a=new Qi;(a=a.isAvailable()?a:null)&&(nk=new Si(a))}return nk?!!nk.get("yt-remote-use-staging-server"):!1}
var uk="";function Hk(a){gk.call(this,"LocalScreenService");this.h=a;this.f=NaN;Ik(this);this.info("Initializing with "+Pj(this.screens))}
x(Hk,gk);g=Hk.prototype;g.start=function(){Ik(this)&&this.D("screenChange");zk()&&Jk(this);J(this.f);this.f=I(v(this.start,this),1E4)};
g.Db=function(a,b){Ik(this);hk(this,a);Kk(this,!1);this.D("screenChange");b(a);a.token||Jk(this)};
g.remove=function(a,b){var c=Ik(this);jk(this,a)&&(Kk(this,!1),c=!0);b(a);c&&this.D("screenChange")};
g.Ab=function(a,b,c,d){var e=Ik(this),f=this.get(a.id);f?(f.name!=b&&(f.name=b,Kk(this,!1),e=!0),c(a)):d(Error("no such local screen."));e&&this.D("screenChange")};
g.G=function(){J(this.f);Hk.I.G.call(this)};
function Jk(a){if(a.screens.length){var b=z(a.screens,function(a){return a.id}),c=Sj(a.h,"/pairing/get_lounge_token_batch");
Tj(a.h,c,{screen_ids:b.join(",")},v(a.Cd,a),v(a.Bd,a))}}
g.Cd=function(a){Ik(this);var b=this.screens.length;a=a&&a.screens||[];for(var c=0,d=a.length;c<d;++c){var e=a[c],f=this.get(e.screenId);f&&(f.token=e.loungeToken,--b)}Kk(this,!b);b&&Ej(this.B,"Missed "+b+" lounge tokens.")};
g.Bd=function(a){Ej(this.B,"Requesting lounge tokens failed: "+a)};
function Ik(a){var b=Nj(xk()),b=Na(b,function(a){return!a.f});
return ik(a,b)}
function Kk(a,b){wk(z(a.screens,Lj));b&&yk()}
;function Lk(a,b){V.call(this);this.A=b;for(var c=U("yt-remote-online-screen-ids")||"",c=c?c.split(","):[],d={},e=this.A(),f=0,h=e.length;f<h;++f){var k=e[f].id;d[k]=A(c,k)}this.f=d;this.B=a;this.j=this.o=NaN;this.h=null;Mk("Initialized with "+M(this.f))}
x(Lk,V);g=Lk.prototype;g.start=function(){var a=parseInt(U("yt-remote-fast-check-period")||"0",10);(this.o=w()-144E5<a?0:a)?Nk(this):(this.o=w()+3E5,T("yt-remote-fast-check-period",this.o),this.Xb())};
g.isEmpty=function(){return qb(this.f)};
g.update=function(){Mk("Updating availability on schedule.");var a=this.A(),b=fb(this.f,function(b,d){return b&&!!fk(a,d)},this);
Ok(this,b)};
function Pk(a,b,c){var d=Sj(a.B,"/pairing/get_screen_availability");Tj(a.B,d,{lounge_token:b.token},v(function(a){a=a.screens||[];for(var d=0,h=a.length;d<h;++d)if(a[d].loungeToken==b.token){c("online"==a[d].status);return}c(!1)},a),v(function(){c(!1)},a))}
g.G=function(){J(this.j);this.j=NaN;this.h&&(this.h.abort(),this.h=null);Lk.I.G.call(this)};
function Ok(a,b){var c;a:if(gb(b)!=gb(a.f))c=!1;else{c=lb(b);for(var d=0,e=c.length;d<e;++d)if(!a.f[c[d]]){c=!1;break a}c=!0}c||(Mk("Updated online screens: "+M(a.f)),a.f=b,a.D("screenChange"));Qk(a)}
function Nk(a){isNaN(a.j)||J(a.j);a.j=I(v(a.Xb,a),0<a.o&&a.o<w()?2E4:1E4)}
g.Xb=function(){J(this.j);this.j=NaN;this.h&&this.h.abort();var a=Rk(this);if(gb(a)){var b=Sj(this.B,"/pairing/get_screen_availability"),c={lounge_token:lb(a).join(",")};this.h=Tj(this.B,b,c,v(this.be,this,a),v(this.ae,this))}else Ok(this,{}),Nk(this)};
g.be=function(a,b){this.h=null;var c=lb(Rk(this));if(bb(c,lb(a))){for(var c=b.screens||[],d={},e=0,f=c.length;e<f;++e)d[a[c[e].loungeToken]]="online"==c[e].status;Ok(this,d);Nk(this)}else this.M("Changing Screen set during request."),this.Xb()};
g.ae=function(a){this.M("Screen availability failed: "+a);this.h=null;Nk(this)};
function Mk(a){Ej("OnlineScreenService",a)}
g.M=function(a){Ej("OnlineScreenService",a)};
function Rk(a){var b={};y(a.A(),function(a){a.token?b[a.token]=a.id:this.M("Requesting availability of screen w/o lounge token.")});
return b}
function Qk(a){var b=lb(fb(a.f,function(a){return a}));
b.sort(db);b.length?T("yt-remote-online-screen-ids",b.join(","),60):dj("yt-remote-online-screen-ids");a=Na(a.A(),function(a){return!!this.f[a.id]},a);
Ak(z(a,Lj))}
;function W(a){gk.call(this,"ScreenService");this.A=a;this.f=this.h=null;this.j=[];this.o={};Sk(this)}
x(W,gk);g=W.prototype;g.start=function(){this.h.start();this.f.start();this.screens.length&&(this.D("screenChange"),this.f.isEmpty()||this.D("onlineScreenChange"))};
g.Db=function(a,b,c){this.h.Db(a,b,c)};
g.remove=function(a,b,c){this.h.remove(a,b,c);this.f.update()};
g.Ab=function(a,b,c,d){this.h.contains(a)?this.h.Ab(a,b,c,d):(a="Updating name of unknown screen: "+a.name,Ej(this.B,a),d(Error(a)))};
g.$=function(a){return a?this.screens:Xa(this.screens,Na(this.j,function(a){return!this.contains(a)},this))};
g.Sc=function(){return Na(this.$(!0),function(a){return!!this.f.f[a.id]},this)};
function Tk(a,b,c,d,e,f){a.info("getAutomaticScreenByIds "+c+" / "+b);c||(c=a.o[b]);var h=a.$();if(h=(c?fk(h,c):null)||fk(h,b)){h.f=b;var k=Uk(a,h);Pk(a.f,k,function(a){e(a?k:null)})}else c?Vk(a,c,v(function(a){var f=Uk(this,new Hj({name:d,
screenId:c,loungeToken:a,dialId:b||""}));Pk(this.f,f,function(a){e(a?f:null)})},a),f):e(null)}
g.Tc=function(a,b,c,d,e){this.info("getDialScreenByPairingCode "+a+" / "+b);var f=new kk(this.A,a,b,c);f.subscribe("pairingComplete",v(function(a){E(f);d(Uk(this,a))},this));
f.subscribe("pairingFailed",function(a){E(f);e(a)});
f.start();return v(f.stop,f)};
function Wk(a,b){for(var c=0,d=a.screens.length;c<d;++c)if(a.screens[c].name==b)return a.screens[c];return null}
g.pc=function(a,b){for(var c=2,d=b(a,c);Wk(this,d);){c++;if(20<c)return a;d=b(a,c)}return d};
g.Ne=function(a,b,c,d){$d(Sj(this.A,"/pairing/get_screen"),{method:"POST",S:{pairing_code:a},timeout:5E3,ca:v(function(a,d){var h=new Hj(d.screen||{});if(!h.name||Wk(this,h.name))h.name=this.pc(h.name,b);c(Uk(this,h))},this),
onError:v(function(a){d(Error("pairing request failed: "+a.status))},this),
gb:v(function(){d(Error("pairing request timed out."))},this)})};
g.G=function(){E(this.h);E(this.f);W.I.G.call(this)};
function Vk(a,b,c,d){a.info("requestLoungeToken_ for "+b);var e={S:{screen_ids:b},method:"POST",context:a,ca:function(a,e){var k=e&&e.screens||[];k[0]&&k[0].screenId==b?c(k[0].loungeToken):d(Error("Missing lounge token in token response"))},
onError:function(){d(Error("Request screen lounge token failed"))}};
$d(Sj(a.A,"/pairing/get_lounge_token_batch"),e)}
function Xk(a){a.screens=a.h.$();var b=a.o,c={},d;for(d in b)c[b[d]]=d;b=0;for(d=a.screens.length;b<d;++b){var e=a.screens[b];e.f=c[e.id]||""}a.info("Updated manual screens: "+Pj(a.screens))}
g.Dd=function(){Xk(this);this.D("screenChange");this.f.update()};
function Sk(a){Yk(a);a.h=new Hk(a.A);a.h.subscribe("screenChange",v(a.Dd,a));Xk(a);a.j=Nj(U("yt-remote-automatic-screen-cache")||[]);Yk(a);a.info("Initializing automatic screens: "+Pj(a.j));a.f=new Lk(a.A,v(a.$,a,!0));a.f.subscribe("screenChange",v(function(){this.D("onlineScreenChange")},a))}
function Uk(a,b){var c=a.get(b.id);c?(c.f=b.f,b=c):((c=fk(a.j,b.f))?(c.id=b.id,c.token=b.token,b=c):a.j.push(b),T("yt-remote-automatic-screen-cache",z(a.j,Lj)));Yk(a);a.o[b.f]=b.id;T("yt-remote-device-id-map",a.o,31536E3);return b}
function Yk(a){a.o=U("yt-remote-device-id-map")||{}}
W.prototype.dispose=W.prototype.dispose;function Zk(a,b,c){V.call(this);this.R=c;this.K=a;this.h=b;this.j=null}
x(Zk,V);g=Zk.prototype;g.ub=function(a){this.j=a;this.D("sessionScreen",this.j)};
g.aa=function(a){this.isDisposed()||(a&&$k(this,""+a),this.j=null,this.D("sessionScreen",null))};
g.info=function(a){Ej(this.R,a)};
function $k(a,b){Ej(a.R,b)}
g.Vc=function(){return null};
g.Zb=function(a){var b=this.h;a?(b.displayStatus=new chrome.cast.ReceiverDisplayStatus(a,[]),b.displayStatus.showStop=!0):b.displayStatus=null;chrome.cast.setReceiverDisplayStatus(b,v(function(){this.info("Updated receiver status for "+b.friendlyName+": "+a)},this),v(function(){$k(this,"Failed to update receiver status for: "+b.friendlyName)},this))};
g.G=function(){this.Zb("");Zk.I.G.call(this)};function al(a,b){Zk.call(this,a,b,"CastSession");this.f=null;this.A=0;this.o=null;this.F=v(this.Oe,this);this.B=v(this.me,this);this.A=I(v(function(){bl(this,null)},this),12E4)}
x(al,Zk);g=al.prototype;g.Yb=function(a){if(this.f){if(this.f==a)return;$k(this,"Overriding cast sesison with new session object");this.f.removeUpdateListener(this.F);this.f.removeMessageListener("urn:x-cast:com.google.youtube.mdx",this.B)}this.f=a;this.f.addUpdateListener(this.F);this.f.addMessageListener("urn:x-cast:com.google.youtube.mdx",this.B);this.o&&cl(this);dl(this,"getMdxSessionStatus")};
g.Ra=function(a){this.info("launchWithParams: "+M(a));this.o=a;this.f&&cl(this)};
g.stop=function(){this.f?this.f.stop(v(function(){this.aa()},this),v(function(){this.aa(Error("Failed to stop receiver app."))},this)):this.aa(Error("Stopping cast device witout session."))};
g.Zb=t;g.G=function(){this.info("disposeInternal");J(this.A);this.A=0;this.f&&(this.f.removeUpdateListener(this.F),this.f.removeMessageListener("urn:x-cast:com.google.youtube.mdx",this.B));this.f=null;al.I.G.call(this)};
function cl(a){var b=a.o.videoId||a.o.videoIds[a.o.index];b&&dl(a,"flingVideo",{videoId:b,currentTime:a.o.currentTime||0});a.o=null}
function dl(a,b,c){a.info("sendYoutubeMessage_: "+b+" "+M(c));var d={};d.type=b;c&&(d.data=c);a.f?a.f.sendMessage("urn:x-cast:com.google.youtube.mdx",d,t,v(function(){$k(this,"Failed to send message: "+b+".")},a)):$k(a,"Sending yt message without session: "+M(d))}
g.me=function(a,b){if(!this.isDisposed())if(b){var c=Ad(b);if(c){var d=""+c.type,c=c.data||{};this.info("onYoutubeMessage_: "+d+" "+M(c));switch(d){case "mdxSessionStatus":bl(this,c.screenId);break;default:$k(this,"Unknown youtube message: "+d)}}else $k(this,"Unable to parse message.")}else $k(this,"No data in message.")};
function bl(a,b){J(a.A);if(b){if(a.info("onConnectedScreenId_: Received screenId: "+b),!a.j||a.j.id!=b){var c=v(a.ub,a),d=v(a.aa,a);a.oc(b,c,d,5)}}else a.aa(Error("Waiting for session status timed out."))}
g.oc=function(a,b,c,d){Tk(this.K,this.h.label,a,this.h.friendlyName,v(function(e){e?b(e):0<=d?($k(this,"Screen "+a+" appears to be offline. "+d+" retries left."),I(v(this.oc,this,a,b,c,d-1),300)):c(Error("Unable to fetch screen."))},this),c)};
g.Vc=function(){return this.f};
g.Oe=function(a){this.isDisposed()||a||($k(this,"Cast session died."),this.aa())};function el(a,b){Zk.call(this,a,b,"DialSession");this.A=this.J=null;this.O="";this.o=null;this.F=t;this.B=NaN;this.P=v(this.Re,this);this.f=t}
x(el,Zk);g=el.prototype;g.Yb=function(a){this.A=a;this.A.addUpdateListener(this.P)};
g.Ra=function(a){this.o=a;this.F()};
g.stop=function(){this.f();this.f=t;J(this.B);this.A?this.A.stop(v(this.aa,this,null),v(this.aa,this,"Failed to stop DIAL device.")):this.aa()};
g.G=function(){this.f();this.f=t;J(this.B);this.A&&this.A.removeUpdateListener(this.P);this.A=null;el.I.G.call(this)};
function fl(a){a.f=a.K.Tc(a.O,a.h.label,a.h.friendlyName,v(function(a){this.f=t;this.ub(a)},a),v(function(a){this.f=t;
this.aa(a)},a))}
g.Re=function(a){this.isDisposed()||a||($k(this,"DIAL session died."),this.f(),this.f=t,this.aa())};
function gl(a){var b={};b.pairingCode=a.O;if(a.o){var c=a.o.index||0,d=a.o.currentTime||0;b.v=a.o.videoId||a.o.videoIds[c];b.t=d}Gk()&&(b.env_useStageMdx=1);return Od(b)}
g.Tb=function(a){this.O=Xj();if(this.o){var b=new chrome.cast.DialLaunchResponse(!0,gl(this));a(b);fl(this)}else this.F=v(function(){J(this.B);this.F=t;this.B=NaN;var b=new chrome.cast.DialLaunchResponse(!0,gl(this));a(b);fl(this)},this),this.B=I(v(function(){this.F()},this),100)};
g.Ed=function(a,b){Tk(this.K,this.J.receiver.label,a,this.h.friendlyName,v(function(a){a&&a.token?(this.ub(a),b(new chrome.cast.DialLaunchResponse(!1))):this.Tb(b)},this),v(function(a){$k(this,"Failed to get DIAL screen: "+a);
this.Tb(b)},this))};function hl(a,b){Zk.call(this,a,b,"ManualSession");this.f=I(v(this.Ra,this,null),150)}
x(hl,Zk);hl.prototype.stop=function(){this.aa()};
hl.prototype.Yb=t;hl.prototype.Ra=function(){J(this.f);this.f=NaN;var a=fk(this.K.$(),this.h.label);a?this.ub(a):this.aa(Error("No such screen"))};
hl.prototype.G=function(){J(this.f);this.f=NaN;hl.I.G.call(this)};function il(a){V.call(this);this.h=a;this.f=null;this.A=!1;this.j=[];this.o=v(this.Zd,this)}
x(il,V);g=il.prototype;
g.init=function(a,b){chrome.cast.timeout.requestSession=3E4;var c=new chrome.cast.SessionRequest("233637DE");c.dialRequest=new chrome.cast.DialRequest("YouTube");var d=chrome.cast.AutoJoinPolicy.TAB_AND_ORIGIN_SCOPED,e=a?chrome.cast.DefaultActionPolicy.CAST_THIS_TAB:chrome.cast.DefaultActionPolicy.CREATE_SESSION,c=new chrome.cast.ApiConfig(c,v(this.Bc,this),v(this.$d,this),d,e);c.customDialLaunchCallback=v(this.Od,this);chrome.cast.initialize(c,v(function(){this.isDisposed()||(chrome.cast.addReceiverActionListener(this.o),
Aj(jl),this.h.subscribe("onlineScreenChange",v(this.Uc,this)),this.j=kl(this),chrome.cast.setCustomReceivers(this.j,t,v(function(a){this.M("Failed to set initial custom receivers: "+M(a))},this)),this.D("yt-remote-cast2-availability-change",ll(this)),b(!0))},this),v(function(a){this.M("Failed to initialize API: "+M(a));
b(!1)},this))};
g.ze=function(a,b){ml("Setting connected screen ID: "+a+" -> "+b);if(this.f){var c=this.f.j;if(!a||c&&c.id!=a)ml("Unsetting old screen status: "+this.f.h.friendlyName),E(this.f),this.f=null}if(a&&b){if(!this.f){c=fk(this.h.$(),a);if(!c){ml("setConnectedScreenStatus: Unknown screen.");return}var d=nl(this,c);d||(ml("setConnectedScreenStatus: Connected receiver not custom..."),d=new chrome.cast.Receiver(c.f?c.f:c.id,c.name),d.receiverType=chrome.cast.ReceiverType.CUSTOM,this.j.push(d),chrome.cast.setCustomReceivers(this.j,
t,v(function(a){this.M("Failed to set initial custom receivers: "+M(a))},this)));
ml("setConnectedScreenStatus: new active receiver: "+d.friendlyName);ol(this,new hl(this.h,d),!0)}this.f.Zb(b)}else ml("setConnectedScreenStatus: no screen.")};
function nl(a,b){return b?Qa(a.j,function(a){return Ij(b,a.label)},a):null}
g.Ae=function(a){this.isDisposed()?this.M("Setting connection data on disposed cast v2"):this.f?this.f.Ra(a):this.M("Setting connection data without a session")};
g.Qe=function(){this.isDisposed()?this.M("Stopping session on disposed cast v2"):this.f?(this.f.stop(),E(this.f),this.f=null):ml("Stopping non-existing session")};
g.requestSession=function(){chrome.cast.requestSession(v(this.Bc,this),v(this.ce,this))};
g.G=function(){this.h.unsubscribe("onlineScreenChange",v(this.Uc,this));window.chrome&&chrome.cast&&chrome.cast.removeReceiverActionListener(this.o);Dj(jl);E(this.f);il.I.G.call(this)};
function ml(a){Ej("Controller",a)}
g.M=function(a){Ej("Controller",a)};
function jl(a){window.chrome&&chrome.cast&&chrome.cast.logMessage&&chrome.cast.logMessage(a)}
function ll(a){return a.A||!!a.j.length||!!a.f}
function ol(a,b,c){E(a.f);(a.f=b)?(c?a.D("yt-remote-cast2-receiver-resumed",b.h):a.D("yt-remote-cast2-receiver-selected",b.h),b.subscribe("sessionScreen",v(a.Cc,a,b)),b.j?a.D("yt-remote-cast2-session-change",b.j):c&&a.f.Ra(null)):a.D("yt-remote-cast2-session-change",null)}
g.Cc=function(a,b){this.f==a&&(b||ol(this,null),this.D("yt-remote-cast2-session-change",b))};
g.Zd=function(a,b){if(!this.isDisposed())if(a)switch(ml("onReceiverAction_ "+a.label+" / "+a.friendlyName+"-- "+b),b){case chrome.cast.ReceiverAction.CAST:if(this.f)if(this.f.h.label!=a.label)ml("onReceiverAction_: Stopping active receiver: "+this.f.h.friendlyName),this.f.stop();else{ml("onReceiverAction_: Casting to active receiver.");this.f.j&&this.D("yt-remote-cast2-session-change",this.f.j);break}switch(a.receiverType){case chrome.cast.ReceiverType.CUSTOM:ol(this,new hl(this.h,a));break;case chrome.cast.ReceiverType.DIAL:ol(this,
new el(this.h,a));break;case chrome.cast.ReceiverType.CAST:ol(this,new al(this.h,a));break;default:this.M("Unknown receiver type: "+a.receiverType)}break;case chrome.cast.ReceiverAction.STOP:this.f&&this.f.h.label==a.label?this.f.stop():this.M("Stopping receiver w/o session: "+a.friendlyName)}else this.M("onReceiverAction_ called without receiver.")};
g.Od=function(a){if(this.isDisposed())return Promise.reject(Error("disposed"));var b=a.receiver;b.receiverType!=chrome.cast.ReceiverType.DIAL&&(this.M("Not DIAL receiver: "+b.friendlyName),b.receiverType=chrome.cast.ReceiverType.DIAL);var c=this.f?this.f.h:null;if(!c||c.label!=b.label)return this.M("Receiving DIAL launch request for non-clicked DIAL receiver: "+b.friendlyName),Promise.reject(Error("illegal DIAL launch"));if(c&&c.label==b.label&&c.receiverType!=chrome.cast.ReceiverType.DIAL){if(this.f.j)return ml("Reselecting dial screen."),
this.D("yt-remote-cast2-session-change",this.f.j),Promise.resolve(new chrome.cast.DialLaunchResponse(!1));this.M('Changing CAST intent from "'+c.receiverType+'" to "dial" for '+b.friendlyName);ol(this,new el(this.h,b))}b=this.f;b.J=a;return b.J.appState==chrome.cast.DialAppState.RUNNING?new Promise(v(b.Ed,b,(b.J.extraData||{}).screenId||null)):new Promise(v(b.Tb,b))};
g.Bc=function(a){if(!this.isDisposed()){ml("New cast session ID: "+a.sessionId);var b=a.receiver;if(b.receiverType!=chrome.cast.ReceiverType.CUSTOM){if(!this.f)if(b.receiverType==chrome.cast.ReceiverType.CAST)ml("Got resumed cast session before resumed mdx connection."),ol(this,new al(this.h,b),!0);else{this.M("Got non-cast session without previous mdx receiver event, or mdx resume.");return}var c=this.f.h,d=fk(this.h.$(),c.label);d&&Ij(d,b.label)&&c.receiverType!=chrome.cast.ReceiverType.CAST&&b.receiverType==
chrome.cast.ReceiverType.CAST&&(ml("onSessionEstablished_: manual to cast session change "+b.friendlyName),E(this.f),this.f=new al(this.h,b),this.f.subscribe("sessionScreen",v(this.Cc,this,this.f)),this.f.Ra(null));this.f.Yb(a)}}};
g.Pe=function(){return this.f?this.f.Vc():null};
g.ce=function(a){this.isDisposed()||(this.M("Failed to estabilish a session: "+M(a)),a.code!=chrome.cast.ErrorCode.CANCEL&&ol(this,null))};
g.$d=function(a){ml("Receiver availability updated: "+a);if(!this.isDisposed()){var b=ll(this);this.A=a==chrome.cast.ReceiverAvailability.AVAILABLE;ll(this)!=b&&this.D("yt-remote-cast2-availability-change",ll(this))}};
function kl(a){var b=a.h.Sc(),c=a.f&&a.f.h;a=z(b,function(a){c&&Ij(a,c.label)&&(c=null);var b=a.f?a.f:a.id,f=nl(this,a);f?(f.label=b,f.friendlyName=a.name):(f=new chrome.cast.Receiver(b,a.name),f.receiverType=chrome.cast.ReceiverType.CUSTOM);return f},a);
c&&(c.receiverType!=chrome.cast.ReceiverType.CUSTOM&&(c=new chrome.cast.Receiver(c.label,c.friendlyName),c.receiverType=chrome.cast.ReceiverType.CUSTOM),a.push(c));return a}
g.Uc=function(){if(!this.isDisposed()){var a=ll(this);this.j=kl(this);ml("Updating custom receivers: "+M(this.j));chrome.cast.setCustomReceivers(this.j,t,v(function(){this.M("Failed to set custom receivers.")},this));
var b=ll(this);b!=a&&this.D("yt-remote-cast2-availability-change",b)}};
il.prototype.setLaunchParams=il.prototype.Ae;il.prototype.setConnectedScreenStatus=il.prototype.ze;il.prototype.stopSession=il.prototype.Qe;il.prototype.getCastSession=il.prototype.Pe;il.prototype.requestSession=il.prototype.requestSession;il.prototype.init=il.prototype.init;il.prototype.dispose=il.prototype.dispose;function pl(a,b,c){ql()?sl(a)&&(tl(!0),window.chrome&&chrome.cast&&chrome.cast.isAvailable?ul(b):(window.__onGCastApiAvailable=function(a,c){a?ul(b):(vl("Failed to load cast API: "+c),wl(!1),tl(!1),dj("yt-remote-cast-available"),dj("yt-remote-cast-receiver"),xl(),b(!1))},c?Dc("https://www.gstatic.com/cv/js/sender/v1/cast_sender.js"):uj())):rl("Cannot initialize because not running Chrome")}
function xl(){rl("dispose");var a=yl();a&&a.dispose();zl=null;q("yt.mdx.remote.cloudview.instance_",null,void 0);Al(!1);zc(Bl);Bl.length=0}
function Cl(){return!!U("yt-remote-cast-installed")}
function Dl(){var a=U("yt-remote-cast-receiver");return a?Ca(a.friendlyName):null}
function El(){rl("clearCurrentReciever");dj("yt-remote-cast-receiver")}
function Fl(){Cl()?yl()?Gl()?(rl("Requesting cast selector."),zl.requestSession()):(rl("Wait for cast API to be ready to request the session."),Bl.push(xc("yt-remote-cast2-api-ready",Fl))):vl("requestCastSelector: Cast is not initialized."):vl("requestCastSelector: Cast API is not installed!")}
function Hl(a){Gl()?yl().setLaunchParams(a):vl("setLaunchParams called before ready.")}
function Il(a,b){Gl()?yl().setConnectedScreenStatus(a,b):vl("setConnectedScreenStatus called before ready.")}
var zl=null;function ql(){var a;a=0<=xb.search(/\ (CrMo|Chrome|CriOS)\//);return Ef||a}
function Jl(a){zl.init(!0,a)}
function sl(a){var b=!1;if(!zl){var c=r("yt.mdx.remote.cloudview.instance_");c||(c=new il(a),c.subscribe("yt-remote-cast2-availability-change",function(a){T("yt-remote-cast-available",a);K("yt-remote-cast2-availability-change",a)}),c.subscribe("yt-remote-cast2-receiver-selected",function(a){rl("onReceiverSelected: "+a.friendlyName);
T("yt-remote-cast-receiver",a);K("yt-remote-cast2-receiver-selected",a)}),c.subscribe("yt-remote-cast2-receiver-resumed",function(a){rl("onReceiverResumed: "+a.friendlyName);
T("yt-remote-cast-receiver",a)}),c.subscribe("yt-remote-cast2-session-change",function(a){rl("onSessionChange: "+Oj(a));
a||dj("yt-remote-cast-receiver");K("yt-remote-cast2-session-change",a)}),q("yt.mdx.remote.cloudview.instance_",c,void 0),b=!0);
zl=c}rl("cloudview.createSingleton_: "+b);return b}
function yl(){zl||(zl=r("yt.mdx.remote.cloudview.instance_"));return zl}
function ul(a){wl(!0);tl(!1);Jl(function(b){b?(Al(!0),K("yt-remote-cast2-api-ready")):(vl("Failed to initialize cast API."),wl(!1),dj("yt-remote-cast-available"),dj("yt-remote-cast-receiver"),xl());a(b)})}
function rl(a){Ej("cloudview",a)}
function vl(a){Ej("cloudview",a)}
function wl(a){rl("setCastInstalled_ "+a);T("yt-remote-cast-installed",a)}
function Gl(){return!!r("yt.mdx.remote.cloudview.apiReady_")}
function Al(a){rl("setApiReady_ "+a);q("yt.mdx.remote.cloudview.apiReady_",a,void 0)}
function tl(a){q("yt.mdx.remote.cloudview.initializing_",a,void 0)}
var Bl=[];function Kl(){if(!("cast"in window))return!1;var a=window.cast||{};return"ActivityStatus"in a&&"Api"in a&&"LaunchRequest"in a&&"Receiver"in a}
function Ll(a){Ej("CAST",a)}
function Ml(a){var b=Nl();b&&b.logMessage&&b.logMessage(a)}
function Ol(a){if(a.event.source==window&&a.event.data&&"CastApi"==a.event.data.source&&"Hello"==a.event.data.event)for(;Pl.length;)Pl.shift()()}
function Ql(){if(!r("yt.mdx.remote.castv2_")&&!Rl&&(0==Ta.length&&Za(Ta,Dk()),Kl())){var a=Nl();a?(a.removeReceiverListener("YouTube",Sl),a.addReceiverListener("YouTube",Sl),Ll("API initialized in the other binary")):(a=new cast.Api,Tl(a),a.addReceiverListener("YouTube",Sl),a.setReloadTabRequestHandler&&a.setReloadTabRequestHandler(function(){I(function(){window.location.reload(!0)},1E3)}),Aj(Ml),Ll("API initialized"));
Rl=!0}}
function Ul(){var a=Nl();a&&(Ll("API disposed"),Dj(Ml),a.setReloadTabRequestHandler&&a.setReloadTabRequestHandler(t),a.removeReceiverListener("YouTube",Sl),Tl(null));Rl=!1;Pl=null;(a=Ve(window,"message",Ol,!1))&&We(a)}
function Vl(a){var b=Ra(Ta,function(b){return b.id==a.id});
0<=b&&(Ta[b]=Vj(a))}
function Sl(a){a.length&&Ll("Updating receivers: "+M(a));Wl(a);K("yt-remote-cast-device-list-update");y(Xl(),function(a){Yl(a.id)});
y(a,function(a){if(a.isTabProjected){var c=Zl(a.id);Ll("Detected device: "+c.id+" is tab projected. Firing DEVICE_TAB_PROJECTED event.");I(function(){K("yt-remote-cast-device-tab-projected",c.id)},1E3)}})}
function $l(a,b){Ll("Updating "+a+" activity status: "+M(b));var c=Zl(a);c?(b.activityId&&(c.f=b.activityId),c.status="running"==b.status?"RUNNING":"stopped"==b.status?"STOPPED":"error"==b.status?"ERROR":"UNKNOWN","RUNNING"!=c.status&&(c.f=""),Vl(c),K("yt-remote-cast-device-status-update",c)):Ll("Device not found")}
function Xl(){Ql();return bk(Ta)}
function Wl(a){a=z(a,function(a){var c={id:a.id,name:Ca(a.name)};if(a=Zl(a.id))c.activityId=a.f,c.status=a.status;return c});
Sa();Za(Ta,a)}
function Zl(a){var b=Xl();return Qa(b,function(b){return b.id==a})||null}
function Yl(a){var b=Zl(a),c=Nl();c&&b&&b.f&&c.getActivityStatus(b.f,function(b){"error"==b.status&&(b.status="stopped");$l(a,b)})}
function am(a){Ql();var b=Zl(a),c=Nl();c&&b&&b.f?(Ll("Stopping cast activity"),c.stopActivity(b.f,pa($l,a))):Ll("Dropping cast activity stop")}
function Nl(){return r("yt.mdx.remote.castapi.api_")}
function Tl(a){q("yt.mdx.remote.castapi.api_",a,void 0)}
var Rl=!1,Pl=null,Ta=r("yt.mdx.remote.castapi.devices_")||[];q("yt.mdx.remote.castapi.devices_",Ta,void 0);function bm(a,b){this.action=a;this.params=b||null}
;function cm(){}
;function dm(){this.f=w()}
new dm;dm.prototype.reset=function(){this.f=w()};
dm.prototype.get=function(){return this.f};function em(a,b){this.type=a;this.currentTarget=this.target=b;this.defaultPrevented=!1;this.Lc=!0}
em.prototype.preventDefault=function(){this.defaultPrevented=!0;this.Lc=!1};var fm=!L||wd(9),gm=L&&!vd("9");!ld||vd("528");kd&&vd("1.9b")||L&&vd("8")||id&&vd("9.5")||ld&&vd("528");kd&&!vd("8")||L&&vd("9");function hm(a,b){em.call(this,a?a.type:"");this.relatedTarget=this.currentTarget=this.target=null;this.charCode=this.keyCode=this.button=this.screenY=this.screenX=this.clientY=this.clientX=0;this.metaKey=this.shiftKey=this.altKey=this.ctrlKey=!1;this.f=this.state=null;a&&this.init(a,b)}
x(hm,em);
hm.prototype.init=function(a,b){var c=this.type=a.type,d=a.changedTouches?a.changedTouches[0]:null;this.target=a.target||a.srcElement;this.currentTarget=b;var e=a.relatedTarget;if(e){if(kd){var f;a:{try{pf(e.nodeName);f=!0;break a}catch(h){}f=!1}f||(e=null)}}else"mouseover"==c?e=a.fromElement:"mouseout"==c&&(e=a.toElement);this.relatedTarget=e;null===d?(this.clientX=void 0!==a.clientX?a.clientX:a.pageX,this.clientY=void 0!==a.clientY?a.clientY:a.pageY,this.screenX=a.screenX||0,this.screenY=a.screenY||
0):(this.clientX=void 0!==d.clientX?d.clientX:d.pageX,this.clientY=void 0!==d.clientY?d.clientY:d.pageY,this.screenX=d.screenX||0,this.screenY=d.screenY||0);this.button=a.button;this.keyCode=a.keyCode||0;this.charCode=a.charCode||("keypress"==c?a.keyCode:0);this.ctrlKey=a.ctrlKey;this.altKey=a.altKey;this.shiftKey=a.shiftKey;this.metaKey=a.metaKey;this.state=a.state;this.f=a;a.defaultPrevented&&this.preventDefault()};
hm.prototype.preventDefault=function(){hm.I.preventDefault.call(this);var a=this.f;if(a.preventDefault)a.preventDefault();else if(a.returnValue=!1,gm)try{if(a.ctrlKey||112<=a.keyCode&&123>=a.keyCode)a.keyCode=-1}catch(b){}};var im="closure_listenable_"+(1E6*Math.random()|0),jm=0;function km(a,b,c,d,e){this.listener=a;this.f=null;this.src=b;this.type=c;this.nb=!!d;this.rb=e;this.key=++jm;this.Ta=this.lb=!1}
function lm(a){a.Ta=!0;a.listener=null;a.f=null;a.src=null;a.rb=null}
;function mm(a){this.src=a;this.f={};this.h=0}
function nm(a,b,c,d,e){var f=b.toString();b=a.f[f];b||(b=a.f[f]=[],a.h++);var h=om(b,c,d,e);-1<h?(a=b[h],a.lb=!1):(a=new km(c,a.src,f,!!d,e),a.lb=!1,b.push(a));return a}
mm.prototype.remove=function(a,b,c,d){a=a.toString();if(!(a in this.f))return!1;var e=this.f[a];b=om(e,b,c,d);return-1<b?(lm(e[b]),Array.prototype.splice.call(e,b,1),0==e.length&&(delete this.f[a],this.h--),!0):!1};
function pm(a,b){var c=b.type;c in a.f&&Va(a.f[c],b)&&(lm(b),0==a.f[c].length&&(delete a.f[c],a.h--))}
mm.prototype.removeAll=function(a){a=a&&a.toString();var b=0,c;for(c in this.f)if(!a||c==a){for(var d=this.f[c],e=0;e<d.length;e++)++b,lm(d[e]);delete this.f[c];this.h--}return b};
function qm(a,b,c,d,e){a=a.f[b.toString()];b=-1;a&&(b=om(a,c,d,e));return-1<b?a[b]:null}
function om(a,b,c,d){for(var e=0;e<a.length;++e){var f=a[e];if(!f.Ta&&f.listener==b&&f.nb==!!c&&f.rb==d)return e}return-1}
;var rm="closure_lm_"+(1E6*Math.random()|0),sm={},tm=0;
function um(a,b,c,d,e){if(ea(b)){for(var f=0;f<b.length;f++)um(a,b[f],c,d,e);return null}c=vm(c);if(a&&a[im])a=a.sb(b,c,d,e);else{if(!b)throw Error("Invalid event type");var f=!!d,h=wm(a);h||(a[rm]=h=new mm(a));c=nm(h,b,c,d,e);if(!c.f){d=xm();c.f=d;d.src=a;d.listener=c;if(a.addEventListener)a.addEventListener(b.toString(),d,f);else if(a.attachEvent)a.attachEvent(ym(b.toString()),d);else throw Error("addEventListener and attachEvent are unavailable.");tm++}a=c}return a}
function xm(){var a=zm,b=fm?function(c){return a.call(b.src,b.listener,c)}:function(c){c=a.call(b.src,b.listener,c);
if(!c)return c};
return b}
function Am(a,b,c,d,e){if(ea(b))for(var f=0;f<b.length;f++)Am(a,b[f],c,d,e);else c=vm(c),a&&a[im]?a.zb(b,c,d,e):a&&(a=wm(a))&&(b=qm(a,b,c,!!d,e))&&Bm(b)}
function Bm(a){if(!ga(a)&&a&&!a.Ta){var b=a.src;if(b&&b[im])pm(b.j,a);else{var c=a.type,d=a.f;b.removeEventListener?b.removeEventListener(c,d,a.nb):b.detachEvent&&b.detachEvent(ym(c),d);tm--;(c=wm(b))?(pm(c,a),0==c.h&&(c.src=null,b[rm]=null)):lm(a)}}}
function ym(a){return a in sm?sm[a]:sm[a]="on"+a}
function Cm(a,b,c,d){var e=!0;if(a=wm(a))if(b=a.f[b.toString()])for(b=b.concat(),a=0;a<b.length;a++){var f=b[a];f&&f.nb==c&&!f.Ta&&(f=Dm(f,d),e=e&&!1!==f)}return e}
function Dm(a,b){var c=a.listener,d=a.rb||a.src;a.lb&&Bm(a);return c.call(d,b)}
function zm(a,b){if(a.Ta)return!0;if(!fm){var c=b||r("window.event"),d=new hm(c,this),e=!0;if(!(0>c.keyCode||void 0!=c.returnValue)){a:{var f=!1;if(0==c.keyCode)try{c.keyCode=-1;break a}catch(l){f=!0}if(f||void 0==c.returnValue)c.returnValue=!0}c=[];for(f=d.currentTarget;f;f=f.parentNode)c.push(f);for(var f=a.type,h=c.length-1;0<=h;h--){d.currentTarget=c[h];var k=Cm(c[h],f,!0,d),e=e&&k}for(h=0;h<c.length;h++)d.currentTarget=c[h],k=Cm(c[h],f,!1,d),e=e&&k}return e}return Dm(a,new hm(b,this))}
function wm(a){a=a[rm];return a instanceof mm?a:null}
var Em="__closure_events_fn_"+(1E9*Math.random()>>>0);function vm(a){if(ha(a))return a;a[Em]||(a[Em]=function(b){return a.handleEvent(b)});
return a[Em]}
;function Fm(){D.call(this);this.j=new mm(this);this.Aa=this;this.qa=null}
x(Fm,D);Fm.prototype[im]=!0;g=Fm.prototype;g.addEventListener=function(a,b,c,d){um(this,a,b,c,d)};
g.removeEventListener=function(a,b,c,d){Am(this,a,b,c,d)};
function Gm(a,b){var c,d=a.qa;if(d){c=[];for(var e=1;d;d=d.qa)c.push(d),++e}var d=a.Aa,e=b,f=e.type||e;if(u(e))e=new em(e,d);else if(e instanceof em)e.target=e.target||d;else{var h=e,e=new em(f,d);wb(e,h)}var h=!0,k;if(c)for(var l=c.length-1;0<=l;l--)k=e.currentTarget=c[l],h=Hm(k,f,!0,e)&&h;k=e.currentTarget=d;h=Hm(k,f,!0,e)&&h;h=Hm(k,f,!1,e)&&h;if(c)for(l=0;l<c.length;l++)k=e.currentTarget=c[l],h=Hm(k,f,!1,e)&&h}
g.G=function(){Fm.I.G.call(this);this.removeAllListeners();this.qa=null};
g.sb=function(a,b,c,d){return nm(this.j,String(a),b,c,d)};
g.zb=function(a,b,c,d){return this.j.remove(String(a),b,c,d)};
g.removeAllListeners=function(a){return this.j?this.j.removeAll(a):0};
function Hm(a,b,c,d){b=a.j.f[String(b)];if(!b)return!0;b=b.concat();for(var e=!0,f=0;f<b.length;++f){var h=b[f];if(h&&!h.Ta&&h.nb==c){var k=h.listener,l=h.rb||h.src;h.lb&&pm(a.j,h);e=!1!==k.call(l,d)&&e}}return e&&0!=d.Lc}
;function Im(a,b){this.h=new Cd(a);this.f=b?Ad:zd}
Im.prototype.stringify=function(a){return Bd(this.h,a)};
Im.prototype.parse=function(a){return this.f(a)};function Jm(a,b){this.f=0;this.B=void 0;this.l=this.h=this.j=null;this.o=this.A=!1;if(a!=t)try{var c=this;a.call(b,function(a){Km(c,2,a)},function(a){Km(c,3,a)})}catch(d){Km(this,3,d)}}
function Lm(){this.next=this.context=this.h=this.l=this.f=null;this.j=!1}
Lm.prototype.reset=function(){this.context=this.h=this.l=this.f=null;this.j=!1};
var Mm=new Wb(function(){return new Lm},function(a){a.reset()},100);
function Nm(a,b,c){var d=Mm.get();d.l=a;d.h=b;d.context=c;return d}
function Om(a){return new Jm(function(b,c){c(a)})}
Jm.prototype.then=function(a,b,c){return Pm(this,ha(a)?a:null,ha(b)?b:null,c)};
Jm.prototype.then=Jm.prototype.then;Jm.prototype.$goog_Thenable=!0;Jm.prototype.cancel=function(a){0==this.f&&ac(function(){var b=new Qm(a);Rm(this,b)},this)};
function Rm(a,b){if(0==a.f)if(a.j){var c=a.j;if(c.h){for(var d=0,e=null,f=null,h=c.h;h&&(h.j||(d++,h.f==a&&(e=h),!(e&&1<d)));h=h.next)e||(f=h);e&&(0==c.f&&1==d?Rm(c,b):(f?(d=f,d.next==c.l&&(c.l=d),d.next=d.next.next):Sm(c),Tm(c,e,3,b)))}a.j=null}else Km(a,3,b)}
function Um(a,b){a.h||2!=a.f&&3!=a.f||Vm(a);a.l?a.l.next=b:a.h=b;a.l=b}
function Pm(a,b,c,d){var e=Nm(null,null,null);e.f=new Jm(function(a,h){e.l=b?function(c){try{var e=b.call(d,c);a(e)}catch(n){h(n)}}:a;
e.h=c?function(b){try{var e=c.call(d,b);!p(e)&&b instanceof Qm?h(b):a(e)}catch(n){h(n)}}:h});
e.f.j=a;Um(a,e);return e.f}
Jm.prototype.T=function(a){this.f=0;Km(this,2,a)};
Jm.prototype.J=function(a){this.f=0;Km(this,3,a)};
function Km(a,b,c){if(0==a.f){a==c&&(b=3,c=new TypeError("Promise cannot resolve to itself"));a.f=1;var d;a:{var e=c,f=a.T,h=a.J;if(e instanceof Jm)Um(e,Nm(f||t,h||null,a)),d=!0;else{var k;if(e)try{k=!!e.$goog_Thenable}catch(n){k=!1}else k=!1;if(k)e.then(f,h,a),d=!0;else{if(ia(e))try{var l=e.then;if(ha(l)){Wm(e,l,f,h,a);d=!0;break a}}catch(n){h.call(a,n);d=!0;break a}d=!1}}}d||(a.B=c,a.f=b,a.j=null,Vm(a),3!=b||c instanceof Qm||Xm(a,c))}}
function Wm(a,b,c,d,e){function f(a){k||(k=!0,d.call(e,a))}
function h(a){k||(k=!0,c.call(e,a))}
var k=!1;try{b.call(a,h,f)}catch(l){f(l)}}
function Vm(a){a.A||(a.A=!0,ac(a.F,a))}
function Sm(a){var b=null;a.h&&(b=a.h,a.h=b.next,b.next=null);a.h||(a.l=null);return b}
Jm.prototype.F=function(){for(var a=null;a=Sm(this);)Tm(this,a,this.f,this.B);this.A=!1};
function Tm(a,b,c,d){if(3==c&&b.h&&!b.j)for(;a&&a.o;a=a.j)a.o=!1;if(b.f)b.f.j=null,Ym(b,c,d);else try{b.j?b.l.call(b.context):Ym(b,c,d)}catch(e){Zm.call(null,e)}Xb(Mm,b)}
function Ym(a,b,c){2==b?a.l.call(a.context,c):a.h&&a.h.call(a.context,c)}
function Xm(a,b){a.o=!0;ac(function(){a.o&&Zm.call(null,b)})}
var Zm=Tb;function Qm(a){qa.call(this,a)}
x(Qm,qa);Qm.prototype.name="cancel";function $m(a,b){Fm.call(this);this.f=a||1;this.h=b||m;this.l=v(this.Ce,this);this.o=w()}
x($m,Fm);g=$m.prototype;g.enabled=!1;g.ea=null;function an(a,b){a.f=b;a.ea&&a.enabled?(a.stop(),a.start()):a.ea&&a.stop()}
g.Ce=function(){if(this.enabled){var a=w()-this.o;0<a&&a<.8*this.f?this.ea=this.h.setTimeout(this.l,this.f-a):(this.ea&&(this.h.clearTimeout(this.ea),this.ea=null),Gm(this,"tick"),this.enabled&&(this.ea=this.h.setTimeout(this.l,this.f),this.o=w()))}};
g.start=function(){this.enabled=!0;this.ea||(this.ea=this.h.setTimeout(this.l,this.f),this.o=w())};
g.stop=function(){this.enabled=!1;this.ea&&(this.h.clearTimeout(this.ea),this.ea=null)};
g.G=function(){$m.I.G.call(this);this.stop();delete this.h};
function bn(a,b,c){if(ha(a))c&&(a=v(a,c));else if(a&&"function"==typeof a.handleEvent)a=v(a.handleEvent,a);else throw Error("Invalid listener argument");return 2147483647<Number(b)?-1:m.setTimeout(a,b||0)}
;function cn(a,b,c){D.call(this);this.l=null!=c?v(a,c):a;this.j=b;this.h=v(this.ee,this);this.f=[]}
x(cn,D);g=cn.prototype;g.yb=!1;g.Pa=null;g.rd=function(a){this.f=arguments;this.Pa?this.yb=!0:dn(this)};
g.stop=function(){this.Pa&&(m.clearTimeout(this.Pa),this.Pa=null,this.yb=!1,this.f=[])};
g.G=function(){cn.I.G.call(this);this.stop()};
g.ee=function(){this.Pa=null;this.yb&&(this.yb=!1,dn(this))};
function dn(a){a.Pa=bn(a.h,a.j);a.l.apply(null,a.f)}
;function en(a){D.call(this);this.h=a;this.f={}}
x(en,D);var fn=[];g=en.prototype;g.sb=function(a,b,c,d){ea(b)||(b&&(fn[0]=b.toString()),b=fn);for(var e=0;e<b.length;e++){var f=um(a,b[e],c||this.handleEvent,d||!1,this.h||this);if(!f)break;this.f[f.key]=f}return this};
g.zb=function(a,b,c,d,e){if(ea(b))for(var f=0;f<b.length;f++)this.zb(a,b[f],c,d,e);else c=c||this.handleEvent,e=e||this.h||this,c=vm(c),d=!!d,b=a&&a[im]?qm(a.j,String(b),c,d,e):a?(a=wm(a))?qm(a,b,c,d,e):null:null,b&&(Bm(b),delete this.f[b.key]);return this};
g.removeAll=function(){eb(this.f,function(a,b){this.f.hasOwnProperty(b)&&Bm(a)},this);
this.f={}};
g.G=function(){en.I.G.call(this);this.removeAll()};
g.handleEvent=function(){throw Error("EventHandler.handleEvent not implemented");};function gn(){}
gn.prototype.f=null;function hn(a){var b;(b=a.f)||(b={},jn(a)&&(b[0]=!0,b[1]=!0),b=a.f=b);return b}
;var kn;function ln(){}
x(ln,gn);function mn(a){return(a=jn(a))?new ActiveXObject(a):new XMLHttpRequest}
function jn(a){if(!a.h&&"undefined"==typeof XMLHttpRequest&&"undefined"!=typeof ActiveXObject){for(var b=["MSXML2.XMLHTTP.6.0","MSXML2.XMLHTTP.3.0","MSXML2.XMLHTTP","Microsoft.XMLHTTP"],c=0;c<b.length;c++){var d=b[c];try{return new ActiveXObject(d),a.h=d}catch(e){}}throw Error("Could not create ActiveXObject. ActiveX might be disabled, or MSXML might not be installed");}return a.h}
kn=new ln;function nn(a,b,c,d,e){this.f=a;this.j=c;this.F=d;this.B=e||1;this.o=45E3;this.l=new en(this);this.h=new $m;an(this.h,250)}
g=nn.prototype;g.Ja=null;g.ma=!1;g.Va=null;g.ac=null;g.ib=null;g.Ua=null;g.Ba=null;g.Ea=null;g.La=null;g.N=null;g.kb=0;g.na=null;g.Cb=null;g.Ka=null;g.cb=-1;g.Mc=!0;g.Ga=!1;g.Rb=0;g.wb=null;var on={},pn={};g=nn.prototype;g.setTimeout=function(a){this.o=a};
function qn(a,b,c){a.Ua=1;a.Ba=Gg(b.clone());a.La=c;a.A=!0;rn(a,null)}
function sn(a,b,c,d,e){a.Ua=1;a.Ba=Gg(b.clone());a.La=null;a.A=c;e&&(a.Mc=!1);rn(a,d)}
function rn(a,b){a.ib=w();tn(a);a.Ea=a.Ba.clone();Eg(a.Ea,"t",a.B);a.kb=0;a.N=a.f.Kb(a.f.jb()?b:null);0<a.Rb&&(a.wb=new cn(v(a.Rc,a,a.N),a.Rb));a.l.sb(a.N,"readystatechange",a.oe);var c=a.Ja?tb(a.Ja):{};a.La?(a.Cb="POST",c["Content-Type"]="application/x-www-form-urlencoded",a.N.send(a.Ea,a.Cb,a.La,c)):(a.Cb="GET",a.Mc&&!ld&&(c.Connection="close"),a.N.send(a.Ea,a.Cb,null,c));a.f.la(1)}
g.oe=function(a){a=a.target;var b=this.wb;b&&3==un(a)?b.rd():this.Rc(a)};
g.Rc=function(a){try{if(a==this.N)a:{var b=un(this.N),c=this.N.o,d=this.N.getStatus();if(L&&!wd(10)||ld&&!vd("420+")){if(4>b)break a}else if(3>b||3==b&&!id&&!vn(this.N))break a;this.Ga||4!=b||7==c||(8==c||0>=d?this.f.la(3):this.f.la(2));wn(this);var e=this.N.getStatus();this.cb=e;var f=vn(this.N);(this.ma=200==e)?(4==b&&xn(this),this.A?(yn(this,b,f),id&&this.ma&&3==b&&(this.l.sb(this.h,"tick",this.ne),this.h.start())):zn(this,f),this.ma&&!this.Ga&&(4==b?this.f.tb(this):(this.ma=!1,tn(this)))):(this.Ka=
400==e&&0<f.indexOf("Unknown SID")?3:0,X(),xn(this),An(this))}}catch(h){this.N&&vn(this.N)}finally{}};
function yn(a,b,c){for(var d=!0;!a.Ga&&a.kb<c.length;){var e=Bn(a,c);if(e==pn){4==b&&(a.Ka=4,X(),d=!1);break}else if(e==on){a.Ka=4;X();d=!1;break}else zn(a,e)}4==b&&0==c.length&&(a.Ka=1,X(),d=!1);a.ma=a.ma&&d;d||(xn(a),An(a))}
g.ne=function(){var a=un(this.N),b=vn(this.N);this.kb<b.length&&(wn(this),yn(this,a,b),this.ma&&4!=a&&tn(this))};
function Bn(a,b){var c=a.kb,d=b.indexOf("\n",c);if(-1==d)return pn;c=Number(b.substring(c,d));if(isNaN(c))return on;d+=1;if(d+c>b.length)return pn;var e=b.substr(d,c);a.kb=d+c;return e}
function Cn(a,b){a.ib=w();tn(a);var c=b?window.location.hostname:"";a.Ea=a.Ba.clone();O(a.Ea,"DOMAIN",c);O(a.Ea,"t",a.B);try{a.na=new ActiveXObject("htmlfile")}catch(n){xn(a);a.Ka=7;X();An(a);return}var d="<html><body>";if(b){for(var e="",f=0;f<c.length;f++){var h=c.charAt(f);if("<"==h)e=e+"\\x3c";else if(">"==h)e=e+"\\x3e";else{if(h in Ha)h=Ha[h];else if(h in Ga)h=Ha[h]=Ga[h];else{var k=h,l=h.charCodeAt(0);if(31<l&&127>l)k=h;else{if(256>l){if(k="\\x",16>l||256<l)k+="0"}else k="\\u",4096>l&&(k+="0");
k+=l.toString(16).toUpperCase()}h=Ha[h]=k}e+=h}}d+='<script>document.domain="'+e+'"\x3c/script>'}d+="</body></html>";c=Pc(Db("b/12014412"),d);a.na.open();a.na.write(Mb(c));a.na.close();a.na.parentWindow.m=v(a.ie,a);a.na.parentWindow.d=v(a.Fc,a,!0);a.na.parentWindow.rpcClose=v(a.Fc,a,!1);c=a.na.createElement("DIV");a.na.parentWindow.document.body.appendChild(c);d=Ib(a.Ea.toString());d=Gb(d);Ba.test(d)&&(-1!=d.indexOf("&")&&(d=d.replace(va,"&amp;")),-1!=d.indexOf("<")&&(d=d.replace(wa,"&lt;")),-1!=
d.indexOf(">")&&(d=d.replace(xa,"&gt;")),-1!=d.indexOf('"')&&(d=d.replace(ya,"&quot;")),-1!=d.indexOf("'")&&(d=d.replace(za,"&#39;")),-1!=d.indexOf("\x00")&&(d=d.replace(Aa,"&#0;")));d=Pc(Db("b/12014412"),'<iframe src="'+d+'"></iframe>');c.innerHTML=Mb(d);a.f.la(1)}
g.ie=function(a){Dn(v(this.he,this,a),0)};
g.he=function(a){this.Ga||(wn(this),zn(this,a),tn(this))};
g.Fc=function(a){Dn(v(this.ge,this,a),0)};
g.ge=function(a){this.Ga||(xn(this),this.ma=a,this.f.tb(this),this.f.la(4))};
g.cancel=function(){this.Ga=!0;xn(this)};
function tn(a){a.ac=w()+a.o;En(a,a.o)}
function En(a,b){if(null!=a.Va)throw Error("WatchDog timer not null");a.Va=Dn(v(a.ke,a),b)}
function wn(a){a.Va&&(m.clearTimeout(a.Va),a.Va=null)}
g.ke=function(){this.Va=null;var a=w();0<=a-this.ac?(2!=this.Ua&&this.f.la(3),xn(this),this.Ka=2,X(),An(this)):En(this,this.ac-a)};
function An(a){a.f.sc()||a.Ga||a.f.tb(a)}
function xn(a){wn(a);E(a.wb);a.wb=null;a.h.stop();a.l.removeAll();if(a.N){var b=a.N;a.N=null;Fn(b);b.dispose()}a.na&&(a.na=null)}
function zn(a,b){try{a.f.Ac(a,b),a.f.la(4)}catch(c){}}
;function Gn(a,b,c,d,e){if(0==d)c(!1);else{var f=e||0;d--;Hn(a,b,function(e){e?c(!0):m.setTimeout(function(){Gn(a,b,c,d,f)},f)})}}
function Hn(a,b,c){var d=new Image;d.onload=function(){try{In(d),c(!0)}catch(a){}};
d.onerror=function(){try{In(d),c(!1)}catch(a){}};
d.onabort=function(){try{In(d),c(!1)}catch(a){}};
d.ontimeout=function(){try{In(d),c(!1)}catch(a){}};
m.setTimeout(function(){if(d.ontimeout)d.ontimeout()},b);
d.src=a}
function In(a){a.onload=null;a.onerror=null;a.onabort=null;a.ontimeout=null}
;function Jn(a){this.f=a;this.h=new Im(null,!0)}
g=Jn.prototype;g.Pb=null;g.da=null;g.xb=!1;g.Pc=null;g.ob=null;g.Ub=null;g.Qb=null;g.fa=null;g.za=-1;g.bb=null;g.Xa=null;g.connect=function(a){this.Qb=a;a=Kn(this.f,null,this.Qb);X();this.Pc=w();var b=this.f.F;null!=b?(this.bb=b[0],(this.Xa=b[1])?(this.fa=1,Ln(this)):(this.fa=2,Mn(this))):(Eg(a,"MODE","init"),this.da=new nn(this,0,void 0,void 0,void 0),this.da.Ja=this.Pb,sn(this.da,a,!1,null,!0),this.fa=0)};
function Ln(a){var b=Kn(a.f,a.Xa,"/mail/images/cleardot.gif");Gg(b);Gn(b.toString(),5E3,v(a.md,a),3,2E3);a.la(1)}
g.md=function(a){if(a)this.fa=2,Mn(this);else{X();var b=this.f;b.ia=b.Ca.za;Nn(b,9)}a&&this.la(2)};
function Mn(a){var b=a.f.T;if(null!=b)X(),b?(X(),On(a.f,a,!1)):(X(),On(a.f,a,!0));else if(a.da=new nn(a,0,void 0,void 0,void 0),a.da.Ja=a.Pb,b=a.f,b=Kn(b,b.jb()?a.bb:null,a.Qb),X(),!L||wd(10))Eg(b,"TYPE","xmlhttp"),sn(a.da,b,!1,a.bb,!1);else{Eg(b,"TYPE","html");var c=a.da;a=!!a.bb;c.Ua=3;c.Ba=Gg(b.clone());Cn(c,a)}}
g.Kb=function(a){return this.f.Kb(a)};
g.sc=function(){return!1};
g.Ac=function(a,b){this.za=a.cb;if(0==this.fa)if(b){try{var c=this.h.parse(b)}catch(d){c=this.f;c.ia=this.za;Nn(c,2);return}this.bb=c[0];this.Xa=c[1]}else c=this.f,c.ia=this.za,Nn(c,2);else if(2==this.fa)if(this.xb)X(),this.Ub=w();else if("11111"==b){if(X(),this.xb=!0,this.ob=w(),c=this.ob-this.Pc,!L||wd(10)||500>c)this.za=200,this.da.cancel(),X(),On(this.f,this,!0)}else X(),this.ob=this.Ub=w(),this.xb=!1};
g.tb=function(){this.za=this.da.cb;if(this.da.ma)0==this.fa?this.Xa?(this.fa=1,Ln(this)):(this.fa=2,Mn(this)):2==this.fa&&(a=!1,(a=!L||wd(10)?this.xb:200>this.Ub-this.ob?!1:!0)?(X(),On(this.f,this,!0)):(X(),On(this.f,this,!1)));else{0==this.fa?X():2==this.fa&&X();var a=this.f;a.ia=this.za;Nn(a,2)}};
g.jb=function(){return this.f.jb()};
g.isActive=function(){return this.f.isActive()};
g.la=function(a){this.f.la(a)};function Pn(a){Fm.call(this);this.headers=new Vc;this.R=a||null;this.h=!1;this.P=this.f=null;this.ta=this.J="";this.o=0;this.A="";this.l=this.ha=this.F=this.Z=!1;this.B=0;this.K=null;this.ua="";this.O=this.va=!1}
x(Pn,Fm);var Qn=/^https?$/i,Rn=["POST","PUT"];g=Pn.prototype;
g.send=function(a,b,c,d){if(this.f)throw Error("[goog.net.XhrIo] Object is active with another request="+this.J+"; newUri="+a);b=b?b.toUpperCase():"GET";this.J=a;this.A="";this.o=0;this.ta=b;this.Z=!1;this.h=!0;this.f=this.R?mn(this.R):mn(kn);this.P=this.R?hn(this.R):hn(kn);this.f.onreadystatechange=v(this.zc,this);try{cm(Sn(this,"Opening Xhr")),this.ha=!0,this.f.open(b,String(a),!0),this.ha=!1}catch(f){cm(Sn(this,"Error opening Xhr: "+f.message));Tn(this,f);return}a=c||"";var e=this.headers.clone();
d&&cd(d,function(a,b){Wc(e,b,a)});
d=Qa(e.ra(),Un);c=m.FormData&&a instanceof m.FormData;!A(Rn,b)||d||c||Wc(e,"Content-Type","application/x-www-form-urlencoded;charset=utf-8");e.forEach(function(a,b){this.f.setRequestHeader(b,a)},this);
this.ua&&(this.f.responseType=this.ua);nb(this.f)&&(this.f.withCredentials=this.va);try{Vn(this),0<this.B&&(this.O=Wn(this.f),cm(Sn(this,"Will abort after "+this.B+"ms if incomplete, xhr2 "+this.O)),this.O?(this.f.timeout=this.B,this.f.ontimeout=v(this.qc,this)):this.K=bn(this.qc,this.B,this)),cm(Sn(this,"Sending request")),this.F=!0,this.f.send(a),this.F=!1}catch(f){cm(Sn(this,"Send error: "+f.message)),Tn(this,f)}};
function Wn(a){return L&&vd(9)&&ga(a.timeout)&&p(a.ontimeout)}
function Un(a){return"content-type"==a.toLowerCase()}
g.qc=function(){"undefined"!=typeof aa&&this.f&&(this.A="Timed out after "+this.B+"ms, aborting",this.o=8,Sn(this,this.A),Gm(this,"timeout"),Fn(this,8))};
function Tn(a,b){a.h=!1;a.f&&(a.l=!0,a.f.abort(),a.l=!1);a.A=b;a.o=5;Xn(a);Yn(a)}
function Xn(a){a.Z||(a.Z=!0,Gm(a,"complete"),Gm(a,"error"))}
function Fn(a,b){a.f&&a.h&&(Sn(a,"Aborting"),a.h=!1,a.l=!0,a.f.abort(),a.l=!1,a.o=b||7,Gm(a,"complete"),Gm(a,"abort"),Yn(a))}
g.G=function(){this.f&&(this.h&&(this.h=!1,this.l=!0,this.f.abort(),this.l=!1),Yn(this,!0));Pn.I.G.call(this)};
g.zc=function(){this.isDisposed()||(this.ha||this.F||this.l?Zn(this):this.Xd())};
g.Xd=function(){Zn(this)};
function Zn(a){if(a.h&&"undefined"!=typeof aa)if(a.P[1]&&4==un(a)&&2==a.getStatus())Sn(a,"Local request error detected and ignored");else if(a.F&&4==un(a))bn(a.zc,0,a);else if(Gm(a,"readystatechange"),4==un(a)){Sn(a,"Request complete");a.h=!1;try{var b=a.getStatus(),c;a:switch(b){case 200:case 201:case 202:case 204:case 206:case 304:case 1223:c=!0;break a;default:c=!1}var d;if(!(d=c)){var e;if(e=0===b){var f=String(a.J).match(Hd)[1]||null;if(!f&&m.self&&m.self.location)var h=m.self.location.protocol,
f=h.substr(0,h.length-1);e=!Qn.test(f?f.toLowerCase():"")}d=e}if(d)Gm(a,"complete"),Gm(a,"success");else{a.o=6;var k;try{k=2<un(a)?a.f.statusText:""}catch(l){k=""}a.A=k+" ["+a.getStatus()+"]";Xn(a)}}finally{Yn(a)}}}
function Yn(a,b){if(a.f){Vn(a);var c=a.f,d=a.P[0]?t:null;a.f=null;a.P=null;b||Gm(a,"ready");try{c.onreadystatechange=d}catch(e){}}}
function Vn(a){a.f&&a.O&&(a.f.ontimeout=null);ga(a.K)&&(m.clearTimeout(a.K),a.K=null)}
g.isActive=function(){return!!this.f};
function un(a){return a.f?a.f.readyState:0}
g.getStatus=function(){try{return 2<un(this)?this.f.status:-1}catch(a){return-1}};
function vn(a){try{return a.f?a.f.responseText:""}catch(b){return""}}
function Sn(a,b){return b+" ["+a.ta+" "+a.J+" "+a.getStatus()+"]"}
;function $n(a,b,c){this.B=a||null;this.f=1;this.h=[];this.l=[];this.o=new Im(null,!0);this.F=b||null;this.T=null!=c?c:null}
function ao(a,b){this.f=a;this.map=b;this.context=null}
g=$n.prototype;g.$a=null;g.X=null;g.L=null;g.Ob=null;g.pb=null;g.hc=null;g.qb=null;g.fb=0;g.Gd=0;g.U=null;g.Da=null;g.ya=null;g.Ia=null;g.Ca=null;g.Bb=null;g.Qa=-1;g.tc=-1;g.ia=-1;g.ab=0;g.Oa=0;g.Ha=8;var bo=new Fm;function co(a){em.call(this,"statevent",a)}
x(co,em);function eo(a,b){em.call(this,"timingevent",a);this.size=b}
x(eo,em);function fo(a){em.call(this,"serverreachability",a)}
x(fo,em);g=$n.prototype;g.connect=function(a,b,c,d,e){X();this.Ob=b;this.$a=c||{};d&&p(e)&&(this.$a.OSID=d,this.$a.OAID=e);this.Ca=new Jn(this);this.Ca.Pb=null;this.Ca.h=this.o;this.Ca.connect(a)};
function go(a){ho(a);if(3==a.f){var b=a.fb++,c=a.pb.clone();O(c,"SID",a.j);O(c,"RID",b);O(c,"TYPE","terminate");io(a,c);b=new nn(a,0,a.j,b,void 0);b.Ua=2;b.Ba=Gg(c.clone());(new Image).src=b.Ba;b.ib=w();tn(b)}jo(a)}
function ho(a){if(a.Ca){var b=a.Ca;b.da&&(b.da.cancel(),b.da=null);b.za=-1;a.Ca=null}a.L&&(a.L.cancel(),a.L=null);a.ya&&(m.clearTimeout(a.ya),a.ya=null);ko(a);a.X&&(a.X.cancel(),a.X=null);a.Da&&(m.clearTimeout(a.Da),a.Da=null)}
function lo(a,b){if(0==a.f)throw Error("Invalid operation: sending map when state is closed");a.h.push(new ao(a.Gd++,b));2!=a.f&&3!=a.f||mo(a)}
g.sc=function(){return 0==this.f};
function mo(a){a.X||a.Da||(a.Da=Dn(v(a.Ec,a),0),a.ab=0)}
g.Ec=function(a){this.Da=null;no(this,a)};
function no(a,b){if(1==a.f){if(!b){a.fb=Math.floor(1E5*Math.random());var c=a.fb++,d=new nn(a,0,"",c,void 0);d.Ja=null;var e=oo(a),f=a.pb.clone();O(f,"RID",c);a.B&&O(f,"CVER",a.B);io(a,f);qn(d,f,e);a.X=d;a.f=2}}else 3==a.f&&(b?po(a,b):0!=a.h.length&&(a.X||po(a)))}
function po(a,b){var c,d;b?6<a.Ha?(a.h=a.l.concat(a.h),a.l.length=0,c=a.fb-1,d=oo(a)):(c=b.F,d=b.La):(c=a.fb++,d=oo(a));var e=a.pb.clone();O(e,"SID",a.j);O(e,"RID",c);O(e,"AID",a.Qa);io(a,e);c=new nn(a,0,a.j,c,a.ab+1);c.Ja=null;c.setTimeout(Math.round(1E4)+Math.round(1E4*Math.random()));a.X=c;qn(c,e,d)}
function io(a,b){if(a.U){var c=a.U.nc(a);c&&eb(c,function(a,c){O(b,c,a)})}}
function oo(a){var b=Math.min(a.h.length,1E3),c=["count="+b],d;6<a.Ha&&0<b?(d=a.h[0].f,c.push("ofs="+d)):d=0;for(var e=0;e<b;e++){var f=a.h[e].f,h=a.h[e].map,f=6>=a.Ha?e:f-d;try{cd(h,function(a,b){c.push("req"+f+"_"+b+"="+encodeURIComponent(a))})}catch(k){c.push("req"+f+"_type="+encodeURIComponent("_badmap"))}}a.l=a.l.concat(a.h.splice(0,b));
return c.join("&")}
function qo(a){a.L||a.ya||(a.A=1,a.ya=Dn(v(a.Dc,a),0),a.Oa=0)}
function ro(a){if(a.L||a.ya||3<=a.Oa)return!1;a.A++;a.ya=Dn(v(a.Dc,a),so(a,a.Oa));a.Oa++;return!0}
g.Dc=function(){this.ya=null;this.L=new nn(this,0,this.j,"rpc",this.A);this.L.Ja=null;this.L.Rb=0;var a=this.hc.clone();O(a,"RID","rpc");O(a,"SID",this.j);O(a,"CI",this.Bb?"0":"1");O(a,"AID",this.Qa);io(this,a);if(!L||wd(10))O(a,"TYPE","xmlhttp"),sn(this.L,a,!0,this.qb,!1);else{O(a,"TYPE","html");var b=this.L,c=!!this.qb;b.Ua=3;b.Ba=Gg(a.clone());Cn(b,c)}};
function On(a,b,c){a.Bb=c;a.ia=b.za;a.pd(1,0);a.pb=Kn(a,null,a.Ob);mo(a)}
g.Ac=function(a,b){if(0!=this.f&&(this.L==a||this.X==a))if(this.ia=a.cb,this.X==a&&3==this.f)if(7<this.Ha){var c;try{c=this.o.parse(b)}catch(f){c=null}if(ea(c)&&3==c.length)if(0==c[0])a:{if(!this.ya){if(this.L)if(this.L.ib+3E3<this.X.ib)ko(this),this.L.cancel(),this.L=null;else break a;ro(this);X()}}else this.tc=c[1],0<this.tc-this.Qa&&37500>c[2]&&this.Bb&&0==this.Oa&&!this.Ia&&(this.Ia=Dn(v(this.Hd,this),6E3));else Nn(this,11)}else"y2f%"!=b&&Nn(this,11);else if(this.L==a&&ko(this),!/^[\s\xa0]*$/.test(b)){c=
this.o.parse(b);ea(c);for(var d=0;d<c.length;d++){var e=c[d];this.Qa=e[0];e=e[1];2==this.f?"c"==e[0]?(this.j=e[1],this.qb=e[2],e=e[3],null!=e?this.Ha=e:this.Ha=6,this.f=3,this.U&&this.U.lc(this),this.hc=Kn(this,this.jb()?this.qb:null,this.Ob),qo(this)):"stop"==e[0]&&Nn(this,7):3==this.f&&("stop"==e[0]?Nn(this,7):"noop"!=e[0]&&this.U&&this.U.kc(this,e),this.Oa=0)}}};
g.Hd=function(){null!=this.Ia&&(this.Ia=null,this.L.cancel(),this.L=null,ro(this),X())};
function ko(a){null!=a.Ia&&(m.clearTimeout(a.Ia),a.Ia=null)}
g.tb=function(a){var b;if(this.L==a)ko(this),this.L=null,b=2;else if(this.X==a)this.X=null,b=1;else return;this.ia=a.cb;if(0!=this.f)if(a.ma)1==b?(w(),Gm(bo,new eo(bo,a.La?a.La.length:0)),mo(this),this.l.length=0):qo(this);else{var c=a.Ka,d;if(!(d=3==c||7==c||0==c&&0<this.ia)){if(d=1==b)this.X||this.Da||1==this.f||2<=this.ab?d=!1:(this.Da=Dn(v(this.Ec,this,a),so(this,this.ab)),this.ab++,d=!0);d=!(d||2==b&&ro(this))}if(d)switch(c){case 1:Nn(this,5);break;case 4:Nn(this,10);break;case 3:Nn(this,6);
break;case 7:Nn(this,12);break;default:Nn(this,2)}}};
function so(a,b){var c=5E3+Math.floor(1E4*Math.random());a.isActive()||(c*=2);return c*b}
g.pd=function(a){if(!A(arguments,this.f))throw Error("Unexpected channel state: "+this.f);};
function Nn(a,b){if(2==b||9==b){var c=null;a.U&&(c=null);var d=v(a.Be,a);c||(c=new ng("//www.google.com/images/cleardot.gif"),Gg(c));Hn(c.toString(),1E4,d)}else X();to(a,b)}
g.Be=function(a){a?X():(X(),to(this,8))};
function to(a,b){a.f=0;a.U&&a.U.jc(a,b);jo(a);ho(a)}
function jo(a){a.f=0;a.ia=-1;if(a.U)if(0==a.l.length&&0==a.h.length)a.U.Ib(a);else{var b=Ya(a.l),c=Ya(a.h);a.l.length=0;a.h.length=0;a.U.Ib(a,b,c)}}
function Kn(a,b,c){var d=Hg(c);if(""!=d.h)b&&pg(d,b+"."+d.h),qg(d,d.B);else var e=window.location,d=Ig(e.protocol,b?b+"."+e.hostname:e.hostname,e.port,c);a.$a&&eb(a.$a,function(a,b){O(d,b,a)});
O(d,"VER",a.Ha);io(a,d);return d}
g.Kb=function(a){if(a)throw Error("Can't create secondary domain capable XhrIo object.");a=new Pn;a.va=!1;return a};
g.isActive=function(){return!!this.U&&this.U.isActive(this)};
function Dn(a,b){if(!ha(a))throw Error("Fn must not be null and must be a function");return m.setTimeout(function(){a()},b)}
g.la=function(){Gm(bo,new fo(bo))};
function X(){Gm(bo,new co(bo))}
g.jb=function(){return!(!L||wd(10))};
function uo(){}
g=uo.prototype;g.lc=function(){};
g.kc=function(){};
g.jc=function(){};
g.Ib=function(){};
g.nc=function(){return{}};
g.isActive=function(){return!0};function vo(a,b){$m.call(this);this.A=0;if(ha(a))b&&(a=v(a,b));else if(a&&ha(a.handleEvent))a=v(a.handleEvent,a);else throw Error("Invalid listener argument");this.F=a;um(this,"tick",v(this.B,this));this.stop();an(this,5E3+2E4*Math.random())}
x(vo,$m);vo.prototype.B=function(){if(500<this.f){var a=this.f;24E4>2*a&&(a*=2);an(this,a)}this.F()};
vo.prototype.start=function(){vo.I.start.call(this);this.A=w()+this.f};
vo.prototype.stop=function(){this.A=0;vo.I.stop.call(this)};function wo(a,b){this.sa=a;this.l=b;this.j=new F;this.h=new vo(this.Ie,this);this.f=null;this.J=!1;this.A=null;this.T="";this.F=this.o=0;this.B=[]}
x(wo,uo);g=wo.prototype;g.subscribe=function(a,b,c){return this.j.subscribe(a,b,c)};
g.unsubscribe=function(a,b,c){return this.j.unsubscribe(a,b,c)};
g.oa=function(a){return this.j.oa(a)};
g.D=function(a,b){return this.j.D.apply(this.j,arguments)};
g.dispose=function(){this.J||(this.J=!0,this.j.clear(),xo(this),E(this.j))};
g.isDisposed=function(){return this.J};
function yo(a){return{firstTestResults:[""],secondTestResults:!a.f.Bb,sessionId:a.f.j,arrayId:a.f.Qa}}
g.connect=function(a,b,c){if(!this.f||2!=this.f.f){this.T="";this.h.stop();this.A=a||null;this.o=b||0;a=this.sa+"/test";b=this.sa+"/bind";var d=new $n("1",c?c.firstTestResults:null,c?c.secondTestResults:null),e=this.f;e&&(e.U=null);d.U=this;this.f=d;e?this.f.connect(a,b,this.l,e.j,e.Qa):c?this.f.connect(a,b,this.l,c.sessionId,c.arrayId):this.f.connect(a,b,this.l)}};
function xo(a,b){a.F=b||0;a.h.stop();a.f&&(3==a.f.f&&no(a.f),go(a.f));a.F=0}
g.sendMessage=function(a,b){var c={_sc:a};b&&wb(c,b);this.h.enabled||2==(this.f?this.f.f:0)?this.B.push(c):this.f&&3==this.f.f&&lo(this.f,c)};
g.lc=function(){var a=this.h;a.stop();an(a,5E3+2E4*Math.random());this.A=null;this.o=0;if(this.B.length){a=this.B;this.B=[];for(var b=0,c=a.length;b<c;++b)lo(this.f,a[b])}this.D("handlerOpened")};
g.jc=function(a,b){var c=2==b&&401==this.f.ia;if(4!=b&&!c){if(6==b||410==this.f.ia)c=this.h,c.stop(),an(c,500);this.h.start()}this.D("handlerError",b)};
g.Ib=function(a,b,c){if(!this.h.enabled)this.D("handlerClosed");else if(c)for(a=0,b=c.length;a<b;++a){var d=c[a].map;d&&this.B.push(d)}};
g.nc=function(){var a={v:2};this.T&&(a.gsessionid=this.T);0!=this.o&&(a.ui=""+this.o);0!=this.F&&(a.ui=""+this.F);this.A&&wb(a,this.A);return a};
g.kc=function(a,b){if("S"==b[0])this.T=b[1];else if("gracefulReconnect"==b[0]){var c=this.h;c.stop();an(c,500);this.h.start();go(this.f)}else this.D("handlerMessage",new bm(b[0],b[1]))};
function zo(a,b){(a.l.loungeIdToken=b)||a.h.stop()}
g.Ie=function(){this.h.stop();var a=this.f,b=0;a.L&&b++;a.X&&b++;0!=b?this.h.start():this.connect(this.A,this.o)};function Ao(a){this.videoIds=null;this.index=-1;this.videoId=this.f="";this.volume=this.h=-1;this.o=!1;this.audioTrackId=null;this.A=this.l=0;this.j=null;this.reset(a)}
function Bo(a,b){if(a.f)throw Error(b+" is not allowed in V3.");}
function Co(a){a.audioTrackId=null;a.j=null;a.h=-1;a.l=0;a.A=w()}
Ao.prototype.reset=function(a){this.videoIds=[];this.f="";this.index=-1;this.videoId="";Co(this);this.volume=-1;this.o=!1;a&&(this.videoIds=a.videoIds,this.index=a.index,this.f=a.listId,this.videoId=a.videoId,this.h=a.playerState,this.volume=a.volume,this.o=a.muted,this.audioTrackId=a.audioTrackId,this.j=a.trackData,this.l=a.playerTime,this.A=a.playerTimeAt)};
function Do(a){return a.f?a.videoId:a.videoIds[a.index]}
function Eo(a){switch(a.h){case 1:return(w()-a.A)/1E3+a.l;case -1E3:return 0}return a.l}
Ao.prototype.setVideoId=function(a){Bo(this,"setVideoId");var b=this.index;this.index=Ma(this.videoIds,a);b!=this.index&&Co(this);return-1!=b};
function Fo(a,b,c){Bo(a,"setPlaylist");c=c||Do(a);bb(a.videoIds,b)&&c==Do(a)||(a.videoIds=Ya(b),a.setVideoId(c))}
Ao.prototype.remove=function(a){Bo(this,"remove");var b=Do(this);return Va(this.videoIds,a)?(this.index=Ma(this.videoIds,b),!0):!1};
function Go(a){var b={};b.videoIds=Ya(a.videoIds);b.index=a.index;b.listId=a.f;b.videoId=a.videoId;b.playerState=a.h;b.volume=a.volume;b.muted=a.o;b.audioTrackId=a.audioTrackId;b.trackData=ub(a.j);b.playerTime=a.l;b.playerTimeAt=a.A;return b}
Ao.prototype.clone=function(){return new Ao(Go(this))};function Y(a,b,c){V.call(this);this.A=NaN;this.R=!1;this.J=this.F=this.P=this.K=NaN;this.Z=[];this.j=this.C=this.f=null;this.Ma=a;this.Z.push(N(window,"beforeunload",v(this.zd,this)));this.h=[];this.C=new Ao;3==c["mdx-version"]&&(this.C.f="RQ"+b.token);this.ha=b.id;this.f=Ho(this,c);this.f.subscribe("handlerOpened",this.Nd,this);this.f.subscribe("handlerClosed",this.Jd,this);this.f.subscribe("handlerError",this.Kd,this);this.C.f?this.f.subscribe("handlerMessage",this.Ld,this):this.f.subscribe("handlerMessage",
this.Md,this);zo(this.f,b.token);this.subscribe("remoteQueueChange",function(){var a=this.C.videoId;rk()&&T("yt-remote-session-video-id",a)},this)}
x(Y,V);g=Y.prototype;
g.connect=function(a,b){if(b){if(this.C.f){var c=b.listId,d=b.videoId,e=b.index,f=b.currentTime||0;5>=f&&(f=0);h={videoId:d,currentTime:f};c&&(h.listId=c);p(e)&&(h.currentIndex=e);c&&(this.C.f=c);this.C.videoId=d;this.C.index=e||0}else{var d=b.videoIds[b.index],f=b.currentTime||0;5>=f&&(f=0);var h={videoIds:d,videoId:d,currentTime:f};this.C.videoIds=[d];this.C.index=0}this.C.state=3;c=this.C;c.l=f;c.A=w();this.H("Connecting with setPlaylist and params: "+M(h));this.f.connect({method:"setPlaylist",params:M(h)},
a,vk())}else this.H("Connecting without params"),this.f.connect({},a,vk());Io(this)};
g.dispose=function(){this.isDisposed()||(this.D("beforeDispose"),Jo(this,3));Y.I.dispose.call(this)};
g.G=function(){Ko(this);Lo(this);Mo(this);J(this.F);this.F=NaN;J(this.J);this.J=NaN;this.j=null;We(this.Z);this.Z.length=0;this.f.dispose();Y.I.G.call(this);this.h=this.C=this.f=null};
g.H=function(a){Ej("conn",a)};
g.zd=function(){this.o(2)};
function Ho(a,b){return new wo(Sj(a.Ma,"/bc",void 0,!1),b)}
function Jo(a,b){a.D("proxyStateChange",b)}
function Io(a){a.A=I(v(function(){this.H("Connecting timeout");this.o(1)},a),2E4)}
function Ko(a){J(a.A);a.A=NaN}
function Mo(a){J(a.K);a.K=NaN}
function No(a){Lo(a);a.P=I(v(function(){Oo(this,"getNowPlaying")},a),2E4)}
function Lo(a){J(a.P);a.P=NaN}
function Po(a){var b=a.f;return!!b.f&&3==b.f.f&&isNaN(a.A)}
g.Nd=function(){this.H("Channel opened");this.R&&(this.R=!1,Mo(this),this.K=I(v(function(){this.H("Timing out waiting for a screen.");this.o(1)},this),15E3));
Ek(yo(this.f),this.ha)};
g.Jd=function(){this.H("Channel closed");isNaN(this.A)?Fk(!0):Fk();this.dispose()};
g.Kd=function(a){Fk();isNaN(this.B())?(this.H("Channel error: "+a+" without reconnection"),this.dispose()):(this.R=!0,this.H("Channel error: "+a+" with reconnection in "+this.B()+" ms"),Jo(this,2))};
function Qo(a,b){b&&(Ko(a),Mo(a));b==Po(a)?b&&(Jo(a,1),Oo(a,"getSubtitlesTrack")):b?(a.O()&&a.C.reset(),Jo(a,1),Oo(a,"getNowPlaying"),Ro(a)):a.o(1)}
function So(a,b){var c=b.params.videoId;delete b.params.videoId;c==a.C.videoId&&(qb(b.params)?a.C.j=null:a.C.j=b.params,a.D("remotePlayerChange"))}
function To(a,b){var c=b.params.videoId||b.params.video_id,d=parseInt(b.params.currentIndex,10);a.C.f=b.params.listId||a.C.f;var e=a.C,f=e.videoId;e.videoId=c;e.index=d;c!=f&&Co(e);a.D("remoteQueueChange")}
function Uo(a,b){b.params=b.params||{};To(a,b);Vo(a,b)}
function Vo(a,b){var c=parseInt(b.params.currentTime||b.params.current_time,10),d=a.C;d.l=isNaN(c)?0:c;d.A=w();c=parseInt(b.params.state,10);c=isNaN(c)?-1:c;-1==c&&-1E3==a.C.h&&(c=-1E3);a.C.h=c;1==a.C.h?No(a):Lo(a);a.D("remotePlayerChange")}
function Wo(a,b){var c="true"==b.params.muted;a.C.volume=parseInt(b.params.volume,10);a.C.o=c;a.D("remotePlayerChange")}
g.Ld=function(a){a.params?this.H("Received: action="+a.action+", params="+M(a.params)):this.H("Received: action="+a.action+" {}");switch(a.action){case "loungeStatus":a=zd(a.params.devices);this.h=z(a,function(a){return new mk(a)});
a=!!Qa(this.h,function(a){return"LOUNGE_SCREEN"==a.type});
Qo(this,a);break;case "loungeScreenConnected":Qo(this,!0);break;case "loungeScreenDisconnected":Wa(this.h,function(a){return"LOUNGE_SCREEN"==a.type});
Qo(this,!1);break;case "remoteConnected":var b=new mk(zd(a.params.device));Qa(this.h,function(a){return a.equals(b)})||Ua(this.h,b);
break;case "remoteDisconnected":b=new mk(zd(a.params.device));Wa(this.h,function(a){return a.equals(b)});
break;case "gracefulDisconnect":break;case "playlistModified":To(this,a);break;case "nowPlaying":Uo(this,a);break;case "onStateChange":Vo(this,a);break;case "onVolumeChanged":Wo(this,a);break;case "onSubtitlesTrackChanged":So(this,a);break;default:this.H("Unrecognized action: "+a.action)}};
g.Md=function(a){a.params?this.H("Received: action="+a.action+", params="+M(a.params)):this.H("Received: action="+a.action);Xo(this,a);Yo(this,a);if(Po(this)){var b=this.C.clone(),c=!1,d,e,f,h,k,l;a.params&&(d=a.params.videoId||a.params.video_id,e=a.params.videoIds||a.params.video_ids,f=a.params.state,h=a.params.currentTime||a.params.current_time,k=a.params.volume,l=a.params.muted,p(a.params.currentError)&&zd(a.params.currentError));if("onSubtitlesTrackChanged"==a.action)d==Do(this.C)&&(delete a.params.videoId,
qb(a.params)?this.C.j=null:this.C.j=a.params,this.D("remotePlayerChange"));else if(Do(this.C)||"onStateChange"!=a.action){"playlistModified"!=a.action&&"nowPlayingPlaylist"!=a.action||e?(d||"nowPlaying"!=a.action&&"nowPlayingPlaylist"!=a.action?d||(d=Do(this.C)):this.C.setVideoId(""),e&&(e=e.split(","),Fo(this.C,e,d))):Fo(this.C,[]);e=this.C;var n=d;Bo(e,"add");n&&!A(e.videoIds,n)?(e.videoIds.push(n),e=!0):e=!1;e&&Oo(this,"getPlaylist");d&&this.C.setVideoId(d);b.index==this.C.index&&bb(b.videoIds,
this.C.videoIds)?"playlistModified"!=a.action&&"nowPlayingPlaylist"!=a.action||this.D("remoteQueueChange"):this.D("remoteQueueChange");p(f)&&(a=parseInt(f,10),a=isNaN(a)?-1:a,-1==a&&-1E3==this.C.h&&(a=-1E3),0==a&&"0"==h&&(a=-1),c=c||a!=this.C.h,this.C.h=a,1==this.C.h?No(this):Lo(this));h&&(a=parseInt(h,10),c=this.C,c.l=isNaN(a)?0:a,c.A=w(),c=!0);p(k)&&(a=parseInt(k,10),isNaN(a)||(c=c||this.C.volume!=a,this.C.volume=a),p(l)&&(l="true"==l,c=c||this.C.o!=l,this.C.o=l));c&&this.D("remotePlayerChange")}}};
function Xo(a,b){switch(b.action){case "loungeStatus":var c=zd(b.params.devices);a.h=z(c,function(a){return new mk(a)});
break;case "loungeScreenDisconnected":Wa(a.h,function(a){return"LOUNGE_SCREEN"==a.type});
break;case "remoteConnected":var d=new mk(zd(b.params.device));Qa(a.h,function(a){return a.equals(d)})||Ua(a.h,d);
break;case "remoteDisconnected":d=new mk(zd(b.params.device)),Wa(a.h,function(a){return a.equals(d)})}}
function Yo(a,b){var c=!1;if("loungeStatus"==b.action)c=!!Qa(a.h,function(a){return"LOUNGE_SCREEN"==a.type});
else if("loungeScreenConnected"==b.action)c=!0;else if("loungeScreenDisconnected"==b.action)c=!1;else return;if(!isNaN(a.K))if(c)Mo(a);else return;c==Po(a)?c&&Jo(a,1):c?(Ko(a),a.O()&&a.C.reset(),Jo(a,1),Oo(a,"getNowPlaying"),Ro(a)):a.o(1)}
g.re=function(){if(this.j){var a=this.j;this.j=null;this.C.videoId!=a&&Oo(this,"getNowPlaying")}};
Y.prototype.subscribe=Y.prototype.subscribe;Y.prototype.unsubscribeByKey=Y.prototype.oa;Y.prototype.ua=function(){var a=3;this.isDisposed()||(a=0,isNaN(this.B())?Po(this)&&(a=1):a=2);return a};
Y.prototype.getProxyState=Y.prototype.ua;Y.prototype.o=function(a){this.H("Disconnecting with "+a);Ko(this);this.D("beforeDisconnect",a);1==a&&Fk();xo(this.f,a);this.dispose()};
Y.prototype.disconnect=Y.prototype.o;Y.prototype.ta=function(){var a=this.C;if(this.j){var b=a=this.C.clone(),c=this.j,d=a.index,e=b.videoId;b.videoId=c;b.index=d;c!=e&&Co(b)}return Go(a)};
Y.prototype.getPlayerContextData=Y.prototype.ta;Y.prototype.Aa=function(a){var b=new Ao(a);b.videoId&&b.videoId!=this.C.videoId&&(this.j=b.videoId,J(this.F),this.F=I(v(this.re,this),5E3));var c=[];this.C.f==b.f&&this.C.videoId==b.videoId&&this.C.index==b.index&&bb(this.C.videoIds,b.videoIds)||c.push("remoteQueueChange");this.C.h==b.h&&this.C.volume==b.volume&&this.C.o==b.o&&Eo(this.C)==Eo(b)&&M(this.C.j)==M(b.j)||c.push("remotePlayerChange");this.C.reset(a);y(c,function(a){this.D(a)},this)};
Y.prototype.setPlayerContextData=Y.prototype.Aa;Y.prototype.qa=function(){return this.f.l.loungeIdToken};
Y.prototype.getLoungeToken=Y.prototype.qa;Y.prototype.O=function(){var a=this.f.l.id,b=Qa(this.h,function(b){return"REMOTE_CONTROL"==b.type&&b.id!=a});
return b?b.id:""};
Y.prototype.getOtherConnectedRemoteId=Y.prototype.O;Y.prototype.B=function(){var a=this.f;return a.h.enabled?a.h.A-w():NaN};
Y.prototype.getReconnectTimeout=Y.prototype.B;Y.prototype.Wa=function(){if(!isNaN(this.B())){var a=this.f.h;a.enabled&&(a.stop(),a.start(),a.B())}};
Y.prototype.reconnect=Y.prototype.Wa;function Ro(a){J(a.J);a.J=I(v(a.o,a,1),864E5)}
function Oo(a,b,c){c?a.H("Sending: action="+b+", params="+M(c)):a.H("Sending: action="+b);a.f.sendMessage(b,c)}
Y.prototype.va=function(a,b){Oo(this,a,b);Ro(this)};
Y.prototype.sendMessage=Y.prototype.va;function Zo(a){V.call(this);this.o=0;this.ka=$o();this.Za=NaN;this.vb="";this.A=a;this.H("Initializing local screens: "+Pj(this.ka));this.j=ap();this.H("Initializing account screens: "+Pj(this.j));this.Jb=null;this.f=[];this.h=[];bp(this,Xl()||[]);this.H("Initializing DIAL devices: "+Wj(this.h));a=Nj(Bk());cp(this,a);this.H("Initializing online screens: "+Pj(this.f));this.o=w()+3E5;dp(this)}
x(Zo,V);var ep=[2E3,2E3,1E3,1E3,1E3,2E3,2E3,5E3,5E3,1E4];g=Zo.prototype;g.H=function(a){Ej("RM",a)};
g.M=function(a){Ej("RM",a)};
function ap(){var a=$o(),b=Nj(Bk());return Na(b,function(b){return!ek(a,b)})}
function $o(){var a=Nj(xk());return Na(a,function(a){return!a.f})}
function dp(a){xc("yt-remote-cast-device-list-update",function(){var a=Xl();bp(this,a||[])},a);
xc("yt-remote-cast-device-status-update",a.Ee,a);a.Kc();var b=w()>a.o?2E4:1E4;oc(v(a.Kc,a),b)}
g.D=function(a,b){if(this.isDisposed())return!1;this.H("Firing "+a);return this.l.D.apply(this.l,arguments)};
g.Kc=function(){var a=Xl()||[];0==a.length||bp(this,a);a=fp(this);0==a.length||(Oa(a,function(a){return!ek(this.j,a)},this)&&zk()?gp(this):hp(this,a))};
function ip(a,b){var c=fp(a);return Na(b,function(a){return a.f?(a=dk(this.h,a.f),!!a&&"RUNNING"==a.status):!!ek(c,a)},a)}
function bp(a,b){var c=!1;y(b,function(a){var b=fk(this.ka,a.id);b&&b.name!=a.name&&(this.H("Renaming screen id "+b.id+" from "+b.name+" to "+a.name),b.name=a.name,c=!0)},a);
c&&(a.H("Renaming due to DIAL."),kp(a));Ck(ak(b));var d=!bb(a.h,b,ck);d&&a.H("Updating DIAL devices: "+Wj(a.h)+" to "+Wj(b));a.h=b;cp(a,a.f);d&&a.D("onlineReceiverChange")}
g.Ee=function(a){var b=dk(this.h,a.id);b&&(this.H("Updating DIAL device: "+b.id+"("+b.name+") from status: "+b.status+" to status: "+a.status+" and from activityId: "+b.f+" to activityId: "+a.f),b.f=a.f,b.status=a.status,Ck(ak(this.h)));cp(this,this.f)};
function cp(a,b,c){var d=ip(a,b),e=!bb(a.f,d,Kj);if(e||c)0==b.length||Ak(z(d,Lj));e&&(a.H("Updating online screens: "+Pj(a.f)+" -> "+Pj(d)),a.f=d,a.D("onlineReceiverChange"))}
function hp(a,b){var c=[],d={};y(b,function(a){a.token&&(d[a.token]=a,c.push(a.token))});
var e={method:"POST",S:{lounge_token:c.join(",")},context:a,ca:function(a,b){var c=[];y(b.screens||[],function(a){"online"==a.status&&c.push(d[a.loungeToken])});
var e=this.Jb?lp(this,this.Jb):null;e&&!ek(c,e)&&c.push(e);cp(this,c,!0)}};
$d(Sj(a.A,"/pairing/get_screen_availability"),e)}
function gp(a){var b=fp(a),c=z(b,function(a){return a.id});
0!=c.length&&(a.H("Updating lounge tokens for: "+M(c)),$d(Sj(a.A,"/pairing/get_lounge_token_batch"),{S:{screen_ids:c.join(",")},method:"POST",context:a,ca:function(a,c){mp(this,c.screens||[]);this.ka=Na(this.ka,function(a){return!!a.token});
kp(this);hp(this,b)}}))}
function mp(a,b){y(Xa(a.ka,a.j),function(a){var d=Qa(b,function(b){return a.id==b.screenId});
d&&(a.token=d.loungeToken)})}
function kp(a){var b=$o();bb(a.ka,b,Kj)||(a.H("Saving local screens: "+Pj(b)+" to "+Pj(a.ka)),wk(z(a.ka,Lj)),cp(a,a.f,!0),bp(a,Xl()||[]),a.D("managedScreenChange",fp(a)))}
function np(a,b,c){var d=Ra(b,function(a){return Jj(c,a)}),e=0>d;
0>d?b.push(c):b[d]=c;ek(a.f,c)||a.f.push(c);return e}
g.pc=function(a,b){for(var c=fp(this),c=z(c,function(a){return a.name}),d=a,e=2;A(c,d);)d=b.call(m,e),e++;
return d};
g.Gc=function(a,b,c){var d=!1;b>=ep.length&&(this.H("Pairing DIAL device "+a+" with "+c+" timed out."),d=!0);var e=dk(this.h,a);if(!e)this.H("Pairing DIAL device "+a+" with "+c+" failed: no device for "+a),d=!0;else if("ERROR"==e.status||"STOPPED"==e.status)this.H("Pairing DIAL device "+a+" with "+c+" failed: launch error on "+a),d=!0;d?(op(this),this.D("screenPair",null)):$d(Sj(this.A,"/pairing/get_screen"),{method:"POST",S:{pairing_code:c},context:this,ca:function(a,b){if(c==this.vb){op(this);var d=
new Hj(b.screen);d.name=e.name;d.f=e.id;this.H("Pairing "+c+" succeeded.");var l=np(this,this.ka,d);this.H("Paired with "+(l?"a new":"an old")+" local screen:"+Oj(d));kp(this);this.D("screenPair",d)}},
onError:function(){c==this.vb&&(this.H("Polling pairing code: "+c),J(this.Za),this.Za=I(v(this.Gc,this,a,b+1,c),ep[b]))}})};
function pp(a,b,c){var d=Z,e="";op(d);if(dk(d.h,a)){if(!e){var f=e=Xj();Ql();var h=Zl(a),k=Nl();if(k&&h){var l=new cast.Receiver(h.id,h.name),l=new cast.LaunchRequest("YouTube",l);l.parameters="pairingCode="+f;l.description=new cast.LaunchDescription;l.description.text=document.title;b&&(l.parameters+="&v="+b,c&&(l.parameters+="&t="+Math.round(c)),l.description.url="http://i.ytimg.com/vi/"+b+"/default.jpg");"UNKNOWN"!=h.status&&(h.status="UNKNOWN",Vl(h),K("yt-remote-cast-device-status-update",h));
Ll("Sending a cast launch request with params: "+l.parameters);k.launch(l,pa($l,a))}else Ll("No cast API or no cast device. Dropping cast launch.")}d.vb=e;d.Za=I(v(d.Gc,d,a,0,e),ep[0])}else d.H("No DIAL device with id: "+a)}
function op(a){J(a.Za);a.Za=NaN;a.vb=""}
function lp(a,b){var c=fk(fp(a),b);a.H("Found screen: "+Oj(c)+" with key: "+b);return c}
function qp(a){var b=Z,c=fk(b.f,a);b.H("Found online screen: "+Oj(c)+" with key: "+a);return c}
function rp(a){var b=Z,c=dk(b.h,a);if(!c){var d=fk(b.ka,a);d&&(c=dk(b.h,d.f))}b.H("Found DIAL: "+(c?c.toString():"null")+" with key: "+a);return c}
function fp(a){return Xa(a.j,Na(a.ka,function(a){return!ek(this.j,a)},a))}
;function sp(a){gk.call(this,"ScreenServiceProxy");this.W=a;this.f=[];this.f.push(this.W.$_s("screenChange",v(this.Me,this)));this.f.push(this.W.$_s("onlineScreenChange",v(this.Td,this)))}
x(sp,gk);g=sp.prototype;g.$=function(a){return this.W.$_gs(a)};
g.contains=function(a){return!!this.W.$_c(a)};
g.get=function(a){return this.W.$_g(a)};
g.start=function(){this.W.$_st()};
g.Db=function(a,b,c){this.W.$_a(a,b,c)};
g.remove=function(a,b,c){this.W.$_r(a,b,c)};
g.Ab=function(a,b,c,d){this.W.$_un(a,b,c,d)};
g.G=function(){for(var a=0,b=this.f.length;a<b;++a)this.W.$_ubk(this.f[a]);this.f.length=0;this.W=null;sp.I.G.call(this)};
g.Me=function(){this.D("screenChange")};
g.Td=function(){this.D("onlineScreenChange")};
W.prototype.$_st=W.prototype.start;W.prototype.$_gspc=W.prototype.Ne;W.prototype.$_gsppc=W.prototype.Tc;W.prototype.$_c=W.prototype.contains;W.prototype.$_g=W.prototype.get;W.prototype.$_a=W.prototype.Db;W.prototype.$_un=W.prototype.Ab;W.prototype.$_r=W.prototype.remove;W.prototype.$_gs=W.prototype.$;W.prototype.$_gos=W.prototype.Sc;W.prototype.$_s=W.prototype.subscribe;W.prototype.$_ubk=W.prototype.oa;function tp(){var a=!!G("MDX_ENABLE_CASTV2"),b=!!G("MDX_ENABLE_QUEUE"),c={device:"Desktop",app:"youtube-desktop"};a?q("yt.mdx.remote.castv2_",!0,void 0):Ql();bj&&aj();ok();up||(up=new Rj,Gk()&&(up.f="/api/loungedev"));Z||a||(Z=new Zo(up),Z.subscribe("screenPair",vp),Z.subscribe("managedScreenChange",wp),Z.subscribe("onlineReceiverChange",function(){K("yt-remote-receiver-availability-change")}));
xp||(xp=r("yt.mdx.remote.deferredProxies_")||[],q("yt.mdx.remote.deferredProxies_",xp,void 0));yp(b);b=zp();if(a&&!b){var d=new W(up);q("yt.mdx.remote.screenService_",d,void 0);b=zp();pl(d,function(a){a?Ap()&&Il(Ap(),"YouTube TV"):d.subscribe("onlineScreenChange",function(){K("yt-remote-receiver-availability-change")})},!(!c||!c.loadCastApiSetupScript))}if(c&&!r("yt.mdx.remote.initialized_")){q("yt.mdx.remote.initialized_",!0,void 0);
Bp("Initializing: "+M(c));Cp.push(xc("yt-remote-cast2-availability-change",function(){K("yt-remote-receiver-availability-change")}));
Cp.push(xc("yt-remote-cast2-receiver-selected",function(){Dp(null);K("yt-remote-auto-connect","cast-selector-receiver")}));
Cp.push(xc("yt-remote-cast2-session-change",Ep));Cp.push(xc("yt-remote-connection-change",function(a){a?Il(Ap(),"YouTube TV"):Fp()||(Il(null,null),El())}));
var e=Gp();c.isAuto&&(e.id+="#dial");e.name=c.device;e.app=c.app;Bp(" -- with channel params: "+M(e));Hp(e);a&&b.start();Ap()||Ip()}}
function Jp(){zc(Cp);Cp.length=0;E(Kp);Kp=null;xp&&(y(xp,function(a){a(null)}),xp.length=0,xp=null,q("yt.mdx.remote.deferredProxies_",null,void 0));
Z&&(E(Z),Z=null);up=null;Ul()}
function Lp(){if(Mp()&&Cl()){var a=[];if(U("yt-remote-cast-available")||r("yt.mdx.remote.cloudview.castButtonShown_")||Np())a.push({key:"cast-selector-receiver",name:Op()}),q("yt.mdx.remote.cloudview.castButtonShown_",!0,void 0);return a}return r("yt.mdx.remote.cloudview.initializing_")?[]:Pp()}
function Pp(){var a=[],a=Qp()?zp().W.$_gos():Nj(Bk()),b=Rp();b&&Np()&&(ek(a,b)||a.push(b));Qp()||(b=bk(Dk()),b=Na(b,function(b){return!fk(a,b.id)}),a=Xa(a,b));
return Zj(a)}
function Sp(){if(Mp()&&Cl()){var a=Dl();return a?{key:"cast-selector-receiver",name:a}:null}return Tp()}
function Tp(){var a=Pp(),b=Up(),c=Rp();c||(c=Fp());return Qa(a,function(a){return c&&Ij(c,a.key)||b&&(a=rp(a.key))&&a.id==b?!0:!1})}
function Op(){if(Mp()&&Cl())return Dl();var a=Rp();return a?a.name:null}
function Rp(){var a=Ap();if(!a)return null;if(!Z){var b=zp().$();return fk(b,a)}return lp(Z,a)}
function Ep(a){Bp("remote.onCastSessionChange_: "+Oj(a));if(a){var b=Rp();b&&b.id==a.id?Il(b.id,"YouTube TV"):(b&&Vp(),Wp(a,1))}else Vp()}
function Xp(a,b){Bp("Connecting to: "+M(a));if("cast-selector-receiver"==a.key)Dp(b||null),Hl(b||null);else{Vp();Dp(b||null);var c=null;Z?c=qp(a.key):(c=zp().$(),c=fk(c,a.key));if(c)Wp(c,1);else{if(Z&&(c=rp(a.key))){Yp(c);return}I(function(){Zp(null)},0)}}}
function Vp(){Z&&op(Z);a:{var a=Np();if(a&&(a=a.getOtherConnectedRemoteId())){Bp("Do not stop DIAL due to "+a);$p("");break a}(a=Up())?(Bp("Stopping DIAL: "+a),am(a),$p("")):(a=Rp())&&a.f&&(Bp("Stopping DIAL: "+a.f),am(a.f))}Gl()?yl().stopSession():vl("stopSession called before API ready.");(a=Np())?a.disconnect(1):(Ac("yt-remote-before-disconnect",1),Ac("yt-remote-connection-change",!1));Zp(null)}
function Bp(a){Ej("remote",a)}
function Mp(){return!!r("yt.mdx.remote.castv2_")}
function Qp(){return r("yt.mdx.remote.screenService_")}
function zp(){if(!Kp){var a=Qp();Kp=a?new sp(a):null}return Kp}
function Ap(){return r("yt.mdx.remote.currentScreenId_")}
function aq(a){q("yt.mdx.remote.currentScreenId_",a,void 0);if(Z){var b=Z;b.o=w()+3E5;if((b.Jb=a)&&(a=lp(b,a))&&!ek(b.f,a)){var c=Ya(b.f);c.push(a);cp(b,c,!0)}}}
function Up(){return r("yt.mdx.remote.currentDialId_")}
function $p(a){q("yt.mdx.remote.currentDialId_",a,void 0)}
function bq(){return r("yt.mdx.remote.connectData_")}
function Dp(a){q("yt.mdx.remote.connectData_",a,void 0)}
function Np(){return r("yt.mdx.remote.connection_")}
function Zp(a){var b=Np();Dp(null);a?La(!Np()):(aq(""),$p(""));q("yt.mdx.remote.connection_",a,void 0);xp&&(y(xp,function(b){b(a)}),xp.length=0);
b&&!a?Ac("yt-remote-connection-change",!1):!b&&a&&K("yt-remote-connection-change",!0)}
function Fp(){var a=rk();if(!a)return null;if(Qp()){var b=zp().$();return fk(b,a)}return Z?lp(Z,a):null}
function Wp(a,b){La(!Ap());aq(a.id);var c=new Y(up,a,Gp());c.connect(b,bq());c.subscribe("beforeDisconnect",function(a){Ac("yt-remote-before-disconnect",a)});
c.subscribe("beforeDispose",function(){Np()&&(Np(),Zp(null))});
Zp(c)}
function Yp(a){Up();Bp("Connecting to: "+(a?a.toString():"null"));$p(a.id);var b=bq();b?pp(a.id,b.videoIds[b.index],b.currentTime):pp(a.id)}
function Ip(){var a=Fp();a?(Bp("Resume connection to: "+Oj(a)),Wp(a,0)):(Fk(),El(),Bp("Skipping connecting because no session screen found."))}
function vp(a){Bp("Paired with: "+Oj(a));a?Wp(a,1):Zp(null)}
function wp(){var a=Ap();a&&!Rp()&&(Bp("Dropping current screen with id: "+a),Vp());Fp()||Fk()}
var up=null,xp=null,Kp=null,Z=null;function yp(a){var b=Gp();if(qb(b)){var b=qk(),c=U("yt-remote-session-name")||"",d=U("yt-remote-session-app")||"",b={device:"REMOTE_CONTROL",id:b,name:c,app:d};a&&(b["mdx-version"]=3);q("yt.mdx.remote.channelParams_",b,void 0)}}
function Gp(){return r("yt.mdx.remote.channelParams_")||{}}
function Hp(a){a?(T("yt-remote-session-app",a.app),T("yt-remote-session-name",a.name)):(dj("yt-remote-session-app"),dj("yt-remote-session-name"));q("yt.mdx.remote.channelParams_",a,void 0)}
var Cp=[];var cq=null,dq=[];function eq(){fq();if(Sp()){var a=cq;"html5"!=a.getPlayerType()&&a.loadNewVideoConfig(a.getCurrentVideoConfig(),"html5")}}
function gq(a){"cast-selector-receiver"==a?Fl():hq(a)}
function hq(a){var b=Lp();if(a=Yj(b,a)){var c=cq,d=c.getVideoData().video_id,e=c.getVideoData().list,f=c.getCurrentTime();Xp(a,{videoIds:[d],listId:e,videoId:d,index:0,currentTime:f});"html5"!=c.getPlayerType()?c.loadNewVideoConfig(c.getCurrentVideoConfig(),"html5"):c.updateRemoteReceivers&&c.updateRemoteReceivers(b,a)}}
function fq(){var a=cq;a&&a.updateRemoteReceivers&&a.updateRemoteReceivers(Lp(),Sp())}
;var iq=null,jq=[];function kq(a){return{externalChannelId:a.externalChannelId,Fd:!!a.isChannelPaid,source:a.source,subscriptionId:a.subscriptionId}}
function lq(a){mq(kq(a))}
function mq(a){oi()?(R(bi,new Wh(a.externalChannelId,a.Fd?{itemType:"U",itemId:a.externalChannelId}:null)),(a="/gen_204?"+Od({event:"subscribe",source:a.source}))&&Rg(a)):nq(a)}
function nq(a){ni(function(b){b.subscription_ajax&&mq(a)},null)}
function oq(a){a=kq(a);R(gi,new Yh(a.externalChannelId,a.subscriptionId,null));(a="/gen_204?"+Od({event:"unsubscribe",source:a.source}))&&Rg(a)}
function pq(a){iq&&iq.channelSubscribed(a.f,a.subscriptionId)}
function qq(a){iq&&iq.channelUnsubscribed(a.f)}
;function rq(a){D.call(this);this.h=a;this.h.subscribe("command",this.Jc,this);this.j={};this.l=!1}
x(rq,D);g=rq.prototype;g.start=function(){this.l||this.isDisposed()||(this.l=!0,sq(this.h,"RECEIVING"))};
g.Jc=function(a,b){if(this.l&&!this.isDisposed()){var c=b||{};switch(a){case "addEventListener":if(u(c.event)&&(c=c.event,!(c in this.j))){var d=v(this.te,this,c);this.j[c]=d;this.addEventListener(c,d)}break;case "removeEventListener":u(c.event)&&tq(this,c.event);break;default:this.f.isReady()&&this.f[a]&&(c=uq(a,b||{}),c=this.f[a].apply(this.f,c),(c=vq(a,c))&&this.l&&!this.isDisposed()&&sq(this.h,a,c))}}};
g.te=function(a,b){this.l&&!this.isDisposed()&&sq(this.h,a,this.Lb(a,b))};
g.Lb=function(a,b){if(null!=b)return{value:b}};
function tq(a,b){b in a.j&&(a.removeEventListener(b,a.j[b]),delete a.j[b])}
g.G=function(){this.h.unsubscribe("command",this.Jc,this);this.h=null;for(var a in this.j)tq(this,a);rq.I.G.call(this)};function wq(a,b){rq.call(this,b);this.f=a;this.start()}
x(wq,rq);wq.prototype.addEventListener=function(a,b){this.f.addEventListener(a,b)};
wq.prototype.removeEventListener=function(a,b){this.f.removeEventListener(a,b)};
function uq(a,b){switch(a){case "loadVideoById":return b=ij(b),kj(b),[b];case "cueVideoById":return b=ij(b),kj(b),[b];case "loadVideoByPlayerVars":return kj(b),[b];case "cueVideoByPlayerVars":return kj(b),[b];case "loadPlaylist":return b=jj(b),kj(b),[b];case "cuePlaylist":return b=jj(b),kj(b),[b];case "seekTo":return[b.seconds,b.allowSeekAhead];case "playVideoAt":return[b.index];case "setVolume":return[b.volume];case "setPlaybackQuality":return[b.suggestedQuality];case "setPlaybackRate":return[b.suggestedRate];
case "setLoop":return[b.loopPlaylists];case "setShuffle":return[b.shufflePlaylist];case "getOptions":return[b.module];case "getOption":return[b.module,b.option];case "setOption":return[b.module,b.option,b.value];case "handleGlobalKeyDown":return[b.keyCode,b.shiftKey]}return[]}
function vq(a,b){switch(a){case "isMuted":return{muted:b};case "getVolume":return{volume:b};case "getPlaybackRate":return{playbackRate:b};case "getAvailablePlaybackRates":return{availablePlaybackRates:b};case "getVideoLoadedFraction":return{videoLoadedFraction:b};case "getPlayerState":return{playerState:b};case "getCurrentTime":return{currentTime:b};case "getPlaybackQuality":return{playbackQuality:b};case "getAvailableQualityLevels":return{availableQualityLevels:b};case "getDuration":return{duration:b};
case "getVideoUrl":return{videoUrl:b};case "getVideoEmbedCode":return{videoEmbedCode:b};case "getPlaylist":return{playlist:b};case "getPlaylistIndex":return{playlistIndex:b};case "getOptions":return{options:b};case "getOption":return{option:b}}}
wq.prototype.Lb=function(a,b){switch(a){case "onReady":return;case "onStateChange":return{playerState:b};case "onPlaybackQualityChange":return{playbackQuality:b};case "onPlaybackRateChange":return{playbackRate:b};case "onError":return{errorCode:b}}return wq.I.Lb.call(this,a,b)};
wq.prototype.G=function(){wq.I.G.call(this);delete this.f};function xq(){var a=this.h=new Mi,b=v(this.pe,this);a.h=b;a.j=null;this.l=[];this.B=!1;this.o=(a=G("POST_MESSAGE_ORIGIN",void 0))&&Mg(a)?a:null;this.A={}}
g=xq.prototype;g.pe=function(a,b){if(this.o&&this.o!=this.h.origin)this.dispose();else if("addEventListener"==a&&b){var c=b[0];this.A[c]||"onReady"==c||(this.addEventListener(c,yq(this,c)),this.A[c]=!0)}else this.Wc(a,b)};
g.Wc=function(){};
function yq(a,b){return v(function(a){this.sendMessage(b,a)},a)}
g.addEventListener=function(){};
g.sd=function(){this.B=!0;this.sendMessage("initialDelivery",this.Mb());this.sendMessage("onReady");y(this.l,this.Xc,this);this.l=[]};
g.Mb=function(){return null};
function zq(a,b){a.sendMessage("infoDelivery",b)}
g.Xc=function(a){this.B?this.h.sendMessage(a):this.l.push(a)};
g.sendMessage=function(a,b){this.Xc({event:a,info:void 0==b?null:b})};
g.dispose=function(){this.h=null};function Aq(a){xq.call(this);this.f=a;this.j=[];this.addEventListener("onReady",v(this.Yd,this));this.addEventListener("onVideoProgress",v(this.xe,this));this.addEventListener("onVolumeChange",v(this.ye,this));this.addEventListener("onApiChange",v(this.se,this));this.addEventListener("onPlaybackQualityChange",v(this.ue,this));this.addEventListener("onPlaybackRateChange",v(this.ve,this));this.addEventListener("onStateChange",v(this.we,this))}
x(Aq,xq);g=Aq.prototype;g.Wc=function(a,b){if(this.f[a]){b=b||[];if(0<b.length&&gj(a)){var c;c=b;if(ia(c[0])&&!ea(c[0]))c=c[0];else{var d={};switch(a){case "loadVideoById":case "cueVideoById":d=ij.apply(window,c);break;case "loadVideoByUrl":case "cueVideoByUrl":d=hj.apply(window,c);break;case "loadPlaylist":case "cuePlaylist":d=jj.apply(window,c)}c=d}kj(c);b.length=1;b[0]=c}this.f[a].apply(this.f,b);gj(a)&&zq(this,this.Mb())}};
g.Yd=function(){var a=v(this.sd,this);this.h.f=a};
g.addEventListener=function(a,b){this.j.push({qd:a,listener:b});this.f.addEventListener(a,b)};
g.Mb=function(){if(!this.f)return null;var a=this.f.getApiInterface();Va(a,"getVideoData");for(var b={apiInterface:a},c=0,d=a.length;c<d;c++){var e=a[c],f=e;if(0==f.search("get")||0==f.search("is")){var f=e,h=0;0==f.search("get")?h=3:0==f.search("is")&&(h=2);f=f.charAt(h).toLowerCase()+f.substr(h+1);try{var k=this.f[e]();b[f]=k}catch(l){}}}b.videoData=this.f.getVideoData();return b};
g.we=function(a){a={playerState:a,currentTime:this.f.getCurrentTime(),duration:this.f.getDuration(),videoData:this.f.getVideoData(),videoStartBytes:0,videoBytesTotal:this.f.getVideoBytesTotal(),videoLoadedFraction:this.f.getVideoLoadedFraction(),playbackQuality:this.f.getPlaybackQuality(),availableQualityLevels:this.f.getAvailableQualityLevels(),videoUrl:this.f.getVideoUrl(),playlist:this.f.getPlaylist(),playlistIndex:this.f.getPlaylistIndex()};this.f.getProgressState&&(a.progressState=this.f.getProgressState());
this.f.getStoryboardFormat&&(a.storyboardFormat=this.f.getStoryboardFormat());zq(this,a)};
g.ue=function(a){zq(this,{playbackQuality:a})};
g.ve=function(a){zq(this,{playbackRate:a})};
g.se=function(){for(var a=this.f.getOptions(),b={namespaces:a},c=0,d=a.length;c<d;c++){var e=a[c],f=this.f.getOptions(e);b[e]={options:f};for(var h=0,k=f.length;h<k;h++){var l=f[h],n=this.f.getOption(e,l);b[e][l]=n}}this.sendMessage("apiInfoDelivery",b)};
g.ye=function(){zq(this,{muted:this.f.isMuted(),volume:this.f.getVolume()})};
g.xe=function(a){a={currentTime:a,videoBytesLoaded:this.f.getVideoBytesLoaded(),videoLoadedFraction:this.f.getVideoLoadedFraction()};this.f.getProgressState&&(a.progressState=this.f.getProgressState());zq(this,a)};
g.dispose=function(){Aq.I.dispose.call(this);for(var a=0;a<this.j.length;a++){var b=this.j[a];this.f.removeEventListener(b.qd,b.listener)}this.j=[]};function Bq(a,b,c){V.call(this);this.f=a;this.h=b;this.j=c}
x(Bq,V);function sq(a,b,c){if(!a.isDisposed()){var d=a.f,e=a.h;a=a.j;d.isDisposed()||e!=d.f||(b={id:a,command:b},c&&(b.data=c),d.f.postMessage(M(b),d.j))}}
Bq.prototype.G=function(){this.h=this.f=null;Bq.I.G.call(this)};function Cq(a,b,c){D.call(this);this.f=a;this.j=c;this.l=N(window,"message",v(this.o,this));this.h=new Bq(this,a,b);gc(this,pa(E,this.h))}
x(Cq,D);Cq.prototype.o=function(a){var b;if(b=!this.isDisposed())if(b=a.origin==this.j)a:{b=this.f;do{var c;b:{c=a.source;do{if(c==b){c=!0;break b}if(c==c.parent)break;c=c.parent}while(null!=c);c=!1}if(c){b=!0;break a}b=b.opener}while(null!=b);b=!1}if(b&&(c=a.data,u(c))){try{c=zd(c)}catch(d){return}c.command&&(a=this.h,b=c.command,c=c.data,a.isDisposed()||a.D("command",b,c))}};
Cq.prototype.G=function(){We(this.l);this.f=null;Cq.I.G.call(this)};var Dq=!1;function Eq(a){if(a=a.match(/[\d]+/g))a.length=3,a.join(".")}
(function(){if(navigator.plugins&&navigator.plugins.length){var a=navigator.plugins["Shockwave Flash"];if(a&&(Dq=!0,a.description)){Eq(a.description);return}if(navigator.plugins["Shockwave Flash 2.0"]){Dq=!0;return}}if(navigator.mimeTypes&&navigator.mimeTypes.length&&(a=navigator.mimeTypes["application/x-shockwave-flash"],Dq=!!a&&a.enabledPlugin)){Eq(a.enabledPlugin.description);return}try{var b=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");Dq=!0;Eq(b.GetVariable("$version"));return}catch(c){}try{b=
new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");Dq=!0;return}catch(c){}try{b=new ActiveXObject("ShockwaveFlash.ShockwaveFlash"),Dq=!0,Eq(b.GetVariable("$version"))}catch(c){}})();function Fq(a){return(a=a.exec(xb))?a[1]:""}
(function(){if(Af)return Fq(/Firefox\/([0-9.]+)/);if(L||jd||id)return td;if(Ef)return Fq(/Chrome\/([0-9.]+)/);if(Ff&&!(hd()||B("iPad")||B("iPod")))return Fq(/Version\/([0-9.]+)/);if(Bf||Cf){var a;if(a=/Version\/(\S+).*Mobile\/(\S+)/.exec(xb))return a[1]+"."+a[2]}else if(Df)return(a=Fq(/Android\s+([0-9.]+)/))?a:Fq(/Version\/([0-9.]+)/);return""})();function Gq(){var a={format:"RAW",method:"GET",timeout:5E3,withCredentials:!0};return new Jm(function(b,c){a.ca=function(a){Vd(a)?b(a):c(a)};
a.onError=c;a.gb=c;$d("//googleads.g.doubleclick.net/pagead/id",a)})}
;var Hq=null;function Iq(a){a=a.responseText;if(0!=a.lastIndexOf(")]}'",0))return Jq(""),"";a=JSON.parse(a.substr(4)).id;Jq(a);return a}
function Kq(){I(function(){Hq=null},3E5)}
function Jq(a){q("yt.www.ads.biscotti.lastId_",a,void 0)}
;function Lq(){}
;function Mq(a){for(var b=0;b<a.length;b++){var c=a[b];"send_follow_on_ping_action"==c.name&&c.data&&c.data.follow_on_url&&(c=c.data.follow_on_url)&&Rg(c)}}
;function Nq(a){P.call(this,1,arguments);this.Hb=a}
x(Nq,P);function Oq(a,b){P.call(this,2,arguments);this.h=a;this.f=b}
x(Oq,P);function Pq(a,b,c,d){P.call(this,1,arguments);this.f=b;this.j=c||null;this.h=d||null}
x(Pq,P);function Qq(a,b){P.call(this,1,arguments);this.h=a;this.f=b||null}
x(Qq,P);function Rq(a){P.call(this,1,arguments)}
x(Rq,P);var Sq=new Q("ypc-core-load",Nq),Tq=new Q("ypc-guide-sync-success",Oq),Uq=new Q("ypc-purchase-success",Pq),Vq=new Q("ypc-subscription-cancel",Rq),Wq=new Q("ypc-subscription-cancel-success",Qq),Xq=new Q("ypc-init-subscription",Rq);var Yq=!1,Zq=[],$q=[];function ar(a){a.f?Yq?R(fi,a):R(Sq,new Nq(function(){R(Xq,new Rq(a.f))})):br(a.h,a.l,a.j,a.source)}
function cr(a){a.f?Yq?R(ki,a):R(Sq,new Nq(function(){R(Vq,new Rq(a.f))})):dr(a.h,a.subscriptionId,a.l,a.j,a.source)}
function er(a){fr(Ya(a.f))}
function gr(a){hr(Ya(a.f))}
function ir(a){jr(a.f,a.isEnabled,null)}
function kr(a,b,c,d){jr(a,b,c,d)}
function lr(a){var b=a.h,c=a.f.subscriptionId;b&&c&&R(ei,new Xh(b,c,a.f.channelInfo))}
function mr(a){var b=a.f;eb(a.h,function(a,d){R(ei,new Xh(d,a,b[d]))})}
function nr(a){R(ji,new Uh(a.h.itemId));a.f&&a.f.length&&(or(a.f,ji),or(a.f,li))}
function br(a,b,c,d){var e=new Uh(a);R(ci,e);var f={};f.c=a;c&&(f.eurl=c);d&&(f.source=d);c={};(d=G("PLAYBACK_ID"))&&(c.plid=d);(d=G("EVENT_ID"))&&(c.ei=d);b&&pr(b,c);$d("/subscription_ajax?action_create_subscription_to_channel=1",{method:"POST",$b:f,S:c,ca:function(b,c){var d=c.response;R(ei,new Xh(a,d.id,d.channel_info));d.show_feed_privacy_dialog&&K("SHOW-FEED-PRIVACY-SUBSCRIBE-DIALOG",a);d.actions&&Mq(d.actions)},
Wb:function(){R(di,e)}})}
function dr(a,b,c,d,e){var f=new Uh(a);R(hi,f);var h={};d&&(h.eurl=d);e&&(h.source=e);d={};d.c=a;d.s=b;(a=G("PLAYBACK_ID"))&&(d.plid=a);(a=G("EVENT_ID"))&&(d.ei=a);c&&pr(c,d);$d("/subscription_ajax?action_remove_subscriptions=1",{method:"POST",$b:h,S:d,ca:function(a,b){var c=b.response;R(ji,f);c.actions&&Mq(c.actions)},
Wb:function(){R(ii,f)}})}
function jr(a,b,c,d){if(null!==b||null!==c){var e={};a&&(e.channel_id=a);null===b||(e.email_on_upload=b);null===c||(e.receive_no_updates=c);$d("/subscription_ajax?action_update_subscription_preferences=1",{method:"POST",S:e,onError:function(){d&&d()}})}}
function fr(a){if(a.length){var b=$a(a,0,40);R("subscription-batch-subscribe-loading");or(b,ci);var c={};c.a=b.join(",");var d=function(){R("subscription-batch-subscribe-loaded");or(b,di)};
$d("/subscription_ajax?action_create_subscription_to_all=1",{method:"POST",S:c,ca:function(c,f){d();var h=f.response,k=h.id;if(ea(k)&&k.length==b.length){var l=h.channel_info_map;y(k,function(a,c){var d=b[c];R(ei,new Xh(d,a,l[d]))});
a.length?fr(a):R("subscription-batch-subscribe-finished")}},
onError:function(){d();R("subscription-batch-subscribe-failure")}})}}
function hr(a){if(a.length){var b=$a(a,0,40);R("subscription-batch-unsubscribe-loading");or(b,hi);var c={};c.c=b.join(",");var d=function(){R("subscription-batch-unsubscribe-loaded");or(b,ii)};
$d("/subscription_ajax?action_remove_subscriptions=1",{method:"POST",S:c,ca:function(){d();or(b,ji);a.length&&hr(a)},
onError:function(){d()}})}}
function or(a,b){y(a,function(a){R(b,new Uh(a))})}
function pr(a,b){var c=Rd(a),d;for(d in c)b[d]=c[d]}
;var qr,rr=null,sr=null,tr=null,ur=!1;
function vr(){var a=G("PLAYER_CONFIG",void 0),b=G("REVERSE_MOBIUS_PERCENT",void 0);if(hg&&"1"!=a.privembed&&100*Math.random()<b)try{var c;try{var d=r("yt.www.ads.biscotti.getId_"),e;if(d)e=d();else{if(!Hq){var f=Gq().then(Iq),h=Nm(Kq,Kq,void 0);h.j=!0;Um(f,h);Hq=f}e=Hq}c=e}catch(k){c=Om(k)}Pm(c,null,Lq,void 0)}catch(k){pc(k)}if(G("REQUEST_POST_MESSAGE_ORIGIN")){if(!qr){qr=new Mi;qr.f=vr;return}qr.origin&&"*"!=qr.origin&&(a.args.post_message_origin=qr.origin)}d=document.referrer;b=G("POST_MESSAGE_ORIGIN");
c=!1;u(d)&&u(b)&&-1<d.indexOf(b)&&Mg(b)&&Mg(d)&&(c=!0);window!=window.top&&d&&d!=document.URL&&(a.args.loaderUrl=d);G("LIGHTWEIGHT_AUTOPLAY")&&(a.args.autoplay="1");a.args.autoplay&&kj(a.args);rr=Hh("player",a);d=G("POST_MESSAGE_ID","player");G("ENABLE_JS_API")?tr=new Aq(rr):G("ENABLE_POST_API")&&u(d)&&u(b)&&(sr=new Cq(window.parent,d,b),tr=new wq(rr,sr.h));(ur=c&&!G("ENABLE_CAST_API"))?a.args.disableCast="1":(a=rr,tp(),cq=a,cq.addEventListener("onReady",eq),cq.addEventListener("onRemoteReceiverSelected",
gq),dq.push(xc("yt-remote-receiver-availability-change",fq)),dq.push(xc("yt-remote-auto-connect",hq)));G("BG_P")&&(G("BG_I")||G("BG_IU"))&&Mc();ke();iq=rr;iq.addEventListener("SUBSCRIBE",lq);iq.addEventListener("UNSUBSCRIBE",oq);jq.push(Zg(ei,pq),Zg(ji,qq))}
;q("yt.setConfig",lc,void 0);q("yt.setMsg",function(a){mc(kc,arguments)},void 0);
q("yt.logging.errors.log",function(a,b,c,d){if(a&&window&&window.yterr&&!(5<=fe)){var e=a.stacktrace,f=a.columnNumber;var h=r("window.location.href");if(u(a))a={message:a,name:"Unknown error",lineNumber:"Not available",fileName:h,stack:"Not available"};else{var k,l,n=!1;try{k=a.lineNumber||a.line||"Not available"}catch(H){k="Not available",n=!0}try{l=a.fileName||a.filename||a.sourceURL||m.$googDebugFname||h}catch(H){l="Not available",n=!0}a=!n&&a.lineNumber&&a.fileName&&a.stack&&a.message&&a.name?
a:{message:a.message||"Not available",name:a.name||"UnknownError",lineNumber:k,fileName:l,stack:a.stack||"Not available"}}e=e||a.stack;d=d||G("INNERTUBE_CONTEXT_CLIENT_VERSION",void 0);k=a.lineNumber.toString();isNaN(k)||isNaN(f)||(k=k+":"+f);ee[a.message]||0<=e.indexOf("/YouTubeCenter.js")||0<=e.indexOf("/mytube.js")||(b={$b:{a:"logerror",t:"jserror",type:a.name,msg:a.message.substr(0,1E3),line:k,level:b||"ERROR"},S:{url:G("PAGE_NAME",window.location.href),file:a.fileName,"client.name":c||"WEB"},
method:"POST"},e&&(b.S.stack=e),d&&(b.S["client.version"]=d),$d("/error_204",b),ee[a.message]=!0,fe++)}},void 0);
q("writeEmbed",vr,void 0);q("yt.www.watch.ads.restrictioncookie.spr",function(a){(a=a+"mac_204?action_fcts=1")&&Rg(a);return!0},void 0);
var wr=nc(function(){eh("ol");Yq=!0;$q.push(Zg(bi,ar),Zg(gi,cr));Yq||($q.push(Zg(fi,ar),Zg(ki,cr),Zg(Zh,er),Zg($h,gr),Zg(ai,ir)),Zq.push(xc("subscription-prefs",kr)),$q.push(Zg(Uq,lr),Zg(Wq,nr),Zg(Tq,mr)));Gf.getInstance();var a=1<window.devicePixelRatio;if(Lf(0,119)!=a){var b="f"+(Math.floor(119/31)+1),c=Kf(b)||0,c=a?c|67108864:c&-67108865;0==c?delete Hf[b]:(a=c.toString(16),Hf[b]=a.toString());var d,b=[];for(d in Hf)b.push(d+"="+escape(Hf[d]));d=b.join("&");ff("PREF",d,63072E3)}}),xr=nc(function(){var a=
rr;
a&&a.sendAbandonmentPing&&a.sendAbandonmentPing();G("PL_ATT")&&(Lc=null);for(var a=0,b=ie.length;a<b;a++){var c=ie[a];if(!isNaN(c)){var d=r("yt.scheduler.instance.cancelJob");d?d(c):J(c)}}ie.length=0;a=Hc("//static.doubleclick.net/instream/ad_status.js");if(b=document.getElementById(a))Cc(a),b.parentNode.removeChild(b);je=!1;lc("DCLKSTAT",0);zc(Zq);Zq.length=0;$g($q);$q.length=0;Yq=!1;iq&&(iq.removeEventListener("SUBSCRIBE",mq),iq.removeEventListener("UNSUBSCRIBE",oq));iq=null;$g(jq);jq.length=0;
ur||(zc(dq),dq.length=0,cq&&(cq.removeEventListener("onRemoteReceiverSelected",gq),cq.removeEventListener("onReady",eq),cq=null),Jp());hc(tr,sr);rr&&rr.destroy()});
window.addEventListener?(window.addEventListener("load",wr),window.addEventListener("unload",xr)):window.attachEvent&&(window.attachEvent("onload",wr),window.attachEvent("onunload",xr));var yr=Gi.getInstance(),zr=ui(yr);zr in Li||(yr.register(),yr.Ic.push(xc("yt-uix-init-"+zr,yr.init,yr)),yr.Ic.push(xc("yt-uix-dispose-"+zr,yr.dispose,yr)),Li[zr]=yr);})();
