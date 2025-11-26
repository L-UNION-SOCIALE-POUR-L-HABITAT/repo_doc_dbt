




















with cte_rename as (
    select
    
    
        CLE_MODE_LOGEMENT as mode_logement_cle,
    

    
    
        CODE_MODE_LOGEMENT as mode_logement_code,
    

 
    [ORDRE] as mode_logement_ordre_affichage,
    [LIBL_MODE_LOGEMENT] as mode_logement_libelle_long,
    [LIBC_MODE_LOGEMENT] as mode_logement_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_mode_logement"
),

cte_cast as (
select
    mode_logement_cle,
    mode_logement_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when mode_logement_ordre_affichage is null 
          or mode_logement_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(mode_logement_ordre_affichage as integer) is not null 
        then cast(mode_logement_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(mode_logement_ordre_affichage as float) is not null 
        then cast(cast(mode_logement_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as mode_logement_ordre_affichage,
    mode_logement_libelle_long,
    mode_logement_libelle_court
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

