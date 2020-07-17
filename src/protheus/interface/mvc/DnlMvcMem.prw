#include "protheus.ch"
#include "fwmvcdef.ch"

//Variável estática que salva os dados do modelo após o commit
//Necessário limpeza manual após utilização
static __cJsonMemory as char

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlMvcMemory
Função de usuário, acessa o modelo e view que são criados somente em
memória, essa função poderia e deveria estar em outro fonte para uma
melhor organização! :D

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
user function DnlMvcMemory()
local oExecView as object
local cBreakLine as char
local cData as char
local jData

DnlMvcMemoryData():cleanJsonFromModelInMemory()

oExecView := FWViewExec():New()

oExecView:setTitle("Dados pessois - Somente maiores de 18 anos")
oExecView:setSource("DnlMvcMem")
oExecView:setModal(.T.)
oExecView:setOperation(MODEL_OPERATION_INSERT)
oExecView:openView()

FreeObj(oExecView)

oExecView := nil

cData := DnlMvcMemoryData():getJsonFromModelInMemory()

if !Empty(cData)
    ConOut(cData)

    jData := JsonObject():New()
    jData:fromJson(cData)

    cBreakLine := Chr(13) + Chr(10)

    cData := "Dados cadastrados" + cBreakLine + cBreakLine
    cData += "Nome : " + jData["models"][1]["fields"][1]["value"] + cBreakLine
    cData += "Nascimento : " + DtoC(StoD(jData["models"][1]["fields"][2]["value"])) + cBreakLine
    cData += "E-mail : " + jData["models"][1]["fields"][3]["value"]

    MsgInfo(cData, "TOTVS - Protheus")

    jData := nil
endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} modelDef
Definição do modelo de dados

@return oModel - Objeto do modelo de dados

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function modelDef() as object
local oModel as object

oModel := FWFormModel():New("DNL_MVC_IN_MEMORY", /*bPre*/, /*bPost*/, {|oMdl| myCommit(oMdl)}, {|| .T.})

oModel:setDescription("MVC - Sem tabela ou dicionário de dados")
oModel:addFields("DNL_MEMORY_MODEL_FIELDS", /*cOwner*/, modelStruct(), /*bPre*/, /*bPost*/, /*bLoad*/)

return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} modelStruct
Definição da estrutura do modelo

@return oStruct - Objeto com a estrutura de dados

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function modelStruct() as object
local oStruct as object

oStruct := FWFormModelStruct():New()

oStruct:addTable("", {"Name"}, "Pessoa", /*bRealName*/)
oStruct:addField("Nome", "Nome completo", "Name", "C", 75, /*nDecimal*/, /*bValid*/, /*bWhen*/, /*aValues*/, .T., /*bInit*/, .T., /*lNoUpd*/, /*lVirtual*/, /*cValid*/)
oStruct:addField("Nascimento", "Data de nascimento", "Birth", "D", 8, /*nDecimal*/, {|oModel| adultsOnly(oModel)}, /*bWhen*/, /*aValues*/, .T., /*bInit*/, /*lKey*/, /*lNoUpd*/, /*lVirtual*/, /*cValid*/)
oStruct:addField("E-mail", "Endereço de e-mail", "Email", "C", 30, /*nDecimal*/, /*bValid*/, /*bWhen*/, /*aValues*/, .T., /*bInit*/, /*lKey*/, /*lNoUpd*/, /*lVirtual*/, /*cValid*/)

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} viewDef
Definição da visualização de dados

@return oView - Objeto para a visualização dos dados

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function viewDef() as object
local oView as object

oView := FWFormView():New()

oView:setModel(FWLoadModel("DnlMvcMem"))
oView:addField("DNL_MEMORY_VIEW_FIELDS", viewStruct(), "DNL_MEMORY_MODEL_FIELDS", /*bValid*/)
oView:createHorizontalBox("ALL_CLIENT", 100)
oView:setOwnerView("DNL_MEMORY_VIEW_FIELDS","ALL_CLIENT")

return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} viewStruct
Definição da estrutura de visualização de dados

@return oStruct - Objeto com a estrutura da visualização dos dados

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function viewStruct() as object
local oStruct as object

oStruct := FWFormViewStruct():New()

oStruct:addField("Name", "01", "Nome", "Nome completo", /*aHelp*/, "C", /*cPicture*/, /*bPictVar*/, /*cLookUp*/, /*lCanChange*/, /*cFolder*/, /*cGroup*/, /*aComboValues*/, /*nMaxLenCombo*/, /*cIniBrow*/, /*lVirtual*/, /*cPictVar*/, /*lInsertLine*/, /*nWidth*/, /*lModal*/, /*cPICBRV*/, /*lObfuscated*/)
oStruct:addField("Birth", "02", "Nascimento", "Data de nascimento", /*aHelp*/, "D", /*cPicture*/, /*bPictVar*/, /*cLookUp*/, /*lCanChange*/, /*cFolder*/, /*cGroup*/, /*aComboValues*/, /*nMaxLenCombo*/, /*cIniBrow*/, /*lVirtual*/, /*cPictVar*/, /*lInsertLine*/, /*nWidth*/, /*lModal*/, /*cPICBRV*/, /*lObfuscated*/)
oStruct:addField("Email", "03", "E-mail", "Endereço de e-mail", /*aHelp*/, "C", /*cPicture*/, /*bPictVar*/, /*cLookUp*/, /*lCanChange*/, /*cFolder*/, /*cGroup*/, /*aComboValues*/, /*nMaxLenCombo*/, /*cIniBrow*/, /*lVirtual*/, /*cPictVar*/, /*lInsertLine*/, /*nWidth*/, /*lModal*/, /*cPICBRV*/, /*lObfuscated*/)

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} adultsOnly
Validação de maiores de 18 anos
[Apenas o ano é validado]

@param oModel - Objeto do modelo, não utilizado

@return Boolean - .T.

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function adultsOnly(oFormFields) as logical
return Year(Date()) - Year(oFormFields:getValue("Birth")) >= 18

//-------------------------------------------------------------------
/*/{Protheus.doc} myCommit
Commit do modelo, apenas salva o json em uma variavel estática,
sempre retornando .T., pois não existe persistência

@param oModel - Objeto do modelo, não utilizado

@return Boolean - .T.

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function myCommit(oModel) as logical
__cJsonMemory := oModel:getJsonData()
return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlMvcMemoryData
Classe auxiliar com métodos estáticos para acessar os dados do modelo

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
class DnlMvcMemoryData from longnameclass
    static method getJsonFromModelInMemory()
    static method cleanJsonFromModelInMemory()
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} getJsonFromModelInMemory
Método para retornar o conteúdo atual do json

@return __cJsonMemory - String contendo o JSON, podendo estar vazia ou nula

@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
method getJsonFromModelInMemory() class DnlMvcMemoryData
return __cJsonMemory

//-------------------------------------------------------------------
/*/{Protheus.doc} cleanJsonFromModelInMemory
Método para limpar o conteúdo do json
	
@author Daniel Mendes
@since 17/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
method cleanJsonFromModelInMemory() class DnlMvcMemoryData
__cJsonMemory := ""
return