/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    turbo: {
      rules: {
        '*.md': ['copy']
      }
    }
  }
};

module.exports = nextConfig;
