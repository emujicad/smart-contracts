# Contrato Inteligente NoVulnerableAccessControl (Control de Acceso Seguro)

Este contrato de Solidity, `NoVulnerableAccessControl`, es un ejemplo que demuestra cómo implementar un control de acceso seguro en un contrato inteligente. Utiliza el patrón `onlyOwner` (solo el propietario) para restringir la ejecución de ciertas funciones a una única dirección autorizada, previniendo así accesos no deseados.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular ilustra una práctica fundamental de seguridad: asegurar que solo las entidades autorizadas puedan realizar acciones críticas.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `uint private secretNumber;`

Una variable privada que almacena un número secreto. Su valor solo puede ser modificado por el propietario del contrato.

### `address private owner;`

Esta variable almacena la dirección de la cuenta que desplegó el contrato. Esta dirección será el `owner` (propietario) y tendrá permisos especiales.

### `constructor() { ... }`

El `constructor` es una función especial que se ejecuta una única vez cuando el contrato se despliega. Aquí, se inicializa el `owner`:

*   `owner = msg.sender;`: Establece al desplegador del contrato (`msg.sender`) como el `owner` inicial. `msg.sender` es una variable global que siempre se refiere a la dirección que inició la transacción.

### `modifier onlyOwner() { ... }`

Un `modifier` (modificador) es una pieza de código que se puede adjuntar a las funciones para cambiar su comportamiento de manera declarativa. El modificador `onlyOwner` es un patrón de seguridad muy común:

*   `require(msg.sender == owner, "Error. Only Owner can use this function");`: Esta línea es la clave del control de acceso. `require` verifica una condición y, si es falsa, revierte toda la transacción. Aquí, asegura que la dirección que llama a la función (`msg.sender`) sea exactamente la misma que la dirección del `owner`.
*   `_;`: Esta parte especial del modificador indica dónde se insertará el código de la función a la que se aplica el modificador. Si la condición `require` pasa, el código de la función se ejecuta; de lo contrario, la transacción se revierte.

## Funciones del Contrato

### `setSecretNumber(uint _newNumber) public onlyOwner`

*   **Propósito:** Permite al propietario del contrato establecer un nuevo valor para `secretNumber`.
*   **Parámetros:**
    *   `_newNumber`: El nuevo número secreto a establecer.
*   **Funcionamiento:** Gracias al modificador `onlyOwner`, solo la dirección del `owner` puede llamar a esta función y cambiar el `secretNumber`. Si otra dirección intenta llamarla, la transacción fallará con el mensaje de error especificado en el `require` del modificador.

### `getSecretNumber() public view returns (uint)`

*   **Propósito:** Permite a cualquier persona leer el valor actual de `secretNumber`.
*   **Funcionamiento:** Esta función es `public` y `view`, lo que significa que no modifica el estado del contrato y puede ser llamada por cualquiera sin costo de gas para obtener el valor de `secretNumber`.

## ¿Por qué este enfoque es "No Vulnerable"?

Este contrato implementa un control de acceso básico pero efectivo. Al usar el modificador `onlyOwner`, se asegura que las funciones críticas (como `setSecretNumber`) solo puedan ser ejecutadas por la dirección autorizada. Esto previene que usuarios no autorizados modifiquen datos sensibles o realicen acciones privilegiadas, lo cual es una vulnerabilidad común en contratos sin un control de acceso adecuado.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba), la cuenta que lo despliega se convierte en el `owner`.
2.  **Establecer Número Secreto (como Owner):** El `owner` puede llamar a `setSecretNumber()` para cambiar el valor de `secretNumber`.
3.  **Intentar Establecer Número Secreto (como No-Owner):** Si otra cuenta intenta llamar a `setSecretNumber()`, la transacción fallará, demostrando el control de acceso.
4.  **Obtener Número Secreto (cualquiera):** Cualquier cuenta puede llamar a `getSecretNumber()` para leer el valor actual.

# Contrato Inteligente VulnerableAccessControl (Vulnerabilidad de Control de Acceso)

Este contrato de Solidity, `VulnerableAccessControl`, es un ejemplo que ilustra una **vulnerabilidad crítica** en el control de acceso. Demuestra cómo la falta de restricciones adecuadas en funciones importantes puede permitir que cualquier usuario no autorizado modifique datos sensibles o realice acciones privilegiadas.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de implementar un control de acceso robusto en Web3.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `uint private secretNumber;`

Una variable privada que almacena un número secreto. La intención es que solo el propietario pueda modificarla, pero la implementación es defectuosa.

### `address public owner;`

Esta variable almacena la dirección de la cuenta que desplegó el contrato. Aunque existe un `owner`, no se utiliza para restringir el acceso a funciones críticas.

### `constructor() { ... }`

El `constructor` es una función especial que se ejecuta una única vez cuando el contrato se despliega. Aquí, se inicializa el `owner`:

*   `owner = msg.sender;`: Establece al desplegador del contrato (`msg.sender`) como el `owner` inicial.

## Funciones del Contrato

### `setSecretNumber(uint _newNumber) public`

*   **Propósito:** Permite establecer un nuevo valor para `secretNumber`.
*   **Parámetros:**
    *   `_newNumber`: El nuevo número secreto a establecer.
*   **Funcionamiento:** Esta función es `public`, lo que significa que **cualquier persona** puede llamarla. No hay ninguna restricción (como un modificador `onlyOwner`) que impida que una dirección no autorizada cambie el valor de `secretNumber`.

### `getSecretNumber() public view returns (uint)`

*   **Propósito:** Permite a cualquier persona leer el valor actual de `secretNumber`.
*   **Funcionamiento:** Esta función es `public` y `view`, lo que significa que no modifica el estado del contrato y puede ser llamada por cualquiera sin costo de gas para obtener el valor de `secretNumber`.

## ¿Por qué este enfoque es "Vulnerable"?

La vulnerabilidad principal de este contrato radica en la función `setSecretNumber`. Al ser una función `public` sin ninguna restricción de acceso, cualquier persona puede llamar a esta función y cambiar el valor de `secretNumber` a su antojo. Esto significa que un dato que debería ser controlado por una entidad específica (el `owner`) puede ser manipulado por cualquiera.

En un escenario real, esto podría llevar a:

*   **Manipulación de datos:** Si `secretNumber` controla alguna lógica crítica o un valor importante, un atacante podría cambiarlo para su beneficio.
*   **Pérdida de control:** El propietario del contrato pierde el control exclusivo sobre este dato.
*   **Comportamiento inesperado:** El contrato podría comportarse de manera impredecible si `secretNumber` es modificado por actores maliciosos.

Para evitar esta vulnerabilidad, funciones como `setSecretNumber` que modifican el estado crítico del contrato deberían estar protegidas con un control de acceso, como el modificador `onlyOwner` o un sistema de roles más complejo.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Establecer Número Secreto (como Owner):** El `owner` puede llamar a `setSecretNumber()` para cambiar el valor de `secretNumber`.
3.  **Establecer Número Secreto (como No-Owner):** Cualquier otra cuenta puede llamar a `setSecretNumber()` y cambiar el valor de `secretNumber`, demostrando la vulnerabilidad.