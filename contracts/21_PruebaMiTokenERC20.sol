// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PruebaMiTokenERC20 {
    function devolverBalance() public view returns(uint256) {

        ERC20 tokenERC20 = ERC20(0x2E9d30761DB97706C536A112B9466433032b28e3);
        uint balance = tokenERC20.balanceOf(msg.sender);

        return balance;

    }
} 
