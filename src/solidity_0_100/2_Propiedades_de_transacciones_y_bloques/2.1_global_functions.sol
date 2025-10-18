// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Son funciones que están disponibles globalmente en solidity.

_____________________________________________________________________________________
|           FUNCIONES GLOBALES
_____________________________________________________________________________________
|
|   msg.sender => Devuelve el remitente de la llamada actual *
|   block.blockhash (blockNumber) => Devuelve el hash de un bloque dado
|   block.coinbase => Devuelve la dirección del minero que esta procesando el bloque
|   block.difficulty => Devuelve la dificultad del bloque actual.
|   block.gaslimit => Devuelve el límite de gas del bloque actual
|   block.number => Devuelve el número del bloque actual *
|   block.timestamp => Devuelve el timestamp del bloque actual en segundos *
|   msg.data => Datos enviados en la transacción
|   msg.gas => Devuelve el gas que queda
|   msg.sig => Devuelve los cuatro primeros bytes de los datos enviados en tx
|   now => Devuelve el timestamp del block actual (Esta deprecada. Es un alias de block.timestamp y se sugiere usar esta ultima).
|   tx.gasprice => Devuelve el precio del gas de la transacción
|   tx.origin => Devuelve el emisor original de la transacción
_____________________________________________________________________________________
*/

contract globalFunctions {

    // Function msg.sender
    function getAddress() public view returns(address){
        return msg.sender;
    }
    // Function block.timestamp
    function getTimestamp() public view returns(uint){
        return block.timestamp;
    }
    // Function block.number
    function getNumber() public view returns(uint){
        return block.number;
    } 
}