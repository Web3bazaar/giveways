


let template = 
{
    id: '',
    name : "SLF Raffle Ticket #",
    description :"Testnet giveaway raflle tickets - SFL",
    externalURL: "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/data/",
    image: "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/assets/sfl-w3b-opensea.png"
 }

let writePath = './data'

 const fs = require('graceful-fs');

let startIndex = 20408//6;
let lastIndex = 30000;

for (let index = startIndex; index <= lastIndex; index++) {
    
    let data = JSON.parse( JSON.stringify(template))
    data.id = index;
    data.name = data.name + index
    data.externalURL = data.externalURL + index
    let fileId = fs.writeFile(writePath + '/'+ index ,JSON.stringify(data), function (err) {
        if (err) return console.log(err);
        console.log('Hello World > helloworld.txt');
      });


}



