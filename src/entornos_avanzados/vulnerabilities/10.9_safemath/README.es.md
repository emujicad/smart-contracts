# Biblioteca SafeMath (Operaciones Aritméticas Seguras)

Esta biblioteca de Solidity, `SafeMath`, proporciona funciones para realizar operaciones aritméticas (suma y resta) de manera segura, previniendo las vulnerabilidades de overflow (desbordamiento) y underflow (subdesbordamiento). Es una herramienta esencial para escribir contratos inteligentes robustos, especialmente en versiones de Solidity anteriores a la 0.8.0.

## ¿Qué es una Biblioteca (Library) en Solidity?

Una `library` en Solidity es un tipo especial de contrato que contiene funciones que pueden ser reutilizadas por otros contratos. Las funciones de una biblioteca son `internal` por defecto y se ejecutan en el contexto del contrato que las llama, lo que significa que no tienen su propio almacenamiento de estado. Esto las hace muy eficientes en términos de gas.

## ¿Qué son Overflow y Underflow?

*   **Overflow (Desbordamiento):** Ocurre cuando el resultado de una operación aritmética es mayor que el valor máximo que puede almacenar el tipo de dato. Por ejemplo, si un `uint256` (que puede almacenar hasta `2^256 - 1`) intenta almacenar un valor mayor, el valor "envuelve" y se convierte en un número muy pequeño.
*   **Underflow (Subdesbordamiento):** Ocurre cuando el resultado de una operación aritmética es menor que el valor mínimo que puede almacenar el tipo de dato. Por ejemplo, si un `uint256` (que puede almacenar desde 0) intenta almacenar un valor negativo, el valor "envuelve" y se convierte en un número muy grande.

En Solidity, un overflow o underflow no controlado puede llevar a comportamientos inesperados, manipulación de saldos, o incluso la pérdida de fondos.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.0` significa que la biblioteca compilará con versiones desde 0.8.0 hasta la próxima versión mayor (ej. 0.9.0). Es importante destacar que a partir de Solidity 0.8.0, las operaciones aritméticas por defecto revierten en caso de overflow/underflow, haciendo que `SafeMath` sea menos necesario para versiones más recientes, pero sigue siendo una buena práctica para versiones anteriores o para una claridad explícita.

### `library SafeMath { ... }`

Define la biblioteca `SafeMath`.

### `internal pure`

*   `internal`: Significa que las funciones solo pueden ser llamadas desde dentro de la biblioteca o desde contratos que la utilizan.
*   `pure`: Indica que las funciones no modifican el estado de la blockchain ni leen ninguna variable de estado. Solo operan con los parámetros de entrada y variables locales.

## Funciones de la Biblioteca

### `add(uint256 a, uint256 b) internal pure returns (uint256)`

*   **Propósito:** Realiza una suma segura de dos números `uint256`.
*   **Parámetros:**
    *   `a`: El primer operando.
    *   `b`: El segundo operando.
*   **Funcionamiento:**
    1.  `uint256 c = a + b;`: Realiza la suma.
    2.  `require(c >= a, "SafeMath: addition overflow");`: **Aquí reside la seguridad.** Verifica que el resultado `c` sea mayor o igual que `a`. Si `c` es menor que `a`, significa que ha ocurrido un overflow (el valor ha "envuelto"), y la transacción se revertirá con el mensaje de error especificado.
    3.  `return c;`: Si no hay overflow, devuelve el resultado de la suma.

### `sub(uint256 a, uint256 b) internal pure returns (uint256)`

*   **Propósito:** Realiza una resta segura de dos números `uint256`.
*   **Parámetros:**
    *   `a`: El minuendo.
    *   `b`: El sustraendo.
*   **Funcionamiento:**
    1.  `require(b <= a, "SafeMath: subtraction overflow");`: **Aquí reside la seguridad.** Verifica que `b` sea menor o igual que `a`. Si `b` es mayor que `a`, significa que el resultado sería negativo, lo que causaría un underflow para un `uint256`. La transacción se revertirá con el mensaje de error especificado.
    2.  `uint256 c = a - b;`: Realiza la resta.
    3.  `return c;`: Si no hay underflow, devuelve el resultado de la resta.

## ¿Por qué esta biblioteca es importante?

Antes de Solidity 0.8.0, las operaciones aritméticas no incluían verificaciones automáticas de overflow/underflow. Esto significaba que los desarrolladores debían implementar estas verificaciones manualmente o usar bibliotecas como `SafeMath` para garantizar la seguridad de sus contratos. `SafeMath` se convirtió en un estándar de facto para prevenir estos errores críticos.

Aunque en Solidity 0.8.0 y posteriores el compilador añade estas verificaciones por defecto, `SafeMath` sigue siendo útil para:

*   **Compatibilidad:** Trabajar con bases de código más antiguas.
*   **Claridad Explícita:** Hacer explícito que se están realizando operaciones seguras.
*   **Operaciones `unchecked`:** Si un desarrollador usa un bloque `unchecked { ... }` para ahorrar gas, aún podría usar `SafeMath` dentro de ese bloque para operaciones específicas que requieran seguridad.

## ¿Cómo usar esta biblioteca?

Para usar `SafeMath` en tu contrato, primero debes importarla y luego usar la palabra clave `using` para adjuntarla a un tipo de dato, por ejemplo:

```solidity
import "./10.9_safemath.sol";

contract MyContract {
    using SafeMath for uint256; // Adjunta SafeMath a uint256

    uint256 public myValue;

    function addSafely(uint256 _val) public {
        myValue = myValue.add(_val); // Usa la función add de SafeMath
    }

    function subSafely(uint256 _val) public {
        myValue = myValue.sub(_val); // Usa la función sub de SafeMath
    }
}
```