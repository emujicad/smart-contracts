# Contrato Inteligente NoVulnerableReentrancy (Prevención de Reentrancy)

Este contrato de Solidity, `NoVulnerableReentrancy`, es un ejemplo que demuestra cómo prevenir la vulnerabilidad de reentrancy en un contrato inteligente. Implementa un patrón de retiro seguro que protege los fondos del contrato de ataques maliciosos.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular ilustra una de las vulnerabilidades más conocidas en Solidity y cómo evitarla, lo cual es crucial para la seguridad de los fondos en Web3.

## ¿Qué es la Vulnerabilidad de Reentrancy?

La reentrancy ocurre cuando un contrato realiza una llamada externa a otro contrato (o a una dirección de usuario) antes de actualizar su propio estado. Si el contrato externo es malicioso, puede "volver a entrar" en el contrato original y llamar a la función de retiro repetidamente antes de que el estado del contrato original se haya actualizado, drenando así los fondos.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `mapping(address => uint256) public balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con un balance (`uint256`). Se utiliza para llevar un registro de cuánto Ether ha depositado cada usuario en el contrato.

## Funciones del Contrato

### `deposit() external payable`

*   **Propósito:** Permite a los usuarios depositar Ether en el contrato.
*   **Funcionamiento:**
    1.  `external payable`: La función puede ser llamada desde fuera del contrato y puede recibir Ether.
    2.  `balances[msg.sender] += msg.value;`: Añade la cantidad de Ether enviada (`msg.value`) al balance del remitente (`msg.sender`) en el `mapping` `balances`.

### `withdraw(uint256 _amount) public`

*   **Propósito:** Permite a un usuario retirar una cantidad específica de su Ether depositado del contrato.
*   **Parámetros:**
    *   `_amount`: La cantidad de Ether (en Wei) que el usuario desea retirar.
*   **Funcionamiento (Patrón Checks-Effects-Interactions):
    1.  **Checks (Verificaciones):**
        *   `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Verifica que el usuario tenga suficientes fondos para retirar la cantidad solicitada.
    2.  **Effects (Efectos):**
        *   `balances[msg.sender] -= _amount;`: **Esta es la clave para prevenir la reentrancy.** El balance del usuario se actualiza (se reduce) *antes* de realizar la llamada externa para enviar el Ether. Esto asegura que, incluso si la llamada externa intenta "volver a entrar" en el contrato, el balance del atacante ya se habrá reducido, impidiendo retiros adicionales.
    3.  **Interactions (Interacciones):**
        *   `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: Intenta enviar el Ether al `msg.sender` utilizando `send()`. `send()` es un método de bajo nivel que reenvía una cantidad fija de gas (2300 gas) y devuelve un booleano indicando el éxito o fracaso. Si la transferencia falla, la transacción se revierte debido al `require`.

## ¿Por qué este enfoque es "No Vulnerable"?

Este contrato es seguro contra ataques de reentrancy porque sigue el patrón de seguridad conocido como **Checks-Effects-Interactions**:

1.  **Checks (Verificaciones):** Se realizan todas las validaciones necesarias (ej. `require` para verificar el balance).
2.  **Effects (Efectos):** Se actualiza el estado del contrato (ej. `balances[msg.sender] -= _amount;`). **Esto se hace antes de cualquier interacción externa.**
3.  **Interactions (Interacciones):** Finalmente, se realiza la llamada externa (ej. `payable(msg.sender).send(_amount);`).

Al actualizar el balance del usuario *antes* de enviar el Ether, el contrato se protege de un atacante que intente llamar a `withdraw` varias veces en una sola transacción. Cuando el atacante intenta "volver a entrar", su balance ya se ha reducido, y la verificación inicial (`require(balances[msg.sender] >= _amount, ...)`) fallará, impidiendo el ataque.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Retirar Ether:** Llama a la función `withdraw(cantidad)` para retirar una cantidad específica de tu Ether depositado.

# Contrato Inteligente VulnerableReentrancy (Vulnerabilidad de Reentrancy)

Este contrato de Solidity, `VulnerableReentrancy`, es un ejemplo que ilustra una **vulnerabilidad crítica** conocida como reentrancy. Demuestra cómo una implementación incorrecta de una función de retiro puede permitir a un atacante drenar repetidamente los fondos del contrato.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de seguir patrones de seguridad al interactuar con contratos externos o direcciones de usuario.

## ¿Qué es la Vulnerabilidad de Reentrancy?

La reentrancy ocurre cuando un contrato realiza una llamada externa a otro contrato (o a una dirección de usuario) antes de actualizar su propio estado. Si el contrato externo es malicioso, puede "volver a entrar" en el contrato original y llamar a la función de retiro repetidamente antes de que el estado del contrato original se haya actualizado, drenando así los fondos.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `mapping(address => uint256) private balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con un balance (`uint256`). Se utiliza para llevar un registro de cuánto Ether ha depositado cada usuario en el contrato.

