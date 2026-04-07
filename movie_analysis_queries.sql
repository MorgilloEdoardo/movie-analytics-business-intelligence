# Obiettivo: Analizzare il numero totale dei film

## La query conteggia il numero del film che si trovano nella tabella movies_clean
SELECT
    COUNT(*) Total_Movies
FROM
    movies_clean;
    
# Obiettivo: Analizzare il numero totale dei film per anno

## La query conteggia il numero dei filp raggruppati per anno
SELECT
	YEAR(release_date) Anno,
	COUNT(*) Total_Movies
FROM 
    movies_clean
GROUP BY 
    Anno
ORDER BY
    Anno;
       
# Obiettivo: Analizzare i top 10 film per revenue

## La query raggruppa i top 10 film per revenue
SELECT 
    title,
    revenue
FROM 
    movies_clean
WHERE
	revenue is not null
ORDER BY 
	revenue DESC
LIMIT 10;

# Obiettivo: Analizzare i top 10 film per profit

## La query raggruppa i top 10 film per profit che la calcolo con revenue- budget

SELECT
    title,
    revenue-budget profit
FROM 
    movies_clean   
WHERE
   revenue-budget is not null
ORDER BY
    profit DESC
LIMIT 10;

# Obiettivo: Vedere il ROI medio dei film

## ## La query calcola il ROI medio dei film utilizzando revenue e budget
SELECT
    AVG(((revenue - budget) / budget) * 100) AS avg_roi
FROM
    movies_clean
WHERE
    budget IS NOT NULL
    AND revenue IS NOT NULL
    AND budget > 0;

# Obiettivo: Analizzare i film con percentuale profittevoli

## La query conteggia i numeri in profit per poi fare la percentuale
SELECT 
    AVG(revenue > budget) * 100  percentuale_film_profittevoli
FROM movies_clean;

# Obiettivo: Analizzare i numeri di film per genere

## La query conteggia i numeri di film raggruppati per genere
SELECT 
    g.genre_name Genre,
    Count(*) Movies_total
FROM 
    genre_film_clean g
GROUP BY
    g.genre_name
ORDER BY
    Movies_total DESC;

# Obiettivo: Analizzare il revenue medio per genere

## La query calcola la media del revenue per genere utilizzando una join tra le tabelle genre_film_clean e movies_clean
SELECT
   g.genre_name Genre,
   AVG(m.revenue) avg_revenue
FROM 
   movies_clean m
JOIN
   genre_film_clean g ON m.id = g.movie_id
GROUP BY 
   genre
HAVING 
   avg_revenue != 0
ORDER BY
   avg_revenue DESC;
   
# Obiettivo: Analizzare il voto medio per genere

## La query calcola la la media del voto per genere utilizzando una join tra le tabelle genre_film_clean e movies_clean
SELECT
   g.genre_name Genre,
   AVG(m.vote_average) avg_vote
FROM 
   movies_clean m
JOIN
   genre_film_clean g ON m.id = g.movie_id
GROUP BY 
   genre
ORDER BY
   avg_vote DESC;
   
# Obiettivo: Analizzare gli attori con più film

## la query conteggia quanti film ha ogni attore
SELECT
   name,
   count(*) Movies_total
FROM 
   cast_clean 
GROUP BY
   name
ORDER BY
   Movies_total DESC;
   
# Obiettivo: Analizzare i registi con più film

## La query conteggia per ogni registi quanti film ha, con un where filtriamo per director
SELECT
   name,
   count(*) Movies_total
FROM 
   crew_clean
WHERE
   job = "director"
GROUP BY
   name
ORDER BY
   Movies_total DESC;
   
# Obiettivo: Analizzare i ranking dei film per revenue per ogni anno

## Classifica i film per revenue all’interno di ogni anno
## Utilizzando una window function per confrontarli tra loro nello stesso anno
SELECT
    title,
    YEAR(release_date) AS year,
    revenue,
    RANK() OVER (
        PARTITION BY YEAR(release_date)
        ORDER BY revenue DESC
    ) AS rank_per_year
FROM
    movies_clean
WHERE
    revenue IS NOT NULL;
   
# Obiettivo: Analizzare i film con budget superiori alla media

##  La query analizza la media per film e abbiamo bisogno di calcolare la media generale con una subquery
SELECT 
    title,
    budget
FROM movies_clean
WHERE budget > (
    SELECT AVG(budget)
    FROM movies_clean
)
ORDER BY budget DESC;

#Obiettivo: Analizzare i film appartenenti a generi che hanno più di 50 film

## la subquery analizza i generi con film maggiori di 50 e la query successivamente mostra sia titoli che generi 
SELECT
   m.title,
   g.genre_name
FROM 
   movies_clean m
JOIN
   genre_film_clean g ON m.id = g.movie_id
WHERE g.genre_name IN ( 
                   SELECT
                        gf.genre_name
                   FROM
                       genre_film_clean gf
                   GROUP BY 
                       gf.genre_name
					HAVING COUNT(*) > 50
                    )
LIMIT 50;                    



   


