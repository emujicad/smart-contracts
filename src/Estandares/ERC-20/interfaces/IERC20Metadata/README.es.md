# Interfaz IERC20Metadata (Metadatos del Estándar de Token Fungible)

Este archivo de Solidity, `IERC20Metadata.sol`, define una **interfaz opcional** para el estándar de token ERC-20. Esta interfaz especifica funciones para que un token ERC-20 pueda proporcionar información adicional (metadatos) como su nombre, símbolo y el número de decimales que utiliza. No contiene ninguna lógica de implementación, solo las firmas de las funciones.

## ¿Qué es una Interfaz en Solidity?

Una interfaz es un tipo de contrato abstracto que solo contiene declaraciones de funciones y eventos, pero no su implementación. Se utiliza para:

*   **Definir Estándares:** Como el ERC-20, para asegurar que todos los contratos que implementan la interfaz sigan las mismas reglas.
*   **Interacción entre Contratos:** Permite que un contrato interactúe con otro contrato sin conocer su código fuente completo, solo su interfaz.
*   **Verificación en Tiempo de Compilación:** El compilador puede verificar que un contrato que dice implementar una interfaz realmente implemente todas sus funciones y eventos.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que la interfaz compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### `interface IERC20Metadata { ... }`

Declara la interfaz `IERC20Metadata`.

### `external view` y `external`

*   `external`: Significa que la función solo puede ser llamada desde fuera del contrato.
*   `view`: Indica que la función no modifica el estado del contrato. Son funciones de solo lectura y no cuestan gas para ejecutarse (cuando se llaman fuera de una transacción).

## Funciones Opcionales del Estándar ERC-20 (Metadatos)

La interfaz `IERC20Metadata` define las siguientes funciones opcionales:

### `function name() external view returns (string memory);`

*   **Propósito:** Devuelve el nombre legible del token (ej. "MyToken").

### `function symbol() external view returns (string memory);`

*   **Propósito:** Devuelve el símbolo corto del token (ej. "MTK").

### `function decimals() external returns (uint8);`

*   **Propósito:** Devuelve el número de decimales que utiliza el token para su representación. Comúnmente 18, similar a Ether, lo que significa que 1 token se divide en `10^18` unidades más pequeñas.

## ¿Cómo se utiliza esta Interfaz?

Un contrato que quiera ser un token ERC-20 y proporcionar metadatos estándar debe `implementar` esta interfaz además de la `IERC20` principal. Esto significa que el contrato debe tener todas las funciones definidas en `IERC20Metadata` con las firmas exactas. Por ejemplo:

```solidity
import "./IERC20.sol";
import "./IERC20Metadata.sol";

contract MyToken is IERC20, IERC20Metadata {
    // ... implementación de todas las funciones y eventos de IERC20 y IERC20Metadata ...
}
```

Al hacer esto, cualquier aplicación o servicio que entienda la interfaz `IERC20Metadata` podrá obtener fácilmente el nombre, símbolo y decimales del token, mejorando la interoperabilidad y la experiencia del usuario.