## Funciones del Contrato

### `deposit() external payable`

*   **Propósito:** Permite a los usuarios depositar Ether en el contrato.
*   **Funcionamiento:**
    1.  `external payable`: La función puede ser llamada desde fuera del contrato y puede recibir Ether.
    2.  `balances[msg.sender] += msg.value;`: Añade la cantidad de Ether enviada (`msg.value`) al balance del remitente (`msg.sender`) en el `mapping` `balances`.

### `withdraw(uint256 _amount) public`

*   **Propósito:** Permite a un usuario retirar una cantidad específica de su Ether depositado del contrato.
*   **Parámetros:**
    *   `_amount`: La cantidad de Ether (en Wei) que el usuario desea retirar.
*   **Funcionamiento (Vulnerable a Reentrancy):**
    1.  `require(_amount <= balances[msg.sender], "Error: There is not found to withdraw");`: Verifica que el usuario tenga suficientes fondos para retirar la cantidad solicitada.
    2.  `(bool success, ) = msg.sender.call{value: _amount}("");`: **Aquí reside la vulnerabilidad.** El contrato realiza una llamada externa para enviar el Ether al `msg.sender` *antes* de actualizar el balance del remitente. Si `msg.sender` es un contrato malicioso, puede ejecutar código arbitrario en este punto.
    3.  `require(success, "Error: Transfer failed");`: Verifica que la transferencia haya sido exitosa.
    4.  `balances[msg.sender] -= _amount;`: Finalmente, el balance del remitente se reduce. Sin embargo, si el contrato malicioso "reentró" antes de esta línea, ya habrá retirado fondos adicionales.

## ¿Por qué este enfoque es "Vulnerable"?

Este contrato es vulnerable a ataques de **reentrancy** debido al orden de las operaciones en la función `withdraw`. El patrón de seguridad recomendado es **Checks-Effects-Interactions**:

1.  **Checks (Verificaciones):** Realizar todas las validaciones necesarias.
2.  **Effects (Efectos):** Actualizar el estado del contrato (ej. reducir el balance del usuario).
3.  **Interactions (Interacciones):** Realizar llamadas externas.

En este contrato, el orden es **Checks-Interactions-Effects**. Esto permite que un contrato atacante, al recibir el Ether de la llamada externa (`msg.sender.call`), "vuelva a entrar" en la función `withdraw` del contrato `VulnerableReentrancy` antes de que el balance del atacante se haya reducido a cero. El atacante puede repetir este proceso varias veces, drenando los fondos del contrato.

**Escenario de Ataque:**
1.  Un atacante deposita Ether en `VulnerableReentrancy`.
2.  El atacante llama a `withdraw` desde un contrato malicioso.
3.  `VulnerableReentrancy` verifica el balance y luego envía Ether al contrato malicioso (`msg.sender.call{value: _amount}("");`).
4.  El contrato malicioso, en su función `receive` o `fallback`, llama de nuevo a `withdraw` en `VulnerableReentrancy`.
5.  Como el balance del atacante en `VulnerableReentrancy` aún no se ha reducido (la línea `balances[msg.sender] -= _amount;` aún no se ha ejecutado), la verificación inicial (`require(_amount <= balances[msg.sender], ...)`) pasa de nuevo.
6.  El ciclo se repite, permitiendo al atacante retirar más Ether del que debería, hasta que el contrato `VulnerableReentrancy` se quede sin fondos o el gas se agote.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Simular Ataque:** Para ver la vulnerabilidad en acción, necesitarías desplegar un segundo contrato (un contrato atacante) que esté diseñado para realizar el ataque de reentrancy llamando repetidamente a la función `withdraw` de `VulnerableReentrancy`.