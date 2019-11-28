#include "protheus.ch"

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