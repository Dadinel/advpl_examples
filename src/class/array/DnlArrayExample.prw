#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlArrExp
Função para teste da classe DnlArray, que simula um arraylist

@author Dan M
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function DnlArrExp()
local oArray as object
local nI as numeric

oArray := DnlArray():New()

oArray:add(10)
oArray:add(20)
oArray:add(30)
oArray:add(40)
oArray:add(50)
oArray:add(70)

oArray:insertPos(60, 6)

ConOut("Tamanho: ", oArray:size())
ConOut("Posicao 6: ", oArray:get(6))

for nI := 1 to oArray:size()
	ConOut("[" + cValToChar(nI) + "] : " + cValToChar(oArray:get(nI)))
next

ConOut("Existe o valor 70?", oArray:contains(70))
ConOut("Existe o valor 90?", oArray:contains(90))
ConOut("Qual a posicao do valor 50?", oArray:indexOf(50))

ConOut("Array limpo")

oArray:clear()

ConOut("Tamanho: ", oArray:size())

oArray:destroy()

return nil
