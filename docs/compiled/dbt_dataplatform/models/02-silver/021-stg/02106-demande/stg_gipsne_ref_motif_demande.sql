


















with cte_rename as (
    select
    
    
        CLE_MOTIF_DEMANDE as demande_motif_cle,
    

    
    
        CODE_MOTIF_DEMANDE as demande_motif_code,
    

 
    [ORDRE] as demande_motif_ordre_affichage,
    [LIBL_MOTIF_DEMANDE] as demande_motif_libelle_long,
    [LIBC_MOTIF_DEMANDE] as demande_motif_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_motif_demande"
),

cte_cast as (
select
    demande_motif_cle,
    demande_motif_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when demande_motif_ordre_affichage is null 
          or demande_motif_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demande_motif_ordre_affichage as integer) is not null 
        then cast(demande_motif_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demande_motif_ordre_affichage as float) is not null 
        then cast(cast(demande_motif_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as demande_motif_ordre_affichage,
    demande_motif_libelle_long,
    demande_motif_libelle_court
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

