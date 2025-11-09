// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./10_Padre.sol";

contract Perro is Animal {
    constructor() Animal("Perro") {}

    function hacerSonido() public pure override returns (string memory) {
        return "guau guau";    
    }
    function devolverEdad() public pure returns (uint){
        return getEdad();
    }

}
