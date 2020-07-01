import React from "react";
import PropTypes from "prop-types";
import RadioTile from "../RadioTile";
import { fetchPlayerStatus } from "../../stereo/player.js";

export const PlaybackDisplay = ({ playing }) => {
    return <h1>playing {playing}</h1>;
};

PlaybackDisplay.propTypes = {
    radios: PropTypes.string.isRequired
};

export class PlaybackDisplayContainer extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            playing: "nothing"
        };
    }

    updateDisplay() {
        fetchPlayerStatus().then((status) => {
            console.log(status);
            if (status.playing) {
                const state = { ...this.state };
                state.playing = status.url;
                this.setState(state);
            }
        });
    }

    componentDidMount() {
        this.updateDisplay();
    }

    render() {
        const { playing } = this.state;

        return <PlaybackDisplay playing={playing} />;
    }
}
