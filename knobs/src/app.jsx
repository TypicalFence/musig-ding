import React from "react";
import ReactDOM from "react-dom";
import {
    BrowserRouter as Router, Route, Switch
} from "react-router-dom";
import NotFound from "./components/NotFound";
import Hello from "./components/HelloWorld";
import RadioMenu from "./components/RadioMenu";
import PlaybackDisplay from "./components/PlaybackDisplay";
import Player from "./player.js";

const GeneralNotFound = () => <NotFound />;

export const Routes = ({ player }) => (
    <Switch>
        <Route path="/hello" component={Hello} />
        <Route path="/radio" component={() => <RadioMenu player={player} />} />
        <Route component={GeneralNotFound} />
    </Switch>
);

class App extends React.Component {
    constructor(props) {
        super(props);
        this.playbackDisplay = React.createRef();
        this.state = {
            player: new Player()
        };
    }

    render() {
        const { player } = this.state;

        player.setDisplay(this.playbackDisplay);

        return <Router>
            <PlaybackDisplay ref={this.playbackDisplay} />
            <Routes player={player} />
        </Router>;
    }
}

export function renderApp() {
    ReactDOM.render(<App/>,
        document.getElementById("react-root")
    );
}
