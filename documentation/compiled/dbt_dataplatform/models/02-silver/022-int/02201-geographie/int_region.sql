/**
 *
 * Description :    Alimentation de la table intermediate int_region
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          stg_insee_lib_zone_supra_communale
                    map_departments_regions
 * Cible :          int_region
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_lib_zone_supra_communale as 
(
    select 
       geographie_code          as region_code,
       geographie_libelle       as region_libelle,
       geographie_annee         as region_annee,
       geographie_niveau        as region_niveau 


    from 
        "wh_dp_silver"."stg"."stg_insee_lib_zone_supra_communale"
),

 cte_map_ancienne_region as 
 (
    select 
        distinct 
            region_code_old     as region_code,
            region_libelle_old  as region_libelle
    from   
        "wh_dp_bronze"."seed"."map_departement_region"
 ),

-- Ajout des filters

--cte_fil_stg_insee_lib_zone_supra_communale
 cte_region_actuelle as 
(
    select 
       region_code,
       region_libelle,
       region_annee

    from 
      cte_stg_insee_lib_zone_supra_communale

    where region_niveau = 'REG'
),

-- Filtrer les anciennes régions (celles qui n'existent pas déjà dans la table actuelle)
--cte_filtre_old_regions
cte_region_ancienne as (

    select
        old.region_code,
        old.region_libelle,
        2015 as region_annee

    from 
        cte_map_ancienne_region old

    where not exists (
        select 1 

        from cte_region_actuelle existing

        where existing.region_code = old.region_code
       -- and existing.region_libelle = old.region_libelle
    )
),

-- Union des regions
--cte_filtre_stg_insee_lib_zone_supra_communale_final
cte_all_regions as (
    select 
        region_code,
        region_libelle,
        region_annee
    from 
        cte_region_actuelle

    union all

    select 
        region_code,
        region_libelle,
        region_annee
    from 
        cte_region_ancienne
),


-- Ajout des colonnes calculées

 cte_calc_stg_insee_lib_zone_supra_communale  as 
 (
    select
            *
            , 
    case
        when t1.region_annee = (
            select max(t2.region_annee)
            from cte_all_regions t2
            where t2.region_code = t1.region_code
        ) then 1
        else 0
    end
 as region_annee_last_flag
            , case when  region_code in ('01', '02', '03', '04', '06') then cast (1 as bit) else cast (0 as bit) end as region_outre_mer_flag 
            , case when  region_code in ('01', '02', '03', '04', '06') then 'Régions d''Outre-mer' else 'France métropolitaine' end as region_outre_mer_flag_libelle 
            , case when  region_code = '11' then cast (1 as bit) else cast (0 as bit) end  as region_idf_flag
                 
    from 
      cte_all_regions  t1
   
 ),


-- Ajout des clés techniques
cte_hk_calc_stg_insee_lib_zone_supra_communale as
(
    select 
        *
       , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||',  region_annee, region_code) 
    
)  
 
 as region_hk
       , 
    
        concat_ws('||',  region_annee, region_code) 
    
 as region_bk

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
        cte_hk_calc_stg_insee_lib_zone_supra_communale
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale