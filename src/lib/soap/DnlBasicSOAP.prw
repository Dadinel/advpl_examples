#include "protheus.ch"
#include "apwebsrv.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlBasicSOAP
Exemplo b�sico de classe WS SOAP

@author Dan M
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsservice DnlBasicSOAP
    //Declara��o das propriedades
    wsdata messageOut as string
    wsdata messageIn as string

    //Declara��o dos m�todos
    wsmethod getMessage description "Retorna a mensagem recebida, caso vazia, um hello world"
    wsmethod getError description "Retorna uma exce��o"
endwsservice

//-------------------------------------------------------------------
/*/{Protheus.doc} getMessage
M�todo que recebe uma mensagem e retornoa a mesma
Caso a mensagem esteja vazia, o valor de retorno ser� um Hello World

@author Dan M
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod getMessage wsreceive messageIn wssend messageOut wsservice DnlBasicSOAP

if !Empty(self:messageIn)
    self:messageOut := self:messageIn
else
    self:messageOut := "Hello world"
endif

return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} getError
M�todo que retorna um erro, utilizando a fun��o SetSoapFault

@author Dan M
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod getError wssend messageOut wsservice DnlBasicSOAP
self:messageOut := "Error"
SetSoapFault("DnlBasicSOAP:getError","Erro... =(")
return .F.
