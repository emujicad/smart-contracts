# Contrato Inteligente OptimizedContract (Optimización con Yul)

Este contrato de Solidity, `OptimizedContract`, es un ejemplo educativo que compara la eficiencia en el uso de gas entre el código Solidity estándar y su equivalente implementado utilizando Yul (lenguaje de ensamblaje de la EVM - Ethereum Virtual Machine). El objetivo es mostrar cómo el uso directo de Yul puede, en ciertos casos, llevar a optimizaciones de gas significativas.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular se enfoca en cómo se puede escribir código más eficiente para reducir los costos de transacción (gas).

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.20;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.20` significa que el contrato compilará con versiones desde 0.8.20 hasta la próxima versión mayor (ej. 0.9.0).

### `assembly { ... }` (Yul)

El bloque `assembly { ... }` permite escribir código directamente en Yul, el lenguaje de ensamblaje de bajo nivel de la Ethereum Virtual Machine (EVM). Esto da un control mucho más fino sobre cómo se ejecutan las operaciones, lo que puede ser útil para optimizar el uso de gas, aunque a costa de una mayor complejidad y un mayor riesgo de errores.

### `pure`

Las funciones marcadas como `pure` no modifican el estado de la blockchain ni leen ninguna variable de estado. Solo operan con los parámetros de entrada y variables locales. Son las funciones más baratas de ejecutar en términos de gas.

## Comparación de Funciones (Solidity vs. Yul)

El contrato `OptimizedContract` presenta pares de funciones que realizan la misma operación, una en Solidity y otra en Yul, para comparar su consumo de gas.

### Suma de dos números (`soliditysum` vs. `yul_sum`)

*   **`soliditysum(uint256 _a, uint256 _b)`**: Realiza una suma simple en Solidity (`_a + _b`).
*   **`yul_sum(uint256 _a, uint256 _b)`**: Utiliza el opcode `add` de Yul para realizar la suma. `result := add(_a, _b)` asigna el resultado de la suma a la variable `result`.

### Hashing (`solidityHash` vs. `yulHash`)

*   **`solidityHash(uint256 _a, uint256 _b)`**: Utiliza `keccak256(abi.encode(_a, _b))` para calcular el hash Keccak-256 de dos números. `abi.encode` empaqueta los valores para el hashing.
*   **`yulHash(uint256 _a, uint256 _b)`**: Realiza el hashing utilizando opcodes de Yul:
    *   `mstore(0x00, _a)`: Almacena el valor de `_a` en la posición de memoria `0x00`.
    *   `mstore(0x20, _b)`: Almacena el valor de `_b` en la posición de memoria `0x20` (justo después de `_a`, ya que `uint256` ocupa 32 bytes o `0x20` en hexadecimal).
    *   `let hash := keccak256(0x00, 0x40)`: Calcula el hash Keccak-256 de los 64 bytes (0x40) de memoria que comienzan en `0x00`.

### Bucle `for` (`solidityuncheckedPusPlusI` vs. `yuluncheckedPusPlusI`)

*   **`solidityuncheckedPusPlusI()`**: Un bucle `for` en Solidity que utiliza `unchecked { ++i; }` para evitar la verificación de desbordamiento/subdesbordamiento, lo que puede ahorrar gas.
*   **`yuluncheckedPusPlusI()`**: Implementa un bucle `for` directamente en Yul, con un control explícito de las variables `i` y `j` usando `add` y `lt` (less than).

### Resta con verificación de desbordamiento (`soliditySubTest` vs. `yulSubTest`)

*   **`soliditySubTest(uint256 _a, uint256 _b)`**: Realiza una resta simple en Solidity. En versiones modernas de Solidity (>=0.8.0), las operaciones aritméticas verifican automáticamente los desbordamientos/subdesbordamientos, lo que añade un costo de gas.
*   **`yulSubTest(uint256 _a, uint256 _b)`**: Realiza la resta con `sub(_a, _b)` en Yul. Luego, incluye una verificación manual de subdesbordamiento (`if gt(c, _a)`) y revierte la transacción si ocurre, demostrando cómo se puede implementar la seguridad manualmente en Yul.

### Actualización de variable de estado (`solidityUpdateOwner` vs. `yulUpdateOwner`)

*   **`solidityUpdateOwner(address newOwner)`**: Actualiza una variable de estado `owner` en Solidity (`owner = newOwner;`).
*   **`yulUpdateOwner(address newOwner)`**: Utiliza el opcode `sstore` de Yul para almacenar directamente el valor de `newOwner` en el slot de almacenamiento de `owner`. `owner.slot` es una característica de Solidity que permite acceder al slot de almacenamiento de una variable.

## ¿Por qué usar Yul?

El uso de Yul puede ser beneficioso para:

*   **Optimización de Gas:** Reducir los costos de transacción en operaciones críticas.
*   **Control Fino:** Tener un control preciso sobre cómo se ejecutan las operaciones en la EVM.
*   **Funcionalidades Avanzadas:** Implementar lógicas que son difíciles o imposibles de expresar directamente en Solidity.

Sin embargo, Yul es más complejo, propenso a errores y requiere un conocimiento profundo de la EVM. Generalmente, se recomienda usar Solidity para la mayor parte del código y recurrir a Yul solo para bloques de código muy específicos donde la optimización de gas es crucial.