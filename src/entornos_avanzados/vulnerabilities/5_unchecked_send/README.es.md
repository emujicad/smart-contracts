# Contrato Inteligente VulnerableUncheckedSend (Vulnerabilidad de Reentrancy con send())

Este contrato de Solidity, `VulnerableUncheckedSend`, es un ejemplo que ilustra una **vulnerabilidad de reentrancy** a pesar de utilizar la función `send()` para transferir Ether. Demuestra que, aunque `send()` es más seguro que `call` en términos de gas reenviado, no previene completamente los ataques de reentrancy si el orden de las operaciones no es el correcto.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de seguir el patrón Checks-Effects-Interactions incluso cuando se utilizan métodos de transferencia de Ether aparentemente más seguros.

## ¿Qué es la Vulnerabilidad de Reentrancy?

La reentrancy ocurre cuando un contrato realiza una llamada externa a otro contrato (o a una dirección de usuario) antes de actualizar su propio estado. Si el contrato externo es malicioso, puede "volver a entrar" en el contrato original y llamar a la función de retiro repetidamente antes de que el estado del contrato original se haya actualizado, drenando así los fondos.

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

### `withdraw(uint256 _amount) public`

*   **Propósito:** Permite a un usuario retirar una cantidad específica de su Ether depositado del contrato.
*   **Parámetros:**
    *   `_amount`: La cantidad de Ether (en Wei) que el usuario desea retirar.
*   **Funcionamiento (Vulnerable a Reentrancy):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Verifica que el usuario tenga suficientes fondos para retirar la cantidad solicitada.
    2.  `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: **Aquí reside la vulnerabilidad.** El contrato realiza una llamada externa para enviar el Ether al `msg.sender` utilizando `send()`. Aunque `send()` solo reenvía 2300 unidades de gas (lo que limita la complejidad del código que el contrato receptor puede ejecutar), no impide que un contrato malicioso "reentre" si el balance no se ha actualizado *antes* de esta llamada.
    3.  `balances[msg.sender] -= _amount;`: Finalmente, el balance del remitente se reduce. Sin embargo, si el contrato malicioso "reentró" antes de esta línea, ya habrá retirado fondos adicionales.

## ¿Por qué este enfoque es "Vulnerable"?

Este contrato es vulnerable a ataques de **reentrancy** porque no sigue el patrón de seguridad **Checks-Effects-Interactions** de manera estricta. El orden de las operaciones es:

1.  **Checks (Verificaciones):** `require(balances[msg.sender] >= _amount, ...)`
2.  **Interactions (Interacciones):** `payable(msg.sender).send(_amount)`
3.  **Effects (Efectos):** `balances[msg.sender] -= _amount;`

El problema es que la interacción externa (`send()`) ocurre *antes* de que el estado del contrato (`balances[msg.sender]`) se actualice. Esto permite que un contrato atacante, al recibir el Ether de la llamada `send()`, "vuelva a entrar" en la función `withdraw` del contrato `VulnerableUncheckedSend` antes de que el balance del atacante se haya reducido a cero. El atacante puede repetir este proceso varias veces, drenando los fondos del contrato.

Aunque `send()` limita el gas reenviado, un atacante aún puede realizar una reentrancy si la lógica de reentrada es lo suficientemente simple como para ejecutarse dentro de ese límite de gas. La clave para prevenir la reentrancy es siempre actualizar el estado del contrato *antes* de realizar cualquier llamada externa.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Simular Ataque:** Para ver la vulnerabilidad en acción, necesitarías desplegar un segundo contrato (un contrato atacante) que esté diseñado para realizar el ataque de reentrancy llamando repetidamente a la función `withdraw` de `VulnerableUncheckedSend`.

# Contrato Inteligente VulnerableUncheckedSend (Vulnerabilidad de Reentrancy con transfer())

Este contrato de Solidity, `VulnerableUncheckedSend`, es un ejemplo que ilustra una **vulnerabilidad de reentrancy** en su función `withdraw`, a pesar de utilizar `transfer()` para enviar Ether. Demuestra que, aunque `transfer()` es un método de envío de Ether más seguro que `call` en ciertos contextos, no previene completamente los ataques de reentrancy si el orden de las operaciones no sigue el patrón de seguridad recomendado.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de seguir el patrón Checks-Effects-Interactions para proteger los fondos en Web3.

## ¿Qué es la Vulnerabilidad de Reentrancy?

La reentrancy ocurre cuando un contrato realiza una llamada externa a otro contrato (o a una dirección de usuario) antes de actualizar su propio estado. Si el contrato externo es malicioso, puede "volver a entrar" en el contrato original y llamar a la función de retiro repetidamente antes de que el estado del contrato original se haya actualizado, drenando así los fondos.

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

### `withdraw(uint256 _amount) public`

*   **Propósito:** Permite a un usuario retirar una cantidad específica de su Ether depositado del contrato.
*   **Parámetros:**
    *   `_amount`: La cantidad de Ether (en Wei) que el usuario desea retirar.
*   **Funcionamiento (Vulnerable a Reentrancy):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Verifica que el usuario tenga suficientes fondos para retirar la cantidad solicitada.
    2.  `payable(msg.sender).transfer(_amount);`: **Aquí reside la vulnerabilidad.** El contrato realiza una llamada externa para enviar el Ether al `msg.sender` utilizando `transfer()`. Aunque `transfer()` solo reenvía 2300 unidades de gas (lo que limita la complejidad del código que el contrato receptor puede ejecutar), no impide que un contrato malicioso "reentre" si el balance no se ha actualizado *antes* de esta llamada.
    3.  `balances[msg.sender] -= _amount;`: Finalmente, el balance del remitente se reduce. Sin embargo, si el contrato malicioso "reentró" antes de esta línea, ya habrá retirado fondos adicionales.

## ¿Por qué este enfoque es "Vulnerable"?

Este contrato es vulnerable a ataques de **reentrancy** porque no sigue el patrón de seguridad **Checks-Effects-Interactions** de manera estricta. El orden de las operaciones es:

1.  **Checks (Verificaciones):** `require(balances[msg.sender] >= _amount, ...)`
2.  **Interactions (Interacciones):** `payable(msg.sender).transfer(_amount)`
3.  **Effects (Efectos):** `balances[msg.sender] -= _amount;`

El problema es que la interacción externa (`transfer()`) ocurre *antes* de que el estado del contrato (`balances[msg.sender]`) se actualice. Esto permite que un contrato atacante, al recibir el Ether de la llamada `transfer()`, "vuelva a entrar" en la función `withdraw` del contrato `VulnerableUncheckedSend` antes de que el balance del atacante se haya reducido a cero. El atacante puede repetir este proceso varias veces, drenando los fondos del contrato.

Aunque `transfer()` limita el gas reenviado, un atacante aún puede realizar una reentrancy si la lógica de reentrada es lo suficientemente simple como para ejecutarse dentro de ese límite de gas. La clave para prevenir la reentrancy es siempre actualizar el estado del contrato *antes* de realizar cualquier llamada externa.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Simular Ataque:** Para ver la vulnerabilidad en acción, necesitarías desplegar un segundo contrato (un contrato atacante) que esté diseñado para realizar el ataque de reentrancy llamando repetidamente a la función `withdraw` de `VulnerableUncheckedSend`.