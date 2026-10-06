"use client";

import React, { useState } from "react";
import {
  AlertTriangle,
  Bell,
  CheckCircle2,
  Clock,
  Download,
  Filter,
  Layers,
  MapPin,
  Megaphone,
  Radio,
  RefreshCw,
  Search,
  Send,
  ShieldAlert,
  Truck,
} from "lucide-react";

interface NoticeBroadcast {
  id: string;
  title: string;
  category: "Water Supply" | "Electricity Grid" | "Sanitation Fogging" | "Roadwork" | "Health Advisory";
  targetWard: string;
  urgency: "Advisory" | "Urgent" | "Critical Alert";
  message: string;
  publishedAt: string;
}

const initialNotices: NoticeBroadcast[] = [
  {
    id: "NTC-2026-081",
    title: "Scheduled Pipeline Maintenance & Pressure Flushing",
    category: "Water Supply",
    targetWard: "Ward 1 - Civil Lines",
    urgency: "Urgent",
    message: "Main feeder valve servicing from 10:00 AM to 02:00 PM. Water tankers stationed at Sector 4 community center.",
    publishedAt: "Today, 08:30 AM",
  },
  {
    id: "NTC-2026-079",
    title: "Vector Control & Anti-Larval Fogging Drive",
    category: "Sanitation Fogging",
    targetWard: "All Wards",
    urgency: "Advisory",
    message: "Municipal health teams carrying out intensive fogging across back lanes between 05:00 PM and 07:30 PM.",
    publishedAt: "Yesterday, 04:15 PM",
  },
];

interface GrievanceItem {
  id: string;
  title: string;
  category: "Roads" | "Sanitation" | "Water" | "Electricity" | "Drainage";
  ward: string;
  address: string;
  citizenName: string;
  priority: "Low" | "Medium" | "High" | "Emergency";
  status: "Submitted" | "In Progress" | "Resolved" | "Verified Closed";
  createdAt: string;
  slaHoursLeft: number;
  isBreached: boolean;
}

const initialGrievances: GrievanceItem[] = [
  {
    id: "GRV-2026-101",
    title: "Deep crater pothole near metro pillar 42",
    category: "Roads",
    ward: "Ward 1 - Civil Lines",
    address: "MG Road, Metro Pillar 42",
    citizenName: "Aarav Patel",
    priority: "High",
    status: "In Progress",
    createdAt: "Today at 08:30 AM",
    slaHoursLeft: 34,
    isBreached: false,
  },
  {
    id: "GRV-2026-102",
    title: "Overflowing community garbage bin in Block C",
    category: "Sanitation",
    ward: "Ward 2 - Gandhi Nagar",
    address: "Block C Market Square",
    citizenName: "Aarav Patel",
    priority: "Medium",
    status: "Resolved",
    createdAt: "Yesterday at 04:15 PM",
    slaHoursLeft: 0,
    isBreached: false,
  },
  {
    id: "GRV-2026-103",
    title: "Broken drinking water distribution pipeline",
    category: "Water",
    ward: "Ward 3 - Industrial Area",
    address: "4th Cross Street, Ward 3",
    citizenName: "Ramesh Gupta",
    priority: "Emergency",
    status: "Submitted",
    createdAt: "2 hours ago",
    slaHoursLeft: 4,
    isBreached: false,
  },
  {
    id: "GRV-2026-104",
    title: "5 Dark streetlights along School Lane",
    category: "Electricity",
    ward: "Ward 4 - Model Town",
    address: "Lane 8, Model Town East",
    citizenName: "Pooja Sharma",
    priority: "Medium",
    status: "Verified Closed",
    createdAt: "4 days ago",
    slaHoursLeft: 0,
    isBreached: false,
  },
  {
    id: "GRV-2026-105",
    title: "Severe stormwater drain blockage causing backflow",
    category: "Drainage",
    ward: "Ward 1 - Civil Lines",
    address: "Main Bazaar Road",
    citizenName: "Harish Rawat",
    priority: "High",
    status: "In Progress",
    createdAt: "Yesterday at 11:00 AM",
    slaHoursLeft: -2,
    isBreached: true,
  },
];

export default function MunicipalDashboard() {
  const [grievances, setGrievances] = useState<GrievanceItem[]>(initialGrievances);
  const [search, setSearch] = useState("");
  const [selectedStatus, setSelectedStatus] = useState<string>("All");
  const [selectedCategory, setSelectedCategory] = useState<string>("All");
  const [selectedWard, setSelectedWard] = useState<string>("All");
  const [activeModalItem, setActiveModalItem] = useState<GrievanceItem | null>(null);

  const [dispatchWard, setDispatchWard] = useState<string | null>(null);
  const [selectedSquad, setSelectedSquad] = useState<string>("Squad Alpha - Rapid Pothole & Road Repair");
  const [dispatchNotes, setDispatchNotes] = useState<string>("");
  const [dispatchAlert, setDispatchAlert] = useState<string | null>(null);

  const [currentRole, setCurrentRole] = useState<"Super Admin" | "Ward Officer" | "Department Head">("Super Admin");
  const [auditLogs, setAuditLogs] = useState<{ id: string; user: string; role: string; action: string; time: string }[]>([
    { id: "LOG-01", user: "Commissioner K. Sen", role: "Super Admin", action: "Dispatched Emergency Squad Alpha to Ward 1", time: "10 mins ago" },
    { id: "LOG-02", user: "Officer S. Verma", role: "Ward Officer", action: "Updated GRV-2026-101 status to In Progress", time: "25 mins ago" },
    { id: "LOG-03", user: "Er. K. Narayanan", role: "Department Head", action: "Approved PWD road asphalt maintenance manifest", time: "1 hour ago" },
  ]);

  const [notices, setNotices] = useState<NoticeBroadcast[]>(initialNotices);
  const [showNoticeModal, setShowNoticeModal] = useState(false);
  const [newNoticeTitle, setNewNoticeTitle] = useState("");
  const [newNoticeCategory, setNewNoticeCategory] = useState<NoticeBroadcast["category"]>("Water Supply");
  const [newNoticeWard, setNewNoticeWard] = useState("All Wards");
  const [newNoticeUrgency, setNewNoticeUrgency] = useState<NoticeBroadcast["urgency"]>("Urgent");
  const [newNoticeMessage, setNewNoticeMessage] = useState("");

  const handlePublishNotice = () => {
    if (!newNoticeTitle.trim() || !newNoticeMessage.trim()) return;
    const newNotice: NoticeBroadcast = {
      id: `NTC-2026-0${Math.floor(10 + Math.random() * 90)}`,
      title: newNoticeTitle.trim(),
      category: newNoticeCategory,
      targetWard: newNoticeWard,
      urgency: newNoticeUrgency,
      message: newNoticeMessage.trim(),
      publishedAt: "Just now",
    };
    setNotices([newNotice, ...notices]);
    setShowNoticeModal(false);
    setNewNoticeTitle("");
    setNewNoticeMessage("");
    setDispatchAlert(`Municipal Broadcast Notice ${newNotice.id} pushed to citizens in ${newNoticeWard}.`);
    setTimeout(() => setDispatchAlert(null), 6000);
  };

  const wardsSummary = [
    { id: "Ward 1", name: "Ward 1 - Civil Lines", officer: "Sanjay Verma", phone: "+91 98100 11223" },
    { id: "Ward 2", name: "Ward 2 - Gandhi Nagar", officer: "Anita Mehra", phone: "+91 98100 22334" },
    { id: "Ward 3", name: "Ward 3 - Industrial Area", officer: "Vikram Rathore", phone: "+91 98100 33445" },
    { id: "Ward 4", name: "Ward 4 - Model Town", officer: "Neha Saxena", phone: "+91 98100 44556" },
  ].map((w) => {
    const wardGrievances = grievances.filter((g) => g.ward.includes(w.id));
    const breachedCount = wardGrievances.filter((g) => g.isBreached).length;
    const activeCount = wardGrievances.filter((g) => g.status !== "Verified Closed").length;
    const risk = breachedCount > 0 ? "critical" : activeCount > 1 ? "moderate" : "nominal";
    return { ...w, activeCount, breachedCount, risk };
  });

  const handleDispatchSubmit = () => {
    if (!dispatchWard) return;
    setDispatchAlert(
      `Dispatch Confirmed: ${selectedSquad} deployed to ${dispatchWard}. SMS alert broadcast to field officer.`
    );
    setDispatchWard(null);
    setDispatchNotes("");
    setTimeout(() => setDispatchAlert(null), 6000);
  };

  const filtered = grievances.filter((g) => {
    if (selectedStatus !== "All" && g.status !== selectedStatus) return false;
    if (selectedCategory !== "All" && g.category !== selectedCategory) return false;
    if (selectedWard !== "All" && !g.ward.includes(selectedWard)) return false;
    if (search.trim()) {
      const q = search.toLowerCase();
      return (
        g.title.toLowerCase().includes(q) ||
        g.id.toLowerCase().includes(q) ||
        g.address.toLowerCase().includes(q) ||
        g.citizenName.toLowerCase().includes(q)
      );
    }
    return true;
  });

  const total = grievances.length;
  const inProgress = grievances.filter((g) => g.status === "In Progress").length;
  const breached = grievances.filter((g) => g.isBreached).length;
  const resolved = grievances.filter(
    (g) => g.status === "Resolved" || g.status === "Verified Closed"
  ).length;
  const complianceRate = Math.round(((total - breached) / total) * 100);

  const handleStatusChange = (id: string, newStatus: GrievanceItem["status"]) => {
    setGrievances((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, status: newStatus, isBreached: false } : item
      )
    );
    if (activeModalItem && activeModalItem.id === id) {
      setActiveModalItem({ ...activeModalItem, status: newStatus });
    }
  };

  const exportCsv = () => {
    const headers = "ID,Title,Category,Ward,Priority,Status,Citizen,Address\n";
    const rows = filtered
      .map(
        (g) =>
          `"${g.id}","${g.title}","${g.category}","${g.ward}","${g.priority}","${g.status}","${g.citizenName}","${g.address}"`
      )
      .join("\n");
    const blob = new Blob([headers + rows], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `JanSeva_Grievances_${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
  };

  const exportAuditJson = () => {
    const auditReport = {
      reportTitle: "JanSeva Municipal Grievance Statutory Audit Dossier",
      generatedAt: new Date().toISOString(),
      complianceRate: `${complianceRate}%`,
      totalLogged: total,
      breachedSla: breached,
      activeWards: wardsSummary,
      records: filtered,
    };
    const blob = new Blob([JSON.stringify(auditReport, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `JanSeva_Audit_Dossier_${new Date().toISOString().slice(0, 10)}.json`;
    a.click();
  };

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans">
      {/* Top Header */}
      <header className="bg-blue-900 text-white border-b border-blue-950 sticky top-0 z-30 shadow-md">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="bg-blue-700 p-2 rounded-lg">
              <ShieldAlert className="h-6 w-6 text-amber-300" />
            </div>
            <div>
              <h1 className="text-lg font-bold tracking-tight">JanSeva (जनसेवा)</h1>
              <p className="text-xs text-blue-200">
                Municipal Grievance Command & Telemetry Center
              </p>
            </div>
          </div>

          <div className="flex items-center space-x-3">
            <button
              onClick={() => setShowNoticeModal(true)}
              className="flex items-center space-x-1.5 bg-amber-400 hover:bg-amber-500 text-slate-900 text-xs font-bold px-3 py-2 rounded-md transition shadow-sm"
            >
              <Megaphone className="h-4 w-4" />
              <span>Broadcast Notice</span>
            </button>
            <button
              onClick={exportCsv}
              className="flex items-center space-x-1.5 bg-blue-800 hover:bg-blue-700 text-white text-xs font-semibold px-3 py-2 rounded-md transition"
            >
              <Download className="h-4 w-4" />
              <span>Export CSV</span>
            </button>
            <button
              onClick={exportAuditJson}
              className="flex items-center space-x-1.5 bg-indigo-700 hover:bg-indigo-600 text-white text-xs font-semibold px-3 py-2 rounded-md transition"
            >
              <Download className="h-4 w-4" />
              <span>Audit JSON</span>
            </button>
            <div className="h-6 w-[1px] bg-blue-800" />
            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
              Live Gateway Online
            </span>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        {/* KPI Scorecard Grid */}
        <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                Total Grievances
              </p>
              <h3 className="text-2xl font-black text-slate-900 mt-1">{total}</h3>
              <p className="text-xs text-slate-400 mt-1">Across 5 municipal zones</p>
            </div>
            <div className="p-3 bg-blue-50 text-blue-700 rounded-lg">
              <Layers className="h-6 w-6" />
            </div>
          </div>

          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                In Active Field Triage
              </p>
              <h3 className="text-2xl font-black text-amber-600 mt-1">{inProgress}</h3>
              <p className="text-xs text-amber-600/80 mt-1">Dispatched to engineers</p>
            </div>
            <div className="p-3 bg-amber-50 text-amber-600 rounded-lg">
              <RefreshCw className="h-6 w-6" />
            </div>
          </div>

          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                SLA Compliance Rate
              </p>
              <h3 className="text-2xl font-black text-emerald-600 mt-1">{complianceRate}%</h3>
              <p className="text-xs text-emerald-600/80 mt-1">
                {resolved} Resolved • Target ≥ 85%
              </p>
            </div>
            <div className="p-3 bg-emerald-50 text-emerald-600 rounded-lg">
              <CheckCircle2 className="h-6 w-6" />
            </div>
          </div>

          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-bold text-slate-500 uppercase tracking-wider">
                SLA Overdue / Breached
              </p>
              <h3 className="text-2xl font-black text-red-600 mt-1">{breached}</h3>
              <p className="text-xs text-red-600/80 mt-1">Requires supervisor escalation</p>
            </div>
            <div className="p-3 bg-red-50 text-red-600 rounded-lg">
              <AlertTriangle className="h-6 w-6" />
            </div>
          </div>
        </section>

        {/* Rapid Response Alert Banner (if active) */}
        {dispatchAlert && (
          <div className="bg-emerald-600 text-white p-4 rounded-xl shadow-md flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Truck className="h-5 w-5 text-emerald-200" />
              <p className="text-sm font-bold">{dispatchAlert}</p>
            </div>
            <button
              onClick={() => setDispatchAlert(null)}
              className="text-white hover:text-emerald-100 text-sm font-bold"
            >
              ✕
            </button>
          </div>
        )}

        {/* Interactive Ward Geo-grid & GIS Heatmap */}
        <section className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-4">
          <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-2">
            <div>
              <div className="flex items-center space-x-2">
                <Radio className="h-4 w-4 text-blue-600" />
                <h2 className="text-base font-bold text-slate-900">
                  Municipal Ward Geo-Grid & Rapid Response Command
                </h2>
              </div>
              <p className="text-xs text-slate-500 mt-0.5">
                Real-time incident density and emergency crew dispatch status across wards
              </p>
            </div>
            <span className="text-xs font-mono font-semibold px-2.5 py-1 bg-slate-100 text-slate-700 rounded-md self-start sm:self-auto">
              Auto-sync: 15s interval
            </span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-1">
            {wardsSummary.map((w) => {
              const isCritical = w.risk === "critical";
              const isModerate = w.risk === "moderate";

              return (
                <div
                  key={w.id}
                  className={`p-4 rounded-xl border transition relative overflow-hidden flex flex-col justify-between ${
                    isCritical
                      ? "bg-red-50/50 border-red-300"
                      : isModerate
                      ? "bg-amber-50/40 border-amber-300"
                      : "bg-slate-50 border-slate-200 hover:border-slate-300"
                  }`}
                >
                  <div>
                    <div className="flex justify-between items-start">
                      <span className="text-xs font-mono font-bold text-slate-500">{w.id}</span>
                      <span
                        className={`text-[10px] font-extrabold uppercase px-2 py-0.5 rounded-full ${
                          isCritical
                            ? "bg-red-600 text-white"
                            : isModerate
                            ? "bg-amber-500 text-white"
                            : "bg-emerald-600 text-white"
                        }`}
                      >
                        {isCritical ? "SLA Alert" : isModerate ? "Elevated" : "Nominal"}
                      </span>
                    </div>

                    <h3 className="font-bold text-slate-900 text-sm mt-1">{w.name}</h3>
                    <p className="text-xs text-slate-500 mt-0.5">
                      Officer: {w.officer}
                    </p>

                    <div className="grid grid-cols-2 gap-2 my-3 py-2 px-3 bg-white rounded-lg border border-slate-200/80 text-center">
                      <div>
                        <span className="text-xs text-slate-400 block font-semibold">Active</span>
                        <span className="text-base font-black text-slate-800">{w.activeCount}</span>
                      </div>
                      <div>
                        <span className="text-xs text-slate-400 block font-semibold">Breached</span>
                        <span
                          className={`text-base font-black ${
                            w.breachedCount > 0 ? "text-red-600" : "text-slate-800"
                          }`}
                        >
                          {w.breachedCount}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div className="flex gap-2 pt-1">
                    <button
                      onClick={() => setSelectedWard(w.id)}
                      className="flex-1 py-1.5 px-2 bg-white hover:bg-slate-100 text-slate-700 text-xs font-bold rounded-lg border border-slate-300 transition"
                    >
                      Filter View
                    </button>
                    <button
                      onClick={() => setDispatchWard(w.name)}
                      className={`flex-1 py-1.5 px-2 text-white text-xs font-bold rounded-lg transition flex items-center justify-center space-x-1 ${
                        isCritical
                          ? "bg-red-600 hover:bg-red-700"
                          : "bg-blue-600 hover:bg-blue-700"
                      }`}
                    >
                      <Truck className="h-3 w-3" />
                      <span>Dispatch</span>
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        </section>

        {/* Active Municipal Broadcast Notices Banner */}
        <section className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-2">
              <Megaphone className="h-5 w-5 text-amber-600" />
              <h2 className="text-base font-bold text-slate-900">
                Active Ward Broadcasts & Public Notices ({notices.length})
              </h2>
            </div>
            <button
              onClick={() => setShowNoticeModal(true)}
              className="text-xs font-bold text-blue-700 hover:text-blue-900 border border-blue-200 hover:border-blue-400 px-3 py-1.5 rounded-lg transition"
            >
              + Publish New Notice
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {notices.map((ntc) => (
              <div
                key={ntc.id}
                className="p-4 rounded-xl border border-slate-200 bg-slate-50/70 hover:bg-slate-50 transition space-y-2"
              >
                <div className="flex justify-between items-start">
                  <div className="flex items-center space-x-2">
                    <span className="font-mono text-xs font-bold text-slate-400">{ntc.id}</span>
                    <span className="text-xs font-bold text-blue-700 bg-blue-50 px-2 py-0.5 rounded">
                      {ntc.category}
                    </span>
                  </div>
                  <span
                    className={`text-[10px] font-extrabold uppercase px-2 py-0.5 rounded-full ${
                      ntc.urgency === "Critical Alert"
                        ? "bg-red-600 text-white"
                        : ntc.urgency === "Urgent"
                        ? "bg-amber-500 text-white"
                        : "bg-blue-600 text-white"
                    }`}
                  >
                    {ntc.urgency}
                  </span>
                </div>

                <h3 className="font-bold text-slate-900 text-sm">{ntc.title}</h3>
                <p className="text-xs text-slate-600 leading-relaxed">{ntc.message}</p>

                <div className="flex justify-between items-center text-[11px] text-slate-500 pt-2 border-t border-slate-200">
                  <span className="flex items-center">
                    <MapPin className="h-3 w-3 mr-1 text-slate-400" />
                    Target: {ntc.targetWard}
                  </span>
                  <span>{ntc.publishedAt}</span>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Department SLA & Performance Leaderboard */}
        <section className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-2">
              <Layers className="h-5 w-5 text-indigo-600" />
              <h2 className="text-base font-bold text-slate-900">
                Department SLA Adherence & Performance Leaderboard
              </h2>
            </div>
            <span className="text-xs font-semibold text-slate-500">Live Weekly Aggregation</span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {[
              { name: "Public Works (PWD)", lead: "Er. K. Narayanan", sla: 94, avgHours: "18h", penalty: "₹0", grade: "A+" },
              { name: "Solid Waste & Sanitation", lead: "Dr. S. Mukherjee", sla: 88, avgHours: "26h", penalty: "₹0", grade: "A" },
              { name: "Water Supply & Sewage", lead: "Er. V. Deshmukh", sla: 76, avgHours: "42h", penalty: "₹15,000", grade: "B" },
              { name: "Electricity & Streetlights", lead: "Er. A. Bansal", sla: 96, avgHours: "12h", penalty: "₹0", grade: "A+" },
            ].map((dept, idx) => (
              <div
                key={idx}
                className="p-4 rounded-xl border border-slate-200/80 bg-slate-50/60 hover:bg-slate-50 transition flex flex-col justify-between"
              >
                <div>
                  <div className="flex justify-between items-start">
                    <span className="text-xs font-bold text-slate-700">{dept.name}</span>
                    <span
                      className={`text-[10px] font-black px-2 py-0.5 rounded-full ${
                        dept.grade === "A+"
                          ? "bg-emerald-100 text-emerald-800"
                          : dept.grade === "A"
                          ? "bg-blue-100 text-blue-800"
                          : "bg-amber-100 text-amber-800"
                      }`}
                    >
                      Grade {dept.grade}
                    </span>
                  </div>
                  <p className="text-[11px] text-slate-500 mt-1">Lead: {dept.lead}</p>

                  <div className="my-3 space-y-1.5">
                    <div className="flex justify-between text-xs">
                      <span className="text-slate-500 font-medium">SLA Adherence</span>
                      <span className="font-bold text-slate-800">{dept.sla}%</span>
                    </div>
                    <div className="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
                      <div
                        className={`h-full rounded-full ${
                          dept.sla >= 90 ? "bg-emerald-500" : dept.sla >= 80 ? "bg-blue-500" : "bg-amber-500"
                        }`}
                        style={{ width: `${dept.sla}%` }}
                      />
                    </div>
                  </div>
                </div>

                <div className="pt-2 border-t border-slate-200/60 flex justify-between text-[11px] text-slate-600">
                  <span>Avg MTTR: <strong className="text-slate-800">{dept.avgHours}</strong></span>
                  <span>SLA Deductions: <strong className={dept.penalty !== "₹0" ? "text-red-600" : "text-slate-700"}>{dept.penalty}</strong></span>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Multi-Role Access Control (RBAC) & Tamper-Proof Audit Log Ledger */}
        <section className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-4">
          <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-3">
            <div className="flex items-center space-x-2">
              <ShieldAlert className="h-5 w-5 text-emerald-600" />
              <div>
                <h2 className="text-base font-bold text-slate-900">
                  Municipal Multi-Role Access Control & Security Ledger
                </h2>
                <p className="text-xs text-slate-500">
                  Role: <span className="font-bold text-blue-900">{currentRole}</span> • Immutable SHA-256 Audit Trails
                </p>
              </div>
            </div>

            {/* Role Switcher */}
            <div className="flex items-center space-x-1.5 bg-slate-100 p-1 rounded-lg">
              {(["Super Admin", "Ward Officer", "Department Head"] as const).map((r) => (
                <button
                  key={r}
                  onClick={() => setCurrentRole(r)}
                  className={`text-xs font-bold px-2.5 py-1.5 rounded-md transition ${
                    currentRole === r
                      ? "bg-blue-900 text-white shadow-sm"
                      : "text-slate-600 hover:text-slate-900"
                  }`}
                >
                  {r}
                </button>
              ))}
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs text-slate-600">
              <thead className="bg-slate-50 uppercase font-bold text-slate-500 border-b border-slate-200">
                <tr>
                  <th className="px-4 py-2.5">Log ID</th>
                  <th className="px-4 py-2.5">Officer / User</th>
                  <th className="px-4 py-2.5">Designation</th>
                  <th className="px-4 py-2.5">Action Executed</th>
                  <th className="px-4 py-2.5">Timestamp</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 font-medium">
                {auditLogs.map((log) => (
                  <tr key={log.id} className="hover:bg-slate-50/80 transition">
                    <td className="px-4 py-2.5 font-mono font-bold text-slate-800">{log.id}</td>
                    <td className="px-4 py-2.5 text-slate-900 font-bold">{log.user}</td>
                    <td className="px-4 py-2.5">
                      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-blue-800">
                        {log.role}
                      </span>
                    </td>
                    <td className="px-4 py-2.5 text-slate-700">{log.action}</td>
                    <td className="px-4 py-2.5 text-slate-400 font-mono">{log.time}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        {/* Filters and Controls */}
        <section className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex flex-col md:flex-row gap-4 justify-between items-center">
          <div className="relative w-full md:w-80">
            <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
            <input
              type="text"
              placeholder="Search ID, title, citizen, locality..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-600"
            />
          </div>

          <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
            <div className="flex items-center space-x-1 bg-slate-100 p-1 rounded-lg">
              {["All", "Submitted", "In Progress", "Resolved", "Verified Closed"].map((status) => (
                <button
                  key={status}
                  onClick={() => setSelectedStatus(status)}
                  className={`text-xs font-semibold px-3 py-1.5 rounded-md transition ${
                    selectedStatus === status
                      ? "bg-white text-blue-900 shadow-sm"
                      : "text-slate-600 hover:text-slate-900"
                  }`}
                >
                  {status}
                </button>
              ))}
            </div>

            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="border border-slate-300 rounded-lg px-3 py-2 text-xs font-semibold bg-white text-slate-700 focus:outline-none"
            >
              <option value="All">All Categories</option>
              <option value="Roads">Roads</option>
              <option value="Sanitation">Sanitation</option>
              <option value="Water">Water</option>
              <option value="Electricity">Electricity</option>
              <option value="Drainage">Drainage</option>
            </select>

            <select
              value={selectedWard}
              onChange={(e) => setSelectedWard(e.target.value)}
              className="border border-slate-300 rounded-lg px-3 py-2 text-xs font-semibold bg-white text-slate-700 focus:outline-none"
            >
              <option value="All">All Municipal Wards</option>
              <option value="Ward 1">Ward 1 - Civil Lines</option>
              <option value="Ward 2">Ward 2 - Gandhi Nagar</option>
              <option value="Ward 3">Ward 3 - Industrial Area</option>
              <option value="Ward 4">Ward 4 - Model Town</option>
            </select>
          </div>
        </section>

        {/* Complaints Data Table */}
        <section className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
          <div className="px-6 py-4 border-b border-slate-200 flex justify-between items-center">
            <h2 className="text-base font-bold text-slate-900">
              Active Municipal Complaints ({filtered.length})
            </h2>
            <div className="flex items-center text-xs text-slate-500 space-x-1">
              <Filter className="h-3.5 w-3.5" />
              <span>Sorted by priority & urgency</span>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm text-slate-600">
              <thead className="bg-slate-50 text-xs uppercase font-bold text-slate-500 border-b border-slate-200">
                <tr>
                  <th className="px-6 py-3">ID & Category</th>
                  <th className="px-6 py-3">Grievance Title & Ward</th>
                  <th className="px-6 py-3">Priority</th>
                  <th className="px-6 py-3">SLA Status</th>
                  <th className="px-6 py-3">Status</th>
                  <th className="px-6 py-3 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200">
                {filtered.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50/80 transition">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className="font-mono text-xs font-bold text-slate-800">
                        {item.id}
                      </span>
                      <div className="text-xs text-blue-700 font-semibold">{item.category}</div>
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-semibold text-slate-900 line-clamp-1">{item.title}</p>
                      <p className="text-xs text-slate-500 flex items-center mt-0.5">
                        <MapPin className="h-3 w-3 mr-1 text-slate-400" />
                        {item.ward} • {item.address}
                      </p>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-0.5 rounded text-[11px] font-bold ${
                          item.priority === "Emergency"
                            ? "bg-red-100 text-red-800 border border-red-200"
                            : item.priority === "High"
                            ? "bg-amber-100 text-amber-800 border border-amber-200"
                            : "bg-slate-100 text-slate-700"
                        }`}
                      >
                        {item.priority}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {item.isBreached ? (
                        <span className="inline-flex items-center text-xs font-bold text-red-600 bg-red-50 px-2 py-1 rounded">
                          <AlertTriangle className="h-3 w-3 mr-1" />
                          Breached ({Math.abs(item.slaHoursLeft)}h overdue)
                        </span>
                      ) : (
                        <span className="inline-flex items-center text-xs font-semibold text-slate-600">
                          <Clock className="h-3 w-3 mr-1 text-slate-400" />
                          {item.slaHoursLeft > 0 ? `${item.slaHoursLeft}h left` : "On Schedule"}
                        </span>
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold ${
                          item.status === "Resolved"
                            ? "bg-emerald-100 text-emerald-800"
                            : item.status === "Verified Closed"
                            ? "bg-blue-100 text-blue-800"
                            : item.status === "In Progress"
                            ? "bg-amber-100 text-amber-800"
                            : "bg-slate-100 text-slate-800"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right">
                      <button
                        onClick={() => setActiveModalItem(item)}
                        className="text-xs font-bold text-blue-700 hover:text-blue-900 border border-blue-200 hover:border-blue-400 px-3 py-1.5 rounded-md transition"
                      >
                        Triage & Update
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </main>

      {/* Triage Modal */}
      {activeModalItem && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-xl max-w-lg w-full p-6 shadow-xl border border-slate-200 space-y-4">
            <div className="flex justify-between items-start">
              <div>
                <span className="text-xs font-mono font-bold text-slate-400">
                  {activeModalItem.id}
                </span>
                <h3 className="text-lg font-bold text-slate-900 mt-0.5">
                  {activeModalItem.title}
                </h3>
              </div>
              <button
                onClick={() => setActiveModalItem(null)}
                className="text-slate-400 hover:text-slate-600 text-lg font-bold"
              >
                ✕
              </button>
            </div>

            <div className="bg-slate-50 p-3 rounded-lg text-xs space-y-1 text-slate-600">
              <p>
                <strong>Ward:</strong> {activeModalItem.ward}
              </p>
              <p>
                <strong>Address:</strong> {activeModalItem.address}
              </p>
              <p>
                <strong>Reporter:</strong> {activeModalItem.citizenName}
              </p>
              <p>
                <strong>Category:</strong> {activeModalItem.category}
              </p>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-2">
                Update Operational Status
              </label>
              <div className="grid grid-cols-3 gap-2">
                <button
                  onClick={() => handleStatusChange(activeModalItem.id, "In Progress")}
                  className={`py-2 px-3 rounded-lg text-xs font-bold border transition ${
                    activeModalItem.status === "In Progress"
                      ? "bg-amber-500 text-white border-amber-600"
                      : "border-slate-300 text-slate-700 hover:bg-slate-50"
                  }`}
                >
                  Mark In Progress
                </button>
                <button
                  onClick={() => handleStatusChange(activeModalItem.id, "Resolved")}
                  className={`py-2 px-3 rounded-lg text-xs font-bold border transition ${
                    activeModalItem.status === "Resolved"
                      ? "bg-emerald-600 text-white border-emerald-700"
                      : "border-slate-300 text-slate-700 hover:bg-slate-50"
                  }`}
                >
                  Mark Resolved
                </button>
                <button
                  onClick={() => handleStatusChange(activeModalItem.id, "Verified Closed")}
                  className={`py-2 px-3 rounded-lg text-xs font-bold border transition ${
                    activeModalItem.status === "Verified Closed"
                      ? "bg-blue-600 text-white border-blue-700"
                      : "border-slate-300 text-slate-700 hover:bg-slate-50"
                  }`}
                >
                  Verify & Close
                </button>
              </div>
            </div>

            <div className="flex justify-end pt-4 border-t border-slate-200">
              <button
                onClick={() => setActiveModalItem(null)}
                className="bg-slate-900 text-white text-xs font-bold px-4 py-2 rounded-lg hover:bg-slate-800 transition"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Rapid Response Squad Dispatch Modal */}
      {dispatchWard && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-xl max-w-md w-full p-6 shadow-xl border border-slate-200 space-y-4">
            <div className="flex justify-between items-start">
              <div className="flex items-center space-x-2">
                <div className="p-2 bg-blue-100 text-blue-700 rounded-lg">
                  <Truck className="h-5 w-5" />
                </div>
                <div>
                  <h3 className="text-base font-bold text-slate-900">
                    Emergency Squad Dispatch
                  </h3>
                  <p className="text-xs text-slate-500 font-medium">
                    Deploying to {dispatchWard}
                  </p>
                </div>
              </div>
              <button
                onClick={() => setDispatchWard(null)}
                className="text-slate-400 hover:text-slate-600 text-lg font-bold"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3">
              <div>
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                  Select Rapid Response Unit
                </label>
                <select
                  value={selectedSquad}
                  onChange={(e) => setSelectedSquad(e.target.value)}
                  className="w-full border border-slate-300 rounded-lg px-3 py-2 text-xs font-semibold bg-white text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                >
                  <option value="Squad Alpha - Rapid Pothole & Road Repair">
                    Squad Alpha - Rapid Pothole & Road Repair
                  </option>
                  <option value="Squad Beta - High-Capacity Desilting & Drainage">
                    Squad Beta - High-Capacity Desilting & Drainage
                  </option>
                  <option value="Squad Gamma - High-Voltage Electrical & Grid Triage">
                    Squad Gamma - High-Voltage Electrical & Grid Triage
                  </option>
                  <option value="Squad Delta - Water Pipeline & Pressure Integrity">
                    Squad Delta - Water Pipeline & Pressure Integrity
                  </option>
                  <option value="Squad Epsilon - Sanitation & Biohazard Remediation">
                    Squad Epsilon - Sanitation & Biohazard Remediation
                  </option>
                </select>
              </div>

              <div>
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                  Officer Priority Directives & Dispatch Notes
                </label>
                <textarea
                  value={dispatchNotes}
                  onChange={(e) => setDispatchNotes(e.target.value)}
                  placeholder="Enter specific instructions, GPS waypoint landmarks, or safety gear directives..."
                  rows={3}
                  className="w-full border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                />
              </div>

              <div className="bg-amber-50 border border-amber-200 rounded-lg p-2.5 flex items-start space-x-2">
                <AlertTriangle className="h-4 w-4 text-amber-600 shrink-0 mt-0.5" />
                <p className="text-[11px] text-amber-800 font-medium leading-relaxed">
                  Dispatching will instantly send an automated high-priority SMS alert with digital job cards to the squad foreman and ward officer.
                </p>
              </div>
            </div>

            <div className="flex justify-end space-x-2 pt-3 border-t border-slate-200">
              <button
                onClick={() => setDispatchWard(null)}
                className="px-3 py-2 rounded-lg text-xs font-semibold text-slate-600 hover:bg-slate-100 transition"
              >
                Cancel
              </button>
              <button
                onClick={handleDispatchSubmit}
                className="bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold px-4 py-2 rounded-lg shadow-sm transition flex items-center space-x-1.5"
              >
                <Truck className="h-3.5 w-3.5" />
                <span>Confirm Dispatch</span>
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Publish Municipal Notice Modal */}
      {showNoticeModal && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-xl max-w-lg w-full p-6 shadow-xl border border-slate-200 space-y-4">
            <div className="flex justify-between items-start">
              <div className="flex items-center space-x-2">
                <div className="p-2 bg-amber-100 text-amber-700 rounded-lg">
                  <Megaphone className="h-5 w-5" />
                </div>
                <div>
                  <h3 className="text-base font-bold text-slate-900">
                    Broadcast Municipal Notice
                  </h3>
                  <p className="text-xs text-slate-500 font-medium">
                    Push urgent notification & advisory to citizen apps
                  </p>
                </div>
              </div>
              <button
                onClick={() => setShowNoticeModal(false)}
                className="text-slate-400 hover:text-slate-600 text-lg font-bold"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3">
              <div>
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                  Notice Headline / Alert Title
                </label>
                <input
                  type="text"
                  value={newNoticeTitle}
                  onChange={(e) => setNewNoticeTitle(e.target.value)}
                  placeholder="e.g. Scheduled Water Pipeline Maintenance..."
                  className="w-full border border-slate-300 rounded-lg px-3 py-2 text-xs font-semibold text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                    Category
                  </label>
                  <select
                    value={newNoticeCategory}
                    onChange={(e) =>
                      setNewNoticeCategory(e.target.value as NoticeBroadcast["category"])
                    }
                    className="w-full border border-slate-300 rounded-lg px-2.5 py-2 text-xs font-semibold bg-white text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                  >
                    <option value="Water Supply">Water Supply</option>
                    <option value="Electricity Grid">Electricity Grid</option>
                    <option value="Sanitation Fogging">Sanitation Fogging</option>
                    <option value="Roadwork">Roadwork</option>
                    <option value="Health Advisory">Health Advisory</option>
                  </select>
                </div>

                <div>
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                    Target Ward
                  </label>
                  <select
                    value={newNoticeWard}
                    onChange={(e) => setNewNoticeWard(e.target.value)}
                    className="w-full border border-slate-300 rounded-lg px-2.5 py-2 text-xs font-semibold bg-white text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                  >
                    <option value="All Wards">All Wards (Citywide)</option>
                    <option value="Ward 1 - Civil Lines">Ward 1 - Civil Lines</option>
                    <option value="Ward 2 - Gandhi Nagar">Ward 2 - Gandhi Nagar</option>
                    <option value="Ward 3 - Industrial Area">Ward 3 - Industrial Area</option>
                    <option value="Ward 4 - Model Town">Ward 4 - Model Town</option>
                  </select>
                </div>

                <div>
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                    Urgency Tier
                  </label>
                  <select
                    value={newNoticeUrgency}
                    onChange={(e) =>
                      setNewNoticeUrgency(e.target.value as NoticeBroadcast["urgency"])
                    }
                    className="w-full border border-slate-300 rounded-lg px-2.5 py-2 text-xs font-semibold bg-white text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                  >
                    <option value="Advisory">Advisory</option>
                    <option value="Urgent">Urgent</option>
                    <option value="Critical Alert">Critical Alert</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wider block mb-1">
                  Public Notification Message & Instructions
                </label>
                <textarea
                  value={newNoticeMessage}
                  onChange={(e) => setNewNoticeMessage(e.target.value)}
                  placeholder="Detail timing, affected blocks, standby contact or relief measures..."
                  rows={3}
                  className="w-full border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-600"
                />
              </div>

              <div className="bg-blue-50 border border-blue-200 rounded-lg p-2.5 flex items-start space-x-2">
                <Bell className="h-4 w-4 text-blue-600 shrink-0 mt-0.5" />
                <p className="text-[11px] text-blue-800 font-medium leading-relaxed">
                  Publishing will trigger high-priority push notifications to registered citizen accounts and sync to ward digital display boards.
                </p>
              </div>
            </div>

            <div className="flex justify-end space-x-2 pt-3 border-t border-slate-200">
              <button
                onClick={() => setShowNoticeModal(false)}
                className="px-3 py-2 rounded-lg text-xs font-semibold text-slate-600 hover:bg-slate-100 transition"
              >
                Cancel
              </button>
              <button
                onClick={handlePublishNotice}
                className="bg-amber-500 hover:bg-amber-600 text-slate-900 text-xs font-bold px-4 py-2 rounded-lg shadow-sm transition flex items-center space-x-1.5"
              >
                <Send className="h-3.5 w-3.5" />
                <span>Broadcast Notice</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
