// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MiniNFT is ERC721, Ownable{

    //autoincremental del tokenID
    uint256 private COUNTER;

    //Comision para crear token nuevo en nuestro contrato - BC
    uint256 public  fee = 2 ether;

    constructor(string memory _name, string memory _symbol) 
    ERC721(_name,_symbol)
    Ownable(msg.sender){
    }

    struct Art {
        string name;
        uint256 id;
        uint level;
        uint rarity;
    }
    Art[] public art_works;
    event NewArtWork(address owner, uint256 id, string name);
    //evento

    //Sirve para generar un numero random
    //devuelve un uint >=0 && < _mod
    function _createRandomNum(uint256 _mod) internal view returns(uint256){
        bytes32 hashRandom = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(hashRandom);
        return randomNum % _mod;
    }
    function _createArtWork(string memory _name) internal{

        uint8 randRarity = uint8(_createRandomNum(100));
        Art memory newArtWork = Art({
            name:_name,
            id:COUNTER,
            level:1,
            rarity: randRarity
        });
        
        art_works.push(newArtWork);
        _safeMint(msg.sender, COUNTER);
        emit NewArtWork(msg.sender, COUNTER, _name);
        COUNTER++;
    }

    //******************
    //Funcion ayuda Token
    //******************
    function updateFee(uint256 _fee) external onlyOwner {
        fee= _fee;
    }

    function getArtWorks() public returns (Art[] memory){
        return art_works;
    }
//tokens en general = 2
//tokens del propietario = 2

    function getArtWorksByOwner(address _owner) public view returns (Art[] memory){

        Art[] memory artWorks = new Art[](balanceOf(_owner));
        uint256 count = 0;

        for(uint256 i = 0; i < artWorks.length ; i++){
            if(ownerOf(i) == owner){
                artWorks[count] = art_works[i];
                count ++;
            }
        }
        return artWorks;
    }
    function _createRandomNumArtWork(string memory _name) public payable {
        require(msg.value >= fee, "ERROR: No se alcanzo el pago minimo de fee");
        _createArtWork(_name);
    }
}
