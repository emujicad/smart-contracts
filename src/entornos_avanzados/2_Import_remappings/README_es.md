# Creación de Token ERC-20 con Solmate (ImportERC20.sol)

Este contrato de Solidity (`ImportERC20.sol`) demuestra una forma eficiente y común de crear un token compatible con el estándar ERC-20 utilizando la biblioteca Solmate. Solmate es conocida por sus contratos optimizados en gas y su código conciso, lo que la convierte en una excelente opción para desarrolladores de Solidity.

## Características Principales

*   **Importación de ERC-20**: Utiliza la implementación de ERC-20 de Solmate.
*   **Herencia Simple**: Crea un nuevo token heredando directamente del contrato `ERC20` de Solmate y configurando sus propiedades básicas (nombre, símbolo, decimales) en la declaración del contrato.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`import "path/to/Contract.sol";`**: La declaración `import` permite incluir código de otros archivos o bibliotecas. Es fundamental para la modularidad y la reutilización de código en Solidity.
*   **`contract Token is ERC20(...) { ... }`**: Herencia de contratos.
    *   **`is`**: Palabra clave utilizada para indicar que un contrato hereda de otro. El contrato `Token` obtiene todas las funciones y variables de estado del contrato `ERC20`.
    *   **Constructor de Contrato Base**: Cuando se hereda, el constructor del contrato base (en este caso, `ERC20`) se llama automáticamente. Aquí, se le pasan los parámetros iniciales del token: "CoinTest" (nombre), "CTK" (símbolo) y 18 (decimales).
*   **Estándar ERC-20**: Un conjunto de reglas y funciones que un token debe implementar para ser compatible con el ecosistema Ethereum. Al heredar de una implementación ERC-20 como la de Solmate, su token automáticamente cumple con este estándar.

## Cómo Funciona

1.  **Importación**: La línea `import "solmate/tokens/ERC20.sol";` trae el código del contrato `ERC20` de Solmate a su proyecto.
2.  **Herencia y Configuración**: La línea `contract Token is ERC20("CoinTest", "CTK", 18) {}` hace dos cosas principales:
    *   Declara un nuevo contrato llamado `Token`.
    *   Indica que `Token` es una extensión de `ERC20`, lo que significa que `Token` tendrá todas las funciones de un token ERC-20 (como `transfer`, `balanceOf`, `approve`, etc.) sin necesidad de escribirlas manualmente.
    *   Inicializa el token con un nombre ("CoinTest"), un símbolo ("CTK") y 18 decimales.

## Uso (Creación Rápida de Tokens)

Este patrón es ideal para crear rápidamente tokens ERC-20 estándar para pruebas, desarrollo o incluso para proyectos en producción cuando se busca eficiencia y seguridad probada.

Para desplegar este token:

1.  Asegúrate de que la biblioteca Solmate esté correctamente instalada y accesible en tu entorno de desarrollo (por ejemplo, a través de `forge install solmate`).
2.  Compila y despliega el contrato `Token`.

Una vez desplegado, tendrás un token ERC-20 completamente funcional con las propiedades especificadas, listo para interactuar con otras aplicaciones y servicios en la blockchain.

Este contrato es un excelente ejemplo de cómo la modularidad y las bibliotecas pueden simplificar enormemente el desarrollo de contratos inteligentes, permitiendo a los desarrolladores centrarse en la lógica de negocio única de sus aplicaciones.
