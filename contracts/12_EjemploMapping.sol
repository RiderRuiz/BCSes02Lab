// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;


contract EjemploMapping {
    
    struct Persona {
        string nombre;
        uint edad;
    }

    mapping(uint => Persona) public personasMapping;

    function agregarPersonaMapping(uint _id, string memory _nombre, uint _edad) public{
        personasMapping[_id] = Persona(_nombre, _edad);
    }

}
