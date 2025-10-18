# Pruebas del Contrato "Hola Mundo" (helloworld.t.sol)

Este contrato de Solidity (`helloworld.t.sol`) contiene las pruebas unitarias para el contrato `helloworld.sol`. Utiliza el framework de pruebas Foundry para verificar la funcionalidad básica de lectura y escritura de un mensaje en la blockchain. Es un ejemplo ideal para principiantes que desean entender cómo probar contratos inteligentes simples.

## Características Principales

*   **Configuración de Pruebas (`setUp`)**: Inicializa una nueva instancia del contrato `helloworld` antes de cada prueba, asegurando un estado limpio.
*   **Prueba de Lectura de Mensaje**: Verifica que el mensaje inicial del contrato sea el esperado.
*   **Prueba de Actualización de Mensaje**: Comprueba que la función para actualizar el mensaje funciona correctamente y que el nuevo mensaje se almacena y se puede leer.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`import {Test, console, stdError} from "forge-std/Test.sol";`**: Importa componentes específicos de la biblioteca de pruebas estándar de Foundry.
    *   **`Test`**: El contrato base para escribir pruebas.
*   **`import {helloworld} from "../../src/1_Helloworld/helloworld.sol";`**: Importa el contrato `helloworld` que se va a probar. La ruta relativa es importante.
*   **`contract helloworldTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`setUp()`**: Función especial que se ejecuta antes de cada función de prueba para configurar el entorno.
*   **`assertEq(expected, actual, "mensaje de error");`**: Función de aserción para verificar que dos valores son iguales. Si no lo son, la prueba falla y se muestra el mensaje de error opcional.
*   **`string memory`**: Tipo de dato para cadenas de texto. `memory` indica que la cadena se almacena temporalmente durante la ejecución de la función.
*   **Funciones `view`**: Funciones que solo leen el estado del contrato y no lo modifican. No cuestan gas.
*   **Funciones que Modifican el Estado**: Funciones que cambian el estado del contrato. Requieren una transacción y cuestan gas.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Despliega una nueva instancia del contrato `helloworld`. Cada prueba comienza con un contrato recién desplegado, asegurando que no haya interferencias entre pruebas.
2.  **`test_GetMessage()`**: Llama a la función `getMessage()` del contrato `helloworld` y utiliza `assertEq` para confirmar que el mensaje devuelto es "Hello, World from foundry!".
3.  **`test_UpdateMessage()`**: Define un nuevo mensaje, llama a `updateMessage()` para cambiar el mensaje en el contrato, y luego llama a `getMessage()` nuevamente para verificar que el mensaje se haya actualizado correctamente.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/1_Helloworld/helloworld.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba. Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de tu contrato `helloworld`.

Este contrato de prueba es un excelente recurso para aprender los fundamentos de las pruebas de contratos inteligentes con Foundry, una habilidad esencial para cualquier desarrollador de Web3.
