#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlArrayUtils
Classe com métodos estáticos e úteis para manipulação de arrays

@author Daniel Mendes
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class DnlArrayUtils from longnameclass
    static method insertIntoArrayPosition(aArray, xValue, nPosition)
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} insertIntoArrayPosition
Insere um item no array na posição indicada

@param aArray Array que será manipulado
@param xValue Valor que será inserido no array
@param nPosition Posição que o valor será inserido

@author Daniel Mendes
@since 28/11/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method insertIntoArrayPosition(aArray, xValue, nPosition) class DnlArrayUtils
aAdd(aArray, nil)
AIns(aArray, nPosition)
aArray[nPosition] := xValue
return nil