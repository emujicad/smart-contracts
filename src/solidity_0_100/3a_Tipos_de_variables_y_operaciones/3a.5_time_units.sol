// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
En solidity tenemos una serie de sufijos, que nos ayudan a tratar con el tiempo
+-----------------------------------------------+
|           UNIDADES DE TIEMPO                  |
+-----------------------------------------------+
|                                               |
|   <x> seconds                                 |
|   <x> minutes                                 |
|   <x> hours         <x> es un número entero   |
|   <x> days          positivo (1,2,3, ...)     |
|   <x> weeks         La base de las unidades   |
|   <x> years         de tiempo son los segundos|
|                                               |
+-----------------------------------------------+
*/

contract tesTime {
    // Unidades de Tiempo (en segundos)
    uint256 public tiempoActual = block.timestamp;

    uint256 public minutos = 1 minutes;
    uint256 public horas = 1 hours;
    uint256 public dias = 1 days;
    uint256 public semanas = 1 weeks;

    // Funciones para manipular el tiempo

    // Segundos
    function mas50segundo() public view returns (uint256) {
        return block.timestamp + 50 seconds;
    }

    // Minutos
    function mas60minutos() public view returns (uint256) {
        return block.timestamp + 60 minutes;
    }

    // Horas
    function mas1Hora() public view returns (uint256) {
        return block.timestamp + 1 hours;
    }

    // Semanas
    function mas1Semana() public view returns (uint256) {
        return block.timestamp + 1 weeks;
    }

    // Dias
    function mas2Dias() public view returns (uint256) {
        return block.timestamp + 2 days;
    }

    // Funcion para agregar tiempo
    function masTiempo(uint256 _segundos)
        public
        view
        returns (
            string memory,
            uint256,
            string memory,
            uint256
        )
    {
        return (
            "Tiempo actual",
            block.timestamp,
            "Tiempo mas adicional",
            block.timestamp + _segundos
        );
    }
}
