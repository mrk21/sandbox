import axios from "axios";
import { injectAxiosLogger } from "./axios-logger";

injectAxiosLogger(axios);

axios.get("https://example.com");
