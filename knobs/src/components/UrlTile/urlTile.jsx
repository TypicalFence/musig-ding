import React, { useRef } from "react";
import PropTypes from "prop-types";

function isValidUrl(string) {
    try {
        new URL(string);
    } catch (_) {
        return false;
    }

    return true;
}

export const UrlTile = ({ name, color, playCallback }) => {
    const urlElement = useRef("");

    const onClickHandler = () => {
        const url = urlElement.current.value;
        if (isValidUrl(url)) {
            playCallback(url);
        } else {
            console.error(url + " is not a url");
        }
    };

    return (
        <div className="url-tile" style={{ "--tile-color": color }}>
            <h3 className="name">{name}</h3>
            <input type="text" ref={urlElement} />
            <button className="play-button" onClick={onClickHandler}>play</button>
        </div>
    );
};

UrlTile.propTypes = {
    name: PropTypes.string.isRequired,
    color: PropTypes.string.isRequired,
    playCallback: PropTypes.func.isRequired
};
