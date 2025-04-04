# This shows the setup process for the project

echo "This script will setup a new Next.js 15 project with Tailwind CSS V4 and HeroUI."

if ! command -v cat &> /dev/null; then
    echo "Error: cat command is not available"
    exit 1
fi

# Enter project name
read -p "Enter project name: " projectName

# Install Next.js 15 with Tailwind CSS V4
pnpm dlx create-next-app@latest $projectName --typescript --tailwind --eslint --app --src-dir --turbopack --import-alias "@/*" --use-pnpm --empty 

cd $projectName

# Reinstall next.js to allow for sharp to be automatically built
pnpm add --allow-build=sharp next@latest
pnpm install

# Install prettier
pnpm add prettier prettier-plugin-tailwindcss --save-dev

# Install the beta version of HeroUI
pnpm add --allow-build=@heroui/shared-utils @heroui/react@beta framer-motion next-themes

# Add the following to your `.npmrc` (create one if it doesn't exist) file:
echo "public-hoist-pattern[]=*@heroui/*" >> .npmrc
echo "package-lock=true" >> .npmrc

# Install dependencies
pnpm install --force

# Install react-icons
pnpm add react-icons

# Install react-aria/ssr
pnpm add @react-aria/ssr

# Setup Tailwind CSS
cat << 'EOF' > tailwind.config.js
const { heroui } = require("@heroui/react"); 

/**
 * Please note that Hero UI currently only works if you use the config file.
 * With tailwindcss v4 you would normally use your css files to set all the required config variables, 
 * but this is not possible with Hero UI.
 */

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./node_modules/@heroui/theme/dist/**/*.{js,ts,jsx,tsx}",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  darkMode: "class",
  plugins: [heroui()],
};
EOF

# Setup globals.css
cat << 'EOF' > src/app/globals.css
@import "tailwindcss";

/* 
Hero UI currently only works if you use the config file. Use the config file to set all the required config variables. 
Also check out the docs for more information: https://www.heroui.com/docs/customization/theme 
*/
@config "../../tailwind.config.js";
EOF

# Setup providers.tsx
cat << 'EOF' > src/app/providers.tsx
"use client";

import type { ThemeProviderProps } from "next-themes";

import { HeroUIProvider } from "@heroui/react";
import { ThemeProvider as NextThemesProvider } from "next-themes";
import { useRouter } from "next/navigation";

export interface ProvidersProps {
  children: React.ReactNode;
  themeProps?: ThemeProviderProps;
}

export function Providers({ children, themeProps }: ProvidersProps) {
  const router = useRouter();

  return (
    <HeroUIProvider navigate={router.push}>
      <NextThemesProvider {...themeProps}>{children}</NextThemesProvider>
    </HeroUIProvider>
  );
}
EOF

# Add the provider to the layout.tsx file
# This is the main layout file that is used to wrap the app
cat << 'EOF' > src/app/layout.tsx
import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";

import "./globals.css";

import { Providers } from "./providers";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Hero UI Next App",
  description: "Hero UI Next App with Tailwind CSS v4",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html suppressHydrationWarning lang="en">
      <body className={`${geistSans.variable} ${geistMono.variable} antialiased`}>
        <Providers themeProps={{ attribute: "class", defaultTheme: "dark" }}>{children}</Providers>
      </body>
    </html>
  );
}
EOF

# Create components directory
mkdir -p src/components

# Add ThemeSwitch component
cat << 'EOF' > src/components/ThemeSwitch.tsx
"use client";

import { useIsSSR } from "@react-aria/ssr";
import { useTheme } from "next-themes";
import { TbMoonFilled, TbSunFilled } from "react-icons/tb";

export function ThemeSwitch({ className }: { className?: string }) {
  const { theme, setTheme } = useTheme();
  const isSSR = useIsSSR();

  const toggleTheme = () => {
    setTheme(theme === "light" ? "dark" : "light");
  };

  return (
    <button
      onClick={toggleTheme}
      className={`cursor-pointer rounded-lg p-1 transition-opacity hover:opacity-80 ${className || ""}`}
      aria-label={`Switch to ${isSSR || theme === "dark" ? "light" : "dark"} mode`}
    >
      {isSSR || theme === "dark" ? <TbSunFilled size={22} /> : <TbMoonFilled size={22} />}
    </button>
  );
}
EOF

# Setup an example page
cat << 'EOF' > src/app/page.tsx
"use client";

import { ThemeSwitch } from "@/components/ThemeSwitch";
import { Button } from "@heroui/react";

export default function Home() {
  return (
    <div>
      <ThemeSwitch className="absolute top-8 right-8" />
      <div className="flex h-screen flex-col items-center justify-center">
        <h1 className="mb-4 text-4xl font-bold">Hello World</h1>
        <p className="mb-4 text-lg">
          This is a simple example of how to use the new beta version of Hero UI with Tailwind CSS v4.
        </p>
        <div className="flex flex-row gap-4">
          <Button variant="shadow" color="primary">
            Click me
          </Button>
          <Button variant="bordered" color="default">
            Test
          </Button>
        </div>
      </div>
    </div>
  );
}
EOF

# Prettier config
cat << 'EOF' > prettier.config.js 
/**
 * @see https://prettier.io/docs/configuration
 * @type {import("prettier").Config}
 */
const config = {
  trailingComma: "es5",
  tabWidth: 2,
  semi: true,
  singleQuote: false,
  jsxSingleQuote: false,
  printWidth: 120,
  plugins: ["prettier-plugin-tailwindcss"],
  tailwindStylesheet: "./src/app/globals.css",
  tailwindFunctions: ["tv"],
};

module.exports = config;
EOF

# Create .vscode directory
mkdir -p .vscode

# Add vs code settings
cat << 'EOF' > .vscode/settings.json
{
  "files.associations": {
    "*.css": "tailwindcss"
  },
  "tailwindCSS.includeLanguages": {
    "html": "html",
    "javascript": "javascript",
    "css": "css"
  },
  "editor.quickSuggestions": {
    "strings": true
  },
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "tailwindCSS.experimental.classRegex": [["([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]"]]
}
EOF

# Add readme
cat << 'EOF' > README.md
# HeroUI Beta with Tailwind V4 Template

This is a template for a HeroUI project using Tailwind CSS V4. The template is built with Next.js 15 and uses the new App Router. It uses the beta version of HeroUI. It was generated using a `setup.sh` script.

This template is meant to help setup the new beta version of HeroUI with Tailwind CSS V4 and provide a starting point for a new HeroUI project. It is not meant to be a production ready template.

## Getting Started

```bash
pnpm install
pnpm dev
```

Recommended vscode extensions:

- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Tailwind CSS Intellisense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)

## Deploying

```bash
pnpm build
pnpm deploy
```

## Libraries

- [Next.js 15](https://nextjs.org/docs/getting-started)
- [HeroUI v2 (beta)](https://beta.heroui.com/docs/guide/tailwind-v4)
- [Tailwind CSS](https://tailwindcss.com/)
- [Tailwind Variants](https://tailwind-variants.org)
- [TypeScript](https://www.typescriptlang.org/)
- [Framer Motion](https://www.framer.com/motion/)
- [next-themes](https://github.com/pacocoursey/next-themes)
- [Prettier](https://prettier.io/)
- [react-icons](https://react-icons.github.io/react-icons/)
EOF

# Add tailwind-variants (optional)
pnpm add tailwind-variants

git add .
git commit -m "Install HeroUI with setup.sh script"

# Run the development server
pnpm dev
