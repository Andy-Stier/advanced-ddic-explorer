# 🚀 Advanced DDIC Explorer for SAP (ABAP 7.40+)
![Advanced DDIC Explorer User Interface](screenshot.png)
*The Image shows the PRO version user interface with advanced relationship analytics (check tables, indices, search helps)*

Tired of the endless window-switching and click-marathons in standard SAP `SE11`? This tool is a modern, high-productivity dictionary viewer designed right inside the SAP GUI using a clean, native ALV layout.

Analyze structures, text tables, active database indices, and search helps for an UNLIMITED number of DDIC objects simultaneously. Fully optimized for modern SAP S/4HANA environments (e.g., complex objects like Central Business Partner `BUT000`).

---

## 💡 Free vs. Pro Feature Matrix


| Feature                                                               | FREE Version (Open Source) | PRO Version (Commercial) |
| :---| :---: | :---: |
| 🎯**Unlimited Bulk Query** (Multiple tables at once)                  | ✅                         | ✅                      |
| 🎯**ALV Interface** (Modern layout)                                   | ✅                         | ✅                      |
| 🎯**Smart Filtering** (By category, delivery class, Z/Y objects)      | ✅                         | ✅                      |
| 🎯**Wildcard Text Search** (Utilizing ABAP `CP` operator on `DD02T`)  | ✅                         | ✅                      |
| 🎯**Smart Multi-Language Support** (Language-independent)             | ✅                         | ✅                      |
| 💎**Check Table Analyzer** (Foreign-key mapping)                      | ❌                         | ✅                      | 
| 💎**Active DB Indices & Search Helps** (Performance tuning)           | ❌                         | ✅                      |
| 💎**Fiori-Style HTML Export** *(Coming soon / Free Upgrade)*          | ❌                         | ✅                      |
| 💎**Technical Support & 12 Months Updates**                           | ❌                         | ✅                      |

---

## ⚡ Installation & Deployment

You can install the **Advanced DDIC Explorer** either as a classic single-file report or automate it completely via **abapGit**.

### Option A: Automated Installation via abapGit (Recommended)
1. Open the **abapGit** developer tool in your SAP system.
2. Click on **+ Online** to create a new online repository.
3. Paste the URL of this GitHub repository: `https://github.com/Andy-Stier/advanced-ddic-explorer.git`
4. Specify your target package (e.g., `$Z_DDIC_EXPLORER`) and folder logic.
5. Click **Clone Repository**, then select **Pull** to automatically deploy and activate the code in your system.

### Option B: Classic Single-File Copy-Paste
1. Open your SAP system and go to transaction `SE38` or `SE80`.
2. Create a new executable program (e.g., `Z_ADVANCED_DDIC_EXPLORER`).
3. Open the file `src/zasc_ddic_explorer_free.prog.abap` from this repository and copy the entire source code.
4. Paste the code into your SAP report, activate it (`Ctrl+F3`), and run it (`F8`).

*Baseline Compatibility: 100% compatible down to ABAP 7.40 and fully S/4HANA-ready!*

---

## 💎 Commercial Licensing & Support

The **PRO Version** unlocks deep architectural insights and database performance tuning parameters with a single click. All commercial licenses include **12 months of free updates** (including the upcoming Fiori-Style HTML Export upgrade) and technical support.

🔥 **BONUS ROADMAP VALUE:** The upcoming **Fiori-Style HTML Export upgrade** (launching in 1–3 months) is fully included in your 12-month update window. Buy today, and receive the HTML Export feature as a **FREE automatic update** later!

| Licence | Price | Benefit |
| :--- | ---: | :---|
|**Pro Single User:**| €99.00 | - |
|**Pro Small Team** (Up to 5 developers)| €399.00  | *Get 5 licences for the price of 4!*|
|**Pro Large Team** (Up to 10 developers)| €699.00  | *Save nearly 30%* |
|**Enterprise Site License:**| Custom pricing | *up for negotiable* |

### ⏱️ 1-HOUR FLASH SALE ON WEDNESDAY (MAY 27)
To celebrate the global rollout, I am running an exclusive **60-minute Flash Sale this Wednesday**! You can grab the full PRO Single License for just **€9.99** instead of €99.

* 🌅 **Wave 1 (Europe / Asien):** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**10:00 - 11:00** CEST
* 🏙️ **Wave 2 (Americas / Global):** **16:00 - 17:00** CEST (<ins>New York Time: **10:00 - 11:00**</ins>)

👉 **[LINK TO LEMON SQUEEZY STORE WILL BE PLACED HERE ON WEDNESDAY]**

---

## 📄 License
The Free version of this software is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the base version within your corporate landscape.
