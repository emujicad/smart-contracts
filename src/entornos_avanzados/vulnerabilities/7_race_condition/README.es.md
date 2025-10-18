# Contrato Inteligente NoVulnerableRaceCondition (Intento de Prevención de Race Condition - Aún Vulnerable)

Este contrato de Solidity, `NoVulnerableRaceCondition`, es un ejemplo que intenta prevenir una condición de carrera (race condition) utilizando un flag `isTransfering`. Sin embargo, a pesar de este intento, el contrato **sigue siendo vulnerable a ataques de reentrancy** debido al orden de las operaciones en la función de retiro.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la complejidad de asegurar contratos contra condiciones de carrera y reentrancy.

## ¿Qué es una Condición de Carrera (Race Condition)?

Una condición de carrera ocurre cuando el resultado de una operación depende de la secuencia o el tiempo de eventos incontrolables. En la blockchain, esto a menudo se manifiesta como un ataque de reentrancy, donde un atacante puede ejecutar código malicioso antes de que el estado del contrato se actualice completamente.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `mapping(address => uint256) public balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con un balance (`uint256`). Se utiliza para llevar un registro de cuánto Ether ha depositado cada usuario en el contrato.

### `mapping(address => bool) public isTransfering;`

Un `mapping` que asocia una dirección con un valor booleano. La intención es usarlo como un "candado" para indicar si una dirección ya está en medio de una transferencia, intentando prevenir llamadas concurrentes.

## Funciones del Contrato

### `deposit() public payable`

*   **Propósito:** Permite a los usuarios depositar Ether en el contrato.
*   **Funcionamiento:**
    1.  `public payable`: La función puede ser llamada por cualquiera y puede recibir Ether.
    2.  `balances[msg.sender] += msg.value;`: Añade la cantidad de Ether enviada (`msg.value`) al balance del remitente (`msg.sender`) en el `mapping` `balances`.
    3.  `balance += msg.value;`: Actualiza un balance total del contrato.

### `withdraw(uint256 _amount) public`

*   **Propósito:** Permite a un usuario retirar una cantidad específica de su Ether depositado del contrato.
*   **Parámetros:**
    *   `_amount`: La cantidad de Ether (en Wei) que el usuario desea retirar.
*   **Funcionamiento (Vulnerable a Reentrancy):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Verifica que el usuario tenga suficientes fondos para retirar la cantidad solicitada.
    2.  `require(!isTransfering[msg.sender],"Error. Transfer in progress");`: **Intento de prevención.** Verifica si ya hay una transferencia en curso para esta dirección. Si es así, revierte. Sin embargo, esto no previene la reentrancy si el atacante "reentra" en la misma transacción.
    3.  `isTransfering[msg.sender] = true;`: Establece el flag a `true`. Esto debería bloquear llamadas concurrentes, pero no reentradas dentro de la misma transacción.
    4.  `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: **Aquí reside la vulnerabilidad.** El contrato realiza una llamada externa para enviar el Ether al `msg.sender` *antes* de actualizar el balance del remitente. Si `msg.sender` es un contrato malicioso, puede ejecutar código arbitrario en este punto y "reentrar" en la función `withdraw`.
    5.  `balances[msg.sender] -= _amount;`: Finalmente, el balance del remitente se reduce. Si el contrato malicioso "reentró" antes de esta línea, ya habrá retirado fondos adicionales.
    6.  `isTransfering[msg.sender] = false;`: Restablece el flag a `false`.

## ¿Por qué este enfoque es "Aún Vulnerable"?

Este contrato es vulnerable a ataques de **reentrancy** porque no sigue el patrón de seguridad **Checks-Effects-Interactions** de manera estricta. El orden de las operaciones es:

1.  **Checks (Verificaciones):** `require(balances[msg.sender] >= _amount, ...)` y `require(!isTransfering[msg.sender], ...)`
2.  **Effects (Parciales):** `isTransfering[msg.sender] = true;`
3.  **Interactions (Interacciones):** `payable(msg.sender).send(_amount)`
4.  **Effects (Completos):** `balances[msg.sender] -= _amount;` y `isTransfering[msg.sender] = false;`

El problema es que la interacción externa (`send()`) ocurre *antes* de que el estado crítico del contrato (`balances[msg.sender]`) se actualice. Aunque el flag `isTransfering` intenta evitar llamadas concurrentes, no detiene una reentrada dentro de la misma transacción. Un contrato atacante puede "reentrar" en la función `withdraw` después de recibir el Ether de `send()` y antes de que `balances[msg.sender]` se haya reducido y `isTransfering` se haya restablecido a `false`. Esto le permite retirar fondos múltiples veces.

