#include 'protheus.ch'
#include 'fwmvcdef.ch'

//--------------------------------------------------
/*/{Protheus.doc} DNL_E4EC
Cadastro do alias SE4/SEC

@author Daniel Mendes
@since 19/06/19
@version 1.0 
/*/
//--------------------------------------------------
user function DNL_E4EC()
local oBrowse as object

oBrowse := FWLoadBrw('DNL_E4EC')
oBrowse:Activate()
oBrowse:DeActivate()
oBrowse:Destroy()
FreeObj(oBrowse)
oBrowse := nil

return Nil

//--------------------------------------------------
/*/{Protheus.doc} BrowseDef
Definições do browse

@return oBrowse Objeto do tipo FWMBrowse(FWBrowse)

@author Daniel Mendes
@since 19/06/19
@version 1.0 
/*/
//--------------------------------------------------
static function BrowseDef()
local oBrowse as object

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SE4")
oBrowse:SetDescription("Testando o MVC - Tabela SE4/SEC")

return oBrowse

//--------------------------------------------------
/*/{Protheus.doc} MenuDef
Definição das opções de menu

@author Daniel Mendes
@since 19/06/19
@version 1.0 
/*/
//--------------------------------------------------
static function MenuDef()
local aRotina as array

aRotina := {}

Add Option aRotina Title "Pesquisar" Action "PesqBrw" Operation OP_PESQUISAR Access 0
Add Option aRotina Title "Visualizar" Action "ViewDef.DNL_E4EC" Operation OP_VISUALIZAR Access 0
Add Option aRotina Title "Incluir" Action "ViewDef.DNL_E4EC" Operation OP_INCLUIR Access 0
Add Option aRotina Title "Alterar" Action "ViewDef.DNL_E4EC" Operation OP_ALTERAR Access 0
Add Option aRotina Title "Excluir" Action "ViewDef.DNL_E4EC" Operation OP_EXCLUIR Access 0
Add Option aRotina Title "Imprimir" Action "ViewDef.DNL_E4EC" Operation OP_IMPRIMIR Access 0
Add Option aRotina Title "Copiar" Action "ViewDef.DNL_E4EC" Operation OP_COPIA Access 0

return aRotina
//--------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de dados

@return oModel Objeto do tipo MPFormModel(FWFormModel)

@author Daniel Mendes
@since 19/06/19
@version 1.0 
/*/
//--------------------------------------------------
static function ModelDef()
local oModel as object
local oStrctSE4 as object
local oStrctSEC as object

oStrctSE4 := FwFormStruct( 1 , 'SE4' , /*bFiltro*/ )
oStrctSEC := FwFormStruct( 1 , 'SEC' , /*bFiltro*/ )
oModel    := MPFormModel():New( 'MdlMvcSE4' , /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'M01SE4' , /*Owner*/ , oStrctSE4 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )
oModel:AddGrid( 'M02SEC' , 'M01SE4' , oStrctSEC , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 

oModel:SetRelation(  'M02SEC' , {{ 'EC_FILIAL' , xFilial( 'SEC') } , { 'EC_CODIGO' , 'E4_CODIGO' } } , SEC->( IndexKey(1) ) )
oModel:GetModel( 'M02SEC' ):SetUniqueLine( { 'EC_ITEM' } )

return oModel

//--------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição da interface

@return oView Objeto do tipo FwFormView

@author Daniel Mendes
@since 19/06/19
@version 1.0 
/*/
//--------------------------------------------------
static function ViewDef()
local oModel as object
local oView as object
local oStrctSE4 as object
local oStrctSEC as object

oModel    := FwLoadModel( 'DNL_E4EC' )
oView     := FwFormView():New() 
oStrctSE4 := FwFormStruct( 2 , 'SE4' , /*bFiltro*/ )
oStrctSEC := FwFormStruct( 2 , 'SEC' , /*bFiltro*/ )

oView:SetModel( oModel )
oView:AddField( 'V01SE4' , oStrctSE4 , 'M01SE4' )
oView:AddGrid( 'V02SEC' , oStrctSEC , 'M02SEC' )
oView:CreateHorizontalBox( 'VwSE4' , 50 )
oView:CreateHorizontalBox( 'VwSEC' , 50 )
oView:SetOwnerView( 'V01SE4' , 'VwSE4' )
oView:SetOwnerView( 'V02SEC' , 'VwSEC' )

return oView