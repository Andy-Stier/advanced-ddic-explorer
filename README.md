# Advanced DDIC Explorer for SAP (ABAP 7.40 SP08+)

### SAP Metadata & Impact Analysis Platform
*Explore. Understand. Document.*

![Advanced DDIC Explorer User Interface](Overview.png)

## Why Advanced DDIC Explorer?
* 🎯SAP standard tools provide technical information.
* 💎Advanced DDIC Explorer helps developers understand dependencies, generate documentation, and analyze the impact of changes before implementation.

## Community Edition
* **DDIC Dashboard**
* **Header & Attributes**
* **Fields**
* **Text Table**
* **Check Tables**
* **Indexes**
* **Search Helps**
* **Full Search & Filter**

### Installation & Deployment

You can install the **Advanced DDIC Explorer** either as a classic single-file report or automate it completely via **abapGit**.

#### Option A: Automated Installation via abapGit (Recommended)
1. Open the **abapGit** developer tool in your SAP system.
2. Click on **+ Online** to create a new online repository.
3. Paste the URL of this GitHub repository: `https://github.com/Andy-Stier/advanced-ddic-explorer.git`
4. Specify your target package (e.g., `$Z_DDIC_EXPLORER`) and folder logic.
5. Click **Clone Repository**, then select **Pull** to automatically deploy and activate the code in your system.

#### Option B: Classic Single-File Copy-Paste
1. Open your SAP system and go to transaction `SE38` or `SE80`.
2. Create a new executable program (e.g., `Z_DDIC_EXPLORER`).
3. Open the file `src/zasc_ddic_explorer_free.prog.abap` from this repository and copy the entire source code.
4. Paste the code into your SAP report, activate it (`Ctrl+F3`), and run it (`F8`).

*Baseline Compatibility: 100% compatible down to ABAP 7.40 and fully S/4HANA-ready!*

## Professional Modules
Advanced capabilities are available as optional commercial modules.
* **HTML Documentation**
* **Impact Analysis**
* **More modules are currently under development**

|Module |	Status |
| :---| :--- |
| **HTML Documentation** |	✅ Available|
| **Impact Analysis** |	✅ Available|
| **SQL Builder** |	🚧 Planned, 2026|
| **OData Metadata Generator** |	🚧 Planned, 2026|
| **SuccessFactors OData Explorer** |	🚧 Planned, 2027 |

---

## 📺 Video Documentation & Step-by-Step Manuals

To make your onboarding seamless and show the engine in action under real-world corporate conditions, we provide a high-quality technical video series. No boring slides, no corporate fluff - just pure SAP GUI screen recordings guiding you through every advanced feature of the tool.

▶️ **[Access the Official YouTube Channel & Watch All Manuals](https://www.youtube.com/@Andy-Stier)**

*Feel free to subscribe to the channel to never miss upcoming technical upgrades and release notes! 🔔*

---
## Contact via E-Mail: advanced.abap.software@gmail.com
---

## License
The Community version of this software is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the base version within your corporate landscape.
