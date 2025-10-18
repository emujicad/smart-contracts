# Contrato Inteligente NoVulnerableDenialOfService (Prevención de Denegación de Servicio)

Este contrato de Solidity, `NoVulnerableDenialOfService`, es un ejemplo que demuestra cómo prevenir un ataque de Denegación de Servicio (DoS) en un contrato inteligente. Se enfoca en limitar el consumo de gas de operaciones potencialmente costosas para asegurar que el contrato siga siendo funcional y accesible.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular ilustra la importancia de la eficiencia del gas y la prevención de DoS, ya que cada operación en la blockchain tiene un costo asociado y un límite de gas por bloque.

## ¿Qué es un Ataque de Denegación de Servicio (DoS)?

Un ataque de Denegación de Servicio (DoS) en la blockchain ocurre cuando un atacante hace que una función o el contrato completo consuma una cantidad excesiva de gas, ya sea intencionalmente para bloquear su uso o accidentalmente debido a un diseño ineficiente. Esto puede hacer que las funciones sean imposibles de ejecutar o prohibitivamente caras.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `uint256 constant public MAX_ITERATION = 100;`

*   `uint256`: Un entero sin signo de 256 bits.
*   `constant`: Indica que el valor de esta variable es fijo y se conoce en tiempo de compilación. No ocupa espacio de almacenamiento en la blockchain, lo que ahorra gas.
*   `public`: Permite que el valor de esta constante sea leído desde fuera del contrato.

### `pure`

Las funciones marcadas como `pure` no modifican el estado de la blockchain ni leen ninguna variable de estado. Solo operan con los parámetros de entrada y variables locales. Son las funciones más baratas de ejecutar en términos de gas, pero aún pueden ser costosas si realizan muchas operaciones computacionales.

## Funciones del Contrato

### `performDoS(uint256 _iterations) public pure`

*   **Propósito:** Realiza una operación que podría ser costosa, pero con un límite para prevenir DoS.
*   **Parámetros:**
    *   `_iterations`: El número de iteraciones a realizar en el bucle interno.
*   **Funcionamiento:**
    1.  `require(_iterations <= MAX_ITERATION, "Error. The max number of iterations was exceded");`: **Aquí reside la prevención de DoS.** Esta línea asegura que el número de iteraciones proporcionado por el usuario (`_iterations`) nunca exceda un límite predefinido (`MAX_ITERATION`). Si el usuario intenta pasar un valor mayor, la transacción se revertirá, evitando un consumo excesivo de gas.
    2.  `for (uint256 i = 0; i < _iterations; i++) { ... }`: Un bucle externo.
    3.  `uint256[] memory data = new uint256[](_iterations);`: Dentro del bucle externo, se crea un array en memoria. Esto es una operación que consume gas.
    4.  `for (uint256 j = 0; j < _iterations; j++) { data[j] = j; }`: Un bucle interno que llena el array. Esta operación también consume gas.

## ¿Por qué este enfoque es "No Vulnerable"?

La vulnerabilidad de Denegación de Servicio (DoS) a menudo ocurre cuando una función puede ser forzada a consumir una cantidad arbitrariamente grande de gas, ya sea por un bucle sin límites, la manipulación de arrays dinámicos muy grandes, o cálculos complejos que dependen de entradas no validadas.

Este contrato previene el DoS al:

*   **Limitar las Iteraciones:** La verificación `require(_iterations <= MAX_ITERATION, ...)` es crucial. Al establecer un límite superior fijo para el número de iteraciones, el contrato garantiza que el costo máximo de gas de la función `performDoS` sea predecible y esté acotado. Esto significa que un atacante no puede forzar al contrato a gastar una cantidad infinita de gas.
*   **Predecibilidad del Gas:** Aunque la función realiza bucles anidados y crea arrays en memoria (operaciones que consumen gas), el hecho de que el número máximo de iteraciones esté limitado hace que el costo de gas sea predecible y manejable. Los usuarios pueden saber de antemano el costo máximo de ejecutar esta función.

Al implementar límites y validaciones en las entradas que afectan el consumo de gas, el contrato se protege contra ataques que buscan agotar los recursos de la red o hacer que el contrato sea inoperable.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Llamar a `performDoS(cantidad)`:** Puedes llamar a esta función con un valor para `cantidad` (el número de iteraciones).
    *   Si `cantidad` es menor o igual a `MAX_ITERATION` (100), la función se ejecutará.
    *   Si `cantidad` es mayor que `MAX_ITERATION`, la transacción revertirá con el mensaje de error, demostrando la prevención de DoS.

