# Contrato Inteligente NoVulnerableOverflowAndUnderflow (Prevención de Overflow/Underflow)

Este contrato de Solidity, `NoVulnerableOverflowAndUnderflow`, es un ejemplo que demuestra cómo prevenir las vulnerabilidades de overflow (desbordamiento) y underflow (subdesbordamiento) en operaciones aritméticas. Utiliza la biblioteca `SafeMath` para realizar sumas y restas de manera segura, asegurando que los resultados permanezcan dentro de los límites de los tipos de datos.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular ilustra una práctica de seguridad fundamental para evitar errores aritméticos que pueden tener consecuencias graves en los contratos inteligentes.

## ¿Qué son Overflow y Underflow?

*   **Overflow (Desbordamiento):** Ocurre cuando el resultado de una operación aritmética es mayor que el valor máximo que puede almacenar el tipo de dato. Por ejemplo, si un `uint8` (que puede almacenar hasta 255) intenta almacenar 256, el valor "envuelve" y se convierte en 0.
*   **Underflow (Subdesbordamiento):** Ocurre cuando el resultado de una operación aritmética es menor que el valor mínimo que puede almacenar el tipo de dato. Por ejemplo, si un `uint8` (que puede almacenar desde 0) intenta almacenar -1, el valor "envuelve" y se convierte en 255.

En Solidity, un overflow o underflow no controlado puede llevar a comportamientos inesperados, manipulación de saldos, o incluso la pérdida de fondos.

## Conceptos Clave Utilizados

### `pragma solidity >=0.7.0 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.7.0 <0.9.0` significa que el contrato compilará con versiones desde 0.7.0 hasta 0.8.x. Es importante destacar que a partir de Solidity 0.8.0, las operaciones aritméticas por defecto revierten en caso de overflow/underflow, haciendo que `SafeMath` sea menos necesario para versiones más recientes, pero sigue siendo una buena práctica para versiones anteriores o para una claridad explícita.

### `import "../10.9_safemath/10.9_safemath.sol";`

Esta línea importa la biblioteca `SafeMath` desde el archivo `10.9_safemath.sol`. `SafeMath` es una biblioteca que proporciona funciones seguras para operaciones aritméticas, revirtiendo la transacción si ocurre un overflow o underflow.

## Funciones del Contrato

### `overflowExample(uint8 _val) public pure returns (uint8)`

*   **Propósito:** Demuestra cómo realizar una suma de forma segura para prevenir un overflow.
*   **Parámetros:**
    *   `_val`: Un valor `uint8` a sumar.
*   **Funcionamiento:**
    1.  `uint8 maxValue = 255;`: Se inicializa una variable `maxValue` con el valor máximo que puede contener un `uint8`.
    2.  `maxValue = uint8(SafeMath.add(maxValue,_val));`: En lugar de usar `maxValue + _val`, se utiliza `SafeMath.add(maxValue, _val)`. Si la suma de `maxValue` y `_val` excede 255, la función `SafeMath.add` revertirá la transacción, evitando el overflow.

### `underflowExample(uint8 _val) public pure returns (uint8)`

*   **Propósito:** Demuestra cómo realizar una resta de forma segura para prevenir un underflow.
*   **Parámetros:**
    *   `_val`: Un valor `uint8` a restar.
*   **Funcionamiento:**
    1.  `uint8 minValue = 0;`: Se inicializa una variable `minValue` con el valor mínimo que puede contener un `uint8`.
    2.  `minValue = uint8(SafeMath.sub(minValue,_val));`: En lugar de usar `minValue - _val`, se utiliza `SafeMath.sub(minValue, _val)`. Si la resta de `minValue` y `_val` resulta en un número negativo (es decir, menor que 0), la función `SafeMath.sub` revertirá la transacción, evitando el underflow.

## ¿Por qué este enfoque es "No Vulnerable"?

Este contrato es seguro contra overflows y underflows porque utiliza la biblioteca `SafeMath`. `SafeMath` implementa verificaciones internas para cada operación aritmética (suma, resta, multiplicación, división) que revierten la transacción si el resultado excede los límites del tipo de dato. Esto garantiza que las operaciones aritméticas siempre produzcan resultados válidos y previene manipulaciones maliciosas o errores inesperados debido a desbordamientos o subdesbordamientos.

En versiones de Solidity 0.8.0 y posteriores, el compilador añade automáticamente estas verificaciones para la mayoría de las operaciones aritméticas, lo que reduce la necesidad de `SafeMath`. Sin embargo, para versiones anteriores o cuando se necesita un control explícito, `SafeMath` sigue siendo una herramienta valiosa.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Llamar a `overflowExample(valor)`:**
    *   Si `valor` es 0, el resultado será 255.
    *   Si `valor` es 1 o más, la transacción revertirá, demostrando la prevención de overflow.
3.  **Llamar a `underflowExample(valor)`:**
    *   Si `valor` es 0, el resultado será 0.
    *   Si `valor` es 1 o más, la transacción revertirá, demostrando la prevención de underflow.

# Contrato Inteligente VulnerableOverflowAndUnderflow (Vulnerabilidad de Overflow/Underflow)

