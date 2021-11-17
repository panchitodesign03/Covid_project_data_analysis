--1
/*Query for global death percentage*/
/*Add up all the cases in new_cases column to find total cases. Do the same to new_deaths to find total deaths.*/
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	/*Divide total cases by total deaths to find the global death percentage*/
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_project..CovidDeaths
where continent is not null 
order by 1,2

--2
Select location, sum(cast(new_deaths as int)) as TotalDeathCount
From Covid_project..CovidDeaths
Where continent is null 
and location not in('World', 'European Union', 'International', 'Income')
and location not like '%income%'
Group by location
order by TotalDeathCount desc

--3
/*Percentage of population infected by location in areas with high population and infection rates.*/
Select Location, Population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentPopulationInfected
From Covid_project..CovidDeaths
group by location, population
order by PercentPopulationInfected desc

--4
/*Percentage of population infected by date and location.
---- Shows what percentage of population infected with Covid
*/
Select Location, Population, Date, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentPopulationInfected
From Covid_project..CovidDeaths
group by Location, Population, date
order by PercentPopulationInfected desc