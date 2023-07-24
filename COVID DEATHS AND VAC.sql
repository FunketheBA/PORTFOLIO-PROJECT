
Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].[dbo].[CovidDeathsN] 
Where continent is not null 
order by 1,2





SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS DeathPercentage
FROM 
     [Portfolio Project].[dbo].[CovidDeathsN] 
WHERE 
    location LIKE '%Africa%'
ORDER BY 
    location, date;

--Total cases Vs Population  
SELECT 
    location,
    date, Population
    total_cases,
    (CAST(Total_cases AS float) / CAST(Population AS float)) * 100 AS DeathPercentage
FROM 
    CovidDeathsN
WHERE 
    location LIKE '%Africa%'
ORDER BY 
    location, date;


-- Countries with Highest infection Rate Compared to Population
Select Location,Population,Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
From  [Portfolio Project].[dbo].[CovidDeathsN] 

Group by Location,Population
order by location,Population


--Countries with highest deathcount Per Population  
Select Location, MAX(Total_deaths) as TotalDeathCount
From  [Portfolio Project].[dbo].[CovidDeathsN] 
Where continent is not null
Group by location
Order by TotalDeathCount desc    


-- Continents with the highest death count per Population  
Select continent, max(cast(total_deaths as float)) as TotalDeathCount
From  [Portfolio Project].[dbo].[CovidDeathsN]  
where continent is not null 
Group by continent 
orderby TotalDeathCount desc   


SELECT
    continent,
    MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM
   [Portfolio Project].[dbo].[CovidDeathsN]

WHERE
    continent IS NOT NULL
GROUP BY
    continent
ORDER BY
    TotalDeathCount DESC; 

	--SHOWING TOTAL POPULATIONS VS VACCINATIONS

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM (CAST(vac.new_vaccinations as float)) Over(Partition by dea.location) as RollingPeopleVaccinated
From [Portfolio Project].[dbo].[CovidDeathsN] dea
JOIN [Portfolio Project].[dbo].[CovidVascineN] vac
ON dea.location=vac.location
and dea.date=vac.date  
where dea.continent is not null 
order by 2,3  

--Using CTE  TO PERFORM PARTITION
 
 WITH PopVsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated) AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location) as RollingPeopleVaccinated
    FROM
        [Portfolio Project].[dbo].[CovidDeathsN] dea
    JOIN
        [Portfolio Project].[dbo].[CovidVascineN] vac
    ON
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)
SELECT
    Continent,
    Location,
    Date,
    Population,
    New_vaccinations,
    RollingPeopleVaccinated
FROM
    PopVsVac;
