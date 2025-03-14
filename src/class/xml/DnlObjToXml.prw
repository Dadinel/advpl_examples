#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} dnlObjToXml
Função para teste da serialização de objetos para XML

@author Dan M
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
