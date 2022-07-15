


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

let startIndex = 75001;
let lastIndex =  100000;

for (let index = startIndex; index <= lastIndex; index++) {
    
    let data = JSON.parse( JSON.stringify(template))
    data.id = index;
    data.name = data.name + index
    data.externalURL = data.externalURL + index
    let fileId = fs.writeFileSync(writePath + '/'+ index ,JSON.stringify(data) )
    console.log('index is #',index );

}



