import { createDojoConfig } from "@dojoengine/core";

import manifest from "../dojo-starter/manifests/dev/deployment/manifest_dev.json";

export const dojoConfig = createDojoConfig({
    manifest,
});
