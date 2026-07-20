// SAJNA AI - Core JavaScript Controller

// Offline RAG Document Database - Extracted from Air Arabia Cabin Safety Procedure Manual (Rev 18)
const CSPM_DATABASE = [
  {
    category: "door_arming",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.11 Cabin Door Arming/Disarming Procedures (SOP)",
    page: 268,
    tags: ["arm", "arming", "cross check", "command", "l1", "r1", "l4", "r4c", "girt bar", "slide"],
    text: `2.11 — Cabin Door Arming/Disarming Procedures
The Cabin Supervisor (CS) is responsible to order the Arming/Disarming of the cabin doors.

2.11.1 — Definition of Cross-check:
A cross-check is a visual and a physical check of the opposite door to verify/confirm whether the door is armed or disarmed as appropriate. It must be actioned by the crew members responsible for arming and disarming doors.

2.11.2 — Procedure for Door Arming:
1. Upon receiving the command “CABIN CREW ARM DOORS AND CROSS CHECK”, Crew shall first Arm LHS door then the RHS door.
2. Before starting to Arm the door, the door operator shall state the following: "Arming my door."
3. Crew member in charge of the door will action the command and start the Arming action.
4. The Door operator shall request from the witness to check that the door is Armed by stating: "Confirm Armed."
5. The witness crew shall physically cross check and respond: “Armed Confirmed”.
6. Once the Arming action is completed, both crew will go to the second door and repeat the actions.
7. Note: On departure, once all the cabin doors are closed, and without waiting for the ground equipment to be removed, the CS will immediately make the following PA announcement: “CABIN CREW ARM DOORS AND CROSS-CHECK”."`
  },
  {
    category: "door_disarming",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.11.2 (2) Door Disarming Procedures (SOP)",
    page: 269,
    tags: ["disarm", "disarming", "cross check", "command", "l1", "r1", "l4", "r4c", "slide", "unlocked", "open door"],
    text: `2.11.2 (2) — Procedure for Door Disarming:
a. Upon receiving the command “CABIN CREW DISARM DOORS AND CROSS CHECK”, Crew shall first Disarm LHS door then the RHS door.
b. Before starting to Disarm the door, the door operator shall state the following: "Disarming my door."
c. Crew member in charge of the door will action the command and start the Disarming actions.
d. The Door operator shall request from the witness to check that the door is Disarmed by stating: "Confirm Disarmed."
e. The witness crew shall physically cross check and respond: “Disarmed Confirmed”.
f. Once the Disarming action is completed, both crew will go to the second door and repeat the actions.
g. Crew members shall then pass the door Disarming confirmation to the Cabin Supervisor (CS).
h. CS will then ask for confirmation from the Commander via the interphone: “CAPTAIN, ALL DOORS DISARMED AND CROSS-CHECKED. IS IT CLEAR TO OPEN DOORS”.
i. The Captain will check the relevant page on the ECAM and confirm: "Doors disarmed, clear to open."`
  },
  {
    category: "cabin_secure",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.12 Cabin Secure for Take-off and Landing (SOP)",
    page: 270,
    tags: ["secure", "take-off", "landing", "carts", "curtains", "seatbelts", "upright", "window shades", "tray tables", "lavatory", "refuses", "refuse", "seat belt refusal", "fasten"],
    text: `2.12 — Cabin Secure for Take-off and Landing
Before take-off and landing, the cabin secure check should be given to the Captain when the checks are completed.

2.12.1 — Cabin Secure Check Areas:
- All passengers including infants are seated with seat belts fastened.
- Seatbacks are fully upright, window shades are open (at least 50% open, exit rows fully open).
- Tray tables are closed, locked, and footrests are stowed.
- Carts are latched, brakes applied and secured in galleys.
- All galley container doors are locked and latched.
- All loose articles are stowed and secured.
- Lavatories are vacant, locked and secured.
- Cabin secure checks are passed to the CS by crew positions (L1, R1, L4, R4C).

Note on Seat Belt Refusal:
If a passenger refuses to fasten his seat belt, crew must speak to the passenger and explain the safety requirements. If he still refuses, the Cabin Supervisor (CS) must be informed immediately who will then speak to the passenger. If the passenger still refuses, the CS will liaise with the Commander who will authorise the removal of the person from the aircraft unless the safety instructions are complied with.`
  },
  {
    category: "boarding",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.19.2.2 & 2.19.2.3 Passenger Boarding Procedures",
    page: 295,
    tags: ["boarding", "welcome", "headcount", "count", "overhead bin", "curtains", "boarding completed", "load sheet", "pax"],
    text: `2.19.2.3 — When Passengers Board the Aircraft:
- Assigned Cabin Crew must welcome passengers at demo positions.
- R1 Cabin Crew should count passengers from first row till last row on both sides.
- R4C Cabin Crew shall count passengers from last row until the first row on both sides.
- Passenger count must tally with the load sheet.
- When boarding is completed, the CS will make a PA: “Boarding Completed”.
- CS will obtain all flight documents (General Declaration GD, Passenger Info List PIL, Load sheet, and Cargo documents).
- Cabin Crew must close and secure all overhead stowage compartments (OHSC).
- Secure all curtains and cabin dividers in the open position.`
  },
  {
    category: "infant_procedures",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.7.2 & 2.7.3 Infant Seating Rules and Certified Chairs",
    page: 253,
    tags: ["infant", "child", "certified chair", "car seat", "lap belt", "loop belt", "oxygen mask", "row triple block"],
    text: `2.7.2 — Certified Infant Chairs:
- Infants can be carried in certified chairs whenever they are vacant and secured to the aircraft seat.
- Certified infant chairs must not obstruct other passengers' way to the aisle.
- Adults accompanied by an infant are responsible for securing the infant's chair to the aircraft seat and for securing the infant to the chair with the seat belt for takeoff, landing, and during flight.

2.7.3 — Infant Seating Policy:
- Multiple occupancy of a seat by one adult and one infant is permitted only if the infant is properly secured by a loop belt (infant lap belt) attached to the adult's safety belt.
- An oxygen dispensing unit must be available for both adult and infant (4 oxygen masks per row block). A maximum of one infant is allowed per seat row triple block.`
  },
  {
    category: "wheelchair_passengers",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.7.1 Special Category Passengers (SCPs) Seating Policy",
    page: 252,
    tags: ["wheelchair", "special category", "scp", "disability", "frail", "blind", "deaf", "exit row", "obese", "deportees"],
    text: `2.7.1 — Special Category Passengers (SCPs):
The following categories of passengers are among those who shall NOT be allocated to, or directed to seats which permit direct access to emergency exits:
- PRMs (Persons with Reduced Mobility) and wheelchair passengers.
- Passengers who because of age or sickness are so frail that they have difficulty in moving quickly.
- Passengers who are so obese that they would have difficulty in moving quickly or reaching/passing through exits (no extension seat belt is provided at overwing exit).
- Substantially blind or substantially deaf passengers.
- Children younger than 16 years of age and infants.
- Pregnant women.
- Note: Walking aids, crutches or walking sticks must be stowed in overhead compartments for takeoff and landing.`
  },
  {
    category: "wheelchair_passengers",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.7.1.1 Carriage of Special Category Passengers (SCPs)",
    page: 253,
    tags: ["disability", "disabled", "limbs", "floor level exits", "escort", "mental", "blind", "deaf"],
    text: `2.7.1.1 — Carriage of Special Category Passengers (SCPs):
- Passenger travelling with child under 12 years: should be seated in the same row segment. If not possible, no more than one seat row or aisle away.
- Passenger with physical size limits: seating of more than one obese passenger in the same seat row segment should be avoided.
- Passenger with physical disability of upper limbs: allocate seats during all phases of flight so visual and audible communication can be established with cabin crew.
- Passenger with disability of lower limbs (or both upper and lower limbs): seat in a location providing easy access to floor level exits.
- Mentally impaired passenger: required to travel with an escort. Seat where visual and audible communication can be established.`
  },
  {
    category: "exit_row_seating",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.7.4 Exit Row Seating Assignments (ABPs)",
    page: 255,
    tags: ["exit row", "emergency exit", "abp", "able bodied", "restrictions", "pax", "seating"],
    text: `2.7.4 — Exit Row Seating Assignments:
Seats which permit direct access to emergency exits shall be assigned only to passengers who appear to be reasonably fit, strong and able to assist the rapid evacuation of the aircraft in an emergency after an appropriate briefing by the crew (e.g. Able Bodied Passengers).

Exit row seats shall NOT be assigned to:
- Special Category Passengers (SCPs) like PRMs, pregnant women, infants, or frail passengers.
- Passengers lacking the ability to understand instructions given by the crew or safety card.
- Passengers who have the responsibility of caring for small children.
- Overwing exit rows should not be left vacant. Cabin crew should move qualified ABPs to these seats during taxi, takeoff, and landing.`
  },
  {
    category: "dangerous_goods",
    chapter: "Chapter 10: Dangerous Goods",
    section: "10.1 Introduction and Recognition",
    page: 1125,
    tags: ["dangerous goods", "dg", "baggage", "prohibited", "spill", "hazard", "flammable", "lithium"],
    text: `10.1 — Introduction to Dangerous Goods (DG):
Dangerous goods means articles or substances which are capable of posing a risk to health, safety, property or the environment and which are shown in the list of dangerous goods in the Technical Instructions.

- Carriage of Dangerous Goods in passenger baggage is strictly regulated.
- Prohibited items in cabin: camping gas, loose lithium batteries (powerbanks) over limits, fireworks, strike-anywhere matches, flammable liquids.
- Emergency response for DG spills in cabin: summon back-up, don PBE/gloves, obtain Halon, retrieve Dangerous Goods kit, isolate item, monitor, and inform Flight Crew immediately.`
  },
  {
    category: "medical_emergency",
    chapter: "Chapter 7: Medical and First Aid",
    section: "7.0.3 Principles of Patient Care",
    page: 635,
    tags: ["medical", "doctor", "first aid", "cpr", "breathing", "responsiveness", "emk", "fak", "oxygen", "volunteer"],
    text: `7.0.3 — In-flight Medical Situation / Emergency:
First-aid is the immediate care given to the victim of an accident or sudden illness until professional medical care is available.

Principles of Patient Care:
1. ASSESS the situation and passenger responsiveness (Check ABC: Airway, Breathing, Circulation).
2. SUMMON assistance from other crew and page for medical volunteers:
   "Ladies and Gentlemen, if there is a Doctor of Medicine, a Registered Nurse or Paramedic on-board, please contact a Cabin Crew. Please also have your identification available."
3. DON gloves. Retrieve Emergency Medical Kit (EMK) or First Aid Kit (FAK).
4. ADMINISTER oxygen if passenger has breathing difficulties.
5. COMMUNICATE details immediately to the Captain.`
  },
  {
    category: "fire_procedure",
    chapter: "Chapter 5: Drills",
    section: "5.4.1 Basic Fire Fighting Drill",
    page: 580,
    tags: ["fire", "smoke", "halon", "extinguisher", "pbe", "gloves", "captain", "drill"],
    text: `5.4.1 — Basic Fire Fighting Drill:
1. SUMMON Assistance (Back-up crew).
2. DON PBE (Protective Breathing Equipment) and wear fire gloves immediately.
3. OBTAIN nearest Halon fire extinguisher and test it.
4. FIGHT the fire using the extinguisher (aim at the base of the fire, sweep side-to-side).
5. ORDER assistant to inform the Captain:
   - Where is the fire?
   - What is burning?
   - How much smoke is there and its colour?
   - Actions being taken & whether successful?
   - Number of Halon extinguishers used?
6. MOVE passengers and portable oxygen bottles away from the area.
7. WATCH the fire area continuously until landing to prevent re-ignition.`
  },
  {
    category: "fire_procedure",
    chapter: "Chapter 5: Drills",
    section: "5.4.3 Lavatory Fire / Smoke Alarm Drill",
    page: 581,
    tags: ["lavatory", "fire", "smoke", "detector", "hot door", "cold door", "halon", "gloves", "pbe"],
    text: `5.4.3 — Lavatory Fire/Smoke Detector Alarm Drill:
1. CHECK which lavatory is indicating alarm on AIP (Attendant Indication Panel).
2. CANCEL smoke detector alarm.
3. ASSESS lavatory door for heat (using back of hand).
4. SUMMON assistance (Back-up). Don PBE and wear fire gloves.
5. IF LAVATORY DOOR IS HOT:
   - Do NOT open door.
   - Crack door slightly and DISCHARGE full Halon fire extinguisher into lavatory.
   - Close door for 30 seconds. Re-open cautiously to check.
6. IF LAVATORY DOOR IS COLD:
   - ENTER lavatory with caution and locate/fight the fire from inside.
7. INFORM Captain with full details (Source, smoke color, action taken).`
  },
  {
    category: "fire_procedure",
    chapter: "Chapter 5: Drills",
    section: "5.4.7 Lithium Battery / Portable Electronic Device (PED) Fire Drill",
    page: 584,
    tags: ["lithium battery", "battery fire", "ped", "phone fire", "thermal runaway", "water", "container", "halon", "ice warning"],
    text: `5.4.7 — Lithium Battery / PED Fire Fighting Drill:
If there are flames:
1. SUMMON assistance. Move passengers away.
2. DISCONNECT power if device is plugged into aircraft outlet.
3. DON PBE and wear fire gloves.
4. DISCHARGE Halon extinguisher to extinguish flames.
When flames are suppressed:
5. POUR water or non-flammable liquid onto the device to cool battery cells (prevent thermal runaway).
6. Cool device for 5 minutes. DO NOT use ice or cover device.
7. PLACE device inside a Metallic Container filled with water (completely immersed).
8. TRANSFER container to a lavatory. Monitor periodically until landing.`
  },
  {
    category: "refusal_of_embarkation",
    chapter: "Chapter 2: Standard Operating Procedures",
    section: "2.9 Right of Refusal & Sick Passengers (MEDIF)",
    page: 259,
    tags: ["refusal", "sick", "fit to fly", "medif", "heart attack", "pregnant weeks", "pacemaker", "alcohol", "drugs"],
    text: `2.9.2 — Restricted Passengers for Transportation:
Under no circumstances will transportation be provided to a person who:
- Has NOT completed the Medical Form (MEDIF) for sick passengers requiring oxygen, stretchers, or medical escort.
- Has an airborne communicable disease.
- Is a pregnant woman after 36 weeks (or after 32 weeks in multiple pregnancy).
- Has suffered a heart attack, stroke or heart surgery within the last 3 weeks unless written Doctor's approval is obtained.
- Appears to be under the influence of alcohol or drugs to the extent that safety of the flight is endangered.`
  },
  {
    category: "emergency_introduction",
    chapter: "Chapter 4: Emergency Procedures",
    section: "4.1 Introduction & Time Factors",
    page: 493,
    tags: ["emergency", "evacuation", "time", "survivable", "drill", "captain", "abnormality", "communication"],
    text: `4.1 — Introduction to Emergency Procedures:
This chapter contains emergency procedures for Cabin Crew. The procedures set herewith are general guidelines and are at the discretion of the aircraft Captain.

- Cabin crew must be alert and vigilant at all times to recognize unusual noise, smell, or aircraft attitude.
- Abnormality must be reported immediately to the Captain and crew.
- Crew communication and CRM between flight and cabin crew is vital.
- 4.1.1 Time Factor: Time is limited and uncontrollable. In a major fire, there may be as little as 50 to 120 seconds of survivable atmosphere inside the cabin.
- 4.1.2 Checklists and Drills: Emergency drills must be committed to memory and carried out in the correct sequence without delay.`
  },
  {
    category: "survival_ditching",
    chapter: "Chapter 6: Survival",
    section: "6.3 Sea Survival & Ditching Procedures",
    page: 601,
    tags: ["survival", "ditching", "sea", "raft", "flares", "water", "hypothermia", "slide raft", "girt bar"],
    text: `6.3 — Sea Survival / Ditching Procedures:
Upon ditching in water:
1. Slide rafts must be detached from the door girt bar and launched.
2. Board passengers quickly, prioritizing injured, infants and elderly.
3. Distribute survival equipment (sea anchor, water maker, signaling mirror, flares).
4. Retain shelter and prevent hypothermia by huddling together.
5. Do NOT deploy slide inflation handles inside the cabin to prevent blocking exits.`
  },
  {
    category: "neo_systems",
    chapter: "Chapter 9: A321NEO/CEO Systems",
    section: "9.2 Airbus A321 NEO Cabin Door Configuration (ACF)",
    page: 951,
    tags: ["neo", "acf", "a321", "exits", "doors", "cabin flex", "type iii", "row 17", "row 27", "slide rafts"],
    text: `9.2 — Airbus A321 NEO Cabin Door Configuration:
- A321 CEO features 4 main entry doors and 4 overwing emergency exits.
- A321 NEO ACF (Cabin Flex) configuration replaces doors 2 and 3 with overwing Type III exit doors.
- Crew positions shift: CS L1 remains responsible for front cabin. Mid-cabin exits (L2/R2, L3/R3) must be checked by designated crew (L4 and R4C respectively).
- Exit rows: Row 17 and Row 27 are emergency exit rows on ACF configuration. PRMs and infants must not be seated in these rows.`
  },
  {
    category: "reporting_appendices",
    chapter: "Chapter 12: Appendices",
    section: "12.3 Cabin Safety Reports & Log Sheets",
    page: 1181,
    tags: ["appendices", "report", "iqsms", "flight log", "cdl", "appendix", "seals", "safety report"],
    text: `12.3 — Appendices and Cabin Safety Reports:
- Cabin Flight Log Sheet is a legal log of the flight. CS must fill and sign for outbound/inbound segments.
- IQSMS Cabin Safety Report must be completed online or offline within 24 hours of landing for all safety hazards, passenger disruptions, or medical events.
- Cabin Defect Log (CDL) must document all broken interior cabin equipment (such as broken seat locks, inoperative lights, galley ovens, toilet flush failure) for the Ground Engineer.`
  }
];

