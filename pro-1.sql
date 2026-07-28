select *
from world_layoffs.layoffs;

create table layoffs_stage
like layoffs;

insert layoffs_stage
select *
from world_layoffs.layoffs;

select *
from world_layoffs.layoffs_stage;



with doublicate_remove as 
( 
select * 
, row_number()
 over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
 from layoffs_stage

)
select *
from doublicate_remove
where row_num  > 1;

select *
from world_layoffs.layoffs_stage2;

insert into layoffs_stage2
select * 
, row_number()
 over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
 from layoffs_stage
 ;
 select *
 from layoffs_stage2
 where `row_number` > 1
;

 delete
 from layoffs_stage2
 where `row_number` > 1
;

update layoffs_stage2
set company=trim(company);


update layoffs_stage2
set industry ='Crypto'
where industry like 'Crypto%';

update layoffs_stage2
set country='United States'
where country like 'United States%';

 select distinct country
 from layoffs_stage2
 order by 1;
 
 select `date` 
 from layoffs_stage2;
 
update  layoffs_stage2
set `date` = str_to_date(`date`,'%m / %d / %Y ' );

alter table layoffs_stage2
modify column `date` date;

 
update  layoffs_stage2
set industry = null 
where industry = '' ;

 select distinct company , location ,industry
 from layoffs_stage2
 order by company ;
 
select *
from layoffs_stage2 t1
join layoffs_stage2 t2
  on t1.company = t2.company
where t1.industry is null
and t2.industry is not null;
 
update layoffs_stage2 t1
join layoffs_stage2 t2
  on t1.company = t2.company
set t1.industry = t2.industry 
where t1.industry is null
and t2.industry is not null;

delete
from layoffs_stage2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_stage2
where total_laid_off is null
and percentage_laid_off is null;


alter table layoffs_stage2
drop column `row_number` ;
