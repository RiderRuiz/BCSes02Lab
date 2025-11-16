// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Loteria is ERC20, Ownable {

    address public nft;

    //La cuenta del ganador de la loteria
    address public ganador;

    mapping(address => address) public usuario_contract;

    //Calcula del precio de los tokens ERC-20
    function precioTokens(uint256 _numTokens) internal pure returns(uint256) {
        return _numTokens * (1 ether);
    }

    function balanceTokens(address _account) public view returns (uint256) {
        return balanceOf(_account);
    }

    constructor() ERC20("La Tinka Peru", "LTP") Ownable(msg.sender) {
        _mint(address(this) , 1000);
        nft = address(new MainERC721());
    }

}


contract MainERC721 is ERC721 {
    constructor() ERC721("La Tinka NFT", "LTN") {

    }
}

