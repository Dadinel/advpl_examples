#include 'protheus.ch'

//Grupo e filial que o ambiente será aberto
#define C_GRUPO  "99"
#define C_FILIAL "01"

//-------------------------------------------------------------------
/*/{Protheus.doc} DNLInsTmp
Exemplo de INSERT INTO com a tabela temporária (FWTemporaryTable)

@sample U_DNLInsTmp()
@author Daniel Mendes
@since 30/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function xDNLInsTmp()
local oTempTable as object
local aStruct as array
local cQuery as char
local cAlias as char
local cFields as char
local nLoop as numeric

//Abre o ambiente, o que já conecta no banco de dados
RpcSetEnv(C_GRUPO, C_FILIAL)

aStruct := SED->(DBStruct())

//Criação da tabela temporária com uma estrutura igual a do Protheus
oTempTable := FWTemporaryTable():New()
oTempTable:SetFields(aStruct)
oTempTable:Create()

cFields := ""

//Pega todos os campos para efetuar a cópia dos dados
for nLoop := 1 to Len(aStruct)
    cFields += aStruct[nLoop][1] + ","//Nome do campo
next

cFields := Left(cFields, Len(cFields) -1) //Remover a ultima vírgula

//Criação do insert into
cQuery := "INSERT INTO " + oTempTable:GetRealName()
cQuery += " (" + cFields + ") "
cQuery += "SELECT " + cFields
cQuery += " FROM " + RetSqlName("SED") + " WHERE D_E_L_E_T_ = ' '"

//Envia o insert into para o banco de dados, portanto toda a cópia é feita pelo banco de dados, com grande performance!
if TCSqlExec(cQuery) < 0
    ConOut("O comando SQL gerou erro:", TCSqlError())
else
    cAlias := oTempTable:GetAlias()

    (cAlias)->(DBGoTop())

    //Exibe os três primeiros campos no console do AppServer
    while !(cAlias)->(Eof())
        ConOut( (cAlias)->(FieldGet(1)) + " | " + (cAlias)->(FieldGet(2)) + " | " + (cAlias)->(FieldGet(3)) )
        (cAlias)->(DBSkip())
    enddo
endif

//Fecha e apaga a tabela
oTempTable:Delete()

//Fecha o ambiente
RpcClearEnv()

return nil