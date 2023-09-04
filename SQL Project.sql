
select * from Project..Data1;
select * from Project..Data2;

-- Number of Rows into our Dataset

select count(*) from project..Data1;

select count(*) from project..Data2;

--Here we have find the dataset from two different distic
select * from project..Data1 where Districts in ('Patna', 'Rohtas');

-- Lets find the populations of Bihar..

select Population  from  project..Data1;

select sum(Population) as Total_population_of_bihar from project..Data1;

-- Lets find the average Growth of Bihar

select avg(Growth)*100 as avg_growth_of_Bihar from project..Data2;

-- Lets find the average growth of every distic

select districts, avg(Growth)*100 avg_growth_of_districts from project..Data2 group by districts;

-- Lets find the Avg sex_Ration in assending and desseniding order...

select districts, Round(avg(Sex_Ratio),0) avg_sex_ratio_of_distic from project..Data2 group by districts order by avg_sex_ratio_of_distic asc ;

select districts, Round(avg(Sex_Ratio),0) avg_sex_ratio_of_distic from project..Data2 group by districts order by avg_sex_ratio_of_distic desc ;

-- Lets find the average literacy rate of distic in assending and dissending order..


select districts, Round(avg(Literacy),0) avg_Literacy_ratio_of_distic from project..Data2 group by districts order by avg_Literacy_ratio_of_distic asc ;

select districts, Round(avg(Literacy),0) avg_Literacy_ratio_of_distic from project..Data2 group by districts order by avg_Literacy_ratio_of_distic desc ;

select districts, avg(Literacy) avg_Literacy_ratio_of_distic from project..Data2 group by districts
having avg(Literacy)<800 order by avg_Literacy_ratio_of_distic desc ;

select districts, avg(Literacy) avg_Literacy_ratio_of_distic from project..Data2 group by districts
having avg(Literacy)>800 order by avg_Literacy_ratio_of_distic desc ;

--- Lets find top 5 district showing highest growth ration..


select top 5 districts, avg(Growth)*100 avg_growth_of_districts from project..Data2 group by districts order by avg_growth_of_districts desc;

-- Bottom 5 District showing lowest  Sex_Ratio..

select top 5 districts, Round(avg(Sex_Ratio),0) avg_sex_ratio_of_distic from project..Data2 group by districts order by avg_sex_ratio_of_distic asc ;

-- Top 5 District showing highest Sex_Ratio..

select top 5 districts, Round(avg(Sex_Ratio),0) avg_sex_ratio_of_distic from project..Data2 group by districts order by avg_sex_ratio_of_distic desc ;

-- Lets find top and bottom 5 district in literacy district..

drop table if exists.#top5districts;
create table #top5districts(
districts nvarchar(255),
topdistricts float
)
insert into #top5districts
select top 5 districts, Round(avg(Literacy),0) avg_Literacy_ratio_of_distic from project..Data2 group by districts order by avg_Literacy_ratio_of_distic asc ;

select * from #top5districts;


drop table if exists.#bottom5districts;
create table #bottom5districts(
districts nvarchar(255),
bottomdistricts float
)
insert into #bottom5districts
select top 5 districts, Round(avg(Literacy),0) avg_Literacy_ratio_of_distic from project..Data2 group by districts order by avg_Literacy_ratio_of_distic desc;
select * from #top5districts

--select * from (
--select top 5 * from #top5districts order by #top5districts.#top5districts desc) a

--union

--select * from (
--select top 5 * from #bottom5districts order by #bottom5districts.#bottom5districts asc) b;

-- Districts which is staring from letter 'a'..
select distinct * from project..Data2 where lower(districts) like'a%';

-- Districts which is ending with  letter 'a'..

select distinct * from project..Data2 where lower(districts) like'%a' ;

select distinct * from project..Data2 where lower(districts) like'%a' or lower(districts) like 'b%';

select distinct * from project..Data2 where lower(districts) like'a%' and lower(districts) like '%d';

-- joining both the table 
select a.districts,a.state, a.Sex_Ratio/1000 as Sex_Ratio, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts
select * from project..Data1;
select * from project..Data2;


-- lets find the total number of population for males and females from bihar.....

select d.state, sum(d.males) total_males ,sum(d.females) total_females from
(select c.districts, c.state, round(c.population/(c.Sex_Ratio+1),0) males, round((c.population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) females from 
(select a.districts,a.state, a.Sex_Ratio/1000 as Sex_Ratio, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) c)d group by d.state;

-- lets find the total number of population for males and females from districts.....

select d.districts, sum(d.males) total_males ,sum(d.females) total_females from
(select c.districts, c.state, round(c.population/(c.Sex_Ratio+1),0) males, round((c.population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) females from 
(select a.districts,a.state, a.Sex_Ratio/1000 as Sex_Ratio, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) c)d group by d.districts;


--- find total literacy rate in Bihar......
select c.state,sum(Literacy_people) Total_Literacy_people,sum(ILiteracy_people) Total_ILiteracy_people from
(select d.districts,d.state, round(d.Literacy_Ratio*population,0) Literacy_people, round((1-d.Literacy_Ratio)*d.population,0) ILiteracy_people from
(select a.districts,a.state, a.Literacy/1000 as Literacy_Ratio, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) d)c 
group by c.state;

--find total literacy rate from districts........
select c.districts,sum(Literacy_people) Total_Literacy_people,sum(ILiteracy_people) Total_ILiteracy_people from
(select d.districts,d.state, round(d.Literacy_Ratio*population,0) Literacy_people, round((1-d.Literacy_Ratio)*d.population,0) ILiteracy_people from
(select a.districts,a.state, a.Literacy/1000 as Literacy_Ratio, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) d)c 
group by c.districts;

---- Growth of population from districts......

select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.districts,d.state, round(d.population/(1-d.Growth),0) previous_census_population, d.population current_census_population  from
(select a.districts,a.state, a.Growth as growth, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) d) e
group by e.state;

select e.districts,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.districts,d.state, round(d.population/(1-d.Growth),0) previous_census_population, d.population current_census_population  from
(select a.districts,a.state, a.Growth as growth, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) d) e
group by e.districts;


select '1' as keyy, n.* from 
(select sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from
(select e.districts,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.districts,d.state, round(d.population/(1-d.Growth),0) previous_census_population, d.population current_census_population  from
(select a.districts,a.state, a.Growth as growth, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) d) e
group by e.districts) m)n;

---- population vs density...

select '1' as keyy, z.* from 
(select sum(Density) total_density from project..Data1)z;

--lets join total density and previous_census_population or current_census_population..


select g.total_density/g.previous_census_population as previous_census_population_vs_density, g.total_density/g.current_census_population as current_census_population_vs_density from
(select q.*,r.total_density from(
select '1' as keyy, n.* from 
(select sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from
(select e.districts,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.districts,d.state, round(d.population/(1-d.Growth),0) previous_census_population, d.population current_census_population  from
(select a.districts,a.state, a.Growth as growth, b.population  from project..Data1 b inner join project..Data2 a on a.districts= b.districts) d) e
group by e.districts) m)n) q inner join(


select '1' as keyy, z.* from 
(select sum(Density) total_density from project..Data1)z) r on q.keyy=r.keyy)g;


--output the top 3 districts from each state with highest literacy rate...


select districts,state,Literacy,rank() over(partition by state order by  Literacy desc) rnk from project..Data2

select a.* from
(select districts,state,Literacy,rank() over(partition by state order by  Literacy desc) rnk from project..Data2)a
where a.rnk in(1,2,3) order by districts;