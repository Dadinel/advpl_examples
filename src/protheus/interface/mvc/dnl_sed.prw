#include "protheus.ch"
#include "fwmvcdef.ch"

PUBLISH USER MODEL REST NAME DNL_SED SOURCE DNL_SED

//-------------------------------------------------------------------
/*/{Protheus.doc} DNL_SED
Função de cadastro de naturezas, alias SED

@sample U_DNL_SED()

@author Daniel Mendes
@since 19/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function DNL_SED()
local oBrowse as object

oBrowse := FWLoadBrw("DNL_SED")
oBrowse:Activate()
oBrowse:DeActivate()
oBrowse:Destroy()
FreeObj(oBrowse)
oBrowse := nil

return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} BrowseDef
Retorna o browse da rotina

@return oBrowse Objeto do tipo FWMBrowse(FWBrowse)

@author Daniel Mendes
@since 19/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function BrowseDef()
local oBrowse as object

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SED")
oBrowse:SetDescription("Testando o MVC - Tabela SED")

return oBrowse

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Retorna o modelo de dados para o cadastro de naturezas, alias SED
Todo o modelo é baseado nos dicionários, em principal SX2, SX3 e SIX

@return oModel Objeto do tipo MPFormModel(FWFormModel)

@author Daniel Mendes
@since 19/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function ModelDef()
local oModel as object
local oStruct as object

oModel := MPFormModel():New( "MODEL_SED", /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )
oStruct := FwFormStruct( 1, "SED", /*bFiltro*/ )

oModel:AddFields( "FIELDS_SED", /*Owner*/ , oStruct, /*bPre*/ , /*bPos*/ , /*bLoad*/ )

return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Retorna a view para o cadastro de naturezas, alias SED

@return oView Objeto do tipo FwFormView

@author Daniel Mendes
@since 19/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function ViewDef()
local oView as object
local oStruct as object
local oModel as object

oView := FwFormView():New()
oModel := FwLoadModel("DNL_SED")
oStruct := FwFormStruct( 2, "SED", /*bFiltro*/ )

oView:SetModel(oModel)
oView:AddField( "VIEW_SED", oStruct, "FIELDS_SED" )

return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Retorna o array com a opções presentes na rotina

@return aRotina Array contendo as opções da rotina, algumas opções
não são apresentadas diretamente como botões, é necessário ir nas
outras ações

@author Daniel Mendes
@since 19/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function MenuDef()
local aRotina as array

aRotina := {}

Add Option aRotina Title "Pesquisar" Action "PesqBrw" Operation OP_PESQUISAR Access 0
Add Option aRotina Title "Visualizar" Action "ViewDef.DNL_SED" Operation OP_VISUALIZAR Access 0
Add Option aRotina Title "Incluir" Action "ViewDef.DNL_SED" Operation OP_INCLUIR Access 0
Add Option aRotina Title "Alterar" Action "ViewDef.DNL_SED" Operation OP_ALTERAR Access 0
Add Option aRotina Title "Excluir" Action "ViewDef.DNL_SED" Operation OP_EXCLUIR Access 0
Add Option aRotina Title "Imprimir" Action "ViewDef.DNL_SED" Operation OP_IMPRIMIR Access 0
Add Option aRotina Title "Copiar" Action "ViewDef.DNL_SED" Operation OP_COPIA Access 0

return aRotina