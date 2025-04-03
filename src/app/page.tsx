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
