import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "JanSeva (जनसेवा) — Municipal Command Center",
  description: "Citizen Grievance Redressal and Municipal Operations Command Dashboard",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased bg-slate-50 text-slate-900">{children}</body>
    </html>
  );
}
