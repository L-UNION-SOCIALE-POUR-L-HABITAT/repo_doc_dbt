




















with cte_rename as (
    select
    
    
        CLE_ZONAGE_PLAF as zone_plafond_ressource_cle,
    

    
    
        CODE_ZONAGE_PLAF as zone_plafond_ressource_code,
    

 
    [ORDRE] as zone_plafond_ressource_ordre_affichage,
    [LIBL_ZONAGE_PLAF] as zone_plafond_ressource_libelle_long,
    [LIBC_ZONAGE_PLAF] as zone_plafond_ressource_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_zonage_plaf"
),

cte_cast as (
select
    zone_plafond_ressource_cle,
    zone_plafond_ressource_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when zone_plafond_ressource_ordre_affichage is null 
          or zone_plafond_ressource_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(zone_plafond_ressource_ordre_affichage as integer) is not null 
        then cast(zone_plafond_ressource_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(zone_plafond_ressource_ordre_affichage as float) is not null 
        then cast(cast(zone_plafond_ressource_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as zone_plafond_ressource_ordre_affichage,
    zone_plafond_ressource_libelle_long,
    zone_plafond_ressource_libelle_court
from cte_rename
),

cte_finale as (
select
    *,
    
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
from cte_cast
)

select * from cte_finale

