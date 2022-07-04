


let template = 
{
    id: '',
    name : "NFT #",
    description :"giveway ticket from web3bazaar for sunflowers land ",
    externalURL: "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/data/",
    image: "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/assets/sfl-w3b-opensea.png"
 }


 let writePath = './data'

let fs = require('fs');

for (let index = 6; index <= 100; index++) {
    
    let data = JSON.parse( JSON.stringify(template))
    data.id = index;
    data.name = data.name + index
    data.externalURL = data.externalURL + index
    fs.writeFile(writePath + '/'+ index ,JSON.stringify(data), function (err) {
        if (err) return console.log(err);
        console.log('Hello World > helloworld.txt');
      });

}



