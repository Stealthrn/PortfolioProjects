Select *
From PortfolioProjects..CovidDeaths
where continent is not null
order by 3,4

Select *
From PortfolioProjects..CovidVaccinations
order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2


--Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths,  (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
From PortfolioProjects..CovidDeaths
Where location like '%United Kingdom%'
and continent is not null
order by 1,2



-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPoulationInfected
From PortfolioProjects..CovidDeaths
Where location like '%United Kingdom%'
and continent is not null
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(CONVERT(float, total_cases)) AS HighestInfectionCount, MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPoulationInfected
From PortfolioProjects..CovidDeaths
Where location like '%United Kingdom%'
and continent is not null
Group by Location, population
order by PercentPoulationInfected desc


--Showing Countries with Highest Death Count per Population

Select Location, MAX(CONVERT(float, Total_deaths)) AS TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%United Kingdom%'
where continent is not null
Group by Location, population
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(CONVERT(float, Total_deaths)) AS TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%United Kingdom%'
where continent is not null 
Group by continent
order by TotalDeathCount desc



-- Showing continents with the highest detah count per population

Select continent, MAX(CONVERT(float, Total_deaths)) AS TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%United Kingdom%'
where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select  NULLIF(SUM(new_cases),0) AS total_cases, NULLIF(SUM(new_deaths),0) as total_deaths, NULLIF(SUM(new_deaths),0)/NULLIF(SUM(new_cases),0)*100 AS DeathPercentage
From PortfolioProjects..CovidDeaths
--Where location like '%United Kingdom%'
Where continent is not null
--Group by date
order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



--USE CTE

With PopvsVac(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





--Creating View to store data for later visualisations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


