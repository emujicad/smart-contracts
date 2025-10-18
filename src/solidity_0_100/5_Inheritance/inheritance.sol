// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
#################################################################
#                            HERENCIA                           #
#################################################################
#  - La herencia es uno de los pilares de la programación       #
#    orientada a objetos. Permite que un contrato (hijo)        #
#    adquiera los atributos y métodos de otro (padre).          #
#  - En Solidity, se usa la palabra clave `is`.                 #
#  - `virtual`: Permite que una función en un contrato padre    #
#    sea sobrescrita por un contrato hijo.                      #
#  - `override`: Se usa en el contrato hijo para indicar que se #
#    está sobrescribiendo una función del padre.                #
#                                                               
#  - function                                                   #
#  - herencia                                                   #
#  - override                                                   #
#################################################################
*/


/**
 * @title A
 * @dev Este es el contrato "abuelo" o base. Define un conjunto de funciones.
 */
contract A {
    /**
     * @dev Una función `virtual`. Esto significa que los contratos que hereden de A
     * tienen permiso para cambiar el comportamiento de esta función.
     */
    function foo() public pure virtual returns(string memory) {
        return "A";
    }

    /**
     * @dev Otra función `virtual`, igual que `foo`.
     */
    function bar() public pure virtual returns(string memory) {
        return "A";
    }

    /**
     * @dev Esta función NO es `virtual`. Ningún contrato hijo podrá
     * cambiar lo que hace esta función. Podrán llamarla, pero no sobrescribirla.
     */
    function baz() public pure returns(string memory) {
        return "A";
    }
}

/**
 * @title B
 * @dev Este contrato hereda de A (`is A`). Se considera un contrato "hijo" de A.
 */
contract B is A {
    /**
     * @dev Aquí sobrescribimos la función `foo` de A. Es obligatorio usar `override`.
     * Como no la marcamos como `virtual` de nuevo, ningún hijo de B podrá
     * volver a cambiar `foo`.
     */
    function foo() public pure override returns(string memory) {
        return "B";
    }

    /**
     * @dev Aquí sobrescribimos `bar` de A, pero también la marcamos como `virtual`.
     * Esto significa que estamos cambiando su comportamiento, pero a la vez
     * damos permiso a los hijos de B para que la vuelvan a sobrescribir.
     */
    function bar() public pure override virtual returns(string memory) {
        return "B";
    }
}

/**
 * @title C
 * @dev Este contrato hereda de B (`is B`). Es un "hijo" de B y un "nieto" de A.
 */
contract C is B {
    /**
     * @dev Sobrescribimos la función `bar`. Esto es posible porque B la marcó
     * como `virtual`.
     * Si intentáramos sobrescribir `foo`, el compilador daría un error, porque
     * en B, `foo` no fue marcada como `virtual`.
     */
    function bar() public pure override returns(string memory) {
        return "C";
    }

    // Al desplegar C:
    // - C.foo() devuelve "B" (heredado de B)
    // - C.bar() devuelve "C" (su propia implementación)
    // - C.baz() devuelve "A" (heredado de A, nunca se sobrescribió)
}