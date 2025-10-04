// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";

contract MyWhile {

    //sumar 'n' primeros numeros pares en un variable
    //suma 'n' primeros numeros impares en otra variable
    //retorna ambas sumatorias

    function sumNumbers(uint n) public pure returns (uint) {
        
        uint suma = 0;

        uint i = 1;
        uint count = 0;
        while (count < n) {
            if (i % 2 == 0) {
                console.log("Sumar: ", i);
                suma += i;
                count++;
            }
            i++;
        }

        return suma;
    }


function sumNumeros(uint n) public pure returns (uint, uint) {
        
        uint sumaPares = 0;
        uint sumaImpares = 0;

        uint countPares = 0;
        uint countImpares = 0;

        uint i = 1;
        while (countPares < n || countImpares < n) {
            if (i % 2 == 0) {
                console.log("Sumar Pares: ", i);
                sumaPares += i;
                countPares ++;
               
            } else {
                console.log("Sumar Impares: ", i);
                sumaImpares += i;
                countImpares ++;
            }
            i++;
        }

        return (sumaPares, sumaImpares);
    }
}