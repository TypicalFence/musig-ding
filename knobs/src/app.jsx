import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { Route, Switch } from "react-router";
import { ConnectedRouter } from "connected-react-router";
import NotFound from "./components/NotFound";
import Hello from "./components/HelloWorld";


const GeneralNotFound = () => <NotFound />;

export const Routes = () => (
    <Switch>
        <Route path="/hello" component={Hello} />
        <Route component={GeneralNotFound} />
    </Switch>
);

export function renderApp(store, history) {
    ReactDOM.render(
        <Provider store={store}>
            <ConnectedRouter history={history}>
                <Routes />
            </ConnectedRouter>
        </Provider>,
        document.getElementById("react-root"),
    );
}