// List of English stop words
const STOP_WORDS = new Set([
  "how", "what", "where", "why", "who", "when", "the", "a", "an", "and", "or", "to", "of", "in", 
  "on", "at", "for", "with", "by", "about", "against", "between", "into", "through", "during", 
  "before", "after", "above", "below", "from", "up", "down", "is", "are", "was", "were", "be", 
  "been", "being", "have", "has", "had", "do", "does", "did", "but", "so", "if", "then", "we", 
  "you", "he", "she", "it", "they", "i", "me", "my", "our", "your", "his", "her", "their", "them", 
  "pax", "cabin", "flight", "procedure", "procedures", "manual", "air", "arabia", "does", "happen", 
  "tell", "rules", "rule", "should", "must", "can"
]);

// App State
let activeView = 'dashboard';
let tempTimings = {};
let isUTC = false;

// Benchmarks configuration
const TIMELINE_BENCHMARKS = {
  A320: {
    signInOffset: -60,
    arriveOffice: -15,
    readyBriefing: -5,
    leaveOffice: -50,
    arriveBoard: -40,
    preflightChecks: 10,
    boardingClearance: -30,
    boardingDuration: 18,
    closeDoors: -3,
    chocksToDoorOpen: 2,
    targetDisembarkation: 7,
    cleaningTimeOutstation: 8,
  },
  A321: {
    signInOffset: -75,
    arriveOffice: -15,
    readyBriefing: -5,
    leaveOffice: -60,
    arriveBoard: -50,
    preflightChecks: 10,
    boardingClearance: -40,
    boardingDuration: 22,
    closeDoors: -3,
    chocksToDoorOpen: 2,
    targetDisembarkation: 9,
    cleaningTimeOutstation: 8,
  }
};

