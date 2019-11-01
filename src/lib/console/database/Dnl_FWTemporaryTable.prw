#include "protheus.ch"

//-----------------------------------------------------------------
/*/{Protheus.doc} DnlTmpTbl
Cria e efetua testes com as tabelas temporárias, utilizando
da classe FWTemporaryTable, da LIB do Protheus

@sample U_DnlTmpTbl()

@author Daniel Mendes
@since 01/07/2019
@version 1.0
/*/
//-----------------------------------------------------------------
user function DnlTmpTbl()
local oTable as object
local aFields as array
local nConnect as numeric
local lCloseConnect as logical
local cAlias as char
local cTableName as char
local cAreaQuery as char
local cQuerySQL as char

//--------------------------------------------------------------------------
//Esse bloco efetua a conexão com o DBAccess caso a mesma ainda não exista
//--------------------------------------------------------------------------
if TCIsConnected()
    nConnect := TCGetConn()
    lCloseConnect := .F.
else
    nConnect := TCLink()
    lCloseConnect := .T.
endif

//-------------------------------------------------------------------------------------------
//Só podemos continuar com a geração da tabela temporária caso exista conexão com o DBAccess
//-------------------------------------------------------------------------------------------
if nConnect >= 0
    //--------------------------------------------------------------------
    //O primeiro parâmetro de alias, possui valor default
    //O segundo parâmetro de campos, pode ser atribuido após o construtor
    //--------------------------------------------------------------------
    oTable := FWTemporaryTable():New( /*cAlias*/, /*aFields*/)

    //----------------------------------------------------
    //O array de campos segue o mesmo padrão do DBCreate:
    //1 - C - Nome do campo
    //2 - C - Tipo do campo
    //3 - N - Tamanho do campo
    //4 - N - Decimal do campo
    //----------------------------------------------------
    aFields := {}

    aAdd(aFields, {"C_ID", "C", 36, 0})
    aAdd(aFields, {"N_COD", "N", 10, 0})
    aAdd(aFields, {"C_NAME", "C", 50, 0})
    aAdd(aFields, {"D_DATE", "D", 8, 0})
    aAdd(aFields, {"C_OBS", "C", 255, 0})

    oTable:SetFields(aFields)

    //---------------------
    //Criação dos índices
    //---------------------
    oTable:AddIndex("01", {"C_ID"} )
    oTable:AddIndex("02", {"N_COD"} )
    oTable:AddIndex("03", {"N_COD", "C_NAME"} )

    //---------------------------------------------------------------
    //Pronto, agora temos a tabela criado no espaço temporário do DB
    //---------------------------------------------------------------
    oTable:Create()

    //------------------------------------
    //Pego o alias da tabela temporária
    //------------------------------------
    cAlias := oTable:GetAlias()

    //--------------------------------------------------------
    //Pego o nome real da tabela temporária no banco de dados
    //--------------------------------------------------------
    cTableName := oTable:GetRealName()

    //------------------------------
    //Inserção de dados para testes
    //------------------------------
    (cAlias)->(DBAppend())
    (cAlias)->C_ID := FWUUIDv4()
    (cAlias)->N_COD := 1
    (cAlias)->C_NAME := "Daniel"
    (cAlias)->D_DATE := Date()
    (cAlias)->C_OBS := "Kamehameha"
    (cAlias)->(DBCommit())

    //-------------------------------------------------------------------------
    //Inserção de dados via INSERT, vamos usar o nome real da tabela para isso
    //-------------------------------------------------------------------------
    cQuerySQL := ""
    cQuerySQL += "INSERT INTO " + cTableName + " (C_ID, N_COD, C_NAME, D_DATE, C_OBS) VALUES "
    cQuerySQL += "('" + FWUUIDv4() + "', 2, 'Mendes', '" + DtoS(Date()) + "', 'Hadouken')"

    if TCSqlExec(cQuerySQL) < 0
        ConOut("Ops:", TCSqlError())
    endif

    (cAlias)->(DBSetOrder(3)) //N_COD+C_NAME

    if (cAlias)->(DBSeek("1" + "Daniel"))
        ConOut("Registro encontrado =)")
    else
        ConOut("Ops...")
    endif

    //---------------------------------------------------------
    //Exemplo de query, agora vamos usar o nome real da tabela
    //---------------------------------------------------------
    cAreaQuery := GetNextAlias()

    //--------------------------------------------------------------------
    //É válido lembrar que a data é gravada como string no banco de dados
    //--------------------------------------------------------------------
    cQuerySQL := "SELECT C_ID, N_COD, C_NAME, D_DATE, C_OBS FROM " + cTableName

    DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuerySQL), cAreaQuery, .T., .T.)

    while !(cAreaQuery)->(Eof())
        ConOut( (cAreaQuery)->C_ID, (cAreaQuery)->N_COD, (cAreaQuery)->C_NAME, (cAreaQuery)->D_DATE, (cAreaQuery)->C_OBS )
        (cAreaQuery)->(DBSkip())
    enddo

    //-----------------------------------------------------------
    //Sempre fecho a workarea após utilizar do retorno da query
    //-----------------------------------------------------------
    (cAreaQuery)->(DBCloseArea())

    //-------------------------------------------------------------------
    //Fecho e apago a tabela temporária
    //Por mais que a tabela temporária seja excluí­da de forma automática,
    //É sempre uma boa prática fechar e excluir a mesma
    //-------------------------------------------------------------------
    oTable:Delete()
	FWFreeVar(@oTable) //Limpa o objeto da memória
endif

//--------------------------------------
//Fecha a conexão criada para os testes
//--------------------------------------
if lCloseConnect
    TCUnLink()
endif

return nil