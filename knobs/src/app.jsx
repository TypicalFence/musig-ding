import React from "react";
import ReactDOM from "react-dom";
import {
    BrowserRouter as Router, Route, Switch, Link
} from "react-router-dom";
import NotFound from "./components/NotFound";
import Hello from "./components/HelloWorld";
import RadioMenu from "./components/RadioMenu";
import PlaybackDisplay from "./components/PlaybackDisplay";
import Player from "./player.js";
import YoutubeTile from "./components/YoutubeTile";
import SoundcloudTile from "./components/SoundcloudTile";
import RemoteFileTile from "./components/RemoteFileTile";

const GeneralNotFound = () => <NotFound />;

const Menu = () => (
    <div className="menu">
        <Link to="/radio">radio</Link>
        <Link to="/youtube">youtube</Link>
        <Link to="/soundcloud">soundcloud</Link>
        <Link to="/remote">remote file</Link>
    </div>
);

export const Routes = ({ player }) => (
    <Switch>
        <Route exact path="/" component={Menu}/>
        <Route path="/hello" component={Hello} />
        <Route path="/radio" component={() => <RadioMenu player={player} />} />
        <Route path="/youtube" component={() => <YoutubeTile player={player} />} />
        <Route path="/soundcloud" component={() => <SoundcloudTile player={player} />} />
        <Route path="/remote" component={() => <RemoteFileTile player={player} />} />
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
