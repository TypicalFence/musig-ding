import React from "react";

const NotFound = ({ id = "" }) => {
    let what = id;

    if (id.length > 0) {
        what += " ";
    }
    console.log(what);
    return (
        <h2>
            {what}
            Not Found
        </h2>
    );
};

export default NotFound;