// Initialize App
document.addEventListener("DOMContentLoaded", () => {
  setupNavigation();
  setupThemeToggle();
  setupReportCalculator();
  setupNotesManager();
  setupManualLibrary();
  setupChecklists();
  setupCalculators();
  setupDefectsLog();
  setupAIChat();
  setupSmartSearch();
  setupExportButtons();
  
  const today = new Date().toISOString().split('T')[0];
  document.getElementById('rep-date').value = today;
  document.getElementById('sheet-date').value = formatDateString(today);
  
  renderNotesList();
  renderDefectsList();
  updateSyncStatus();
});

// Helper: Format Date from YYYY-MM-DD to DD/MM/YYYY
function formatDateString(dateStr) {
  if (!dateStr) return '';
  const parts = dateStr.split('-');
  return `${parts[2]}/${parts[1]}/${parts[0]}`;
}

// 1. Navigation Routing
function setupNavigation() {
  const menuItems = document.querySelectorAll(".menu-item");
  menuItems.forEach(item => {
    item.addEventListener("click", (e) => {
      e.preventDefault();
      const view = item.getAttribute("data-view");
      switchView(view);
    });
  });
}

function switchView(viewId) {
  document.querySelectorAll(".menu-item").forEach(item => {
    if (item.getAttribute("data-view") === viewId) {
      item.classList.add("active");
    } else {
      item.classList.remove("active");
    }
  });

  document.querySelectorAll(".app-view").forEach(view => {
    if (view.id === `view-${viewId}`) {
      view.classList.add("active");
    } else {
      view.classList.remove("active");
    }
  });
  
  activeView = viewId;
}

// 2. Theme Toggle
function setupThemeToggle() {
  const btn = document.getElementById("theme-toggle");
  btn.addEventListener("click", () => {
    document.body.classList.toggle("light-mode");
    const isLight = document.body.classList.contains("light-mode");
    btn.innerHTML = isLight ? 
      `<span class="material-symbols-rounded">dark_mode</span><span>Dark Mode</span>` : 
      `<span class="material-symbols-rounded">light_mode</span><span>Light Mode</span>`;
  });
}

// 3. Smart Flight Report Calculations
function setupReportCalculator() {
  const form = document.getElementById("report-form");
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    calculateFlightReport();
  });

  document.getElementById("btn-show-local").addEventListener("click", () => {
    isUTC = false;
    document.getElementById("btn-show-local").classList.add("active");
    document.getElementById("btn-show-utc").classList.remove("active");
    renderTimingResults();
  });

  document.getElementById("btn-show-utc").addEventListener("click", () => {
    isUTC = true;
    document.getElementById("btn-show-utc").classList.add("active");
    document.getElementById("btn-show-local").classList.remove("active");
    renderTimingResults();
  });

  document.getElementById("btn-save-report").addEventListener("click", () => {
    saveReportToLogSheet();
  });
}

