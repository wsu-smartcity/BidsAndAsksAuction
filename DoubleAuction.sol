contract DoubleAuction {
    
    struct Bid {
        address owner;
        uint price;
        uint amount;
        uint date;
    }
    struct Ask {
        address owner;
        uint price;
        uint amount;
        uint date;
    }

    Bid[] public BidLedger;
    Ask[] public AskLedger;

    function submitBid(uint _price, uint _amount, address _owner )  returns (bool) {
        Bid memory b;
        b.price = _price;
        b.amount = _amount;
        b.owner = _owner;
        b.date = now;
        for(uint i = 0; i < BidLedger.length; i++) {
            if (BidLedger[i].price < _price) {
                Bid[] memory tempLedger = new Bid[](BidLedger.length - i);
                for(uint j = 0; j < tempLedger.length; j++) {
                    tempLedger[j] = BidLedger[j+i];
                }
                BidLedger[i] = b;
                BidLedger.length ++;
                for(uint k = 0; k < tempLedger.length; k++) {
                    BidLedger[k+i+1] = tempLedger[k];
                }
                return true;
            }
        }
        BidLedger.push(b);
        return true;
    }
    function getbid(uint bid_index) external returns(uint,uint){
        return (BidLedger[bid_index].price,BidLedger[bid_index].amount);
    }

    function submitAsk(uint _price, uint _amount, address _owner )  returns (bool) {
        Ask memory a;
        a.price = _price;
        a.amount = _amount;
        a.owner = _owner;
        a.date = now;
        for(uint i = 0; i < AskLedger.length; i++) {
            if(AskLedger[i].price > _price) {
                Ask[] memory tempLedger = new Ask[](AskLedger.length - i);
                for(uint j = 0; j < tempLedger.length; j++) {
                    tempLedger[j] = AskLedger[j+i];
                }
                AskLedger[i] = a;
                AskLedger.length += 1;
                for(uint k = 0; k < tempLedger.length; k++) {
                    AskLedger[k+i+1] = tempLedger[k];
                }
                return true;
            }
        }
        AskLedger.push(a);
        return true;
    }
    function getask(uint ask_index) external returns(uint,uint){
        return (AskLedger[ask_index].price,AskLedger[ask_index].amount);
    }

     function matchBidAndAsks(uint bid_index) returns (bool) {
         uint _index =0;
         while (_index < AskLedger.length && BidLedger[bid_index].amount !=0 && BidLedger[bid_index].price !=0){
        
            if (AskLedger[_index].amount < BidLedger[bid_index].amount){
                BidLedger[bid_index].amount = BidLedger[bid_index].amount - AskLedger[_index].amount;
                BidLedger[bid_index].price = BidLedger[bid_index].price - AskLedger[_index].price;
                AskLedger[_index].amount =0;
                AskLedger[_index].price =0;
                delete AskLedger[_index];
            }
            else if (AskLedger[_index].amount > BidLedger[bid_index].amount){
                uint amount_per_dollar = AskLedger[_index].amount / AskLedger[_index].price;
                while (BidLedger[bid_index].price != 0 ){
                    BidLedger[bid_index].price -- ;
                    BidLedger[bid_index].amount = BidLedger[bid_index].amount - amount_per_dollar;
                    AskLedger[_index].price = AskLedger[_index].price - 1;
                    AskLedger[_index].amount = AskLedger[_index].amount - amount_per_dollar;
                }
            }
            _index++;
         }
         return true;
     }
     

    function cleanAskLedger() returns (bool) {
        for(uint i = AskLedger.length - 1; i > 0; i--) {
            if(AskLedger[i].amount > 0) {
                AskLedger.length = i + 1;
                delete AskLedger[i];
            }
        }
        return true;
    }

    function cleanBidLedger() returns (bool) {
        for(uint i = BidLedger.length - 1; i > 0; i--) {
            if(BidLedger[i].amount <= 0) {
                BidLedger.length = i + 1;
                delete AskLedger[i];
            }
        }
        return true;
    }

}
