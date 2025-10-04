// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

/**
Implementar un contrato que permita al propietario del contrato enviar mensajes a otro usuario.
Cada mensaje debe guardar:
La dirección del remitente (from) //siempre es el propietario
La dirección del destinatario (to)
El contenido del mensaje (contenido)
La fecha y hora en que fue enviado (timestamp) //block.timestamp
Cada vez que se envíe un mensaje:
Debe guardarse en una estructura (struct)
Debe emitirse un evento para dejar registro público en la blockchain
Debe pintar todos los mensajes con console.log
Para agregar un nuevo mensaje deberia pasar al menos un minuto

*/

contract EjercicioMensajes {
    struct Mensaje{
        address from;
        address to;
        string contenido;
        uint256 timestamp;    
    }

    Mensaje[] public mensajes;

    function enviarMensaje(address _to, string memory _contenido) public{
        mensajes.push(Mensaje(msg.sender, _to, _contenido, block.timestamp));
    }

    function pintarDestinatarioMensajes() public view {
        for (uint256 i = 0; i < mensajes.length; i++) {
            console.log("Mensaje a: ", mensajes[i].to);
        }
    }



}