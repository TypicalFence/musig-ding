import "./index.scss";
import { renderApp } from "./app";
import configureStore, { history } from "./store";

const store = configureStore();
renderApp(store, history);
