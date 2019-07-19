#include "protheus.ch"
#include "restful.ch"

//Constantes para utilização do SQLite
#define C_SQLITE_DRIVE "SQLITE_SYS"
#define C_TABLE_ETC_NAME "DNL_ETC_JSON"

//Controle de criação de tabelas no SQLite
static __lSqlOk as logical

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlRestETC
API para exemplificar o REST no Protheus

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
wsrestful DnlRestETC description "REST de exemplo! =]"
wsdata idJSON as char optional

wsmethod post description "Recebe um JSON e armazena o mesmo no SQLite" wssyntax "dnlrestetc/v1" path "dnlrestetc/v1"
wsmethod get description "Retorna o JSON armazenado do ID informado" wssyntax "dnlrestetc/v1/{idJSON}" path "dnlrestetc/v1/{idJSON}"
wsmethod put description "Atualiza o JSON do ID informado" wssyntax "dnlrestetc/v1/{idJSON}" path "dnlrestetc/v1/{idJSON}"
wsmethod delete description "Deleta o JSON do ID informado" wssyntax "dnlrestetc/v1/{idJSON}" path "dnlrestetc/v1/{idJSON}"

end wsrestful

//-------------------------------------------------------------------
/*/{Protheus.doc} post
Método POST, onde o JSON enviado é persistido no SQLite

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod post wsservice DnlRestETC
self:setResponse( addJson( self:getContent() ) )
self:setStatus(201)
return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} get
Método GET, onde o JSON é retornando após consulta no SQLite

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod get wsservice DnlRestETC
local lRet as logical

if existID(self:idJSON)
    self:setResponse( getJson( self:idJSON ) )
    self:setStatus(200)
    lRet := .T.
else
    self:setStatus(404)
    lRet := .F.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} put
Método PUT, onde o JSON é atualizado no SQLite

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod put wsservice DnlRestETC
local lRet as logical

if existID(self:idJSON)
    updateJson( self:idJSON, self:getContent() )
    self:setStatus(204)
    lRet := .T.
else
    self:setStatus(404)
    lRet := .F.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} delete
Método DELETE, onde o JSON é excluído do SQLite

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
wsmethod delete wsservice DnlRestETC
local lRet as logical

if existID(self:idJSON)
    deleteJson( self:idJSON )
    self:setStatus(204)
    lRet := .T.
else
    self:setStatus(404)
    lRet := .F.
endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} existID
Indica se o ID pesquisado exist no DB

@param cId ID que será pesquisado

@return Boolean, Indica se o ID pesquisado existe no DB

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function existID(cID)
local lExist as logical
local cAlias as char

lExist := .F.
cAlias := GetNextAlias()

initSQLite()

if DBSqlExec(cAlias, "SELECT COUNT(*) AS QTD_REG FROM " + C_TABLE_ETC_NAME + " WHERE ID_JSON = '" + cId + "'", C_SQLITE_DRIVE)
    lExist := (cAlias)->QTD_REG > 0
    (cAlias)->(DBCloseArea())
endif

return lExist

//-------------------------------------------------------------------
/*/{Protheus.doc} addJson
Efetua a inserção do JSON enviado no SQLite

@param cJson String contendo o JSON que será inserido no DB

@return cUUID String de ID gerada na inserção no DB

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function addJson(cJson)
local cUUID as char

cUUID := FWUUIDv4(.F.)

initSQLite()
DBSqlExec("", "INSERT INTO " + C_TABLE_ETC_NAME + " VALUES ('" + cUUID + "', '" + cJson + "')", C_SQLITE_DRIVE)

return cUUID

//-------------------------------------------------------------------
/*/{Protheus.doc} getJson
Retorna o JSON presente no DB

@param cId ID que será consultado o JSON no DB

@return cJson String contendo o JSON

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getJson(cId)
local cAlias as char
local cJson as char

cAlias := GetNextAlias()
cJson := ""

initSQLite()

if DBSqlExec(cAlias, "SELECT VALUE_JSON FROM " + C_TABLE_ETC_NAME + " WHERE ID_JSON = '" + cId + "'", C_SQLITE_DRIVE)
    cJson := (cAlias)->VALUE_JSON
    (cAlias)->(DBCloseArea())
endif

return cJson

//-------------------------------------------------------------------
/*/{Protheus.doc} updateJson
Atualiza o JSON presente no DB

@param cId ID que será atualizado o JSON no DB
@param cJson JSON que será atualizado no DB

@return Boolean, Indica se a operação foi bem sucedida

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function updateJson(cId, cJson)
initSQLite()
return DBSqlExec("", "UPDATE " + C_TABLE_ETC_NAME + " SET VALUE_JSON = '" + cJson + "' WHERE ID_JSON = '" + cId + "'", C_SQLITE_DRIVE)

//-------------------------------------------------------------------
/*/{Protheus.doc} deleteJson
Apaga o JSON presente no DB

@param cId ID que será excluído o JSON no DB

@return Boolean, Indica se a operação foi bem sucedida

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function deleteJson(cId)
initSQLite()
return DBSqlExec("", "DELETE FROM " + C_TABLE_ETC_NAME + " WHERE ID_JSON = '" + cId + "'", C_SQLITE_DRIVE)

//-------------------------------------------------------------------
/*/{Protheus.doc} initSQLite
Efetua a criação da tabela de JSON no DB (SQLite)

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function initSQLite()

if __lSqlOk == nil
    if !existTable()
        createTable()
    endif
endif

return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} createTable
Efetua a criação da tabela no SQLite

@return Boolean, Indica se a criação ocorreu sem problemas
@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function createTable()
return DBSqlExec("", "CREATE TABLE " + C_TABLE_ETC_NAME + " (ID_JSON VARCHAR(32) PRIMARY KEY, VALUE_JSON CLOB)", C_SQLITE_DRIVE)

//-------------------------------------------------------------------
/*/{Protheus.doc} existTable
Verifica se a tabela existe no DB

@return lExist Indica se a tabela existe no SQLite

@author Daniel Mendes
@since 15/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function existTable()
local cAlias as char
local lExist as logical

lExist := .F.

cAlias := GetNextAlias()

if DBSqlExec(cAlias, "SELECT 1 FROM " + C_TABLE_ETC_NAME + " WHERE 0 = 1", C_SQLITE_DRIVE)
    lExist := .T.
    (cAlias)->(DBCloseArea())
endif

return lExist