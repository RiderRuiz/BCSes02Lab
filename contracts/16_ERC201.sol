// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "./15_IERC20.sol";


contract ERC20 is IToken20{

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns(uint) {
        return 18;
    }

    //virtual override --> Te sobreescribo pero permito que mis hijos puedan volver a sobreescribir
    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        address from = msg.sender;

        require(to != address(0), "ERC20: TO incorrecto");

        //restar a cuenta FROM
        uint256 balanceFrom = _balances[from];
        require(balanceFrom >= amount, "ERC20: Su balance debe ser mayor o igual a amount");
        _balances[from] = balanceFrom - amount;

        //sumar a la cuenta TO
        _balances[to] += amount;
        emit Transfer(from, to, amount); //opcional
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        address owner = msg.sender;
        require(spender != address(0), "ERC20: La cuenta spender no debe ser direccion cero");

        _allowances[owner][spender] = amount; //obtiene del mapping de allowances del propietario, encuentra el spender y le asigna un amount
        emit Approval(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        address spender = msg.sender;
        require(from != address(0), "ERC20: La cuenta FROM no debe ser direccion cero");
        require(to != address(0), "ERC20: La cuenta TO no debe ser direccion cero");

         //1. verificar antes de gastar el amount (consultar si el allowance es suficiente)
        uint256 currentAllowance = _allowances[from][spender];
        require(currentAllowance >= amount, "ERC20: Allowance insuficiente");
        //2. reducir el allowance
        _allowances[from][spender] = currentAllowance - amount;
        emit Approval(from, to, currentAllowance - amount);

        //3. Realizar transferencia: Restarle al FROM y sumarle al TO
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: Balance de la cuenta FROM insuficiente");
        _balances[from] = fromBalance - amount;
        _balances[to] += amount;
        
        //4. Emitir evento
        emit Transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;
        require(spender != address(0), "ERC20: La cuenta SPENDER no debe ser direccion cero");

        uint256 currentAllowance = _allowances[owner][spender];
        _allowances[owner][spender] = currentAllowance + addedValue;
        emit Approval(owner, spender, currentAllowance + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = msg.sender;
        require(spender != address(0), "ERC20: La cuenta SPENDER no debe ser direccion cero");

        uint256 currentAllowance = _allowances[owner][spender];
        require(currentAllowance >= subtractedValue, "ERC20: La reduccion del allowance no debe ser negativa");
        _allowances[owner][spender] = currentAllowance - subtractedValue;
        emit Approval(owner, spender, currentAllowance - subtractedValue);
        return true;
    }

    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "ERC20: El mint debe asignarse a una cuenta valida");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount); 
    }

    //function burn

}


