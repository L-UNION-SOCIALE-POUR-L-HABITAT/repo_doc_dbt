/**
 *
 * Description :    Alimentation de la table intermediate int_arrondissement
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Sources:         stg_insee_arrondissement
 * Cible :          int_arrondissement 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_arrondissement as 
(
    select
         arrondissement_annee,
         arrondissement_code,
         arrondissement_libelle,
         commune_code

    from 
         "wh_dp_silver"."stg"."stg_insee_arrondissement"
),

-- Ajout des colonnes calculées
 cte_calc_stg_insee_arrondissement as 
 (
    select
        *
        , 
    case
        when t1.arrondissement_annee = (
            select max(t2.arrondissement_annee)
            from cte_stg_insee_arrondissement t2
            where t2.arrondissement_code = t1.arrondissement_code
        ) then 1
        else 0
    end
 as arrondissement_annee_last_flag

    from
        cte_stg_insee_arrondissement t1   
 ),

-- Ajout des clés techniques
cte_hk_calc_insee_arrondissement as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', arrondissement_annee, arrondissement_code) 
    
)  
 
   as arrondissement_hk
        , 
    
        concat_ws('||', arrondissement_annee, arrondissement_code) 
    
   as arrondissement_bk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', arrondissement_annee, commune_code) 
    
)  
 
   as commune_hk

    from 
        cte_calc_stg_insee_arrondissement
),

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_insee_arrondissement
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale