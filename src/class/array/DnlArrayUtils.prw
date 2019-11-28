#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} DnlArrayUtils
Classe com m�todos est�ticos e �teis para manipula��o de arrays

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
Insere um item no array na posi��o indicada

@param aArray Array que ser� manipulado
@param xValue Valor que ser� inserido no array
@param nPosition Posi��o que o valor ser� inserido

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