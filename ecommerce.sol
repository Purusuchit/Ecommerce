// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ecommerce{
    struct Product{
        string title;
        string desc;
        uint price;
        uint productID;
        address payable seller;
        address buyer;
        bool delivered;
    }

    uint Counter = 1;
    Product[] public products;
    event registered(string title, uint productID, address seller);
    event bought(uint productID, address buyer);
    event deliver(uint productID);

    function prodRegister(string memory _title, string memory _desc, uint _price) public{
        require(_price>0,"Price should be greater thsn zero");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price*10**18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productID = Counter;
        products.push(tempProduct);
        Counter++;
        emit registered(_title, tempProduct.productID, msg.sender);
    }

    function buy(uint _productID) payable public{
        require(products[_productID-1].price==msg.value,"Please enter the exact price");
        require(products[_productID-1].seller!= msg.sender,"Seller cannot be the buyer");
        require(products[_productID-1].buyer == msg.sender);
        emit bought(_productID, msg.sender);
    }

    function delivery(uint _productID) payable public{
        require(products[_productID-1].buyer == msg.sender,"You are not the buyer");
        products[_productID-1].delivered = true;
        products[_productID-1].seller.transfer(products[_productID-1].price);
        emit deliver(_productID);
    }
}