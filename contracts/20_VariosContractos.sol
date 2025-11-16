// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CalculadoraNotas {
/*
    // Ejemplo: 30% practica, 30% teoria, 40% proyecto
    function calcularNotaFinal(uint256 practica, uint256 teoria, uint256 proyecto) 
                                                    external pure returns (uint256) {        
        uint256 notaFinal = (practica * 30 + teoria * 30 + proyecto * 40) / 100;
        return notaFinal;
    }

    */

    function calcularNotaFinal(uint256 practica, uint256 teoria, uint256 proyecto) 
                                                    external pure returns (uint256) {        
        uint256 notaFinal = (practica * 10 + teoria * 10 + proyecto * 80) / 100;
        return notaFinal;
    }

}


contract RegistroNotas is Ownable {

    // Dirección del contrato CalculadoraNotas
    address public addressCalculadora;

    // Nota final de cada alumno (por address)
    mapping(address => uint256) public notasAlumnos;
    

    constructor(address _addressCalculadora) 
        Ownable(msg.sender) {
        addressCalculadora = _addressCalculadora;
    }

    // Permite cambiar la calculadora si hubiera una nueva versión
    function actualizarCalculadora(address _addressCalculadora) onlyOwner external {
        addressCalculadora = _addressCalculadora;
    }

    // Registrar la nota de un alumno
    function registrarNota(
        address _alumno,
        uint256 _practica,
        uint256 _teoria,
        uint256 _proyecto
    ) onlyOwner external {
                require(addressCalculadora != address(0), "Calculadora no configurada");

        // Llamamos al otro contrato
        CalculadoraNotas contratoCalculadora = CalculadoraNotas(addressCalculadora);

        uint256 nota = contratoCalculadora.calcularNotaFinal(_practica, _teoria, _proyecto);

        notasAlumnos[_alumno] = nota;
    }

    // Atajo para que un alumno vea su propia nota
    function miNotaFinal() external view returns (uint256) {
        return notasAlumnos[msg.sender];
    }
}

