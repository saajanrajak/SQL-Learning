/*


Rank Variance Per Country
https://platform.stratascratch.com/coding/2007-rank-variance-per-country?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link

Difficulty: Hard

Which countries have risen in the rankings based on the number of comments between Dec 2019 vs Jan 2020? Hint: Avoid gaps between ranks when ranking countries.

Tables:
<fb_comments_count>
user_id                 int
created_at              datetime
number_of_comments      int

<fb_active_users>
user_id                 int
name                    varchar
status                  varchar
country                 varchar

*/

-- logic: rank countries in dec 2019 and jan 2020 seperately
-- join by country
-- compare former and latter rank
-- filter country where latter rank < former rank

-- assumption: earlier period might not have comments
-- hence we need to right join on latter summary
-- we need 1,2,3,4 no gaps in rank so dense_rank()


with
main_table as 
(
select a.*,
       b.country
       

from fb_comments_count a
left join fb_active_users b on a.user_id = b.user_id
where country is not NULL
),

dec_ranking as 
(
select country, 
       sum(number_of_comments) as dec_comment_sum
      
from main_table
where created_at >= '2019-12-01' and created_at < "2020-01-01"

group by country
),
dec_rank_02 as
(
select *,
      dense_rank() over(order by dec_comment_sum desc) as dec_rank
from dec_ranking      


),

jan_ranking as 
(
select country, 
      sum(number_of_comments) as jan_comment_sum
from main_table
where created_at >= '2020-01-01' and created_at < "2020-02-01"
group by country

) ,

jan_rank_02 as
(
select *,
      dense_rank() over(order by jan_comment_sum desc) as jan_rank
from jan_ranking      


)
select * 
from dec_rank_02 a
left join jan_rank_02 b
     on a.country = b.country
where jan_rank < dec_ran
