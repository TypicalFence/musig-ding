import React from "react";
import PropTypes from "prop-types";
import UrlTile from "../UrlTile";

class RemoteFileTile extends React.Component {
    playUrl(url) {
        this.props.player.playUrl(url);
    }

    render() {
        return <UrlTile name="Remote File" color="green" playCallback={this.playUrl.bind(this)} />;
    }
}

export default RemoteFileTile;
