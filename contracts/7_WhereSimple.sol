// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;


contract WhereSimple {
    uint256 public zipCode;
    address payable public destAccount;

    constructor(uint256 _zipCode) {
        zipCode = _zipCode;
        destAccount = payable(0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678);
    }

    function setZipCode(uint256 _newZipCode) public payable {
        require(msg.value >= 0.01 ether, "El valor debe ser minimo 0.01");       
        zipCode = _newZipCode;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public  {
        destAccount.transfer(address(this).balance);
    }

}