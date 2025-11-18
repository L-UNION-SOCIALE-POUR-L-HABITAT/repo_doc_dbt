/**
 *
 * Description :    Alimentation de la table intermediate int_ept
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Sources:         stg_insee_appartenance_geo_commune, stg_insee_lib_zone_supra_communale
 * Cible :          int_ept 
 * Historique des modifications:
        - SLR 06/08/2025 : suppression de l epci (car provoque des problemes de logique fonctionnelle)
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_lib_zone_supra_communale as
(
    select
        geographie_annee         as ept_annee,
        geographie_code          as ept_code,
        geographie_libelle       as ept_libelle

    from
        "wh_dp_silver"."stg"."stg_insee_lib_zone_supra_communale"

    where
        geographie_niveau = 'EPT'
       -- and
        -- permet d'eviter d'avoir des doublons
       -- geographie_code not like '%ZZZZ%'

),

cte_stg_insee_appartenance_geo_commune as 
(
    select distinct
         commune_annee,
        -- epci_code,
         ept_code

    from 
         "wh_dp_silver"."stg"."stg_insee_appartenance_geo_commune"
),

-- Ajout des colonnes calculées
 cte_calc_stg_insee_lib_zone_supra_communale as 
 (
    select
        t1.ept_annee                          as ept_annee,
       -- cte_stg_insee_appartenance_geo_commune.epci_code                          as epci_code,
        t1.ept_code                           as ept_code,
        t1.ept_libelle                        as ept_libelle,
        
    case
        when t1.ept_annee = (
            select max(t2.ept_annee)
            from cte_stg_insee_lib_zone_supra_communale t2
            where t2.ept_code = t1.ept_code
        ) then 1
        else 0
    end
 as ept_annee_last_flag

    from
        cte_stg_insee_lib_zone_supra_communale t1
    
    left join
        cte_stg_insee_appartenance_geo_commune
    on
        cte_stg_insee_appartenance_geo_commune.ept_code = t1.ept_code
    and
        cte_stg_insee_appartenance_geo_commune.commune_annee = t1.ept_annee
 ),

-- Ajout des clés techniques
cte_hk_calc_insee_lib_zone_supra_communale as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', ept_annee, ept_code) 
    
)  
 
 as ept_hk
        , 
    
        concat_ws('||', ept_annee, ept_code) 
    
 as ept_bk
        
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