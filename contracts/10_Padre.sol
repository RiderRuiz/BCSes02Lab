// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Animal {
    string public especie;

    constructor(string memory _especie) {
        especie = _especie;
    }

    function hacerSonido() public pure virtual  returns (string memory) {
        return "Sonido generico de animal";    
    }

    function devolverEspecie() public view returns (string memory) {
        return string(abi.encodePacked("Especie: ", especie)); 
    }
}