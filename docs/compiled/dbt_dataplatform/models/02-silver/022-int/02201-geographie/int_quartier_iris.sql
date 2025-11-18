/**
 *
 * Description :    Alimentation de la table intermediate int_quartier_iris
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Source:          stg_insee_appartenance_geo_iris
 * Cible :          int_quartier_iris
 * Un quartier IRIS ne peut appartenir qu'à une seule commune, contrairement au QPV
 * Un quartier IRIS ne peut appartenir qu'à un seul arrondissement 
 * Le champ geographie_code est soit un arrondissement, soit une commune
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_appartenance_geo_iris as 
(
    select 
        quartier_iris_annee,
        quartier_iris_code ,
        quartier_iris_libelle,
        geographie_code
        
    from 
        "wh_dp_silver"."stg"."stg_insee_appartenance_geo_iris"
),

cte_int_arrondissement as 
(
    select 
        arrondissement_annee,
        arrondissement_code,
        commune_code
    from 
        "wh_dp_silver"."int"."int_arrondissement"
),

-- Filtres
-- Exclusion des géographies hors scope
cte_filter_stg_insee_appartenance_geo_iris as 
(
    select 
        *
        
    from 
        cte_stg_insee_appartenance_geo_iris

    where not (geographie_code like '98%' or geographie_code like '975%' or geographie_code like '977%' or geographie_code like '978%')
),

-- Ajout des colonnes calculées
cte_calc_stg_insee_appartenance_geo_iris  as 
 (
    select
        quartier_iris_annee,
        quartier_iris_code,
        quartier_iris_libelle,
        isnull(int_arrondissement.commune_code, t1.geographie_code)                                 
            as commune_code,
        isnull(int_arrondissement.arrondissement_code,'N/A')                                                                              
            as arrondissement_code,
        
    case
        when t1.quartier_iris_annee = (
            select max(t2.quartier_iris_annee)
            from cte_stg_insee_appartenance_geo_iris t2
            where t2.quartier_iris_code = t1.quartier_iris_code
        ) then 1
        else 0
    end
 as quartier_iris_annee_last_flag
    from 
        cte_filter_stg_insee_appartenance_geo_iris t1
    -- geographie_code peut etre soit une commune soit un arrondissement
    left join cte_int_arrondissement int_arrondissement
        on  t1.geographie_code = int_arrondissement.arrondissement_code
        and t1.quartier_iris_annee = int_arrondissement.arrondissement_annee
            
    
 ),


-- Ajout des clés techniques
cte_hk_calc_stg_insee_appartenance_geo_iris as
(
    select 
        *
        , 
    
        concat_ws('||', quartier_iris_annee, quartier_iris_code) 
    
 as quartier_iris_bk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', quartier_iris_annee, quartier_iris_code) 
    
)  
 
 as quartier_iris_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', quartier_iris_annee, commune_code) 
    
)  
 
 as commune_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', quartier_iris_annee, arrondissement_code) 
    
)  
 
 as arrondissement_hk
    from 
        cte_calc_stg_insee_appartenance_geo_iris
),
 
-- Ajout des métadonnées
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_insee_appartenance_geo_iris
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale