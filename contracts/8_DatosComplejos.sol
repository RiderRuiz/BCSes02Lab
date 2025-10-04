// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

contract DatosComplejos {

    string[] public nombres;

    event PersonaAgregada (string nombre, uint pos);

    struct Persona {
        string nombre;
        uint edad;
    }

    Persona[] public personas;
    

    function agregarNombre(string memory _nombre) public {
        nombres.push(_nombre);
    }

    function devolverTodosNombres() public view returns (string[] memory) {
        return nombres;
    }

    function pintarNombres() public view {
        for (uint i = 0; i < nombres.length; i++) {
            console.log(nombres[i]);
        }
    }

    function agregarPersonas(string memory _nombre, uint _edad) public {
        //directo
        personas.push(Persona(_nombre, _edad));
        emit PersonaAgregada(_nombre, personas.length - 1);     
    }

    function devolverPersona(uint pos) public view returns (string memory, uint) {
        return (personas[pos].nombre, personas[pos].edad);
    }

    function pintarPersonas() public view {
        for (uint i = 0; i < personas.length; i++) {
            console.log("nombre", personas[i].nombre);
            console.log("edad", personas[i].edad);
        }
    }


    
    /*
    string private saludo = "Hola mundo";

    bytes public data;

    function setSaludo(string memory _saludo) public {
        saludo = _saludo;
    }

    function getSaludo() public view returns (string memory) {
        return saludo;
    }

    function setData(bytes calldata _data) public {
        data = _data;
    }

    function devolverHexAsString() external view returns (string memory) {
        return string(data);
    }*/

}