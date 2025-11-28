/**
 *
 * Description :    Alimentation de la table intermediate int_radiation
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_radiation    
                           
 * Cible :          int_radiation
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_radiation as 
(
    select 
         

    from "wh_dp_silver"."stg"."stg_gipsne_radiation"
),
 

-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
cte_calc_stg_gipsne_radiation as
(
    select 
         *

    from 
        cte_stg_gipsne_radiation stg
     
    
),

--ajout des clés techniques
cte_hk_calc_stg_gipsne_radiation as
(
    select 
        *
    from 
        cte_calc_stg_gipsne_radiation
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_gipsne_radiation
 )

 
select 
    *
from 
    cte_finale