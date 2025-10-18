# Contrato Inteligente NoVulnerableFallBack (Manejo Seguro de Ether)

Este contrato de Solidity, `NoVulnerableFallBack`, es un ejemplo que demuestra una forma segura de manejar la recepción de Ether en un contrato inteligente. Se enfoca en cómo evitar vulnerabilidades relacionadas con las funciones `fallback` y `receive`, asegurando que el Ether solo se reciba de manera intencionada y controlada.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular ilustra las mejores prácticas para la gestión de Ether, un aspecto crucial para la seguridad de los fondos en Web3.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `mapping(address => uint256) private balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con un balance (`uint256`). Se utiliza para llevar un registro de cuánto Ether ha depositado cada usuario en el contrato.

### `fallback() external payable { ... }`

La función `fallback` es una función especial que se ejecuta cuando un contrato recibe Ether y no hay datos de llamada, o cuando los datos de llamada no coinciden con ninguna otra función del contrato. En este contrato, la función `fallback` está diseñada para **revertir** cualquier intento de enviar Ether de forma inesperada:

*   `revert("Error: This funtion is not enabled to receive payments");`: Esto asegura que si alguien envía Ether al contrato sin especificar una función válida, la transacción fallará y el Ether será devuelto. Esto previene depósitos accidentales o no deseados.

### `receive() external payable { ... }`

La función `receive` es otra función especial, introducida en Solidity 0.6.0. Se ejecuta específicamente cuando un contrato recibe Ether sin datos de llamada (es decir, una transferencia de Ether "simple").

*   En este contrato, la función `receive` está vacía (`{}`). Esto significa que el contrato **puede recibir Ether** a través de transferencias directas (sin datos de llamada), pero no realiza ninguna lógica adicional. Esto es útil si el contrato necesita recibir Ether para su funcionamiento interno, pero no quiere que se active la lógica de `fallback`.

## Funciones del Contrato

### `deposit() external payable`

*   **Propósito:** Permite a los usuarios depositar Ether en el contrato.
*   **Funcionamiento:**
    1.  `external payable`: La función puede ser llamada desde fuera del contrato y puede recibir Ether.
    2.  `balances[msg.sender] += msg.value;`: Añade la cantidad de Ether enviada (`msg.value`) al balance del remitente (`msg.sender`) en el `mapping` `balances`.

### `withdraw() public`

*   **Propósito:** Permite a un usuario retirar su Ether depositado del contrato.
*   **Funcionamiento:**
    1.  `uint256 amount = balances[msg.sender];`: Obtiene la cantidad de Ether que el remitente tiene disponible para retirar.
    2.  `require(amount > 0, "Error: There is not found to withdraw");`: Verifica que el usuario tenga fondos para retirar.
    3.  `balances[msg.sender] = 0;`: Resetea el balance del usuario a cero para evitar retiros dobles (reentrancy).
    4.  `(bool success, ) = msg.sender.call{value: amount}("");`: Intenta enviar el Ether al `msg.sender` utilizando `call`. Este es un método seguro para enviar Ether porque reenvía una cantidad fija de gas (2300 gas) y devuelve un booleano `success` indicando si la transferencia fue exitosa. Si la transferencia falla, el contrato no se detiene, pero podemos verificar el resultado.
    5.  `require(success, "Error: Transfer failed");`: Verifica que la transferencia de Ether haya sido exitosa. Si no lo fue, revierte la transacción.

## ¿Por qué este enfoque es "No Vulnerable"?

Este contrato es seguro porque:

*   **Control de Depósitos:** La función `fallback` revierte explícitamente, evitando que Ether no intencionado se quede "atrapado" en el contrato sin una lógica clara para su manejo. La función `receive` permite depósitos directos si son necesarios, pero sin lógica compleja que pueda ser explotada.
*   **Retiros Seguros:** La función `withdraw` utiliza el patrón "Checks-Effects-Interactions" (Verificaciones-Efectos-Interacciones):
    1.  **Verificaciones:** `require(amount > 0, ...)`
    2.  **Efectos:** `balances[msg.sender] = 0;` (actualiza el estado *antes* de la interacción externa)
    3.  **Interacciones:** `msg.sender.call{value: amount}("");`
    Este patrón es crucial para prevenir ataques de reentrancy, donde un atacante podría llamar repetidamente a la función `withdraw` antes de que el balance se actualice a cero.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Depositar Ether:** Llama a la función `deposit()` y envía Ether junto con la transacción.
3.  **Retirar Ether:** Llama a la función `withdraw()` para recuperar tu Ether depositado.

# Contrato Inteligente VulnerableFallBack (Vulnerabilidad en Fallback)

Este contrato de Solidity, `VulnerableFallBack`, es un ejemplo que ilustra una **vulnerabilidad crítica** relacionada con la función `fallback`. Demuestra cómo una implementación incorrecta de esta función puede llevar a ataques de reentrancy, permitiendo a un atacante retirar fondos repetidamente de manera no autorizada.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre los peligros de no seguir las mejores prácticas de seguridad al manejar Ether.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `mapping(address => uint256) private balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con un balance (`uint256`). Se utiliza para llevar un registro de cuánto Ether ha depositado cada usuario en el contrato.

