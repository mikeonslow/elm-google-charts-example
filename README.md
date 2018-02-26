# Elm + Google Charts Example

### Proof of concept for using Elm and Google Charts together

#### To start in dev mode (mock data server will be created and started) use the following commands:
`npm install && npm start`

![Example Image](/example.png)

#### Back-End
Uses `faker`to generate mock data and `json-server` to serve it as a JSON API

#### Front-end
Uses the Elm programming language [http://elm-lang.org/](http://elm-lang.org/) for all API calls, draws dashboard and widget UI based on API responses, and then simply passes the data needed for rendering each Google Chart to the JavaScript code over a port. 
