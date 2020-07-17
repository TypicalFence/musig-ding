import React from "react";
import PropTypes from "prop-types";

export const RadioTile = ({ name, color, id, clickHandler }) => {
    return (
        <div className="radio-tile" style={{ "--tile-color": color }}>
            <h3 className="name">{name}</h3>
            <button className="play-button" onClick={() => clickHandler(id)}>play</button>
        </div>
    );
};

RadioTile.propTypes = {
    name: PropTypes.string.isRequired,
    color: PropTypes.string.isRequired,
    id: PropTypes.string.isRequired,
    clickHandler: PropTypes.func.isRequired
};
