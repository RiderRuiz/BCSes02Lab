// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

interface IToken20 {

    /**
    * Permite saber el numero de tokens que existen
    */
    function totalSupply() external view returns (uint256);

    /**
    * Permite saber el saldo de una direccion
    */
    function balanceOf(address account) external view returns (uint256);

    /**
    * Mover tokens de un emisor a un receptor (from 'msg.sender' -> to)
    */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
    * El duenio autoriza a un tercero 'spender' para gastar cierta cantidad de sus tokens
    * Patron de delagacion, asociado con transferFrom
    */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
    * Permite saber cuanto mas puede gastar el spender de su gasto asignado
    * Cuando interactuamos con apps van a consultar antes de intentar gastar
    */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
    * Permite al spender transferir Tokens en nombre del "duenio de la cuenta"
    * Siempre y cuando tenga esa facultar (que le hayan hecho approve)
    */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    /**
    * Registra log cada movimiento de tokens
    * indexed nos va permitir buscar rapidamente por remitente o destinatario
    */
    event Transfer(address indexed from, address indexed to, uint256 amount);


    /**
    * Registra un permiso de gasto de un owner a un spender y por cuanto
    */
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    
}