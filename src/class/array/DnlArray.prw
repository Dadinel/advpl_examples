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
Método construtor da classe

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

@param xValue Valor que será inserido no array

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
Adiciona um valor no array na posição indicada

@param xValue Valor que será inserido no array
@param nPos Posição que o valor será inserido

@return lRet Indica se a inserção foi efetuada

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
	// O método acima contém a lógica abaixo
	// self:add(nil)
	// AIns(self:aArray, nPos)
	// self:aArray[nPos] := xValue
else
	lRet := .T.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} delPos
Remove um item do array conforme posição

@param nPos Posição que o valor será removido

@return lRet Indica se a deleção foi efetuada

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

@param xValue Valor que será removido

@return lRet Indica se a deleção foi efetuada

@obs O primeiro valor encontrado será removido

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

@return Númerico - Tamanho do array

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

@param xValue Valor que será pesquisado

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
Retorna a posição do valor informado

@param xValue Valor que será pesquisado

@return nPos Posição que o valor foi encontrado

@author Dan M
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method indexOf(xValue) class DnlArray
return getPosition(self:aArray, xValue)

//-------------------------------------------------------------------
/*/{Protheus.doc} getPosition
Função auxiliar que retorna a posição de um valor no array

@param aArray Array que será utilizada na pesquisa de valores
@param xValue Valor que será pesquisado

@return nPos Posição que o valor foi encontrado

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
Retorna o valor do array na posição indicada

@param nPos Posição de retorno do array

@return xValue Valor na posição encontrada

@obs Retorna nul em caso de posição inválida

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
Retorna uma cópia do array

@return Array - Cópia do array

@obs Retorna uma cópia para evitar problemas de referência

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
Efetua a limpeza do array e o free da instância da classe

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
