


















with cte_rename as (
    select
    
    
        CLE_STATUT_PROFESSIONNEL as statut_professionnel_cle,
    

    
    
        CODE_STATUT_PROFESSIONNEL as statut_professionnel_code,
    

 
    [ORDRE] as statut_professionnel_ordre_affichage,
    [LIBL_STATUT_PROFESSIONNEL] as statut_professionnel_libelle_long,
    [LIBC_STATUT_PROFESSIONNEL] as statut_professionnel_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_statut_professionnel"
),

cte_cast as (
select
    statut_professionnel_cle,
    statut_professionnel_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when statut_professionnel_ordre_affichage is null 
          or statut_professionnel_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(statut_professionnel_ordre_affichage as integer) is not null 
        then cast(statut_professionnel_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(statut_professionnel_ordre_affichage as float) is not null 
        then cast(cast(statut_professionnel_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as statut_professionnel_ordre_affichage,
    statut_professionnel_libelle_long,
    statut_professionnel_libelle_court
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

