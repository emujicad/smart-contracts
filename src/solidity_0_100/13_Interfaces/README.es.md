# Ejemplo de Interfaces en Solidity

Este proyecto proporciona un ejemplo simple de cómo usar interfaces en Solidity para interactuar con contratos inteligentes.

## Contratos

### `interface.sol`

Este archivo define la interfaz `ICounter`. Una interfaz en Solidity es una colección de definiciones de funciones sin implementación. Define la API pública de un contrato, permitiendo que otros contratos interactúen con él sin necesidad de conocer su lógica interna.

Características clave de las interfaces:
- No pueden tener ninguna función implementada.
- Pueden heredar de otras interfaces.
- Todas las funciones declaradas deben ser `external`.
- No pueden tener un constructor.
- No pueden tener variables de estado.

### `counter.sol`

Este es un contrato inteligente simple que mantiene un contador. Tiene dos funciones: `inc()` para incrementar el contador y `dec()` para decrementarlo. Este contrato implementa las funciones definidas en la interfaz `ICounter`.

### `callinterface.sol`

Este contrato demuestra cómo usar la interfaz `ICounter` para interactuar con el contrato `Counter`. Toma la dirección de un contrato `Counter`, llama a su función `inc()` y luego recupera la cuenta actualizada usando la función `count()`.

## Cómo funciona

1.  **Interfaz `ICounter`:** Define las funciones que un contrato de contador debe tener (`count()` e `inc()`).
2.  **Contrato `Counter`:** Implementa las funciones definidas en la interfaz `ICounter`.
3.  **Contrato `CallInterface`:**
    *   Importa la interfaz `ICounter`.
    *   La función `examples()` toma la dirección de un contrato `Counter` desplegado.
    *   Crea una instancia de `ICounter` a partir de la dirección, lo que le permite llamar a las funciones definidas в la interfaz.
    *   Llama a `inc()` en el contrato `Counter`, lo que modifica su estado.
    *   Llama a `count()` para leer el estado del contrato `Counter`.

Este ejemplo ilustra un concepto fundamental en el desarrollo de contratos inteligentes: la **separación de preocupaciones**. Al usar interfaces, podemos escribir contratos que pueden interactuar con cualquier otro contrato que implemente la misma interfaz, lo que hace que nuestro código sea más modular, reutilizable y comprobable.

## Cómo usar

1.  Despliega el contrato `Counter`.
2.  Despliega el contrato `CallInterface`.
3.  Llama a la función `examples()` del contrato `CallInterface`, pasando la dirección del contrato `Counter` desplegado como argumento.
