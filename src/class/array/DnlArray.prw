#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlArray
Classe similar a um arraylist

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class DnlArray from longnameclass
	private data aArray as array
	private data nSize as numeric

	method new() constructor
	method add(xValue)
	method insertPos(xValue, nPos)
	method delPos(nPos)
	method delValue(xValue)
	method size()
	method contains(xValue)
	method indexOf(xValue)
    method get(nPos)
	method getArray()
	method clear()
    method destroy()
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
M�todo construtor da classe

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class DnlArray
self:aArray := Array(0)
self:nSize := 0
return self

//-------------------------------------------------------------------
/*/{Protheus.doc} add
Adiciona um valor no final do array

@param xValue Valor que ser� inserido no array

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method add(xValue) class DnlArray
aAdd(self:aArray, xValue)
self:nSize++
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} insertPos
Adiciona um valor no array na posi��o indicada

@param xValue Valor que ser� inserido no array
@param nPos Posi��o que o valor ser� inserido

@return lRet Indica se a inser��o foi efetuada

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method insertPos(xValue, nPos) class DnlArray
local lRet as logical

if nPos >= self:nSize
    self:nSize++
    DnlArrayUtils():insertIntoArrayPosition(self:aArray, xValue, nPos)
	// O m�todo acima cont�m a l�gica abaixo
	// self:add(nil)
	// AIns(self:aArray, nPos)
	// self:aArray[nPos] := xValue
else
	lRet := .T.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} delPos
Remove um item do array conforme posi��o

@param nPos Posi��o que o valor ser� removido

@return lRet Indica se a dele��o foi efetuada

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method delPos(nPos) class DnlArray
local lRet as logical

if self:nSize >= nPos .And. nPos > 0
	self:nSize--

	aDel(self:aArray, nPos)
	aSize(self:aArray, self:nSize)

	lRet := .T.
else
	lRet := .F.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} delValue
Remove um item do array conforme o valor enviado

@param xValue Valor que ser� removido

@return lRet Indica se a dele��o foi efetuada

@obs O primeiro valor encontrado ser� removido

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method delValue(xValue) class DnlArray
local lRet as logical
local nPos as numeric

nPos := getPosition(self:aArray, xValue)

if nPos > 0
	lRet := self:delPos(nPos)
else
	lRet := .F.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} size
Retorna o tamanho do array

@return N�merico - Tamanho do array

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method size() class DnlArray
return self:nSize

//-------------------------------------------------------------------
/*/{Protheus.doc} contains
Retorna se o valor informado existe no array

@param xValue Valor que ser� pesquisado

@return lExist Indica se o valor existe no array

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method contains(xValue) class DnlArray
local lExist as logical

if self:nSize > 0
	lExist := getPosition(self:aArray, xValue) > 0
else
	lExist := .F.
endif

return lExist

//-------------------------------------------------------------------
/*/{Protheus.doc} indexOf
Retorna a posi��o do valor informado

@param xValue Valor que ser� pesquisado

@return nPos Posi��o que o valor foi encontrado

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method indexOf(xValue) class DnlArray
return getPosition(self:aArray, xValue)

//-------------------------------------------------------------------
/*/{Protheus.doc} getPosition
Fun��o auxiliar que retorna a posi��o de um valor no array

@param aArray Array que ser� utilizada na pesquisa de valores
@param xValue Valor que ser� pesquisado

@return nPos Posi��o que o valor foi encontrado

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getPosition(aArray, xValue)
local cType as char
local nPos as numeric

cType := ValType(xValue)

nPos := aScan(aArray, {|xVlr| ValType(xVlr) == cType .And. xVlr == xValue})

return nPos

//-------------------------------------------------------------------
/*/{Protheus.doc} get
Retorna o valor do array na posi��o indicada

@param nPos Posi��o de retorno do array

@return xValue Valor na posi��o encontrada

@obs Retorna nul em caso de posi��o inv�lida

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method get(nPos) class DnlArray
local xValue

if self:nSize >= nPos
    xValue := self:aArray[nPos]
endif

return xValue

//-------------------------------------------------------------------
/*/{Protheus.doc} getArray
Retorna uma c�pia do array

@return Array - C�pia do array

@obs Retorna uma c�pia para evitar problemas de refer�ncia

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getArray() class DnlArray
return aClone(self:aArray)

//-------------------------------------------------------------------
/*/{Protheus.doc} clear
Efetua a limpeza do array

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method clear() class DnlArray
aSize(self:aArray, 0)
self:nSize := 0
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Efetua a limpeza do array e o free da inst�ncia da classe

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class DnlArray
self:clear()
self:aArray := nil
freeObj(self)
return nil
