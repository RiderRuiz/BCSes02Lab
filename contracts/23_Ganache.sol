// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Ganache {

    string private message = "";

    event newMessage(string _message);

    constructor() {

    }

    function setMessage(string memory _message) public {
        message = _message;
        emit newMessage(_message);
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

}