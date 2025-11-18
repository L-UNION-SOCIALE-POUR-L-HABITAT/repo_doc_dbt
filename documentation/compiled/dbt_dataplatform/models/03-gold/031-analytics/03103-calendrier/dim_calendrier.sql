/**
 *
 * Description :    Alimentation de la table dim_calendrier
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source :         logement_rpls - on récupère le min et le max de rpls_annee pour générer les dates
 * Cible :          dim_calendrier
 */



with
-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_logement_rpls as (
    select logement_rpls_millesime
    from "wh_dp_silver"."dbo"."logement_rpls"
),

cte_min_max_annee as (
    select 
        min(logement_rpls_millesime) as min_annee,
        max(logement_rpls_millesime) as max_annee
    from cte_logement_rpls
),

cte_calendrier as (
    select  
        date_iso,
        date_annee_int
    from "wh_dp_silver"."dbo"."calendrier"

),
-------------------------------------------------------------------
--***************** LIMITATION DES DATES **************************
-------------------------------------------------------------------
-- on prend uniquement les dates qui correspondent aux millésimes RPLS intégrés 
cte_all_dates as (
    select
        calendrier.date_iso,
        calendrier.date_annee_int
    from 
        cte_calendrier calendrier
        inner join cte_min_max_annee min_max 
            on (calendrier.date_annee_int between min_max.min_annee and min_max.max_annee)

         
)

-------------------------------------------------------------------
--*********************** TABLE EN SORTIE *************************
-------------------------------------------------------------------
select
    date_iso        as date_jour,
    date_annee_int  as annee
from cte_all_dates