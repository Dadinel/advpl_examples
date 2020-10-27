#include "protheus.ch"

//-----------------------------------------------------------------
/*/{Protheus.doc} DnlFWDBAccess
Exemplo de utilização da classe FWDBAccess

@sample U_DnlFWDBAccess()

@author Daniel Mendes
@since 27/10/2020
@version 1.0
/*/
//-----------------------------------------------------------------
user function DnlFWDBAccess()
local oPostgres as object
local oMsSql as object
local cPostgAlias as char
local cSqlAlias as char
local cQuery as char

//Crio os objetos de acesso aos bancos distintos
oPostgres := FWDBAccess():New("postgres/bra_db_27", "localhost", 7890)
oMsSql := FWDBAccess():New("mssql/mssqlunittest", "localhost", 7890)

//Abro a conexão com os bancos
if oPostgres:OpenConnection() .and. oMsSql:OpenConnection()
    cQuery := "SELECT * FROM TOP_PARAM" //Query BEM genérica...

    cPostgAlias := oPostgres:NewAlias(cQuery, GetNextAlias(), {})
    cSqlAlias := oMsSql:NewAlias(cQuery, GetNextAlias(), {})

    //Exibo dados sobre a query no console
    if Select(cPostgAlias) > 0
        ConOut("Query aberta no Postgres")
        (cPostgAlias)->(DBCloseArea())
    else
        ConErr(oPostgres:ErrorMessage())
        oPostgres:ClearError()
    endif

    if Select(cSqlAlias) > 0
        ConOut("Query aberta no MSSQL")
        (cSqlAlias)->(DBCloseArea())
    else
        ConErr(oMsSql:ErrorMessage())
        oMsSql:ClearError()
    endif

    cQuery := "INSERT INTO TOP_PARAM (PARAM_NAME, PARAM_SESSION, PARAM_VALUE) VALUES ("

    //Faço um inserção de dados na tabela
    if !oPostgres:SQLExec(cQuery + "'Xisto', 13, 'Xpto')")
        ConErr(oMsSql:ErrorMessage())
        oPostgres:ClearError()
    endif

    //Faço um inserção de dados na tabela
    if !oMsSql:SQLExec(cQuery + "'Xpto', 69, 'Xisto')")
        ConErr(oMsSql:ErrorMessage())
        oMsSql:ClearError()
    endif

    cQuery := "SELECT * FROM TOP_PARAM WHERE PARAM_NAME = "

    //Faço uma query para trazer o registro inserido
    cPostgAlias := oPostgres:NewAlias(cQuery + "'Xisto'", GetNextAlias(), {})
    cSqlAlias := oMsSql:NewAlias(cQuery + "'Xpto'", GetNextAlias(), {})

    //Exibo os dados do registro encontrado no console
    if Select(cPostgAlias) > 0
        ConOut("Dados do Postgres")
        ConOut("PARAM_NAME=" + (cPostgAlias)->PARAM_NAME)
        ConOut("PARAM_NAME=" + cValToChar((cPostgAlias)->PARAM_SESSION))
        ConOut("PARAM_NAME=" + (cPostgAlias)->PARAM_VALUE)
        (cPostgAlias)->(DBCloseArea())
    else
        ConErr(oPostgres:ErrorMessage())
        oPostgres:ClearError()
    endif

    if Select(cSqlAlias) > 0
        ConOut("Dados do MSSQL")
        ConOut("PARAM_NAME=" + (cSqlAlias)->PARAM_NAME)
        ConOut("PARAM_NAME=" + cValToChar((cSqlAlias)->PARAM_SESSION))
        ConOut("PARAM_NAME=" + (cSqlAlias)->PARAM_VALUE)
        (cSqlAlias)->(DBCloseArea())
    else
        ConErr(oMsSql:ErrorMessage())
        oMsSql:ClearError()
    endif

    cQuery := "DELETE FROM TOP_PARAM WHERE PARAM_NAME = "

    //Faço um inserção de dados na tabela
    if !oPostgres:SQLExec(cQuery + "'Xisto'")
        ConErr(oMsSql:ErrorMessage())
        oPostgres:ClearError()
    endif

    //Faço um inserção de dados na tabela
    if !oMsSql:SQLExec(cQuery + "'Xpto'")
        ConErr(oMsSql:ErrorMessage())
        oMsSql:ClearError()
    endif
else
    ConOut("Nao conectou em um dos bancos... =(")
endif

//Fecho e finalizo a conexão com ambos os bancos
if oMsSql:CloseConnection()
    oMsSql:Finish()
endif

if oPostgres:CloseConnection()
    oPostgres:Finish()
endif

FreeObj(oPostgres)
FreeObj(oMsSql)

return