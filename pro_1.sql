select *
from world_layoffs.layoffs;

create table layoffs_stage
like layoffs;

select *
from world_layoffs.layoffs_stage;

insert layoffs_stage
select *
from world_layoffs.layoffs;