# Contrato Inteligente VulnerableDenialOfService (Vulnerabilidad de Denegación de Servicio)

Este contrato de Solidity, `VulnerableDenialOfService`, es un ejemplo que ilustra una **vulnerabilidad crítica de Denegación de Servicio (DoS)**. Demuestra cómo una función que realiza operaciones costosas basadas en una entrada de usuario sin límites puede ser explotada para hacer que el contrato sea inoperable o extremadamente caro de usar.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular sirve como una advertencia sobre la importancia de validar y limitar las entradas de usuario que afectan el consumo de gas.

## ¿Qué es un Ataque de Denegación de Servicio (DoS)?

Un ataque de Denegación de Servicio (DoS) en la blockchain ocurre cuando un atacante hace que una función o el contrato completo consuma una cantidad excesiva de gas, ya sea intencionalmente para bloquear su uso o accidentalmente debido a un diseño ineficiente. Esto puede hacer que las funciones sean imposibles de ejecutar o prohibitivamente caras.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `pure`

Las funciones marcadas como `pure` no modifican el estado de la blockchain ni leen ninguna variable de estado. Solo operan con los parámetros de entrada y variables locales. Son las funciones más baratas de ejecutar en términos de gas, pero aún pueden ser costosas si realizan muchas operaciones computacionales.

## Funciones del Contrato

### `performDoS(uint256 _iterations) public pure`

*   **Propósito:** Realiza una operación de bucle anidado que es susceptible a un ataque DoS.
*   **Parámetros:**
    *   `_iterations`: El número de iteraciones a realizar en los bucles. **Este parámetro es la fuente de la vulnerabilidad.**
*   **Funcionamiento (Vulnerable a DoS):
    1.  `for (uint256 i = 0; i < _iterations; i++) { ... }`: Un bucle externo que itera `_iterations` veces.
    2.  `uint256[] memory data = new uint256[](_iterations);`: Dentro del bucle externo, se crea un array en memoria cuyo tamaño depende de `_iterations`. Crear arrays grandes consume mucho gas.
    3.  `for (uint256 j = 0; j < _iterations; j++) { data[j] = j; }`: Un bucle interno que llena el array, también iterando `_iterations` veces. Cada operación de asignación consume gas.

## ¿Por qué este enfoque es "Vulnerable"?

La vulnerabilidad de Denegación de Servicio (DoS) en este contrato se debe a que la función `performDoS` permite que un usuario malicioso controle directamente la cantidad de trabajo computacional que el contrato debe realizar. No hay un límite superior para el parámetro `_iterations`.

*   **Bucle Incontrolado:** Si un atacante llama a `performDoS` con un valor muy grande para `_iterations` (por ejemplo, 1000, 10000, o más), el contrato intentará ejecutar `_iterations * _iterations` operaciones de asignación y creación de arrays. Esto resultará en un consumo de gas exponencialmente alto.
*   **Exceso del Límite de Gas por Bloque:** El costo de gas de la función `performDoS` puede exceder fácilmente el límite de gas por bloque de la red Ethereum. Cuando esto sucede, la transacción fallará con un error de "Out of Gas", y la función se volverá inejecutable para cualquier valor de `_iterations` que cause este exceso.
*   **Ataque de Denegación de Servicio:** Un atacante puede usar esta vulnerabilidad para:
    *   Hacer que la función sea tan cara que nadie pueda permitirse ejecutarla.
    *   Bloquear la ejecución de la función para todos los usuarios, ya que cualquier intento de llamarla con un `_iterations` grande fallará, y si la función es crítica para el contrato, esto podría paralizarlo.

Para evitar esta vulnerabilidad, siempre se deben validar y limitar las entradas de usuario que afectan el consumo de gas, especialmente en bucles o cuando se manipulan estructuras de datos dinámicas.

## ¿Cómo interactuar con este contrato (para entender la vulnerabilidad)?

1.  **Desplegar el Contrato:** Una vez desplegado en una red Ethereum (o una red de prueba).
2.  **Llamar a `performDoS(cantidad)`:** Puedes llamar a esta función con diferentes valores para `cantidad`.
    *   Comienza con valores pequeños (ej. 10, 20) y observa el costo de gas.
    *   Aumenta `cantidad` (ej. 100, 200). Verás cómo el costo de gas aumenta drásticamente.
    *   Eventualmente, al usar un valor suficientemente grande para `cantidad`, la transacción fallará con un error de "Out of Gas", demostrando la vulnerabilidad de DoS.