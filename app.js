const request = require('superagent');
var argv = require('minimist')(process.argv.slice(2));

if (!argv.webapi || !argv.appid || !argv.memo ) {
    console.log('usage: \n' +
                 '--webapi="YOUR STEAM WEB API TOKEN" \n' +
                 '--appid="APPID of your game" \n' +
				 '--memo="Additional memo for your token"' )
}

request
    //.post('https://api.steampowered.com/IGameServersService/CreateAccount/v1/?key=' + argv.webapi + '&appid=' + argv.appid + "&memo=" + Date.now().toString())
	.post('https://api.steampowered.com/IGameServersService/CreateAccount/v1/?key=' + argv.webapi + '&appid=' + argv.appid + "&memo=" + argv.memo)
    .set('accept', 'json')
    .end((err, res) => {
         console.log(res.body.response.login_token);
});