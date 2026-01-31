
SELECT * FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
order by 3, 4


-- Selection of data that we will be using 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
ORDER BY 1,2


-- Total cases & total deaths
-- The likelihood of dying from Covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Croatia%'
AND CONTINENT IS NOT NULL
ORDER BY 1,2
 

 -- Total cases VS Population
 -- Percentage of population infected by Covid
SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS InfectionPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Croatia%'
AND CONTINENT IS NOT NULL
ORDER BY 1,2


-- Countries with the Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS InfectionPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY LOCATION, population
ORDER BY InfectionPercentage DESC


-- ANALYZING THE DATA BY CONTINENTS


-- Highest Death Count per Population
SELECT location, max(cast(Total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NULL
GROUP BY location
ORDER BY TotalDeaths DESC


SELECT continent, max(cast(Total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC


-- Continents with the highest death count per population
SELECT location, max(cast(Total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NULL
GROUP BY location
ORDER BY TotalDeaths DESC


-- GLOBAL NUMBERS


-- The number of total cases, deaths per day since the start of the pandemic
SELECT date, SUM(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1,2


-- Total Population VS  Vaccinations


WITH PopVsVac
(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT))
            OVER (PARTITION BY dea.location ORDER BY dea.date)
            AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
	--ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopVsVac;


-- TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT))
            OVER (PARTITION BY dea.location ORDER BY dea.date)
            AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
	--order by 2, 3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- Views to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS

SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT))
            OVER (PARTITION BY dea.location ORDER BY dea.date)
            AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
	--order by 2, 3

SELECT * FROM PercentPopulationVaccinated

CREATE VIEW dbo.vw_CovidDeaths_Clean AS
SELECT
    location,
    date,
    continent,
    population,
    total_cases,
    new_cases,
    total_deaths,
    new_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL;

