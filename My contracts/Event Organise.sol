//SPDX-License-Identifier: GPL-3.0
//vishal nakhate
 
pragma solidity >=0.5.0 <0.9.0;

contract EventContract{

    //creating database of event
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event)public events;
    mapping(address=>mapping(uint=>uint))public tickets;
    uint public nextId;

    //creating function to organize event
    function createEvent(string memory name, uint date, uint price, uint ticketCount) external{
        require(date>block.timestamp,"You can organise event for future date");
        require(ticketCount>0,"Tickets not available, please organise event for more then 0 tickets");

        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    //Creating function to buy ticket from organizer
    function buyTicket(uint id, uint quantity) external payable {
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already completed");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ethers is not enough");
        require(_event.ticketRemain>=quantity,"Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+= quantity;      
    }

    //special function for transfer ticket to other account  
    function transferTicket(uint id, uint quantity, address to) external {
        require(events[id].date!=0, "Event does not exist");
        require(events[id].date>block.timestamp,"event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }

}