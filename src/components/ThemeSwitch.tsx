"use client";

import { useTheme } from "next-themes";
import { TbMoonFilled, TbSunFilled } from "react-icons/tb";

export function ThemeSwitch({ className }: { className?: string }) {
  const { theme, setTheme } = useTheme();

  const toggleTheme = () => {
    setTheme(theme === "light" ? "dark" : "light");
  };

  return (
    <button
      onClick={toggleTheme}
      className={`cursor-pointer rounded-lg p-1 transition-opacity hover:opacity-80 ${className || ""}`}
      aria-label={`Switch to ${theme === "light" ? "dark" : "light"} mode`}
    >
      {theme === "light" ? <TbMoonFilled size={22} /> : <TbSunFilled size={22} />}
    </button>
  );
}
