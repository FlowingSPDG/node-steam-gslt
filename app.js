const request = require('superagent');
var argv = require('minimist')(process.argv.slice(2));

if (!argv.webapi) {
    console.log('usage: \n' +
		'--action="Your action. create or delete!" \n' +
		'--webapi="YOUR STEAM WEB API TOKEN" \n' +
		'--appid="APPID of your game" \n' +
		'--memo="Additional memo for your token" \n' + 
		'--token="The token which will be deleted" \n'
		)
}

else if (argv.action == "create" || !argv.action){
	request
		//.post('https://api.steampowered.com/IGameServersService/CreateAccount/v1/?key=' + argv.webapi + '&appid=' + argv.appid + "&memo=" + Date.now().toString())
		.post('https://api.steampowered.com/IGameServersService/CreateAccount/v1/?key=' + argv.webapi + '&appid=' + argv.appid + "&memo=" + argv.memo)
		.set('accept', 'json')
		.end((err, res) => {
			console.log(res.body.response.login_token);
		})
}
else if (argv.action == "delete") {
	request
		//.post('https://api.steampowered.com/IGameServersService/DeleteAccount/v1/?key=' + argv.webapi + '&appid=' + argv.appid + "&memo=" + Date.now().toString())
		//.post('https://api.steampowered.com/IGameServersService/DeleteAccount/v1/?key=' + argv.webapi + '&appid=' + argv.appid + "&memo=" + argv.memo)
		// 8340C1503CD213D35ED4F976B1C8EFCE
		//.post('https://api.steampowered.com/IGameServersService/DeleteAccount/v1/?key=' + argv.webapi + '&steamid=' + argv.token)
		.get('https://api.steampowered.com/IGameServersService/GetAccountList/v1/?key=' + argv.webapi)
		.set('accept', 'json')
		.end((err, res) => {
			//console.log(res.body.response.servers);
			//var json = JSON.stringify(res.body.response.servers);
			//console.log(json);
			response = res.body.response.servers;
			var token = response.filter(function(item, index){
				if (item.login_token == argv.token) return true;
			});
			if (!token[0]){
				console.log("Specified token not found...");
			}
			else {
				console.log(token[0]);
				request
					.post('https://api.steampowered.com/IGameServersService/DeleteAccount/v1/?key=' + argv.webapi + '&steamid=' + token[0].steamid)
					.set('accept', 'json')
					.end((err,res) => {
						console.log("Delete "+ token[0].login_token);
					})
			}
	})
}