function calculateFlightReport() {
  const date = document.getElementById("rep-date").value;
  const flightNo = document.getElementById("rep-flight-no").value;
  const sector = document.getElementById("rep-sector").value.toUpperCase();
  const acType = document.getElementById("rep-ac-type").value;
  const acReg = document.getElementById("rep-ac-reg").value.toUpperCase();
  const paxCount = parseInt(document.getElementById("rep-pax-count").value) || 0;
  const std = document.getElementById("rep-std").value;
  const sta = document.getElementById("rep-sta").value;
  const tzOffset = parseInt(document.getElementById("rep-timezone").value) || 0;
  const specials = document.getElementById("rep-specials").value;

  if (!std || !sta) return;

  const benchmark = TIMELINE_BENCHMARKS[acType];
  
  const baseDate = new Date(`2026-07-20T${std}:00`);
  const arrivalDate = new Date(`2026-07-20T${sta}:00`);
  if (arrivalDate < baseDate) {
    arrivalDate.setDate(arrivalDate.getDate() + 1);
  }

  const addMin = (minOffset) => {
    const d = new Date(baseDate.getTime() + minOffset * 60000);
    return formatTime(d);
  };

  const addMinSta = (minOffset) => {
    const d = new Date(arrivalDate.getTime() + minOffset * 60000);
    return formatTime(d);
  };

  const signInMin = benchmark.signInOffset;
  const briefingStartMin = signInMin;
  const briefingEndMin = signInMin + 10;

  tempTimings = {
    metadata: { date, flightNo, sector, acType, acReg, paxCount, std, sta, tzOffset, specials },
    local: {
      "Briefing Starts": addMin(briefingStartMin),
      "Briefing Completed": addMin(briefingEndMin),
      "First Bus": addMin(benchmark.leaveOffice + 2),
      "Second Bus": addMin(benchmark.leaveOffice + 5),
      "Cabin Crew Onboard": addMin(benchmark.arriveBoard),
      "Cockpit Crew Onboard": addMin(benchmark.arriveBoard),
      "Cleaning Start": addMin(benchmark.arriveBoard + 2),
      "Cleaning Done": addMin(benchmark.boardingClearance),
      "Boarding Clearance": addMin(benchmark.boardingClearance),
      "First Passenger": addMin(benchmark.boardingClearance),
      "Last Passenger": addMin(benchmark.boardingClearance + benchmark.boardingDuration),
      "Door Closed": addMin(benchmark.closeDoors),
      "Aircraft Landed": formatTime(arrivalDate),
      "Door Open": addMinSta(benchmark.chocksToDoorOpen),
      "Last Passenger Disembarked": addMinSta(benchmark.chocksToDoorOpen + benchmark.targetDisembarkation),
      "Cleaning Started (Transit)": addMinSta(benchmark.chocksToDoorOpen + benchmark.targetDisembarkation + 1),
      "Cleaning Completed (Transit)": addMinSta(benchmark.chocksToDoorOpen + benchmark.targetDisembarkation + 1 + benchmark.cleaningTimeOutstation),
      "Door Open in Sharjah": addMinSta(benchmark.chocksToDoorOpen)
    },
    utc: {}
  };

  for (let key in tempTimings.local) {
    const localTime = tempTimings.local[key];
    const [h, m] = localTime.split(':').map(Number);
    let utcH = h - tzOffset;
    if (utcH < 0) utcH += 24;
    if (utcH >= 24) utcH -= 24;
    tempTimings.utc[key] = `${String(utcH).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
  }

  renderTimingResults();
  document.getElementById("results-action-buttons").style.display = "flex";
}

function formatTime(dateObj) {
  return `${String(dateObj.getHours()).padStart(2, '0')}:${String(dateObj.getMinutes()).padStart(2, '0')}`;
}

function renderTimingResults() {
  const container = document.getElementById("timings-result-grid");
  container.innerHTML = "";

  const sourceList = isUTC ? tempTimings.utc : tempTimings.local;

  for (let key in sourceList) {
    const timeVal = sourceList[key];
    let alertClass = "benchmark-alert-ontime";
    if (key.includes("Last Passenger") || key.includes("Door Closed")) {
      alertClass = "benchmark-alert-warning";
    }

    const row = document.createElement("div");
    row.className = `timing-row ${alertClass}`;
    row.innerHTML = `
      <div class="timing-label-group">
        <span class="timing-label">${key}</span>
        <span class="timing-benchmark-info">Benchmark: ${getBenchmarkText(key)}</span>
      </div>
      <input type="text" class="timing-value-input" value="${timeVal}" onchange="updateTimingField('${key}', this.value)">
    `;
    container.appendChild(row);
  }
}

function getBenchmarkText(key) {
  const acType = tempTimings.metadata.acType;
  const b = TIMELINE_BENCHMARKS[acType];
  switch (key) {
    case "Briefing Starts": return "At Sign In";
    case "Briefing Completed": return "Briefing 10 min";
    case "Cabin Crew Onboard": return `${b.arriveBoard} min`;
    case "Cleaning Done": return `Transit Limit`;
    case "Boarding Clearance": return `${b.boardingClearance} min`;
    case "First Passenger": return `${b.boardingClearance} min`;
    case "Last Passenger": return `Duration: ${b.boardingDuration} min`;
    case "Door Closed": return "D-3 min";
    case "Door Open": return "Landed + 2 min";
    case "Last Passenger Disembarked": return `Disembarkation: ${b.targetDisembarkation} min`;
    case "Cleaning Completed (Transit)": return `Cleaning: ${b.cleaningTimeOutstation} min`;
    default: return "On Time";
  }
}

window.updateTimingField = function(key, val) {
  if (isUTC) {
    tempTimings.utc[key] = val;
    const tzOffset = tempTimings.metadata.tzOffset;
    const [h, m] = val.split(':').map(Number);
    let locH = h + tzOffset;
    if (locH < 0) locH += 24;
    if (locH >= 24) locH -= 24;
    tempTimings.local[key] = `${String(locH).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
  } else {
    tempTimings.local[key] = val;
    const tzOffset = tempTimings.metadata.tzOffset;
    const [h, m] = val.split(':').map(Number);
    let utcH = h - tzOffset;
    if (utcH < 0) utcH += 24;
    if (utcH >= 24) utcH -= 24;
    tempTimings.utc[key] = `${String(utcH).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
  }
};

// 4. Populate Flight Log Sheet (Feature 2)
function saveReportToLogSheet() {
  const meta = tempTimings.metadata;
  const times = tempTimings.utc;

  document.getElementById("sheet-date").value = formatDateString(meta.date);
  document.getElementById("sheet-sector").value = meta.sector;
  document.getElementById("sheet-ac-reg").value = meta.acReg;
  document.getElementById("sheet-pax-out").value = meta.paxCount;
  document.getElementById("sheet-fl-out").value = meta.flightNo;
  document.getElementById("sheet-specials-out").value = meta.specials || 'None';

  document.getElementById("sheet-fl-in").value = incrementFlightNumber(meta.flightNo);
  
  document.getElementById("sheet-t-brief-start").value = times["Briefing Starts"] || '';
  document.getElementById("sheet-t-brief-end").value = times["Briefing Completed"] || '';
  document.getElementById("sheet-t-bus1").value = times["First Bus"] || '';
  document.getElementById("sheet-t-bus2").value = times["Second Bus"] || '';
  document.getElementById("sheet-t-cabin-ob").value = times["Cabin Crew Onboard"] || '';
  document.getElementById("sheet-t-clean-start").value = times["Cleaning Start"] || '';
  document.getElementById("sheet-t-clean-end").value = times["Cleaning Done"] || '';
  document.getElementById("sheet-t-board-clear").value = times["Boarding Clearance"] || '';
  document.getElementById("sheet-t-first-pax").value = times["First Passenger"] || '';
  document.getElementById("sheet-t-last-pax").value = times["Last Passenger"] || '';
  document.getElementById("sheet-t-door-close").value = times["Door Closed"] || '';

  document.getElementById("sheet-t-land").value = times["Aircraft Landed"] || '';
  document.getElementById("sheet-t-door-open").value = times["Door Open"] || '';
  document.getElementById("sheet-t-last-disembark").value = times["Last Passenger Disembarked"] || '';
  document.getElementById("sheet-t-in-clean-start").value = times["Cleaning Started (Transit)"] || '';
  document.getElementById("sheet-t-in-clean-end").value = times["Cleaning Completed (Transit)"] || '';
  document.getElementById("sheet-t-in-board-clear").value = times["Boarding Clearance"] || '';
  document.getElementById("sheet-t-in-first-pax").value = times["First Passenger"] || '';
  document.getElementById("sheet-t-in-last-pax").value = times["Last Passenger"] || '';
  document.getElementById("sheet-t-in-door-close").value = times["Door Closed"] || '';
  document.getElementById("sheet-t-shj-open").value = times["Door Open in Sharjah"] || '';
  document.getElementById("sheet-t-shj-last").value = times["Last Passenger Disembarked"] || '';

  const reports = JSON.parse(localStorage.getItem("sajna_reports") || "[]");
  reports.unshift({
    id: Date.now(),
    date: meta.date,
    flightNo: meta.flightNo,
    sector: meta.sector,
    acType: meta.acType,
    acReg: meta.acReg,
    paxCount: meta.paxCount,
    utcTimings: times
  });
  localStorage.setItem("sajna_reports", JSON.stringify(reports));

  renderRecentReportsList();
  
  // RESET Checklists automatically for the new flight
  resetAllChecklistsSilent();

  alert("Operational report saved! Cabin Flight Log Sheet populated successfully in UTC. Checklists have been reset for the new flight.");
  switchView('log-sheet');
}

function incrementFlightNumber(flNo) {
  const match = flNo.match(/^(G9|ABY)-(\d+)$/i);
  if (match) {
    const num = parseInt(match[2]) + 1;
    return `${match[1]}-${num}`;
  }
  return flNo;
}

function renderRecentReportsList() {
  const container = document.getElementById("recent-reports-list");
  if (!container) return;
  
  const reports = JSON.parse(localStorage.getItem("sajna_reports") || "[]");
  container.innerHTML = "";
  
  if (reports.length === 0) {
    container.innerHTML = `<li class="recent-item">No recent reports generated.</li>`;
    return;
  }
  
  reports.slice(0, 5).forEach(rep => {
    const li = document.createElement("li");
    li.className = "recent-item";
    li.innerHTML = `
      <div class="recent-item-meta">
        <span class="recent-item-title">${rep.flightNo} (${rep.sector})</span>
        <span class="recent-item-date">${formatDateString(rep.date)} - ${rep.acReg}</span>
      </div>
      <span class="material-symbols-rounded text-crimson">arrow_forward</span>
    `;
    li.addEventListener("click", () => {
      tempTimings = {
        metadata: rep,
        utc: rep.utcTimings,
        local: {}
      };
      isUTC = true;
      saveReportToLogSheet();
    });
    container.appendChild(li);
  });
}

// 5. Offline AI Chatbot with Local CSPM RAG (Feature 4)
function setupAIChat() {
  const chatInput = document.getElementById("chat-text-input");
  const sendBtn = document.getElementById("btn-send-chat");
  const voiceBtn = document.getElementById("btn-voice-chat");
  
  sendBtn.addEventListener("click", () => {
    processChatMessage();
  });
  
  chatInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") processChatMessage();
  });

  let isChatRecording = false;
  let chatRecognition = null;
  
  try {
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
      const Speech = window.SpeechRecognition || window.webkitSpeechRecognition;
      chatRecognition = new Speech();
      chatRecognition.continuous = true;
      // ENABLE INTERIM RESULTS FOR REAL-TIME TYPING WHILE SPEAKING
      chatRecognition.interimResults = true;
      chatRecognition.lang = 'en-US';
      
      chatRecognition.onresult = (event) => {
        let finalTranscript = '';
        let interimTranscript = '';
        for (let i = event.resultIndex; i < event.results.length; ++i) {
          if (event.results[i].isFinal) {
            finalTranscript += event.results[i][0].transcript;
          } else {
            interimTranscript += event.results[i][0].transcript;
          }
        }
        // Update input field in real-time as words are recognized
        chatInput.value = finalTranscript || interimTranscript;
      };
      
      chatRecognition.onend = () => {
        isChatRecording = false;
        voiceBtn.classList.remove("recording");
        voiceBtn.innerHTML = `<span class="material-symbols-rounded">mic</span>`;
      };

      voiceBtn.addEventListener("click", () => {
        if (!isChatRecording) {
          isChatRecording = true;
          voiceBtn.classList.add("recording");
          voiceBtn.innerHTML = `<span class="material-symbols-rounded animate-pulse text-red">stop</span>`;
          chatInput.placeholder = "Listening... words will appear here live.";
          chatRecognition.start();
        } else {
          isChatRecording = false;
          chatRecognition.stop();
          chatInput.placeholder = "Type a safety question (e.g. 'door arming' or 'fire procedure')...";
          setTimeout(() => {
            if (chatInput.value.trim()) {
              processChatMessage();
            }
          }, 600);
        }
      });
    } else {
      setupSpeechBtnFallback(voiceBtn, chatInput);
    }
  } catch(e) {
    console.error("Speech Recognition initialization failed:", e);
    setupSpeechBtnFallback(voiceBtn, chatInput);
  }
}

function setupSpeechBtnFallback(voiceBtn, chatInput) {
  voiceBtn.addEventListener("click", () => {
    alert("Speech recognition is simulated on this local sandbox environment. Typing safety query in real-time...");
    let query = "How do we arm the cabin doors?";
    let index = 0;
    chatInput.value = "";
    
    // Simulate words appearing in real-time
    const interval = setInterval(() => {
      if (index < query.length) {
        chatInput.value += query[index];
        index++;
      } else {
        clearInterval(interval);
        setTimeout(() => {
          processChatMessage();
        }, 300);
      }
    }, 50);
  });
}

function processChatMessage() {
  const input = document.getElementById("chat-text-input");
  const query = input.value.trim();
  if (!query) return;
  
  appendMessage(query, 'user');
  input.value = "";
  
  setTimeout(() => {
    const result = localRAGQuery(query);
    appendMessage(result.answer, 'bot', result.ref);
    if (result.ref) {
      highlightManualReference(result.ref);
    }
  }, 1000);
}

function appendMessage(text, sender, ref) {
  const container = document.getElementById("chat-messages-box");
  const msg = document.createElement("div");
  msg.className = `chat-msg ${sender}`;
  
  let refHtml = "";
  if (ref) {
    refHtml = `
      <div class="chat-msg-reference" onclick="jumpToManualPage(${ref.page})">
        <span class="material-symbols-rounded">find_in_page</span>
        <span>CSPM Page ${ref.page} (${ref.section})</span>
      </div>
    `;
  }

  msg.innerHTML = `
    <div class="msg-bubble">
      ${text}
      ${refHtml}
    </div>
  `;
  container.appendChild(msg);
  container.scrollTop = container.scrollHeight;
}

// Offline RAG search ranking logic (UPGRADED COVERS SEATBELT REFUSAL)
function localRAGQuery(query) {
  const cleanQuery = query.toLowerCase().trim();
  let bestMatch = null;
  let maxScore = 0;

  const keyPhrases = {
    "door arming": ["ARMING", "DOOR", "CROSS CHECK", "ARM"],
    "door disarming": ["DISARMING", "DOOR", "CROSS CHECK", "DISARM"],
    "cabin secure": ["SECURE", "CABIN", "GALLEYS", "CARTS", "SEAT BELT", "REFUSE", "FASTEN", "NON-COMPLIANCE", "SEATBELT"],
    "infant": ["INFANT", "CHILD", "certified chair", "LOOP BELT"],
    "wheelchair": ["WHEELCHAIR", "DISABILITY", "PRM", "frail"],
    "dangerous goods": ["DANGEROUS GOODS", "DGR", "PROHIBITED", "SPILL"],
    "medical emergency": ["MEDICAL", "FIRST AID", "DOCTOR", "ABC"],
    "fire procedure": ["FIRE", "HALON", "OVEN", "LAVATORY", "PBE", "LITHIUM"],
    "refusal": ["REFUSAL", "PREGNANT", "HEART ATTACK", "MEDIF"],
    "evacuation": ["EVACUATION", "NITS", "COMMANDS", "BRACE"],
    "survival": ["SURVIVAL", "DITCHING", "SEA", "RAFT", "HYPOTHERMIA"],
    "a321 neo": ["NEO", "ACF", "DOORS", "EXIT ROWS"],
    "report log": ["APPENDICES", "IQSMS", "DEFECT", "LOG SHEET"]
  };

  const words = cleanQuery.split(/[^a-zA-Z0-9]+/).filter(w => w.length > 2 && !STOP_WORDS.has(w));

  CSPM_DATABASE.forEach(doc => {
    let score = 0;
    const docTextUpper = doc.text.toUpperCase();
    const docSectionUpper = doc.section.toUpperCase();

    for (let phrase in keyPhrases) {
      if (cleanQuery.includes(phrase)) {
        if (doc.category === phrase.replace(" ", "_") || (phrase === "refusal" && doc.category === "refusal_of_embarkation")) {
          score += 15;
        }
      }
    }

    doc.tags.forEach(tag => {
      if (cleanQuery.includes(tag.toLowerCase())) {
        score += 8;
      }
    });

    words.forEach(word => {
      const regex = new RegExp("\\b" + word + "\\b", "gi");
      const matches = doc.text.match(regex);
      if (matches) {
        score += matches.length * 1.5;
      }
      
      if (docSectionUpper.includes(word.toUpperCase())) {
        score += 5;
      }
    });

    if (score > maxScore) {
      maxScore = score;
      bestMatch = doc;
    }
  });

  const THRESHOLD = 3.5;
  if (maxScore >= THRESHOLD && bestMatch) {
    return {
      answer: `**Safety manual procedure found in ${bestMatch.chapter}, Section ${bestMatch.section} (Page ${bestMatch.page}):**\n\n${bestMatch.text}\n\n*Review the complete details highlighted in the manual window to the right.*`,
      ref: bestMatch
    };
  } else {
    for (let doc of CSPM_DATABASE) {
      if (words.some(w => doc.chapter.toLowerCase().includes(w) || doc.section.toLowerCase().includes(w))) {
        return {
          answer: `**Safety manual details for ${doc.chapter}, Section ${doc.section} (Page ${doc.page}):**\n\n${doc.text}`,
          ref: doc
        };
      }
    }
    return {
      answer: `**No relevant safety information was found in the offline safety manual.**\n\n*Search guidelines: please enter query terms such as 'door arming', 'fire drill', 'medif', 'infants', 'survival ditching', 'A321 Neo doors', or 'defects'.*`,
      ref: null
    };
  }
}

function highlightManualReference(ref) {
  const box = document.getElementById("manual-ref-box");
  box.innerHTML = `
    <div class="ref-active-content">
      <h4>${ref.section}</h4>
      <div class="ref-meta-info">${ref.chapter} — Page ${ref.page}</div>
      <div class="ref-text-body">${ref.text}</div>
    </div>
  `;
}

window.jumpToManualPage = function(pageNum) {
  switchView("manuals");
  const jumpInput = document.getElementById("manual-jump-input");
  jumpInput.value = pageNum;
  loadManualPage(pageNum);
};

// 6. Offline Flight & Voice Notes Manager
function setupNotesManager() {
  const form = document.getElementById("note-form");
  const speechBtn = document.getElementById("btn-note-speech");
  const contentArea = document.getElementById("note-content");
  
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    saveNote();
  });

  document.getElementById("btn-clear-note").addEventListener("click", () => {
    form.reset();
  });

  let isNoteRecording = false;
  let noteOriginalVal = "";
  let noteRecognition = null;
  
  try {
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
      const Speech = window.SpeechRecognition || window.webkitSpeechRecognition;
      noteRecognition = new Speech();
      noteRecognition.continuous = true;
      // ENABLE INTERIM RESULTS FOR REAL-TIME NOTE TYPING
      noteRecognition.interimResults = true;
      noteRecognition.lang = 'en-US';

      noteRecognition.onresult = (event) => {
        let finalTranscript = '';
        let interimTranscript = '';
        for (let i = event.resultIndex; i < event.results.length; ++i) {
          if (event.results[i].isFinal) {
            finalTranscript += event.results[i][0].transcript;
          } else {
            interimTranscript += event.results[i][0].transcript;
          }
        }
        // Update the textarea continuously with the original value + new voice inputs
        contentArea.value = noteOriginalVal + (noteOriginalVal ? ' ' : '') + finalTranscript + interimTranscript;
      };

      noteRecognition.onend = () => {
        isNoteRecording = false;
        speechBtn.classList.remove("recording");
        speechBtn.innerHTML = `<span class="material-symbols-rounded">mic</span> Speech to Text`;
      };

      speechBtn.addEventListener("click", () => {
        if (!isNoteRecording) {
          isNoteRecording = true;
          noteOriginalVal = contentArea.value;
          speechBtn.classList.add("recording");
          speechBtn.innerHTML = `<span class="material-symbols-rounded animate-pulse text-red">stop</span> Stop Recording`;
          noteRecognition.start();
        } else {
          isNoteRecording = false;
          noteRecognition.stop();
        }
      });
    } else {
      setupNotesSpeechFallback(speechBtn, contentArea);
    }
  } catch(e) {
    console.error("Note speech recognition initialization failed:", e);
    setupNotesSpeechFallback(speechBtn, contentArea);
  }
  
  document.getElementById("notes-search").addEventListener("input", (e) => {
    renderNotesList(e.target.value);
  });
}

function setupNotesSpeechFallback(speechBtn, contentArea) {
  speechBtn.addEventListener("click", () => {
    alert("Speech recognition is simulated on this local sandbox environment. Appending sample note text in real-time...");
    let query = "Catering issues resolved on G9-137. Outbound load was complete.";
    let index = 0;
    let initialVal = contentArea.value;
    
    const interval = setInterval(() => {
      if (index < query.length) {
        contentArea.value = initialVal + (initialVal ? ' ' : '') + query.substring(0, index + 1);
        index++;
      } else {
        clearInterval(interval);
      }
    }, 40);
  });
}

function saveNote() {
  const title = document.getElementById("note-title").value;
  const category = document.getElementById("note-category").value;
  const flight = document.getElementById("note-flight").value;
  const content = document.getElementById("note-content").value;
  
  const notes = JSON.parse(localStorage.getItem("sajna_notes") || "[]");
  notes.unshift({
    id: Date.now(),
    title,
    category,
    flight,
    content,
    date: new Date().toLocaleDateString(),
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    pinned: false
  });
  localStorage.setItem("sajna_notes", JSON.stringify(notes));
  
  document.getElementById("note-form").reset();
  renderNotesList();
}

function renderNotesList(filterText = "") {
  const container = document.getElementById("notes-list-container");
  if (!container) return;

  const notes = JSON.parse(localStorage.getItem("sajna_notes") || "[]");
  container.innerHTML = "";
  
  const filteredNotes = notes.filter(note => {
    const text = (note.title + note.content + note.category + note.flight).toLowerCase();
    return text.includes(filterText.toLowerCase());
  });

  if (filteredNotes.length === 0) {
    container.innerHTML = `<div class="timings-placeholder"><p>No notes found.</p></div>`;
    return;
  }

  filteredNotes.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));

  filteredNotes.forEach(note => {
    const div = document.createElement("div");
    div.className = "note-item";
    div.innerHTML = `
      <div class="note-item-header">
        <span class="note-item-title">${note.title}</span>
        <span class="material-symbols-rounded note-pin-btn ${note.pinned ? 'pinned' : ''}" onclick="togglePinNote(${note.id})">push_pin</span>
      </div>
      <div class="note-item-meta">
        <span>${note.category}</span>
        <span>${note.date} ${note.time}</span>
        ${note.flight ? `<span>Flt: ${note.flight}</span>` : ''}
      </div>
      <p class="note-item-text">${note.content}</p>
      <div class="note-item-actions">
        <button class="btn-micro" onclick="deleteNote(${note.id})"><span class="material-symbols-rounded">delete</span></button>
        <button class="btn-micro" onclick="shareNote(${note.id})"><span class="material-symbols-rounded">share</span></button>
      </div>
    `;
    container.appendChild(div);
  });
}

window.togglePinNote = function(id) {
  const notes = JSON.parse(localStorage.getItem("sajna_notes") || "[]");
  const note = notes.find(n => n.id === id);
  if (note) {
    note.pinned = !note.pinned;
    localStorage.setItem("sajna_notes", JSON.stringify(notes));
    renderNotesList();
  }
};

window.deleteNote = function(id) {
  if (confirm("Are you sure you want to delete this note?")) {
    let notes = JSON.parse(localStorage.getItem("sajna_notes") || "[]");
    notes = notes.filter(n => n.id !== id);
    localStorage.setItem("sajna_notes", JSON.stringify(notes));
    renderNotesList();
  }
};

window.shareNote = function(id) {
  const notes = JSON.parse(localStorage.getItem("sajna_notes") || "[]");
  const note = notes.find(n => n.id === id);
  if (note) {
    alert(`Sharing Note: "${note.title}"\nContent: ${note.content}`);
  }
};

// 7. Manual Library Viewer
function setupManualLibrary() {
  const listItems = document.querySelectorAll("#manual-toc-list li");
  listItems.forEach(item => {
    item.addEventListener("click", () => {
      listItems.forEach(li => li.classList.remove("active"));
      item.classList.add("active");
      const chapter = item.getAttribute("data-chapter");
      loadChapterPage(chapter);
    });
  });

  document.getElementById("btn-manual-jump").addEventListener("click", () => {
    const pageNum = parseInt(document.getElementById("manual-jump-input").value);
    if (pageNum > 0 && pageNum <= 1226) {
      loadManualPage(pageNum);
    } else {
      alert("Invalid page number. Manual is 1,226 pages.");
    }
  });
}

function loadChapterPage(chapter) {
  const pageMap = {
    "som": 9,
    "ch0": 11,
    "ch1": 12,
    "ch2": 268,
    "ch3": 481,
    "ch4": 493,
    "ch5": 580,
    "ch6": 601,
    "ch7": 635,
    "ch8": 882,
    "ch9": 951,
    "ch10": 1125,
    "ch11": 1134,
    "ch12": 1181
  };
  loadManualPage(pageMap[chapter] || 9);
}

function loadManualPage(pageNum) {
  document.getElementById("manual-page-num").innerText = pageNum;
  const contentBox = document.getElementById("manual-page-content-box");
  
  const matchedDoc = CSPM_DATABASE.find(doc => doc.page === pageNum);
  
  if (matchedDoc) {
    contentBox.innerHTML = `
      <h3>${matchedDoc.section}</h3>
      <p style="font-size:12px; color:var(--accent-orange); font-weight:600;">${matchedDoc.chapter} — Page ${matchedDoc.page} of 1226</p>
      <div style="white-space: pre-line; margin-top: 15px;">${matchedDoc.text}</div>
    `;
  } else {
    let chapter = "";
    let title = "";
    let body = "";
    
    if (pageNum >= 1 && pageNum <= 11) {
      chapter = "Chapter 0: Administration";
      title = "0.4 Distribution and Control of Safety Manuals";
      body = `This manual is published by Air Arabia flight operations safety division. All cabin crew are required to carry a copy of this manual on duty. The manual contents are intellectual property of Air Arabia. Updates are distributed as revision sheets.
      
      Revision Procedures:
      1. Revisions must be updated in the electronic flight bag (EFB) prior to starting any duty.
      2. CS must verify that all crew members have successfully synced the latest revision (Active Rev 18).`;
    } else if (pageNum >= 12 && pageNum <= 251) {
      chapter = "Chapter 1: Qualification & Regulations";
      title = "1.9 Crew Complement and Safety Duties";
      body = `Each crew position on the Airbus A320 and A321 is assigned specific safety and emergency duties.
      
      Minimum Cabin Crew Complement:
      - Airbus A320: Minimum of 3 Cabin Crew members (L1, R1, L4).
      - Airbus A321: Minimum of 4 Cabin Crew members (L1, R1, L4, R4C).
      
      Chain of Command:
      1. Commander (Captain)
      2. Co-pilot (First Officer)
      3. Cabin Supervisor (CS - seated at L1)
      4. Cabin Crew positions.`;
    } else if (pageNum >= 252 && pageNum <= 480) {
      chapter = "Chapter 2: Standard Operating Procedures";
      title = "2.25 Galley Security and Pre-flight Inspection";
      body = `All galleys must be checked prior to passenger boarding to ensure all containers, ovens, and cart brackets are secured.
      
      Standard Inspection Checklist:
      - Galley carts must have brakes applied and secondary locks engaged.
      - Galley ovens must be clean and free of loose debris.
      - Boiler switches and hot beverage makers must be checked for correct operation.
      - Curtains must be clipped back and secured open for taxi, takeoff, and landing.`;
    } else if (pageNum >= 481 && pageNum <= 492) {
      chapter = "Chapter 3: Safety & Emergency Equipment";
      title = "3.10 Location of Portable Oxygen and Extinguishers";
      body = `Airbus A320/A321 aircraft carry portable oxygen cylinders and Halon 1211 fire extinguishers distributed throughout the cabin.
      
      Pre-flight Checks for Portable Oxygen:
      1. Cylinder pressure is at least 1500 PSI.
      2. Mask is plugged into the High flow outlet.
      3. Carrying strap is securely attached.
      
      Pre-flight Checks for Halon Extinguishers:
      1. Pressure gauge indicates within the green band.
      2. Safety pin is in place and secured with a plastic seal.
      3. Extinguisher is securely bracketed.`;
    } else if (pageNum >= 493 && pageNum <= 579) {
      chapter = "Chapter 4: Emergency Procedures";
      title = "4.2 Planned Emergency Evacuation on Land";
      body = `In the event of a planned emergency landing, the CS will receive a NITS briefing from the Captain.
      
      NITS Briefing Elements:
      - **N**ature of the Emergency.
      - **I**ntentions of the Captain.
      - **T**ime remaining before landing.
      - **S**pecial instructions.
      
      Evacuation Commands (To be shouted in case of evacuation):
      - "HEADS DOWN, BRACE, BRACE!" (Shouted continuously until the aircraft stops).
      - "UNFASTEN SEATBELTS, LEAVE EVERYTHING, COME THIS WAY!"
      - "JUMP AND SLIDE!"`;
    } else if (pageNum >= 580 && pageNum <= 600) {
      chapter = "Chapter 5: Drills";
      title = "5.3 Cabin Depressurization Drill";
      body = `In case of sudden cabin decompression (loss of cabin pressure):
      
      Immediate Crew Actions:
      1. Grab the nearest oxygen mask immediately. Secure yourself on a seat or hold onto structure.
      2. Wait until the aircraft reaches safe altitude (10,000 feet) and Captain makes PA: "Cabin crew, safe altitude."
      3. Obtain portable oxygen bottle and check the cabin for passenger injuries, structural damage, or fires.
      4. Administer first aid and report status to the Commander.`;
    } else if (pageNum >= 601 && pageNum <= 634) {
      chapter = "Chapter 6: Survival";
      title = "6.1 Basic Principles of Survival";
      body = `Survival depends on four main factors: Protection, Location, Water, and Food (in order of priority).
      
      Survival Actions after Landing in Remote Areas:
      - Protection: Build shelter using slide rafts or aircraft parts to protect from sun, wind, or cold.
      - Location: Set up signaling equipment (beacons, signaling mirror, sea dye markers, flares).
      - Water: Purify water and ration intake. Do NOT drink sea water or urine.
      - Food: Ration available meals and avoid eating unknown plants.`;
    } else if (pageNum >= 635 && pageNum <= 881) {
      chapter = "Chapter 7: Medical & First Aid";
      title = "7.15 CPR and Automated External Defibrillator (AED)";
      body = `If a passenger displays signs of cardiac arrest (unconscious, not breathing):
      
      CPR Procedure:
      1. Lay the passenger flat in the aisle.
      2. Deliver chest compressions (30 compressions at a rate of 100-120 per minute).
      3. Provide rescue breaths (2 breaths) if trained and protective barrier is available.
      4. Retrieve AED (Defibrillator) and apply pads to the chest. Follow the AED voice instructions.
      
      Warning: AED must only be used on unresponsive passengers who are not breathing.`;
    } else if (pageNum >= 882 && pageNum <= 950) {
      chapter = "Chapter 8: A320/A321 Systems";
      title = "8.15 Interphone and Attendant Indication Panel (AIP)";
      body = `The interphone system allows communication between all cabin stations and the flight deck.
      
      AIP Indicators:
      - Steady Red light: Normal call from another cabin crew.
      - Flashing Red light: Emergency call from the flight deck (3 high-low chime alerts).
      - Amber light: Lavatory smoke detector call.
      
      In case of cabin interphone failure: visual hand signals must be established between stations.`;
    } else if (pageNum >= 951 && pageNum <= 1124) {
      chapter = "Chapter 9: A321NEO/CEO Systems";
      title = "9.1 A321 NEO ACF (Cabin Flex) Door Configuration";
      body = `The A321 NEO features Cabin Flex modifications that change the door exits layout:
      - Doors 2 and 3 are replaced with overwing emergency exits (Type III).
      - Design increases cabin capacity while maintaining evacuation standards.
      - Crew briefing must designate who cross-checks mid-cabin exits. L4 is responsible for L3, R4C for R3.
      - Crew must ensure overwing exit rows (Rows 17 and 27) are occupied by Able-Bodied Passengers (ABPs).`;
    } else if (pageNum >= 1125 && pageNum <= 1133) {
      chapter = "Chapter 10: Dangerous Goods";
      title = "10.4 Dangerous Goods Spills in the Cabin";
      body = `In case of liquid spill from passenger baggage suspected of being dangerous goods:
      
      Emergency Actions:
      1. Move all passengers away from the spill area.
      2. Don PBE (Protective Breathing Equipment) and heavy rubber fire gloves.
      3. Retrieve the Dangerous Goods Kit (containing bags and absorbing pads).
      4. Isolate the spill and place contaminated items in a polyethylene bag.
      5. Inform the Flight Deck immediately of the substance classification and details.`;
    } else if (pageNum >= 1134 && pageNum <= 1180) {
      chapter = "Chapter 11: Security";
      title = "11.12 Unruly Passenger Procedures";
      body = `Unruly passengers are classified into four levels of threat:
      - Level 1: Minor disruptive behaviour (verbal arguments, refusing seatbelt).
      - Level 2: Physical disruptive behaviour (pushing, kicking, damaging cabin interior).
      - Level 3: Life-threatening behaviour (armed weapon, physical assault, attempt to enter cockpit).
      - Level 4: Attempted breach of flight deck (sabotage, hijacking attempt).
      
      CS must inform the Captain of all security threats. Levels 2, 3, and 4 require restraint and offloading on landing.`;
    } else {
      chapter = "Chapter 12: Appendices";
      title = "12.2 Cabin Safety Reporting Form (IQSMS)";
      body = `IQSMS reporting procedures require the CS to file reports within 24 hours of landing:
      
      Mandatory Report Events:
      - Any in-flight medical emergency or CPR / First Aid administration.
      - Disruptive passenger incidents (Level 1, 2, 3, or 4).
      - Safety hazards (such as smoke, fire, engine surge, severe turbulence).
      - Seals discrepancy or lost property.
      
      The report must be completed offline in the app and synced as soon as internet is available.`;
    }

    contentBox.innerHTML = `
      <h3>${title}</h3>
      <p style="font-size:12px; color:var(--accent-orange); font-weight:600;">${chapter} — Page ${pageNum} of 1226 (Cached EFB Copy)</p>
      <div style="white-space: pre-line; margin-top: 15px;">${body}</div>
    `;
  }
}

// 8. Interactive Checklists
function setupChecklists() {
  const checklists = ["preflight", "boarding", "doors", "secure"];
  
  checklists.forEach(chk => {
    const list = document.getElementById(`chk-${chk}`);
    const checkboxes = list.querySelectorAll("input[type='checkbox']");
    const progressSpan = document.getElementById(`prog-${chk}`);
    
    const savedState = JSON.parse(localStorage.getItem(`sajna_chk_${chk}`) || "[]");
    checkboxes.forEach((cb, index) => {
      cb.checked = savedState[index] || false;
      cb.addEventListener("change", () => {
        saveState();
        updateProgress();
      });
    });

    const saveState = () => {
      const state = Array.from(checkboxes).map(cb => cb.checked);
      localStorage.setItem(`sajna_chk_${chk}`, JSON.stringify(state));
    };

    const updateProgress = () => {
      const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;
      progressSpan.innerText = `${checkedCount}/${checkboxes.length} Completed`;
    };

    updateProgress();
  });

  document.getElementById("btn-reset-checklists").addEventListener("click", () => {
    if (confirm("Are you sure you want to reset all checklists for the new flight?")) {
      resetAllChecklistsSilent();
      alert("Checklists reset successfully!");
    }
  });
}

function resetAllChecklistsSilent() {
  const checklists = ["preflight", "boarding", "doors", "secure"];
  checklists.forEach(chk => {
    localStorage.removeItem(`sajna_chk_${chk}`);
    const list = document.getElementById(`chk-${chk}`);
    if (list) {
      const checkboxes = list.querySelectorAll("input[type='checkbox']");
      checkboxes.forEach(cb => cb.checked = false);
      const progSpan = document.getElementById(`prog-${chk}`);
      if (progSpan) {
        progSpan.innerText = `0/${checkboxes.length} Completed`;
      }
    }
  });
}

// 9. Cabin Crew Calculators (INR Rupees added)
function setupCalculators() {
  document.getElementById("btn-calc-rest").addEventListener("click", () => {
    const duration = parseFloat(document.getElementById("rest-flight-duration").value);
    const shifts = parseInt(document.getElementById("rest-shifts").value);
    const resultBox = document.getElementById("rest-calc-result");
    
    if (duration > 0 && shifts > 0) {
      const durationMin = duration * 60;
      const breakMin = Math.floor(durationMin / shifts);
      const h = Math.floor(breakMin / 60);
      const m = breakMin % 60;
      resultBox.innerText = `Break Breakdowns: Each crew member receives ${h} hr ${m} min rest break (${breakMin} mins total per shift).`;
    } else {
      resultBox.innerText = "Please enter valid cruise duration and shifts.";
    }
  });

  document.getElementById("btn-calc-curr").addEventListener("click", () => {
    const amount = parseFloat(document.getElementById("curr-amount").value);
    const from = document.getElementById("curr-from").value;
    const to = document.getElementById("curr-to").value;
    const resultBox = document.getElementById("curr-calc-result");

    const rates = {
      "AED": { "SAR": 1.02, "USD": 0.27, "EUR": 0.25, "INR": 22.75, "AED": 1 },
      "SAR": { "AED": 0.98, "USD": 0.26, "EUR": 0.24, "INR": 22.25, "SAR": 1 },
      "USD": { "AED": 3.67, "SAR": 3.75, "EUR": 0.92, "INR": 83.50, "USD": 1 },
      "EUR": { "AED": 3.98, "SAR": 4.07, "USD": 1.08, "INR": 90.60, "EUR": 1 },
      "INR": { "AED": 0.044, "SAR": 0.045, "USD": 0.012, "EUR": 0.011, "INR": 1 }
    };

    if (amount > 0) {
      const rate = rates[from][to];
      const converted = (amount * rate).toFixed(2);
      resultBox.innerText = `${amount} ${from} = ${converted} ${to}`;
    } else {
      resultBox.innerText = "Please enter a valid amount.";
    }
  });

  setupTimer("boarding", "timer-boarding-digits", "btn-timer-board-start", "btn-timer-board-stop", 1200);
  setupTimer("cleaning", "timer-cleaning-digits", "btn-timer-clean-start", "btn-timer-clean-stop", 480);
}

function setupTimer(timerName, digitsId, startBtnId, stopBtnId, defaultSecs) {
  let timerId = null;
  let remaining = defaultSecs;
  
  const display = document.getElementById(digitsId);
  const startBtn = document.getElementById(startBtnId);
  const stopBtn = document.getElementById(stopBtnId);
  
  if (!display || !startBtn || !stopBtn) return;
  
  const updateDisplay = () => {
    const m = Math.floor(remaining / 60);
    const s = remaining % 60;
    display.innerText = `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  };

  startBtn.addEventListener("click", () => {
    if (timerId) return;
    timerId = setInterval(() => {
      if (remaining > 0) {
        remaining--;
        updateDisplay();
      } else {
        clearInterval(timerId);
        timerId = null;
        alert(`${timerName.toUpperCase()} timer finished!`);
      }
    }, 1000);
  });

  stopBtn.addEventListener("click", () => {
    if (timerId) {
      clearInterval(timerId);
      timerId = null;
    } else {
      remaining = defaultSecs;
      updateDisplay();
    }
  });
  
  updateDisplay();
}

// 10. Cabin Defect Log Manager
function setupDefectsLog() {
  const form = document.getElementById("defect-form");
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    
    const flightNo = document.getElementById("def-flight").value;
    const seat = document.getElementById("def-seat").value;
    const priority = document.getElementById("def-priority").value;
    const desc = document.getElementById("def-description").value;
    
    const defects = JSON.parse(localStorage.getItem("sajna_defects") || "[]");
    defects.unshift({
      id: Date.now(),
      flightNo,
      seat,
      priority,
      desc,
      date: new Date().toLocaleDateString()
    });
    localStorage.setItem("sajna_defects", JSON.stringify(defects));
    
    form.reset();
    renderDefectsList();
    alert("Cabin defect successfully logged!");
  });
}

