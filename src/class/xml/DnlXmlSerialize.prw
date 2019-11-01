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

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlPessoa
Classe simples para exemplificar uma pessoa

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class DnlPessoa from DnlXmlSerialize
    data nome as char
    data sobrenome as char
    data nascimento as date
    data informacoes as array
    data filhos as array

    method new() constructor
    method destroy()

    method setNome(nome)
    method setSobrenome(sobrenome)
    method setNascimento(dNascimento)
    method addInformacao(cInformacao)
    method addFilho(oFilho)
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor da classe

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class DnlPessoa
self:nome := ""
self:sobrenome := ""
self:nascimento := CtoD("")
self:informacoes := {}
self:filhos := {}
return self

//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Método destrutor da classe

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class DnlPessoa
local nI as numeric

for nI := 1 to len(self:filhos)
    self:filhos[nI]:destroy()
    FreeObj(self:filhos[nI])
next

aSize(self:informacoes, 0)
aSize(self:filhos, 0)

self:nome := nil
self:sobrenome := nil
self:nascimento := nil
self:informacoes := nil
self:filhos := nil

return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} setNome
Set da propriedade nome

@param cNome Nome da pessoa

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method setNome(cNome) class DnlPessoa
self:nome := cNome
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} setSobrenome
Set da propriedade sobrenome

@param cSobrenome Sobrenome da pessoa

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method setSobrenome(cSobrenome) class DnlPessoa
self:sobrenome := cSobrenome
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} setNascimento
Set da propriedade nascimento

@param dNascimento Nascimento da pessoa

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method setNascimento(dNascimento) class DnlPessoa
self:nascimento := dNascimento
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} addInformacao
Add da propriedade informacoes

@param cInformacao Informação sobre a pessoa

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method addInformacao(cInformacao) class DnlPessoa
aAdd(self:informacoes, cInformacao)
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} addInformacao
Add da propriedade filho

@param oFilho Filho da pessoa

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method addFilho(oFilho) class DnlPessoa
aAdd(self:filhos, oFilho)
return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} dnlObjToXml
Função para teste da serialização de objetos para XML

@author Daniel Mendes
@since 25/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function dnlObjToXml()
local oDaniel as object
local oRafael as object

oDaniel := DnlPessoa():New()

oDaniel:setNome("Daniel")
oDaniel:setSobrenome("Mendes")
oDaniel:setNascimento( CtoD("10/12/1986") )
oDaniel:addInformacao( "DEV" )
oDaniel:addInformacao( "Cerveja" )

oRafael := DnlPessoa():New()

oRafael:setNome("Rafael")
oRafael:setSobrenome("Mendes")
oRafael:setNascimento( CtoD("03/09/2019") )
oRafael:addInformacao( "RN" )

oDaniel:addFilho(oRafael)

ConOut( oDaniel:toXml() )

oDaniel:destroy()

FreeObj(oDaniel)

return nil
