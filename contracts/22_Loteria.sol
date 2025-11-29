// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Loteria is ERC20, Ownable { 

    address public nft;

    //La cuenta del ganador de la loteria
    address public ganador;

    mapping(address => address) public usuario_contract; //graba un cliente de loteria vs 

    constructor() ERC20("La Tinka Peru", "LTP") Ownable(msg.sender) {
        _mint(address(this) , 1000);
        nft = address(new MainERC721());
    }

    //Calcula del precio de los tokens ERC-20
    function precioTokens(uint256 _numTokens) internal pure returns(uint256) {
        return _numTokens * (1 ether);
    }

    //Visualizacion del balance de tokens ERC-20 de una cuenta
    function balanceTokens(address _account) public view returns (uint256) {
        return balanceOf(_account);
    }

    //Visualizacion del balance de tokens ERC-20 pero del smart contract
    function balanceTokensSC() public view returns (uint256) {
        return balanceOf(address(this));
    }

    //Visualizacion del balance de Ethers del smart contract
    function balanceEthersSC() public view returns(uint256){
        address sc = address(this);
        return sc.balance / (10 ** 18);  
    }

    function mint(uint256 _nuevosTokens) public onlyOwner {
        _mint(address(this), _nuevosTokens); //heredado de ERC20
    }

    function registrar() internal {
        address addr_personal_contract = address(new BoletosNFTs(msg.sender, address(this), nft));
        usuario_contract[msg.sender] = addr_personal_contract; 
    }

    function comprarTokens(uint _numTokens) public payable {
        //no deberia guardarse mas de una vez
        if(usuario_contract[msg.sender] == address(0)) {
            registrar();
        }

        //Establecer el costo de los tokens
        uint256 costoTokens = precioTokens(_numTokens);
        require(msg.value >= costoTokens, "No te alccanza para pagar. Compra menos o paga mas ethers");
        //hay que evitar que se compren mas tokens de los disponibles en el contrato
        uint256 balance = balanceTokensSC();
        require(_numTokens <= balance, "Compra un numero menor de tokens");

        //Devolucion de dinero sobrante
        uint256 returnValue = msg.value - costoTokens;

        //El smart contract devuelve la cantidad restante
        payable(msg.sender).transfer(returnValue);

        //Envio de tokens al cliente/usuario
        _transfer(address(this), msg.sender, _numTokens);

    }

    function devolverTokens(uint _numTokens) public payable {

        //El numero de otkens debe ser mayor a cero
        require(_numTokens > 0, "Necesitas devolver un numero de tokens mayor a cero");
        //Se debe validar que el usuario tenga los tokens que quiera devolver
        require(_numTokens <= balanceTokens(msg.sender), "No tienes los tokens que deseas devolver");

        //El usuario transfiere los tokens al SC
        _transfer(msg.sender, address(this), _numTokens);
        payable(msg.sender).transfer(precioTokens(_numTokens));
    }

    function userInfo(address _account) public view returns (address) {
        return usuario_contract[_account];
    }


    // ==============
    // Gestion de la loteria ::: variables
    // ==============

    uint public precioBoleto = 5;

    mapping(address => uint[]) idPersona_boleto;

    mapping(uint => address) boletoGanador;

    uint randNonce = 0;

    uint [] boletosComprados;

    mapping(uint256 => address) boletoUsuario;

    // ==============
    // Gestion de la loteria ::: proceso compra
    // ==============

    function comprarBoleto(uint _numBoletos) public {

        //Precio total de los boletos a comprar
        uint precioTotal = _numBoletos * precioBoleto;

        require(precioTotal <= balanceTokens(msg.sender), "No tienes tokens sufucientes");

        _transfer(msg.sender, address(this), precioTotal);

        //Generar
        for(uint i = 0; i < _numBoletos; i++) {
            uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce)));

            randNonce ++;

            boletosComprados.push(random);

            boletoUsuario[random] = msg.sender;

            BoletosNFTs(usuario_contract[msg.sender]).mintBoleto(msg.sender, random);

            idPersona_boleto[msg.sender].push(random);

        }

    }

    function tusBoletos(address _propietario) public view returns(uint[] memory) {
        return idPersona_boleto[_propietario];
    }

    function generarGanador() public onlyOwner {
        
    }
    

}


contract MainERC721 is ERC721 {

    address public addressLoteria;

    constructor() ERC721("La Tinka NFT", "LTN") {
        addressLoteria = msg.sender; //Recordemos que msg.sender inicialmente es el contrato padre 'Loteria' cuando hizo el new [en su constructor] 
    }

    function safeMint(address _propietario, uint256 _boleto) public{
        require(msg.sender == Loteria(addressLoteria).userInfo(_propietario), "No tienes permisos para ejecutar esta funcion");
        _safeMint(_propietario, _boleto); //herencia de ERC721
        
    }
}

contract BoletosNFTs {

    struct Holder {
        address addressPropietario;
        address contratoPadre; 
        address contratoNFT;
        address contratoUsuario;
    }

    Holder public propietario;


    constructor(address _propietario, address _contratoPadre, address _contratoNFT) {
        propietario = Holder(_propietario, _contratoPadre, _contratoNFT, address(this));
    }

    function mintBoleto(address _propietario, uint _boleto) public {
        require(msg.sender == propietario.contratoPadre, "No tiene permisos para ejecutar esta funcion");
        MainERC721 contratoNFT = MainERC721(propietario.contratoNFT);
        contratoNFT.safeMint(_propietario, _boleto);
    }
}

