import React from "react";
import ReactDOM from "react-dom";
import {
    BrowserRouter as Router, Route, Switch
} from "react-router-dom";
import NotFound from "./components/NotFound";
import Hello from "./components/HelloWorld";

const GeneralNotFound = () => <NotFound />;

export const Routes = () => (
    <Switch>
        <Route path="/hello" component={Hello} />
        <Route component={GeneralNotFound} />
    </Switch>
);

export function renderApp() {
    ReactDOM.render(
        <Router>
            <Routes />
        </Router>,
        document.getElementById("react-root")
    );
}
