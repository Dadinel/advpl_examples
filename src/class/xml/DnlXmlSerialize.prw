#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlXmlSerialize
Classe genérica para converter os atributos em xml

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class DnlXmlSerialize from longnameclass
    method toXml()
    method getValoresObjeto(oObjeto)
    method getValorArray(aArray)
    method getValor(xValue)
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} toXml
Converte a instancia da classe em xml

@return cXML classe serializada em formato xml

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method toXml() class DnlXmlSerialize
local cXml as char

cXml := '<?xml version="1.0"?>'
cXml += self:getValoresObjeto(self)

return cXml

//-------------------------------------------------------------------
/*/{Protheus.doc} getPropriedades
Método auxiliar ao toXml que converte as propriedades em xml

@param oObjeto Objeto que será convertido

@return cXML XML das propriedades do objeto recebido

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getValoresObjeto(oObjeto) class DnlXmlSerialize
local aPropriedades as array
local cClasse as char
local cXml as char
local cValor as char
local nI as numeric

aPropriedades := ClassDataArr(oObjeto, /*lParent*/)
cClasse := GetClassName(oObjeto)
cXml := "<" + cClasse + ">"

for nI := 1 to Len(aPropriedades)
    cXml += "<" + aPropriedades[nI][1] + ">"
    cValor := self:getValor(aPropriedades[nI][2])
    cXml += cValor + "</" + aPropriedades[nI][1] + ">"
next

cXml += "</" + cClasse + ">"

aSize(aPropriedades, 0)

return cXml

//-------------------------------------------------------------------
/*/{Protheus.doc} getPropriedades
Método auxiliar ao toXml que converte uma propriedade do tipo array

@param aArray Array que será convertido

@return cValor XML das posições do array recebido

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getValorArray(aArray) class DnlXmlSerialize
local cValor as char
local nI as numeric

cValor := ""

for nI := 1 to len(aArray)
    cValor += self:getValor(aArray[nI]) + ","
next

cValor := Left( cValor, Len( cValor ) - 1 )

return cValor

//-------------------------------------------------------------------
/*/{Protheus.doc} getValor
Método auxiliar ao toXml que converte o valor da propriedade em string

@param xValue Valor que será convertido

@return cValor XML do valor recebido

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getValor(xValue) class DnlXmlSerialize
local cValor as char
local cTipo as char

cTipo := ValType(xValue)

do case
    case cTipo == "C"
        cValor := xValue
    case cTipo == "D"
        cValor := DtoC(xValue)
    case cTipo == "B"
        cValor := GetCBSource(xValue)
    case cTipo == "N"
        cValor := cValToChar(xValue)
    case cTipo == "L"
        cValor := Iif(xValue, "true", "false")
    case cTipo == "J"
        cValor := xValue:toJSON()
    case cTipo == "A"
        cValor := self:getValorArray(xValue)
    case cTipo == "O"
        cValor := self:getValoresObjeto(xValue)
    otherwise
        cValor := ""
endcase

return cValor