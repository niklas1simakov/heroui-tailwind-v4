"use client";

import { SwitchProps, useSwitch } from "@heroui/switch";
import { useIsSSR } from "@react-aria/ssr";
import { VisuallyHidden } from "@react-aria/visually-hidden";
import { useTheme } from "next-themes";
import { FC } from "react";
import { TbMoonFilled, TbSunFilled } from "react-icons/tb";

export interface ThemeSwitchProps {
  className?: string;
  classNames?: SwitchProps["classNames"];
}

export const ThemeSwitch: FC<ThemeSwitchProps> = ({ className, classNames }) => {
  const { theme, setTheme } = useTheme();
  const isSSR = useIsSSR();

  const onChange = () => {
    setTheme(theme === "light" ? "dark" : "light");
  };

  const { Component, slots, isSelected, getBaseProps, getInputProps, getWrapperProps } = useSwitch({
    isSelected: theme === "light" || isSSR,
    "aria-label": `Switch to ${theme === "light" || isSSR ? "dark" : "light"} mode`,
    onChange,
  });

  return (
    <Component
      {...getBaseProps({
        className: `px-px transition-opacity hover:opacity-80 cursor-pointer ${className || ""} ${classNames?.base || ""}`,
      })}
    >
      <VisuallyHidden>
        <input {...getInputProps()} />
      </VisuallyHidden>
      <div
        {...getWrapperProps()}
        className={slots.wrapper({
          class: `mx-0 flex h-auto w-auto items-center justify-center rounded-lg bg-transparent px-0 pt-px !text-default-500 group-data-[selected=true]:bg-transparent ${classNames?.wrapper || ""}`,
        })}
      >
        {!isSelected || isSSR ? <TbSunFilled size={22} /> : <TbMoonFilled size={22} />}
      </div>
    </Component>
  );
};
