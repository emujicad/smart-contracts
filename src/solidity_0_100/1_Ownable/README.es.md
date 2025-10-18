# Entendiendo el Patrón "Ownable" (Ser Propietario) en Solidity

Este documento explica el patrón "Ownable", uno de los mecanismos de control de acceso más fundamentales y utilizados en Solidity. El archivo `ownable.sol` proporciona una implementación clara y sencilla de este patrón.

## ¿Qué es el Patrón Ownable?

El patrón Ownable es una forma simple de restringir el acceso a ciertas funciones en un contrato inteligente, asegurando que solo una única dirección, el "propietario" (owner), pueda ejecutarlas. Esto es crucial para tareas administrativas como cambiar variables críticas, pausar un contrato o retirar fondos.

---

## Componentes Clave del Contrato `Propietario`

### 1. La Variable de Estado `propietario`

```solidity
address public propietario;
```

-   Se declara una variable de estado de tipo `address` para almacenar la dirección del propietario.
-   Se marca como `public`, por lo que Solidity crea automáticamente una función "getter" (`propietario()`) que permite a cualquiera ver la dirección del propietario.

### 2. El `constructor`

```solidity
constructor() {
    propietario = msg.sender;
}
```

-   El `constructor` es una función especial que se ejecuta solo **una vez**, cuando el contrato se despliega por primera vez.
-   Establece el `propietario` a `msg.sender`. `msg.sender` es una variable global en Solidity que siempre se refiere a la dirección que inició la transacción actual.
-   Por lo tanto, la persona que despliega el contrato se convierte automáticamente en su propietario.

### 3. El `modifier` (Modificador) `soloPropietario`

```solidity
modifier soloPropietario() {
    require(msg.sender == propietario, "no es el propietario");
    _;
}
```

Este es el corazón del patrón Ownable.

-   **¿Qué es un `modifier`?** Un modificador es una pieza de código reutilizable que se puede adjuntar a una función para cambiar su comportamiento. Se usan típicamente para verificar ciertas condiciones antes de que se ejecute una función.
-   **`require(msg.sender == propietario, ...)`**: Esta línea comprueba si la persona que llama a la función (`msg.sender`) es la misma que la dirección almacenada en la variable `propietario`. Si esta condición es `false`, la transacción se revierte inmediatamente con el mensaje de error proporcionado ("no es el propietario").
-   **El Símbolo `_;`**: Este símbolo especial representa el cuerpo de la función donde se aplica el modificador. Si la comprobación `require` pasa, la ejecución del código continúa hacia el cuerpo de la función (representado por `_`).

### 4. Aplicando el Modificador

Para proteger una función, simplemente añades el nombre del modificador a su definición:

```solidity
function soloPropietarioPuedeLlamar() view external soloPropietario returns (string memory) {
    // ... cuerpo de la función
}
```

-   Ahora, antes de que se ejecute cualquier código dentro de `soloPropietarioPuedeLlamar`, la lógica dentro de `soloPropietario` se ejecuta primero. Si quien llama no es el propietario, la función fallará incluso antes de empezar.

### 5. Transfiriendo la Propiedad

```solidity
function setPropietario(address _newOwner) external soloPropietario {
    require(_newOwner != address(0), "direccion invalida");
    propietario = _newOwner;
}
```

-   Un contrato casi siempre debería tener una forma de transferir la propiedad. De lo contrario, si el propietario pierde el acceso a su dirección, las funciones administrativas del contrato quedarían bloqueadas para siempre.
-   Esta función está a su vez protegida por `soloPropietario`, asegurando que solo el propietario actual pueda iniciar una transferencia de propiedad.
-   También incluye una comprobación para evitar establecer como propietario la dirección cero (`address(0)`), que es una dirección inválida e inaccesible.

## Resumen

El patrón Ownable es una herramienta simple pero poderosa. Combinando una variable de estado (`propietario`), un `constructor` para establecerla y un `modifier` (`soloPropietario`) para comprobarla, puedes crear fácilmente funciones de administrador seguras en tus contratos inteligentes.
