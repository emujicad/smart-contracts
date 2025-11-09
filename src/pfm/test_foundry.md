# Guía de Pruebas en Foundry: Simulando Usuarios y Flujos de Trabajo

Esta guía explica cómo realizar pruebas efectivas en Foundry, aclarando la diferencia entre pruebas automatizadas de contrato y pruebas de interacción con un frontend, y cómo simular diferentes usuarios en tus tests.

---

## 1. El Objetivo: Probar como un Usuario Específico

Cuando probamos un contrato, a menudo queremos asegurarnos de que la lógica de permisos funciona correctamente. Por ejemplo: "Solo el `owner` puede llamar a esta función" o "Solo los usuarios con el rol `PRODUCER` pueden crear tokens".

Una confusión común es pensar que para probar esto, necesitamos conectar una billetera como MetaMask durante las pruebas de Foundry. **Esto no es correcto ni posible.**

-   **Pruebas de Contrato (`forge test`):** Verifican la lógica *interna* del contrato de forma automática y masiva.
-   **Pruebas de Interfaz de Usuario (UI/E2E):** Verifican el flujo *completo* desde que un usuario hace clic en un botón en una web hasta que la transacción se confirma, usando una billetera real como MetaMask.

`forge test` se enfoca exclusivamente en el primer tipo.

---

## 2. ¿Por Qué `forge test` no usa MetaMask?

Las pruebas de Foundry están diseñadas para ser:

1.  **Automáticas:** No deben requerir intervención humana. Esto es crucial para la Integración Continua (CI), donde los tests se ejecutan en un servidor cada vez que se sube código nuevo.
2.  **Rápidas:** Una suite de pruebas puede ejecutar miles de transacciones en segundos. Esperar una firma manual para cada una haría esto imposible.
3.  **Aisladas:** `forge test` es una herramienta de línea de comandos (CLI), mientras que MetaMask es una extensión de navegador. Son entornos separados que no están diseñados para comunicarse de esa manera.

---

## 3. La Forma Correcta: Simular Usuarios con Cheatcodes

Foundry te da herramientas muy poderosas para "fingir" ser cualquier usuario. Estas herramientas se conocen como **cheatcodes**. El principal que usarás es `vm.prank()`.

### `vm.prank(address)`

Este cheatcode le dice a Foundry: "La **siguiente llamada a una función** debe ser ejecutada como si viniera de la dirección `address`".

#### Ejemplo Práctico:

Imaginemos que queremos probar la función `createToken` de nuestro `SupplyChain.sol`, que está protegida por el modificador `onlyTokenCreators`.

```solidity
// test/SupplyChain.t.sol

import "forge-std/Test.sol";
import "../src/SupplyChain.sol";

contract SupplyChainTest is Test {
    SupplyChain supplyChain;
    
    // Direcciones de prueba que crearemos
    address owner;
    address producer = makeAddr("producer");
    address randomUser = makeAddr("randomUser");

    function setUp() public {
        // El contrato se despliega por defecto con la dirección del test como owner
        supplyChain = new SupplyChain();
        owner = supplyChain.owner(); // Guardamos la dirección del owner
        
        // Configuramos el rol de 'producer' para nuestra dirección de prueba
        // 1. Fingimos ser el owner para solicitar y aprobar el rol para 'producer'
        vm.prank(owner);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        // 2. Aprobamos al usuario 'producer'
        vm.prank(owner);
        supplyChain.changeStatusUser(producer, SupplyChain.UserStatus.Approved);
    }

    // Test 1: Un usuario con el rol correcto PUEDE llamar a la función
    function test_ProducerCanCreateToken() public {
        // Usamos vm.prank para la SIGUIENTE llamada.
        // Le decimos a Foundry: "La llamada a createToken debe ser firmada por 'producer'".
        vm.prank(producer); 
        
        supplyChain.createToken("Madera", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // La simulación de 'producer' termina aquí automáticamente.
        // El test pasa si la línea anterior no revierte.
        assertEq(supplyChain.getTokenBalance(1, producer), 100); // Verificamos el resultado
    }

    // Test 2: Un usuario sin el rol correcto NO PUEDE llamar a la función
    function test_Fail_RandomUserCannotCreateToken() public {
        // vm.expectRevert() le dice a Foundry que esperamos que la siguiente
        // llamada falle con un error específico.
        vm.expectRevert(SupplyChain.Unauthorized.selector);
        
        // Hacemos la llamada como 'randomUser' (quien no tiene rol)
        vm.prank(randomUser);
        supplyChain.createToken("Acero Ilegal", SupplyChain.TokenType.RowMaterial, 50, "", 0);
    }
}
```

### Otros Cheatcodes Útiles

-   **`vm.startPrank(address)` y `vm.stopPrank()`**: Similar a `prank`, pero la simulación se aplica a **todas las llamadas siguientes** hasta que se llama a `vm.stopPrank()`. Es útil cuando necesitas ejecutar una secuencia de varias funciones como el mismo usuario.

-   **`vm.expectRevert()`**: Se usa para probar que una función falla cuando debe hacerlo. Es fundamental para probar la seguridad y los modificadores.

---

## 4. Comandos Útiles de Foundry para Pruebas

Aquí tienes los comandos básicos que usarás:

-   **Ejecutar todos los tests:**
    ```bash
    forge test
    ```

-   **Aumentar la verbosidad (muy útil para depurar):**
    Muestra qué funciones se llaman y las trazas de las transacciones. `-vv` es un buen punto de partida, puedes llegar hasta `-vvvvv`.
    ```bash
    forge test -vv
    ```

-   **Ejecutar tests de un solo archivo:**
    ```bash
    forge test --match-path test/SupplyChain.t.sol
    ```

-   **Ejecutar un solo test dentro de un archivo:**
    ```bash
    forge test --match-test test_ProducerCanCreateToken
    ```

-   **Ejecutar tests que coincidan con un contrato de prueba:**
    ```bash
    forge test --match-contract SupplyChainTest
    ```

---

## 5. ¿Cuándo y Cómo Usar MetaMask?

Usas MetaMask para las **pruebas de extremo a extremo (E2E)**, donde pruebas la interacción de tu **frontend** con el contrato.

El flujo de trabajo es:
1.  **Inicia tu nodo local:** `anvil`
2.  **Despliega tu contrato en Anvil:** `forge script ...`
3.  **Configura MetaMask:** Añade la red de Anvil (`http://127.0.0.1:8545`, Chain ID `31337`).
4.  **Importa una cuenta de Anvil:** Usa una de las claves privadas que Anvil te proporciona.
5.  **Lanza tu aplicación web:** `npm run dev` o similar.
6.  **Prueba manualmente:** Interactúa con tu web en el navegador. MetaMask se abrirá para firmar las transacciones, que se enviarán a tu nodo local de Anvil.

Este proceso prueba que tu DApp (contrato + frontend) funciona como un todo para un usuario final.
