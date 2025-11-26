/**
 *
 * Description :    Alimentation de la table intermediate int_passage_commune_histo
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          stg_insee_passage_commune
 * Cible :          int_passage_commune_histo
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
 -- Sélection des colonnes 
  cte_stg_insee_passage_commune as 
 (
    select 
        passage_commune_annee,
        commune_initiale_code,
        commune_finale_code
  
    from 
        "wh_dp_silver"."stg"."stg_insee_passage_commune"
 ),

  /*  cte_filter_stg_insee_passage_commune as 
 (
    select 
        passage_commune_annee,
        commune_initiale_code,
        commune_finale_code
  
    from 
       cte_stg_insee_passage_commune
    where passage_commune_annee =
        (
            select max (passage_commune_annee)
            from cte_stg_insee_passage_commune
        )
 ),*/

-- Ajout des colonnes calculées
 cte_calc_stg_insee_passage_commune  as 
 (
    select
        cte_stg_insee_passage_commune.*
        , 
    case
        when (passage_commune_annee) = (
            select max((passage_commune_annee))
            from cte_stg_insee_passage_commune
        ) then 1
        else 0
    end
 as passage_commune_annee_last_flag


    from 
        cte_stg_insee_passage_commune
 ),

-- Ajout des clés techniques
cte_hk_calc_insee_passage_commune as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', passage_commune_annee, commune_initiale_code) 
    
)  
 
 as commune_initiale_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', passage_commune_annee, commune_finale_code) 
    
)  
 
 as commune_finale_hk

    from 
        cte_calc_stg_insee_passage_commune
),

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_insee_passage_commune
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale