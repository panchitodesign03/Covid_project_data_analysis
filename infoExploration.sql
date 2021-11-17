/*An exploration of a world covid data set that includes vaccinations and deaths.*/

---- Checking to see if covid death data loaded correctly
select *
from Covid_project..covidDeaths
order by 3,4

/*View created to present all of the death data.*/
--Create View covidDeathDataView as
--select *
--from Covid_project..covidDeaths

--- Checking to see if the covid vaccination data loaded correctly.
select * 
from Covid_project..covidVaccinations
order by 3,4

/*Creating a view for covid vaccination data*/
--create view covidVaccinationDataView as
--select * 
--from Covid_project..covidVaccinations



---- Data we will start with
Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_project..CovidDeaths
Where continent is not null 
order by 1,2

/*A view of the data we will start with*/
--create view startingDataView as 
--Select Location, date, total_cases, new_cases, total_deaths, population
--From Covid_project..CovidDeaths
--Where continent is not null 


---- Total Cases vs Total Deaths
---- It shows the likeliehood of dying by percentage
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Covid_project..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2

/*View for total cases vs total deaths*/
--create view  totalCasesVsTotalDeaths as
--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From Covid_project..CovidDeaths
--Where location like '%states%'
--and continent is not null


/*Total Cases vs Population
---- Shows what percentage of population infected with Covid
*/
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From Covid_project..CovidDeaths
--Where location like '%states%'
order by 1,2
/*creating a view of this query*/

/*View for Total Cases vs population*/
--create view totalCasesVsPopulation as
--Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
--From Covid_project..CovidDeaths



/*******************************************************************************/
---- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_project..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

/**View for counties with highest infection rate compared to population*/
--create view infectionRatebyCountriesView as
--Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
--From Covid_project..CovidDeaths
--Group by Location, Population


---- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount, MAX(population) as MaxPopulationCount
From Covid_project..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

/*Creating view for highest death count per population*/
--create view  HighestDeathCountView as
--Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount, MAX(population) as MaxPopulationCount
--From Covid_project..CovidDeaths
----Where location like '%states%'
--Where continent is not null 
--Group by Location



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount, MAX(population) as MaxPopulationCount
From Covid_project..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


/*View for highest death count per pupulation broken down by continent*/
--create view highestDeathCountbyContinetView as
--Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount, MAX(population) as MaxPopulationCount
--From Covid_project..CovidDeaths
--Where continent is not null 
--Group by continent


---- GLOBAL NUMBERS
/*Add up all the cases in new_cases column to find total cases. Do the same to new_deaths to find total deaths.*/
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	/*Divide total cases by total deaths to find the global death percentage*/
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_project..CovidDeaths
where continent is not null 
Group By date
order by 1,2

/*View for global death percentage*/
--create view globalDeathPercentageView as
--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
--	/*Divide total cases by total deaths to find the global death percentage*/
--	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From Covid_project..CovidDeaths
--where continent is not null 
--Group by date



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

---using Comman Table Expression to perform calculation on partition by in previous query. Allows you to manipulate information further after query
with PopvsVac(Continent, Location,Date, Population, new_vaccinations, rollingPeopleVaccinated) as
(
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
	sum(cast(vaccine.new_vaccinations as bigint)) OVER (partition by death.location order by death.location, death.date) as rollingPeopleVaccinated/*will use this to find percentage of people vaccinated per population*/
	--(rollingPeopleVaccinated/population)*100
from Covid_project..covidDeaths death
join Covid_project..covidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null

)
select *, (rollingPeopleVaccinated/Population)* 100 from PopvsVac


-- Creating a view to store data for later visualiztion

--Create View PercentPopulationVaccinated as
--Select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
--, SUM(CONVERT(int,vaccine.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as rollingPeopleVaccinated
--From Covid_project..CovidDeaths death
--Join Covid_project..CovidVaccinations vaccine
--	On death.location = vaccine.location
--	and death.date = vaccine.date 
--where death.continent is not null 


