SELECT * FROM project12.cd order by 3,4;
SELECT * FROM project12.cvv order by 3,4;
-- Data that will be in focoused--
select date, Location, total_cases, new_cases, total_deaths, population FROM project12.cd where continent != '' order by 2,1;

-- total cases vs total Population (for India) --
select Location, date, population, total_cases, (total_cases/population)*100 as Percentage_of_case 
FROM project12.cd where location like 'India' and continent != '' order by 1;

-- total_cases vs total_deaths (for India) --
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Percentage_of_death 
FROM project12.cd where location like 'India' and continent != '' order by 1;


-- Infection rate compared to population (country-wise)--
select Location, population, max(total_cases) as most_country_case, max(total_cases/population)*100 as Possibilty_of_case 
FROM project12.cd  where continent != '' group by Location, population order by Possibilty_of_case desc;

-- country with more death compared to population --
select Location, population, max(cast(total_deaths as UNSIGNED)) as count_total_death 
FROM project12.cd where continent != '' group by Location order by 3 desc;

-- By continent, death compared to population--
select Continent, population, max(cast(total_deaths as UNSIGNED)) as count_total_death 
FROM project12.cd where continent != '' group by Continent order by 3 desc;

-- Global wise data--
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as UNSIGNED)) as total_no_deaths, 
sum(cast(new_deaths as unsigned))/sum(new_cases)*100 as Death_percentage FROM project12.cd  where continent != ''
group by date ORDER BY 2;

-- Total data --
select sum(cast(total_deaths as UNSIGNED)) as deaths_total, sum(total_cases) as case_total, 
(((sum(cast(total_deaths as UNSIGNED))/sum(total_cases))*100)) as case_per_death FROM project12.cd where continent != '' 
group by date order by 2;

-- Vaccination--

with vacpopu (continent, location, date, population, new_vaccinations, commulative_vaccination) as 
(select dc.continent, dc.location, dc.date, dc.population, vc.new_vaccinations, sum(vc.new_vaccinations) 
over(partition by dc.location order by dc.location, dc.date) as commulative_vaccination from project12.cvv vc join project12.cd dc
 on vc.location=dc.location and vc.date=dc.date where dc.continent !='') 
 select *, (commulative_vaccination/population)*100 from vacpopu;
 
 -- View Created --
 
 create view vaccipopu as
 select dc.continent, dc.location, dc.date, dc.population, vc.new_vaccinations, sum(vc.new_vaccinations) 
over(partition by dc.location order by dc.location, dc.date) as commulative_vaccination  from project12.cvv vc join project12.cd dc
 on vc.location=dc.location and vc.date=dc.date where dc.continent !='';