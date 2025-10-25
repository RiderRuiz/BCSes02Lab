// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";
import "./15_IERC20.sol";

contract ERC22 is IToken20 {

    
    mapping(address => uint256) private _balances;
    //Owner (Luis) -> (Alice) 50 tokens
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;    
    }

    function name() public view virtual returns(string memory) {
        return _name;
    }

    function symbol() public view virtual returns(string memory) {
        return _symbol;
    }

    //concepto decimales
    function decimals() public view virtual returns(uint8) {
        return 18;
    }

    //override: la funcion que anula la funcion base establecida como virtual
    function totalSupply() public view virtual override returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
      
        address from = msg.sender;
        require(from != address(0), "ERC20: incorrecto from"); //validacion de que no se transfiera desde la direccion cero
        require(to != address(0), "ERC20: incorrecto to"); //validacion de que no se transfiera hacia la direccion cero
        
        _beforeTokenTransfer(from, to, amount);
        
        uint256 fromBalance = _balances[from]; //obtenemos el balance de from (emisor)
        require(fromBalance >= amount, "ERC20: Balance de From debe ser mayor o igual a amount");
        unchecked {
            _balances[from] = fromBalance - amount; //descontamos el balance del emisor
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);

        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
        //dos tiempos
        //mapping(address => uint256) storage permiso = _allowances[owner];
        //return permiso[spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = msg.sender;
        require(spender != address(0), "ERC20: spender no debe ser la direccion cero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);

        return true;

    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = msg.sender;

        require(from != address(0), "ERC20: from no debe ser la direccion cero");
        require(to != address(0), "ERC20: to no debe ser la direccion cero");

        //1. vamos a verificar y actualizar "gastar" el allowence
        uint256 currentAllowance = allowance(from, spender);        
        require(currentAllowance >= amount, "ERC20: Allowance insuficiente");
        uint256 newAllowance = currentAllowance - amount;
        _allowances[from][spender] = newAllowance;
        emit Approval(from, spender, newAllowance); //opcional

        // 2. Antes de mover los saldos
        _beforeTokenTransfer(from, to, amount);

        //3. Realizar la Transferencias
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: balance insuficiente");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        //4. Evento y hook final
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);

        return true;

    }        

    //permite que pueda incrementarle el permiso a un tercero
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;

        require(spender != address(0), "ERC20: spender no debe ser la direccion cero");

        uint256 currentAllowence = _allowances[owner][spender];
        uint256 updatedAllowence = currentAllowence + addedValue;
        _allowances[owner][spender] = updatedAllowence;

         emit Approval(owner, spender, updatedAllowence);
         return true;        
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = msg.sender;
        require(spender != address(0), "ERC20: spender no debe ser la direccion cero");
        uint256 currentAllowance = _allowances[owner][spender];
        //validaremos si tiene la cantidad necesaria para sustraer
        require(currentAllowance >= subtractedValue, "ERC20: la reduccion de la autorizacion (allowance) quedo por debajo de cero");
        uint256 updatedAllowance = currentAllowance - subtractedValue;
        _allowances[owner][spender] = updatedAllowance;
        emit Approval(owner, spender, updatedAllowance);
        return true;
    }   

    //address(0) es una direccion +> 000000000000... ese address cero nunca sera usable ni asignable
    //Especial para crear o destruir tokens
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: Mint debe asignarse a una cuenta valida");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount; //aumentamos el balance de la direccion account
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: Burn debe asignarse a una cuenta valida");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: La cantidad a burn excede el balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
         _afterTokenTransfer(account, address(0), amount);
    }    

    function _beforeTokenTransfer (address from, address to, uint256 amount) internal virtual {        

    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {
        
    }

}
