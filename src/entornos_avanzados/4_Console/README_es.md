# Uso de `console.log` para Depuración

En el desarrollo de contratos inteligentes con Foundry, `console.log` es una herramienta de depuración indispensable. Permite imprimir mensajes y valores de variables desde tus contratos de Solidity durante la ejecución de las pruebas, de manera similar a como se usa en JavaScript.

## ¿Cómo funciona?

Foundry proporciona una implementación de `console.log` a través de un contrato especial (un "cheat code") que puedes importar en tus contratos de prueba. Al ejecutar las pruebas con un nivel de verbosidad adecuado, Foundry captura estas llamadas y muestra la salida en tu terminal.

## Importar `console.log`

Para usar `console.log` en tus contratos de prueba, necesitas importar `console.sol` de la librería `forge-std`:

```solidity
import "forge-std/console.sol";
```

## Ejemplos de Uso

Puedes usar `console.log` para imprimir diferentes tipos de datos:

*   **Cadenas de texto y números:**
    ```solidity
    console.log("El valor de mi variable es:", miVariable);
    ```

*   **Direcciones:**
    ```solidity
    console.log("La dirección del remitente es:", msg.sender);
    ```

*   **Enteros (con `console.logInt`):**
    ```solidity
    console.logInt(unEnteroConSigno);
    ```

## Consideraciones Importantes

*   **Solo para desarrollo y pruebas:** `console.log` no tiene efecto en la red principal (mainnet) o en redes públicas de prueba (testnets). Es una herramienta exclusiva para el entorno de desarrollo local de Foundry.
*   **Verbosidad:** Para ver la salida de `console.log`, debes ejecutar tus pruebas con un flag de alta verbosidad, como `-vv`, `-vvv` o `-vvvv`.

El uso de `console.log` es una práctica fundamental para entender el flujo de ejecución de tus contratos, depurar errores y verificar que las variables contienen los valores esperados durante las pruebas.