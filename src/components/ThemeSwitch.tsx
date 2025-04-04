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
