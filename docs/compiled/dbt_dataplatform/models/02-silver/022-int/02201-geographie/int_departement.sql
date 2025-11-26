/**
 *
 * Description :    Alimentation de la table intermediate int_departement
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Sources:         stg_insee_appartenance_geo_commune, stg_insee_lib_zone_supra_communale
 * Cible :          int_ept 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_lib_zone_supra_communale as
(
    select
        geographie_annee         as departement_annee,
        geographie_code          as departement_code,
        geographie_libelle       as departement_libelle

    from
        "wh_dp_silver"."stg"."stg_insee_lib_zone_supra_communale"

    where  geographie_niveau = 'DEP'
),

cte_stg_insee_appartenance_geo_commune as 
(
    select distinct
         commune_annee,
         departement_code,
         region_code

    from 
         "wh_dp_silver"."stg"."stg_insee_appartenance_geo_commune"
),

 cte_map_departement_region as 
 (
    select 
        departement_code,
        region_code_old
       -- region_code_new as region_code
    from   
        "wh_dp_bronze"."seed"."map_departement_region"
 ),

-- Ajout des colonnes calculées
 cte_calc_stg_insee_lib_zone_supra_communale as 
 (
    select
        t1.departement_annee                          as departement_annee,
        t1.departement_code                           as departement_code,
        t1.departement_libelle                        as departement_libelle,
        
    case
        when t1.departement_annee = (
            select max(t2.departement_annee)
            from cte_stg_insee_lib_zone_supra_communale t2
            where t2.departement_code = t1.departement_code
        ) then 1
        else 0
    end
 as departement_annee_last_flag,
        cte_stg_insee_appartenance_geo_commune.region_code                                as region_code,
        cte_map_departement_region.region_code_old                                       as region_av15_code

    from
        cte_stg_insee_lib_zone_supra_communale t1
    
    left join
        cte_stg_insee_appartenance_geo_commune
    on
        cte_stg_insee_appartenance_geo_commune.departement_code = t1.departement_code
    and
        cte_stg_insee_appartenance_geo_commune.commune_annee = t1.departement_annee

    left join 
        cte_map_departement_region
    on 
        cte_stg_insee_appartenance_geo_commune.departement_code = cte_map_departement_region.departement_code
  --  and
  --      cte_stg_insee_appartenance_geo_commune.region_code = cte_map_departments_regions.region_code

 ),

-- Ajout des clés techniques
cte_hk_calc_insee_lib_zone_supra_communale as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', departement_annee, departement_code) 
    
)  
 
 as departement_hk
        , 
    
        concat_ws('||', departement_annee, departement_code) 
    
 as departement_bk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', departement_annee, region_code) 
    
)  
 
      as region_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', departement_annee, region_av15_code) 
    
)  
 
      as region_av15_hk
    from 
        cte_calc_stg_insee_lib_zone_supra_communale
),

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_insee_lib_zone_supra_communale
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale