# Contrato Abstracto ERC165 (Estándar de Detección de Interfaz)

Este contrato de Solidity, `ERC165.sol`, proporciona una implementación básica del estándar **EIP-165**. Este estándar permite que los contratos inteligentes declaren qué interfaces (conjuntos de funciones) implementan. Es fundamental para la interoperabilidad en la blockchain, ya que permite que otros contratos o aplicaciones consulten si un contrato dado soporta una funcionalidad específica.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. `ERC165` es un contrato `abstract` (abstracto), lo que significa que no puede ser desplegado directamente, sino que está diseñado para ser heredado por otros contratos que necesiten la funcionalidad de detección de interfaz.

## ¿Qué es EIP-165?

EIP-165 (Ethereum Improvement Proposal 165) es un estándar que define un método para que los contratos publiquen las interfaces que implementan. Esto es útil porque permite que un contrato verifique si otro contrato soporta un conjunto particular de funciones sin tener que intentar llamar a esas funciones y arriesgarse a que la transacción falle.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que el contrato compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### `import "../../interfaces/IERC165/IERC165.sol";`

Esta línea importa la interfaz `IERC165`, que define la función `supportsInterface` que debe ser implementada.

### `abstract contract ERC165 is IERC165 { ... }`

*   `abstract contract`: Un contrato abstracto no puede ser desplegado por sí mismo. Está diseñado para ser una base para otros contratos, proporcionando funcionalidades comunes que pueden ser extendidas o modificadas.
*   `is IERC165`: Indica que este contrato implementa la interfaz `IERC165`.

## Funciones del Contrato

### `supportsInterface(bytes4 interfaceId) public view virtual override returns (bool)`

*   **Propósito:** Esta es la función central del estándar EIP-165. Permite consultar si el contrato implementa una interfaz específica.
*   **Parámetros:**
    *   `interfaceId`: Un identificador único de 4 bytes para la interfaz que se desea consultar. Este ID se calcula tomando el XOR de los selectores de función de todas las funciones en la interfaz.
*   **Funcionamiento:**
    *   `public view virtual override`: 
        *   `public`: Puede ser llamada por cualquier persona.
        *   `view`: No modifica el estado del contrato.
        *   `virtual`: Permite que los contratos que heredan de `ERC165` sobrescriban (override) esta función para añadir soporte a más interfaces.
        *   `override`: Indica que esta función está sobrescribiendo una función de la interfaz `IERC165`.
    *   `return interfaceId == type(IERC165).interfaceId;`: En esta implementación básica, la función solo devuelve `true` si el `interfaceId` proporcionado coincide con el `interfaceId` de la propia interfaz `IERC165`. Los contratos que hereden de `ERC165` y quieran declarar soporte para otras interfaces (como `IERC721`) necesitarán sobrescribir esta función para incluir esas verificaciones.

## ¿Cómo se utiliza este Contrato?

Otros contratos que necesiten implementar el estándar EIP-165 (como los tokens ERC-721 o ERC-1155) heredarán de `ERC165`. Luego, sobrescribirán la función `supportsInterface` para añadir la lógica que declare el soporte para sus propias interfaces. Por ejemplo, un contrato ERC-721 sobrescribiría `supportsInterface` para devolver `true` tanto para `type(IERC165).interfaceId` como para `type(IERC721).interfaceId`.

Esto permite que una aplicación o un explorador de blockchain pueda preguntar a cualquier contrato: "¿Implementas la interfaz ERC-721?" y recibir una respuesta confiable.