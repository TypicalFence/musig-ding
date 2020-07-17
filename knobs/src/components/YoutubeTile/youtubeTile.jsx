import React from "react";
import PropTypes from "prop-types";
import UrlTile from "../UrlTile";

class YoutubeTile extends React.Component {
    playUrl(url) {
        this.props.player.playYoutube(url);
    }

    render() {
        return <UrlTile name="Youtube" color="#FF0000" playCallback={this.playUrl.bind(this)} />;
    }
}

export default YoutubeTile;
