# COVID-19 Data Exploration using SQL Server

This project focuses on exploratory data analysis of global COVID-19 data using **SQL Server**.  
The goal is to analyze infections, deaths, and vaccination trends using advanced SQL techniques
such as **CTEs, window functions, temporary tables, and views**, and to prepare clean datasets
for data visualization tools like Power BI or Tableau.

---

## 📊 Dataset
The analysis is based on two datasets:
- **CovidDeaths** – daily COVID-19 cases, deaths, and population data
- **CovidVaccinations** – daily vaccination statistics by country

---

## 🛠️ Technologies & Skills Used
- **SQL Server**
- **T-SQL**
- Common Table Expressions (CTEs)
- Window Functions (`OVER`, `PARTITION BY`)
- Temporary Tables
- SQL Views
- Data Aggregation & Filtering
- Data Cleaning
- Analytical Queries

---

## 🔍 Key Analyses Performed

### 1. General Data Exploration
- Filtering valid country-level records
- Selecting core fields used for analysis

### 2. COVID-19 Mortality Analysis
- Death percentage per country and date
- Likelihood of dying after infection
- Comparison between countries

### 3. Infection Rate Analysis
- Percentage of population infected
- Countries with the highest infection rate

### 4. Continent-Level & Global Analysis
- Death counts by continent
- Global daily cases and deaths
- Global death percentage over time

### 5. Vaccination Analysis
- Rolling (cumulative) number of vaccinated people per country
- Percentage of population vaccinated
- Use of window functions for time-based calculations

---

## 🧠 SQL Concepts Demonstrated

- **CTE (Common Table Expressions)**  
  Used to improve query readability and structure complex calculations.

- **Window Functions**  
  Rolling vaccination totals calculated using `SUM() OVER (PARTITION BY … ORDER BY …)`.

- **Temporary Tables**  
  Used as an alternative approach to store intermediate results.

- **Views**  
  Created reusable, clean datasets for visualization and further analysis.

---

## 📁 Views Created for Visualization

| View Name | Description |
|---------|------------|
| `vw_CovidDeaths_Clean` | Cleaned base dataset |
| `vw_DeathPercentage` | Death percentage by country and date |
| `vw_GlobalNumbers` | Global daily cases and deaths |
| `vw_PopulationVsVaccination` | Rolling vaccination numbers |
| `vw_PercentPopulationVaccinated` | Percentage of population vaccinated |

---

## 📈 Example Query
```sql
SELECT
    location,
    MAX(PercentPopulationVaccinated) AS VaccinationRate
FROM dbo.vw_PercentPopulationVaccinated
GROUP BY location
ORDER BY VaccinationRate DESC;
