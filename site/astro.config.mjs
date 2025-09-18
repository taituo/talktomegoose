import path from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig } from "astro/config";

const repoRoot = path.resolve(
	fileURLToPath(new URL(".", import.meta.url)),
	"..",
	"..",
);

export default defineConfig({
	site: "https://taituo.github.io/talktomegoose",
	vite: {
		server: {
			fs: {
				allow: [repoRoot],
			},
		},
	},
});
