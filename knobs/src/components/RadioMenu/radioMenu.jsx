import React from "react";
import PropTypes from "prop-types";
import RadioTile from "../RadioTile";
import { fetchRadioStations, RadioStation } from "../../stereo/radio.js";

export const RadioMenu = ({ radios, clickHandler }) => {
    return <div className="radio-menu">
        {radios.map(r =>
            <RadioTile
                key={r.id}
                name={r.name}
                color={r.color}
                id={r.id}
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

    tuneRadio(radio) {
        this.props.player.tuneRadio(radio);
    }

    render() {
        const { radios } = this.state;

        if (radios !== null && typeof radios !== "undefined") {
            return <RadioMenu radios={radios} clickHandler={this.tuneRadio.bind(this)} />;
        } else {
            return <p>loading</p>;
        }
    }
}
