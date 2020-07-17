import React from "react";
import PropTypes from "prop-types";
import UrlTile from "../UrlTile";

class SoundcloudTile extends React.Component {
    playUrl(url) {
        this.props.player.playSoundcloud(url);
    }

    render() {
        return <UrlTile name="Soundcloud" color="#ff7700" playCallback={this.playUrl.bind(this)} />;
    }
}

export default SoundcloudTile;