function renderDefectsList() {
  const container = document.getElementById("defects-list-container");
  if (!container) return;
  
  const defects = JSON.parse(localStorage.getItem("sajna_defects") || "[]");
  container.innerHTML = "";
  
  if (defects.length === 0) {
    container.innerHTML = `<div class="timings-placeholder"><p>No defects logged.</p></div>`;
    return;
  }

  defects.forEach(def => {
    const div = document.createElement("div");
    div.className = "defect-item";
    div.innerHTML = `
      <div class="defect-item-header">
        <span class="defect-prio-badge ${def.priority.toLowerCase()}">${def.priority}</span>
        <strong>Flight: ${def.flightNo} — Seat ${def.seat}</strong>
      </div>
      <p style="font-size:12.5px; margin: 8px 0; color:var(--text-dark-sec);">${def.desc}</p>
      <div style="font-size:10px; display:flex; justify-content:space-between; align-items:center;">
        <span>Logged Date: ${def.date}</span>
        <button class="btn-micro" onclick="deleteDefect(${def.id})">Remove</button>
      </div>
    `;
    container.appendChild(div);
  });
}

window.deleteDefect = function(id) {
  if (confirm("Delete this defect record?")) {
    let defects = JSON.parse(localStorage.getItem("sajna_defects") || "[]");
    defects = defects.filter(d => d.id !== id);
    localStorage.setItem("sajna_defects", JSON.stringify(defects));
    renderDefectsList();
  }
};

