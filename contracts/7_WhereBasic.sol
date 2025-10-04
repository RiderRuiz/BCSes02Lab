// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract RecibirYMostrarBalance {
    receive() external payable { }
    
    function donar() public payable{

    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}