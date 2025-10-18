# Contrato Inteligente CRUD de Usuarios

Este contrato de Solidity, `UserCrud`, es un ejemplo básico de cómo implementar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) para gestionar usuarios en la blockchain. Está diseñado para ser fácil de entender para personas nuevas en Web3 y Solidity.

## ¿Qué es un Contrato Inteligente?

Imagina un contrato inteligente como un programa que vive en la blockchain. Una vez desplegado, funciona exactamente como fue programado, sin posibilidad de ser modificado por nadie. En este caso, nuestro contrato `UserCrud` nos permite interactuar con una lista de usuarios.

## Conceptos Clave Utilizados

### `pragma solidity >=0.8.2 <0.9.0;`

Esto le dice al compilador de Solidity qué versión debe usar. Es como especificar la versión de un lenguaje de programación para asegurar que tu código funcione correctamente.

### `struct User { ... }`

Una `struct` (estructura) es como una plantilla para crear objetos. Aquí, `User` define cómo se ve un usuario, con propiedades como:

*   `id` (identificador único del usuario)
*   `name` (nombre del usuario)
*   `age` (edad del usuario)
*   `isActive` (un valor `true` o `false` para saber si el usuario está activo o ha sido "eliminado" lógicamente)

### `mapping(uint256 => User) private users;`

Un `mapping` es como un diccionario o un mapa clave-valor. En este caso, cada `id` de usuario (`uint256`) se asocia con un objeto `User`. Es muy eficiente para buscar usuarios por su ID.

### `uint256 private nextId;`

Esta variable lleva la cuenta del próximo ID disponible para un nuevo usuario. Se incrementa cada vez que se crea un usuario para asegurar que cada uno tenga un ID único.

### `event UserCreated(...)`, `UserUpdated(...)`, `UserDeleted(...)`

Los `eventos` son una forma de registrar lo que sucede en tu contrato en la blockchain. Son como "notificaciones" que las aplicaciones externas (como una interfaz de usuario web) pueden escuchar para saber cuándo se ha creado, actualizado o eliminado un usuario. Esto es muy útil porque leer directamente el estado de la blockchain puede ser costoso, pero escuchar eventos es más eficiente.

## Funciones del Contrato

### `createUser(string memory _name, uint256 _age) public`

*   **Propósito:** Añade un nuevo usuario a la lista.
*   **Parámetros:**
    *   `_name`: El nombre del usuario (texto).
    *   `_age`: La edad del usuario (número).
*   **Funcionamiento:** Crea un nuevo objeto `User` con un `id` único, el nombre y la edad proporcionados, y lo marca como `isActive = true`. Luego, emite un evento `UserCreated`.

### `readUser(uint256 _id) public view returns (User memory)`

*   **Propósito:** Obtiene la información de un usuario específico.
*   **Parámetros:**
    *   `_id`: El ID del usuario que quieres buscar.
*   **Funcionamiento:** Verifica que el usuario exista y esté activo. Si lo encuentra, devuelve el objeto `User` completo. Si no, revierte la transacción con un mensaje de error.
*   **`view`:** Significa que esta función no modifica el estado del contrato en la blockchain, por lo que no cuesta gas ejecutarla.

### `updateUser(uint256 _id, string memory _name, uint256 _age) public`

*   **Propósito:** Cambia el nombre y la edad de un usuario existente.
*   **Parámetros:**
    *   `_id`: El ID del usuario a actualizar.
    *   `_name`: El nuevo nombre.
    *   `_age`: La nueva edad.
*   **Funcionamiento:** Busca el usuario por su ID, verifica que exista y esté activo, y luego actualiza su nombre y edad. Emite un evento `UserUpdated`.

### `deleteUser(uint256 _id) public`

*   **Propósito:** "Elimina" lógicamente un usuario.
*   **Parámetros:**
    *   `_id`: El ID del usuario a "eliminar".
*   **Funcionamiento:** En lugar de borrar el usuario de la blockchain (lo cual es complicado y costoso), esta función simplemente cambia el valor de `isActive` a `false`. Esto significa que el usuario ya no se considerará activo, pero su registro aún existe. Emite un evento `UserDeleted`.

### `getAllActiveUsers() public view returns (User[] memory)`

*   **Propósito:** Obtiene una lista de todos los usuarios que están actualmente activos.
*   **Funcionamiento:** Recorre todos los usuarios registrados, cuenta cuántos están activos y luego crea un nuevo array solo con esos usuarios activos para devolverlo. Esta función también es `view` y no cuesta gas.

## ¿Cómo interactuar con este contrato?

Una vez desplegado en una red Ethereum (o una red de prueba), puedes interactuar con él usando herramientas como Remix, Hardhat, Truffle, o a través de una interfaz de usuario (DApp) que hayas construido. Cada función pública puede ser llamada para realizar las operaciones CRUD.