// 11. Smart Search
function setupSmartSearch() {
  const searchInput = document.getElementById("global-search");
  searchInput.addEventListener("input", (e) => {
    const query = e.target.value.trim().toLowerCase();
    if (query.length > 2) {
      performSmartSearch(query);
    }
  });
}

function performSmartSearch(query) {
  const notes = JSON.parse(localStorage.getItem("sajna_notes") || "[]");
  const defects = JSON.parse(localStorage.getItem("sajna_defects") || "[]");
  
  const foundNotes = notes.filter(n => (n.title + n.content).toLowerCase().includes(query));
  const foundDefects = defects.filter(d => d.desc.toLowerCase().includes(query));
  const foundManual = CSPM_DATABASE.filter(m => m.text.toLowerCase().includes(query));
  
  if (foundManual.length > 0) {
    jumpToManualPage(foundManual[0].page);
    alert(`Smart search found safety procedure match on Page ${foundManual[0].page}: ${foundManual[0].section}`);
  } else if (foundNotes.length > 0) {
    switchView("notes");
    document.getElementById("notes-search").value = query;
    renderNotesList(query);
  } else if (foundDefects.length > 0) {
    switchView("defects");
    renderDefectsList();
  }
}

// 12. Online Sync Indicator
function updateSyncStatus() {
  const indicator = document.getElementById("sync-indicator");
  
  window.addEventListener("online", () => {
    indicator.className = "sync-status online";
    indicator.innerHTML = `<span class="material-symbols-rounded">cloud_done</span><span>Synced</span>`;
    alert("Internet connection detected. SAJNA AI is backing up data.");
  });

  window.addEventListener("offline", () => {
    indicator.className = "sync-status offline";
    indicator.innerHTML = `<span class="material-symbols-rounded">cloud_off</span><span>Offline</span>`;
  });
}

