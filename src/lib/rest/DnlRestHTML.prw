#include "protheus.ch"
#include "restful.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlRestHTML
API que retorna uma página HTML

@author Daniel Mendes
@since 22/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsrestful DnlRestHTML description "REST para retorna de um HTML =]"

wsmethod get description "Retorna um página HTML" wssyntax "dnlresthtml/v1" path "dnlresthtml/v1" produces TEXT_HTML
wsmethod get redirect description "Retorna um página HTML via redirect" wssyntax "dnlresthtml/v2" path "dnlresthtml/v2"

end wsrestful

//-------------------------------------------------------------------
/*/{Protheus.doc} get
Método GET, retorna uma página HTML

@author Daniel Mendes
@since 22/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod get wsservice DnlRestHTML
local cHTML as char

//Página gerada com base nesse exemplo
//https://code.sololearn.com/W1i1QczvgO7U/#html

begincontent var cHTML
<!DOCTYPE html>
<html>
<head>
	<title>Hello World Animate</title>
	<style type="text/css">

        #target {
            text-align: center;
            margin-top: 10%;
        }
		 h1.elm {
			margin: 0;
			padding: 0;
			width: 40px;
             display: inline;
             position: relative;
             -webkit-perspective: 10pc;
             perspective: 10pc;
		}

         .anim{
             animation-name: entry;
             animation-duration: 1235ms;
         }

         @keyframes entry {
             0% {
                 top: 200px;
                 opacity: 0.1;
             }

             20% {
                 opacity: 0.2;
                 top: 180px;
             }

             30% {
                 top: 150px;
                 opacity: 0.4;
             }

             55% {
                 opacity: 0.6;
                 top: 140px;
             }

             60% {
                 top: 130px;
                 opacity: 0.65;

             }
             65% {
                 top: 120px;
                 opacity: 0.80;

             }

             68% {
                 top: 110px;
                 opacity: 0.85;

             }

             70% {
                 top: 100px;opacity: 0.95;
             }

             80% {
                 top: 90px;opacity: 1;

             }

             85% {
                 top: 70px;
             }

             94% {
                 top: 50px;
             }

             97% {
                 top: 20px;
             }

             100% {
                 top: 0;
             }
         }

         @keyframes flash {
             0% {opacity: 1}
             50% {opacity: 0; font-size: 3em}
             75% {
                 opacity: 1;
             }
             100% {
                 opacity: 0.4;
                 font-size: 1em
             }
         }

         .anim_loop {
             animation-name: flash;
             animation-duration: 1200ms;
             animation-iteration-count: infinite;
         }

        .space {
            width: 20px;
            display: inline-block;
        }
	</style>
</head>
<body>
	<div id="target">
		<h1 class="elm">H</h1>
		<h1 class="elm">E</h1>
		<h1 class="elm">LL</h1>
		<h1 class="elm">O</h1>
        <div class="space"></div>
		<h1 class="elm">W</h1>
		<h1 class="elm">O</h1>
		<h1 class="elm">R</h1>
		<h1 class="elm">L</h1>
		<h1 class="elm">D</h1>

	</div>

    <script type="text/javascript">
        var elm = document.getElementById('target');
        var index = 0;

        function permanentEffect(){
            setTimeout(function(){
                index = 0;
                for (var i = 1; i <= elm.children.length; i++) {
                    setTimeout(function(){
                        elm.children[index++].classList.add('anim_loop');
                    },i*100);
                }
            },1200);
        }

        for (var i = 1; i <= elm.children.length; i++) {
            setTimeout(function(){
                elm.children[index++].classList.add('anim');
                if(index===9)
                    permanentEffect();
            }, i*160);
        }
    </script>
</body>
</html>
endcontent

self:setResponse(cHTML)
self:setStatus(200)

return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} get
Método GET, retorna uma página HTML

@author Daniel Mendes
@since 22/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod get redirect wsservice DnlRestHTML
self:setStatus(301)
self:setHeader("Location", "https://devforum.totvs.com.br")
return .T.