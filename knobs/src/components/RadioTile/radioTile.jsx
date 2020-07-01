import React from "react";
import PropTypes from "prop-types";

export const RadioTile = ({ name, color, url, clickHandler }) => {
    return (
        <div className="radio-tile" style={{ "--tile-color": color }}>
            <h3 className="name">{name}</h3>
            <button className="play-button" onClick={() => clickHandler(url)}>play</button>
        </div>
    );
};

RadioTile.propTypes = {
    name: PropTypes.string.isRequired,
    color: PropTypes.string.isRequired,
    url: PropTypes.string.isRequired,
    clickHandler: PropTypes.func.isRequired
};
