#include "protheus.ch"
#include "restful.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlRestXML
Exemplo de REST trabalhando com XML

@author Daniel Mendes
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsrestful DnlRestXML description "Exemplo de REST com XML"
wsmethod post description "Recebe um XML" wssyntax "/v1" path "/v1"
wsmethod get description "Retorna um XML" wssyntax "/v1" path "/v1" produces APPLICATION_XML
wsmethod get error description "Gera uma exceção" wssyntax "/v1/error" path "/v1/error"
end wsrestful

//-------------------------------------------------------------------
/*/{Protheus.doc} get
Retorna um XML

@author Daniel Mendes
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod get wsservice DnlRestXML
local cXml as char

begincontent var cXml
    <?xml version="1.0"?>
    <teste>
        <xisto>Daniel</xisto>
    </teste>
endcontent

self:setResponse(cXml)
self:setStatus(200)

return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} post
Recebe um XML

@author Daniel Mendes
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod post wsservice DnlRestXML
local lRet as logical
local oXml as object
local cError as char
local cWarning as char
local cContentType as char

lRet := .F.
cContentType := self:getHeader("Content-Type")

self:setHeader("Accept", APPLICATION_XML)

if cContentType != nil .and. APPLICATION_XML $ Lower(cContentType)
    cError := ""
    cWarning := ""

    oXml := XmlParser( self:getContent(), "_", @cError, @cWarning )

    if ValType(oXml) == "O"
        lRet := .T.
        self:setStatus(201)
    else
        self:setStatus(400)
    endif
else
    self:setStatus(400)
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} error
Retorna um exceção

@author Daniel Mendes
@since 03/06/2020
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod get error wsservice DnlRestXML
self:setStatus(500)
return .F.