Este contrato de Solidity, `VulnerableOverflowAndUnderflow`, es un ejemplo que ilustra una **vulnerabilidad crítica de overflow (desbordamiento) y underflow (subdesbordamiento)** en operaciones aritméticas. Demuestra cómo la falta de verificaciones adecuadas puede llevar a resultados inesperados y potencialmente explotables.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de manejar las operaciones aritméticas con cuidado en Solidity.

## ¿Qué son Overflow y Underflow?

*   **Overflow (Desbordamiento):** Ocurre cuando el resultado de una operación aritmética es mayor que el valor máximo que puede almacenar el tipo de dato. Por ejemplo, si un `uint8` (que puede almacenar hasta 255) intenta almacenar 256, el valor "envuelve" y se convierte en 0.
*   **Underflow (Subdesbordamiento):** Ocurre cuando el resultado de una operación aritmética es menor que el valor mínimo que puede almacenar el tipo de dato. Por ejemplo, si un `uint8` (que puede almacenar desde 0) intenta almacenar -1, el valor "envuelve" y se convierte en 255.

En Solidity, un overflow o underflow no controlado puede llevar a comportamientos inesperados, manipulación de saldos, o incluso la pérdida de fondos.

## Conceptos Clave Utilizados

### `pragma solidity >=0.7.0 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.7.0 <0.9.0` significa que el contrato compilará con versiones desde 0.7.0 hasta 0.8.x. Es crucial entender que en versiones de Solidity anteriores a 0.8.0, las operaciones aritméticas no revertían automáticamente en caso de overflow/underflow, lo que hacía que los contratos fueran vulnerables si no se usaban bibliotecas como `SafeMath`.

## Funciones del Contrato

### `overflowExample(uint8 _val) public pure returns (uint8)`

*   **Propósito:** Demuestra un overflow vulnerable.
*   **Parámetros:**
    *   `_val`: Un valor `uint8` a sumar.
*   **Funcionamiento (Vulnerable a Overflow):
    1.  `uint8 maxValue = 255;`: Se inicializa una variable `maxValue` con el valor máximo que puede contener un `uint8`.
    2.  `maxValue += _val;`: **Aquí reside la vulnerabilidad.** Si `_val` es mayor que 0, la suma `maxValue + _val` excederá el valor máximo de `uint8` (255). En Solidity 0.7.x, esto no revertirá la transacción, sino que el valor "envuelve" (wrap around) y `maxValue` se convertirá en un número pequeño (por ejemplo, si `_val` es 1, `maxValue` se convierte en 0).

### `underflowExample(uint8 _val) public pure returns (uint8)`

*   **Propósito:** Demuestra un underflow vulnerable.
*   **Parámetros:**
    *   `_val`: Un valor `uint8` a restar.
*   **Funcionamiento (Vulnerable a Underflow):
    1.  `uint8 minValue = 0;`: Se inicializa una variable `minValue` con el valor mínimo que puede contener un `uint8`.
    2.  `minValue -= _val;`: **Aquí reside la vulnerabilidad.** Si `_val` es mayor que 0, la resta `minValue - _val` resultará en un número negativo. En Solidity 0.7.x, esto no revertirá la transacción, sino que el valor "envuelve" y `minValue` se convertirá en un número muy grande (por ejemplo, si `_val` es 1, `minValue` se convierte en 255).

## ¿Por qué este enfoque es "Vulnerable"?

Este contrato es vulnerable a overflows y underflows porque realiza operaciones aritméticas directamente sin ninguna verificación de seguridad. En versiones de Solidity anteriores a 0.8.0, el compilador no incluía verificaciones automáticas para estas condiciones. Esto significa que:

*   **Resultados Inesperados:** Las operaciones aritméticas pueden producir resultados que no son los matemáticamente correctos, lo que puede llevar a errores lógicos en el contrato.
*   **Manipulación de Saldos:** En contratos que manejan saldos o cantidades, un atacante podría explotar un underflow para hacer que su saldo parezca mucho mayor de lo que realmente es, o un overflow para reducir el saldo de otros.
*   **Comportamiento Impredecible:** El contrato puede comportarse de manera impredecible, lo que puede llevar a pérdidas financieras o a la interrupción del servicio.

Para evitar esta vulnerabilidad, en versiones de Solidity anteriores a 0.8.0, era esencial utilizar bibliotecas como `SafeMath` para todas las operaciones aritméticas. En Solidity 0.8.0 y posteriores, el compilador incluye verificaciones automáticas que revierten la transacción en caso de overflow/underflow, haciendo que estas operaciones sean seguras por defecto.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Llamar a `overflowExample(valor)`:**
    *   Llama con `valor = 1`. Observa cómo el resultado es 0 (255 + 1 = 256, que envuelve a 0 para `uint8`).
3.  **Llamar a `underflowExample(valor)`:**
    *   Llama con `valor = 1`. Observa cómo el resultado es 255 (0 - 1 = -1, que envuelve a 255 para `uint8`).

Estos resultados demuestran cómo los valores "envuelven" en lugar de revertir, lo que puede ser explotado en un contrato real.