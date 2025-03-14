#include "protheus.ch"

//Nome da pasta onde serão salvos os resources do RPO
#define C_PATH_SAVE "\resources\"

//-------------------------------------------------------------------
/*/{Protheus.doc} u_ResToRoot
Salva "todos" os resources do RPO em uma pasta

@author Dan M
@sample u_ResToRoot()
@since 18/05/2020
@version 1.0
@obs Os resources .tres são ignorados
/*/
//-------------------------------------------------------------------
function u_ResToRoot()
local aResources as array
local nX as numeric

aResources := GetResArray("*")

if !ExistDir(C_PATH_SAVE)
    MakeDir(C_PATH_SAVE)
endif

for nX := 1 to Len(aResources)
    if !Lower(Right(aResources[nX], 5)) == ".tres"
        Resource2File(aResources[nX], C_PATH_SAVE + aResources[nX])
    endif
next

return nil
