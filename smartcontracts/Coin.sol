// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    // Le mot clé "public" rend les variables
    // accessibles depuis d'autres contrats
    address public minter;
    mapping (address => uint) public balances;

    // Les événements permettent aux clients de réagir à des
    // changements de contrat que vous déclarez
    event Sent(address from, address to, uint amount);

    // Le code du constructeur n'est exécuté que lorsque le contrat
    // est créé
    constructor() {
        minter = msg.sender;
    }

    // Envoie une quantité de pièces nouvellement créées à une adresse.
    // Ne peut être appelé que par le créateur du contrat
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Les erreurs vous permettent de fournir des informations sur
    // pourquoi une opération a échoué. Elles sont renvoyées
    // à l'appelant de la fonction.
    error InsufficientBalance(uint requested, uint available);

    // Envoie un montant de pièces existantes
    // de n'importe quel appelant à une adresse
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
