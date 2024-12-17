import ballerina/http;
import ballerina/log;
import ballerina/os;

string endpointUrl = os:getEnv("CHOREO_ARCHIBUS_WORK_REQUESTS_INCOMING_CONNECTION_SERVICEURL");
string clientID = os:getEnv("CHOREO_ARCHIBUS_WORK_REQUESTS_INCOMING_CONNECTION_CONSUMERKEY");
string clientSecret = os:getEnv("CHOREO_ARCHIBUS_WORK_REQUESTS_INCOMING_CONNECTION_CONSUMERSECRET");
string tokenUrl = os:getEnv("CHOREO_ARCHIBUS_WORK_REQUESTS_INCOMING_CONNECTION_TOKENURL");

public function main() returns error? {
    // the auth param automatically adds the Bearer Token to each request:
    // https://ballerina.io/learn/by-example/http-client-oauth2-password-grant-type/
    http:Client httpclient = check new(
        endpointUrl,
        auth = {
            tokenUrl: tokenUrl,
            clientId: clientID,
            clientSecret: clientSecret
        });

    http:Response response = check httpclient->get("/incoming");    
    log:printInfo("LOG-ARCHIBUS-WORK-REQUESTS Scheduled triggered " + endpointUrl + "/incoming");
    log:printInfo("LOG-ARCHIBUS-WORK-REQUESTS Scheduled task response code: " + response.statusCode.toString());
    
    json jsonResponse = check response.getJsonPayload();
    log:printInfo("LOG-ARCHIBUS-WORK-REQUESTS Scheduled task response body: " + jsonResponse.toString());
    return();
}