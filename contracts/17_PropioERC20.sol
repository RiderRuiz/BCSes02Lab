// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "./16_ERC20.sol";

contract PropioERC20 is ERC20 {
    constructor() ERC20("Ballenita Fan Token", "BFT"){
        _mint(msg.sender, 1000);
    }
}