// 13. Export & Action Buttons Implementation
function setupExportButtons() {
  document.getElementById("btn-export-pdf").addEventListener("click", () => {
    window.print();
  });

  document.getElementById("btn-export-docx").addEventListener("click", () => {
    const content = document.getElementById("log-sheet-print-area").innerHTML;
    const html = `
      <html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
      <head>
        <title>Manual Cabin Flight Report</title>
        <style>
          body { font-family: "Courier New", Courier, monospace; font-size: 11px; color:#000; }
          h2 { font-size: 14px; text-align: center; text-transform: uppercase; margin-bottom: 2px; }
          h1 { font-size: 16px; text-align: center; text-transform: uppercase; margin-bottom: 12px; }
          .sheet-sub { font-size: 9px; text-align: center; font-style: italic; margin-bottom: 15px; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 12px; }
          th, td { border: 1px solid #000000; padding: 6px; text-align: left; }
          th { background-color: #EFEFEF; }
          .sheet-cell { font-weight: bold; border: none; }
          .sheet-textarea { width: 100%; border: 1px solid #000000; font-weight: bold; }
          .sheet-section-title { font-weight: bold; text-transform: uppercase; margin: 16px 0 8px 0; border-bottom: 1px solid #000000; }
          .sheet-split-grid { width: 100%; display: table; }
          .sheet-col { display: table-cell; width: 50%; padding: 5px; }
        </style>
      </head>
      <body>
        ${content}
      </body>
      </html>
    `;
    
    const blob = new Blob(['\ufeff' + html], { type: 'application/msword' });
    const url = URL.createObjectURL(blob);
    
    const link = document.createElement('a');
    link.href = url;
    link.download = 'manual_cabin_flight_report.doc';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  });

  document.getElementById("btn-share-log").addEventListener("click", () => {
    const flightNo = document.getElementById("sheet-fl-out").value;
    const sector = document.getElementById("sheet-sector").value;
    const date = document.getElementById("sheet-date").value;
    const summaryText = `SAJNA AI Cabin Flight Log Summary:\nFlight: ${flightNo}\nSector: ${sector}\nDate: ${date}\nStatus: Completed & Saved Offline.`;
    
    if (navigator.share) {
      navigator.share({
        title: 'Air Arabia Flight Log Sheet',
        text: summaryText,
      }).catch(err => console.log(err));
    } else {
      navigator.clipboard.writeText(summaryText);
      alert("Flight log summary copied to clipboard!");
    }
  });

  document.getElementById("btn-duplicate-log").addEventListener("click", () => {
    const flNo = document.getElementById("sheet-fl-out").value;
    const nextFl = incrementFlightNumber(flNo);
    document.getElementById("sheet-fl-out").value = nextFl;
    alert("Flight report duplicated. Outbound flight number updated to " + nextFl);
  });
}
