// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract SimplePetAdoption {
    // Rol 
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el owner");
        _;
    }

    modifier onlyNotOwner() {
        require(msg.sender != owner, "Solo para no-owners");
        _;
    }

    uint public constant TIME_LIMIT = 2 minutes;

    struct Pet {
        string name;
        address adopter;   
        uint timeAdopted; 
    }

    Pet[] public pets;

    event PetRegistered(string name, uint id);
    event PetAdopted(address adopter, uint id);
    event PetReturned(address adopter, uint id);

    constructor() {
        owner = msg.sender;
    }

    function registerPet(string memory _name) external onlyOwner {
        pets.push(Pet({name: _name, adopter: address(0), timeAdopted: 0}));
        emit PetRegistered(_name, pets.length - 1);
    }

    function adoptPet(uint _id) external onlyNotOwner {
        require(_id < pets.length, "ID invalido");
        Pet storage p = pets[_id];
        require(p.adopter == address(0), "Mascota ya adoptada");

        p.adopter = msg.sender;
        p.timeAdopted = block.timestamp;

        emit PetAdopted(msg.sender, _id);
    }

    function returnPet(uint _id) external onlyNotOwner {
        require(_id < pets.length, "ID invalido");
        Pet storage p = pets[_id];
        require(p.adopter != address(0), "Mascota no adoptada");
        require(p.adopter == msg.sender, "No eres el adoptante");
        require(block.timestamp <= p.timeAdopted + TIME_LIMIT, "Tiempo expirado");

        address prev = p.adopter;
        p.adopter = address(0);
        p.timeAdopted = 0;

        emit PetReturned(prev, _id);
    }

    function countAdopted() external view returns (uint count) {
        for (uint i = 0; i < pets.length; i++) {
            if (pets[i].adopter != address(0)) {
                count++;
            }
        }
    }
}