La clave para prevenir la reentrancy es siempre actualizar el estado del contrato *antes* de realizar cualquier llamada externa.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Simular Ataque:** Para ver la vulnerabilidad en acción, necesitarías desplegar un segundo contrato (un contrato atacante) que esté diseñado para realizar el ataque de reentrancy llamando repetidamente a la función `withdraw` de `NoVulnerableRaceCondition`.

# Contrato Inteligente VulnerableRaceCondition (Vulnerabilidad de Condición de Carrera)

Este contrato de Solidity, `VulnerableRaceCondition`, es un ejemplo que ilustra una **vulnerabilidad de condición de carrera** en su función `withdraw`. Aunque intenta detectar una condición de carrera con una verificación final, el orden de las operaciones lo hace susceptible a ataques de reentrancy, donde un atacante puede manipular el estado del contrato.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de seguir el patrón Checks-Effects-Interactions para proteger los fondos en Web3.

## ¿Qué es una Condición de Carrera (Race Condition)?

Una condición de carrera ocurre cuando el resultado de una operación depende de la secuencia o el tiempo de eventos incontrolables. En la blockchain, esto a menudo se manifiesta como un ataque de reentrancy, donde un atacante puede ejecutar código malicioso antes de que el estado del contrato se actualice completamente.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `mapping(address => uint256) public balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con un balance (`uint256`). Se utiliza para llevar un registro de cuánto Ether ha depositado cada usuario en el contrato.

## Funciones del Contrato

### `deposit() public payable`

*   **Propósito:** Permite a los usuarios depositar Ether en el contrato.
*   **Funcionamiento:**
    1.  `public payable`: La función puede ser llamada por cualquiera y puede recibir Ether.
    2.  `balances[msg.sender] += msg.value;`: Añade la cantidad de Ether enviada (`msg.value`) al balance del remitente (`msg.sender`) en el `mapping` `balances`.
    3.  `balance += msg.value;`: Actualiza un balance total del contrato.

### `withdraw(uint256 _amount) public`

*   **Propósito:** Permite a un usuario retirar una cantidad específica de su Ether depositado del contrato.
*   **Parámetros:**
    *   `_amount`: La cantidad de Ether (en Wei) que el usuario desea retirar.
*   **Funcionamiento (Vulnerable a Condición de Carrera):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Verifica que el usuario tenga suficientes fondos para retirar la cantidad solicitada.
    2.  `uint256 lastBalance = balances[msg.sender];`: Guarda el balance actual del remitente. **Este es un intento de verificación, pero se realiza en un momento vulnerable.**
    3.  `balances[msg.sender] -= _amount;`: Reduce el balance del remitente. **Este es el efecto, pero ocurre antes de la interacción externa.**
    4.  `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: **Aquí reside la vulnerabilidad.** El contrato realiza una llamada externa para enviar el Ether al `msg.sender`. Si `msg.sender` es un contrato malicioso, puede ejecutar código arbitrario en este punto y "reentrar" en la función `withdraw`.
    5.  `require(balances[msg.sender] == lastBalance, "Error: Race condition detected");`: **Esta verificación final es ineficaz.** Si un atacante reentra y retira más fondos, `balances[msg.sender]` será menor de lo esperado, pero el ataque ya habrá ocurrido. Además, si el atacante reentra y luego devuelve los fondos, esta verificación podría pasar falsamente como segura.

## ¿Por qué este enfoque es "Vulnerable"?

Este contrato es vulnerable a ataques de **reentrancy** (una forma de condición de carrera) porque no sigue el patrón de seguridad **Checks-Effects-Interactions** de manera estricta. El orden de las operaciones es:

1.  **Checks (Verificaciones):** `require(balances[msg.sender] >= _amount, ...)`
2.  **Effects (Parciales):** `uint256 lastBalance = balances[msg.sender];` y `balances[msg.sender] -= _amount;`
3.  **Interactions (Interacciones):** `payable(msg.sender).send(_amount)`
4.  **Checks (Finales):** `require(balances[msg.sender] == lastBalance, ...)`

El problema es que la interacción externa (`send()`) ocurre *después* de que el balance se reduce, pero *antes* de la verificación final. Un contrato atacante puede "reentrar" en la función `withdraw` después de recibir el Ether de `send()` y antes de que la transacción original termine. Durante esta reentrada, el atacante puede retirar más fondos. La verificación final `require(balances[msg.sender] == lastBalance, ...)` solo detectaría la inconsistencia *después* de que el ataque ya se haya completado, y no lo previene.

La clave para prevenir la reentrancy es siempre actualizar el estado del contrato *antes* de realizar cualquier llamada externa.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Simular Ataque:** Para ver la vulnerabilidad en acción, necesitarías desplegar un segundo contrato (un contrato atacante) que esté diseñado para realizar el ataque de reentrancy llamando repetidamente a la función `withdraw` de `VulnerableRaceCondition`.