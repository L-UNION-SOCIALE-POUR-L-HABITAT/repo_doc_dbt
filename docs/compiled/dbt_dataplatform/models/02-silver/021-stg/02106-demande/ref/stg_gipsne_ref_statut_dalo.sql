




















with cte_rename as (
    select
    
    
        CLE_STATUT_DALO as statut_dalo_cle,
    

    
    
        CODE_STATUT_DALO as statut_dalo_code,
    

 
    [ORDRE] as statut_dalo_ordre_affichage,
    [LIBL_STATUT_DALO] as statut_dalo_libelle_long,
    [LIBC_STATUT_DALO] as statut_dalo_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_statut_dalo"
),

cte_cast as (
select
    statut_dalo_cle,
    statut_dalo_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when statut_dalo_ordre_affichage is null 
          or statut_dalo_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(statut_dalo_ordre_affichage as integer) is not null 
        then cast(statut_dalo_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(statut_dalo_ordre_affichage as float) is not null 
        then cast(cast(statut_dalo_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as statut_dalo_ordre_affichage,
    statut_dalo_libelle_long,
    statut_dalo_libelle_court
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

