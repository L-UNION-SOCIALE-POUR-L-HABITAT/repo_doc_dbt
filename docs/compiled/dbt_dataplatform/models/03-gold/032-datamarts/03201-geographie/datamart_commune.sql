/**
 *
 * Description :    Alimentation de la table datamart_commune
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          silver - geographie
 * Cible :          datamart_commune

 * A utiliser uniquement pour exposition ou visualisation des données
 * Ne pas utiliser en tant que source pour alimenter une table/vue
 */




-- Selection des tables et des colonnes
with 

cte_commune as
(
    select 
        commune_hk,
        commune_annee,
        commune_annee_last_flag,
        commune_code,
        commune_libelle,    
        commune_pays_libelle,
        departement_hk,      
        epci_hk,      
        ept_hk,    
        zone_123_hk,   
        zone_abc_hk,
        logements_prives_nombre
    from   
        "wh_dp_silver"."dbo"."commune"
),

cte_departement as
(
    select 
        departement_code,
        departement_libelle,
        departement_hk,
        region_hk,
        region_av15_hk
    from   
        "wh_dp_silver"."dbo"."departement"
),

cte_region as
(
    select 
        region_code,
        region_libelle,
        region_hk,
        region_idf_flag,
        region_outre_mer_flag,
        region_outre_mer_flag_libelle
    from 
         "wh_dp_silver"."dbo"."region"
),

cte_epci as
(
    select
 
        epci_code,
        epci_libelle,
        epci_nature_code,
        epci_hk
    from 
         "wh_dp_silver"."dbo"."epci"
),

cte_ept as
(
    select
        ept_code,
        ept_libelle,
        ept_hk
    from 
        "wh_dp_silver"."dbo"."ept"

),

cte_zone_123 as
(
    select
        zone_123_code,
        zone_123_libelle,
        zone_123_hk
    from 
        "wh_dp_silver"."dbo"."zone_123"
),

cte_zone_abc as 
(
    select 
        zone_abc_code,
        zone_abc_libelle,
        zone_abc_hk
    from 
        "wh_dp_silver"."dbo"."zone_abc"
),

-- Filtrage (dernière version de la géographie)
cte_commune_last_version as
(
    select 
        commune_hk,
        commune_annee,
        commune_code,
        commune_libelle,  
        commune_pays_libelle,  
        departement_hk,      
        epci_hk,      
        ept_hk,    
        zone_123_hk,   
        zone_abc_hk,
        logements_prives_nombre
    from 
        cte_commune
    where 
        commune_annee_last_flag = 1
),

-- jointure
cte_geographie_last_version as
(
    select
        commune.commune_hk,
        commune.commune_annee,
        commune.commune_code,
        commune.commune_libelle, 
        commune.commune_pays_libelle,   
        commune.logements_prives_nombre,
        departement.departement_code,
        departement.departement_libelle,
        region.region_code,
        region.region_libelle,
        region.region_idf_flag,
        region.region_outre_mer_flag,
        region_outre_mer_flag_libelle,                                  
        epci.epci_code,
        epci.epci_libelle,
        epci.epci_nature_code,
        ept.ept_code,
        ept.ept_libelle,
        zone_123.zone_123_code,
        zone_123.zone_123_libelle,
        zone_abc.zone_abc_code,
        zone_abc.zone_abc_libelle
        

    from 
        cte_commune_last_version commune
    inner join
        cte_departement departement on (commune.departement_hk = departement.departement_hk)
    inner join 
        cte_region region on (departement.region_hk = region.region_hk)
    left join 
        cte_epci epci on (commune.epci_hk = epci.epci_hk)
    left join
        cte_ept ept on (commune.ept_hk = ept.ept_hk)
    left join
        cte_zone_123 zone_123 on (commune.zone_123_hk = zone_123.zone_123_hk)
    left join  
        cte_zone_abc zone_abc on (commune.zone_abc_hk = zone_abc.zone_abc_hk)
),

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
 
cte_finale as
(
    select
        *
    from
        cte_geographie_last_version
)

select 
    *
from 
    cte_finale