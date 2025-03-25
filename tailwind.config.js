const { heroui } = require("@heroui/react"); 

/**
 * Please note that Hero UI currently only works if you use the config file.
 * With tailwindcss v4 you would normally use your css files to set all the required config variables.
 * Therefore please also check the globals.css and configure the variables there.
 */

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./node_modules/@heroui/theme/dist/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: "class",
  plugins: [heroui()],
};