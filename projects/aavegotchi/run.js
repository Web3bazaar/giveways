


let template = 
{
    id: '',
    name : "Aavegotchi Raffle Ticket #",
    description :"Testnet giveaway raflle tickets - Aavegotchi",
    externalURL: "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/aavegotchi/data/",
    image: "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/aavegotchi/assets/aavegotchi-w3b.png"
 }


 let writePath = './data'

 const fs = require('graceful-fs');

let startIndex = 11//6;
let lastIndex = 15;

for (let index = startIndex; index <= lastIndex; index++) {
    
    let data = JSON.parse( JSON.stringify(template))
    data.id = index;
    data.name = data.name + index
    data.externalURL = data.externalURL + index
    let fileId = fs.writeFile(writePath + '/'+ index ,JSON.stringify(data), function (err) {
        if (err) return console.log(err);
        console.log('index is #',index );
      });


}



