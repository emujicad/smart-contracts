# Interactuando con Otros Contratos en Solidity

Este documento explica cómo los contratos inteligentes pueden llamarse e interactuar entre sí en la blockchain, un concepto conocido como "composabilidad". El archivo `call_other_contract.sol` demuestra el método estándar y de alto nivel para esta interacción.

La composabilidad es una característica central de DeFi (Finanzas Descentralizadas), permitiendo que diferentes protocolos (como Uniswap, Aave, etc.) se combinen como si fueran "legos de dinero".

## Los Contratos en el Archivo

1.  **`ContratoPrueba`**: Este es nuestro contrato de destino. Tiene variables de estado (`x`, `value`) y funciones para establecer y obtener sus valores. Es un contrato simple que será llamado por otro.
2.  **`LlamarContratoPrueba`**: Este es nuestro contrato llamador. Contiene funciones que demuestran cómo interactuar con un `ContratoPrueba` ya desplegado.

---

## Cómo Llamar a Otro Contrato (El Método de Alto Nivel)

Para interactuar con otro contrato, necesitas dos piezas clave de información:

1.  **La Dirección del Contrato de Destino:** La ubicación única del contrato en la blockchain.
2.  **La Interfaz del Contrato de Destino:** Las firmas de las funciones (nombres, parámetros, tipos de retorno) del contrato que quieres llamar. No necesitas el código fuente completo, solo las definiciones de las funciones.

En Solidity, puedes proporcionar el código fuente completo del contrato (como en nuestro ejemplo) o una definición formal de `interface`. Una `interface` es como el esqueleto de un contrato:

```solidity
// Una interfaz para ContratoPrueba
interface IContratoPrueba {
    function setX(uint _x) external;
    function getX() external view returns (uint);
    // ... y así sucesivamente
}
```

### La Sintaxis de Llamada

La sintaxis estándar para llamar a una función en otro contrato es:

`NombreContratoDestino(direccion_destino).funcionALlamar(argumentos);`

Analicemos las funciones en `LlamarContratoPrueba`.

### Leer Datos de otro contrato

```solidity
function getX(address _test) external view returns (uint x) {
    x = ContratoPrueba(_test).getX();
}
```

1.  `ContratoPrueba(_test)`: Tomamos la dirección del contrato de destino (`_test`) y la "convertimos" (hacemos un cast) al tipo `ContratoPrueba`. Esto le dice a Solidity: "Trata al contrato en esta dirección como si fuera un `ContratoPrueba`".
2.  `.getX()`: Ahora que Solidity conoce el tipo del contrato, podemos simplemente llamar a sus funciones públicas/externas como si fueran parte de nuestro propio contrato.

Esta es una llamada de **solo lectura** porque `getX()` es una función `view`. No consume una cantidad significativa de gas.

### Escribir Datos en otro contrato

```solidity
function setX(ContratoPrueba _test, uint _x) external {
    _test.setX(_x);
}
```

-   El principio es el mismo. Llamamos a la función `setX` en el contrato de destino.
-   Esta es una llamada que **cambia el estado**, ya que modifica la variable `x` en `ContratoPrueba`. Esto creará una transacción real en la blockchain y consumirá gas.

### Enviar Ether Mientras se Llama a una Función

```solidity
function setXandSendEther(address _test, uint _x) external payable {
    ContratoPrueba(_test).setXandReceiveEther{value: msg.value}(_x);
}
```

-   Esto demuestra una característica más avanzada y poderosa.
-   **`{value: msg.value}`**: Esta sintaxis especial se usa para enviar Ether junto con una llamada a una función. `msg.value` es la cantidad de Ether que se envió a la función `setXandSendEther`.
-   Este Ether se reenvía al contrato `ContratoPrueba`, que puede acceder a él dentro de su función `setXandReceiveEther` (la cual debe estar marcada como `payable`).

## Resumen

La comunicación entre contratos es una piedra angular de Solidity. El método de alto nivel, donde conviertes una dirección a un tipo de contrato o interfaz conocida, es la forma más común, legible y segura de construir aplicaciones interconectadas en Ethereum.
