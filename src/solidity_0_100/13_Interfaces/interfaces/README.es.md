# Interfaz ICounter

Este archivo define la interfaz `ICounter`. Una interfaz en Solidity es una colección de definiciones de funciones sin implementación. Define la API pública de un contrato, permitiendo que otros contratos interactúen con él sin necesidad de conocer su lógica interna.

## Características clave de las interfaces:
- No pueden tener ninguna función implementada.
- Pueden heredar de otras interfaces.
- Todas las funciones declaradas deben ser `external`.
- No pueden tener un constructor.
- No pueden tener variables de estado.

## Funciones

### `count()`
Declara una función para obtener la cuenta actual.
- **Visibilidad:** `external`
- **Mutabilidad de estado:** `view`
- **Retorna:** `uint`

### `inc()`
Declara una función para incrementar la cuenta.
- **Visibilidad:** `external`