// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Los enums son una de las manera que tiene solidity para que el usuario pueda crear su propio tipo de datos
+----------------------------------------------------------------------+
|                                 ENUMS                                |
+----------------------------------------------------------------------+
|                                                                      |
| enum <nombre_enumeracion> {valores_enumeracion}                      |
|                                                                      |
| // Declara una variable de tipo enum                                  |
| <nombre_enumeracion> <nombre_variable>;                              |
|                                                                      |
+----------------------------------------------------------------------+

Modificar el valor de un ENUMS

+----------------------------------------------------------------------+
|                         MODIFICAR ENUMS                              |
+----------------------------------------------------------------------+
|                                                                      |
| // 1. Especificando la opción de la enumeración                      |
| <nombre_variable> = <nombre_enumeracion>.<valor_enumeracion>;        |
|                                                                      |
| // 2. Con el índice                                                  |
| <nombre_variable> = <nombre_enumeracion>(<posicion>)                 |
|                                                                      |
+----------------------------------------------------------------------+

*/

contract TestEnum {

    // Definición de Enum Estado
    enum Estado {Apagado, Encendido}

    // Declaración de variable de tipo Estado
    Estado estado;

    // Funcion para cambiar el estado a Apagado
    function apagar() public {
        estado = Estado.Apagado;
    }

    // Funcion para cambiar el estado a Encendido
    function encender() public {
        estado = Estado.Encendido;
    }

    // Funcion para obtener el estado de la variable
    function consultarEstado() public view returns(Estado){
        return estado;
    }
}

