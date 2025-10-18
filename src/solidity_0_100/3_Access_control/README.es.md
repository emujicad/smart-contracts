# Contrato Inteligente c1_AccessControl (Control de Acceso Basado en Roles)

Este contrato de Solidity, `c1_AccessControl`, implementa un sistema básico de control de acceso basado en roles. Permite definir diferentes roles (como `ADMIN` o `USER`) y asignar o revocar estos roles a direcciones específicas. Las funciones pueden ser protegidas para que solo los usuarios con un rol determinado puedan ejecutarlas.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular es fundamental para la seguridad de las aplicaciones descentralizadas, ya que permite gestionar quién puede hacer qué dentro del contrato.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.2 <0.9.0` significa que el contrato compilará con versiones desde 0.8.2 hasta 0.8.x.

### `event AssingRole (bytes32 indexed role, address indexed account);`
### `event RevokeRole (bytes32 indexed role, address indexed account);`

Estos son `eventos` que se emiten cuando se asigna o revoca un rol a una cuenta. Son útiles para que las aplicaciones externas puedan rastrear los cambios en los permisos de los usuarios.

### `mapping (bytes32 => mapping (address => bool)) public roles;`

Este es el corazón del sistema de roles. Es un `mapping` anidado:

*   La primera clave (`bytes32`) es el hash del nombre del rol (ej. `ADMIN`).
*   La segunda clave (`address`) es la dirección de la cuenta.
*   El valor (`bool`) indica si la cuenta tiene ese rol (`true`) o no (`false`).

### `bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));`
### `bytes32 private constant USER = keccak256(abi.encodePacked("USER"));`

Estas líneas definen los identificadores únicos para los roles `ADMIN` y `USER`. Se utiliza `keccak256(abi.encodePacked("ROLE_NAME"))` para generar un hash único para cada nombre de rol, lo que es una práctica común para ahorrar espacio de almacenamiento y evitar colisiones de nombres.

### `modifier onlyAdmin(bytes32 _role) { ... }`

Un `modifier` (modificador) es una pieza de código que se puede adjuntar a las funciones para cambiar su comportamiento. El modificador `onlyAdmin` verifica si la cuenta que llama a la función (`msg.sender`) tiene el rol especificado (`_role`).

*   `require(roles[_role][msg.sender], "Error. You are not authorized");`: Si la cuenta no tiene el rol, la transacción se revierte.
*   `_;`: Si la verificación pasa, el código de la función a la que se aplica el modificador se ejecuta.

## Funciones del Contrato

### `_assignRole (bytes32 _role, address _account) internal`

*   **Propósito:** Asigna un rol a una cuenta. Es una función interna, lo que significa que solo puede ser llamada desde dentro del contrato.
*   **Funcionamiento:** Establece `roles[_role][_account]` a `true` y emite el evento `AssingRole`.

### `_revokeRole (bytes32 _role, address _account) internal`

*   **Propósito:** Revoca un rol a una cuenta. También es una función interna.
*   **Funcionamiento:** Establece `roles[_role][_account]` a `false` y emite el evento `RevokeRole`.

### `assignRole (bytes32 _role, address _account) external onlyAdmin(ADMIN)`

*   **Propósito:** Función pública para asignar un rol a una cuenta.
*   **Restricción:** Solo las cuentas con el rol `ADMIN` pueden llamar a esta función, gracias al modificador `onlyAdmin(ADMIN)`.

### `revokeRole (bytes32 _role, address _account) external onlyAdmin(ADMIN)`

*   **Propósito:** Función pública para revocar un rol a una cuenta.
*   **Restricción:** Solo las cuentas con el rol `ADMIN` pueden llamar a esta función.

### `constructor () { ... }`

El `constructor` es una función especial que se ejecuta una única vez cuando el contrato se despliega. Aquí se inicializa el sistema de roles:

*   `_assignRole(ADMIN, msg.sender);`: Asigna el rol `ADMIN` a la cuenta que despliega el contrato (`msg.sender`). Esto asegura que siempre haya al menos un administrador inicial.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** La cuenta que despliega el contrato automáticamente obtiene el rol `ADMIN`.
2.  **Asignar Roles (como ADMIN):** El administrador puede llamar a `assignRole` para dar roles (como `USER` o incluso `ADMIN`) a otras cuentas.
3.  **Revocar Roles (como ADMIN):** El administrador puede llamar a `revokeRole` para quitar roles a otras cuentas.
4.  **Verificar Roles:** Puedes consultar el `mapping` `roles` directamente (ya que es `public`) para ver qué roles tiene cada cuenta.