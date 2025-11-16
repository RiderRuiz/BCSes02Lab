// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArtToken is ERC721, Ownable {

    //autoincremental del tokenId
    uint256 private COUNTER;

    //comision para crear un token en nuestro contrato - blockchain
    uint256 public fee = 2 ether;

    constructor(string memory _name, string memory _symbol) 
        ERC721(_name, _symbol) 
        Ownable(msg.sender) {

    }

    struct Art {
        string name;
        uint256 id;
        uint8 level;
        uint rarity;
    }

    Art[] public art_works;

    event NewArtWork(address owner, uint256 id, string name);

    //Sirve para generar un numero random
    //devuelve un uint >= 0 && < _mod
    function _createRandomNum(uint256 _mod) internal view returns(uint256) {
        bytes32 hashRandom = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(hashRandom);
        return randomNum  % _mod;
    }

    function _createArtWork(string memory _name) internal {

        uint8 randRarity = uint8(_createRandomNum(256));

        Art memory newArtWork = Art({
            name: _name,
            id: COUNTER,
            level: 1,
            rarity: randRarity
        });

        art_works.push(newArtWork);
        _safeMint(msg.sender, COUNTER);
        emit NewArtWork(msg.sender, COUNTER, _name);
        COUNTER++;
    }

    // ******************
    // Funciones Ayuda Token
    // ******************
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    function getArtWorks() public view returns(Art[] memory) {
        return art_works;
    }

    function getArtWorksByOwner(address _owner) public view returns (Art[] memory) {

        Art[] memory artWorks = new Art[](balanceOf(_owner));
        uint256 count = 0;

        for(uint256 i = 0; i < artWorks.length; i++) {
            if(ownerOf(i) == _owner) {
                artWorks[count] = art_works[i];
                count ++;
            }
        }

        return artWorks;
    }

    function createRandomArtWork(string memory _name) public payable {
        require(msg.value >= fee, "ERROR: No se alcanzo el pago minimo de fee");
        _createArtWork(_name);
    }

    function infoSmartContract() public view returns (address, uint256) {
        address scAddress = address(this);
        uint256 scMoney =  scAddress.balance / (10 ** 18);
        return(scAddress, scMoney); 
    }

    function levelUp(uint256 _artId) public {
        Art storage art = art_works[_artId]; //storage al arreglo quiere decir que cualquier cambio cambia ese atributo de estado
        art.level = art.level + 1;
    }

    function withdraw() external {
        payable(owner()).transfer(address(this).balance);
    }

}

