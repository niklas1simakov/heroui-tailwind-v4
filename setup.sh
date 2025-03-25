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

/* Hero UI currently only works if you use the config file. However you can still use the @theme directive. */
@config "../../tailwind.config.js";
EOF

# Setup providers.tsx
cat << 'EOF' > src/app/providers.tsx
"use client";

import type { ThemeProviderProps } from "next-themes";

import * as React from "react";
import { HeroUIProvider } from "@heroui/react";
import { useRouter } from "next/navigation";
import { ThemeProvider as NextThemesProvider } from "next-themes";

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

# Setup an example page
cat << 'EOF' > src/app/page.tsx
"use client";

import { Button } from "@heroui/react";

export default function Home() {
  return (
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
  );
}
EOF

# Prettier config
cat << 'EOF' > .prettier.config.js 
/**
 * @see https://prettier.io/docs/configuration
 * @type {import("prettier").Config}
 */
const config = {
  trailingComma: 'es5',
  tabWidth: 2,
  semi: true,
  singleQuote: false,
  jsxSingleQuote: false,
  printWidth: 120,
  plugins: ['prettier-plugin-tailwindcss'],
  tailwindStylesheet: './src/app/globals.css',
};

module.exports = config;
EOF

git add .
git commit -m "Install HeroUI with setup.sh script"

# Run the development server
pnpm dev
