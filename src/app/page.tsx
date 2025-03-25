"use client";

import { Button } from "@heroui/react";

export default function Home() {
  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className="text-4xl font-bold mb-4">Hello World</h1>
      <p className="text-lg mb-4">
        This is a simple example of how to use the new beta version of Hero UI
        with Tailwind CSS v4.
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
