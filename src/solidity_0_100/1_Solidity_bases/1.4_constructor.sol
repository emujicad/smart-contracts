/*
Es una funcion opcional donde se definen las propiedades del contrato que deben ser inicializadas.
_____________________________________________________________________
|             CONTRACT                                              |
|___________________________________________________________________|
|                                                                   |
|     constructor {                                                 |
|         ...                                                       |
|     }                                                             |
|___________________________________________________________________|
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract TestConstructor {

    address owner;

    constructor() {
        owner =  msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}