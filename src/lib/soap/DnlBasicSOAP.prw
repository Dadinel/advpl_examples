#include "protheus.ch"
#include "apwebsrv.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlBasicSOAP
Exemplo básico de classe WS SOAP

@author Dan M
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsservice DnlBasicSOAP
    //Declaração das propriedades
    wsdata messageOut as string
    wsdata messageIn as string

    //Declaração dos métodos
    wsmethod getMessage description "Retorna a mensagem recebida, caso vazia, um hello world"
    wsmethod getError description "Retorna uma exceção"
endwsservice

//-------------------------------------------------------------------
/*/{Protheus.doc} getMessage
Método que recebe uma mensagem e retornoa a mesma
Caso a mensagem esteja vazia, o valor de retorno será um Hello World

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
Método que retorna um erro, utilizando a função SetSoapFault

@author Dan M
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod getError wssend messageOut wsservice DnlBasicSOAP
self:messageOut := "Error"
SetSoapFault("DnlBasicSOAP:getError","Erro... =(")
return .F.
