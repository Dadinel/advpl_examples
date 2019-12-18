#include "protheus.ch"

//Alias que será utilizado para a criação do browse de tabela temporária
//O mesmo é uma constante para facilitar a troca e testes
#define C_ALIAS_TEST "SE1"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlTmpBrw
Exemplo de browse com tabela temporária, SEM MENU!

@sample U_DnlTmpBrw

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function DnlTmpBrw()
local oBrowse as object
local aFields as array
local oTable as object

aFields := {}

oTable := getTempTable(C_ALIAS_TEST, @aFields)

oBrowse := getBrowse(oTable, aFields, C_ALIAS_TEST)
oBrowse:Activate()

oTable:Delete()
oBrowse:Destroy()

FWFreeVar(@oTable)
FWFreeVar(@aFields)
FWFreeVar(@oBrowse)

return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} getTempTable
Retorna a objeto da tabela temporária, já criada e com registros

@param cAlias Alias que a tabela temporária será baseada
@param aFields Campos da tabela temporária [Referência]

@return oTemp Objeto FWTemporaryTable

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getTempTable(cAlias, aFields)
local oTemp as object
local aIndex as array

oTemp := FWTemporaryTable():New()
aFields := (cAlias)->(dbStruct())
aIndex := getIndex(cAlias)

oTemp:SetFields(aFields)

addIndex(oTemp, aIndex)

oTemp:Create()

insertInto(oTemp, aFields, cAlias)

return oTemp

//-------------------------------------------------------------------
/*/{Protheus.doc} getBrowse
Retorna o browse da tabela temporária, já com o alias e colunas

@param oTemp Objeto FWTemporaryTable da tabela temporária
@param aFields Campos da tabela temporária
@param cAlias Alias que a tabela temporária é baseada

@return oBrowse Objeto FWMBrowse

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getBrowse(oTemp, aFields, cAlias)
local oBrowse as object

oBrowse := FWMBrowse():New()
oBrowse:SetDescription( FWSX2Util():GetX2Name(cAlias) )
oBrowse:SetDataTable()
oBrowse:SetAlias( oTemp:GetAlias() )
oBrowse:SetColumns( getColumns(aFields) )
oBrowse:SetTemporary( .T. )

return oBrowse

//-------------------------------------------------------------------
/*/{Protheus.doc} getColumns
Retorna as colunas do browse com base nos campos do alias informado

@param aFields Campos da tabela temporária

@return aColumns Array de colunas do browse (FWBrwColumn)

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getColumns(aFields)
local aColumns as array
local nLoop as numeric

aColumns := {}

for nLoop := 1 to Len(aFields)
    aAdd(aColumns, FWBrwColumn():New() )

    aColumns[nLoop]:SetData( &("{ || " + aFields[nLoop][1] + " }") )
    aColumns[nLoop]:SetTitle( Capital(aFields[nLoop][1]) ) //TODO: Verificar como pegar o título
    aColumns[nLoop]:SetType( aFields[nLoop][2] )
    aColumns[nLoop]:SetSize( aFields[nLoop][3] )
    aColumns[nLoop]:SetDecimal( aFields[nLoop][4] )  
next

return aColumns

//-------------------------------------------------------------------
/*/{Protheus.doc} addIndex
Adiciona os índices na tabela temporária

@param oTemp Objeto FWTemporaryTable da tabela temporária
@param aIndex Array dos índices do alias que a tabela temporária é baseada

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function addIndex(oTemp, aIndex)
local nLoop as numeric

for nLoop := 1 to Len(aIndex)
    oTemp:AddIndex(StrZero(nLoop, 2), StrTokArr2(aIndex[nLoop],"+", .F.))
next

return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} getIndex
Retorna os índices do alias informado

@param cAlias Tabela/Alias que os índices serão verificados e retornados

@return aIndex Array com os índice do alias informado, com a remoção da função DTOS e STR

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getIndex(cAlias)
local aIndex as array
local nLoop as numeric
local cIndex as char

aIndex := {}
nLoop := 1
cIndex := removeFunctions((cAlias)->(IndexKey(nLoop)))

while !Empty(cIndex)
    aAdd(aIndex, cIndex)
    nLoop++
    cIndex := removeFunctions((cAlias)->(IndexKey(nLoop)))
Enddo

return aIndex

//-------------------------------------------------------------------
/*/{Protheus.doc} removeFunctions
Remove da string as funções DTOS e STR, funções utilizada em índices

@param cIndex Índice

@return Sting, índice limpo, sem a utilização de funções

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function removeFunctions(cIndex)
return StrTran(StrTran(StrTran(Upper(cIndex), "DTOS(", ""), "STR(", ""), ")", "")

//-------------------------------------------------------------------
/*/{Protheus.doc} insertInto
Popula a tabela temporária com base no alias de origem

@param oTemp Objeto FWTemporaryTable da tabela temporária
@param aFields Campos da tabela temporária
@param cAlias Alias que a tabela temporária é baseada

@obs Em caso de erro uma exceção é gerada e o programa é encerrado

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function insertInto(oTemp, aFields, cAlias)
local cQuery as char
local cFields as char

cFields := ArrayToStr(aFields, ",")
cQuery := "INSERT INTO " + oTemp:GetRealName() + " (" + cFields + ") "
cQuery += "SELECT " + cFields + " FROM " + RetSqlName(cAlias) + " WHERE D_E_L_E_T_ = ' '"

if TCSQLExec(cQuery) < 0
    UserException(TCSQLError())
endif

return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} ArrayToStr
Converte o array de campos (Nome) para uma string

@param aArray Array de campos do alias
@param cSep Separador durante a conversão, para SQL é utilizado vírgula (,)

@return cString String de retorno da conversão do array

@author Daniel Mendes
@since 18/12/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function ArrayToStr(aArray, cSep)
local cString as char
local nLoop as numeric

cString := ""

for nLoop := 1 to Len(aArray)
    cString += aArray[nLoop][1] + cSep
next

cString := Left(cString, Len(cString) -1)

return cString