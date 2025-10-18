// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract HolaMundo {
    // Variable de estado (se almacena en la Blockchain)
    string private mensaje;

    // Constructor: se ejecuta una vez al desplegar el contrato
    constructor() {
        mensaje = "Hola Mundo";
    }

    // Funcion para obtener el mensaje actual
    function getMensaje() public view returns (string memory) {
        return mensaje;
    }

    // Funcion para actualizar mensaje
    function updateMensaje(string memory nuevoMensaje) public  {
        mensaje = nuevoMensaje;
    }
}
