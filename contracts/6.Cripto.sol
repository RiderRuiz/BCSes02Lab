// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Cripto {
    address alice;

    constructor () {
        alice = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
    }

    event MensajeEncriptado(
        address from,
        address to,
        bytes mensajeEncriptado
    );

    function enviarMensaje(bytes memory _textoCifrado) public{
        emit MensajeEncriptado(msg.sender, alice, _textoCifrado);
    }
}