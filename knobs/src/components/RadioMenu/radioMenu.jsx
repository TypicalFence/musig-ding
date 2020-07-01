import React from "react";
import PropTypes from "prop-types";
import RadioTile from "../RadioTile";
import { fetchRadioStations, RadioStation } from "../../stereo/radio.js";

export const RadioMenu = ({ radios, clickHandler }) => {
    return <div className="radio-menu">
        {radios.map(r =>
            <RadioTile
                key={r.name}
                name={r.name}
                color={r.color}
                url={r.url}
                clickHandler={clickHandler}
            />
        )}
    </div>;
};

RadioMenu.propTypes = {
    radios: PropTypes.arrayOf(PropTypes.instanceOf(RadioStation))
};

export class RadioMenuContainer extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            radios: null
        };
    }

    componentDidMount() {
        fetchRadioStations().then((stations) => {
            const state = { ...this.state };
            state.radios = stations;
            this.setState(state);
        });
    }

    playUrl(url) {
        this.props.player.playUrl(url);
    }

    render() {
        const { radios } = this.state;

        if (radios !== null && typeof radios !== "undefined") {
            return <RadioMenu radios={radios} clickHandler={this.playUrl.bind(this)} />;
        } else {
            return <p>loading</p>;
        }
    }
}
