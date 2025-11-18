/**
 *
 * Description :    Alimentation de la table int_calendrier
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source :         Années comprise entre 1900 et 2050
 * Cible :          int_calendrier
 */



with
-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_min_max_annee as (
    select 
        1900 as min_annee,
        2050 as max_annee
),

-------------------------------------------------------------------
--************ GENERATION DE TOUTES LES DATES *********************
-------------------------------------------------------------------
-- On utilise GENERATE_SERIES (alias SEQUENCE en Fabric SQL) 
-- pour générer toutes les dates entre 01-01-min et 31-12-max
cte_all_dates as (
    select
        dte = dateadd(day, value, cast(cast(min_annee as varchar) + '-01-01' as date))
    from cte_min_max_annee
    cross apply generate_series(
        0,
        datediff(
            day,
            cast(cast(min_annee as varchar) + '-01-01' as date),
            cast(cast(max_annee as varchar) + '-12-31' as date)
        ),
        1
    )
)

-------------------------------------------------------------------
--*********************** TABLE EN SORTIE *************************
-------------------------------------------------------------------
select
    dte                                             as date_iso,
    cast(FORMAT(dte, 'dd-MM-yyyy') as varchar(10))  as date_fr_char,
    year(dte)                                       as date_annee_int,
    cast(FORMAT(dte, 'yyyy') as varchar(4))         as date_annee_char,
    month(dte)                                      as date_mois_int,
    cast(FORMAT(dte, 'MM') as varchar(2))           as date_mois_char,
    day(dte)                                        as date_jour_int,
    cast(FORMAT(dte, 'dd') as varchar(2))           as date_jour_char
    
from cte_all_dates