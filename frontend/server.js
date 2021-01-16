const express = require('express');
const bodyParser = require('body-parser');
const request = require('request');
const url = require('url');
const app = express();
const fs = require('fs');
const https = require('https');
var accessToken;

app.use(express.static('public'));
app.use(bodyParser.urlencoded({extended: true}));
app.set('view engine', 'ejs');

var apiEndpoint = process.env.API_ENDPOINT;
var tokenEndpoint = process.env.TOKEN_ENDPOINT;
var apimClientId = process.env.APIM_CLIENT_ID;
var apimClientSecret = process.env.APIM_CLIENT_SECRET;

var errorMessage = 'Error, Please try again';
var notifyMessage = 'Notification Sent to Google Chat';

app.get('/', function (req, res) {

    let monthlyStat = '';
    let dailyStat = '';
    res.render('index', {monthlyStat: monthlyStat, dailyStat: dailyStat, dailyError: null, monthlyError: null});
});

app.post('/', function (req, res) {


    let statType = req.body.statType;

    if (statType == 'daily') {

        if (accessToken == undefined) {
            callTokenAndDailyStats(res);

        } else {

            let dailyPromised = callDailyStats(apiEndpoint, accessToken);

            Promise.all([dailyPromised]).then(result => {

                var status = result[0];

                if (status == 'Success') {
                    res.render('index', {
                        monthlyStat: '', dailyStat: 'Notify only if conditions are matched!',
                        dailyError: null, monthlyError: null
                    });
                }

                if (status == '401') {
                    callTokenAndDailyStats(res);
                }

            }).catch(error => {
                console.log(`Error in getting daily stats ${error}`);
                res.render('index', {
                    monthlyStat: '', dailyStat: null, monthlyError: null,
                    dailyError: errorMessage
                });
            });
        }

    }

    if (statType == 'monthly') {

        if (accessToken == undefined) {
            callTokenAndMonthStats(res);

        } else {

            let monthPromised = callMonthlyStats(apiEndpoint, accessToken);

            Promise.all([monthPromised]).then(result => {

                var status = result[0];

                if (status == 'Success') {
                    res.render('index', {
                        monthlyStat: notifyMessage, dailyStat: '',
                        dailyError: null, monthlyError: null
                    });
                }

                if (status == '401') {
                    callTokenAndMonthStats(res);
                }

            }).catch(error => {
                console.log(`Error in getting monthly stats ${error}`);
                res.render('index', {
                    monthlyStat: null, dailyStat: '', monthlyError: errorMessage,
                    dailyError: null
                });
            });
        }
    }
});

function callTokenAndMonthStats(res) {

    var tokenPromise = getAccessToken(tokenEndpoint, apimClientId, apimClientSecret);

    Promise.all([tokenPromise]).then(result => {

        accessToken = result[0];
        let monthPromised = callMonthlyStats(apiEndpoint, accessToken);

        monthPromised.then(function (result) {

            res.render('index', {
                monthlyStat: notifyMessage, dailyStat: '',
                dailyError: null, monthlyError: null
            });

        }, function (err) {

            console.log(`Error in month promise ${err}`);
            res.render('index', {
                monthlyStat: null, dailyStat: '', monthlyError: errorMessage,
                dailyError: null
            });
        });

    }).catch(error => {

        console.log(`Error in getting monthly stats ${error}`);
        res.render('index', {
            monthlyStat: null, dailyStat: '', monthlyError: errorMessage,
            dailyError: null
        });
    });
}

function callTokenAndDailyStats(res) {

    var tokenPromise = getAccessToken(tokenEndpoint, apimClientId, apimClientSecret);

    Promise.all([tokenPromise]).then(result => {

        accessToken = result[0];
        let dailyPromised = callDailyStats(apiEndpoint, accessToken);

        dailyPromised.then(function (result) {

            res.render('index', {
                monthlyStat: '', dailyStat: 'Notify only if conditions are matched!',
                dailyError: null, monthlyError: null
            });

        }, function (err) {

            console.log(`Error in month promise ${err}`);
            res.render('index', {
                monthlyStat: '', dailyStat: null, monthlyError: null,
                dailyError: errorMessage
            });
        });

    }).catch(error => {

        console.log(`Error in getting daily stats ${error}`);
        res.render('index', {
            monthlyStat: '', dailyStat: null, monthlyError: null,
            dailyError: errorMessage
        });
    });
}


function callMonthlyStats(apiEndpoint, accessToken) {

    let monthlyUrl = apiEndpoint + '/eventhub/v1/monthly';
    let tokenHeaderValue = 'Bearer ' + accessToken;

    const options = {
        url: monthlyUrl,
        method: 'POST',
        headers: {
            'Authorization': tokenHeaderValue,
            'Accept': 'application/json'
        },
        rejectUnauthorized: false
    };

    return new Promise(function (resolve, reject) {

        request(options, function (err, response, body) {
            if (err) {
                console.log("Error while calling the monthly stats endpoint");
                reject(err);
            } else {

                if (response.statusCode == 401) {
                    resolve('401');
                }

                if (response.statusCode == 202) {
                    resolve('Success');
                }
                reject(null);
            }
        });
    })

}

function callDailyStats(apiEndpoint, accessToken) {

    let dailyUrl = apiEndpoint + '/eventhub/v1/daily';
    let tokenHeaderValue = 'Bearer ' + accessToken;

    const options = {
        url: dailyUrl,
        method: 'POST',
        headers: {
            'Authorization': tokenHeaderValue,
            'Accept': 'application/json'
        },
        rejectUnauthorized: false
    };

    return new Promise(function (resolve, reject) {

        request(options, function (err, response, body) {
            if (err) {
                console.log("Error while calling the daily stats endpoint");
                reject(err);
            } else {

                if (response.statusCode == 401) {
                    resolve('401');
                }

                if (response.statusCode == 202) {
                    resolve('Success');
                }
                reject(null);
            }
        });
    })

}

function getAccessToken(tokenUrl, clientId, clientSecret) {

    let basicHeaderValue = Buffer.from(clientId + ":" + clientSecret).toString('base64');
    let basicHeader = 'Basic ' + basicHeaderValue;
    let fullUrl = tokenUrl + '?grant_type=client_credentials';

    const options = {
        url: fullUrl,
        method: 'POST',
        headers: {
            'Authorization': basicHeader,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        rejectUnauthorized: false
    };

    return new Promise(function (resolve, reject) {

        request(options, function (err, response, body) {
            if (err) {
                console.log("Error while calling the token endpoint");
                reject(err);
            } else {

                let tokenResponse = JSON.parse(body);
                if (tokenResponse.access_token == undefined) {
                    console.log("Error while processing token request");
                    reject(null);
                } else {
                    resolve(tokenResponse.access_token);
                }
            }
        });
    })

}


const httpsServer = https.createServer({
    key: fs.readFileSync('certs/key.pem'),
    cert: fs.readFileSync('certs/cert.pem')
}, app);

httpsServer.listen(8000, () => {
    console.log('HTTPS Server running on port 8000');
});