### `fallback() external payable { ... }`

La función `fallback` es una función especial que se ejecuta cuando un contrato recibe Ether y no hay datos de llamada, o cuando los datos de llamada no coinciden con ninguna otra función del contrato. En este contrato, la función `fallback` es la fuente de la vulnerabilidad:

*   `balances[msg.sender] += msg.value;`: Esta línea actualiza el balance del remitente con el Ether recibido. Hasta aquí, parece inofensivo.
*   `(bool success, ) = msg.sender.call{value: msg.value}("");`: **Aquí reside la vulnerabilidad.** Inmediatamente después de actualizar el balance, el contrato intenta enviar el mismo `msg.value` de vuelta al `msg.sender`. Si el `msg.sender` es otro contrato malicioso, este puede tener una función `receive` o `fallback` que, al recibir el Ether, llama de nuevo a la función `withdraw` (o incluso a la `fallback` misma) de `VulnerableFallBack` antes de que el balance del atacante se haya puesto a cero. Esto permite un retiro repetido de fondos.
*   `require(success, "Error: Transfer failed");`: Verifica que la transferencia haya sido exitosa.

### `receive() external payable { ... }`

La función `receive` está presente pero vacía. Esto significa que el contrato puede recibir Ether directamente sin activar la lógica de `fallback` si se envía Ether sin datos de llamada. Sin embargo, la vulnerabilidad principal está en la `fallback`.

## Funciones del Contrato

### `withdraw() public`

*   **Propósito:** Permite a un usuario retirar su Ether depositado del contrato.
*   **Funcionamiento:**
    1.  `uint256 amount = balances[msg.sender];`: Obtiene la cantidad de Ether que el remitente tiene disponible para retirar.
    2.  `require(amount > 0, "Error: There is not found to withdraw");`: Verifica que el usuario tenga fondos para retirar.
    3.  `balances[msg.sender] = 0;`: Resetea el balance del usuario a cero. **En un contrato vulnerable a reentrancy, esta línea debería ejecutarse *antes* de la transferencia externa.**
    4.  `(bool success, ) = msg.sender.call{value: amount}("");`: Intenta enviar el Ether al `msg.sender`.
    5.  `require(success, "Error: Transfer failed");`: Verifica que la transferencia de Ether haya sido exitosa.

## ¿Por qué este enfoque es "Vulnerable"?

La vulnerabilidad principal de este contrato es el ataque de **reentrancy** en la función `fallback`. Cuando un contrato malicioso llama a `VulnerableFallBack` y envía Ether, la función `fallback` se activa. Dentro de `fallback`, el contrato `VulnerableFallBack` envía Ether de vuelta al contrato malicioso *antes* de que el balance del atacante se haya actualizado a cero.

El contrato atacante puede tener una función `receive` o `fallback` que, al recibir el Ether, llama de nuevo a `VulnerableFallBack` para retirar más fondos. Este ciclo puede repetirse varias veces, vaciando el contrato `VulnerableFallBack` de su Ether, ya que el balance del atacante no se pone a cero hasta que la primera llamada a `fallback` (o `withdraw`) termina.

Para prevenir esto, se debe seguir el patrón "Checks-Effects-Interactions":
1.  **Verificaciones** (Checks): `require(...)`
2.  **Efectos** (Effects): Actualizar el estado del contrato (ej. `balances[msg.sender] = 0;`)
3.  **Interacciones** (Interactions): Realizar llamadas externas (ej. `msg.sender.call{value: amount}("");`)

En este contrato, la interacción externa ocurre *antes* de que el balance se ponga a cero en la función `withdraw`, y la función `fallback` también realiza una interacción externa inmediatamente después de un efecto parcial, lo que la hace vulnerable.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Enviar Ether:** Envía Ether directamente al contrato `VulnerableFallBack` (esto activará la función `fallback`).
3.  **Simular Ataque:** Para ver la vulnerabilidad en acción, necesitarías desplegar un segundo contrato (un contrato atacante) que esté diseñado para realizar el ataque de reentrancy llamando repetidamente a la función `fallback` o `withdraw` de `VulnerableFallBack`.