// SPDX-License-Identifier: MIT
// La primera línea de un contrato de Solidity. Declara la licencia bajo la cual el código es publicado.
// Es una buena práctica para generar confianza y estandarización.
pragma solidity >=0.8.0 <0.9.0;

/*
 * NOTA PARA APRENDICES:
 * Este archivo demuestra las 3 formas principales de enviar Ether (la criptomoneda de Ethereum) desde un contrato a otra dirección.
 * Cada método tiene implicaciones importantes en cuanto a seguridad y manejo de gas.
 *
 * Los tres métodos son:
 *
 * 1. .transfer()
 *    - Límite de gas: 2300 (muy bajo, solo para logs básicos).
 *    - En caso de error: Revierte la transacción (muy seguro).
 *    - Estado: Considerado seguro pero obsoleto por su rigidez con el gas.
 *
 * 2. .send()
 *    - Límite de gas: 2300 (igual que transfer).
 *    - En caso de error: Devuelve `false` pero NO revierte la transacción.
 *    - Estado: NO RECOMENDADO. Es peligroso porque si olvidas verificar el resultado, el fallo pasa desapercibido.
 *
 * 3. .call()
 *    - Límite de gas: Reenvía todo el gas disponible (muy flexible).
 *    - En caso de error: Devuelve `false` (igual que send).
 *    - Estado: MÉTODO RECOMENDADO ACTUALMENTE. Es el más flexible, pero requiere verificar siempre el resultado
 *      y tener cuidado con los ataques de re-entrada (re-entrancy).
 */

/**
 * @title SendEther
 * @dev Este contrato contiene tres funciones, cada una para demostrar una forma de enviar Ether.
 */
contract SendEther {
    /**
     * @dev El constructor se ejecuta una sola vez cuando el contrato es desplegado.
     * La palabra clave `payable` permite que el constructor reciba Ether durante el despliegue.
     * Esto es útil para que el contrato tenga un saldo inicial.
     */
    constructor() payable {}

    /**
     * @dev Esta es una función especial llamada `receive`. Se ejecuta automáticamente
     * cuando el contrato recibe Ether sin que se especifique ninguna función a llamar (msg.data está vacío).
     * Debe ser `external` y `payable`.
     */
    receive() external payable {}

    /**
     * @dev Envía 123 wei a la dirección `_to` usando el método `.transfer()`.
     * Si la dirección `_to` es un contrato que no puede recibir Ether o la operación gasta más de 2300 gas,
     * toda la transacción se revertirá.
     * @param _to La dirección payable que recibirá el Ether.
     */
    function testTransfer(address payable _to) external payable {
        // `transfer` es simple y seguro, pero su límite de gas fijo puede ser un problema.
        _to.transfer(123);
    }

    /**
     * @dev Envía 123 wei a la dirección `_to` usando el método `.send()`.
     * `.send()` devuelve `false` si falla, en lugar de revertir.
     * Por eso es CRÍTICO usar `require()` para verificar el resultado. Si no lo haces,
     * el Ether podría no enviarse y el resto de tu función seguiría ejecutándose.
     * @param _to La dirección payable que recibirá el Ether.
     */
    function testSend(address payable _to) external payable {
        // `send` es similar a `transfer` pero menos seguro si no se maneja correctamente.
        bool sent = _to.send(123);
        require(sent, "El envio con .send() fallo");
    }

    /**
     * @dev Envía 123 wei a la dirección `_to` usando el método `.call()`.
     * Esta es la forma recomendada hoy en día.
     * La sintaxis `{value: 123}` especifica la cantidad de Ether a enviar.
     * El `("")` significa que no estamos llamando a ninguna función específica del otro contrato.
     * Devuelve un booleano `success` que DEBE ser verificado.
     * @param _to La dirección payable que recibirá el Ether.
     */
    function testCall(address payable _to) external payable {
        // `.call` es el método más flexible y recomendado.
        // Reenvía todo el gas, permitiendo operaciones complejas en el contrato receptor.
        // ¡SIEMPRE verifica el resultado `success`!
        (bool success, ) = _to.call{value: 123}("");
        require(success, "La llamada con .call() fallo");
    }
}

/**
 * @title RecibirEther
 * @dev Un contrato simple diseñado para ser el destinatario de las transferencias de `SendEther`.
 * Su único propósito es recibir Ether y emitir un evento para que podamos ver qué sucedió.
 */
contract RecibirEther {
    /**
     * @dev Un evento es un log que se guarda en la blockchain. Las aplicaciones externas
     * pueden "escuchar" estos eventos para reaccionar a cambios en el contrato.
     * Aquí, registraremos la cantidad de Ether recibido y el gas restante.
     */
    event Log(uint amount, uint gas);

    /**
     * @dev La función `receive` se activa cuando este contrato recibe Ether.
     * Aquí, emitimos el evento `Log` para registrar la cantidad (msg.value)
     * y el gas que queda en ese momento (`gasleft()`).
     * Al probar `transfer` y `send`, verás que el valor de `gasleft()` es muy bajo.
     * Al probar con `call`, será mucho más alto.
     */
    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}