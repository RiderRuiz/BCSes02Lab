// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MiTokenERC20 is ERC20 {

    constructor(uint256 initialSupply) ERC20("Ballenita Fan Token", "BFT") {
        _mint(msg.sender, initialSupply);
    }

}
